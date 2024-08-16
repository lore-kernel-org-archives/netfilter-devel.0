Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1CC412AAC6
	for <netfilter-devel@vger.kernel.org>; Fri, 16 Aug 2024 12:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723811123; cv=none; b=uMmiH3/9vjq/g9d6FdvtrpEdq2cXT2ef2Rumy8rt6b+7Fo1jQvMNb4KG/8uO5AVU6KG76jiQMShCYNiRoW+yRmHSrUPbq9rxjh7efUxkA4Vf9Fddn4H3FrRm8CumkR7EuLVmg5THG2Kc9gHZ+TmQqZikGu+MWMcExlY1ZKFfgWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723811123; c=relaxed/simple;
	bh=uyaKEs753Dc3DowTaxGtBYX/QE98s7KWTWm/O5PE9CE=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O/31TE90k6aAFwnsQnLLnJ2bcqQSqkkgKlVHnH4LGqbvtO3wNQfMfr6BunsA+j4hLPx3j5o4GzBiEJP//LtHkKdrfhRvKglH0ZnKyimOvMZ2TajuWPUqeJOmpByfO7FN/VAq877XqrOy/Ygm/A4maY4nC+gqwNgG/mE5yjSMNb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=XuokqtFh; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="XuokqtFh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=uyaKEs753Dc3DowTaxGtBYX/QE98s7KWTWm/O5PE9CE=; b=XuokqtFhuURZmKYB3Sh131b0aH
	rXSZXrxDgCNPUYMYHD2T5G2A+1V4rxa8GC5s0hx//7oNad/T45k3m+6HCk1vOkbiF/l/ieORonrKo
	WRBHbfeiExTeHK/yMBbK3rR1PcIAiOpuBC20lMPWGydCJIxWFQpzjf2Bml5P3HYUhQfAxPTbJVgzx
	gzYXuakoY2z/khzUNaEvOxloRSegxnHvr5s9f3qEgG5MXWEeWIaWjE5wiwCBiOKo341Cr/b7TGDgK
	bQam3APX87QAPTPi1uw+xO2iGwMgi59CUBChUIBRES/qYP3n970Xt26biWV+AKHJzzImEdvHcmTHy
	G8mg4JWA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sew12-000000000t4-2XcV;
	Fri, 16 Aug 2024 14:25:12 +0200
Date: Fri, 16 Aug 2024 14:25:12 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft,v2 1/2] datatype: reject rate in quota statement
Message-ID: <Zr9FKFg8bnfQrqoZ@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20240814115122.279041-1-pablo@netfilter.org>
 <ZrzUt-8mZoqdY0ai@orbyte.nwl.cc>
 <ZrzWpcQehJBmss13@calendula>
 <Zr0E7BZu3fowGLBz@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zr0E7BZu3fowGLBz@orbyte.nwl.cc>

On Wed, Aug 14, 2024 at 09:26:36PM +0200, Phil Sutter wrote:
[...]
> Maybe one could introduce a start condition which allows strings, but
> it might turn into a mess given the wide use of them. I'll give it a try
> and let you know.

Looks like I hit a dead end there: For expressions like 'iif', we have
to accept STRING on RHS and since I need a token to push SC_STRING, I
can't just enable it for all relational expressions. The alternative is
to enable it for the whole rule but I can't disable it selectively (as I
had to enable it again afterwards without knowing what's next. :(

Cheers, Phil
