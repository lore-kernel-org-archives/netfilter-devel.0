Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBEDD423E81
	for <netfilter-devel@vger.kernel.org>; Wed, 16 Sep 2026 22:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789596932; cv=none; b=LTTUX4GleeQVbPHk+lDQtt/jJdBuFanOzsaDc9SDQOewSZSrGmT56d5fZnEHkLoVgTDGls72o9jAPv0NxJpfP9V1gaAkinWF0SziCpYQwtWidGX8m36Z4b9+gsBs6bJ/AMR9ZW9LDluKJyv1JFWhVT0F66AHUslpKmP5G1nLz0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789596932; c=relaxed/simple;
	bh=a2rRzsxWtE6I0uy3J7ZYxTZO8wDtohB0JCr3TsvCs1M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IblUkmXuTWMFx9T1jGe5oMpzKCsNnlLsaJpdTrf6A/8zh1wx5I8HlE+z1rW/r7R3W/2v5dlyEAvwTNdvVfSmzX474p9vUjD+KudG770tlvgQpH2xI/cVqZRrqGwKyNheftwl7Kgah5w/DALCPtgdkd0CqrZ7ss+aIIgunY6OkP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=sJYV69pY; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="sJYV69pY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1789596923;
	bh=a2rRzsxWtE6I0uy3J7ZYxTZO8wDtohB0JCr3TsvCs1M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sJYV69pYO2x6vj6dogj5zn4+jAa3bV9qSA00fJ6cQDS0BFFGgFoB1h0ex5RTcxLfB
	 8KFyR7lWeu2bn4cyylS/AiOxVZzNvYpW5INNnrMr+2jKNsk40WYMv9MvMDkaOT/r0x
	 6nueWzhHf5ESvOX1qwzqjYWC22xUz1aXJzahulWq2HUvuFrctwkFDTFbX9zhJqm2Po
	 KEx9BX5PWkjFFvEfSLN4/5kHAi5DSQA1xH49L6FNvro8OVCSvjhLnN5JlvdneGJCgj
	 8p5CHypr841zztxox3B5LF4JVPp+4oVZxxVXOkFA72XQlYW/D6buaMQFOMaAbeZN2I
	 e2cHqBlVjiGFw==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id D806660054;
	Thu, 17 Sep 2026 00:15:22 +0200 (CEST)
Date: Thu, 17 Sep 2026 00:15:19 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: Re: [PATCH nf,v2] netfilter: nfnetlink_queue: hash queue instance by
 portid too
Message-ID: <aqsU9219B3LJyFAM@chamomile>
References: <20260916220251.97427-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260916220251.97427-1-pablo@netfilter.org>

On Thu, Sep 17, 2026 at 12:02:51AM +0200, Pablo Neira Ayuso wrote:
> netlink_release() calls netlink_remove() before delivering the
> NETLINK_URELEASE event. And a new queue instance can be created before
> delivering such NETLINK_URELEASE event. This allows for two different
> queue instances with the same portid to co-exist for a little while.
> Since the instance that is going away is destroyed by portid via netlink
> notifier, both the newly created instance and the one that is going away
> with the same portid are destroyed.

Scratch this too, it's botched.
