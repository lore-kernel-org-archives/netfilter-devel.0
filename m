Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=151.80.46.58
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792760691;
	b=OBW+32sn4rJtUmrIwWRH4czaUBDVuGLAHnYzUILgeP0TCm1hkPk4Y8HkPAceGC3qy3uX
	 fLmkiwnnFZOoPxBauu6Zd1nyAioICWDgVbUfCC1q/A4zQeHWV3+JAeV6gwbnbnXGYGki7
	 bv4h3SYVHIYQPaYDf6tWXW3GnJy+OKayi4zvu5fI4eJSMt4VxaQxyDGdu61XLMBemKdWK
	 zzwPD9e+xhWVsGCArZjEel/uxaGUFhuHySwX/IfvS4BaairNIX2W7/mIccfXaQmmbHRVE
	 PH+31pCtsVTsgWDMh8wTS3HElLh2ARXDHk4+he0XyAdbuQ8vAvwrUMPUwpPohRnmOuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792760691;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To;
	bh=XzTkKGmsIi3zk1lBNvCXvpAQPUeEzBYlYCnOar7Iwz0=;
	b=IZYcvtWkDcSuNQZ6r+CLfxCtnMfCCYjBssLIkI8q7RiVVLESXTigp9fS+3GSW0NEmkq+
	 MCPwZqcLWy3nX8Z1WYw59goyNElyuZwG2IXNld5mNCcbgw1n/7TYt4BnAoh7HWv+sfzMx
	 xb7pB3RszeOie5LZG3nKrjn+kk//i6AKllH0mAcqBw9WPlt3ZkC52m8mOOuCxzfDFxF5T
	 uw+zbp4OE6N4ZlsvR3Un/R2kxWvOc5coTcCfJ6TTCASHbaHV4gxHZlXEy/7XwZuMuHXXL
	 rpuyvMkRW8bvtKBRROwGjWsSmJwZi1nc7BZpRfLU3HZfSibpHoNdBNiWYkoTR60nTSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=nwl.cc;
	spf=pass smtp.mailfrom=nwl.cc;
	dkim=pass header.d=nwl.cc header.i=@nwl.cc header.a=rsa-sha256 header.s=mail2022 header.b=CqvSFFx+;
	arc=none smtp.remote-ip=151.80.46.58
Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C7C3606A31A
	for <netfilter-devel@vger.kernel.org>; Fri, 23 Oct 2026 13:04:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6C7C3606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=nwl.cc header.i=@nwl.cc header.a=rsa-sha256 header.s=mail2022 header.b=CqvSFFx+
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=XzTkKGmsIi3zk1lBNvCXvpAQPUeEzBYlYCnOar7Iwz0=; b=CqvSFFx+rfVei6uTTzz7HvxSmQ
	BmZ3m5E9ZnwajQhBvpHZhWMhSYusq321d1pSBzcbElGR/a+oAqvPYdY2asOUCIXLUm80NgBrVNG53
	BalWdP0+xU9ghtCSSKL/dSOLTli3dwjzqhx8/zz/LdmqX8TVBT7T4DhgQ/RSNg9p/yZr48t8gcDUm
	ECTeaN5bOW6J3g6PN29oYTF48vEDoAgq/+e11hG54D8GfwSsHl2QbDGJWbhUj8Kg3TWZ2LlAo6jwm
	m+PGnoz0AB0DDraD/hDcTVh+LMO+qWdSCjhfgN0kvkbZWAJ1dmcDUagN2K1MzC6zdeZ9gvZWSbvOO
	mnPE5Llw==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1xKEwx-000000002SC-4BJB;
	Fri, 23 Oct 2026 15:04:48 +0200
Date: Fri, 23 Oct 2026 15:04:47 +0200
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] tests: shell: Fix for spurious fail in
 maps/typeof_maps_add_delete
Message-ID: <attbb5tyYBtQRjU2@orbyte.nwl.cc>
References: <20261023103603.1048380-1-phil@nwl.cc>
 <attLaqI7J7QcsupL@strlen.de>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <attLaqI7J7QcsupL@strlen.de>

On Fri, Oct 23, 2026 at 01:56:26PM +0200, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > Testing on a (probably slow) aarch64 machine yielded dump failure since
> > ruleset listing had '# count 1' appended to map size statement. The 3s
> > delay supposedly wasn't long enough for the element to be reapped after
> > disabling.
> > 
> > The test itself seems to perform all desired ruleset checks though, so
> > just drop the stored dumps to avoid this problem.
> 
> Annoying, but spurious failures suck more:

Well, there might be another way involving timeout and gc-interval
tweaks, but AIUI the test didn't intend to check gc reliability or
"performance". Moreover, delayed execution of gc due to high system load
is expected, right?

Sadly, it's not the only test which becomes unstable with system load
and delays. Looking at estimate_timeout in sets/0044interval_overlap_0,
variance in system load may also reduce test stability. :(

> Acked-by: Florian Westphal <fw@strlen.de>

Thanks, Phil
