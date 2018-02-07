From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf 2/7] netfilter: x_tables: prefer pr_debug where
 possible
Date: Wed, 7 Feb 2018 20:15:29 +0100
Message-ID: <20180207191529.GF14261@breakpoint.cc>
References: <20180207134828.18691-1-fw@strlen.de>
 <20180207134828.18691-3-fw@strlen.de>
 <20180207170222.klnth4yebivljirc@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:40082 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754141AbeBGTSe (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Feb 2018 14:18:34 -0500
Content-Disposition: inline
In-Reply-To: <20180207170222.klnth4yebivljirc@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Wed, Feb 07, 2018 at 02:48:23PM +0100, Florian Westphal wrote:
> > prefer pr_debug for cases where error is usually not seen by users.
> > checkpatch complains due to lines > 80 but adding a newline doesn't
> > make things any more readable.
> > 
> > Signed-off-by: Florian Westphal <fw@strlen.de>
> > ---
> >  net/ipv4/netfilter/ipt_rpfilter.c  | 2 +-
> >  net/ipv6/netfilter/ip6t_rpfilter.c | 2 +-
> >  net/netfilter/xt_SECMARK.c         | 2 +-
> >  net/netfilter/xt_bpf.c             | 2 +-
> >  net/netfilter/xt_connlabel.c       | 2 +-
> >  net/netfilter/xt_ipcomp.c          | 2 +-
> >  net/netfilter/xt_ipvs.c            | 2 +-
> >  net/netfilter/xt_l2tp.c            | 2 +-
> >  net/netfilter/xt_recent.c          | 4 ++--
> >  net/netfilter/xt_socket.c          | 8 ++++----
> >  net/netfilter/xt_time.c            | 2 +-
> >  11 files changed, 15 insertions(+), 15 deletions(-)
> > 
> > diff --git a/net/ipv4/netfilter/ipt_rpfilter.c b/net/ipv4/netfilter/ipt_rpfilter.c
> > index 37fb9552e858..ffd1cf65af3a 100644
> > --- a/net/ipv4/netfilter/ipt_rpfilter.c
> > +++ b/net/ipv4/netfilter/ipt_rpfilter.c
> > @@ -105,7 +105,7 @@ static int rpfilter_check(const struct xt_mtchk_param *par)
> >  	const struct xt_rpfilter_info *info = par->matchinfo;
> >  	unsigned int options = ~XT_RPFILTER_OPTION_MASK;
> >  	if (info->flags & options) {
> > -		pr_info("unknown options encountered");
> > +		pr_debug("unknown options");
> 
> OK, so the idea is to use pr_debug() when it is unlikely to hit an
> error via iptables, right?

Yes, alternatively this pr_* could be removed.

Theoretically we could have some new version of iptables hat support
--rpfilter-foobar flag which would then trigger this -EINVAL.
