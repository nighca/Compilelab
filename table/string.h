#include <stdlib.h>
#include <string.h>

#if ! defined bool
#define bool int
#define true 1
#define false 0
#endif



bool _strcmp(const char* str1, const char* str2) {
    int i;
    for (i = 0; ; i++) {
        if (str1[i] != str2[i])
            return false;
        if (str1[i] == '\0' && str2[i] == '\0') {
            return true;
        }
    }
}

char* _strcat(const char *s1, const char *s2) {
    int len1 = strlen(s1);
    int len2 = strlen(s2);

    char *tempstr = (char *)malloc((len1 + len2 + 1) * sizeof(char));

    int i;
    for (i = 0; i < len1; i++) {
        tempstr[i] = s1[i];
    }
    for (i = 0; i < len2; i++) {
        tempstr[len1+i] = s2[i];
    }
    tempstr[len1+len2] = '\0';
    return tempstr;
}


char* _itoa(int n) {
    char *tempstr = (char *)malloc(10 * sizeof(char));
    int i;
    for (i = 0; ; i++) {
        tempstr[i] = '0' + n % 10;
        n /= 10;
        if (n == 0 || i == 8) {
            int j;
            for (j = 0; j <= i / 2; j++) {
                char t = tempstr[j];
                tempstr[j] = tempstr[i-j];
                tempstr[i-j] = t;
            }
            tempstr[i+1] = '\0';
            break;
        }
    }

    return tempstr;
}