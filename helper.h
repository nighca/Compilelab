#ifndef HELPER_H
#define HELPER_H

#include <stdio.h>
#include <stdlib.h>
#include "table/table.h"
#include "table/string.h"
#include "table/quad.h"

# define YYSTYPE_IS_DECLARED 1
typedef struct {
    char* name;
    int type;
    int width;
    int next;
} YYSTYPE;

// ============type=======================
#define __INTEGER__ 1
#define __REAL__    2
#define __BOOLEAN__ 3

#define __INTEGER__ARRAY__  11
#define __REAL__ARRAY__     12
#define __BOOLEAN__ARRAY__  13

#if ! defined NIL
#define NIL -1
#endif

// ======================================

// return the offset of the new temp in table
static int newtemp(int type, int width) {
    char *tempstr = (char *)malloc(10 * sizeof(char));
    tempstr[0] = 'T';
    int n = __tableTop__;
    int i;
    for (i = 1; ; i++) {
        tempstr[i] = '0' + n % 10;
        n /= 10;
        if (n == 0 || i == 8) {
            int j;
            for (j = 1; j <= i / 2; j++) {
                char t = tempstr[j];
                tempstr[j] = tempstr[i+1-j];
                tempstr[i+1-j] = t;
            }
            tempstr[i+1] = '\0';
            break;
        }
    }
    __table__[__tableTop__].name = tempstr;
    __table__[__tableTop__].type = type;
    __table__[__tableTop__].width = width;
    __table__[__tableTop__].addr = __offset__;
    __tableTop__++;
    __offset__ += width;
    return __tableTop__ - 1;
}

static int enter(char* name, int type, int width) {
    __table__[__tableTop__].name = name;
    __table__[__tableTop__].type = type;
    __table__[__tableTop__].width = width;
    __table__[__tableTop__].addr = __offset__;
    __tableTop__++;
    __offset__ += width;
    return __tableTop__ - 1;
}

static char* getName(int i) {
    return __table__[i].name;
}

static int getType(int i) {
    return __table__[i].type;
}

static int getWidth(int i) {
    return __table__[i].width;
}

static int getAddr(int i) {
    return __table__[i].addr;
}

static int lookup(char* name) {
    int i;
    for (i = 0; i < __tableTop__; i++) {
        if (_strcmp(name, __table__[i].name)) {
            return i;
        }
    }
    return NIL;
}

// ========================================================

static int gen(char* op, char* arg1, char* arg2, char* result) {
    __quad__[__quadTop__].op = op;
    __quad__[__quadTop__].arg1 = arg1;
    __quad__[__quadTop__].arg2 = arg2;
    __quad__[__quadTop__].result = result;
    __quadTop__++;
    return __quadTop__ - 1;
}

static void setResult(int n, char* newResult) {
    __quad__[n].result = newResult;
}

static int getQuadTop() {
    return __quadTop__ - 1;
}

// ========================================================

static void _init() {
}

static void _finish() {
    __file__ = fopen("中间代码.txt", "w");
    int i;
    for (i = 0; i < __quadTop__; i++) {
        fprintf(__file__, "%d: %s %s %s %s\n", i, __quad__[i].op, __quad__[i].arg1, __quad__[i].arg2, __quad__[i].result);
    }
    fclose(__file__);
}


#endif
