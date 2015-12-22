//
//  ViewController.m
//  iOSSQLDemo
//
//  Created by yz on 15/12/22.
//  Copyright © 2015年 DeviceOne. All rights reserved.
//

#import "ViewController.h"
#import <sqlite3.h>
#import "FMDB.h"

@interface ViewController ()
{
    sqlite3 *db;
    FMDatabase *fmdb;
}


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *docDic = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *fileName = [docDic stringByAppendingPathComponent:@"demo.db"];
    //创建数据库
    int result = sqlite3_open_v2(fileName.UTF8String, &db, SQLITE_IOERR_READ|SQLITE_IOERR_WRITE|SQLITE_OPEN_CREATE, NULL);
    if (result == SQLITE_OK) {
        NSLog(@"open true");
    }
    
    //创建表
    const char *sqlCreate = "CREATE TABLE IF NOT EXISTS t_demo (id integer PRIMARY KEY AUTOINCREMENT,name text NOT NULL,age integer NOT NULL);";
    
    char *errmsg = NULL;
    result = sqlite3_exec(db, sqlCreate, NULL, NULL, &errmsg);
    if (result == SQLITE_OK) {
        NSLog(@"create true");
    }
    
    //执行sql语句
    
    //1.插入
    NSString *sqlInsert = [NSString stringWithFormat:@"INSERT INTO t_demo (name,age) VALUES('%@','%d');",@"one",19];
    sqlite3_exec(db, sqlInsert.UTF8String, NULL, NULL, &errmsg);
    sqlite3_exec(db, sqlInsert.UTF8String, NULL, NULL, &errmsg);
    sqlite3_exec(db, sqlInsert.UTF8String, NULL, NULL, &errmsg);
    if (errmsg) {
        NSLog(@"insert false");
    }
    
    // 2.查询
    NSString *sqlQuery = [NSString stringWithFormat:@"SELECT id,name,age FROM t_demo;"];
    sqlite3_stmt *stmt = NULL;
    //准备执行语句
    if (sqlite3_prepare_v2(db, sqlQuery.UTF8String, -1, &stmt, NULL) == SQLITE_OK) {
        //分步执行
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            int ID = sqlite3_column_int(stmt, 0);
            const unsigned char *name  = sqlite3_column_text(stmt, 1);
            int age = sqlite3_column_int(stmt, 2);
            
            NSLog(@"%d***%s******%d",ID,name,age);
        }
    }
    //释放
    sqlite3_free(stmt);
    [self testFMDB];
    // Do any additional setup after loading the view, typically from a nib.
}
- (void)testFMDB
{
    NSString *docDic = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *fileName = [docDic stringByAppendingPathComponent:@"fmdb.db"];
    //创建数据库，路径为空的话，在内存中创建数据库
    fmdb = [FMDatabase databaseWithPath:fileName];
    
    [fmdb open];
    //执行sql语句,增、删、改都是executeUpdate方法
    NSString *sqlCreate =@"CREATE TABLE IF NOT EXISTS t_demo (id integer PRIMARY KEY AUTOINCREMENT,name text NOT NULL,age integer NOT NULL);";
    BOOL res = [fmdb executeUpdate:sqlCreate];
    NSString *sqlInsert = [NSString stringWithFormat:@"INSERT INTO t_demo (name,age) VALUES('%@','%d');",@"one",19];
    res = [fmdb executeUpdate:sqlInsert];
    if (!res) {
        NSLog(@"error when creating db table");
    } else {
        NSLog(@"success to creating db table");
    }
    //执行查询
    NSString *sqlQuery = [NSString stringWithFormat:@"SELECT id,name,age FROM t_demo;"];
    
    FMResultSet * rs = [fmdb executeQuery:sqlQuery];
    while ([rs next]) {
        int Id = [rs intForColumn:@"id"];
        NSString * name = [rs stringForColumn:@"name"];
        NSString * age = [rs stringForColumn:@"age"];
        NSLog(@"id = %d, name = %@, age = %@ ", Id, name, age);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end


















