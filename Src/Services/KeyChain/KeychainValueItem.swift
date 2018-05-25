/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 A struct for accessing generic value keychain items.
 */

import Foundation

struct KeychainValueItem {
  // MARK: Types
  
  enum KeychainError: Error {
    case noValue
    case unexpectedValueData
    case unexpectedItemData
    case unhandledError(status: OSStatus)
  }
  
  // MARK: Properties
  
  let service: String
  
  private(set) var identifier: String
  
  let accessGroup: String?
  
  // MARK: Intialization
  
  init(service: String, identifier: String, accessGroup: String? = nil) {
    self.service = service
    self.identifier = identifier
    self.accessGroup = accessGroup
  }
  
  // MARK: Keychain access
  
  func readValue() throws -> String  {
    /*
     Build a query to find the item that matches the service, identifier and
     access group.
     */
    var query = KeychainValueItem.keychainQuery(withService: service, identifier: identifier, accessGroup: accessGroup)
    query[kSecMatchLimit as String] = kSecMatchLimitOne
    query[kSecReturnAttributes as String] = kCFBooleanTrue
    query[kSecReturnData as String] = kCFBooleanTrue
    
    // Try to fetch the existing keychain item that matches the query.
    var queryResult: AnyObject?
    let status = withUnsafeMutablePointer(to: &queryResult) {
      SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
    }
    
    // Check the return status and throw an error if appropriate.
    guard status != errSecItemNotFound else { throw KeychainError.noValue }
    guard status == noErr else { throw KeychainError.unhandledError(status: status) }
    
    // Parse the Value string from the query result.
    guard let existingItem = queryResult as? [String : AnyObject],
      let valueData = existingItem[kSecValueData as String] as? Data,
      //            let value = String(data: valueData, encoding: String.Encoding.utf8)
      let value = NSKeyedUnarchiver.unarchiveObject(with: valueData) as? String
      else {
        throw KeychainError.unexpectedValueData
    }
    
    return value
  }
  
  func saveValue(_ value: String) throws {
    // Encode the value into an Data object.
    let encodedValue = NSKeyedArchiver.archivedData(withRootObject: value)
    
    do {
      // Check for an existing item in the keychain.
      try _ = readValue()
      
      // Update the existing item with the new value.
      var attributesToUpdate = [String : AnyObject]()
      attributesToUpdate[kSecValueData as String] = encodedValue as AnyObject?
      
      let query = KeychainValueItem.keychainQuery(withService: service, identifier: identifier, accessGroup: accessGroup)
      let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
      
      // Throw an error if an unexpected status was returned.
      guard status == noErr else { throw KeychainError.unhandledError(status: status) }
    }
    catch KeychainError.noValue {
      /*
       No value was found in the keychain. Create a dictionary to save
       as a new keychain item.
       */
      var newItem = KeychainValueItem.keychainQuery(withService: service, identifier: identifier, accessGroup: accessGroup)
      newItem[kSecValueData as String] = encodedValue as AnyObject?
      
      // Add a the new item to the keychain.
      let status = SecItemAdd(newItem as CFDictionary, nil)
      
      // Throw an error if an unexpected status was returned.
      guard status == noErr else { throw KeychainError.unhandledError(status: status) }
    }
  }
  
  func deleteItem() throws {
    // Delete the existing item from the keychain.
    let query = KeychainValueItem.keychainQuery(withService: service, identifier: identifier, accessGroup: accessGroup)
    let status = SecItemDelete(query as CFDictionary)
    
    // Throw an error if an unexpected status was returned.
    guard status == noErr || status == errSecItemNotFound else { throw KeychainError.unhandledError(status: status) }
  }
  
  static func valueItems(forService service: String, accessGroup: String? = nil) throws -> [KeychainValueItem] {
    // Build a query for all items that match the service and access group.
    var query = KeychainValueItem.keychainQuery(withService: service, accessGroup: accessGroup)
    query[kSecMatchLimit as String] = kSecMatchLimitAll
    query[kSecReturnAttributes as String] = kCFBooleanTrue
    query[kSecReturnData as String] = kCFBooleanFalse
    
    // Fetch matching items from the keychain.
    var queryResult: AnyObject?
    let status = withUnsafeMutablePointer(to: &queryResult) {
      SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
    }
    
    // If no items were found, return an empty array.
    guard status != errSecItemNotFound else { return [] }
    
    // Throw an error if an unexpected status was returned.
    guard status == noErr else { throw KeychainError.unhandledError(status: status) }
    
    // Cast the query result to an array of dictionaries.
    guard let resultData = queryResult as? [[String : AnyObject]] else { throw KeychainError.unexpectedItemData }
    
    // Create a `KeychainValueItem` for each dictionary in the query result.
    var valueItems = [KeychainValueItem]()
    for result in resultData {
      guard let identifier  = result[kSecAttrAccount as String] as? String else { throw KeychainError.unexpectedItemData }
      
      let valueItem = KeychainValueItem(service: service, identifier: identifier, accessGroup: accessGroup)
      valueItems.append(valueItem)
    }
    
    return valueItems
  }
  
  // MARK: Convenience
  
  private static func keychainQuery(withService service: String, identifier: String? = nil, accessGroup: String? = nil) -> [String : AnyObject] {
    var query = [String : AnyObject]()
    query[kSecClass as String] = kSecClassGenericPassword
    query[kSecAttrService as String] = service as AnyObject?
    
    if let identifier = identifier {
      query[kSecAttrAccount as String] = identifier as AnyObject?
    }
    
    if let accessGroup = accessGroup {
      query[kSecAttrAccessGroup as String] = accessGroup as AnyObject?
    }
    
    return query
  }
}
