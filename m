Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7B209443
	for <netfilter-devel@vger.kernel.org>; Mon,  8 Sep 2025 07:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757318374; cv=none; b=BDy6ZCTVBqsQ9o7DzXJ98QEKDDJZf0sHO2muQ/Od33vWq37rxfPIem+IVV/e2qLLqpH+75UE5jh6J2R/93hh66m1GCPxl20fPnwYfryd58fEy6i4Iqp4bnQ+6hrWNuVqN7+oIV17TLGA/U2gvxcXY8fXXYQlk2GES0uPFq+274I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757318374; c=relaxed/simple;
	bh=Z2Lhr5a2i2bGHjMkLA1TNGHkNTp1Qd6JMr0mb7MdnUA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A3UPLg4WqI9pQRoKy9k83zFQ03/APRqVG4OVcQIBefGNiO64TOhIp6zS8/RKfnQVlmAfd2OsDxhOaB+K+o5y08mmJse30lVcZyTiTDQTaWw7AeaK6dKkMDxKokirSllUO3NOv/bIQgjYqyQJN1kgb7noNEXuJRbu6oTC3QKPqvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=IIApRYto; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Tax8z2gy; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="IIApRYto";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Tax8z2gy"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 1222860269; Mon,  8 Sep 2025 09:59:20 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1757318360;
	bh=glK6Jtvl5IGIoqXXYGrUw2O7MyXMRrlwRsdRJUvuJiA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IIApRYtou/n73qgGM1zwkbiNW+R9owuhMZUHDo7eke+d9X+pFb06JgBq85IWvHIjr
	 5Mm0LOkaLfuqg4H+B3X2s/4kRHfcXKg3+ra6TJu85dRpD5fPSTEw++H9dRwXJ7KTym
	 i7q9H4yvMNUd3ULgmAPcghAkWAWXx60azm+mXrcMrbai/V7icTscTmXpf6/xTbfziP
	 ABK8aMqmbMLBVfKEyKS7kZ0EfdbeIEFOBx6w0bI9y/QqKI7Xv3UrjGXtShfrQybbo2
	 0Uls4k1rmgDxFWpKQ2RTJZBLlr+ODobpENxspboiBGLKPAzIpAJ0ERJs6EYKjat7Uq
	 K0bMTKY6uZ1sQ==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 6D0AF60269;
	Mon,  8 Sep 2025 09:59:19 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1757318359;
	bh=glK6Jtvl5IGIoqXXYGrUw2O7MyXMRrlwRsdRJUvuJiA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Tax8z2gyxJY74ygYUtaTNT5OYHKJ4dNNYGmYkQqMf1W4HqelPmr9qL8u/+J7Nf3yk
	 SXlQjaPQ39nLZX0dyW+rpd8XHl5fvCeDk0NeciqbtjIlc9jCeVtNWiOsbS1hWYrThw
	 HLsFXHPCv9me4s7Fk++O/NAEvxOZxr1fIkhxLPUX6z6kDuAHgUHRD6zb6wiGMCErp4
	 Awl/z2MmIIk7dUeSkOHBfoD9WH1OsdGrskfR7OCwvCIvi7/IH50t9p00kaAGb7JYCZ
	 p8kvcRFmBH0HO3OvTk00vWTb3A3rfYHuoStV/WvLnri8jgAEPToBp09q0+Op/rBCtH
	 j2d+C1K4SEinQ==
Date: Mon, 8 Sep 2025 09:59:15 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 1/7] src: normalize set element with EXPR_MAPPING
Message-ID: <aL6M00mij3wKi1RX@calendula>
References: <20250905153627.1315405-1-pablo@netfilter.org>
 <20250905153627.1315405-2-pablo@netfilter.org>
 <aL2SbBTVwjeo1UA2@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aL2SbBTVwjeo1UA2@strlen.de>

On Sun, Sep 07, 2025 at 04:10:52PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > This patch normalizes the expression for mappings:
> > 
> >                                        EXPR_SET_ELEM -> EXPR_VALUE
> >                                       /
> > 	EXPR_SET_ELEM -> EXPR_MAPPING |
> >                                       \
> >                                        EXPR_VALUE

Oh, actually this is wrong.

> Is the plan to eventually rewrite this to
> 
>                                          EXPR_VALUE
>                                         /
>   	EXPR_SET_ELEM -> EXPR_MAPPING |
>                                         \
>                                          EXPR_VALUE
> ?

This is the correct representation, I will amend the patch
description.
