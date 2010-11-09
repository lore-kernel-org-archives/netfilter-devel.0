From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [arptables] rfc: add classify target
Date: Tue, 9 Nov 2010 21:28:09 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1011092121210.10710@obet.zrqbmnf.qr>
References: <20101107152636.56f62235@caresse> <alpine.LNX.2.01.1011071616150.21289@obet.zrqbmnf.qr> <4CD959D6.1090705@trash.net> <20101109161047.GB25549@sd-11162.dedibox.fr> <4CD98746.4050100@pandora.be> <20101109211834.4da8e412@caresse>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Bart De Schuymer <bdschuym@pandora.be>,
	Patrick McHardy <kaber@trash.net>,
	netfilter-devel@vger.kernel.org
To: Frederic Leroy <fredo@starox.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:55713 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754566Ab0KIU2K (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Nov 2010 15:28:10 -0500
In-Reply-To: <20101109211834.4da8e412@caresse>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2010-11-09 21:18, Frederic Leroy wrote:
>
>For the kernel part,I didn't add modalias command because the
>userspace don't work yet :
>
># ./arptables -A OUTPUT -o eth0 -j CLASSIFY --set-class 0:7
>x_tables: arp_tables: CLASSIFY target: used from hooks INPUT, but only
>usable from FORWARD/OUTPUT/POSTROUTING

Here we have a perfect example of the dentrimentality of code duplication.
Hooray for NF_ARP_* not matching NF_INET_*.

Alas, when I originally coded NFPROTO_UNSPEC wildcard support,
I allowed for same-rev overloading, as in:

static struct xt_target classify_tg_reg[] __read_mostly = {
	{
		.name       = "CLASSIFY",
		.revision   = 0,
		.family     = NFPROTO_UNSPEC,
		.table      = "mangle",
		.hooks      = (1 << NF_INET_LOCAL_OUT) | (1 << NF_INET_FORWARD) |
		              (1 << NF_INET_POST_ROUTING),
		.target     = classify_tg,
		.targetsize = sizeof(struct xt_classify_target_info),
		.me         = THIS_MODULE,
	},
	{
		.name       = "CLASSIFY",
		.revision   = 0,
		.family     = NFPROTO_ARP,
		.hooks      = (1 << NF_ARP_OUT) | (1 << NF_ARP_FORDWARD),
		.target     = classify_tg,
		.targetsize = sizeof(struct xt_classify_target_info),
		.me         = THIS_MODULE,
	},
};

This should nicely work around the NF_ARP_* hook number deviation
for the time being.
