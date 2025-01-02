Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDF8317DE2D;
	Thu,  2 Jan 2025 17:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=156.67.10.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735839609; cv=none; b=PmtGiDeI5HrRkearOCgGTt94comU28H3+vzicKmZTWu/Ek8fRqcfZRq+tIrTKBjU0IOoXdxHhTBzZQ6PmjhgHtTdPUzuP15kDXmENaH/kgZ5JLnIX7zMkW3Ds5Wsq8iYKJuA4gR/yEp7aK18nVylh0b+8BfNndqaB89kwVK7wKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735839609; c=relaxed/simple;
	bh=LIvqTH+wl6w6hCR6IT1PddWop634LZbTE2mgDqO/5wg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ciR2XgXhZRYoLMNiXbHN+LPSZgoXIOFeG2h8Xhvj6Sa1mAevD6hafZ7yrYxDjZUfvIpMUI7I3PiORxrCNR8P3NAb0LC86MVMUYMHPg+A8hjOU6uG32EngeKh+yZc3yeKJVow2HlKsbfpHAe2gA79ar6YogPDa9n4NuuJIurEIsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch; spf=pass smtp.mailfrom=lunn.ch; dkim=pass (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.b=b/8fUCCj; arc=none smtp.client-ip=156.67.10.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lunn.ch
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.b="b/8fUCCj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
	Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
	Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
	In-Reply-To:References; bh=vG8zV0iSeZ9UhdPoxEVXLWK29ZKO026Z7LJWnTAlLpM=; b=b/
	8fUCCjlMcGxckrVRXP7R4mPJN45Hzlj76ZiryGW5LAZaghB1oWdRRTUfGyPrDoRs9w1tzh+us3Ixh
	tXFzSQL5zdQizpxMRJpfNOJhflbWq6T9ZUjRwV/4w4SObuUY/sjJA3NuwnvbQ8I58LQ8rueBFvt5m
	G5XEc03kuHrXhzQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1tTPAd-000o0n-Ax; Thu, 02 Jan 2025 18:39:43 +0100
Date: Thu, 2 Jan 2025 18:39:43 +0100
From: Andrew Lunn <andrew@lunn.ch>
To: egyszeregy@freemail.hu
Cc: fw@strlen.de, pablo@netfilter.org, lorenzo@kernel.org,
	daniel@iogearbox.net, leitao@debian.org, amiculas@cisco.com,
	kadlec@netfilter.org, davem@davemloft.net, dsahern@kernel.org,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	horms@kernel.org, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH v2] netfilter: uapi: Merge xt_*.h/c and ipt_*.h which has
 same name.
Message-ID: <6eab8f06-3f65-42cb-b42e-6ba13f209660@lunn.ch>
References: <20250102172115.41626-1-egyszeregy@freemail.hu>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250102172115.41626-1-egyszeregy@freemail.hu>

On Thu, Jan 02, 2025 at 06:21:15PM +0100, egyszeregy@freemail.hu wrote:
> From: Benjamin Szőke <egyszeregy@freemail.hu>
> 
> Merge and refactoring xt_*.h, xt_*.c and ipt_*.h files which has the same
> name in upper and lower case format. Combining these modules should provide
> some decent memory savings.

Numbers please. We don't normally accept optimisations without some
form of benchmark showing there is an improvement.
 
> The goal is to fix Linux repository for case-insensitive filesystem,
> to able to clone it and editable on any operating systems.

This needs a much stronger argument, since as i already pointed out,
how many case-insenstive file systems are still in use? Please give
real world examples of why this matters.

>  delete mode 100644 include/uapi/linux/netfilter/xt_CONNMARK.h
>  delete mode 100644 include/uapi/linux/netfilter/xt_DSCP.h
>  delete mode 100644 include/uapi/linux/netfilter/xt_MARK.h
>  delete mode 100644 include/uapi/linux/netfilter/xt_RATEEST.h
>  delete mode 100644 include/uapi/linux/netfilter/xt_TCPMSS.h
>  delete mode 100644 include/uapi/linux/netfilter_ipv4/ipt_ECN.h
>  delete mode 100644 include/uapi/linux/netfilter_ipv4/ipt_TTL.h
>  delete mode 100644 include/uapi/linux/netfilter_ipv6/ip6t_HL.h

How did you verify that there is no user space code using these
includes?

We take ABI very seriously. You cannot break user space code.

    Andrew

---
pw-bot: cr
