From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Help! Stuck while porting table code from older to recent
 kernel
Date: Mon, 9 Aug 2010 19:58:52 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1008091955560.21619@obet.zrqbmnf.qr>
References: <SNT135-w26664576B07E441CEE789BF3940@phx.gbl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Jon E <je_nfd@hotmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:52869 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752813Ab0HIR65 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Aug 2010 13:58:57 -0400
In-Reply-To: <SNT135-w26664576B07E441CEE789BF3940@phx.gbl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2010-08-09 18:20, Jon E wrote:

>static int __init init(void)
>{
>    int ret;
>    /* Register table */
>    ret = ipt_register_table(&packet_manipulator, &initial_table.repl);

Why would you need another table anyway? That isn't something that's
lightly included.

>I downloaded the source fpr kernel 2.6.32 and examined the iptable_mangle.c
>code to try and see how things are now done. I noticed that the net->ipv4
>struct contains specific struct xt_table xx entries (from
>/usr/src/linux-headers-2.6.32-24-generic/include/net/netns/ipv4.h) for the
>listed tables and there doesn't appear to be a mechanism by which a new table
>can be added (ie: it looks like the tables one can use are now hard-coded into
>the ipv4 struct). The netfilter hacking doc doesn't help since it doesn't
>contain any updated information on the struct net* requirement.
> 
>So, my primary question is, how can I add a new table under the current
>framework?

You will have to forfeit the netns integration and use &init_net.

>Related: why was the struct net* requirement added?  Ie: what problem did it
>solve?

Different table contents in different containers (IIUC, openvz).

>As well, how can I use the xt_register_table function (and other xt_xx
>replacement functions) - the signatures are different (from the ipt_xx
>functions) and I'm not sure what to supply for the different parameters (or,
>should we be using these at all?). I've tried searching for current iptables
>'howto' docs but noone has updated anything since 2002 (that I can find,
>anyway).

xt_register_table is for exclusive internal use of {ip,ip6,etc}_register_table.

