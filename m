From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH 3/3] netfilter: nf_tables: enforce NLA_NUL_STRING in
 strings
Date: Mon, 31 Mar 2014 15:08:25 +0200
Message-ID: <20140331130825.GD4682@breakpoint.cc>
References: <1396266691-3538-1-git-send-email-pablo@netfilter.org>
 <1396266691-3538-3-git-send-email-pablo@netfilter.org>
 <20140331121551.GC4682@breakpoint.cc>
 <20140331124600.GA4335@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	kaber@trash.net, tgraf@suug.ch
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:52075 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752222AbaCaNI0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 31 Mar 2014 09:08:26 -0400
Content-Disposition: inline
In-Reply-To: <20140331124600.GA4335@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> I think you're right, a quick look at the users of this:
> 
> net/core/fib_rules.c:               nla_strcmp(tb[FRA_IIFNAME], rule->iifname))
> net/core/fib_rules.c:               nla_strcmp(tb[FRA_OIFNAME], rule->oifname))
> net/core/neighbour.c:           if (nla_strcmp(tb[NDTA_NAME], tbl->id) == 0)
> net/decnet/dn_dev.c:            if (tb[IFA_LABEL] && nla_strcmp(tb[IFA_LABEL], ifa->ifa_label))
> net/ipv4/devinet.c:             if (tb[IFA_LABEL] && nla_strcmp(tb[IFA_LABEL], ifa->ifa_label))
> net/netfilter/nf_tables_api.c:          if (!nla_strcmp(nla, table->name))
> net/netfilter/nf_tables_api.c:              !nla_strcmp(nla, chain_type[family][i]->name))
> net/netfilter/nf_tables_api.c:          if (!nla_strcmp(nla, chain->name))
> net/netfilter/nf_tables_api.c:          if (!nla_strcmp(nla, type->name) &&
> net/netfilter/nf_tables_api.c:          if (!nla_strcmp(nla, set->name))
> net/sched/act_api.c:                    if (nla_strcmp(kind, a->kind) == 0) {
> net/sched/cls_api.c:                    if (nla_strcmp(kind, t->kind) == 0) {
> net/sched/cls_api.c:    } else if (tca[TCA_KIND] && nla_strcmp(tca[TCA_KIND], tp->ops->kind))
> net/sched/sch_api.c:                    if (nla_strcmp(kind, q->id) == 0) {
> net/sched/sch_api.c:    if (tca[TCA_KIND] && nla_strcmp(tca[TCA_KIND], q->ops->id))
> net/sched/sch_api.c:                            if (tca[TCA_KIND] && nla_strcmp(tca[TCA_KIND], q->ops->id))
> net/sched/sch_api.c: nla_strcmp(tca[TCA_KIND], q->ops->id))))
> net/sched/sch_api.c:    if (tca[TCA_KIND] && nla_strcmp(tca[TCA_KIND], q->ops->id
> 
> In the current iproute2 tree: /ip/ipntable.c:
> 
>         len = strlen(namep) + 1;
>         addattr_l(&req.n, sizeof(req), NDTA_NAME, namep, len)
> 
> from ip/ipaddress.c:
> 
> addattr_l(&req.n, sizeof(req), IFA_LABEL, l, strlen(l)+1)
> 
> They are indeed including the nul-termination, that's why the
> comparison is working.
> I don't find any validation for TCA_KIND though, but that nla_strcmp
> is implicitly enforcing the nul-termination, otherwise will return a
> mismatch.

You're right, aliasing it to nla_memcmp would break iproute2.

So looks like we'd have to add backwards compat to nla_strcmp and check if the last
byte of nla data is a zero byte to catch this.

Lets see if Thomas has a better idea.
