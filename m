Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01DD937C0F2
	for <netfilter-devel@vger.kernel.org>; Thu, 26 Mar 2026 14:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774536418; cv=none; b=DHyWTXEVmB2pstSL89Uk0UjKXmKsS0x9o64GEVAI54TjiTlAGOc9n7gRZZCTsuN1G/JZYIRplr6WYdU5Nm3TVOWfS4thdkeAZvteimKe3myOzTn5dNgQPOMIF640mGE9Ou/Mkp58HmQ0txrrFkgKcxCLEKfSz89vjRHGjzOiMUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774536418; c=relaxed/simple;
	bh=COFoneHZFvbC0AyE7OLl+QiItRNCVIvT0WlZje+vp0A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KaIPPXao9LsUr7cL9o8KmFskaJo6IwmjWquHsE0FQhfWD79Z3REKTxFeMjZo0VwQSnoLXlAvSUEyI6kmT4yHUGXmOeaFRt50eZXSoABZdPaKCkyMKUZhFIwSoqcmbFYfmb+yFWI9RnhajaiwwtTS6juTby1HwFX6j99hEpy9NhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id B195B608BD; Thu, 26 Mar 2026 15:46:54 +0100 (CET)
Date: Thu, 26 Mar 2026 15:46:34 +0100
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net,v3 00/12] Netfilter for net
Message-ID: <acVGyl-UKiUQShXH@strlen.de>
References: <20260326125153.685915-1-pablo@netfilter.org>
 <acUxw826gEzIv8Zp@strlen.de>
 <acVGWE6APd2itKyu@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acVGWE6APd2itKyu@chamomile>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > If anything, we should also consider this (not even compile tested):
> 
> This chunk below looks easier to understand.
> 
> The issue can only happen from nft_compat, correct?

I don't think so.  I think you can request any module that
registers for NFPROTO_UNSPEC from arptables, which, unlike
bridge, doesn't have compatible hook flags.

So we need the existing patch (or a variant of it) in any case.
