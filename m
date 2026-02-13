Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AA2D3590C3
	for <netfilter-devel@vger.kernel.org>; Fri, 13 Feb 2026 13:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770988644; cv=none; b=jy+zcYDFy+ReaZ3K8ZNw+xqY/xIWDCyPZC8FaDrjCYbxgKVlDLdwufBZWunyYzfJndz2S8q0pwliUJzPAkXGdhkeLXSIIiJ7DJ5SbmSLoPrCXu3h6sFKi73hUqmf+tRp6Gc4ZeBLKb/NhJTKK6Fcqs2nDhznmTBqlT59vOxq7Jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770988644; c=relaxed/simple;
	bh=vA7OBfLXRUL7UzZImDg8jXRz8lKli37a8OrZM9YTUGs=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uxPu5xCpKdfNCr3rvf8WiiCmceM56QZVmBzlJUVGAfdLfRnWdBw5pk3emJ7W1Y6L5zN5t5oVenGTDvbMO/pVf2OSEAgjWstdjmQtbXhAtcwGC0JPj+/LiVpJhEx4ZJ8s2BpzSTftI26vMTJH1nl9VF9N4kc+5346BJAgYwGXdfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id AFD19608AD; Fri, 13 Feb 2026 14:17:19 +0100 (CET)
Date: Fri, 13 Feb 2026 14:17:19 +0100
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>, "Remy D. Farley" <one-d-wide@protonmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH] iptables: fix null dereference parsing bitwise operations
Message-ID: <aY8kXy5ZlvVIz1Ul@strlen.de>
References: <20260202101408.745532-1-one-d-wide@protonmail.com>
 <aYz2eUev4mUdN7uX@orbyte.nwl.cc>
 <wsfxGCi6FNb3Qj2_tw3b9WZS2spw8DyUe34OgpSzj8UQg7tNdw0RReS7iwQBnoVIHfZOIFoCUFf6mVAVOAGCSabgUgWBa9yABVwyAzNI_lc=@protonmail.com>
 <aY8hvMbo6JVX5hto@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aY8hvMbo6JVX5hto@orbyte.nwl.cc>

Phil Sutter <phil@nwl.cc> wrote:
> > > '== NFT_BITWISE_MASK_XOR' and drop the comment.
> > 
> > 
> > It took me a while to realize iptables/linux headers are quite outdated,
> > so NFT_BITWISE_MASK_XOR is still called NFT_BITWISE_BOOL in there.
> 
> Ah, sorry about that. I merely looked at current kernel headers to check
> if that magic zero could be replaced by something more descriptive.

Lets refresh the headers, then.  == NFT_BITWISE_MASK_XOR would be
preferred.
