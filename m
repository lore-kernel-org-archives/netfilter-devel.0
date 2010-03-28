From: Peter Gordon <peter@pg-consultants.com>
Subject: Modifying ebtables to read the commands from a file
Date: Sun, 28 Mar 2010 13:07:57 +0300
Message-ID: <1269770877.2563.9.camel@qed>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from gold.securenet-server.net ([207.45.186.66]:58047 "EHLO
	gold.securenet-server.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753198Ab0C1LGy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 28 Mar 2010 07:06:54 -0400
Received: from bzq-218-145-176.cablep.bezeqint.net ([81.218.145.176] helo=[192.168.234.3])
	by gold.securenet-server.net with esmtpa (Exim 4.69)
	(envelope-from <peter@pg-consultants.com>)
	id 1NvpPV-0007k1-8B
	for netfilter-devel@vger.kernel.org; Sun, 28 Mar 2010 06:08:01 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I need to add a number of rules to the ebtables and I cannot afford the
fork overhead for each line. So what I want to do is to read each line
from a file and have the program iterate over the file. 

ebtables-save and ebtables-restore is not good enough for my
application, because I can't add rules incrementally. ebtables-restore
doesn't add add rules, but replaces all existing rules.

I have changed ebtables-standalone.c:

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "include/ebtables_u.h"

static struct ebt_u_replace replace;
void ebt_early_init_once();

#define MAX_TOKENS 100
int main(int argc, char *argv[])
{
	ebt_silent = 0;
	ebt_early_init_once();

	char *tok ;
	char **myArgv ;
	char *delim = " " ; 
	char *p ; 
	FILE *fp ; 
	char line[1000] ; 
	int myArgc = 0 ; 
	int i ; 
	myArgv = malloc(MAX_TOKENS * sizeof(char *)) ; 
	for (i=0 ; i<MAX_TOKENS ; i++) { 
	  myArgv[i] = NULL ; 
	} 

	if (argc == 3 && strcmp(argv[1],"-f") == 0) { 
	  myArgv[0] = "ebtables" ; 
	  myArgc = 1 ; 
	  fp = fopen(argv[2],"r") ; 
	  if (fp == NULL) { 
	    fprintf(stderr,"Can't open file %s\n",argv[2]) ;
	    exit(1);
	  } 
	  
	  while(fgets(line,sizeof(line),fp)) { 
	    /* Ignore comments */
	    if (*line == '#' || *line == '\n') {
	      continue ; 
	    }
	    *strchr(line, '\n') = '\0';
	    p = line ; 
	    while(1) { 
	      tok = strtok(p,delim) ;
	      if (tok == NULL) { 
		break ; 
	      } 
	      p = NULL ; 
	      /* printf("Token %s\n",tok) ; */
	      if (myArgc >= MAX_TOKENS) { 
		fprintf(stderr,"Too many tokens on line %s\n",line) ;
		exit(1) ; 
	      } 
	      /* printf("TOKEN: number: %d name: %s\n",myArgc,tok) ;*/
	      myArgv[myArgc++] = tok ;
	    } 

	    memset(&replace,0,sizeof(replace)) ; 
	    strcpy(replace.name, "filter");
	    do_command(myArgc, myArgv, EXEC_STYLE_PRG, &replace);
	    myArgc = 1 ; 
	  }
	  return 0;
	}

	strcpy(replace.name, "filter");
	do_command(argc, argv, EXEC_STYLE_PRG, &replace);
	return 0;
}

I have also added some extra initialization to ebtables.c - the extra
code added is the three for loops:
	opterr = 0;
	ebt_modprobe = NULL;
	
	for (m = ebt_matches; m; m = m->next) { 
	  m->used = 0 ; 
	  m->flags = 0 ; 
	} 
	for (t = ebt_targets; t; t = t->next) { 
	  t->used = 0 ; 
	  t->flags = 0 ; 
	} 
	for (w = ebt_watchers; w; w = w->next) { 
	  w->used = 0 ; 
	  w->flags = 0 ; 
	} 

	replace = replace_;

	/* The daemon doesn't use the environment variable */
	if (exec_style == EXEC_STYLE_PRG) {


I am still missing some initializations - I am getting leftover
information from previous rules. 

The essential problem is to allow do_command to be called more than
once.

Can anyone tell me how to correctly initialize all the structures in the
do_command.

Thanks,

Peter





