Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A648E484230
	for <netfilter-devel@vger.kernel.org>; Wed,  7 Oct 2026 11:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791373286; cv=none; b=uxYEVQFsnGshfgGH62Fir26eZ82y2ld74kxPzocc2RDTsIb/YpoUQmyJae2aEQSyUyOsQLE7734I+xt6rVIhaWHuEKZYbfqpuhoGsYhHPPgKAIRkhjJZZnUwuU44SyVkFX6dVfmmnj92D7OucnDqk0SKzn/fujLfTwyGGGRNGuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791373286; c=relaxed/simple;
	bh=0mMqZftok8UUKyEKFrD8znM2hXfLYsZOx1Qa7vmN034=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rB15NGA44kiVx+TqWDi6MFpYs30CHMN19rUhEys0MpF4/d7vbGrYEe1KP4DL1g8CbWO4CpET1LhQSMzPU4kLRsgZVidJsj0i6DSQy0rMnwBoAiFy35UKKlNezOdQkW7a/rBkrpt+gef+GEBgUjqU4uG1qm7Pat/jVQqGIEAyEE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 86BDF603FB; Wed, 07 Oct 2026 13:40:58 +0200 (CEST)
Date: Wed, 7 Oct 2026 13:40:57 +0200
From: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] tests: shell: add conntrack template attachment test
Message-ID: <asYvyT7gvEyDiIaf@strlen.de>
References: <20261006231953.6338-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261006231953.6338-1-fw@strlen.de>

Florian Westphal <fw@strlen.de> wrote:
> Try to attach ct templates at various priorities and check that
> attachmet only works at the acceptable positions: prerouting + output,
> before nf_conntrack_in() on the kernel side.
> 
> Relax the test for now to not fail on kernels that lack the required
> validation and SKIP if all attachment request work.
> 
> Assisted-by: LLM
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  Companion nftables.git shell test for the
>  'netfilter: nft_ct: validate hook and priority for ct zone set' kernel
>  patch.
> 
>  It could be added to nftables.git already, its expected to PASS or
>  SKIP only.

https://sashiko.dev/#/patchset/20261006231953.6338-1-fw%40strlen.de

I've fixed most of those up locally, if there are no objections I'll
push this out tomorrow.
