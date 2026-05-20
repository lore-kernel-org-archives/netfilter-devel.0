Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4570C3A257F
	for <netfilter-devel@vger.kernel.org>; Wed, 20 May 2026 09:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779269166; cv=none; b=otbP0xg/iX4ra1aLdRTDZgHuMgnG9VVVifBrdJjpOXMQ6OwyCqxmyhXHbJGIpUD2HJVQbKRQ59DM66pLgRXOQQdUP1FaxGdQOUn931FzmJHKf1C8qqVKjYaISQ2r6lch+489d4K+7PjuVeG7At6Oyn4OXF3xT9mG4Vz4TPmcmmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779269166; c=relaxed/simple;
	bh=Ri53PParVAiOAl8z65C+soaB4z6RfA5xEWQ6nmXHNNg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MfUv6TlIKDvbEgIfzKeaezMxr7ynLaquEEKIqLo0rua/vF1LzBFj5t+tPduiOCIz94BkwyGkqh/sMR34JEPT7mSxhsmeHTd01/2YjPjn45sL/XOfu4k9IbI3C+SRlHDVTHLGt+vQQcgEne2NQJ+35EyXa3k2ePZAoAKHDvbj2DY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=GnFCO4gt; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="GnFCO4gt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Zmt9ZlT+hbCRcEo+KbLMEqSt3USJpIUbi+PeTjXKX/Q=; b=GnFCO4gtja6YMro2ZV34OsOOgV
	gNCPyVg2pPwPxEtQeUy53GOx+Q5/nYIZSKn1Df5PPyy1OOfDhLtjPUnkOAQMj22jLjCWRwPqOTUnH
	tY40yKZ+5o1l/yOhzw1byuVUblhfz6lzTF3sge57Lik1DAivGHwYcpB8bwaCkVyEmOHaNtN/upmE0
	w/gox9nq0upOns0pJDO1JRjUnQEtFdUwwXMm4/UWP1TLva8uyFmBQ0Vmzav2p24HYVrnRQTHmP5Op
	uQNDXdQPeQnGaf+cBWGk1Vze57SUTRrXgJvnfCjRVXsFDoQstTqJEk+9BSfeoLPFR/x7gRPHdx/hk
	9C4mpUyw==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1wPdBh-000000006F4-0gxe;
	Wed, 20 May 2026 11:26:01 +0200
Date: Wed, 20 May 2026 11:26:01 +0200
From: Phil Sutter <phil@nwl.cc>
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org, fw@strlen.de,
	coreteam@netfilter.org
Subject: Re: [PATCH nf v2 0/3] netfilter: nft_fib_ipv6: handle routes via
 external nexthop
Message-ID: <ag1-KRkLjQXHa6aJ@orbyte.nwl.cc>
References: <20260520023411.391233-1-jiayuan.chen@linux.dev>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260520023411.391233-1-jiayuan.chen@linux.dev>

Hi,

On Wed, May 20, 2026 at 10:34:08AM +0800, Jiayuan Chen wrote:
> Patch 1 switches the fib6_siblings walk in nft_fib6_info_nh_uses_dev()
> to list_for_each_entry_rcu().
> 
> Patch 2 fixes the slab-out-of-bounds when the matched route uses an
> external nexthop object.
> 
> Patch 3 adds a selftest covering single nh, nh group and old-style
> multipath.
> 
> v1: https://lore.kernel.org/netfilter-devel/20260519041431.396218-1-jiayuan.chen@linux.dev/
> 
> Changes since v1:
>   - new patch 1: list_for_each_entry_rcu() conversion split out
>     (Suggested-by: Phil Sutter)
>   - patch 2:
>     * drop redundant ternary in nft_fib6_nh_match_dev_cb (Phil)
>     * drop redundant "!= 0" on nexthop_for_each_fib6_nh return (Phil)
>     * use READ_ONCE() for rt->fib6_nsiblings (Phil)

Will you send a v3 addressing Florian's concerns regarding the test case
in patch 3?

Patches 1 and 2 look good to me, thanks for the respin!

Cheers, Phil
