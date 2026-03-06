Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com [209.85.167.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B28173F0773
	for <netfilter-devel@vger.kernel.org>; Fri,  6 Mar 2026 18:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772821222; cv=none; b=K/Dt7ZOci4QhscQNKg/sLO+xf6SuOYqNjXdca4jVGum2x4fwQ1TUNysG6rIoyo7D2eWqE2dPJvmESgllq7q8K5zQ5X3zGJoGUJ7Z0h7TlhTzdedup04SAPTjbqSFKvkgq6jyRuvH9phsbBeuUzMWP6CEtUU0u+JjsWgCobR3RaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772821222; c=relaxed/simple;
	bh=XoUdcp4sZ9u9yg4lARLdJdb4aYqyVRFrJzsGslmOESs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nDI/25Ceermko+aNMcGAtBKB/qgV/5ZEipiD7Z4C0/BRCdeK/sG2Ny7Z7YMJvVWqp88bDXT921nHLcWGTd3jvSDdguIbVQ6XCQlxZvydq+caNcJ3Fe/OEExi6dvTWkMoQoxtldQz3JST+ybPdgbDPUt/lKjeOit8Fa2okTD1PVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com; spf=pass smtp.mailfrom=cloudflare.com; dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b=CYo8SjHl; arc=none smtp.client-ip=209.85.167.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b="CYo8SjHl"
Received: by mail-oi1-f180.google.com with SMTP id 5614622812f47-4648447c899so5808119b6e.0
        for <netfilter-devel@vger.kernel.org>; Fri, 06 Mar 2026 10:20:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google09082023; t=1772821220; x=1773426020; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=39xArBXSs4Whdyj6F5WRF6OsnU4hIyo+O+UjLfGtF8w=;
        b=CYo8SjHlAy9kqTHyIOMpjcJ1oXM9PmxnsXgDID+AaEqCZq+M560l3Q2myzbChRboTH
         WCHq/+PHNtX8DLKnOwa2CBaW/12KV3tRMFROU51aE0ll7gaQI34wncEkmf+1TXfePrmC
         Z0ZEj/WlPje4GEt+Ak2Bbz6g3Mo6/CHZinIu8e0DGohppPocUzDf5J5XQXIif7T0tik0
         G60tqQocgETu6Sm10qwc63DMgIotTQwMnnUsB9HjfV4g7V4Vy9XuquY4Be5711RNbJBC
         7sjwXVngIfy0+nPrSm9BVfPwLs+N8++JVLH4Xl9gHD/Kt/OLtwqCgbzuIp50LtAB/pBf
         orxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772821220; x=1773426020;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=39xArBXSs4Whdyj6F5WRF6OsnU4hIyo+O+UjLfGtF8w=;
        b=iLrQWdpi2UvjZ0YfSqBbnimQqWdbHJXuhkoxv2Ll721xcS40c7UaPA7hfp85C3Sl+P
         4JEqmgNuVCHZgrv8ZguSn0tHFHuKZXPNkCIPR6ObmDBimbhXznSPbUPBq7QQqOlbDiy8
         VoNXiU1CJLxpSZXl4dhhQEG2xNNPHeDnF3ZdU2G06MTS798DLAYDEp7ILZO9HoXlSE6C
         I851bMiKZ9wIHvYHpIrRNylJFnnapZepUpLWZejf9l1NJEnXayMOPQ5ekSBE3/e/bVZp
         hmJfII2zl8faGdIk0xeHagjxWpvs2vJ2ylwH+aAc1t+JOoxCyF+9QXZDKfuE0tFP5lcY
         Nt8g==
X-Forwarded-Encrypted: i=1; AJvYcCXr1vDXVtsQ3eNnqkFfmLi2QYSiQV4RyurSJfwwIL65wp2OpRTgZbJwVwnuzCO9jex+ZAaxsaQwpA5be5XewG0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzRVWGv6cMqXO5fs4RVrtiCLKD2tifuaBIjEcX/Oh59safqDwx3
	t8eM4M0ixtututXIledAOxcgfrNHZ6TuIrte9sf7Z0af+86iHSs9BDi6AmYP19IeHqI=
X-Gm-Gg: ATEYQzwUvZu2yRz+n3nLNkfHMx9kNSpOx3GNBqnzCRY1yYsxGxuBp4JBxzYcXm4H07W
	5OjGUEx3i6IRk+K1BjHISlbUn1+QKPyA2Kl307dSIwCkIaasGoGVDWlZo7TrLka5oPYb5GhObp8
	Dk+/cT0NCJ6zn7JO811iYqrMAl/N9SJVEUz2IrPO+/TfTbkynj/bHTrShjexRVuUjxNghhozZEq
	41m655gYZNsDOA5cgNXjG1BhdtZOHr6qaOf3TrF+NbwIPREuh/8PN3DSMKO/SicBTwQZcDkf4tw
	gCkfMxROFOQ2NAyf4u03uYBCLjEhiZp/IIw5Yt5carubN/UW64NqwnHnFoHI2qUqLtwxgm4yKKs
	9PGOymK+TZy48df8pnEmGP45WIHxcrQTWuCMMkndL+sGnvGPrGOxgXxEbEw1ZHm3sb3bbSWyNmu
	eLIkhFlA==
X-Received: by 2002:a05:6808:1641:b0:45c:8675:eef1 with SMTP id 5614622812f47-466dca16637mr1603487b6e.3.1772821219577;
        Fri, 06 Mar 2026 10:20:19 -0800 (PST)
Received: from 20HS2G4 ([2a09:bac1:76c0:540::3ce:23])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-466dfac17b3sm1112878b6e.14.2026.03.06.10.20.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Mar 2026 10:20:18 -0800 (PST)
Date: Fri, 6 Mar 2026 12:20:16 -0600
From: Chris Arges <carges@cloudflare.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, stable@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, lwn@lwn.net,
	jslaby@suse.cz, kernel-team@cloudflare.com,
	netfilter-devel@vger.kernel.org
Subject: Re: [REGRESSION] 6.18.14 netfilter/nftables consumes way more memory
Message-ID: <aasa4AV5p7TFxNmj@20HS2G4>
References: <aahw_h5DdmYZeeqw@20HS2G4>
 <aaijcrM5Ke5-Zabx@chamomile>
 <aaij0XAgYRN40QdD@chamomile>
 <aamvQTTZu4-chpsS@20HS2G4>
 <aarHEfdMXDJ-Wq3V@chamomile>
 <aarHyHIQY0nS9d9K@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aarHyHIQY0nS9d9K@chamomile>

On 2026-03-06 13:25:44, Pablo Neira Ayuso wrote:
<snip>
> > I see what is going on, my resize logic is not correct. This is
> > increasing the size for each new transaction, then the array is
> > getting larger and larger on each transaction update.
> > 
> > Could you please give a try to this patch?
> 
> Scratch that.
> 
> Please, give a try to this patch.
> 
> Thanks.

Pablo,

Thanks, I'm getting this set up on a few machines. I will have:
- 6.18.15 (original kernel version that repo'd the issue for us)
- 6.18.15 + this patch
- 6.18.15 + revert rbtree patchseries

I'll compare memory usage with those 3 variants and give a response.

--chris
> diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
> index 853ff30a208c..cffeb6f5c532 100644
> --- a/net/netfilter/nft_set_rbtree.c
> +++ b/net/netfilter/nft_set_rbtree.c
> @@ -646,7 +646,7 @@ static int nft_array_may_resize(const struct nft_set *set)
>  	struct nft_array *array;
>  
>  	if (!priv->array_next) {
> -		array = nft_array_alloc(nelems + NFT_ARRAY_EXTRA_SIZE);
> +		array = nft_array_alloc(priv->array->max_intervals);
>  		if (!array)
>  			return -ENOMEM;
>  

