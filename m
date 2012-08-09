From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH 2/7] extensions: add IPv6 MASQUERADE extension
Date: Thu, 9 Aug 2012 23:18:05 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1208092310250.10514@frira.zrqbmnf.qr>
References: <1344543073-11660-1-git-send-email-kaber@trash.net> <1344543073-11660-3-git-send-email-kaber@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([5.9.24.206]:35645 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750791Ab2HIVSG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Aug 2012 17:18:06 -0400
In-Reply-To: <1344543073-11660-3-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2012-08-09 22:11, kaber@trash.net wrote:
>+static void MASQUERADE_help(void)
>+{
>+	printf(
>+"MASQUERADE target options:\n"
>+" --to-ports <port>[-<port>]\n"
>+"				Port (range) to map to.\n"
>+" --random\n"
>+"				Randomize source port.\n");
>+}
>+
>+static const struct xt_option_entry MASQUERADE_opts[] = {
>+	{.name = "to-ports", .id = O_TO_PORTS, .type = XTTYPE_STRING},
>+	{.name = "random", .id = O_RANDOM, .type = XTTYPE_NONE},
>+	XTOPT_TABLEEND,
>+};

You could use .type = XTTYPE_PORTRC (port range)...
though arguably iptables already did a bad job at selecting
a suitable syntax for ranges.


>+/* Parses ports */

I don't think such a comment is needed ;)

>+static struct xtables_target masquerade_tg_reg = {
>+	.name		= "MASQUERADE",
>+	.version	= XTABLES_VERSION,
>+	.family		= NFPROTO_IPV6,
>+	.size		= XT_ALIGN(sizeof(struct nf_nat_range)),
>+	.userspacesize	= XT_ALIGN(sizeof(struct nf_nat_range)),
>+	.help		= MASQUERADE_help,
>+	.x6_parse	= MASQUERADE_parse,
>+	.print		= MASQUERADE_print,
>+	.save		= MASQUERADE_save,
>+	.x6_options	= MASQUERADE_opts,
>+};

Is it perhaps feasible to rename libipt_DNAT.c to libxt_DNAT.c
and thus have the v4 and v6 parts in the same file? In userspace
we do not have to fear depending on ipv6.ko like for kernel modules.

