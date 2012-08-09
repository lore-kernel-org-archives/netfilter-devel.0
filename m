From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH 3/7] extensions: add IPv6 SNAT extension
Date: Thu, 9 Aug 2012 23:28:27 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1208092326130.10514@frira.zrqbmnf.qr>
References: <1344543073-11660-1-git-send-email-kaber@trash.net> <1344543073-11660-4-git-send-email-kaber@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([5.9.24.206]:35726 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753544Ab2HIV22 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Aug 2012 17:28:28 -0400
In-Reply-To: <1344543073-11660-4-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2012-08-09 22:11, kaber@trash.net wrote:
>+
>+static const struct xt_option_entry SNAT_opts[] = {
>+	{.name = "to-source", .id = O_TO_SRC, .type = XTTYPE_STRING,
>+	 .flags = XTOPT_MAND | XTOPT_MULTI},

According to the IPv4 SNAT/DNAT manpage, support for multiple ranges
was removed after 2.6.10. Has this changed?
If not, XTOPT_MULTI seems misplaced.

>+	case O_TO_SRC:
>+		if (cb->xflags & F_X_TO_SRC) {
>+			if (!kernel_version)
>+				get_kernel_version();
>+			if (kernel_version > LINUX_VERSION(2, 6, 10))
>+				xtables_error(PARAMETER_PROBLEM,
>+					   "SNAT: Multiple --to-source not supported");

It certainly is misplaced. IPv6 S/DNAT did not exist in any form in 2.6.10,
so we do not need to do the version check here.

