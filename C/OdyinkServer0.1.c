#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define _CRT_SECURE_NO_WARNINGS

// OSType lowercase
#define OSTYPE windows
// Windows = 1 Linux = 0
#define OSNUM 1

void Install();

//OS Commands
	void Clear();
	char* WinPath(char *fName);
	void ViewText(char *fName);
//

// Files Manipulation
	int FExist(char *fName);
	void FOverWrite(char *fName,char *text);
	void FAddWrite(char *fName,char *text);
//

// Other
	int NumStrToInt(char numStr[]);
//

int main()
{
	char stop;
	int docID;
	char *file,*message;
	char lnk[32];
	file = (char*)malloc(sizeof(char) * 64);
	message = (char*)malloc(sizeof(char) * 256);
	if (OSNUM)
		system("chcp 65001");
	printf("Odyink Server\n");
	if (FExist("./odyins.txt"))
	{
		printf("Odyink Server is installed\n");
		system("cd odydata");
	}
	else
		Install();
	Clear();
	ViewText("doclist.ini");
	scanf("%d",&docID);
	Clear();
	sprintf(lnk,"doc/%d.txt",docID);
	ViewText(lnk);
	stop = getchar();
	stop = getchar();
	if (OSNUM)
		system("chcp 936");
	Clear();
	return 0;
}

void Install()
{
	// Install Odyink Server
	printf("Instailling Odyink Server...\n");
	//system("mkdir odydata");
	if (OSNUM)
		system("mkdir odydata\\doc nul 2> nul");
	else
		system("mkdir -p odydata/doc");
	FOverWrite("./odydata/odyins.ini","Odyink Server is install");
	FOverWrite("./odydata/docnum.ini","1");
	FOverWrite("./odydata/docallnum.ini","1");
	FOverWrite("./odydata/doclist.ini","0.你好 Odyink");
	FOverWrite("./odydata/doctype.ini","0 txt");
	FOverWrite("./odydata/doc/0.txt","Hello this is Odyink");
	FAddWrite("./odydata/doc/0.txt","");
	FAddWrite("./odydata/doc/0.txt","Odyink is make by smgdream & Andyccr");
	getchar();
}


//OS Commands
void Clear()
{
	if (OSNUM)
		system("cls");
	else
		system("clear");
}

void ViewText(char *fName)
{
	char command[64];
	if (OSNUM)
	{
		sprintf(command,"type .\\odydata\\%s",WinPath(fName));
		system(command);
	}
	else
	{
		sprintf(command,"cat ./odydata/%s",fName);
		system(command);
	}
	printf("\n");
}

char* WinPath(char *fName)
{
        int l;
        static char tmpePath[256];
        strcpy(tmpePath,fName);
        for (l = 0;tmpePath[l] !='\0';++l)
        {
                if (tmpePath[l] =='/')
                        tmpePath[l++] = '\\';
        }
        return tmpePath;
}

// Files Manipulation
int FExist(char *fName)
{
	FILE *fp = NULL;
	fp = fopen(fName,"r");
	//NULL = 0
	if (fp == NULL)
		return 0;
	else
		return 1;
	fclose(fp);
}

void FOverWrite(char *fName,char *text)
{
	FILE *fp = NULL;
	fp = fopen(fName,"w+");
	fputs(text,fp);
	fputs("\n",fp);
	fclose(fp);
}

void FAddWrite(char *fName,char *text)
{
	FILE *fp = NULL;
	fp = fopen(fName,"a+");
	fputs(text,fp);
	fputs("\n",fp);
	fclose(fp);
}

// Other
int NumStrToInt(char numStr[])
{
	int i,number;
	for (i = 0;numStr[i] >= '0' && numStr[i] <= '9';i++)
		number = 10 * number + (numStr[i] - '0');
	return number;
}