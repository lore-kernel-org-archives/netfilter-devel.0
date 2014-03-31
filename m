From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 3/3] netfilter: nf_tables: enforce NLA_NUL_STRING in
 strings
Date: Mon, 31 Mar 2014 14:46:00 +0200
Message-ID: <20140331124600.GA4335@localhost>
References: <1396266691-3538-1-git-send-email-pablo@netfilter.org>
 <1396266691-3538-3-git-send-email-pablo@netfilter.org>
 <20140331121551.GC4682@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net, tgraf@suug.ch
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42230 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752154AbaCaMqI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 31 Mar 2014 08:46:08 -0400
Content-Disposition: inline
In-Reply-To: <20140331121551.GC4682@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Mar 31, 2014 at 02:15:51PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> 
> [cc'd Thomas ]
> 
> > nla_strcmp compares the string length plus one, so it's implicitly
> > including the nul-termination in the comparison.
> >  int nla_strcmp(const struct nlattr *nla, const char *str)
> >  {
> >         int len = strlen(str) + 1;
> >         ...
> > 		d = memcmp(nla_data(nla), str, len);
> 
> [..]
> 
> > However, if NLA_STRING is used, userspace can send us a string without
> > the null-termination. This is a problem since the nf_tables lookup
> > functions won't find any matching as the last byte may mismatch.
> > So we have to enforce that strings are nul-termination to avoid
> > mismatches.
> 
> Looks to me as if the real fix is:
> 
> int nla_strcmp(const struct nlattr *nla, const char *str)
> {
> 	return nla_memcmp(nla, str, strlen(str));
> }
> 
> [ better yet, add static inline wrapper for it ].

I think you're right, a quick look at the users of this:

net/core/fib_rules.c:               nla_strcmp(tb[FRA_IIFNAME], rule->iifname))
net/core/fib_rules.c:               nla_strcmp(tb[FRA_OIFNAME], rule->oifname))
net/core/neighbour.c:           if (nla_strcmp(tb[NDTA_NAME], tbl->id) == 0)
net/decnet/dn_dev.c:            if (tb[IFA_LABEL] && nla_strcmp(tb[IFA_LABEL], ifa->ifa_label))
net/ipv4/devinet.c:             if (tb[IFA_LABEL] && nla_strcmp(tb[IFA_LABEL], ifa->ifa_label))
net/netfilter/nf_tables_api.c:          if (!nla_strcmp(nla, table->name))
net/netfilter/nf_tables_api.c:              !nla_strcmp(nla, chain_type[family][i]->name))
net/netfilter/nf_tables_api.c:          if (!nla_strcmp(nla, chain->name))
net/netfilter/nf_tables_api.c:          if (!nla_strcmp(nla, type->name) &&
net/netfilter/nf_tables_api.c:          if (!nla_strcmp(nla, set->name))
net/sched/act_api.c:                    if (nla_strcmp(kind, a->kind) == 0) {
net/sched/cls_api.c:                    if (nla_strcmp(kind, t->kind) == 0) {
net/sched/cls_api.c:    } else if (tca[TCA_KIND] && nla_strcmp(tca[TCA_KIND], tp->ops->kind))
net/sched/sch_api.c:                    if (nla_strcmp(kind, q->id) == 0) {
net/sched/sch_api.c:    if (tca[TCA_KIND] && nla_strcmp(tca[TCA_KIND], q->ops->id))
net/sched/sch_api.c:                            if (tca[TCA_KIND] && nla_strcmp(tca[TCA_KIND], q->ops->id))
net/sched/sch_api.c: nla_strcmp(tca[TCA_KIND], q->ops->id))))
net/sched/sch_api.c:    if (tca[TCA_KIND] && nla_strcmp(tca[TCA_KIND], q->ops->id

In the current iproute2 tree: /ip/ipntable.c:

        len = strlen(namep) + 1;
        addattr_l(&req.n, sizeof(req), NDTA_NAME, namep, len)

from ip/ipaddress.c:

addattr_l(&req.n, sizeof(req), IFA_LABEL, l, strlen(l)+1)

They are indeed including the nul-termination, that's why the
comparison is working.

I don't find any validation for TCA_KIND though, but that nla_strcmp
is implicitly enforcing the nul-termination, otherwise will return a
mismatch.
