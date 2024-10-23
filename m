Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE331154BE0
	for <netfilter-devel@vger.kernel.org>; Wed, 23 Oct 2024 20:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729714768; cv=none; b=H3GLQMpxXEOh1Vpai4vvVwwKqcDdOuRaMCWkJsgRZALhiMrth07oy8VQpIWYW6W8Hbjgoc8G1YS2ikAdOr3iT1F4B7QkLnid5qe+nuvbLnMXXnxfb+XeC2cezKLhPbAH+z6n+bS353+HxRsBo2ilP4PIhR2ayKuge99lqCBPHcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729714768; c=relaxed/simple;
	bh=SF+JSPe7HeUQ+aaPCjZU7uGWY6OrMNZQZ2DgE/fe2CY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qgwfE3xk/0tea70dHFLAsKdlPYmwbCMxniVFlY/u1gFT5mUY9J/rU3KWrtoM4Dk3EP+6c6slwZbqx9bvBR9kg1DRU2erO1FhzcH+D+IZfXjcDdJcfgkRlHoO42ovYBbfNsYUDYMRZA2JNp1F8cZ9o79NOFchK1qJKomoyP4NDm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=T6Y/OU48; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="T6Y/OU48"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=JMukCwyof4keStHT806D0lRxZLQLq374629jKallI+g=; b=T6Y/OU48JIFJ0oab+5twNTwKln
	BcoAh4Xthz33S84Svk345GTjHsCt5wkieroLrOBzLIEn30glG2i8hq0Swmhipy2pr08FLCYAdS8LQ
	6faRp2CQ4Bocx8DnJz/zBFhRNZu1eQ4miPMps3kTbwRmagXtLQ7QRf0BS5+7ShIq13TQq6QO0DfAu
	e5hTmjnBNU8wXLhIECA1/YCpVr+LG8g3mGb8rzQtbU4YpWyn5lm1KvdTe8AWLMSwXo8/PSBHp5YZe
	v1aDR+hZkJilpYAuQaO32xGxADYLrdSdMfsZD1ZbUAIV+xc6Q2MKk2aLpUdq1Qc9TFklRQTlNpzUt
	NpE9Rlwg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1t3hpF-000000000vB-0IrE;
	Wed, 23 Oct 2024 22:19:25 +0200
Date: Wed, 23 Oct 2024 22:19:25 +0200
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [libnftnl PATCH] Introduce struct nftnl_str_array
Message-ID: <ZxlaTdMsvDDDD0Yg@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20241023200049.22598-1-phil@nwl.cc>
 <20241023201304.GA29876@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241023201304.GA29876@breakpoint.cc>

On Wed, Oct 23, 2024 at 10:13:04PM +0200, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > This data structure holds an array of allocated strings for use in
> > nftnl_chain and nftnl_flowtable structs. For convenience, implement
> > functions to clear, populate and iterate over contents.
> > 
> > While at it, extend chain and flowtable tests to cover these attributes,
> > too.
> > 
> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > ---
> >  include/internal.h         |  1 +
> >  src/Makefile.am            |  1 +
> >  src/chain.c                | 90 ++++++------------------------------
> >  src/flowtable.c            | 94 ++++++--------------------------------
> >  src/utils.c                |  1 +
> >  tests/nft-chain-test.c     | 37 ++++++++++++++-
> >  tests/nft-flowtable-test.c | 21 +++++++++
> >  7 files changed, 86 insertions(+), 159 deletions(-)
> 
> I don't see str_array.c here, missing 'git add'?

A classic. :(
V2 is underway.

Thanks, Phil
