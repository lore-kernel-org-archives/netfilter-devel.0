From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf 1/7] netfilter: x_tables: remove pr_info where possible
Date: Wed, 7 Feb 2018 20:14:16 +0100
Message-ID: <20180207191416.GE14261@breakpoint.cc>
References: <20180207134828.18691-1-fw@strlen.de>
 <20180207134828.18691-2-fw@strlen.de>
 <20180207170304.sqohdymzifoujlre@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:40074 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754446AbeBGTRV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Feb 2018 14:17:21 -0500
Content-Disposition: inline
In-Reply-To: <20180207170304.sqohdymzifoujlre@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Wed, Feb 07, 2018 at 02:48:22PM +0100, Florian Westphal wrote:
> > remove several pr_info messages that cannot be triggered with iptables.
> > 
> > Signed-off-by: Florian Westphal <fw@strlen.de>
> > ---
> >  net/ipv4/netfilter/ipt_ECN.c | 10 ++++------
> >  net/netfilter/xt_HL.c        | 13 +++----------
> >  net/netfilter/xt_LED.c       |  4 +---
> >  net/netfilter/xt_cgroup.c    |  4 +---
> >  4 files changed, 9 insertions(+), 22 deletions(-)
> > 
> > diff --git a/net/ipv4/netfilter/ipt_ECN.c b/net/ipv4/netfilter/ipt_ECN.c
> > index 270765236f5e..39ff167e6d86 100644
> > --- a/net/ipv4/netfilter/ipt_ECN.c
> > +++ b/net/ipv4/netfilter/ipt_ECN.c
> > @@ -98,14 +98,12 @@ static int ecn_tg_check(const struct xt_tgchk_param *par)
> >  	const struct ipt_ECN_info *einfo = par->targinfo;
> >  	const struct ipt_entry *e = par->entryinfo;
> >  
> > -	if (einfo->operation & IPT_ECN_OP_MASK) {
> > -		pr_info("unsupported ECN operation %x\n", einfo->operation);
> > +	if (einfo->operation & IPT_ECN_OP_MASK)
> 
> According to patch 2/7, these should be pr_debug(), or probably I'm
> misunderstanding something :-).

Right, there is no consistency in the tree currently.

I don't think we'll see any new options added to ipt_ECN, so I don't
think its worth having a pr_foo() for this.
