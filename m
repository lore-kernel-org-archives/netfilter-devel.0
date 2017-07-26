From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: nft_set_rbtree: use seqcount to avoid
 lock in most cases
Date: Wed, 26 Jul 2017 13:25:07 +0200
Message-ID: <20170726112507.GA2217@salvia>
References: <20170726000941.29673-1-fw@strlen.de>
 <20170726111506.GA1816@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35672 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751034AbdGZLZP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 26 Jul 2017 07:25:15 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0EDBD17D42B
        for <netfilter-devel@vger.kernel.org>; Wed, 26 Jul 2017 13:25:02 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id ECAF2DA7F4
        for <netfilter-devel@vger.kernel.org>; Wed, 26 Jul 2017 13:25:01 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C4609DA7F4
        for <netfilter-devel@vger.kernel.org>; Wed, 26 Jul 2017 13:24:59 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170726111506.GA1816@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jul 26, 2017 at 01:15:06PM +0200, Pablo Neira Ayuso wrote:
> On Wed, Jul 26, 2017 at 02:09:41AM +0200, Florian Westphal wrote:
> [...]
> > @@ -144,7 +159,9 @@ static int nft_rbtree_insert(const struct net *net, const struct nft_set *set,
> >  	int err;
> >  
> >  	write_lock_bh(&priv->lock);
> > +	write_seqcount_begin(&priv->count);
> >  	err = __nft_rbtree_insert(net, set, rbe, ext);
> > +	write_seqcount_end(&priv->count);
> >  	write_unlock_bh(&priv->lock);
> >  
> >  	return err;
> > @@ -158,7 +175,9 @@ static void nft_rbtree_remove(const struct net *net,
> >  	struct nft_rbtree_elem *rbe = elem->priv;
> >  
> >  	write_lock_bh(&priv->lock);
> 
> Do we need the spinlock anymore? This is protected by mutex from
> userspace, and we have no support for neither timeouts nor dynamic set
> population from packet path yet.

Forget this, I overlook we have a slow path in case seq mismatches.
