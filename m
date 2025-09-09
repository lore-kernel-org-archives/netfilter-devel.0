Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED1DE2FB606
	for <netfilter-devel@vger.kernel.org>; Tue,  9 Sep 2025 10:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757413168; cv=none; b=TgjNUm8U3au0bojljcrCG/uQXBoXFiQBqYh9RZm/E0xWnrYP2j2N1QEV1tRhsI3C+Bt8uiqOnBhZqHV3EgnT0C4Mo6XlUOoGJxujseN+F0+mlO8PbnQL9mWOOH8+j5bKJC1XbFXm3yzL8IMA5rPPjA5noVESJC2O/YwNiWrNazU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757413168; c=relaxed/simple;
	bh=dqqhPt/zxVKwbQNoWSWsrCvB5WPjN8423nnbS3ETXCQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=upWigG9PO+8DeZZiFwqu+oUuVyjLtAOxR5+TTEtZ3UH/etLZqP2RLqGkObbT48/jpYU8o3LmZZj7/RLKcH8zN9S6Ee0i7ghqZn0NBC9T+UvczGSmauzxokarapXki351r/7N2ZsAazVOQluyxqrN7vvzE/mWRCQa5n5yfsph2+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=RzqRHjjW; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="RzqRHjjW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=jl4EMZevAHZEVLJjkh/29ye18cilFmaMz0i4iJlp9+Q=; b=RzqRHjjWaAzMJXViRInIVcliY8
	ZcCDHdmAwWmsu/KujfLfPr78euGS26zHIlrSXc3bGGxH6t9T6dkisKhahMSQNgfShZRMyMUy4jmLB
	ysxNibh7QYShcLCVrsDTVZ8cwuzmdzlvEWUS4MjZ9/6y46122OOcxBAYx/721ugwkA4KUEhZoWYku
	W6kez8UVbtEttX4SjVwagLSXqztaFKYS9RuGimMWn/FfGQkj6IYQiKa2QrDUzlEUya70W5iVTf2tb
	ICwoPO3pLmhep/hdCX7mZrfbaCeZccywRP+ew0ghg8xuxhVKiV86lCEWdYejlWUzrwyjcI/QZGpbZ
	auCLAlGw==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uvvRb-000000002X9-1lNd;
	Tue, 09 Sep 2025 12:19:23 +0200
Date: Tue, 9 Sep 2025 12:19:23 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] Makefile: Fix for 'make CFLAGS=...'
Message-ID: <aL__K_qqeuxnG1wZ@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20250908221909.31384-1-phil@nwl.cc>
 <aL_5-hgKWiF877pb@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aL_5-hgKWiF877pb@calendula>

On Tue, Sep 09, 2025 at 11:57:14AM +0200, Pablo Neira Ayuso wrote:
> On Tue, Sep 09, 2025 at 12:19:09AM +0200, Phil Sutter wrote:
> > Appending to CFLAGS from configure.ac like this was too naive, passing
> > custom CFLAGS in make arguments overwrites it. Extend AM_CFLAGS instead.
> > 
> > Fixes: 64c07e38f0494 ("table: Embed creating nft version into userdata")
> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> 
> Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> Thanks for fixing this.

Patch applied, sorry for breaking your use-case in the first place!
