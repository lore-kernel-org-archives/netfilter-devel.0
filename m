Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9161B34A79E
	for <netfilter-devel@vger.kernel.org>; Wed,  4 Feb 2026 18:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770228494; cv=none; b=QXWTyVwTVQ++305BWyzLgKI4N5fmak4qCRj/Hg6BiPltlVABV2AkaW0yMBSxVLSoa1EmtlFMGBZXOGIWNNb8QiPepnONw8LdPs2zeQLEX14bVB4BNBDiciMvMzZyF4qaOHbd5JTg+kMHieV0D8NYBhFAaPvULqx342AY6EzGuUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770228494; c=relaxed/simple;
	bh=NUlM0rhJBgiZup6olUz9WUEOHtLC4w67tBbh46H5Mdc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Rat0K0ThvqYVkUKtAKaOwiau+u/052vouuY1LwFySSHWzwWTlUJ7COCqr6rm9cAiyuuYsrhh/xnnbnzIt29lm1UJzYpAaoaVoqimtOHjr5ce6aQSYFwPbyuyS+ODf8xLaapnkoNK2QCJImvAHBYZEpJU0Fzsojjc28oWDnUpPV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id CF2886033F; Wed, 04 Feb 2026 19:08:10 +0100 (CET)
Date: Wed, 4 Feb 2026 19:08:05 +0100
From: Florian Westphal <fw@strlen.de>
To: Brian Witte <brianwitte@mailfence.com>
Cc: pablo@netfilter.org, kadlec@netfilter.org,
	netfilter-devel@vger.kernel.org,
	syzbot+ff16b505ec9152e5f448@syzkaller.appspotmail.com
Subject: Re: [PATCH v4 nf-next 2/2] netfilter: nf_tables: serialize reset
 with spinlock and atomic
Message-ID: <aYOLBSdHzVUHLPXR@strlen.de>
References: <aYJ0h5y-KZ29F99g@chamomile>
 <20260204175809.5703-1-brianwitte@mailfence.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260204175809.5703-1-brianwitte@mailfence.com>

Brian Witte <brianwitte@mailfence.com> wrote:
> On Mon, Feb 03, 2026 at 11:19:46PM +0100, Pablo Neira Ayuso wrote:
> > Maybe this so it covers for get and dump path?
> >
> > static struct nftables_pernet *nft_pernet_from_nlskb(const struct sk_buff *skb)
> > {
> >         struct sock *sk = skb->sk ? : NETLINK_CB(skb).sk;
> >
> >         return nft_pernet(sock_net(sk));
> > }
> >
> > in case it is worth to skip the unique nft_counter_lock below.
> 
> I have v5 ready with Florian's global DEFINE_SPINLOCK approach:
> split into 3 patches (revert, counter spinlock, quota atomic64_xchg),
> with nft_counter_fetch_and_reset() wrapping fetch+reset under the
> lock so parallel resets can't both read the same values. Tested and
> working.

Thanks.

> Before I send: should I go with the global spinlock, or would you
> prefer the per-net lock via nft_pernet_from_nlskb()? Happy to do
> either.

I don't think the nft_pernet_from_nlskb() will work as-is, for the
get requests the target skb is allocated via alloc_skb() and I don't
think the control block is initialised to hold the origin netlink query
sk.
