From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] ebtables: Clone xt_AUDIT to ebt_audit to return
 EBT_CONTINUE
Date: Wed, 16 Mar 2011 01:43:42 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1103160138160.1189@obet.zrqbmnf.qr>
References: <20110316003307.GB26145@canuck.infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org
To: Thomas Graf <tgraf@infradead.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:41626 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753460Ab1CPAnn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Mar 2011 20:43:43 -0400
In-Reply-To: <20110316003307.GB26145@canuck.infradead.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 2011-03-16 01:33, Thomas Graf wrote:

>Even though ebtables uses xtables it still requires targets to
>return EBT_CONTINUE instead of XT_CONTINUE. This prevented
>xt_AUDIT to work as ebt module.

Something that just came to mind is that you could probably do
to keep the code at a minimum:


static unsigned int ebt_audit(struct xt_target_param *par)
{
	unsigned int ret = xt_audit_tg(par);

	if (ret == XT_CONTINUE)
		return EBT_CONTINUE;
	...
}

static struct xt_target audit_tg_reg[] = {
	{
		.name = "AUDIT",
		.family = NFPROTO_UNSPEC,
		.target = xt_audit_tg,
	},
	{
		.name = "AUDIT",
		.family = NFPROTO_BRIDGE,
		.target = ebt_audit_tg,
	},
};
