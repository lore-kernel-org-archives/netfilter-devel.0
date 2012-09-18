From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH] New Target Extension OBSF
Date: Tue, 18 Sep 2012 02:04:10 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1209180120530.22227@nerf07.vanv.qr>
References: <1347895271.27332.1.camel@kernel-host-rh6>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: aft <aftnix@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:41528 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932379Ab2IRAEM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Sep 2012 20:04:12 -0400
In-Reply-To: <1347895271.27332.1.camel@kernel-host-rh6>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2012-09-17 17:21, aft wrote:
>
>1) it encrypts UDP traffic.
>2) it adds false bytes(padding).
>
>Its purpose is to escape smarter DPIs which blocks certain kinds of
>packets by several heuristic methods.

But then why not use IPsec (udpencap), OpenVPN, or something?
After all, you do already need a cooperating peer to decrypt
your traffic, and hence might as well pick a _standardized_ solution.

If all you want is evading some DPI gateways, I guess even the
lowly XOR non-encryption scheme will sufficiently work.

>+static struct xt_target obsf_tg_reg[] __read_mostly = {
>+	{
>+		.name = "OBSF",
>+		.family = NFPROTO_UNSPEC,
>+		.target = obsf_tg,
>+		.checkentry = obsf_tg_check,
>+		.targetsize = sizeof(struct xt_OBSF_tginfo),
>+		.me = THIS_MODULE,
>+	},
>+	{
>+		.name = "OBSF",
>+		.revision = 1,
>+		.family = NFPROTO_UNSPEC,
>+		.target = obsf_tg_v1,
>+		.targetsize = sizeof(struct xt_OBSF_tginfo_v1),
>+		.checkentry = obsf_tg_check_v1,
>+		.me = THIS_MODULE,
>+	},
>+};

There is no need to use two revisions.

