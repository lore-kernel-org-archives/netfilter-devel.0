Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADD572B9DD
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Jul 2024 21:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720645758; cv=none; b=Aart+eeyZmucI53wN6FbwaFMBUJKTqnXtbAAjRzTTdcxyvmPzXMhRGFUTffdTE4u5iXpFVAinHtxjI/Nwb8EqHYHqpobs4qxmAIRKlBFUPaVeXEIpTZ2ppbM2UjlkBe/BrIk21TJDJPBWXRFU3swXTIcDUy4Q347maLBuFtcrv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720645758; c=relaxed/simple;
	bh=/RmHVrDXrWiAxQ5UC1kj8ofT+xQY4bIRfMc0rqVa2Z8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RzU6WeQKrq+esLGiG1ccUBGF8ZKpztepgqX9E2BCnUG+DXR4yZch67+2ido1SkIrCxkIv7XVsAhYh8AcB5K9SDtIvPdrW/+pHDXPf8/NJhHE5a4gu0ZljS36GoJU1nPP76gXr+gibgjkalJ4ij/HjvvvNw8mD4XPbmG7jsWi/Sc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Hfpwwx4x; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Hfpwwx4x"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=6YkB10AQlnjcHuV/rcXjDXb+GWZCvll1p5Wr1o8+I4s=; b=Hfpwwx4xR2gXK2cZPbK7uFKsH1
	1RXiaXk3oH7dkgMoHi1B3OPM5KxoEjH51t9Yh21ej+yiSS8K9ONNWHPs6xd0XtgPVPannq9IhBeQg
	KyDy4dxA8bAy64W/xiEtv/PWK2sz9KUgw4cbQBql+cljgDplX3qY7zoc6s9QppKRyZcH9W8vZUXH8
	pYllS6gL8akfKDeOi+fCePFvFbHlO67JVwnG8GdoIoDGvM6zHqjka5ANSyFPYI6yENYo6W5iXXvLq
	a3ralILGYL7M9f7KuxFoft24EYnJDq5iyrWfnpK1URwU9j1Yltj4NXH1qjoZe1ZzHwo27h4b97uiU
	GRu62Q6A==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sReYr-000000006Jm-1Q9q;
	Wed, 10 Jul 2024 23:09:13 +0200
Date: Wed, 10 Jul 2024 23:09:13 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [libnftnl PATCH 1/2] chain: Support unsetting
 NFTNL_CHAIN_USERDATA attribute
Message-ID: <Zo74eSb4uw4UT0ew@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20240710153322.18574-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240710153322.18574-1-phil@nwl.cc>

On Wed, Jul 10, 2024 at 05:33:21PM +0200, Phil Sutter wrote:
> Cosmetics, but support unsetting anything that may be set.
> 
> Fixes: 76b82c425818e ("chain: add userdata and comment support")
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Both patches applied.
