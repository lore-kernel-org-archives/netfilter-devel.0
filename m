Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794421669;
	b=kMUzvycKfVbSv8cTfjtuHzw9rRAJC6l2+qMrfDBSjYjqHsFpzF4wcfP3297gIaXoQDnp
	 dmi+LCwzV58Sw76D55JjAJAeBxHfpABP05nmCVBHkQWoGWhVFsICaqMqgH81RuGlb+UfC
	 HiJaH0ShQuN3L4YIm1svt96N7jz1s0wMR6NcoGNIGFKoOyoXZFgNm++q2bUVp3MdQqlZK
	 tJVDmtUQOKmfxPyuQkgQ3LHKl72pOzW+SlIOYr9MTp6aufuYm5HflfplaYF8hACvl5qtN
	 XNuMriuy7bjtqMB+gUQFRa47eqHfHl2bjgcl4l8O1eNvMr31qXBPBJ0+PxR5E1bBHig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794421669;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=eGv5Q5yZ+w3Y+bfQSTIcUR0OvcANuOUbemnt/BvWBaA=;
	b=y9Qodnzyq2kVHgtW8V/JGDu686rE+DBEih4myTAHZ+6rq0yeBI3kTV/eaPHuswPeCvzE
	 7ZAN9zoN0cwgLAoKBLS+lFwP2Xil85pJImLl+W7kdzYCgoyT4lxM8C+vnYMh4jGL4S/Q6
	 67iVd/ZPP8yErBlAXwpRn6Z1FIbpZlbwZ7d/2XCDPXhVJ/iZquOkZiNePZB3/d7KOAEYj
	 D/Yk+ATm1tEowI/CvNzTtmv3JaIpWB4ACuOXRu/ggm+SyIboUqfg4F0o6Ir0fTrsVmWnk
	 xk6eYCuw/lpXfBYerZk7phSUMqgFPk9dsyJE9HCK+0GuVd+Y6KsixgXID2b3fKdtgAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=strlen.de;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2DE3606A31C
	for <netfilter-devel@vger.kernel.org>; Wed, 11 Nov 2026 18:27:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C2DE3606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id E358660420; Wed, 11 Nov 2026 19:27:39 +0100 (CET)
Date: Wed, 11 Nov 2026 19:27:35 +0100
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org,
	Yaron Shragai <yshragai.firmware@gmail.com>
Subject: Re: [libmnl PATCH] include: libmnl.h: Add explicit casts to macros
 for C++
Message-ID: <avSzl8-2uom7Mntt@strlen.de>
References: <20261111153054.44763-1-phil@nwl.cc>
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
In-Reply-To: <20261111153054.44763-1-phil@nwl.cc>

Phil Sutter <phil@nwl.cc> wrote:
> C++ does not like implicit casts of void pointers, make them explicit
> there. After adjusting similar cases in example source files, these are
> the only needed header adjustments needed to compile them with g++.

Reviewed-by: Florian Westphal <fw@strlen.de>
