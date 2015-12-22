//
//  ViewController.m
//  iOSSQLDemo
//
//  Created by yz on 15/12/22.
//  Copyright © 2015年 DeviceOne. All rights reserved.
//

#import "ViewController.h"
#import <sqlite3.h>

@interface ViewController ()
{
    sqlite3 *db;
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
    // Do any additional setup after loading the view, typically from a nib.
}
- (void)test
{
    double sqlite3_column_double(sqlite3_stmt*, int iCol);  // 浮点数据
    int sqlite3_column_int(sqlite3_stmt*, int iCol); // 整型数据
    sqlite3_int64 sqlite3_column_int64(sqlite3_stmt*, int iCol); // 长整型数据
    const void *sqlite3_column_blob(sqlite3_stmt*, int iCol); // 二进制文本数据
    const unsigned char *sqlite3_column_text(sqlite3_stmt*, int iCol);  // 字符串数据
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end


















