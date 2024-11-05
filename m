Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B1C11FBCB5
	for <netfilter-devel@vger.kernel.org>; Tue,  5 Nov 2024 22:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730847352; cv=none; b=CcitTBoYHlZEvJtsXUfIXqs14m25TmDEsnWYwdNom6QyJpTe2PsNSwvWdmPaQspX0IYVGmVdcXzjhSmszcnRb7oIpUavmzGaKLDk4/GxlctptfP1SkoGNiQ/RrKO4f2XVT8VBPEFGfL3wW2Y8MhXmXH+lIciNY1iqfFrtwxAwc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730847352; c=relaxed/simple;
	bh=yT3/toxLy2NGiLt9mFgge+O420Jt87SMMWVNImkz+D0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OK7av4CYiUa9BgS+/RUrkQa7sKjj0TjqRzjNhyBX0z22rnvkRhhlCC2cDhKT8giGLuA0G0bvB123TpudzEP4Ly0HXAd45PfDFxFyMyb6atYP1iwCxe0y6nQVCvmcIoCbNjj2F+CTYtdCa3fihHxmQJZAULoC5Nc2Sjxkoeu/WdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=FDXpgSlD; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="FDXpgSlD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=dsDSRq6srMdbmWBr1aTVYHF9GOZKV8nibGlHUkbWRQY=; b=FDXpgSlD2TXtAhLzFJEs1Fr0E0
	GqTBlrlCCf4RgB/qBH0ypFcp2I5sRBGViTBCdUtDtPxDdrnF8RBE/pgI8DkYsjwu3FQYxzOGywTuv
	Y52T6ntwoXGn9te96bVlyIWYNzI6GcakkjY0qQjZriRys/Hwui1knj9UeXj4OSik0o50L9Yrdttff
	SVzVvmlFNq1kWGiwsQEjtghl0xgAmv+xzPuyM0o/PmpmsLNSdgR0kuFKgU97us2ie2+8I2fK81m3Z
	bRMr60DrQ3K7g3J3QAULgrzUb3crfSJVAKfbE3fC0kaSsJAAyMJLSXw31bxApCNZZl59KE/7SdJw2
	aAir5s/w==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1t8SSi-0000000058q-2sUF;
	Tue, 05 Nov 2024 23:55:48 +0100
Date: Tue, 5 Nov 2024 23:55:48 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [conntrack-tools PATCH] src: Eliminate warnings with
 -Wcalloc-transposed-args
Message-ID: <ZyqidMIpGsRROtLO@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20241105215450.6122-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241105215450.6122-1-phil@nwl.cc>

On Tue, Nov 05, 2024 at 10:54:50PM +0100, Phil Sutter wrote:
> calloc() expects the number of elements in the first parameter, not the
> second. Swap them and while at it drop one pointless cast (the function
> returns a void pointer anyway).
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Patch applied.
