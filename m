Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5B7934DB59
	for <netfilter-devel@vger.kernel.org>; Thu, 30 Oct 2025 10:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761819443; cv=none; b=hWdtQXchUKsaRoCtDb3DzdX303Uj7C9egx8DnMLoe+S2B0uWfEvSg8zUTvK3Z6zAHRFkRYUQFPOxEMm1NSr1mf7oMlH4N+HBqCZZWdQ+juX+lGcA84J5iuPtGhrgnMXkJbX2maQwpzvqJcIA17g6biiOsgBXRJS/qULgmpSuhYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761819443; c=relaxed/simple;
	bh=XvYmiXuQBKXIVBAldhZRvLD02Er3agavOfOwi2IfXH4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MPf+DkIcHRPfcZl6uhOmCElM22gQbFI3POjx+E1Y73BPJRXyFfhLFWY5DjwMj1zXyenQeB5ZCTtYLb44ZIbO8r/YCR2PUvKNVQDWe/3vn3UwpA9iBySBznZGF9sRNQwKuUV/y7U/tVokMYaHV8lCSmKJvV2KgBhorU51txAAd08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=dZjF5bz9; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="dZjF5bz9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=1f0Ynqro7fMmWEcUCN8GKYFVL0236Hq7HC1BO7p8jiU=; b=dZjF5bz9iBRlfTd5SCLGMN2GWf
	Bw+qoFpfgg4U8kJ3bhu3ZhUbWlpN2yUcYy8hOaLmSwewjy5dUmqHSL2UHWudNxFXmOOQoHog54wZX
	1KeKHg9mYNthouLYJh4ykuRvC7EFKyGOlhMPfygqMbkDMGlhAuV5ALnct25vel8aLoAP+8me8ohgY
	O/ZPRXt6WjvuvIvRWHMO8B4uxQpbkPbiIw85H2L0Qv1cTUMRK16RSeY5H3U4s1sFH/hwk0iJ1RWeU
	Gubr7ukmX5skMGd0x4hD/VgY/ogIj2zALJI7CyX9z9boYBUfQvEIgLW96TBvvulze9KdN+6fn3Lbt
	zOWaNLag==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1vEPiY-0000000008e-1Zjt;
	Thu, 30 Oct 2025 11:17:18 +0100
Date: Thu, 30 Oct 2025 11:17:18 +0100
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 27/28] utils: Cover for missing newline after BUG()
 messages
Message-ID: <aQM7LkX6xFrMXLVL@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20251023161417.13228-1-phil@nwl.cc>
 <20251023161417.13228-28-phil@nwl.cc>
 <aQIM530vaoXIEr89@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aQIM530vaoXIEr89@strlen.de>

On Wed, Oct 29, 2025 at 01:47:35PM +0100, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > Relieve callers from having to suffix their messages with a newline
> > escape sequence, have the macro append it to the format string instead.
> > 
> > This is mostly a fix for (the many) calls to BUG() without a newline
> > suffix but causes an extra new line in (equally many) others. Fixing
> > them is subject to followup patch.
> 
> Would you mind rebaseing this patch and the next one?
> No need to resend, just push these two out.

ACK, will do!

Thanks, Phil
