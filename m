Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A94726AD3
	for <netfilter-devel@vger.kernel.org>; Tue, 23 Jul 2024 12:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721739436; cv=none; b=aViJBBZJZfRUnrtzCvHJnUPii5++q9KjPMXQUKfbqFdKozv/wg64S/ygGFfk1VIKK3TfuFXVM9+hWVlo5qFMFxyizjfnzmzv2Lz1VxL336Aw3GzRHbyD+poUDLMIbtAO6YlQbvszyDJm/alvbJ7XHxN7H5nxfcmDZIh3onMZwT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721739436; c=relaxed/simple;
	bh=Pth5j0vtqhFy/L1602DAZjYuZajLG6+2WJ0rL40Tl40=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UwxY4vRQhPcowbV1Tx1jp4YY8wGWY5ruK6BStfUda+wxop7MU8crP3hZotbuhXhNu5gG9E02EBWektAvFSARXun78rRJwWboi4IdQpJf7xNOoi2OH7YOjZzbvXV1spj5nApbomvS7s7hLTmt8j6qZRsscM4/azMJKG90DwNA30s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [46.6.251.194] (port=5384 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sWF4n-000dXZ-HE; Tue, 23 Jul 2024 14:57:11 +0200
Date: Tue, 23 Jul 2024 14:57:07 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>, Eric Garver <eric@garver.life>,
	netfilter-devel@vger.kernel.org, nhofmeyr@sysmocom.de
Subject: Re: [PATCH nft 2/2,v2] cache: recycle existing cache with
 incremental updates
Message-ID: <Zp-oo3YnHOnZ7H98@calendula>
References: <20240528152817.856211-1-pablo@netfilter.org>
 <20240528152817.856211-2-pablo@netfilter.org>
 <Zp7FqL_YK3p_dQ8B@egarver-mac>
 <Zp7QSXcMHt9a8Hm7@calendula>
 <Zp-afhWpdM9R4hco@orbyte.nwl.cc>
 <Zp-fx35ewU1n8EE5@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Zp-fx35ewU1n8EE5@calendula>
X-Spam-Score: -1.9 (-)

On Tue, Jul 23, 2024 at 02:19:25PM +0200, Pablo Neira Ayuso wrote:
> On Tue, Jul 23, 2024 at 01:56:46PM +0200, Phil Sutter wrote:
> > Some digging and lots of printf's later:
> > 
> > On Mon, Jul 22, 2024 at 11:34:01PM +0200, Pablo Neira Ayuso wrote:
> > [...]
> > > I can reproduce it:
> > > 
> > > # nft -i
> > > nft> add table inet foo
> > > nft> add chain inet foo bar { type filter hook input priority filter; }
> > > nft> add rule inet foo bar accept
> > 
> > This bumps cache->flags from 0 to 0x1f (no cache -> NFT_CACHE_OBJECT).
> > 
> > > nft> insert rule inet foo bar index 0 accept
> > 
> > This adds NFT_CACHE_RULE_BIT and NFT_CACHE_UPDATE, cache is updated (to
> > fetch rules).
> > 
> > > nft> add rule inet foo bar index 0 accept
> > 
> > No new flags for this one, so the code hits the 'genid == cache->genid +
> > 1' case in nft_cache_is_updated() which bumps the local genid and skips
> > a cache update. The new rule then references the cached copy of the
> > previously commited one which still does not have a handle. Therefore
> > link_rules() does it's thing for references to  uncommitted rules which
> > later fails.
> > 
> > Pablo: Could you please explain the logic around this cache->genid
> > increment? Commit e791dbe109b6d ("cache: recycle existing cache with
> > incremental updates") is not clear to me in this regard. How can the
> > local process know it doesn't need whatever has changed in the kernel?
> 
> The idea is to use the ruleset generation ID as a hint to infer if the
> existing cache can be recycled, to speed up incremental updates. This
> is not sufficient for the index cache, see below.

I have to revisit e791dbe109b6d, another process could race to bump
the generation ID incrementally and I incorrectly assumed cache is
consistent.
