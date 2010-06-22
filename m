From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 2/3] netfilter: xt_connbytes: Force CT tracking to be
 enabled
Date: Tue, 22 Jun 2010 18:49:37 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1006221847540.4850@obet.zrqbmnf.qr>
References: <1277225075-30428-1-git-send-email-tim.gardner@canonical.com> <1277225075-30428-3-git-send-email-tim.gardner@canonical.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org, ole@ans.pl
To: Tim Gardner <tim.gardner@canonical.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:56090 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755172Ab0FVQti (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Jun 2010 12:49:38 -0400
In-Reply-To: <1277225075-30428-3-git-send-email-tim.gardner@canonical.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>



On Tuesday 2010-06-22 18:44, tim.gardner@canonical.com wrote:
> net/netfilter/xt_connbytes.c |   13 ++++++++++++-
> 1 files changed, 12 insertions(+), 1 deletions(-)
>
>+	 * accounting is enabled, so complain about it until someone notices.
>+	 * It _should_ only print one warning message.
>+	 */
>+	if (unlikely(nf_ct_acct_enabled(ct) == false)) {
>+		if (net_ratelimit())
>+			pr_warning("ipt_connbytes: Force enabling CT accounting\n");
>+		nf_ct_set_acct(ct, true);
>+	}

Am I in a timewarp vortex? It's xt_connbytes, not ipt_connbytes.
Better yet, use KBUILD_MODNAME together with pr_fmt.
