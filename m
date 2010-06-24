From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 1/3] netfilter: Expose connection tracking accounting
 toggles
Date: Thu, 24 Jun 2010 19:14:40 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1006241913591.324@obet.zrqbmnf.qr>
References: <1277393257-15281-1-git-send-email-tim.gardner@canonical.com> <1277393257-15281-2-git-send-email-tim.gardner@canonical.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org
To: Tim Gardner <tim.gardner@canonical.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:38562 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751799Ab0FXROp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Jun 2010 13:14:45 -0400
In-Reply-To: <1277393257-15281-2-git-send-email-tim.gardner@canonical.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2010-06-24 17:27, Tim Gardner wrote:
> 
>+/* Check if connection tracking accounting is enabled */
>+static inline bool nf_ct_acct_enabled(const struct xt_mtchk_param *par)
>+{
>+	return par->net->ct.sysctl_acct == 0 ? false : true;
>+}

The ? false : true part is pretty redundant. Just write

	return par->net->ct.sysctl_acct != 0;
>+
>+/* Enable/disable connection tracking accounting */
>+static inline void nf_ct_set_acct(const struct xt_mtchk_param *par, bool enable)
>+{
>+	par->net->ct.sysctl_acct = enable == true ? 1 : 0;

par->net->ct.sysctl_acct = enable;


>+}
>+
> extern int nf_conntrack_acct_init(struct net *net);
> extern void nf_conntrack_acct_fini(struct net *net);
> 
>-- 
>1.7.0.4
>
>--
>To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

