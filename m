Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D13D25A2B4;
	Wed, 28 Jan 2026 16:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769618117; cv=none; b=MPQFg+q9PehQDR0Rc2lhtBo3CAahPtm3eH5h0xvLD3bHuuHBMesa8Faa0tNb4bPRnMsSUbDNjcQCy0Z2FCxIX46U/5hmxrzH/8+/vbKqBo6Tbj+F1mDGF6qZn/FsacYJZDy2daiU2mD14NjF4aeEyWcL6n+x1E8MWY0u5SCE6ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769618117; c=relaxed/simple;
	bh=lEAPg8/1O1kCKjKzRe0arMgCCKsZXsXwj7sG/uTzP4c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aC2ZDEpL8Fg4xjYI5wvWUA3Vi37bakvKZFIPbkZB+uHSSLqc+Yn9iDOx6Mtr2GsFp+OZynyEb0EE9x399zSzyRdD48ULsyhbtqoeZrjG4u5PhhR7fmxU5//OwBqegZk5Diw5F5PfrnH+yuysOOvKocgG1c8Zw3J0fn+vv9de6BM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id B085D60625; Wed, 28 Jan 2026 17:35:11 +0100 (CET)
Date: Wed, 28 Jan 2026 17:35:12 +0100
From: Florian Westphal <fw@strlen.de>
To: syzbot <syzbot+d417922a3e7935517ef6@syzkaller.appspotmail.com>
Cc: coreteam@netfilter.org, davem@davemloft.net, edumazet@google.com,
	horms@kernel.org, kuba@kernel.org, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
	pabeni@redhat.com, pablo@netfilter.org, phil@nwl.cc,
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [netfilter?] KASAN: slab-use-after-free Read in
 nft_array_get_cmp
Message-ID: <aXo6wL1ziBe1vKEN@strlen.de>
References: <6979fc44.050a0220.c9109.003b.GAE@google.com>
 <aXoRvAottF2YRD3a@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aXoRvAottF2YRD3a@strlen.de>

Florian Westphal <fw@strlen.de> wrote:
> >  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
> >  print_address_description mm/kasan/report.c:378 [inline]
> >  print_report+0xba/0x230 mm/kasan/report.c:482
> >  kasan_report+0x117/0x150 mm/kasan/report.c:595
> >  nft_set_ext include/net/netfilter/nf_tables.h:795 [inline]
> >  nft_set_ext_key include/net/netfilter/nf_tables.h:800 [inline]
> >  nft_array_get_cmp+0x1f6/0x2a0 net/netfilter/nft_set_rbtree.c:133
> >  __inline_bsearch include/linux/bsearch.h:15 [inline]
> >  bsearch+0x50/0xc0 lib/bsearch.c:33
> >  nft_rbtree_get+0x16b/0x400 net/netfilter/nft_set_rbtree.c:169
> 
> Use after free, its possible for rbtree insert to evict elements
> due to expiry, but still return -EEXIST.
> 
> We can thus end up with removed elements but without a call to
> ->commit(), hence we have a stale binary blob referencing free'd
> elements.

So far I found 3 related issues, bsearch blob gets out of sync with the
rbtree.  Prerequisite: set has a timed-out entry.  In all cases
the bsearch blob isn't refreshed and holds pointers to free'd elements.

1. add new element, transaction is later aborted.
Fix: refresh the bsearch blob from abort callback.

2. re-add an existing element, transaction passes.
In this case, the commit hook isn't called because we don't have
any changes to the set from transaction point of view.

3. create (F_EXCL) an existing element.  This also
aborts the transaction, but the abort callback isn't run
as no change to the set was made.

I'm not yet sure how to fix 2 and 3.

I'll see about moving set_update_list to the nft pernet
structure, so it can be populated from
nft_trans_gc_queue_sync_done().

Pipapo set backend should be fine with it, it won't act
when called with the 'private clone' being NULL.
