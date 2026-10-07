Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D9224A8FE2
	for <netfilter-devel@vger.kernel.org>; Wed,  7 Oct 2026 13:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791379414; cv=none; b=HKctSVs6gL+MedAlGS0WwgcXfRaIwxhVg6sD3zrAAAt13ZUMh3UqQLfKZbuudGAWNLWKz6Ash7hpcq0bTXK4vOsngT2HXnGayhcE0lTJO12zd9XrCFUY0WvXlzRyQ90V2o2CuDEitzUO7s5yNtidw+ZIsFyM8LS5PGkUGtqs1/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791379414; c=relaxed/simple;
	bh=8LIvBy6vY4HK9g2ndaxHb/F1ZSv8Om4NALrhHMYYUcM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PzSYQvzNIhVMYJTPUpDJIyNq8HXUi/mA8Fza7TAqFJYzt/3FiZreX+L17PnKoEsg2QqFhxjrnXpg6OXD9oBMTGb7+A4P7dLZ3ohcIKKFHbf/+4RykYYqZ1MQArQL5bfqXhUleGSVmSXw6zXtbBe2CHCSfYjpkrpwjf4WxdmdJ9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id C0653603FB; Wed, 07 Oct 2026 15:23:14 +0200 (CEST)
Date: Wed, 7 Oct 2026 15:23:13 +0200
From: Florian Westphal <fw@strlen.de>
To: Sebastien Bacher <sebastien.bacher@canonical.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [ebtables PATCH] include: drop bundled copy of linux/types.h
Message-ID: <asZHwYyb0rlYXlYC@strlen.de>
References: <CAD04=wrZafKknWixGGRZWtYD_ydfdL4Uk39s_RkwZ6WUEVATKg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAD04=wrZafKknWixGGRZWtYD_ydfdL4Uk39s_RkwZ6WUEVATKg@mail.gmail.com>

Sebastien Bacher <sebastien.bacher@canonical.com> wrote:
> The bundled include/linux/types.h is a copy of the kernel UAPI header
> from v3.16. Since the build uses -I./include, it shadows the system
> <linux/types.h>.
> 
> Recent kernel UAPI headers (v7.3) changed arm64's asm/sigcontext.h,
> included via <signal.h>, to use the __u128 type from linux/types.h:
> 
>   - __uint128_t vregs[32];
>   + __u128 vregs[32];
> 
> The stale copy lacks __u128, so the build fails on arm64:
> 
>   /usr/include/aarch64-linux-gnu/asm/sigcontext.h:81:9: error: unknown
>   type name '__u128'; did you mean '__u32'?
> 
> The system header provides everything the bundled copy did, so drop it.

Applied, thanks.
