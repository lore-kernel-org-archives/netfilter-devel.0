From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [RFC] generic CONNTRACK target
Date: Tue, 15 Jan 2008 13:27:42 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801151317010.30034@fbirervta.pbzchgretzou.qr>
References: <478B8B74.3070903@netfilter.org> <478B8DF1.3060503@netfilter.org>
 <478C5541.9050809@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Phil Oester <kernel@linuxace.com>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:35379 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858AbYAOM1n (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Jan 2008 07:27:43 -0500
In-Reply-To: <478C5541.9050809@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Jan 15 2008 07:40, Patrick McHardy wrote:
>
> This doesn't seem to actually consolidate any code, just put
> it all in one file and dispatch based on the desired operation.
> Whats the advantage over the existing modules?

I could imagine it is the "less .ko overhead" thing as I tried with 
xt_REJECT (12 kb, replacing a 24kb ipt_+ip6t_REJECT solution) and xt_ah.

Also, as noticed in http://lkml.org/lkml/2007/12/31/59, modules are 
aligned at page boundaries, which means

ipt_REJECT.ko 11121 bytes uses up 12288 bytes of RAM.
ip6t_REJECT.ko 12107 bytes also uses up 12288 bytes of RAM.
(All values on x86_32).
xt_REJECT.ko 14665 bytes would use just 16384 bytes of RAM,
though of course, as correctly noticed, it has the ugly runtime 
dependency on IPv6. While xt_CONNTRACK would not have this IPv6 
dependency, if people do not use IPv6 at all, they _save_ 4096 bytes.
It's really a tradeoff.

(Yes it shows that the ELF .ko header bloat should probably be reduced.)


> Another issue is that it merges all conntrack-related targets
> existing today, but as soon as we're going to add something
> new we're going to run into compatibility issues again and it
> will be easier to add a new module. I don't think the trouble
> is worth it as long as we have to suffer our crappy userspace
> interface.

I would have a third suggestion you can tinker with. It involves using 
separate struct xt_targetNameHere_tginfo for all submodules, so that all 
xt_CONNTRACK would do is code agglomeration rather than target 
combination. In other words:

struct xt_target xt_conntrack_tg_reg[] __read_mostly = {
	{
		.name = "NOTRACK",
		.targetsize = sizeof(struct xt_notrack_tginfo),
		...
	},
	{
		.name = "CONNMARK",
		.targetsize = sizeof(struct xt_connmark_tginfo),
		...
	},
};

This would at least leave the compatibility forest as-is, but be a 
benefit (either + or -) on RAM space (see above).
