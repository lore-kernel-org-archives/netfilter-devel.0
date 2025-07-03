Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CE592E54A3
	for <netfilter-devel@vger.kernel.org>; Thu,  3 Jul 2025 12:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751546393; cv=none; b=TZkFpJrFtu5l5pcdE6TovqvvttqszuNC5fzjD4aSscJ7M9leOEWVZd1NIq3kfC2ipqvgrWMnaE1YQW+KeRNotKfRqTjDVnmbnFjYRv8FiHRz/J0k88wddhfy0kqLoq5t3CA4pBISzwi/NC9AI+LZmm/6xYhQHXJI9sPTyqXeRFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751546393; c=relaxed/simple;
	bh=wipIiAt4gMZmpvrcOfI7IJQ3BrV63eYT//2DgKqRI0c=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CUfsBpRGG/3g6wWJrRusGvdv6NwXN+0UjaZTpQBnB3YAR/wgmVOpX0+cBZFjUUo2jOnVrgv971HSEfEn34vix2k/bov68ZRKs8qr38xiZ8vlEGvo1fhINtnFLQNnQ4AkDN2OiSq8sT8uOV1xPdLBIjxUvoIDa2cvkZ/RC8vpVUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id D454A604A5; Thu,  3 Jul 2025 14:39:48 +0200 (CEST)
Date: Thu, 3 Jul 2025 14:39:47 +0200
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>, Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [nf-next RFC] netfilter: nf_tables: Feature ifname-based hook
 registration
Message-ID: <aGZ6E0k0AyYMiMvp@strlen.de>
References: <20250702174725.11371-1-phil@nwl.cc>
 <aGW1JNPtUBb_DDAB@strlen.de>
 <aGZZnbgZTXMwo_MS@orbyte.nwl.cc>
 <aGZrD0paQ6IUdnx2@calendula>
 <aGZ21NE61B4wdlq8@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aGZ21NE61B4wdlq8@orbyte.nwl.cc>

Phil Sutter <phil@nwl.cc> wrote:
> personally wouldn't care about as I find it similar to mis-typing an IP
> address or RHS to an iifname match.

Good point.  I think if performance isn't an issue then we can go ahead
without this flag.

> If transparency of behaviour is a
> concern, I'd rather implement GETDEV message type and enable user space
> to print the list of currently bound interfaces (though it's partially
> redundant, 'nft list hooks' helps there although it does not show which
> flowtable/chain "owns" the hook).

Do we need new query types for this?
nftables could just query via rtnetlink if the device exists or not
and then print a hint if its absent.
