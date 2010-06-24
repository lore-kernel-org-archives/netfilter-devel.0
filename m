From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 2/3] netfilter: xt_connbytes: Force CT accounting to be
 enabled
Date: Thu, 24 Jun 2010 19:15:19 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1006241915040.324@obet.zrqbmnf.qr>
References: <1277393257-15281-1-git-send-email-tim.gardner@canonical.com> <1277393257-15281-3-git-send-email-tim.gardner@canonical.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org
To: Tim Gardner <tim.gardner@canonical.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:38576 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751546Ab0FXRPU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Jun 2010 13:15:20 -0400
In-Reply-To: <1277393257-15281-3-git-send-email-tim.gardner@canonical.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2010-06-24 17:27, Tim Gardner wrote:
>diff --git a/net/netfilter/xt_connbytes.c b/net/netfilter/xt_connbytes.c
>index 7351783..b0cda8c 100644
>--- a/net/netfilter/xt_connbytes.c
>+++ b/net/netfilter/xt_connbytes.c
>@@ -112,6 +112,16 @@ static int connbytes_mt_check(const struct xt_mtchk_param *par)
> 	if (ret < 0)
> 		pr_info("cannot load conntrack support for proto=%u\n",
> 			par->family);
>+
>+	/*
>+	 * This filter cannot function correctly unless connection tracking
>+	 * accounting is enabled, so complain in the hope that someone notices.
>+	 */
>+	if (nf_ct_acct_enabled(par) == false) {

	if (!nfct_acct_enabled(par)) {

>+		pr_warning("Forcing CT accounting to be enabled\n");
>+		nf_ct_set_acct(par, true);
>+	}
>+
> 	return ret;
> }
