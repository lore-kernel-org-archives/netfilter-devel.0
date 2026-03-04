Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62F4F18FDBD;
	Wed,  4 Mar 2026 12:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772628590; cv=none; b=XRKgscLnl9v1JeIIizcRO5LIKA9NoCBcGH1W/CYOR7qoF/sg2Yzkbh/JJFMoAwV6qXW36JRK3q73pB5cBokNuTVWq3ebsahE2oMSNO9zv/XEvv5FHxNl15HXBcckOOrXWm6asCDyEQbKXNptBqC4sJ560Do9XqcTzPf6jKhH9eI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772628590; c=relaxed/simple;
	bh=K1NSkyT/5yk5JIolv12DBjooKk2618aNUDcYaGNnQns=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DN+CLCiHVjg5VW8/1bnmkvffdb3L0H6JlLh1zN/1tK+yD5743XCgWzoQtWLG/paWKnS35zj9MWZgocbaeUl+xTScARC/jnBPjRWaUipooJvf402Xf2jngXy3Av565q6UU87c+jakQEnm3wA5b2FaAtjSsIHNRwZsP3eMfOq0+/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=WSbAMbLF; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="WSbAMbLF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=wjUSe32dbNkWbFtSmbGolwtwpZu2UyUPLb7b+Y7uY84=; b=WSbAMbLFdVcW6SZ6egx5ri9xYF
	+vE6KQppBNhPkvFXi8DA6AjcQR5CNOFs4w1y5pGiMEWilUmQyv+UZOS3Yc39g58hh0N7w8T2ab2VL
	0X3HmDnaMKTv1AF4WTnnqVC7rmVLjz4yqmBTuTtRjh1EWk7KovVttAiuL8n3SBWgdBDnQFSIC8Wxp
	RFX6lrXg6fXredpEoG7b2TDdfHX/2jZEpG5Ks5DyMJAbghIJV+CuWlOj/47++1CZHFDZj2/FTJGNn
	HEZMyKmBslhK9fR5QEu9CJFByqrD/GdLB1riQp55szeee9Bknxoqc/3xX7MbRfQIwr/I1sln0nZUV
	raOiGw6A==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1vxlfe-0000000081O-2E5K;
	Wed, 04 Mar 2026 13:49:46 +0100
Date: Wed, 4 Mar 2026 13:49:46 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Helen Koike <koike@igalia.com>, fw@strlen.de,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-dev@igalia.com
Subject: Re: [PATCH] netfilter: nf_tables: fix use-after-free on ops->dev
Message-ID: <aagqaq6LNJnrg8eC@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Helen Koike <koike@igalia.com>, fw@strlen.de,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-dev@igalia.com
References: <20260302212605.689909-1-koike@igalia.com>
 <aaYYiPTO5JYOlhhY@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aaYYiPTO5JYOlhhY@chamomile>

On Tue, Mar 03, 2026 at 12:08:56AM +0100, Pablo Neira Ayuso wrote:
> On Mon, Mar 02, 2026 at 06:26:05PM -0300, Helen Koike wrote:
> > struct nf_hook_ops has a pointer to dev, which can be used by
> > __nf_unregister_net_hook() after it has been freed by tun_chr_close().
> > 
> > Fix it  by calling dev_hold() when saving dev to ops struct.
> 
> Sorry, I don't think this patch works, dev_hold()/dev_put() use
> per_cpu area.

Why is this problematic? netdev_refcnt_read() sums the per-cpu variables
up, so it should be fine if we refcount_inc on one CPU and refcount_dec
on another, no?

> The nf_tables_flowtable_event() function used to release the hook, but
> now things have changed since there is auto-hook registration.

But isn't __nf_unregister_net_hook() still called immediately when
handling NETDEV_UNREGISTER event? I guess struct nf_hook_ops::dev may
still be accessed afterwards since ops is RCU-freed. Is Helen's report
inaccurate in that regard?

Looking at netdev_wait_allrefs_any(), I see NETDEV_UNREGISTER
notification before rcu_barrier() call. Does that suffice for our
kfree_rcu() upon NETDEV_UNREGISTER?

If we really risk losing the device pointer while the holding
nf_hook_ops object is still in use, dev_hold/_put should help. But where
to call dev_put() then? AIUI, nft_netdev_hook_free_ops() does not apply
to the NETDEV_UNREGISTER event code path, does it?

Cheers, Phil

> > Reported-by: syzbot+bb9127e278fa198e110c@syzkaller.appspotmail.com
> > Closes: https://syzkaller.appspot.com/bug?extid=bb9127e278fa198e110c
> > Signed-off-by: Helen Koike <koike@igalia.com>
> > ---
> >  net/netfilter/nf_tables_api.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> > index fd7f7e4e2a43..00b5f900a51d 100644
> > --- a/net/netfilter/nf_tables_api.c
> > +++ b/net/netfilter/nf_tables_api.c
> > @@ -352,6 +352,7 @@ static void nft_netdev_hook_free_ops(struct nft_hook *hook)
> >  
> >  	list_for_each_entry_safe(ops, next, &hook->ops_list, list) {
> >  		list_del(&ops->list);
> > +		dev_put(ops->dev);
> >  		kfree(ops);
> >  	}
> >  }
> > @@ -2374,6 +2375,7 @@ static struct nft_hook *nft_netdev_hook_alloc(struct net *net,
> >  			err = -ENOMEM;
> >  			goto err_hook_free;
> >  		}
> > +		dev_hold(dev);
> >  		ops->dev = dev;
> >  		list_add_tail(&ops->list, &hook->ops_list);
> >  	}
> > -- 
> > 2.53.0
> > 
> 
