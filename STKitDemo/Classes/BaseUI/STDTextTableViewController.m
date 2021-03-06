//
//  STDTextTableViewController.m
//  STKitDemo
//
//  Created by SunJiangting on 14-10-12.
//  Copyright (c) 2014年 SunJiangting. All rights reserved.
//

#import "STDTextTableViewController.h"


@implementation STDTableViewCellItem

- (instancetype) initWithTitle:(NSString *)title target:(id)target action:(SEL)action {
    self = [super init];
    if (self) {
        self.title = title;
        self.target = target;
        self.action = action;
    }
    return self;
}

@end

@implementation STDTableViewSectionItem

- (instancetype) initWithSectionTitle:(NSString *) title items:(NSArray *) items {
    self = [super init];
    if (self) {
        self.title = title;
        self.items = items;
    }
    return self;
}

@end


@interface STDTextTableViewController ()

@end

@implementation STDTextTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Identifier"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Table view data source
- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    STDTableViewSectionItem * sectionItem = [self.dataSource objectAtIndex:section];
    if ([sectionItem isKindOfClass:[STDTableViewSectionItem class]]) {
        return sectionItem.title;
    }
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    STDTableViewSectionItem * sectionItem = [self.dataSource objectAtIndex:section];
    if ([sectionItem isKindOfClass:[STDTableViewSectionItem class]]) {
        return sectionItem.items.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * tableViewCell = [tableView dequeueReusableCellWithIdentifier:@"Identifier"];
    STDTableViewSectionItem * sectionItem = [self.dataSource objectAtIndex:indexPath.section];
    STDTableViewCellItem * item = sectionItem.items[indexPath.row];
    if ([item isKindOfClass:[STDTableViewCellItem class]]) {
        tableViewCell.textLabel.text = item.title;
    } else {
        tableViewCell.textLabel.text = @"配置出现问题";
    }
    return tableViewCell;
}

- (void) tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    if (![view isKindOfClass:[UITableViewHeaderFooterView class]]) {
        return;
    }
    UILabel * textLabel = ((UITableViewHeaderFooterView * )view).textLabel;
    STDTableViewSectionItem * sectionItem = [self.dataSource objectAtIndex:section];
    if ([sectionItem isKindOfClass:[STDTableViewSectionItem class]]) {
        textLabel.text = sectionItem.title;
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    STDTableViewSectionItem * sectionItem = [self.dataSource objectAtIndex:indexPath.section];
    STDTableViewCellItem * item = sectionItem.items[indexPath.row];
    if ([item isKindOfClass:[STDTableViewCellItem class]] && [item.target respondsToSelector:item.action]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [item.target performSelector:item.action];
#pragma clang diagnostic pop
    }
}

@end
