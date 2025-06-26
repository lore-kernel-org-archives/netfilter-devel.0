Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2CCD292B3F
	for <netfilter-devel@vger.kernel.org>; Thu, 26 Jun 2025 12:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750940990; cv=none; b=CerUYguYu0pyKmu1bqwHsL4p+oO5bjy1YdSxSO0g9dweZsoyzPPN1zDEfqXqaZU+Y6FA/6qXzFVm6T+qf2xcHboKY52ojybTYyyllmsEIwHjAuBomGokhHWSz0/XzXHmkhAcxIqIxQQ4C+LLKG6lEN54rqStcDhu9WLwMWWya/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750940990; c=relaxed/simple;
	bh=ACxxbPa1dLi9bDcpnuALA6ITwgfQmSasPIFROwZYtYg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FljWV5A11h67MLYw2bt9o5hH+Kd/5c4XaGuXF5ftCapdqyGeVVoYYUbFnN84JvHpnSkgeB+eWSwmDdL4sBs5yrX5I0ogRi4M9gtMbHZOquhcWZ9mpQX0R+VvKcS9b8v+VHrW5du1kmGO4HOe5NILY7m32PFc7+HMUEuiKEU52CU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=b0BHFncy; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="b0BHFncy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ksBI7BE7IWTQP988B58sxNXgqC0/InelM4o0PeShHZY=; b=b0BHFncyuIBBzgtvqEt7jC1BRt
	8oQpedxbbzLxxBVao0pI9jKc+LjnLBdQaxNK+VIpmVfpy+3tFC7KQdCIghz4EvEE1igHk0Zf0/u5I
	AWZ7Saow/2rm88dX5S3o1HI7NV6SQf0wqPH/7TRxG8/VdTadkl8bQRpnO5l/olVeP/80OQ2nctfC/
	+xFTuOI0Otqow33hhgbTRxP8fP7grcgBou0k63rUutIAe4BJXyHDLWdswLs/eCwuKBp9xo7PBDBX7
	jZtIg1nDWYpfMVIAF7FWFIcTvTyGgmACOiVUWH6iso+W6WV/pjOEO7qaFow3wIOT6xz01g6gzCyqo
	xPipwsUg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uUljc-000000005CS-0hdZ;
	Thu, 26 Jun 2025 14:29:44 +0200
Date: Thu, 26 Jun 2025 14:29:44 +0200
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] tests: shell: Fix ifname_based_hooks feature check
Message-ID: <aF09ODS5R_ZPv65v@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20250625165336.26654-1-phil@nwl.cc>
 <aF04Q2ppk70lssKl@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aF04Q2ppk70lssKl@strlen.de>

On Thu, Jun 26, 2025 at 02:08:35PM +0200, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > Fix this by detecting whether a netdev-family chain may be added despite
> > specifying a non-existent interface to hook into. Keep the old check
> > around with a better name, although unused for now.
> 
> Thanks, this makes shell tests pass on fedora 42 again, so I pushed it
> out.

Perfect, thanks!
