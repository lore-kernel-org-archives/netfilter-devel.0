From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: Re: ipt_ACCOUNT 1.15 released
Date: Wed, 15 Apr 2009 10:11:41 +0200
Message-ID: <200904151011.42360.thomas.jarosch@intra2net.com>
References: <200904141744.57570.thomas.jarosch@intra2net.com> <alpine.LSU.2.00.0904141807430.21682@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, siarka2107@interia.pl
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from re01.intra2net.com ([82.165.28.202]:46520 "EHLO
	re01.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbZDOILp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Apr 2009 04:11:45 -0400
In-Reply-To: <alpine.LSU.2.00.0904141807430.21682@fbirervta.pbzchgretzou.qr>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jan,

On Tuesday, 14. April 2009 18:10:54 Jan Engelhardt wrote:
> guess I just forward this to you, as I do not want to touch ACCOUNT
> just yet.

As you already mentioned, I'm not sure it would be a good idea
to include it as the kernel patch extends the kernel<->user space socket 
operations in include/linux/netfilter_ipv4/ip_tables.h.

"ipt_account" is another story as it works differently.
The lastest patch seems to be for 2.6.19 / iptables 1.3.5,
though there is some recent activity on the project homepage.

I'm still surprised how many people are using ipt_ACCOUNT,
somehow it is magnetic to ISPs in central and eastern europe :-)

> >Can You prepare ipt_ACCOUNT and ipt_account patches/files supported for
> >kernel 2.6.29?

ipt_ACCOUNT is now ready for 2.6.29.

Cheers,
Thomas

