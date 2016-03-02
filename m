From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH v3] extensions: libxt_statistic: Add translation to nft
Date: Wed, 2 Mar 2016 13:10:33 +0100
Message-ID: <20160302121033.GA4348@breakpoint.cc>
References: <20160301204042.GA15382@sonyv>
 <20160302114611.GA3008@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Laura Garcia Liebana <nevola@gmail.com>,
	netfilter-devel@vger.kernel.org, shivanib134@gmail.com,
	fw@strlen.de, outreachy-kernel@googlegroups.com
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:52060 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753358AbcCBMKg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Mar 2016 07:10:36 -0500
Content-Disposition: inline
In-Reply-To: <20160302114611.GA3008@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Tue, Mar 01, 2016 at 09:40:45PM +0100, Laura Garcia Liebana wrote:
> > Add translation for random mode to nftables. The nth mode is not
> > supported yet.
> > 
> > Examples:
> > 
> > $ iptables-translate -A INPUT -m statistic --mode random --probability
> > 0.1 -j ACCEPT
> > nft add rule ip filter INPUT meta random 0.10000000009 counter accept
> 
> Is this translation correct?

Yes.

> I can see in 
> 
> static bool
> statistic_mt(const struct sk_buff *skb, struct xt_action_param *par)
> {
>         const struct xt_statistic_info *info = par->matchinfo;
>         bool ret = info->flags & XT_STATISTIC_INVERT;
>         int nval, oval;
> 
>         switch (info->mode) {
>         case XT_STATISTIC_MODE_RANDOM:
>                 if ((prandom_u32() & 0x7FFFFFFF) < info->u.random.probability)
> 
> --probability seems to check for "less than" the random value.

Yes.

> I think meta random 0.10000000009 will only match for the exact case.

No; I thought that 'nft ... meta random 0.5' should on average match half of
the time so the proposed nft prandom patch set makes LE the default op.

So meta random 0.1 is in fact 'meta random le 0.1' (and nft will display
it like this).

> > $ iptables-translate -A INPUT -m statistic --mode random ! --probability
> > 0.1 -j ACCEPT
> > nft add rule ip filter INPUT meta random != 0.10000000009 counter accept
> 
> Then, the opposite has to be:
> 
>         meta random gte 0.10000000009

Good point, this is not intuitive.

Currently if no operator is given and the type is TYPE_PROBABILITY then
we just use le instead of eq (just like we pick "&" in some cases).

But if user asks 'meta random ne 0.1' then the match propability is close
to 100%.

Do you think its enough to just document that you need to use le/ge etc.
for this?

Other option would be to rewrite NE to GE if rh value is a probability,
but I'm not sure if such 'helpful' logic isn't too likely to get in the
way.

Yet another option is to just disallow EQ and NE ops and throw an error.

Other suggestions?
