From: Amin Azez <azez@ufomechanic.net>
Subject: new code; iptables-xml for iptables package.
Date: Thu, 09 Nov 2006 11:32:05 +0000
Message-ID: <455311B5.5000600@ufomechanic.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------040608000805080106080301"
Cc: Harald Welte <laforge@netfilter.org>, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------040608000805080106080301
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

(I hope these can be added to the standard iptables package)

Here is iptables-xml based on iptables-restore (as it knows how to parse
iptables-save format), along with some xslt that converts back to
iptables-save format.

A typical null use would be:

  iptables-save -c | iptables-xml -c | xsltproc iptables.xslt -

iptables-xml does a mechanistic conversion to a very expressive xml
format; the only semantic considerations are for -g and -j targets in
order to discriminate between <call> <goto> and <nane-of-target> as it
helps xml processing scripts if they can tell the difference between a
target like SNAT and another chain.

The software is released under the GPL2 (naturally, being derived from
iptables-restore). I'm happy to "or later version" if/when iptables ever
does.

the -c argument means "combine"; it looks for sequential rules with
actions whose conditions are non-null and identical, and combines those
into a single xml rule with multiple actions. The test is rather basic
and thus suited to processing the ACTUAL output of iptables-save as this
does some (accidental) argument re-ordering making the test more likely
to succeed. This option is only to help people whose native format is
iptables-save move to xml; those who use xml as the native format will
not be bothered by this.

The accomanying xslt does a reverse translation back to iptables-save
format, and is released under the same license.

The xslt is not very strict; maybe if you give it bad xml it will
produce a bad output file. It's sole purpose is not to syntax or sanity
check the iptables rules, but to provide an alternative representation
of these rules.

It would be trivial to alter the multiple-actions code in the xslt to
generate sub-chains instead of repeating the conditions; I intend to do
this soon, but current behaviour is required by my current projects in
the short term.

A sample of the xml format
<iptables-rules>
  <table name="mangle" >
    <chain name="PREROUTING" policy="ACCEPT" packet-count="63436"
byte-count="7137573" >
      <rule >
       <conditions>
        <match >
          <p >tcp</p>
        </match>
        <tcp >
          <sport >8443</sport>
        </tcp>
       </conditions>
       <actions>
        <call >
          <check_ip />
        </call>
       </actions>
      </rule>
    </chain>
</iptables-rules>

Sam

--------------040608000805080106080301
Content-Type: text/x-csrc;
 name="iptables-xml.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="iptables-xml.c"

/* Code to convert iptables-save format to xml format,
 * (C) 2006 Ufo Mechanic <azez@ufomechanic.net>
 * based on iptables-restore (C) 2000-2002 by Harald Welte <laforge@gnumonks.org>
 * based on previous code from Rusty Russell <rusty@linuxcare.com.au>
 *
 * This code is distributed under the terms of GNU GPL v2
 *
 * $Id: iptables-xml.c,v 1.4 2006/11/09 12:02:17 azez Exp $
 */

#include <getopt.h>
#include <sys/errno.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include "iptables.h"
#include "libiptc/libiptc.h"

#ifdef DEBUG
#define DEBUGP(x, args...) fprintf(stderr, x, ## args)
#else
#define DEBUGP(x, args...) 
#endif

/* no need to link with iptables.o */
const char* program_name;
const char* program_version;
int line=0;

void exit_error(enum exittype status, char *msg, ...)
{
        va_list args;

        va_start(args, msg);
        fprintf(stderr, "%s v%s: ", program_name, program_version);
        vfprintf(stderr, msg, args);
        va_end(args);
        fprintf(stderr, "\n");
        /* On error paths, make sure that we don't leak memory */
        exit(status);
}

static void print_usage(const char *name, const char *version) __attribute__((noreturn));

static int verbose = 0;
/* Whether to combine actions of sequential rules with identical conditions */
static int combine = 0;
/* Keeping track of external matches and targets.  */
static struct option options[] = {
	{ "verbose", 0, 0, 'v' },
	{ "combine", 0, 0, 'c' },
	{ "help", 0, 0, 'h' },
	{ 0 }
};

static void print_usage(const char *name, const char *version)
{
	fprintf(stderr, "Usage: %s [-c] [-v] [-h]\n"
                        "          [--combine ]\n"
			"	   [ --verbose ]\n"
			"	   [ --help ]\n",
			name);
		
	exit(1);
}

int parse_counters(char *string, struct ipt_counters *ctr)
{
	if (string != NULL)
		return (sscanf(string, "[%llu:%llu]", (unsigned long long *)&ctr->pcnt, (unsigned long long *)&ctr->bcnt) == 2);
	else
		return (0 == 2);
}

/* global new argv and argc */
static char *newargv[255];
static int newargc=0;

static char *oldargv[255];
static int oldargc=0;

/* arg meta data, were they quoted, frinstance */
static int newargvattr[255];
static int oldargvattr[255];

#define IPT_CHAIN_MAXNAMELEN IPT_TABLE_MAXNAMELEN
char closeActionTag[IPT_TABLE_MAXNAMELEN+1];
char closeRuleTag[IPT_TABLE_MAXNAMELEN+1];
char curTable[IPT_TABLE_MAXNAMELEN+1];
char curChain[IPT_CHAIN_MAXNAMELEN+1];

typedef struct chain {
	char *chain;
	char *policy;
	struct ipt_counters count;
	int created;
} chain;

#define maxChains 10240 /* max chains per table */
static chain chains[maxChains];
static int nextChain=0;

/* funCtion adding one argument to newargv, updating newargc 
 * returns true if argument added, false otherwise */
static int add_argv(char *what,int quoted) {
	DEBUGP("add_argv: %d %s\n", newargc, what);
	if (what && ((newargc + 1) < sizeof(newargv)/sizeof(char *))) {
		newargv[newargc] = strdup(what);
		newargvattr[newargc]=quoted;
		newargc++;
		return 1;
	} else 
		return 0;
}

static void free_argv(void) {
	int i;

	for (i = 0; i < newargc; i++) {
		free(newargv[i]);
		newargv[i]=NULL;
	}
	newargc=0;

	for (i = 0; i < oldargc; i++) {
		free(oldargv[i]);
		oldargv[i]=NULL;
	}
	oldargc=0;
}

/* save parsed rule for comparison with next rule 
   to perform action agregation on duplicate conditions */
static void save_argv(void) {
	int i;

	for (i = 0; i < oldargc; i++)
		free(oldargv[i]);
	oldargc=newargc;
	newargc=0;
	for (i = 0; i < oldargc; i++) {
		oldargv[i]=newargv[i];
		newargv[i]=NULL;
	}
}

/* like puts but with xml encoding */
static void xmlEncode(char* text) {
	while(text && *text) {
		if ((unsigned char)(*text)>127) printf("&#%d;",(unsigned char)(*text));
		else if (*text=='&') printf("&amp;");
		else if (*text=='<') printf("&lt;");
		else if (*text=='>') printf("&gt;");
		else if (*text=='"') printf("&quot;");
		else putchar(*text);
		*text++;
	}
}

/* Output text as a comment, avoiding a double hyphen */
static void xmlCommentEscape(char* comment) {
  int h_count=0;

  while(comment && *comment) {
    if (*comment=='-') {
      h_count++;
      if (h_count>=2) {
        h_count=0;
        putchar(' ');
      }
      putchar('*');
    }
    /* strip trailing newline */
    if (*comment=='\n' && *(comment+1)==0);
    else putchar(*comment);
    comment++;
  }
}

static void xmlComment(char *comment) {
  printf("<!-- ");
  xmlCommentEscape(comment);
  printf(" -->\n");
}

static void xmlAttrS(char* name, char* value) {
  printf("%s=\"",name);
  xmlEncode(value);
  printf("\" ");
}

static void xmlAttrI(char* name, long long int num) {
  printf("%s=\"%lld\" ",name,num);
}

static void closeChain() {
	if (curChain[0]==0) return;

	if (closeActionTag[0]) printf("%s\n",closeActionTag);
	closeActionTag[0]=0;
	if (closeRuleTag[0]) printf("%s\n",closeRuleTag);
	closeRuleTag[0]=0;
	if (curChain[0]) printf("    </chain>\n");
	curChain[0]=0;
	//lastRule[0]=0;
}

static void openChain(char* chain, char* policy, struct ipt_counters *ctr, char close) {
	closeChain();
	
	strncpy(curChain, chain, IPT_CHAIN_MAXNAMELEN);
	curChain[IPT_CHAIN_MAXNAMELEN] = '\0';

	printf("    <chain ");
	xmlAttrS("name",curChain);
	if (strcmp(policy,"-")!=0) xmlAttrS("policy",policy);
	xmlAttrI("packet-count",(unsigned long long)ctr->pcnt);
	xmlAttrI("byte-count",(unsigned long long)ctr->bcnt);
	if (close) {
		printf("%c",close);
		curChain[0]=0;
	}
	printf(">\n");
}

static int existsChain(char *chain) {
	/* open a saved chain */
	int c=0;

	if (0==strcmp(curChain,chain)) return 1;
	for(c=0;c<nextChain;c++) if (chains[c].chain && strcmp(chains[c].chain,chain)==0) return 1;
	return 0;
}

static void needChain(char *chain) {
	/* open a saved chain */
	int c=0;

	if (0==strcmp(curChain,chain)) return;
	
	for(c=0;c<nextChain;c++) if (chains[c].chain && strcmp(chains[c].chain,chain)==0) {
		openChain(chains[c].chain, chains[c].policy, &(chains[c].count),'\0');
		// And, mark it as done so we don't create an empty chain at table-end time
		chains[c].created=1;
	}
}

static void saveChain(char* chain, char* policy, struct ipt_counters *ctr) {
	if (nextChain>=maxChains) {
		exit_error(PARAMETER_PROBLEM,
			"%s: line %u chain name invalid\n",
			program_name, line);
		exit(1);
	};
	chains[nextChain].chain=strdup(chain);
	chains[nextChain].policy=strdup(policy);
	chains[nextChain].count=*ctr;
	chains[nextChain].created=0;
	nextChain++;
}

static void finishChains() {
	int c;

	for(c=0;c<nextChain;c++) if (! chains[c].created) {
		openChain(chains[c].chain, chains[c].policy, &(chains[c].count),'/');
		free(chains[c].chain);
		free(chains[c].policy);
	}
	nextChain=0;
}

static void closeTable() {
	closeChain();
	finishChains();
	if (curTable[0]) printf("  </table>\n");
	curTable[0]=0;
}

static void openTable(char* table) {
	closeTable();

	strncpy(curTable, table, IPT_TABLE_MAXNAMELEN);
	curTable[IPT_TABLE_MAXNAMELEN] = '\0';

	printf("  <table ");
	xmlAttrS("name",curTable);
	printf(">\n");
}

// is char* -j --jump -g or --goto
static int isTarget(char* arg) {
  return ((arg) && ( strcmp((arg),"-j")==0 || strcmp((arg),"--jump")==0 || strcmp((arg),"-g")==0 || strcmp((arg),"--goto")==0));
}

// part=-1 means do conditions, part=1 means do rules, part=0 means do both
static void do_rule_part(char* leveltag1,char *leveltag2,int part, int argc, char* argv[], int argvattr[]) {
	int arg=1; // ignore leading -A
	char invert_next=0;
	char* thisChain=NULL;
	char* spacer=""; // space when needed to assemble arguments
	char* level1=NULL;
	char* level2=NULL;
	char* leveli1="        ";
	char* leveli2="          ";

#define CLOSE_LEVEL(LEVEL) \
	do { \
		if (level ## LEVEL) printf("</%s>\n", (leveltag ## LEVEL)?(leveltag ## LEVEL):(level ## LEVEL)); \
		level ## LEVEL=NULL;\
	} while(0)

#define OPEN_LEVEL(LEVEL,TAG) \
	do {\
		level ## LEVEL=TAG;\
		if (leveltag ## LEVEL) {\
			printf("%s<%s ", (leveli ## LEVEL), (leveltag ## LEVEL));\
			xmlAttrS("type", (TAG)); \
		} else printf("%s<%s ", (leveli ## LEVEL), (level ## LEVEL)); \
	} while(0)

	thisChain=argv[arg++];

	if (part==1) { /* skip */
		/* use argvattr to tell which arguments were quoted 
                   to avoid comparing quoted arguments, like comments, to -j,*/
		while(arg<argc && (argvattr[arg] || !isTarget(argv[arg])) ) arg++;
	}
	
	/* Before we start, if the first arg is -[^-] and not -m or -j or -g then start a dummy <match> tag 
	 * for old style built-in matches.  We would do this in any case, but no need if it would be empty */
	if (arg<argc && argv[arg][0]=='-' && ! isTarget(argv[arg]) && strcmp(argv[arg],"-m")!=0) {
		OPEN_LEVEL(1,"match");
		printf(">\n");
	}
	while(arg<argc) {
		// If ! is followed by -* then apply to that, else output as data
                // Stop, if we need to
		if (part==-1 && ! argvattr[arg] && (isTarget(argv[arg]))) {
			break;
		} else if (! argvattr[arg] && strcmp(argv[arg],"!")==0) { 
			if ((arg+1)<argc && argv[arg+1][0]=='-') invert_next='!';
			else printf("%s%s",spacer,argv[arg]);
			spacer=" ";
		} else if (! argvattr[arg] && isTarget(argv[arg]) && existsChain(argv[arg+1]) && (2+arg>=argc)) {
			if (! ((1+arg)<argc)) break; // no args to -j, -m or -g, just ignore it and finish loop
			CLOSE_LEVEL(2);
			if (level1) printf("%s",leveli1);
			CLOSE_LEVEL(1);
			spacer="";
			invert_next=0;
			if (strcmp(argv[arg],"-g")==0 || strcmp(argv[arg],"--goto")==0) {
				/* goto user chain */
				OPEN_LEVEL(1,"goto");
				printf(">\n");
				arg++;
				OPEN_LEVEL(2,argv[arg]);
				printf("/>\n");
				level2=NULL;
			} else {
				/* call user chain */
				OPEN_LEVEL(1,"call");
				printf(">\n");
				arg++;
				OPEN_LEVEL(2,argv[arg]);
				printf("/>\n");
				level2=NULL;
			}
 		} else if (! argvattr[arg] && (isTarget(argv[arg]) || strcmp(argv[arg],"-m")==0 || strcmp(argv[arg],"--module")==0)) {
			if (! ((1+arg)<argc)) break; // no args to -j, -m or -g, just ignore it and finish loop
			CLOSE_LEVEL(2);
			if (level1) printf("%s",leveli1);
			CLOSE_LEVEL(1);
			spacer="";
			invert_next=0;
			arg++;
			OPEN_LEVEL(1,(argv[arg]));
			// Optimize case, can we close this tag already?
			if ( (arg+1)>=argc || (! argvattr[arg+1] && ( isTarget(argv[arg+1]) || strcmp(argv[arg+1],"-m")==0 || strcmp(argv[arg+1],"--module")==0 ) ) ) {
				printf(" />\n");
				level1=NULL;
			} else {
				printf(">\n");
			}
		} else if (! argvattr[arg] && argv[arg][0]=='-') {
			char* tag;
			CLOSE_LEVEL(2);
			// Skip past any -
			tag=argv[arg];
			while(*tag=='-' && *tag) tag++;

			spacer="";
			OPEN_LEVEL(2,tag);
			if (invert_next) printf(" invert=\"1\"");
			invert_next=0;

			// Optimize case, can we close this tag already?
			if (! ((arg+1)<argc) || (argv[arg+1][0]=='-' /* NOT QUOTED */)) {
				printf(" />\n");
				level2=NULL;
			} else {
				printf(">");
			}
		} else { // regular data
			char* spaces=strchr(argv[arg],' ');
			printf("%s",spacer);
			if (spaces || argvattr[arg]) printf("&quot;");
			// if argv[arg] contains a space, enclose in quotes
			xmlEncode(argv[arg]);
			if (spaces || argvattr[arg]) printf("&quot;");
			spacer=" ";
		}
		arg++;
	}
	CLOSE_LEVEL(2);
	if (level1) printf("%s",leveli1);
	CLOSE_LEVEL(1);

	return;
}

static int compareRules() {
  /* compare arguments up to -j or -g for match.
     NOTE: We don't want to combine actions if there were no criteria in each rule,
           or rules didn't have an action 
     NOTE: Depends on arguments being in some kind of "normal" order which is 
           the case when processing the ACTUAL output of actual iptables-save 
           rather than a file merely in a compatable format */

  int old=0;
  int new=0;

  int compare=0;

  while (new<newargc && old<oldargc) {
    if (isTarget(oldargv[old]) && isTarget(newargv[new])) { 
      compare=1;
      break;
    }
    // break when old!=new
    if (strcmp(oldargv[old],newargv[new])!=0) {
      compare=0;
      break;
    }

    old++;
    new++;
  }
  // We won't match unless both rules had a target. 
  // This means we don't combine target-less rules, which is good

  /* If we don't insist that they both have -j, then if compare may be still -1 if one of them ran out of space cos had no -j
     This is OK, if the other is at -j, e.g. */
  //NOTE:NOTE:These two lines were commented out so I did NOT add the -g code to match the -j code
  //if (compare==-1 && ( (old<oldargc && oldargv[old]=="-j") || (new<newargc && newargv[new]=="-j") ) ) compare=1;
  //else if (compare==-1) compare=0;

  return compare==1;
}

/* has a nice parsed rule starting with -A */
static void do_rule(char* pcnt, char* bcnt, int argc, char *argv[], int argvattr[]) {
	/* are these conditions the same as the previous rule?
 	 * If so, skip arg straight to -j or -g */
	if (combine && argc>2 && ! isTarget(argv[2]) && compareRules()) {
		xmlComment("Combine action from next rule");
	} else {

		if (closeActionTag[0]) {
			printf("%s\n",closeActionTag);
			closeActionTag[0]=0;
		}
		if (closeRuleTag[0]) {
			printf("%s\n",closeRuleTag);
			closeRuleTag[0]=0;
		}

		printf("      <rule ");
		//xmlAttrS("table",curTable); // not needed in full mode 
		//xmlAttrS("chain",argv[1]); // not needed in full mode 
		if (pcnt) xmlAttrS("packet-count",pcnt);
		if (bcnt) xmlAttrS("byte-count",bcnt);
		printf(">\n");

		strncpy(closeRuleTag, "      </rule>\n", IPT_TABLE_MAXNAMELEN);
		closeRuleTag[IPT_TABLE_MAXNAMELEN] = '\0';

		/* no point in writing out condition if we can see there isn't one */
		if (argc>=3 && !isTarget(argv[2]) ) {
			printf("       <conditions>\n");
			do_rule_part(NULL,NULL,-1,argc,argv,argvattr);
			printf("       </conditions>\n");
		}
	}
	/* Write out the action */
	//do_rule_part("action","arg",1,argc,argv,argvattr);
	if (! closeActionTag[0]) {
	  printf("       <actions>\n");
	  strncpy(closeActionTag, "       </actions>\n", IPT_TABLE_MAXNAMELEN);
	  closeActionTag[IPT_TABLE_MAXNAMELEN] = '\0';
	}
	do_rule_part(NULL,NULL,1,argc,argv,argvattr);
}


#ifdef IPTABLES_MULTI
int
iptables_restore_main(int argc, char *argv[])
#else
int
main(int argc, char *argv[])
#endif
{
	char buffer[10240];
	int c;
	FILE *in;

	program_name = "iptables-xml";
	program_version = IPTABLES_VERSION;
	line = 0;

	while ((c = getopt_long(argc, argv, "bcvthnM:", options, NULL)) != -1) {
		switch (c) {
			case 'c':
				combine = 1;
				break;
			case 'v':
				printf("xptables-xml\n");
				verbose = 1;
				break;
			case 'h':
				print_usage("iptables-xml",
					    IPTABLES_VERSION);
				break;
		}
	}
	
	if (optind == argc - 1) {
		in = fopen(argv[optind], "r");
		if (!in) {
			fprintf(stderr, "Can't open %s: %s", argv[optind],
				strerror(errno));
			exit(1);
		}
	}
	else if (optind < argc) {
		fprintf(stderr, "Unknown arguments found on commandline");
		exit(1);
	}
	else in = stdin;

	printf("<iptables-rules version=\"1.0\">\n");

	/* Grab standard input. */
	while (fgets(buffer, sizeof(buffer), in)) {
		int ret = 0;

		line++;

		if (buffer[0] == '\n')
			continue;
		else if (buffer[0] == '#') {
			xmlComment(buffer);
			continue;
		}

		if (verbose) {	
			printf("<!-- line %d ",line);
			xmlCommentEscape(buffer);
			printf(" -->\n");
		}

		if ((strcmp(buffer, "COMMIT\n") == 0) && (curTable[0])) {
			DEBUGP("Calling commit\n");
			closeTable();
			ret=1;
		} else if ((buffer[0] == '*')) {
			/* New table */
			char *table;

			table = strtok(buffer+1, " \t\n");
			DEBUGP("line %u, table '%s'\n", line, table);
			if (!table) {
				exit_error(PARAMETER_PROBLEM, 
					"%s: line %u table name invalid\n",
					program_name, line);
				exit(1);
			}
			openTable(table);

			ret=1;
		} else if ((buffer[0] == ':') && (curTable[0])) {
			/* New chain. */
			char *policy, *chain;

			chain = strtok(buffer+1, " \t\n");
			DEBUGP("line %u, chain '%s'\n", line, chain);
			if (!chain) {
				exit_error(PARAMETER_PROBLEM,
					   "%s: line %u chain name invalid\n",
					   program_name, line);
				exit(1);
			}

			DEBUGP("Creating new chain '%s'\n", chain);

			policy = strtok(NULL, " \t\n");
			DEBUGP("line %u, policy '%s'\n", line, policy);
			if (!policy) {
				exit_error(PARAMETER_PROBLEM,
					   "%s: line %u policy invalid\n",
					   program_name, line);
				exit(1);
			}

			struct ipt_counters count;

			char *ctrs;
			ctrs = strtok(NULL, " \t\n");

			parse_counters(ctrs, &count);
			
			saveChain(chain, policy, &count);

			ret=1;
		} else if (curTable[0]) {
			int a;
			char *ptr = buffer;
			char *pcnt = NULL;
			char *bcnt = NULL;
			char *parsestart;
			char *chain = NULL;

			/* the parser */
			char *param_start, *curchar;
			int quote_open, quoted;

			/* reset the newargv */
			newargc = 0;

			if (buffer[0] == '[') {
				/* we have counters in our input */
				ptr = strchr(buffer, ']');
				if (!ptr)
					exit_error(PARAMETER_PROBLEM,
						   "Bad line %u: need ]\n",
						   line);

				pcnt = strtok(buffer+1, ":");
				if (!pcnt)
					exit_error(PARAMETER_PROBLEM,
						   "Bad line %u: need :\n",
						   line);

				bcnt = strtok(NULL, "]");
				if (!bcnt)
					exit_error(PARAMETER_PROBLEM,
						   "Bad line %u: need ]\n",
						   line);

				/* start command parsing after counter */
				parsestart = ptr + 1;
			} else {
				/* start command parsing at start of line */
				parsestart = buffer;
			}


			/* This is a 'real' parser crafted in artist mode
			 * not hacker mode. If the author can live with that
			 * then so can everyone else */

			quote_open = 0;
			/* We need to know which args were quoted so we can preserve quote */
			quoted = 0; 
			param_start = parsestart;
			
			for (curchar = parsestart; *curchar; curchar++) {
				if (*curchar == '"') {
					/* quote_open cannot be true if there
					 * was no previous character.  Thus, 
					 * curchar-1 has to be within bounds */
					if (quote_open && 
					    *(curchar-1) != '\\') {
						quote_open = 0;
						*curchar = ' ';
					} else {
						quote_open = 1;
						quoted = 1;
						param_start++;
					}
				} 
				if (*curchar == ' '
				    || *curchar == '\t'
				    || * curchar == '\n') {
					char param_buffer[1024];
					int param_len = curchar-param_start;

					if (quote_open)
						continue;

					if (!param_len) {
						/* two spaces? */
						param_start++;
						continue;
					}
					
					/* end of one parameter */
					strncpy(param_buffer, param_start,
						param_len);
					*(param_buffer+param_len) = '\0';

					/* check if table name specified */
					if (!strncmp(param_buffer, "-t", 3)
                                            || !strncmp(param_buffer, "--table", 8)) {
						exit_error(PARAMETER_PROBLEM, 
						   "Line %u seems to have a "
						   "-t table option.\n", line);
						exit(1);
					}

					add_argv(param_buffer,quoted);
					if (newargc>=2 && 0==strcmp(newargv[newargc-2],"-A")) chain=newargv[newargc-1];
					quoted = 0;
					param_start += param_len + 1;
				} else {
					/* regular character, skip */
				}
			}

			DEBUGP("calling do_command(%u, argv, &%s, handle):\n",
				newargc, curTable);

			for (a = 0; a < newargc; a++)
				DEBUGP("argv[%u]: %s\n", a, newargv[a]);

			needChain(chain); // Should we explicitly look for -A
			do_rule(pcnt, bcnt, newargc, newargv, newargvattr);

			save_argv();
			ret=1;
		}
		if (!ret) {
			fprintf(stderr, "%s: line %u failed\n",
					program_name, line);
			exit(1);
		}
	}
	if (curTable[0]) {
		fprintf(stderr, "%s: COMMIT expected at line %u\n",
				program_name, line + 1);
		exit(1);
	}

	printf("</iptables-rules>\n");
	free_argv();

	return 0;
}

--------------040608000805080106080301
Content-Type: application/xslt+xml;
 name="iptables.xslt"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="iptables.xslt"

PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iSVNPLTg4NTktMSI/Pgo8IS0tIENvbnZl
cnRzIGZyb20gc2ltcGxlIHhtbCBpcHRhYmxlcyBmb3JtYXQgdG8gaXB0YWJsZXMtc2F2ZSBm
b3JtYXQgIAogICAgIENvcHlyaWdodCAyMDA2IFVmb01lY2hhbmljIAogICAgIEF1dGhvcjog
YXplekB1Zm9tZWNoYW5pYy5uZXQgCiAgICAgVGhpcyBjb2RlIGlzIGRpc3RyaWJ1dGVkIGFu
ZCBsaWNlbnNlZCB1bmRlciB0aGUgdGVybXMgb2YgR05VIEdQTCB2MgogICAgIAogICAgIFRo
aXMgc2FtcGxlIHVzYWdlIG91dHB1dHMgcm91Z2hseSB3YW50IGdvZXMgaW4KICAgICAgIGlw
dGFibGVzLXNhdmUgfCBpcHRhYmxlcy14bWwgLWMgfCB4c2x0cHJvYyBpcHRhYmxlcy54c2x0
IC0KICAgICAtLT4KPHhzbDp0cmFuc2Zvcm0gdmVyc2lvbj0iMS4wIiB4bWxuczp4c2w9Imh0
dHA6Ly93d3cudzMub3JnLzE5OTkvWFNML1RyYW5zZm9ybSI+CiAgPHhzbDpvdXRwdXQgbWV0
aG9kID0gInRleHQiIC8+CiAgPHhzbDpzdHJpcC1zcGFjZSBlbGVtZW50cz0iKiIgLz4KCiAg
PCEtLSBvdXRwdXQgY29uZGl0aW9ucyBvZiBhIHJ1bGUgYnV0IG5vdCBhbiBhY3Rpb24gLS0+
CiAgPHhzbDp0ZW1wbGF0ZSBtYXRjaD0iaXB0YWJsZXMtcnVsZXMvdGFibGUvY2hhaW4vcnVs
ZS9jb25kaXRpb25zLyoiPgogICAgPCEtLSA8bWF0Y2g+IGlzIHRoZSBwc3VlZG8gbW9kdWxl
IHdoZW4gYSBtYXRjaCBtb2R1bGUgZG9lc24ndCBuZWVkIHRvIGJlIGxvYWRlZAogICAgICAg
ICBhbmQgd2hlbiAtbSBkb2VzIG5vdCBuZWVkIHRvIGJlIGluc2VydGVkIC0tPgogICAgPHhz
bDppZiB0ZXN0PSJuYW1lKCkgIT0gJ21hdGNoJyI+CiAgICAgIDx4c2w6dGV4dD4gLW0gPC94
c2w6dGV4dD48eHNsOnZhbHVlLW9mIHNlbGVjdD0ibmFtZSgpIi8+CiAgICA8L3hzbDppZj4K
ICAgIDx4c2w6YXBwbHktdGVtcGxhdGVzIHNlbGVjdD0ibm9kZSgpIi8+CiAgPC94c2w6dGVt
cGxhdGU+CgogIDwhLS0gZGVsZXRlIHRoZSBhY3Rpb25zIG9yIGNvbmRpdGlvbnMgY29udGFp
bmVycywgYW5kIHByb2Nlc3MgY2hpbGQgbm9kZXMgLS0+CiAgPHhzbDp0ZW1wbGF0ZSBtYXRj
aD0iaXB0YWJsZXMtcnVsZXMvdGFibGUvY2hhaW4vcnVsZS9hY3Rpb25zfHRhYmxlL2NoYWlu
L3J1bGUvY29uZGl0aW9ucyI+CiAgICA8eHNsOmFwcGx5LXRlbXBsYXRlcyBzZWxlY3Q9Iioi
Lz4KICA8L3hzbDp0ZW1wbGF0ZT4KCiAgPHhzbDp0ZW1wbGF0ZSBtYXRjaD0iaXB0YWJsZXMt
cnVsZXMvdGFibGUvY2hhaW4vcnVsZS9hY3Rpb25zL2dvdG8iPgogICAgPHhzbDp0ZXh0PiAt
ZyA8L3hzbDp0ZXh0PgogICAgPHhzbDphcHBseS10ZW1wbGF0ZXMgc2VsZWN0PSIqIi8+CiAg
ICA8eHNsOnRleHQ+JiN4QTs8L3hzbDp0ZXh0PgogIDwveHNsOnRlbXBsYXRlPgogIDx4c2w6
dGVtcGxhdGUgbWF0Y2g9ImlwdGFibGVzLXJ1bGVzL3RhYmxlL2NoYWluL3J1bGUvYWN0aW9u
cy9jYWxsIj4KICAgIDx4c2w6dGV4dD4gLWogPC94c2w6dGV4dD4KICAgIDx4c2w6YXBwbHkt
dGVtcGxhdGVzIHNlbGVjdD0iKiIvPgogICAgPHhzbDp0ZXh0PiYjeEE7PC94c2w6dGV4dD4K
ICA8L3hzbDp0ZW1wbGF0ZT4KICA8IS0tIGFsbCBvdGhlciBhY3Rpb25zIGFyZSBtb2R1bGUg
YWN0aW9ucyAtLT4KICA8eHNsOnRlbXBsYXRlIG1hdGNoPSJpcHRhYmxlcy1ydWxlcy90YWJs
ZS9jaGFpbi9ydWxlL2FjdGlvbnMvKiI+CiAgICA8eHNsOnRleHQ+IC1qIDwveHNsOnRleHQ+
PHhzbDp2YWx1ZS1vZiBzZWxlY3Q9Im5hbWUoKSIvPgogICAgPHhzbDphcHBseS10ZW1wbGF0
ZXMgc2VsZWN0PSIqIi8+CiAgICA8eHNsOnRleHQ+JiN4QTs8L3hzbDp0ZXh0PgogIDwveHNs
OnRlbXBsYXRlPgogIAogIDwhLS0gYWxsIGNoaWxkIGFjdGlvbiBub2RlcyAtLT4KICA8eHNs
OnRlbXBsYXRlIG1hdGNoPSJpcHRhYmxlcy1ydWxlcy90YWJsZS9jaGFpbi9ydWxlL2FjdGlv
bnMvKi8qfGlwdGFibGVzLXJ1bGVzL3RhYmxlL2NoYWluL3J1bGUvYWN0aW9ucy8qLy8qfGlw
dGFibGVzLXJ1bGVzL3RhYmxlL2NoYWluL3J1bGUvY29uZGl0aW9ucy8qLyp8aXB0YWJsZXMt
cnVsZXMvdGFibGUvY2hhaW4vcnVsZS9jb25kaXRpb25zLyovLyoiPgogICAgPHhzbDppZiB0
ZXN0PSJAaW52ZXJ0PTEiPjx4c2w6dGV4dD4gITwveHNsOnRleHQ+PC94c2w6aWY+CiAgICA8
eHNsOnRleHQ+IC08L3hzbDp0ZXh0PgogICAgPCEtLSBpZiBsZW5ndGggb2YgbmFtZSBpcyAx
IGNoYXJhY3RlciwgdGhlbiBvbmx5IGRvIDEgLSBub3QgMiAtLT4KICAgIDx4c2w6aWYgdGVz
dD0ic3RyaW5nLWxlbmd0aChuYW1lKCkpJmd0OzEiPgogICAgICA8eHNsOnRleHQ+LTwveHNs
OnRleHQ+CiAgICA8L3hzbDppZj4KICAgIDx4c2w6dmFsdWUtb2Ygc2VsZWN0PSJuYW1lKCki
Lz4KICAgIDx4c2w6dGV4dD4gPC94c2w6dGV4dD48eHNsOnZhbHVlLW9mIHNlbGVjdD0iLiIv
PgogIDwveHNsOnRlbXBsYXRlPgoKICA8eHNsOnRlbXBsYXRlIG1hdGNoPSJpcHRhYmxlcy1y
dWxlcy90YWJsZS9jaGFpbi9ydWxlL2FjdGlvbnMvY2FsbC8qfGlwdGFibGVzLXJ1bGVzL3Rh
YmxlL2NoYWluL3J1bGUvYWN0aW9ucy9nb3RvLyoiPgogICAgPHhzbDp2YWx1ZS1vZiBzZWxl
Y3Q9Im5hbWUoKSIvPgogICAgPCEtLSBJIGJldCB0aGVyZSBhcmUgbm8gY2hpbGQgbm9kZXMs
IHNob3VsZCB3ZSByaXNrIGl0PyAtLT4KICAgIDx4c2w6YXBwbHktdGVtcGxhdGVzIHNlbGVj
dD0ibm9kZSgpIi8+CiAgPC94c2w6dGVtcGxhdGU+CgogIDwhLS0gb3V0cHV0IHRoZSBoZWFk
IG9mIHRoZSBydWxlLCBhbmQgYW55IGNvbmRpdGlvbnMgLS0+CiAgPHhzbDp0ZW1wbGF0ZSBu
YW1lPSJydWxlLWhlYWQiPgogICAgPHhzbDppZiB0ZXN0PSJzdHJpbmctbGVuZ3RoKEBwYWNr
ZXQtY291bnQpK3N0cmluZy1sZW5ndGgoQGJ5dGUtY291bnQpIj4KICAgICAgPHhzbDpjYWxs
LXRlbXBsYXRlIG5hbWU9ImNvdW50ZXJzIj48eHNsOndpdGgtcGFyYW0gbmFtZT0ibm9kZSIg
c2VsZWN0PSIuIi8+PC94c2w6Y2FsbC10ZW1wbGF0ZT4KICAgICAgPHhzbDp0ZXh0PiA8L3hz
bDp0ZXh0PgogICAgPC94c2w6aWY+CiAgICA8eHNsOnRleHQ+LUEgPC94c2w6dGV4dD48IS0t
IGEgcnVsZSBtdXN0IGJlIHVuZGVyIGEgY2hhaW4gLS0+CiAgICA8eHNsOnZhbHVlLW9mIHNl
bGVjdD0iLi4vQG5hbWUiIC8+CiAgICA8eHNsOmFwcGx5LXRlbXBsYXRlcyBzZWxlY3Q9ImNv
bmRpdGlvbnMiLz4KICA8L3hzbDp0ZW1wbGF0ZT4KCiAgPCEtLSBPdXRwdXQgYSBzaW5nbGUg
cnVsZSwgcGVyaGFwcyBhcyBtdWx0aXBsZSBydWxlcyBpZiB3ZSBoYXZlIG1vcmUgdGhhbiBv
bmUgYWN0aW9uIC0tPgogIDx4c2w6dGVtcGxhdGUgbWF0Y2g9ImlwdGFibGVzLXJ1bGVzL3Rh
YmxlL2NoYWluL3J1bGUiPgogICAgPHhzbDpjaG9vc2U+CiAgICAgIDx4c2w6d2hlbiB0ZXN0
PSJjb3VudChhY3Rpb25zLyopJmd0OzAiPgogICAgICAgIDx4c2w6Zm9yLWVhY2ggc2VsZWN0
PSJhY3Rpb25zLyoiPgogICAgICAgICAgPCEtLSBhbmQgYSBmb3ItZWFjaCB0byByZS1zZWxl
Y3QgdGhlIHJ1bGUgYXMgdGhlIGN1cnJlbnQgbm9kZSwgdG8gd3JpdGUgdGhlIHJ1bGUtaGVh
ZCAtLT4KICAgICAgICAgIDx4c2w6Zm9yLWVhY2ggc2VsZWN0PSIuLi8uLiI+CiAgICAgICAg
ICAgIDx4c2w6Y2FsbC10ZW1wbGF0ZSBuYW1lPSJydWxlLWhlYWQiLz4KICAgICAgICAgIDwv
eHNsOmZvci1lYWNoPgogICAgICAgICAgPCEtLSBub3cgd3JpdGUgdGhlIHRoaXMgYWN0aW9u
IC0tPgogICAgICAgICAgPHhzbDphcHBseS10ZW1wbGF0ZXMgc2VsZWN0PSIuIi8+CiAgICAg
ICAgPC94c2w6Zm9yLWVhY2g+CiAgICAgIDwveHNsOndoZW4+CiAgICAgIDx4c2w6b3RoZXJ3
aXNlPgogICAgICAgIDwhLS0gbm8gbmVlZCB0byBsb29wIGlmIHRoZXJlIGFyZSBubyBhY3Rp
b25zLCBqdXN0IG91dHB1dCBjb25kaXRpb25zIC0tPgogICAgICAgIDx4c2w6Y2FsbC10ZW1w
bGF0ZSBuYW1lPSJydWxlLWhlYWQiLz4KICAgICAgICA8eHNsOnRleHQ+JiN4QTs8L3hzbDp0
ZXh0PgogICAgICA8L3hzbDpvdGhlcndpc2U+CiAgICA8L3hzbDpjaG9vc2U+CiAgPC94c2w6
dGVtcGxhdGU+CgogIDx4c2w6dGVtcGxhdGUgbWF0Y2g9ImlwdGFibGVzLXJ1bGVzL3RhYmxl
Ij4KICAgIDx4c2w6dGV4dD4jIEdlbmVyYXRlZCBieSBpcHRhYmxlcy54c2x0JiN4QTs8L3hz
bDp0ZXh0PgogICAgPHhzbDp0ZXh0Pio8L3hzbDp0ZXh0Pjx4c2w6dmFsdWUtb2Ygc2VsZWN0
PSJAbmFtZSIvPjx4c2w6dGV4dD4mI3hBOzwveHNsOnRleHQ+CiAgICA8IS0tIExvb3AgdGhy
b3VnaCBlYWNoIGNoYWluIGFuZCBvdXRwdXQgdGhlIGNoYWluIGhlYWRlciAtLT4KICAgIDx4
c2w6Zm9yLWVhY2ggc2VsZWN0PSJjaGFpbiI+CiAgICAgIDx4c2w6dGV4dD46PC94c2w6dGV4
dD4KICAgICAgPHhzbDp2YWx1ZS1vZiBzZWxlY3Q9IkBuYW1lIi8+CiAgICAgIDx4c2w6dGV4
dD4gPC94c2w6dGV4dD4KICAgICAgPHhzbDpjaG9vc2U+CiAgICAgICAgPHhzbDp3aGVuIHRl
c3Q9Im5vdChzdHJpbmctbGVuZ3RoKEBwb2xpY3kpKSI+PHhzbDp0ZXh0Pi08L3hzbDp0ZXh0
PjwveHNsOndoZW4+CiAgICAgICAgPHhzbDpvdGhlcndpc2U+PHhzbDp2YWx1ZS1vZiBzZWxl
Y3Q9IkBwb2xpY3kiLz48L3hzbDpvdGhlcndpc2U+CiAgICAgIDwveHNsOmNob29zZT4KICAg
ICAgPHhzbDp0ZXh0PiA8L3hzbDp0ZXh0PgogICAgICA8eHNsOmNhbGwtdGVtcGxhdGUgbmFt
ZT0iY291bnRlcnMiPjx4c2w6d2l0aC1wYXJhbSBuYW1lPSJub2RlIiBzZWxlY3Q9Ii4iLz48
L3hzbDpjYWxsLXRlbXBsYXRlPgogICAgICA8eHNsOnRleHQ+JiN4QTs8L3hzbDp0ZXh0Pgog
ICAgPC94c2w6Zm9yLWVhY2g+CiAgICA8IS0tIExvb3AgdGhyb3VnaCBlYWNoIGNoYWluIGFu
ZCBvdXRwdXQgdGhlIHJ1bGVzIC0tPgogICAgPHhzbDphcHBseS10ZW1wbGF0ZXMgc2VsZWN0
PSJub2RlKCkiLz4KICAgIDx4c2w6dGV4dD5DT01NSVQmI3hBOyMgQ29tcGxldGVkJiN4QTs8
L3hzbDp0ZXh0PgogIDwveHNsOnRlbXBsYXRlPgogIAogIDx4c2w6dGVtcGxhdGUgbmFtZT0i
Y291bnRlcnMiPgogICAgPHhzbDpwYXJhbSBuYW1lPSIkbm9kZSIvPgogICAgPHhzbDp0ZXh0
Pls8L3hzbDp0ZXh0PgogICAgPHhzbDppZiB0ZXN0PSJzdHJpbmctbGVuZ3RoKCRub2RlL0Bw
YWNrZXQtY291bnQpIj48eHNsOnZhbHVlLW9mIHNlbGVjdD0iJG5vZGUvQHBhY2tldC1jb3Vu
dCIvPjwveHNsOmlmPgogICAgPHhzbDppZiB0ZXN0PSJzdHJpbmctbGVuZ3RoKCRub2RlL0Bw
YWNrZXQtY291bnQpPTAiPjA8L3hzbDppZj4KICAgIDx4c2w6dGV4dD46PC94c2w6dGV4dD4K
ICAgIDx4c2w6aWYgdGVzdD0ic3RyaW5nLWxlbmd0aCgkbm9kZS9AYnl0ZS1jb3VudCkiPjx4
c2w6dmFsdWUtb2Ygc2VsZWN0PSIkbm9kZS9AYnl0ZS1jb3VudCIvPjwveHNsOmlmPgogICAg
PHhzbDppZiB0ZXN0PSJzdHJpbmctbGVuZ3RoKCRub2RlL0BieXRlLWNvdW50KT0wIj4wPC94
c2w6aWY+CiAgICA8eHNsOnRleHQ+XTwveHNsOnRleHQ+CiAgPC94c2w6dGVtcGxhdGU+ICAK
ICAKICA8IS0tIHRoZSBiaXQgdGhhdCBhdXRvbWF0aWNhbGx5IHJlY3Vyc2VzIGZvciB1cywg
Tk9URTogd2UgdXNlICogbm90IG5vZGUoKSwgd2UgZG9uJ3Qgd2FudCB0byBjb3B5IGV2ZXJ5
IHdoaXRlIHNwYWNlIHRleHQgLS0+CiAgPHhzbDp0ZW1wbGF0ZSBtYXRjaD0iQCp8bm9kZSgp
Ij4KICAgIDx4c2w6Y29weT4KICAgICAgPCEtLSB3aXRoIGxpYnhzbHQgeHNsdHByb2Mgd2Ug
Y2FuJ3QgZG8gQCp8bm9kZSgpIG9yIHRoZSBub2RlcyBtYXkgZ2V0IHByb2Nlc3NlZCBiZWZv
cmUgdGhlIGF0dHJpYnV0ZXMgLS0+CiAgICAgIDx4c2w6YXBwbHktdGVtcGxhdGVzIHNlbGVj
dD0iQCoiLz4KICAgICAgPHhzbDphcHBseS10ZW1wbGF0ZXMgc2VsZWN0PSJub2RlKCkiLz4K
ICAgIDwveHNsOmNvcHk+CiAgPC94c2w6dGVtcGxhdGU+Cgo8L3hzbDp0cmFuc2Zvcm0+Cg==
--------------040608000805080106080301--
