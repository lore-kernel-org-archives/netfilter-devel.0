From: Jesper Dangaard Brouer <hawk@diku.dk>
Subject: Re: [Fwd: Re: Shortcuts to counting rules?]
Date: Wed, 5 Nov 2008 21:36:39 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0811052133050.9289@ask.diku.dk>
References: <490B46F0.4010100@hp.com> <alpine.LNX.1.10.0810311906120.29079@fbirervta.pbzchgretzou.qr>
 <490B544B.50903@hp.com> <alpine.LNX.1.10.0811010209040.23833@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0811051922050.6949@ask.diku.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Netfilter Developers <netfilter-devel@vger.kernel.org>
To: Rick Jones <rick.jones2@hp.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mgw1.diku.dk ([130.225.96.91]:35636 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757448AbYKEUgn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 5 Nov 2008 15:36:43 -0500
In-Reply-To: <Pine.LNX.4.64.0811051922050.6949@ask.diku.dk>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


>>  On Friday 2008-10-31 19:54, Rick Jones wrote:
>> > 
>> >  Here is where I cop to being a luddite who prefers straight C to calling
>> >  system() :)

Using libiptc, here is the C-program you need:

--- cut here ---
#include <stdio.h>
#include <libiptc/libiptc.h>

main(int argc, char *argv[])
{
 	char *table = "filter";
 	const char             *chain;
 	const struct ipt_entry *rule;
 	iptc_handle_t handle = NULL;
 	unsigned int num_chains = 0;
 	unsigned int num_rules  = 0;

 	handle = iptc_init(table);
 	//dump_entries(handle);

 	chain = iptc_first_chain(&handle);
 	while (chain) {
 		//printf("Chain:%s\n", chain);
 		num_chains++;

 		rule = iptc_first_rule(chain, &handle);
 		while (rule) {
 			num_rules++;
 			rule = iptc_next_rule(rule, &handle);
 		}
 		//printf("Rules so far:%u\n", num_rules);

 		chain = iptc_next_chain(&handle);
 	}

 	printf("Number of chains:%u\n", num_chains);
 	printf("Number of rules:%u\n", num_rules);
}
--- cut here ---

~/git/iptables$  gcc count.c -o count libiptc/libiptc.a  -I./include

Cheers,
   Jesper Brouer

--
-------------------------------------------------------------------
MSc. Master of Computer Science
Dept. of Computer Science, University of Copenhagen
Author of http://www.adsl-optimizer.dk
-------------------------------------------------------------------
