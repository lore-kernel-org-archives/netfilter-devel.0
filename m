Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FC38231A41
	for <netfilter-devel@vger.kernel.org>; Wed, 18 Mar 2026 17:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773853445; cv=none; b=h5UgW5mTLHfaAnTCCJEaGxr2seVlB7M+W3n3XoJVcOFhlExSTjznthyBBiiZTVyHQ6lxdsTGxB1846HmF1ILN9v5XM0l5R+O9PgORclnKseb8QxyIpgwnG23YBn9hAJ/t08cErwBc0iaYlp4iCMH25UH6vFzVZoVZjozRPo0wmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773853445; c=relaxed/simple;
	bh=SC+m3GTd8VoSo3S9wRz4ONCD+ld1L25RZW3MmJRkI4g=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q5yPXIl4+iW6J34kwyO+fdzUk6zI+Oae8tK48uYOi/4rjJA9HG1BQntZGPNB/KDA9uvRemjiRqDIpLUq5eU6nPc+gNZb/6u49o9qrmWud2y0Ky6127MkRB5aHmYzx+QFEmucqPXqf/76/WG4LDE2t5fyiMoZpTjCzbBWcFcYzq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=YUNAUwzl; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="YUNAUwzl"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 1A35660181;
	Wed, 18 Mar 2026 18:04:02 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1773853442;
	bh=fpS8YmJttC1h2TVuZJc7F9TV+jdBLxTBbadRZKLSmwA=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=YUNAUwzlWFT6IZS2TXttOC5iXSBG2EL0llIpv03MR1DP9tdatXETAxqVe8k16wgTx
	 giwsyTIrc+Pr7+vwClpNgwhwC+zifMeWkngIbcfn6yhsGdGbInxnJvwNcp0znebXZ8
	 4g9BLQmMsau30cqr7v/g9D33EcYrxHeKwcpelvxQgHyUi9C4y0zKJBL5KGUWMW6RHE
	 o3qBGkhWzZy2lWBddWMZ1FHwcOOE4CTw7Ez2/O9R0BF7StH5URuFSsRXWZw+RQb78D
	 peFD4k1HD0zBOjiDWE/jMFeTxENOEJWFMrgSsf4oEcQEqncdpF95LvY8UCHoGobKrt
	 Wcrpm9rSDru/A==
Date: Wed, 18 Mar 2026 18:03:58 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>, chlorodose <chlorodose@gmail.com>,
	netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] src: Export nftnl_set_clone symbol
Message-ID: <abra_o50miSi49Aw@chamomile>
References: <20260318025651.151116-1-chlorodose@gmail.com>
 <abqCdqPLJyKmBQc-@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <abqCdqPLJyKmBQc-@orbyte.nwl.cc>

On Wed, Mar 18, 2026 at 11:46:14AM +0100, Phil Sutter wrote:
> Hi chlorodose,
> 
> On Wed, Mar 18, 2026 at 10:56:51AM +0800, chlorodose wrote:
> > Seems that nftnl_set_clone is forgot to be exported, we add it back.
> > 
> > Signed-off-by: chlorodose <chlorodose@gmail.com>
> > ---
> >  src/set.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/src/set.c b/src/set.c
> > index 54674bc..e5e51b6 100644
> > --- a/src/set.c
> > +++ b/src/set.c
> > @@ -360,6 +360,7 @@ uint64_t nftnl_set_get_u64(const struct nftnl_set *s, uint16_t attr)
> >  	return val ? *val : 0;
> >  }
> >  
> > +EXPORT_SYMBOL(nftnl_set_clone);
> >  struct nftnl_set *nftnl_set_clone(const struct nftnl_set *set)
> >  {
> >  	struct nftnl_set *newset;
> 
> Don't you also have to add it to src/libnftnl.map? How did you test this
> patch?
> 
> Looking at the function itself, I fear the code is not correct anymore.
> E.g., it does not clone expr_list or user.data. If I was to decide, I'd
> rather drop it entirely instead of polishing it up. What's your
> use-case?

Indeed, this function is internal and it is incomplete. it does not
provide a full clone.
