Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05A6FC433EF
	for <netfilter-devel@archiver.kernel.org>; Mon, 28 Feb 2022 02:32:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231259AbiB1Cdc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 27 Feb 2022 21:33:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231653AbiB1Cda (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 27 Feb 2022 21:33:30 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7386F37A33;
        Sun, 27 Feb 2022 18:32:51 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1nOVqA-0007Ks-EM; Mon, 28 Feb 2022 03:32:46 +0100
Date:   Mon, 28 Feb 2022 03:32:46 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org
Subject: Re: [PATCH net-next 18/32] netfilter: egress: avoid a lockdep splat
Message-ID: <20220228023246.GA26547@breakpoint.cc>
References: <20220109231640.104123-1-pablo@netfilter.org>
 <20220109231640.104123-19-pablo@netfilter.org>
 <872e2596-4d7c-3b91-341c-0db3a3d7fd57@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <872e2596-4d7c-3b91-341c-0db3a3d7fd57@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > index b71b57a83bb4..b4dd96e4dc8d 100644
> > --- a/include/linux/netfilter_netdev.h
> > +++ b/include/linux/netfilter_netdev.h
> > @@ -94,7 +94,7 @@ static inline struct sk_buff *nf_hook_egress(struct sk_buff *skb, int *rc,
> >   		return skb;
> >   #endif
> > -	e = rcu_dereference(dev->nf_hooks_egress);
> > +	e = rcu_dereference_check(dev->nf_hooks_egress, rcu_read_lock_bh_held());
> >   	if (!e)
> >   		return skb;
> 
> 
> It seems other rcu_dereference() uses will also trigger lockdep splat.
 
> if (genbit)
>     blob = rcu_dereference(chain->blob_gen_1);
> else
>    blob = rcu_dereference(chain->blob_gen_0);
> 
> I wonder how many other places will need a fix ?

I don't like that, all nf hooks assume rcu_read_lock is held.
nf_hook_egress() call to nf_hook_slow() needs to be wrapped
in rcu_read_(un)lock pair.
