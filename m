Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D40FB2367D4
	for <netfilter-devel@vger.kernel.org>; Wed, 21 May 2025 11:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747826816; cv=none; b=TnJPMqwlNr2AnHYQZf6YHURLk9C+AkWA+rkvb1TFGHWr/13SV5V3/2yz0h/xPHDQDYxQCu/QvY6WmwAnaE7JeY6WZ1lvREcxcRmKZUUCdK/ddBOpB0QR8pLAZ9g40e7w/p9uLvkUeLb3mvK22jVxa1xhI9IgnreFC5YxxBVh9UI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747826816; c=relaxed/simple;
	bh=knkjspcco6Wnb4QO35j4NNNT3ZBkMWTRoaxVUa2j8rQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bI0vI9iT9C7FDZAUEyMJ2N2JemxBxv0LoxGT1Fs12fvg7jnYw+5GmKNk8PPDAf7TbpGboBrnce/Xlz8RcnADj7vBbDo+lmcfQQGAqwRXvmdc0uzEaIER1w0EotahcedLKAwCxyjt+0fX5p5GXl/YPwbdwWpPOPGzd6GWVIXWAsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 9CB6460167; Wed, 21 May 2025 13:26:52 +0200 (CEST)
Date: Wed, 21 May 2025 13:26:00 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 2/2] netfilter: nf_tables: add packets conntrack
 state to debug trace info
Message-ID: <aC24SHR6Jl0uMhVl@strlen.de>
References: <20250508150855.6902-1-fw@strlen.de>
 <20250508150855.6902-3-fw@strlen.de>
 <aC2eUd6OOxn9ramP@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aC2eUd6OOxn9ramP@calendula>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > +		if (nla_put_be32(nlskb, NFT_CT_ID, (__force __be32)id))
> > +			goto nla_put_failure;
> > +
> > +		if (status && nla_put_be32(nlskb, NFT_CT_STATUS, htonl(status)))
> > +			goto nla_put_failure;
> 
> NFT_CT_* is enum nft_ct_keys which is not intended to be used as
> netlink attribute.
> 
> NFT_CT_STATE is 0 which is usually reserved for _UNSPEC in netlink
> attribute definitions.
> 
> My suggestion is that you define new attributes for this, it is
> boilerplate code to be added to uapi.

In that case I would prefer not to use NESTED attribute for this, i.e.:

 * @NFTA_TRACE_CT_ID: connection tracking information (NLA_U32)
 * @NFTA_TRACE_CT_STATUS: connection tracking information (NLA_U32)
 * @NFTA_TRACE_CT_STATE: connection tracking information (NLA_U32)

... and so on.  I see no potential for attribute re-use.

The only argument for NESTED is that userspace can check for presence
of NFTA_TRACE_CT/NESTED instead of checking each ct trace attr in
sequence.

Whats you preference?
