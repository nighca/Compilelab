#include "table/table.h"
#include "table/string.h"
#include <stdlib.h>

# define YYSTYPE_IS_DECLARED 1
typedef struct YYSTYPE {
    char* name;
    int type;
    int width;
};

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
int newtemp(int type, int width) {
    char *tempstr = (char *)malloc(10 * sizeof(char));
    tempstr[0] = 'T';
    int n = __tableTop__;
    int i;
    for (i = 1; ; i++) {
        tempstr[i] = '0' + n % 10;
        n /= 10;
        if (n == 0 || i == 8) {
            tempstr[i+1] = '\0'
            break;
        }
    }
    __table__[__tableTop__].name = tempstr;
    __table__[__tableTop__].type = type;
    __table__[__tableTop__].width = width;
    __tableTop__++;
    return __tableTop__ - 1;
}

int enter(char* name, int type, int width) {
    __table__[__tableTop__].name = name;
    __table__[__tableTop__].type = type;
    __table__[__tableTop__].width = width;
    __tableTop__++;
    return __tableTop__ - 1;
}

char* getName(int i) {
    return __table__[i].name;
}

int getType(int i) {
    return __table__[i].type;
}

int getWidth(int i) {
    return __table__[i].width;
}

int lookup(char* name) {
    int i;
    for (i = 0; i < __tableTop__; i++) {
        if (_strcmp(name, __table__[i].name)) {
            return i;
        }
    }
    return NIL;
}


