#include <io.h>
#include <direct.h>
#include <stdio.h>
#include <math.h>
#include <process.h>
#include <string.h>
#include <stdlib.h>/*为了调用system("PAUSE");*/
#include <time.h>/*为了调用time;*/
#include <windows.h>
#include <sys/types.h>  
#include<mmsystem.h>
#include <conio.h>
#pragma comment(lib, "Winmm.lib")




//（需要 #include <io.h> 以及 #include <direct.h>）
// 创建文件夹
void CreateFolder()
{
    //文件夹名称
    char folderName[] = "odyink";

    // 文件夹不存在则创建文件夹
    if (_access(folderName, 0) == -1)
    {
        _mkdir(folderName);
    }
}

//然后在main函数中调用CreateFolder函数即可
void main()
{
  PlaySound("1.WAV",NULL,SND_FILENAME | SND_ASYNC);
  getch();
  while(1)
  {
    /* code */
  
  
       CreateFolder();
       //PlaySound(TEXT("1.wav"), NULL, SND_FILENAME | SND_ASYNC | SND_LOOP);
       //mciSendString("open p.mp3 alias bkmusic", NULL, 0, NULL);
    	 //mciSendString("play bkmusic repeat", NULL, 0, NULL);
       int a;
       //system("cd model");p
       system("prr.exe");
       printf("PRINT command NUMBER:\n");
       printf("1 is natural\n");
       printf("2 is HAVE\n");
       printf("3 is CREAT first\n");
       scanf("%d", &a);
       if( a == 1 )
       {
        //system("echo Odyink is a command-line personal blog software created by Andy (python) and SMG (Batch). >>odyink/Odyink.txt");
        //mkdir("odyink/blog");
        //system("echo THIS IS C ODYINK BY Andy. >>odyink/blog/0.txt");
        while(1)
        {
          int b;
          printf("PRINT command:\n");
          printf("1 is show the blog list\n");
          printf("2 is show the blog word\n");
          printf("3 is add blog in list\n");
          scanf("%d", &b);
          if ( b == 1 )
          {
           system("cd odyink/blog/");
           system("tree /f");
          }
          else if ( b == 2 )
         {
           FILE *fp;
           char ch;
           char mc[10];
           scanf("%s", mc);
           char zml[] = "odyink/blog/";
           char hoz[] = ".txt";
           char *strCat = (char*)malloc(strlen(zml) + strlen(mc) + strlen(hoz));
           sprintf(strCat,"%s%s%s",zml,mc,hoz);
           fp=fopen(strCat,"r");
           if(fp==NULL)
           {
             printf("can not open!\n");
           }
           else
           {
             fscanf(fp,"%c",&ch);
             while(!feof(fp))
             {
              putchar(ch);
              fscanf(fp,"%c",&ch);
             }
             fclose(fp);
           }
           printf("\n");
         }
          else if ( b == 3)
          {
           FILE *fp;
           FILE *fpnext;
           char ah;
           char strBat[30];
           scanf("%s", strBat);
           fp=fopen(strBat,"r");
           fscanf(fp,"%s",&ah);
            if (fp==NULL)
           {
             printf("NO FILE");
           }
            else
           {
            //&ah=fgetc(fp);
            //fscanf(fp,"%s",&ah);
            char mc2[10];
            char zml2[] = "odyink/blog/";
            char hoz2[] = ".txt";
            scanf("%s", mc2);
            char *wjc = (char*)malloc(strlen(zml2) + strlen(mc2) + strlen(hoz2));
            sprintf(wjc,"%s%s%s",zml2,mc2,hoz2);
            fpnext=fopen(wjc,"w+");
            fputs(&ah, fpnext);
            fclose(fpnext);
           }
          }
          else
          {
           break;
          }

        }
        

       }
       else if ( a == 2)
       {
        int a=10000,b,c=88400,d,e,f[88401],g;
        int mainx()
        {
        for(;b-c;)f[b++]=a/5;
        for(;d=0,g=c*2;c-=14,printf("%.4d",e+d/a),e=d%a)
        for(b=c;d+=f[b]*a,f[b]=d%--g,d/=g--,--b;d*=b);
        }
       }
       else if ( a == 3)
       {
        system("echo Odyink is a command-line personal blog software created by Andy (python) and SMG (Batch). >>odyink/Odyink.txt");
        mkdir("odyink/blog");
        system("echo THIS IS C ODYINK BY Andy. >>odyink/blog/0.txt");
       }
       
       system("pause");   
  }     
}