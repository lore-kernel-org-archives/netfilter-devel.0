Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A01EF50F
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Aug 2025 15:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755099328; cv=none; b=VOfs9U+mQnDFOgwueeKRxeFFGWdLPUb3/ze+OtJpN10CmF9bOxmvbgVmRHWeAVcOfQEJVdEKKflnIHBPKAh4jG36MNOO1xR0FbIj/YfwgaCymicG/tKosTf7mIhcIh+UheBNalOernGjoWOFQUEeZAwb8PgisvVXvkat2bFcldk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755099328; c=relaxed/simple;
	bh=wm3BZO/61J2n6zSdGtuf41rL2xGhkGl2IUqkreQ76Xc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LhfRFyyJANSq3DsDbV1gs4jNf7vDOr0vV5v9g0PvkTs3/0bt9Q6aBjcv0WmnZDBwkUNyJTnjzeoivJSVqDF4TUEh0UFbaOq7CzJdxP1kFNCAJSpKPT/dC1Uc73HpJZYkFg4emBcLOI4Xzvt8iYff3JbhKbdjYuLDhyoliobdJ1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=DOYYn9G3; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="DOYYn9G3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=yhPyE0b+L2hwBeT1ZNPov2QI72dppuHmgiTXUKbgFoU=; b=DOYYn9G3omiPE1+90xqwKMTiSt
	pA8eUyu6EiEvYgyW9ZOl4Kr3wdqonjxLKNXQbA/8UA+hQFdp708tgSE7v660CAZU2uDS/KZqN/rGg
	4OQfqGlI90rajWQXzwQhM/NUJr02HZCkA4h0vBUh296zSXSs1iFzdOWi/hcZp9vC3PYUwy4EgnvTc
	FRNS3ZRJZgwkbRtMbxUIBGdr7MaPHsr+MpMw5/LZgbB9Dr3VbRN7k3dPfgzOgXtG2GEysmpZ8Nnwt
	bqXhuEuKsdHNeS1avpg9ta1aTUxIFEUPSU/C2hv2H0JWHFJyQ1o7QB/BOY+4ohmZ4e8+qv6EbCnss
	K18FWwGQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1umDVV-000000000ey-3uIN;
	Wed, 13 Aug 2025 17:35:17 +0200
Date: Wed, 13 Aug 2025 17:35:17 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] src: netlink: netlink_delinearize_table() may return
 NULL
Message-ID: <aJywtS9v6NfmXfjN@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20250808124536.30434-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250808124536.30434-1-phil@nwl.cc>

On Fri, Aug 08, 2025 at 02:45:36PM +0200, Phil Sutter wrote:
> Catch the error condition in callers to avoid crashes.
> 
> Fixes: c156232a530b3 ("src: add comment support when adding tables")
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Patch applied.
