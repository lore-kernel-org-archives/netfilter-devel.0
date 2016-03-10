From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: nft_compat: check match/targetinfo attr size
Date: Thu, 10 Mar 2016 18:16:19 +0100
Message-ID: <20160310171619.GA3483@salvia>
References: <1457478261-11247-1-git-send-email-fw@strlen.de>
 <20160310164710.GA3267@salvia>
 <20160310170001.GC14718@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:32950 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753085AbcCJRQZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Mar 2016 12:16:25 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 4E771114F44
	for <netfilter-devel@vger.kernel.org>; Thu, 10 Mar 2016 18:16:24 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 3E65EDA380
	for <netfilter-devel@vger.kernel.org>; Thu, 10 Mar 2016 18:16:24 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id B99D7DA386
	for <netfilter-devel@vger.kernel.org>; Thu, 10 Mar 2016 18:16:18 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20160310170001.GC14718@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Mar 10, 2016 at 06:00:01PM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Wed, Mar 09, 2016 at 12:04:21AM +0100, Florian Westphal wrote:
> > > We copy accoring to ->target|matchsize, so check that the netlink attribute
> > > (which can include padding and might be larger) contains enough data.
> > > 
> > > Reported-by: Julia Lawall <Julia.Lawall@lip6.fr>
> > > Signed-off-by: Florian Westphal <fw@strlen.de>
> > 
> > I think xt_check_match() and xt_check_target() already validate this
> > for us.
> 
> But AFAICS we copy before this:
> 
> nft_target_init:
> 
> size = XT_ALIGN(nla_len(tb[NFTA_TARGET_INFO]));
> ...
> target_compat_from_user(target, nla_data(tb[NFTA_TARGET_INFO]), info);
>    -> memcpy(out, in, t->targetsize);
> 
> xt_check_target(&par, size, proto, inv);  // checks size vs. targetsize
> 
> 'target' is sized based on target->targetsize in
> nft_target_select_ops().
> 
> So if tb[NFTA_TARGET_INFO] is != t->targetsize we might copy more
> data than whats in 'in', no?

Right, if the user passes less information, then we would be copying
more than what we have.

I'm going to place this in the nf-next, thanks Florian.
