Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF7641FDD;
	Fri, 23 May 2025 13:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748006778; cv=none; b=HXglYA3eP5dk/VHeIXbdgfft8vT61bU9JNhleW3qpgRdxBFpKnhGngrv1CxHirLmR6I0dgD0s3MYuedUOXKBhuNMaqj0xmdYFOHRX6IoNBPohjZiSoCh/Wt72A98JX4tvK9SSAd/4UrFKMEMd3ew3mXVopM4WkpDnz09H2LGlJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748006778; c=relaxed/simple;
	bh=QfwOzRXg17oiLyI62vHbF9ot/93AkhMBVAj65vYAFU8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IiLGBALtn/+2JiMSx9I0OB0WTUq7wOAuD1c/Kpzt4DFf3M9w4hvnE+uUUiaMS0lShzQl/J3MWbdGuOsmflnibF0srN3SPVrZbRPj08VNVTbibQFOys0f9DbZa0c5pi7HYP3wTxC050rfWEuggvYjsxZAicgns2cBXPGmJSwavUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J0SM2qQA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J0SM2qQA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C34F0C4CEEF;
	Fri, 23 May 2025 13:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748006774;
	bh=QfwOzRXg17oiLyI62vHbF9ot/93AkhMBVAj65vYAFU8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=J0SM2qQAJ0QSQC9EaQsqBP43689pdaWL6ORgjeVf6eZNkfu1npGOzI5MmUEL5e+sd
	 OGHZae5eU4PxTUlOC8RUucAQJkh0LBETYRjK7Cq/qIhfngcluWkxg5W8x6F5hAdrr2
	 nj7Uni6nfwo9KNg+g+gpi5LmmdAP7Bl4ZbGpaMOGuvq4cQFk4YmLWJ8zaAnX6vaViY
	 9EMVvYMNgRhv6qgPfQuUq0O2pWAb2oYuNDv4gnF7D8ToyQjCUyf4JTGBLmzpy6TORS
	 aV81Kdo0csejTOBHaz5H1rULXB2Yby4b0yF3vkd4jlzoVGWGPfp7sLohgXp/R1v/Md
	 A1351QqQVaiEw==
Date: Fri, 23 May 2025 14:26:10 +0100
From: Simon Horman <horms@kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
	edumazet@google.com, fw@strlen.de
Subject: Re: [PATCH net-next 06/26] netfilter: nf_tables: nft_fib: consistent
 l3mdev handling
Message-ID: <20250523132610.GV365796@horms.kernel.org>
References: <20250522165238.378456-1-pablo@netfilter.org>
 <20250522165238.378456-7-pablo@netfilter.org>
 <20250523073524.GR365796@horms.kernel.org>
 <aDAmMUGwlvMoEYE0@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aDAmMUGwlvMoEYE0@calendula>

On Fri, May 23, 2025 at 09:39:29AM +0200, Pablo Neira Ayuso wrote:
> On Fri, May 23, 2025 at 08:35:24AM +0100, Simon Horman wrote:
> > On Thu, May 22, 2025 at 06:52:18PM +0200, Pablo Neira Ayuso wrote:
> > > @@ -39,6 +40,21 @@ static inline bool nft_fib_can_skip(const struct nft_pktinfo *pkt)
> > >  	return nft_fib_is_loopback(pkt->skb, indev);
> > >  }
> > >  
> > > +/**
> > > + * nft_fib_l3mdev_get_rcu - return ifindex of l3 master device
> > 
> > Hi Pablo,
> > 
> > I don't mean to hold up progress of this pull request. But it would be nice
> > if at some point the above could be changed to
> > nft_fib_l3mdev_master_ifindex_rcu so it matches the name of the function
> > below that it documents.
> > 
> > Flagged by ./scripts/kernel-doc -none
> 
> Thanks for letting me know, I can resubmit the series, let me know.

I'd lean towards fixing it later unless there is another reason to
resubmit the series.
