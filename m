Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1053917333F
	for <netfilter-devel@vger.kernel.org>; Fri,  4 Jul 2025 14:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751637886; cv=none; b=mqZfzjhi2lze1kNc2lk2uyu5xeGw2dPyts0ZTBTv8MgPrEqYdvTb87vG1NXSPDC/YMB8OXxxAZaHbdSWSOQolE8pNkMTM98GfSDaj0fnYWM6VLWZ/MO4MwngKYnjmJsx3khEJilYouunnYZh2BYQGLyg6lp/5xRxZ0mz1GRDxQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751637886; c=relaxed/simple;
	bh=sEqyFtXAGfezK3ML+ekNteol6sytn2PKAUOGUzWsqJ8=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PX4bMxstYcfPVU4oXDiYsH2/o8NeGISWHxMtcu/xkhPZ+ORA7xlXtqpGr33GolHdzaukxkAukWAOivEWfgXAe9kSWeIeUI7xkjeOj2DROTZLQOZukBKV27arpPJIe+YEvwwt012GwWg8/F7jv9E6JtBstJ9S0TgIvK0n2gNIAxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id B1611607AC; Fri,  4 Jul 2025 16:04:41 +0200 (CEST)
Date: Fri, 4 Jul 2025 16:04:39 +0200
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>, Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [nf-next RFC] netfilter: nf_tables: Feature ifname-based hook
 registration
Message-ID: <aGffdwjA23MaNgPQ@strlen.de>
References: <aGZrD0paQ6IUdnx2@calendula>
 <aGZ21NE61B4wdlq8@orbyte.nwl.cc>
 <aGZ6E0k0AyYMiMvp@strlen.de>
 <aGZ75G4SVuwkNDb9@orbyte.nwl.cc>
 <aGZ9jNVIiq9NrUdi@strlen.de>
 <aGaC0vHnoIEz8sTc@orbyte.nwl.cc>
 <aGaRaHoawJ-DbNUl@calendula>
 <aGaUzVUf_-xbowvO@orbyte.nwl.cc>
 <aGbu5ugsBY8Bu3Ad@calendula>
 <aGfL3Q2huYeiOH1O@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aGfL3Q2huYeiOH1O@orbyte.nwl.cc>

Phil Sutter <phil@nwl.cc> wrote:
> Please keep in mind we already have 'nft list hooks' which provides
> hints in that direction. It does not show which flowtable/chain actually
> binds to a given device, though.

Its possible to extend it:
- add NF_HOOK_OP_NFT_FT to enum nf_hook_ops_type
- add

static int nfnl_hook_put_nft_ft_info(struct sk_buff *nlskb,
                                   const struct nfnl_dump_hook_data *ctx,
                                   unsigned int seq,
                                   struct nf_flowtable *ft)

to nfnetlink_hook.c

it can use container_of to get to the nft_flowtable struct.
It might be possibe to share some code with nfnl_hook_put_nft_chain_info
and reuse some of the same netlink attributes.

- call it from nfnl_hook_dump_one.

I think it would use useful to have, independent of "eth*" support.
