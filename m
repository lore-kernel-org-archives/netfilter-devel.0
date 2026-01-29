Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEA7C28934F
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Jan 2026 16:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769704754; cv=none; b=FteCLwPNvkYCcfMwEwqFNTOEke+hBP0UwF2l82Lmj8KOObeVhgvVuSkS0jiQwt2i8jKLE3u9X00qWyJGgFy+UsKCr+MUYedOhMemEeeF2Xc4jrxd5DWbmJubZn+6wctmIaAsTg0RY01wZQ/689uDrAJi5aaiawvYHWP5XLPimh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769704754; c=relaxed/simple;
	bh=fVHOO4nVZXQ09tv+4UfD9HfjVyj/njCVHD4QqYizEVE=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rpx+emYtA6Aqz5rTtfOkwQ9HRajTyDI8zDleE6iBhs1oY8ZpraXZuo7RVVx2Z8+2CuyFl3JCYi2x7Bapnwh5lTFebHu7D+6s+/SowL1EfjqGsQMdTVdu0SiM+PoPaNUu7NRKiQiKTw7LIFVuNXwXl0iWTUmB1R9KmeQbx15JDBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 3CA1460516; Thu, 29 Jan 2026 17:39:11 +0100 (CET)
Date: Thu, 29 Jan 2026 17:39:11 +0100
From: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] tests: shell: add test case for interval set with
 timeout and aborted transaction
Message-ID: <aXuNL-gZl4OJ20Vy@strlen.de>
References: <20260129163309.6512-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260129163309.6512-1-fw@strlen.de>

Florian Westphal <fw@strlen.de> wrote:
> +		elements = { 10.0.0.1, 10.0.1.2-10.1.2.4 timeout 1s }
> +	}
> +}
> +EOF
> +
> +sleep 2

Argh, I keep forgetting I can use sub-ms timeout :-)

I'll push an amended test that completes a bit faster.
