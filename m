Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F15E293728;
	Fri, 23 May 2025 13:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748007538; cv=none; b=Y7ksaq3jDSt1cc1NO1CbHot+sC90ExMporpFYeU8YXcpQ4Le/JmA8trbscwNAhpd8hHFI+DDXL5tWKRrkjMQIifLa9LrNzR6qHuAl17o+ISbTxxLbrr6Qk1+N0yNQD175qaOc8+RH13YM8l1SgLEcuvOjgciBFlBRMX7YmOX+ys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748007538; c=relaxed/simple;
	bh=r8OahUbV1X27tHO/oeyACWqIckVKUfBpJaADE0ooC0M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AnyU4sAjgYqlYFrNvfVlvRN2H0L2n3qRf1emmtd5B9OKQxnve0SiA4u9VkqJd08RzU4SuzZo38Ncvcx6vKqQ8FjuMm4/3TebyxN1fFPE/bJrlQQKp9WrvdSlyFlaidmS3pQ9huVp1efnEpQOC/ga+oRpBUVmLu06z3Hy93UEsrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UVuJMFLC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UVuJMFLC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E70BC4CEE9;
	Fri, 23 May 2025 13:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748007538;
	bh=r8OahUbV1X27tHO/oeyACWqIckVKUfBpJaADE0ooC0M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UVuJMFLCrf8RjJDwgeaLTekeZ5fW0qtoFt7ATNR2orv/iO3mZscwla+6JKf1G7x+i
	 /t7hLvRhCJQXpgjMtKCTyuV27nYfa7vuCTid6EF676VCFCFo0uMTbz5hbazB1tHK/4
	 V0vvq+qVYxQFxvhhvek1fvcMp3SJdAV3RAN/RCAh8RpRXqXGsmHA5gws1H78Zw2Nwh
	 QjSFNphs6vSqK9pLS0FmU8703q2Gc0rdFiNBKrAA8cuQy1dD96PWZkM+xK+hc7oM9I
	 IaoxUFYK2yVOO176OuwzIwUKnSB/1zI33t8FSW7WKfh6N/zVWUGMZziR3dOVCuqxOS
	 /9w5RiYrfermA==
Date: Fri, 23 May 2025 14:38:54 +0100
From: Simon Horman <horms@kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
	edumazet@google.com, fw@strlen.de
Subject: Re: [PATCH net-next 06/26] netfilter: nf_tables: nft_fib: consistent
 l3mdev handling
Message-ID: <20250523133854.GX365796@horms.kernel.org>
References: <20250522165238.378456-1-pablo@netfilter.org>
 <20250522165238.378456-7-pablo@netfilter.org>
 <20250523073524.GR365796@horms.kernel.org>
 <aDAmMUGwlvMoEYE0@calendula>
 <20250523132610.GV365796@horms.kernel.org>
 <aDB4NniR09nI2rjp@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aDB4NniR09nI2rjp@calendula>

On Fri, May 23, 2025 at 03:29:26PM +0200, Pablo Neira Ayuso wrote:
> On Fri, May 23, 2025 at 02:26:10PM +0100, Simon Horman wrote:
> > On Fri, May 23, 2025 at 09:39:29AM +0200, Pablo Neira Ayuso wrote:
> > > On Fri, May 23, 2025 at 08:35:24AM +0100, Simon Horman wrote:
> > > > On Thu, May 22, 2025 at 06:52:18PM +0200, Pablo Neira Ayuso wrote:
> > > > > @@ -39,6 +40,21 @@ static inline bool nft_fib_can_skip(const struct nft_pktinfo *pkt)
> > > > >  	return nft_fib_is_loopback(pkt->skb, indev);
> > > > >  }
> > > > >  
> > > > > +/**
> > > > > + * nft_fib_l3mdev_get_rcu - return ifindex of l3 master device
> > > > 
> > > > Hi Pablo,
> > > > 
> > > > I don't mean to hold up progress of this pull request. But it would be nice
> > > > if at some point the above could be changed to
> > > > nft_fib_l3mdev_master_ifindex_rcu so it matches the name of the function
> > > > below that it documents.
> > > > 
> > > > Flagged by ./scripts/kernel-doc -none
> > > 
> > > Thanks for letting me know, I can resubmit the series, let me know.
> > 
> > I'd lean towards fixing it later unless there is another reason to
> > resubmit the series.
> 
> I did not read this email and I resubmitted. I hope this is also fine with you.

Yes, of course that is fine :)
