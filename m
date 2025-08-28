Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ECF1255F39
	for <netfilter-devel@vger.kernel.org>; Thu, 28 Aug 2025 10:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756377712; cv=none; b=mY24gOwIhY7a0yXJF/G9Ee1OXVzcBa5OjqkXL2HWXo3CtN/78vnm2lIMq46lgcDpa35vkZN+BsX5HRW9QI4yiNi6va3KtWZ4GJVj6lbXo187YQjFKYPlzFgFZ4324ts3bNcoIYsrS7IUz+A1mTduzs44sj4M02ezO6Dn17g7fIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756377712; c=relaxed/simple;
	bh=WiflPXohJGb7FCwtFQZP4GQF5iavcFQwL6VsO4OZPcQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kFtyxXrAvGqoJ3RT6CToFeYfLLG/DfyRmoS74WrSgEWvxH7G7VWuEKvXcM5c/zTg2VjnMJA4ZZG6U4whO+uGOyCjdJxHAnzDm5peGLCNiAuKB8zgrdZQ8mb08DdYGPh4Hz1W4rfiQmcibaWCEBsdllk9R+CsWhWvEy8bFS57dxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=b5xjN7M9; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="b5xjN7M9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=NWU4d1LZPfVDlgsxfYMJuXciqqRTzlWxi8DMl2ysavk=; b=b5xjN7M9g1hFcbTeyGa4nN+iIK
	jokC1LV0/8cTR6IBEIOKwUyUHnjO9qFl1wkehppgR6DBLNDvVINGXI/rpNmbdbeB8sJtncjCZEGrC
	4OMP+TOXmyMMs+GSd1bIqmh/ZisnIKjcomolaBiCCz3/iUCVxBF6AHqS5TwYbSnj9LvisMkr33Eaa
	vby4J57O2mDfyX4rYp7UjFcqe/CQfKo7dBGF5eWXq5eWTqmRKnwp4tD6rp3Ww6VX5aDKAZvcaUZTs
	pNfFVTq1RDSeZ6P/uYQrhEHGIXfXAQjO4TmJTKynVXJcN2Rugiq5jFuuNNwo2KQ9rDgFiZxG7azgJ
	O5o1C7sA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1ura4i-0000000024A-00fi;
	Thu, 28 Aug 2025 12:41:48 +0200
Date: Thu, 28 Aug 2025 12:41:47 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [libnftnl PATCH] udata: Introduce NFTNL_UDATA_TABLE_NFT{VER,BLD}
Message-ID: <aLAya7ldEJjVVEPD@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20250813170703.28510-1-phil@nwl.cc>
 <aK-LJaptoYyZhmbe@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aK-LJaptoYyZhmbe@calendula>

On Thu, Aug 28, 2025 at 12:48:05AM +0200, Pablo Neira Ayuso wrote:
> On Wed, Aug 13, 2025 at 07:07:03PM +0200, Phil Sutter wrote:
> > Register these table udata types here to avoid accidental overlaps.
> > 
> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> 
> Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>

Patch applied.
