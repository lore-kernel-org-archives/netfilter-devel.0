Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17BAC4501A
	for <netfilter-devel@vger.kernel.org>; Fri,  4 Jul 2025 15:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751643208; cv=none; b=HiBj3J2jwECm5LKr4Rkwou+7g2dfctR9o0AzHK80SRmxMANTav9wPCneun5hWBHnxiP2DMUZ3Bp3oxt7eqTSH0YWO6I4Gy/MLT1vKrsg4DcGjZmNq7zgk/EMRFiHFER10JlHOw0lnacrtteJCpsX+MZj0psPAQUsop3wfL7rx4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751643208; c=relaxed/simple;
	bh=qU+UdE/3uiQNII1tHq9ZaZfDqTxHo82wV8/aRPhRFPQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dT3uwH8Dcn2/0sg0cG4GgzmpUzp4nXOAZA+s1uYgCd5K1AQiL94gEChxNnzPb4qtsOU3NznqwWU4WL5IdH9CIdpO8XPv8k9EYB6RzFaIuHHJQNmrAcWEc1VuyY7hOsNjjVojDnhJGa9hnSPsAuw9N8Xjyv2S0Nu2Q/C6f0ySFSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=PiWoxTfM; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="PiWoxTfM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=JOw0eKqiVbX8AWCTdhWgZbsQhmlaUos21x2rsERWgQ4=; b=PiWoxTfMY5h0Ln0qT38F9pu412
	WDqihivjRJFU8xtHgf1QpLB1ApfNy+5qikWewHS2GgXqT/FhxBvnsDEzFfs+SNR17iLnttNBzFytL
	m2g15+JfZ/S/xjFSNOMZP/FmEESRV7cwcu9km6pmPqkViV3fAFOXDnagoxSUxjrbl6HDGIP/A0j9M
	PJQ7FylMamV0ZdK0z2LV8+u11hJLg4hOaANSEEXV9WEnjkKTzO74qqb1MOWPlNYwVoRrYRQK6RgKI
	mKDbvds6SH0PgGMPjAO6g7fX61Df06Ne4pxFbraDP2BEEBrEkAebqa4P1FhqV2EJigi82Jcu0usCA
	cFYB2Hww==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uXiPi-00000000363-3kAG;
	Fri, 04 Jul 2025 17:33:22 +0200
Date: Fri, 4 Jul 2025 17:33:22 +0200
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [nf-next RFC] netfilter: nf_tables: Feature ifname-based hook
 registration
Message-ID: <aGf0QtBQAkTaIMEW@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <aGZ21NE61B4wdlq8@orbyte.nwl.cc>
 <aGZ6E0k0AyYMiMvp@strlen.de>
 <aGZ75G4SVuwkNDb9@orbyte.nwl.cc>
 <aGZ9jNVIiq9NrUdi@strlen.de>
 <aGaC0vHnoIEz8sTc@orbyte.nwl.cc>
 <aGaRaHoawJ-DbNUl@calendula>
 <aGaUzVUf_-xbowvO@orbyte.nwl.cc>
 <aGbu5ugsBY8Bu3Ad@calendula>
 <aGfL3Q2huYeiOH1O@orbyte.nwl.cc>
 <aGffdwjA23MaNgPQ@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aGffdwjA23MaNgPQ@strlen.de>

Florian!

On Fri, Jul 04, 2025 at 04:04:39PM +0200, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > Please keep in mind we already have 'nft list hooks' which provides
> > hints in that direction. It does not show which flowtable/chain actually
> > binds to a given device, though.
> 
> Its possible to extend it:
> - add NF_HOOK_OP_NFT_FT to enum nf_hook_ops_type
> - add
> 
> static int nfnl_hook_put_nft_ft_info(struct sk_buff *nlskb,
>                                    const struct nfnl_dump_hook_data *ctx,
>                                    unsigned int seq,
>                                    struct nf_flowtable *ft)
> 
> to nfnetlink_hook.c
> 
> it can use container_of to get to the nft_flowtable struct.
> It might be possibe to share some code with nfnl_hook_put_nft_chain_info
> and reuse some of the same netlink attributes.
> 
> - call it from nfnl_hook_dump_one.
> 
> I think it would use useful to have, independent of "eth*" support.

I entirely missed the fact that 'list hooks' output sucks with
flowtables only and is fine with chains! Thanks for the quick howto,
I'll implement this next week.

Thanks, Phil
