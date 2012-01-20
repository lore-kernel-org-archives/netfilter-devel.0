From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: xtables2 a8, netlink interface
Date: Fri, 20 Jan 2012 09:33:12 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1201200931340.29049@frira.zrqbmnf.qr>
References: <1326990381-14534-1-git-send-email-jengelh@medozas.de> <20120119165629.2f7c8112@nehalam.linuxnetplumber.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
To: Stephen Hemminger <shemminger@vyatta.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:34043 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751953Ab2ATIdP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Jan 2012 03:33:15 -0500
In-Reply-To: <20120119165629.2f7c8112@nehalam.linuxnetplumber.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday 2012-01-20 01:56, Stephen Hemminger wrote:
>> 
>> So here is the first set of patches implementing part of the xt2 core
>> and nfnl interface. Please review, I am sure you will have something
>> to say :)
>> 
>> The userspace part is at git://dev.medozas.de/libnetfilter_xtables,
>> the xtnl-test program compiled as part of the default make target
>> gives access to the kernel functions implemented by the patches.
>
>Does it allow for watching for iptables changes (notifications),
>similar to what is done for link, address, and qdisc changes?

It certainly does not look like a big deal to write it, so yes, I 
had that on my list of things to add. (Even though I could not come up 
with a usecase for that feature myself yet.)
