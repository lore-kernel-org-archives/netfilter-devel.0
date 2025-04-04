Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9765B146588
	for <netfilter-devel@vger.kernel.org>; Fri,  4 Apr 2025 11:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743766959; cv=none; b=btRayrek9ZRuhTH9I1sOuzIJ6mBPGBeYd5jtRVrC9bul5KMguxHuGZeTZY8JweQLFuaZoqdUrgPWF3sPPa24hbZRy8pAfjfQRfuirk1mT+HxGI9fynaW56oGOP1dwY+fy3It4JRIT3tQle0rZ9/0Tf/3ZRPfehYonENwNHTHdLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743766959; c=relaxed/simple;
	bh=gpZ6wChcS1HVS0eGx5Xcxn9ZAhKg4t2zNcRZt8Q3Aas=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ezw+QerS39hDT+pd5uKi2SfUxFms63kkrRluPU1WCjRGKkVN5hu1gFuryxq2gleWjLO9t2SaVc6Y3tJIptvLxfe5DWyqb17hwv9/X/FIz370hUQCTWjN3HCJhL2mFklSZlVp5j77T0xQ3iF3H6IFmRo5Ao4IHQSfmSTpaw4R1PU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1u0fRR-00007I-Nx; Fri, 04 Apr 2025 13:42:33 +0200
Date: Fri, 4 Apr 2025 13:42:33 +0200
From: Florian Westphal <fw@strlen.de>
To: Stefano Brivio <sbrivio@redhat.com>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	sontu21@gmail.com
Subject: Re: [PATCH nf 1/3] nft_set_pipapo: add avx register usage tracking
 for NET_DEBUG builds
Message-ID: <20250404114233.GA28604@breakpoint.cc>
References: <20250404062105.4285-1-fw@strlen.de>
 <20250404062105.4285-2-fw@strlen.de>
 <20250404124005.75ed1949@elisabeth>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250404124005.75ed1949@elisabeth>
User-Agent: Mutt/1.10.1 (2018-07-13)

Stefano Brivio <sbrivio@redhat.com> wrote:
> This made me wonder if there's any specific reason why we would need
> #if defined(x) here instead of a common #ifdef x. It looks like there
> isn't a reason, so maybe #ifdef CONFIG_DEBUG_NET is more... expected.

Ok, I'll change it and will also update the rest as per your comments.

Not sure I will be able to spin v2 before next week though.

> Perhaps those could all be uint16_t to reflect that it's YMM registers,
> and nft_pipapo_avx2_debug_usable() could simply promote them to
> unsigned long as needed by test_bit().

I'll swich to u16 and will ditch test_bit in favor of BIT(a) & r->.

> They could even be uint32_t to represent ZMM registers (or extended
> YMM) if we want to make this AVX512-ready, I'm not sure.

Can be done later.
