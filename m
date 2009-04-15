From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: ipt_ACCOUNT 1.15 released
Date: Wed, 15 Apr 2009 10:55:36 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0904151053270.31771@fbirervta.pbzchgretzou.qr>
References: <200904141744.57570.thomas.jarosch@intra2net.com> <alpine.LSU.2.00.0904141807430.21682@fbirervta.pbzchgretzou.qr> <200904151011.42360.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, siarka2107@interia.pl
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:52739 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644AbZDOIzj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Apr 2009 04:55:39 -0400
In-Reply-To: <200904151011.42360.thomas.jarosch@intra2net.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2009-04-15 10:11, Thomas Jarosch wrote:
>Hi Jan,
>
>On Tuesday, 14. April 2009 18:10:54 Jan Engelhardt wrote:
>> guess I just forward this to you, as I do not want to touch ACCOUNT
>> just yet.
>
>As you already mentioned, I'm not sure it would be a good idea
>to include it as the kernel patch extends the kernel<->user space socket 
>operations in include/linux/netfilter_ipv4/ip_tables.h.
>
>"ipt_account" is another story as it works differently.
>The lastest patch seems to be for 2.6.19 / iptables 1.3.5,
>though there is some recent activity on the project homepage.

What the user wanted is moving the iptables modules 
(libipt_account.c/ACCOUNT.c) into Xt-a. The kernel patch would continue 
to be separate.

>I'm still surprised how many people are using ipt_ACCOUNT,
>somehow it is magnetic to ISPs in central and eastern europe :-)

Sometimes, ulogd is considered to big of a solution. Even I just use 
xt_quota2 for embedded devices that need to watch their kb limits 
set forth in their HSDPA link contract.
