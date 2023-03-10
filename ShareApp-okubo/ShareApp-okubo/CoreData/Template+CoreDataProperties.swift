//
//  Template+CoreDataProperties.swift
//  ShareApp-okubo
//
//  Created by 大久保徹郎 on 2023/03/10.
//
//

import Foundation
import CoreData


extension Template {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Template> {
        return NSFetchRequest<Template>(entityName: "Template")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var body: String?
    @NSManaged public var createdDate: Date?

}

extension Template : Identifiable {

}
