Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B05141F0E29
	for <netfilter-devel@vger.kernel.org>; Thu, 26 Mar 2026 15:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774537255; cv=none; b=XuAW91xxU6rknQLvdEbl9AM5hZ09VQSWaQTexxeu1qZ/DXZW20CVftTmIBdkzbbNFEF1ZGQywJGAMj7XVjNKiSsjpoPbJVVswrQTzyX+BV7xnpoQD8Uf8tdlod7bHrO5Ee0KmZmdbsRtMNJKfNZCXaMyMUAlF8EDQ+1Fke3htVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774537255; c=relaxed/simple;
	bh=8tAmm+DtkXWCYlh3mK/3ApFG3nBhmty0nCI/eghPFkI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZZC6/DFJPkPr+hPiwqqsSvtCacSJ7dvd296LGkU69M9qS1pPYEObiuUWh5cqh6LsiTrx5NCnuAiCPDKMMR8wapX8/r7Vc8+WH1K6LBBHAhVlQmNGpBQNDfSdj9U+G6GmifytTDe9FohO7fUcpbX4o2PB8qS8Wc3DsFNzmEMLNv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=wB2evPLZ; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="wB2evPLZ"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 1E09B60178;
	Thu, 26 Mar 2026 16:00:52 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1774537252;
	bh=A+AUz/daPvD/Q/4tVs/GtdEm7/n00MTM3Js37l2/otI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=wB2evPLZVapnm2n+B4v8rCv7T/uhvdPwhVI1zFK9YwKsKcWaT670k7YCChdgYlY5p
	 CK796KW51IHk4ZdHSuCL965BbrZzTeg9qe3il8inBfM6Ag5aP6FYcv6vWv6ZdSQGWV
	 01Bh7G+ChSxKpEZ2V2bMDQbYt/x9VwfmZtLh3P1g4/Ebu6sRpxEdd5zrttnYPYUfvS
	 Pgg6V/KnorADLNpBGbFelPbEN+cbWAwOj6iPp/ufq+rcyC8BNAb7hmEApzrrlLnQ5D
	 7p9nZRid3ohqf+Qr6u4CWrAVPBmZOciHFx0ackJVC16E8KGcAnVAb3CylPnfWkuOjI
	 D70v6J+GHGLVg==
Date: Thu, 26 Mar 2026 16:00:49 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net,v3 00/12] Netfilter for net
Message-ID: <acVKIRZre0_pQURV@chamomile>
References: <20260326125153.685915-1-pablo@netfilter.org>
 <acUxw826gEzIv8Zp@strlen.de>
 <acVGWE6APd2itKyu@chamomile>
 <acVGyl-UKiUQShXH@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <acVGyl-UKiUQShXH@strlen.de>

On Thu, Mar 26, 2026 at 03:46:34PM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > If anything, we should also consider this (not even compile tested):
> > 
> > This chunk below looks easier to understand.
> > 
> > The issue can only happen from nft_compat, correct?
> 
> I don't think so.  I think you can request any module that
> registers for NFPROTO_UNSPEC from arptables, which, unlike
> bridge, doesn't have compatible hook flags.
> 
> So we need the existing patch (or a variant of it) in any case.

I mostly stumbled on my expectation series, Jozsef's and this specific
patch particularly yesterday late at night when making a second pass.

Let me have another look on this one later today.
