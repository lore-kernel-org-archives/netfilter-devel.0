From: John Fastabend <jfastabe@up.edu>
Subject: iptables shared library compiling error
Date: Wed, 31 Mar 2004 00:43:40 -0800 (PST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0403310026460.19914-100000@lhotse.up.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


hello,

im new to kernel programming and netfilters so hopefully this isn't to 
dumb of a question.  I've been trying to program an extension module for 
iptables, but i keep getting all kinds of compiler errors that i cant 
figure out and was hoping for a little help.  I read the how-to's and as 
far as i can tell my code looks like the sample extension shared 
libraries.  below is my source code and compiler output.  If someone has 
the time to help me that would be greatly appreciated. Thank you for your 
time and sorry about the long post.


Here are the compiler errors

pseudo@nitbit kernrouter $ gcc -fPIC libipt_CHANGEIP.c
In file included from libipt_CHANGEIP.c:10:
/usr/include/iptables.h:4:29: iptables_common.h: No such file or directory
/usr/include/iptables.h:5:29: libiptc/libiptc.h: No such file or directory
In file included from libipt_CHANGEIP.c:10:
/usr/include/iptables.h:12: parse error before "ipt_chainlabel"
/usr/include/iptables.h:57: parse error before '}' token
/usr/include/iptables.h:63: parse error before "ipt_chainlabel"
/usr/include/iptables.h:77: conflicting types for `init'
/usr/include/iptables.h:26: previous declaration of `init'
/usr/include/iptables.h:83: conflicting types for `parse'
/usr/include/iptables.h:33: previous declaration of `parse'
/usr/include/iptables.h:90: conflicting types for `print'
/usr/include/iptables.h:40: previous declaration of `print'
/usr/include/iptables.h:94: conflicting types for `save'
/usr/include/iptables.h:44: previous declaration of `save'
/usr/include/iptables.h:97: conflicting types for `extra_opts'
/usr/include/iptables.h:47: previous declaration of `extra_opts'
/usr/include/iptables.h:107: parse error before '}' token
/usr/include/iptables.h:125: parse error before "iptc_handle_t"
/usr/include/iptables.h:139: parse error before "chain"
/usr/include/iptables.h:141: parse error before "chain"
/usr/include/iptables.h:143: parse error before "iptc_handle_t"
/usr/include/iptables.h:144: parse error before "iptc_handle_t"
libipt_CHANGEIP.c:21: `help' redeclared as different kind of symbol
/usr/include/iptables.h:74: previous declaration of `help'
libipt_CHANGEIP.c:38: `init' redeclared as different kind of symbol
/usr/include/iptables.h:77: previous declaration of `init'
libipt_CHANGEIP.c:54: `parse' redeclared as different kind of symbol
/usr/include/iptables.h:83: previous declaration of `parse'
libipt_CHANGEIP.c: In function `parse':
libipt_CHANGEIP.c:63: `PARAMETER_PROBLEM' undeclared (first use in this 
function)
libipt_CHANGEIP.c:63: (Each undeclared identifier is reported only once
libipt_CHANGEIP.c:63: for each function it appears in.)
libipt_CHANGEIP.c: At top level:
libipt_CHANGEIP.c:86: `final_check' redeclared as different kind of symbol
/usr/include/iptables.h:86: previous declaration of `final_check'
libipt_CHANGEIP.c:97: `print' redeclared as different kind of symbol
/usr/include/iptables.h:90: previous declaration of `print'
libipt_CHANGEIP.c:104: `save' redeclared as different kind of symbol
/usr/include/iptables.h:94: previous declaration of `save'
libipt_CHANGEIP.c:108: variable `changeip' has initializer but incomplete 
type
libipt_CHANGEIP.c:108: warning: excess elements in struct initializer
libipt_CHANGEIP.c:108: warning: (near initialization for `changeip')
libipt_CHANGEIP.c:109: warning: excess elements in struct initializer
libipt_CHANGEIP.c:109: warning: (near initialization for `changeip')
libipt_CHANGEIP.c:110: warning: excess elements in struct initializer
libipt_CHANGEIP.c:110: warning: (near initialization for `changeip')
libipt_CHANGEIP.c:111: warning: excess elements in struct initializer
libipt_CHANGEIP.c:111: warning: (near initialization for `changeip')
libipt_CHANGEIP.c:112: warning: excess elements in struct initializer
libipt_CHANGEIP.c:112: warning: (near initialization for `changeip')
libipt_CHANGEIP.c:113: warning: excess elements in struct initializer
libipt_CHANGEIP.c:113: warning: (near initialization for `changeip')
libipt_CHANGEIP.c:114: warning: excess elements in struct initializer
libipt_CHANGEIP.c:114: warning: (near initialization for `changeip')
libipt_CHANGEIP.c:115: warning: excess elements in struct initializer
libipt_CHANGEIP.c:115: warning: (near initialization for `changeip')
libipt_CHANGEIP.c:116: warning: excess elements in struct initializer
libipt_CHANGEIP.c:116: warning: (near initialization for `changeip')
libipt_CHANGEIP.c:117: warning: excess elements in struct initializer
libipt_CHANGEIP.c:117: warning: (near initialization for `changeip')
libipt_CHANGEIP.c:118: warning: excess elements in struct initializer
libipt_CHANGEIP.c:118: warning: (near initialization for `changeip')
libipt_CHANGEIP.c:120: warning: excess elements in struct initializer
libipt_CHANGEIP.c:120: warning: (near initialization for `changeip')
libipt_CHANGEIP.c:108: storage size of `changeip' isn't known
pseudo@nitbit kernrouter $

,,,, And here's the code that made them ... :(


/* Shared library add-on to iptables to add CHANGEIP target support.
 * Author : John Fastabend, <jfastabe@up.edu>
 */

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <getopt.h>
#include <netinet/in.h>
#include <iptables.h>
#include <linux/netfilter_ipv4/ip_tables.h>
#include "ipt_CHANGEIP.h"

#define NOCLOBBER 0
#define CLOBBER   1

#define IPTABLES_VERSION 1.2
/* Function that prints out usage message */
static void 
help(void) 
{
	printf(
	 "ChangeIP target v \n"
	 "     --dip     \tip \t\t Change destination IP\n"
	 "     --sip     \tip \t\t Change source IP\n"
	 "     --continue\t   \t\t Let packet continue traversal\n"
	 "\n");
}

static struct option opts[] = {
	{"dip", 1, 0, '1' },
	{"sip", 1, 0, '2' },
	{"clobber",0,0,'3'},
	{ 0 }
};

static void init 
(struct ipt_entry_target *t , unsigned int *nfcache ){
    struct ipt_changeip_target_info *ipinfo = 
               (struct ipt_changeip_target_info*)t->data;

    ipinfo->clobber = NOCLOBBER;
    ipinfo->dip.s_addr = 0;
    ipinfo->sip.s_addr = 0;

 }



static int parse(int c, char **argv, int invert, 
		 unsigned int *flags,
		 const struct ipt_entry *entry, 
		 struct ipt_entry_target **target)
{
~	struct ipt_changeip_target_info *ipinfo = 
	                 (struct ipt_changeip_target_info 
*)(*target)->data;

	/*if(entry->ip.proto != IPT_IP)
		exit_error(PARAMETER_PROBLEM, "Needs to be an ip packet");
*/
	switch (c){
	case '1':
		if(*flags) exit_error(PARAMETER_PROBLEM,
			"Only one destination ip allowed");
		ipinfo->dip.s_addr = inet_addr(optarg);
		*flags =1;
	        break;				
	case '2':
		if(*flags) exit_error(PARAMETER_PROBLEM,
		  	"Only one src ip allowed");
		ipinfo->sip.s_addr = inet_addr(optarg);
		*flags = 1;
		break;
	case '3':
	 	if(*flags) exit_error(PARAMETER_PROBLEM,
			"Syntax messed up");
		ipinfo->clobber = 1;
		break;

	default: return 0;
	}

	return 1;
}

static void final_check(unsigned int flags){
	if(!flags)
		exit_error(/*PARAMETER_PROBLEM,*/
			"Must have either source or destination ip to 
change");
	
}


static void print (const struct ipt_ip *ip,
		   const struct ipt_entry_target *target,
		   int numeric)
{
	const struct ipt_changeip_target_info *ipinfo 
	 		= (const struct ipt_changeip_target_info 
*)target->data; 
	printf("Changing IP");	       
}

static void save(const struct ipt_ip *ip, const struct ipt_entry_target 
*target)
{

}

static struct iptables_target changeip = { NULL,
    "CHANGEIP",
    IPTABLES_VERSION,
    IPT_ALIGN(sizeof(struct ipt_changeip_target_info) ),
    IPT_ALIGN(sizeof(struct ipt_changeip_target_info) ),
    &help,
    &init,
    &parse,
    &final_check,
    &print,
    &save,
    opts
};

void __init(void)
{
	register_target(&changeip);
}




Any hints would help! thanks
john


~


-- 
--
"Dependence on computers is apparently making a significant fraction
of the population incurably stupid." -- Fritz Whittington
