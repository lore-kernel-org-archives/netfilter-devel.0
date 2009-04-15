From: Thomas Jacob <jacob@internet24.de>
Subject: Re: ipt_ACCOUNT 1.15 released
Date: Wed, 15 Apr 2009 11:40:29 +0200
Message-ID: <1239788429.11865.20.camel@enterprise.ims-firmen.de>
References: <200904141744.57570.thomas.jarosch@intra2net.com>
	 <alpine.LSU.2.00.0904141807430.21682@fbirervta.pbzchgretzou.qr>
	 <200904151011.42360.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, siarka2107@interia.pl
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailout02.ims-firmen.de ([213.174.32.97]:56999 "EHLO
	mailout02.ims-firmen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841AbZDOKBo (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Apr 2009 06:01:44 -0400
In-Reply-To: <200904151011.42360.thomas.jarosch@intra2net.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 2009-04-15 at 10:11 +0200, Thomas Jarosch wrote:
> Hi Jan,
> 
> On Tuesday, 14. April 2009 18:10:54 Jan Engelhardt wrote:
> > guess I just forward this to you, as I do not want to touch ACCOUNT
> > just yet.
> 
> As you already mentioned, I'm not sure it would be a good idea
> to include it as the kernel patch extends the kernel<->user space socket 
> operations in include/linux/netfilter_ipv4/ip_tables.h.

I noticed this too, and the question for me is, do you really need
do things this way? Because that's really the only thing that requires
a kernel patch in your module. Ipset for instance doesn't anymore, but
I guess they've been "assigned" a permanent socket option number.... if
that could happen for your module: problem solved.

> "ipt_account" is another story as it works differently.
> The lastest patch seems to be for 2.6.19 / iptables 1.3.5,
> though there is some recent activity on the project homepage.
>
> I'm still surprised how many people are using ipt_ACCOUNT,
> somehow it is magnetic to ISPs in central and eastern europe :-)

One reason springs to mind, apart from the obvious "they were there
first" reason: 64 bit counters... your module only uses 32 bit counters
which is not really great if you all you want to do account traffic at
an ISP, because if you've got a fully loaded 100 Mbps-Port your counters
will overflow every 5 minutes, so one needs to write software
that can extract and adding up the accounting data by querying your
module very often (I just did that for a future project ;).

Also the other ipt_account allows saving and restoring the accounting
state, thereby allowing you to deal with crashes and reboots.

But as you say, ipt_account is not really supported anymore, so....

BTW, if you plan to add 64bit counters and maybe also IPv6 capability
I'd be very much willing to help ;)

