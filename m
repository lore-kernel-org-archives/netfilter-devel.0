From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] netfilter: nft_compat: check match/targetinfo attr size
Date: Thu, 10 Mar 2016 18:00:01 +0100
Message-ID: <20160310170001.GC14718@breakpoint.cc>
References: <1457478261-11247-1-git-send-email-fw@strlen.de>
 <20160310164710.GA3267@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:44490 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753571AbcCJRAD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Mar 2016 12:00:03 -0500
Content-Disposition: inline
In-Reply-To: <20160310164710.GA3267@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Wed, Mar 09, 2016 at 12:04:21AM +0100, Florian Westphal wrote:
> > We copy accoring to ->target|matchsize, so check that the netlink attribute
> > (which can include padding and might be larger) contains enough data.
> > 
> > Reported-by: Julia Lawall <Julia.Lawall@lip6.fr>
> > Signed-off-by: Florian Westphal <fw@strlen.de>
> 
> I think xt_check_match() and xt_check_target() already validate this
> for us.

But AFAICS we copy before this:

nft_target_init:

size = XT_ALIGN(nla_len(tb[NFTA_TARGET_INFO]));
...
target_compat_from_user(target, nla_data(tb[NFTA_TARGET_INFO]), info);
   -> memcpy(out, in, t->targetsize);

xt_check_target(&par, size, proto, inv);  // checks size vs. targetsize

'target' is sized based on target->targetsize in
nft_target_select_ops().

So if tb[NFTA_TARGET_INFO] is != t->targetsize we might copy more
data than whats in 'in', no?
