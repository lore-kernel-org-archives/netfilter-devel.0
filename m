From: Rick Jones <rick.jones2@hp.com>
Subject: [Fwd: Re: Shortcuts to counting rules?]
Date: Fri, 31 Oct 2008 10:57:04 -0700
Message-ID: <490B46F0.4010100@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from g1t0029.austin.hp.com ([15.216.28.36]:47889 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353AbYJaR5h (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 31 Oct 2008 13:57:37 -0400
Received: from tardy.cup.hp.com (tardy.cup.hp.com [16.89.104.60])
	by g1t0029.austin.hp.com (Postfix) with ESMTP id D35E23855C
	for <netfilter-devel@vger.kernel.org>; Fri, 31 Oct 2008 17:57:06 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tardy.cup.hp.com (8.9.3 (PHNE_28810)/8.9.3 SMKit7.02) with ESMTP id KAA24733
	for <netfilter-devel@vger.kernel.org>; Fri, 31 Oct 2008 10:57:04 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Over in netfilter it was suggested I might ask the question(s) below in 
netfilter-devel.  I'd point at a archive for the base message and 
remainder of the thread but:

http://vger.kernel.org/vger-lists.html#netfilter

doesn't indicate one.  The end goal here is to teach netperf how to get 
a count of iptables rules in place in the kernel.  There was also a 
drifting question of whether or not strace should be taught about the 
getsockopt() options.

thanks,

rick jones

-------- Original Message --------
Subject: Re: Shortcuts to counting rules?
Date: Thu, 30 Oct 2008 18:26:02 -0700
From: Rick Jones <rick.jones2@hp.com>
To: netfilter@vger.kernel.org
CC: Philip Craig <philipc@snapgear.com>
References: <4908FDE9.7040006@hp.com>	<49090A3D.40102@snapgear.com> 
<4909E386.1000405@hp.com>	<490A0117.4090501@hp.com>

Rick Jones wrote:
> Rick Jones wrote:
> 
>> Philip Craig wrote:
>>
>>> The getsockopt() calls are part of the linux ABI.  Using them is safe.
>>> You just need to make sure you handle the case that they aren't
>>> implemented.
>>
>>
>>
>> Time to go find their documentation then I suppose.
> 
> 
> Looks like struct ipt_getinfo and ip6t_getinfo are only in header files 
> that come with "iptables-dev?"

Having found linux/netfilter_ipv4/ip_tables.h and its ipv6 counterpart,
I will confess to having an Emily Litella moment with the above.

In messing about further and at the risk of yet another emily litella
moment (I have no pride when I'm trying to learn something new :) with
what the getsockopt(IPT_SO_GET_INFO) returns vs what I get by iterating
with libiptc calls, I take it that I cannot just use num_entries from
ipt_getinfo but have to retrieve the entries and run through them
skipping over chain entries?

tardy:~/iptables-1.4.1.1# cc -o fw_count
fw_count.ctardy:~/iptables-1.4.1.1# ./fw_count
name is mangle valid is 1f num is 6 size is 916
name is nat valid is 19 num is 4 size is 620
name is filter valid is e num is 4 size is 620
firewalltype is 1, rulecount 14
tardy:~/iptables-1.4.1.1# cc -DHAVE_IT_ALL -Iinclude -Llibiptc -o
fw_count fw_count.c -liptc
tardy:~/iptables-1.4.1.1# ./fw_count
chain count 5
chain count 3
chain count 3
firewalltype is 1, rulecount 0

The "tardy" system has no rules defined, and there are five chains for
mangle and three each for nat and filter, but that leaves me with one -
is that expected?

tardy:~/iptables-1.4.1.1# cat fw_count.c
#if defined(HAVE_LIBIPTC_H) && defined(HAVE_IPTABLES_H) &&
defined(HAVE_LIBIPTC)
#define HAVE_IT_ALL
#endif

#include <errno.h>
#include <stdio.h>
#include <fcntl.h>
#include <stdlib.h>
#include <string.h>
#include <dlfcn.h>
#include <time.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>

#if defined(HAVE_IT_ALL)
#include "libiptc/libiptc.h"
#include "iptables.h"
#else
/* seems linux/netfilter_ipv4/ip_tables.h needs IFNAMSIZ and does not get
  * it on its own */
#include <net/if.h>
#include <linux/netfilter_ipv4/ip_tables.h>
/* need to consider IPv6 here at some point */
#endif

#define NETFW_UNKNOWN -1
#define NETFW_IPTABLES 1


#if defined(HAVE_IT_ALL)
static int
count_rules(iptc_handle_t *messiah) {

         const char *chain;
         const struct ipt_entry *rule;
         int count = 0;
         int chain_count = 0;
         chain = iptc_first_chain(messiah);
         while (chain) {
                 chain_count++;
                 rule = iptc_first_rule(chain,messiah);
                 while (rule) {
                         count++;
                         rule = iptc_next_rule(rule,messiah);
                 }
                 chain = iptc_next_chain(messiah);
         }
         printf("chain count %d\n",chain_count);
         return count;
}
#else
static int
count_rules(char *table) {

         struct ipt_getinfo info;

         static int sock = -1;;
         int len = sizeof(info);

         if (-1 == sock)
                 sock = socket(AF_INET,SOCK_RAW,IPPROTO_RAW);
         strncpy(info.name,table,IPT_TABLE_MAXNAMELEN);
         info.name[IPT_TABLE_MAXNAMELEN-1] = '\0';

         getsockopt(sock,SOL_IP,IPT_SO_GET_INFO,&info,&len);

         printf("name is %s valid is %x num is %d size is %d\n",
                 info.name,
                 info.valid_hooks,
                 info.num_entries,
                 info.size);

         return info.num_entries;
}

#endif


void
get_firewall_info(int *firewalltype, int *rulecount) {

#if defined(HAVE_IT_ALL)
         iptc_handle_t messiah;  /* handles, always handles */
#endif

         FILE *namesfile = NULL;
         char tablename[IPT_TABLE_MAXNAMELEN + 1];
         int mycount = 0;
         *firewalltype = NETFW_IPTABLES;
         *rulecount = -1;


         namesfile = fopen("/proc/net/ip_tables_names","r");
         if (!namesfile)
                 return;

         while (fgets(tablename,
                      sizeof(tablename),
                      namesfile)) {
                 /* no end of line is bad */
                 if (tablename[strlen(tablename) - 1] != '\n') {
                         /* we want to signal the problem somehow */
                         /* so set the rulecount to -1 always here */
                         *rulecount = -1;
                         return;
                 }
                 /* but we dont want to have one in our calls */
                 tablename[strlen(tablename) - 1] = '\0';
#if defined(HAVE_IT_ALL)
                 messiah = iptc_init(tablename);
                 mycount += count_rules(&messiah);
                 iptc_free(&messiah);
#else
                 mycount += count_rules(tablename);
#endif
         }
         *rulecount = mycount;
}

int
main(int argc, char *argv[]) {

         int firewalltype,rulecount;

         get_firewall_info(&firewalltype,&rulecount);
         printf("firewalltype is %d, rulecount
%d\n",firewalltype,rulecount);

         return 0;
}
--
To unsubscribe from this list: send the line "unsubscribe netfilter" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
