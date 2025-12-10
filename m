Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9CE4267729
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Dec 2025 15:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765379694; cv=none; b=cbWWPWGdZzMZjdZiqUl83JwPKR3n+RQ8Jr8JtD6AZz5mDfDqWK8BwsWhSIzzOlvsc1m9Itu+0Z91TMl85xTedkygQHmPS1sgXhJQLV6FcPaa+YaWXTF7BmykGZOSBLjG4nkp+iv78pmTq/CUcYI3VRg54zd15OsuFH7z4+Z16YA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765379694; c=relaxed/simple;
	bh=AVAH4QQqEDDNRZI7ZUMz74gtTTACypgB4Gqniu0Hqvg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eNeTdsAAzYDb/36w27f9yN5u8sWWwRyaAzvI6n6qGjAREN/5MN1c/KGGFlt6IrSpsN7gmqJ5fiANE3XGTOs8cXCdMMG3qr6aI1Q9Q8MWwcPHYbth/4lBzB8nhmernMX0IjuZPSBlTceR+F+EKuNCFMjpjNhWgSwI6vOUcO0OXJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 8E58960351; Wed, 10 Dec 2025 16:14:49 +0100 (CET)
Date: Wed, 10 Dec 2025 16:14:49 +0100
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Eric Garver <e@erig.me>,
	netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH v2] src: Convert ip {s,d}addr to IPv4-mapped as needed
Message-ID: <aTmOaUEmL0P_h0sy@strlen.de>
References: <20251210150333.14654-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251210150333.14654-1-phil@nwl.cc>

Phil Sutter <phil@nwl.cc> wrote:
> Note that adding IPv4 addresses to sets of type ip6addr_type is still
> rejected although easily enabled by passing AI_V4MAPPED flag to
> getaddrinfo(): Since this also resolves DNS names, users may
> unexpectedly add a host's IPv4 address in mapped notation if the name
> doesn't resolve to an IPv6 address for whatever reason. If we really
> want to open this can of worms, it deserves a separate patch anyway.

I think we should force AI_NUMERICHOST when AI_V4MAPPED gets added, i.e.
never autofill in a v4mapped address for ip6addr_type when all we had
was a name.

> +# ip saddr ::ffff:1.2.3.4
> +ip test-ip4 input
> +  [ payload load 4b @ network header + 12 => reg 1 ]
> +  [ cmp eq reg 1 0x04030201 ]

Makes sense, no expansion.

> +# ip saddr @ip6addrset
> +ip test-ip4 input
> +  [ immediate reg 1 0x00000000 0x00000000 0xffff0000 ]
> +  [ payload load 4b @ network header + 12 => reg 11 ]
> +  [ lookup reg 1 set ip6addrset ]

Looks good to me, thanks for working on this.
