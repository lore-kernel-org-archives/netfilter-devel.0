Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E74AE1A76BB;
	Fri, 23 May 2025 07:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747985979; cv=none; b=Sfl6kLYKKxQhrR5GXtU9nU4Yqw0ZIP+F6S4iJ2Ni3DPk3BZeyWFriXIt+5FhrceILrd/qaF8XDbf10k7NdcAVYTD+hZ8y1riEHfK7ydZDboqrfraDDPtBhL7/9OPWKX3TsUat3zQDzbsJ0gmavC1Y0YqErKR1XvKO0Bx8/ohfoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747985979; c=relaxed/simple;
	bh=dpaDvs+AgMclkmomzmiVFMJX8bApNLwyF4LXEwEusNw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nWj7o67/inxkvsYKT8fIIxdaAbach18kABng1Q7xrS2++0o00RLXEekCkw//5ttb1j4/hYqps31ownj0iU/Xi2Y+KHXDdsEIDvS2Sv1nE28VJOAoEgafuLr02PH/pd/pEwgJupNr1XImVjLT4RwTLyFgl+tx1eLoRCX2xxi0Nqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Leg6UD3G; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=oSyaEwac; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Leg6UD3G";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="oSyaEwac"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 78DE1602B6; Fri, 23 May 2025 09:39:33 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747985973;
	bh=GAKl6BywfaP8khyBvnatNyM5VJ6j4j3itci1yUWFmJk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Leg6UD3GuA0Gz58Yo8+K2asPFWfD/liQJOk6AxM9ZFMRWyY+cjE00kRYMrSzU+aqc
	 D6u74PzqREGebAk+QUC04ewjeSA0ZJLoQr4RWuYQrSRWmjbo/FC0jtn13Qorq1xE9n
	 /3XzY5MvvbzODhmYmO4spg8Jdn89mfqrEd2fBa0dIb4Mn5Oq0aT9P65sKAXC8ZtyYY
	 vqgriSDk+3rkdbyNGovY1SyDl3UHRnor5z+vKXhWOQsQOKUbkruuHOcbWP0LcIE0Fe
	 eOIfhgz4KQafETvO+cBanur79MHq2tZYLksGAnitS8Q0i0Zu04wFkBkmRtJtmNaCEv
	 0YDrbqFgZCJhg==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id F079A602B6;
	Fri, 23 May 2025 09:39:31 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747985972;
	bh=GAKl6BywfaP8khyBvnatNyM5VJ6j4j3itci1yUWFmJk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oSyaEwacdvl7+HPNrhto5fE3bBKyXUoNmING/hX8ntMn/kLA2UmzuwVrV9RPwChhc
	 D7uxth/zVBy3k2Nr+nCqCI1aXLDkUwv9541q3zvkzS4eFd0VYQ9F6vSVBOrf6Hk19E
	 DXqMmRTtOiygBo4e6D+1n06O0VjJS6losDtm5PegiOQR480mKL+PY4IjmxawwFDlrf
	 3vv80I1cUv6sZ7aaPNAn20aNQz/aWZwWDJI1wRXcEppl+o+6AgZi1GeZ5zZ3sUxuLF
	 29h8ypXKK7P5mTNdeMawvUuXT+tODp9hyi8oJRZj6i9Dow/DbBgc5Ca0gLF5DXGTvx
	 1Zml6UCx9F0Vg==
Date: Fri, 23 May 2025 09:39:29 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Simon Horman <horms@kernel.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
	edumazet@google.com, fw@strlen.de
Subject: Re: [PATCH net-next 06/26] netfilter: nf_tables: nft_fib: consistent
 l3mdev handling
Message-ID: <aDAmMUGwlvMoEYE0@calendula>
References: <20250522165238.378456-1-pablo@netfilter.org>
 <20250522165238.378456-7-pablo@netfilter.org>
 <20250523073524.GR365796@horms.kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250523073524.GR365796@horms.kernel.org>

On Fri, May 23, 2025 at 08:35:24AM +0100, Simon Horman wrote:
> On Thu, May 22, 2025 at 06:52:18PM +0200, Pablo Neira Ayuso wrote:
> > @@ -39,6 +40,21 @@ static inline bool nft_fib_can_skip(const struct nft_pktinfo *pkt)
> >  	return nft_fib_is_loopback(pkt->skb, indev);
> >  }
> >  
> > +/**
> > + * nft_fib_l3mdev_get_rcu - return ifindex of l3 master device
> 
> Hi Pablo,
> 
> I don't mean to hold up progress of this pull request. But it would be nice
> if at some point the above could be changed to
> nft_fib_l3mdev_master_ifindex_rcu so it matches the name of the function
> below that it documents.
> 
> Flagged by ./scripts/kernel-doc -none

Thanks for letting me know, I can resubmit the series, let me know.
