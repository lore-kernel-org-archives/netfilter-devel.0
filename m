Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5757271448
	for <netfilter-devel@vger.kernel.org>; Fri, 28 Nov 2025 14:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764341534; cv=none; b=W4SrDA9UALTm+oDz4DL0kQUXDiqpj5npA++V1BdtB8VwygqZwYAWeNtKiO7qRQFiKn9f2BlE+KMnwAQ4hwbAiMJcQkeqosmyGWmeQV+LN3mT+Zmr7Myvf8wU4GEOQMrpXu1EuUA5aNpyel2S0LBG8bRNxYnonbzZVJMB3eJ3hkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764341534; c=relaxed/simple;
	bh=4FfR3td6ZddSx46ue+WxItkN4A5zby5rj90grpgA2aw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t977ERPFMFF401BEbpHpIpzt7w26jBSZZw6wmYAy/u1oI2WYy9U7p+5SMq14ubxxgl8KrQj5TcnrYLE+MMdk96m6HK1feVemOq8rSdGQhfQ1sn23CLS9DbjIHYbeLOmCuSISVVx75b0+88NG4VfU8qZw8V5/nsPKHApSslDLVSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 9768160308; Fri, 28 Nov 2025 15:52:03 +0100 (CET)
Date: Fri, 28 Nov 2025 15:51:59 +0100
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH RFC 1/6] parser_bison: Introduce tokens for monitor
 events
Message-ID: <aSm3D2ixdyD8yT_1@strlen.de>
References: <20251126151346.1132-1-phil@nwl.cc>
 <20251126151346.1132-2-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251126151346.1132-2-phil@nwl.cc>

Phil Sutter <phil@nwl.cc> wrote:
> There already is a start condition for "monitor" keyword and also a
> DESTROY token. So just add the missing one and get rid of the
> intermediate string buffer.
> 
> Keep checking the struct monitor::event value in eval phase just to be
> on the safe side.

Looks good, just minor nits below:

> diff --git a/include/rule.h b/include/rule.h
> index e8b3c0376e367..4c647f732caf2 100644
> --- a/include/rule.h
> +++ b/include/rule.h
> @@ -739,15 +739,22 @@ enum {
>  	CMD_MONITOR_OBJ_MAX
>  };
>  
> +enum {
> +	CMD_MONITOR_EVENT_ANY,
> +	CMD_MONITOR_EVENT_NEW,
> +	CMD_MONITOR_EVENT_DEL,
> +	CMD_MONITOR_EVENT_MAX
> +};
> +
>  struct monitor {
>  	struct location	location;
>  	uint32_t	format;
>  	uint32_t	flags;
>  	uint32_t	type;
> -	const char	*event;
> +	uint32_t	event;

any reason for using u32_t rather than an enum?

> -struct monitor *monitor_alloc(uint32_t format, uint32_t type, const char *event);
> +struct monitor *monitor_alloc(uint32_t format, uint32_t type, uint32_t event);

If we can get rid of internal parsing I would prefer
	... , enum monitor_event_type event); or similar.
