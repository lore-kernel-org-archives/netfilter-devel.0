Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF83E204592
	for <netfilter-devel@vger.kernel.org>; Tue, 15 Jul 2025 15:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752592115; cv=none; b=dtnG+F3dQ4wrYgnAgpso65H4ViQamPOL82903UjxiqVz6bQiThPTBoDuUnoj727fT9j8zue5aMMXGXGCchSmJH/IZO4rI3u+mc/AmPYgXoWCqoLu1cvBvvbP+fa57YCd3lwB0ELtaW7wX/KMuAIk3pNGHoBvXJWM6HA9obop83I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752592115; c=relaxed/simple;
	bh=pFICUsrsAO7HAWzuYgV2o1glncqDSCp9l8j4xjhvtUU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sqGmH/6jqNBWa7SrbzqlDXIIyZx8x7XpmBNWC9K+Tbh4FZjktNPJPZdYoIA+ncOA0NvaYnReKqbeULpGMog7KTjk/fj6Wgzcaexz/vzGiQv7Dq0LiMNLZ6vI6lMsF40AKjQz8tA1vuqISM8COl9Lo8tQro5Jpolq5w68LsR8v1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=B4tC93rb; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="B4tC93rb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=cWbcbHlu3hgntzATYImBlsalcaYjao1jOhr14vNoCuc=; b=B4tC93rb+sD1Fa8abTAkPL2tRb
	i/ZZ4Gbcy0dKziUoR3rhl9VpVN1/QCAkyY7cWV7/5S0Utb/2V8N6NNxF6napvK2b7EIW6DTlPGXJ/
	YVEk6n6BPheuLZOhbte//heZSIC3EKpsmA4l8UPMLUOCoicjpSngBWsFCbNWJeYUNQhV4T4w4AxT4
	oWrVQWrobZWnfJ7S07TfoLRuZ26y9Hg2Ppz5zK7LiZSbc1QWxV6TOUw0JqGpeGw8THN3CTEY9KdNN
	bUZCCVtyoQd+7p859d9IVNlKrC0U0qftRxVkmqrEt0hSYi1ePWVsNDlY6+1wppOZ+VRFMYahYxJao
	SLwOZAXA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1ubhGa-000000001lt-2qyV;
	Tue, 15 Jul 2025 17:08:24 +0200
Date: Tue, 15 Jul 2025 17:08:24 +0200
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] mnl: Support NFNL_HOOK_TYPE_NFT_FLOWTABLE
Message-ID: <aHZu6AIsy-lAe6n-@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20250708130442.16449-1-phil@nwl.cc>
 <aG0hqMPin_1AjNnT@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aG0hqMPin_1AjNnT@strlen.de>

On Tue, Jul 08, 2025 at 03:48:24PM +0200, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > New kernels dump info for flowtable hooks the same way as for base
> > chains.
> 
> Reviewed-by: Florian Westphal <fw@strlen.de>

Patch applied, thanks for the review!
