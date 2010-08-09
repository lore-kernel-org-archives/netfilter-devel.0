From: Jon E <je_nfd@hotmail.com>
Subject: Help! Stuck while porting table code from older to recent kernel
Date: Mon, 9 Aug 2010 12:20:08 -0400
Message-ID: <SNT135-w26664576B07E441CEE789BF3940@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from snt0-omc1-s33.snt0.hotmail.com ([65.55.90.44]:2788 "EHLO
	snt0-omc1-s33.snt0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756379Ab0HIQ0T convert rfc822-to-8bit
	(ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Aug 2010 12:26:19 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hi,
 
I'm porting an app from the older version of netfilter from kernel 2.620 to the current Ubuntu LL kernel (2.6.32).  I noticed a lot of changes in the code and wondered if you could shed some light as to how to port (or point me to a porting guide).  
 
For example, ipt_register_table now contains a struct net* as the first parameter.  We didn't require this before, our code simply read:
 
static int __init init(void)
{
    int ret;
    /* Register table */
    ret = ipt_register_table(&packet_manipulator, &initial_table.repl);
 
I downloaded the source fpr kernel 2.6.32 and examined the iptable_mangle.c code to try and see how things are now done.  I noticed that the net->ipv4 struct contains specific struct xt_table xx entries (from /usr/src/linux-headers-2.6.32-24-generic/include/net/netns/ipv4.h) for the listed tables and there doesn't appear to be a mechanism by which a new table can be added (ie: it looks like the tables one can use are now hard-coded into the ipv4 struct).  The netfilter hacking doc doesn't help since it doesn't contain any updated information on the struct net* requirement.
 
So, my primary question is, how can I add a new table under the current framework?
 
Related: why was the struct net* requirement added?  Ie: what problem did it solve?  Only asking 'cause I can't find any docs describing the requirements.
 
As well, how can I use the xt_register_table function (and other xt_xx replacement functions) - the signatures are different (from the ipt_xx functions) and I'm not sure what to supply for the different parameters (or, should we be using these at all?).  I've tried searching for current iptables 'howto' docs but noone has updated anything since 2002 (that I can find, anyway).
 
Any thoughts on how I can update the code would be appreciated!
 
Cheers! 		 	   		  