Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B29913B599
	for <netfilter-devel@vger.kernel.org>; Tue, 23 Jul 2024 15:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721747357; cv=none; b=Kk6hj8rmIim3Dg3xN7O+zD5WIH75ItGlGPOoxrwendnwVXLuDeCVjbamVvxIgyKOAuCx45WTPYNLKFAlrQ3oqJHLgEn6DCbGzodedARvqEFVy2T2S5ltukLpx0CaUKruCPBEV5mPjJFN4g0TVxJYUHa+myUlYJIc56B/4bRjdYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721747357; c=relaxed/simple;
	bh=f49ZMVCghUBZPlQCXj2ndhlHdG/jKMlz26lUrFhvjZc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qgHq7soZNnTxXWllH6GfV0bjgC1TGOcHXDehNwYLFxNEVeYcSkCmVd4VtcVEv70c3yWDT4zptaSOq4dwzVQE/C/E1ff9oQE1qJsKgd//99B7KhDDQP8pyatfGwYENSVbHZFTqAJslwlsgPPoh/A8XP8la06RwlrsSnUhN9SfvJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Bh5cyCui; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Bh5cyCui"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=VcfX/4WlV+cmF0spHnxCjxjqEWerAmfVdcV1y8htbOY=; b=Bh5cyCuizDWu0BGeJ7JRkgcrMW
	N44YFBuEkDnErVVbGovNRYEry0xhJYK7J2Tk4nkj5IoSHO6EvogXwP2ovg9JgN2AiDAtkEtcysq7I
	Oh5dTzbIWUUdPX7hE7U/LKzxXJTPVEaA4U6qXigOfjdDmBFSaZwmRIVkw/utPdkIcYBzFctHg9Qkc
	/q3eYKu0ZadRN+wA56f5UTMl3u5aUHOXh6fPcNLgT8lLvc2hyXXBcXbd2hH3u9H8+u4UpEWHyf+8J
	/rkKyq9cQE9VlXMVspVFkpxOVQGgs5v5bG8gDlJ/2eICPmcTHDpHJ8L+uE4ULyjW2C4xWUCS1GMAz
	/DP0XMsQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sWH8a-000000004fZ-16su;
	Tue, 23 Jul 2024 17:09:12 +0200
Date: Tue, 23 Jul 2024 17:09:12 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Eric Garver <eric@garver.life>, netfilter-devel@vger.kernel.org,
	nhofmeyr@sysmocom.de
Subject: Re: [PATCH nft 2/2,v2] cache: recycle existing cache with
 incremental updates
Message-ID: <Zp_HmLb2r3nYeBBb@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Eric Garver <eric@garver.life>, netfilter-devel@vger.kernel.org,
	nhofmeyr@sysmocom.de
References: <20240528152817.856211-1-pablo@netfilter.org>
 <20240528152817.856211-2-pablo@netfilter.org>
 <Zp7FqL_YK3p_dQ8B@egarver-mac>
 <Zp7QSXcMHt9a8Hm7@calendula>
 <Zp-afhWpdM9R4hco@orbyte.nwl.cc>
 <Zp-fx35ewU1n8EE5@calendula>
 <Zp-oo3YnHOnZ7H98@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zp-oo3YnHOnZ7H98@calendula>

On Tue, Jul 23, 2024 at 02:57:07PM +0200, Pablo Neira Ayuso wrote:
> On Tue, Jul 23, 2024 at 02:19:25PM +0200, Pablo Neira Ayuso wrote:
> > On Tue, Jul 23, 2024 at 01:56:46PM +0200, Phil Sutter wrote:
> > > Some digging and lots of printf's later:
> > > 
> > > On Mon, Jul 22, 2024 at 11:34:01PM +0200, Pablo Neira Ayuso wrote:
> > > [...]
> > > > I can reproduce it:
> > > > 
> > > > # nft -i
> > > > nft> add table inet foo
> > > > nft> add chain inet foo bar { type filter hook input priority filter; }
> > > > nft> add rule inet foo bar accept
> > > 
> > > This bumps cache->flags from 0 to 0x1f (no cache -> NFT_CACHE_OBJECT).
> > > 
> > > > nft> insert rule inet foo bar index 0 accept
> > > 
> > > This adds NFT_CACHE_RULE_BIT and NFT_CACHE_UPDATE, cache is updated (to
> > > fetch rules).
> > > 
> > > > nft> add rule inet foo bar index 0 accept
> > > 
> > > No new flags for this one, so the code hits the 'genid == cache->genid +
> > > 1' case in nft_cache_is_updated() which bumps the local genid and skips
> > > a cache update. The new rule then references the cached copy of the
> > > previously commited one which still does not have a handle. Therefore
> > > link_rules() does it's thing for references to  uncommitted rules which
> > > later fails.
> > > 
> > > Pablo: Could you please explain the logic around this cache->genid
> > > increment? Commit e791dbe109b6d ("cache: recycle existing cache with
> > > incremental updates") is not clear to me in this regard. How can the
> > > local process know it doesn't need whatever has changed in the kernel?
> > 
> > The idea is to use the ruleset generation ID as a hint to infer if the
> > existing cache can be recycled, to speed up incremental updates. This
> > is not sufficient for the index cache, see below.
> 
> I have to revisit e791dbe109b6d, another process could race to bump
> the generation ID incrementally and I incorrectly assumed cache is
> consistent.

It might be fine, because cache->genid != 0 means we have fetched from
kernel previously and thus also committed a change (list commands set
CACHE_REFRESH). Kernel genid is expectedly cache->genid + 1, a
concurrent commit would bump again.

I don't like the commit because it breaks with the assumption that
kernel genid matching cache genid means cache is up to date. It may
indeed be, but I think it's thin ice and caching code is pretty complex
as-is. :/

Cheers, Phil
