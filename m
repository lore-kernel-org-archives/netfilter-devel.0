From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: iptables 1.4.0 and Linux 2.4
Date: Tue, 1 Jan 2008 14:33:48 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801011431420.5137@fbirervta.pbzchgretzou.qr>
References: <x6fxxklbaj@gzp> <Pine.LNX.4.64.0712310346070.2093@fbirervta.pbzchgretzou.qr>
 <4778FAA5.3030406@trash.net> <Pine.LNX.4.64.0712311646250.28123@fbirervta.pbzchgretzou.qr>
 <47791440.8020706@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "Gabor Z. Papp" <gzp@papp.hu>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:59014 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753580AbYAANdt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Jan 2008 08:33:49 -0500
In-Reply-To: <47791440.8020706@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Dec 31 2007 17:09, Patrick McHardy wrote:
>> >     
>> So that means iptables-1.4.0 needs a kernel tree with nf_inet_addr,
>> and that's currently only in davem-net-2.6.25 and maybe a few other.
>
> Yes, seems like we need to release a bugfix release for 1.4.0. Not a big
> deal, I'll take care of that once I'm back home.
>

For a while now, I thought about renaming nf_inet_addr to inet_addr
(or something else), as this inet_addr compound comes in handy not
only in Netfilter, but also, for example, in xfrm.
(xfrm_address_t in <linux/xfrm.h>)
Then, userspace could start with using inet_addr (instead of doing
the nf_inet_addr fix now) and avoid the clutterance.
Opinions?
