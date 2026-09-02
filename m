Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9B7149C4A7
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Sep 2026 13:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788355000; cv=none; b=bk18z/fF8IZXP+ebAnZ6jYLCUnanVeY85Qx1QViJlwfrT7SMJAQBSuBXLgYG0krtLRJWIgbfPw4CgJrzBXgwWgqVF/qe4wGGfet7GhPx+je3e/TuePWqS7HfKAeyyLTkniYS7ijtQ5+za78JJS3Ek9MoGZ12i82Kf9BuOyltWk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788355000; c=relaxed/simple;
	bh=c32yN9ViCc2T715P+KWwuLTGP0CM5xscmtHKRajbu78=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uLAkM8Fhdg/RhTWbw/4Q1BK4p+7x0+RR66w98VxrX+KriztZrPpJXkpO1s8EG6WBaqknUz/cBb606vc1hWhdYZxdRSbynaXZVQb/X27WoCKM1gOGSnIuYUNIfXR6TuZ2wUnn09x1KscW90s8vOOsKHTm+qZGKJCw8bt61LUTZdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=kXbjLbg+; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="kXbjLbg+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=4FdWQSmG1f5d4T2/6QLj2bG1/AFTuznSWTtwBAG71VU=; b=kXbjLbg+cS6IRd4v5b/0pnaaK3
	hGpXd9KW0OpjLDE9AbvFS8tJVbn7NvuXj/jfbl96DFrpCIzHN7l01cLTeXwD96AzSSD/19d/9IeBI
	hBrK7Ubf0mcfddFeZWiQDRFX5STzFG8tA+cVuGPiKoqf9G6vO7Bx0m9BQbFICtDq5OCv0cdzfwEUd
	FLq6+dppb5CcAJIxlpQM1bsAUKU2XuNcEMaTI00+i5cIlmwHQV9a1Y8uqnDRE6GgGNHWWeB6lN2b8
	DcBADBvQx+r3ZJZ5UzBOMSP3E7yrNBYclfjTsMbxn5e+mOFlfqDfXmjPaOquoS/DnQ27rqNV+Xn6p
	LW/IUmxQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1x1kpP-0000000012i-275q;
	Wed, 02 Sep 2026 15:16:35 +0200
Date: Wed, 2 Sep 2026 15:16:35 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] libnftables: Drop symbol
 nft_bison_have_extended_errors
Message-ID: <apghs9azBbZ51hly@orbyte.nwl.cc>
References: <20260901094852.104268-1-phil@nwl.cc>
 <apbnh53-c6IGNYut@chamomile>
 <apbon9gjfoUsgSYv@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <apbon9gjfoUsgSYv@chamomile>

On Tue, Sep 01, 2026 at 05:00:47PM +0200, Pablo Neira Ayuso wrote:
> On Tue, Sep 01, 2026 at 04:56:10PM +0200, Pablo Neira Ayuso wrote:
> > On Tue, Sep 01, 2026 at 11:48:52AM +0200, Phil Sutter wrote:
> > > It was merely used to indicate extended parser error support in 'nft
> > > --version' output. Not worth bumping library version just for that, so
> > > drop it again.
> > > 
> > > Fixes: b315dd551dd96 ("parser_bison: Fix for bison < 3.6")
> > > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > 
> > Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> I have applied this patch to nftables.git to prepare for the nftables
> release.

Thanks, Pablo!
