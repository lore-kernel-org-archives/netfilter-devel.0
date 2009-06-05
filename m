From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 2/2] NFQUEUE: add new v1 version with queue-balance
 option
Date: Fri, 5 Jun 2009 15:30:15 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0906051528200.7950@fbirervta.pbzchgretzou.qr>
References: <1244164679-11032-1-git-send-email-fw@strlen.de> <1244164679-11032-3-git-send-email-fw@strlen.de> <alpine.LSU.2.00.0906051457160.17010@fbirervta.pbzchgretzou.qr> <20090605132707.GG29745@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:39915 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978AbZFENaN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Jun 2009 09:30:13 -0400
In-Reply-To: <20090605132707.GG29745@Chamillionaire.breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2009-06-05 15:27, Florian Westphal wrote:
>> >target4_v1{
>> >+	.revision	= 1,
>> >+	.name		= "NFQUEUE",
>> >+	.version	= XTABLES_VERSION,
>> >+	.size		= XT_ALIGN(sizeof(struct xt_NFQ_info_v1)),
>> >+	.userspacesize	= XT_ALIGN(sizeof(struct xt_NFQ_info_v1)),
>> >+	.help		= NFQUEUE_help_v1,
>> >+	.init		= NFQUEUE_init_v1,
>> >+	.parse		= NFQUEUE_parse_v1,
>> >+	.print		= NFQUEUE_print_v1,
>> >+	.save		= NFQUEUE_save_v1,
>> >+	.extra_opts	= NFQUEUE_opts_v1,
>> >+};
>> >+
>> >+static struct xtables_target nfqueue_target6_v1 = {
>> >+	.family		= NFPROTO_IPV6,
>> >+	.revision	= 1,
>> 
>> You can combine these two to NFPROTO_UNSPEC, like you did to v0,
>> is not it?
>
>Hm, v1 is tied to ipv4/6 on the kernel side, thats why I wanted to make
>this explicit here, too.

It is not needed. iptables's .family and the kernel's .family fields
are not linked in any way. That is why libxt_length.c can have
NFPROTO_UNSPEC even if the kernel's xt_length.c happens not to
(because it inspects L3proto-dependent headers).
