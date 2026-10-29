Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=151.80.46.58
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793294255;
	b=pwvqRMLI4Y8ci1YL6OgxH1PXukjb5oqwfD9DBUSiHXo5cWCAkb0/VmuvcD+S0dbh3OkO
	 tjCfrkRlAJ37lmpzaJQLiISH+nJR+fbuEuGsUr3oy/5WPJWS2olst6dFqrSfow59DWJjq
	 4VG6pjfZr8M90X5oCHK0V1IjbkAm8QlzeQW7wb+x7GhQ8yc0/0GuGkd0LHxM+9xTTUY76
	 hMOngWo0zCY2lxM7LbUW2C3PpH1qem9KG+y/pyNZjJjXUNcFANxBl1ke6RBHkmPoJ6E2f
	 BDCALN5uheJ4IWcRtaHkrYsqq4LQ/9fs76rqDDfRVXf01D8V3xr+8SkEJ95znzTDsGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793294255;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To;
	bh=GHQYLipuuSfHtIeLhDVJKTz3eXm5wppWBXcn56/NOFE=;
	b=4zBI9opO0JxeYggdkhX3Iqt915KfOSRxFH274NFkgxsiyRdlaMMIWX7EXotk+uowboog
	 dW4SoAXKPEs6hFuWsA2yVM8KcDRiWnRoaNVS6GKv+bGBZKxdf0eb4s8l+9UebySKRkjZR
	 cfImMGPzF3OvYgqqbCbCxw33xQhGl2tMCfi8FwFrLnXCG2bd7Wg5I8dzp6NjlS05Zpdhx
	 iTBKjOQ/3lDexFNlRlH0GbLf9ggwtsJbKNGIT/a5l30/oSjRh88tKPsitS9WmM6sTwXfr
	 wrvfDAuuhMseLLs2587bjCWUalNIu8Z/1do3rfihJIcQ/u3KcWc9m5tMqOsNMUUpS3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=nwl.cc;
	spf=pass smtp.mailfrom=nwl.cc;
	dkim=pass header.d=nwl.cc header.i=@nwl.cc header.a=rsa-sha256 header.s=mail2022 header.b=OeMYSLKF;
	arc=none smtp.remote-ip=151.80.46.58
Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27A74606A31A
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Oct 2026 17:17:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 27A74606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=nwl.cc header.i=@nwl.cc header.a=rsa-sha256 header.s=mail2022 header.b=OeMYSLKF
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=GHQYLipuuSfHtIeLhDVJKTz3eXm5wppWBXcn56/NOFE=; b=OeMYSLKFwFDNfAYlk7O9OWY5eO
	qqGlMosictiYHz34tWQuDc7nw/8lzJIsfdZNegUry02zQ/EckBEyh19uMIqmVJhG87+Id6L96XlqT
	Mq/bekZZcjRY4PtEXPJRglBbcZjI5KCiyfyUGPJENlJP6fKRZmEbZTXFvWagW9x0hhTKDKeYvPaNi
	o4r318DFw5mULqMJe6RzNG51smqJ3bLC+8o8GNJlUYSeDZgDuv58FhhIUwTdAowkZpVLGH1ilz9Vk
	nL2qkA4KN70ynQtkKZyXfm0Cd5MJd5VKCSm1vAhM157u/qzm6n8KBa7foWnR+5RUQ1jU2k4/A4g5m
	QmY/3h7A==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1xMTkp-000000003gm-3uo7;
	Thu, 29 Oct 2026 18:17:31 +0100
Date: Thu, 29 Oct 2026 18:17:31 +0100
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libftnl 08/12] src: set: clear field_len array before
 copying
Message-ID: <auN_q0LzulsbSkE1@orbyte.nwl.cc>
References: <20261028145632.7089-1-fw@strlen.de>
 <20261028145632.7089-9-fw@strlen.de>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261028145632.7089-9-fw@strlen.de>

On Wed, Oct 28, 2026 at 03:56:28PM +0100, Florian Westphal wrote:
> LLM flagged:
>       if (data_len > sizeof(s->desc.field_len))
>           return -1;
> 
>       memcpy(&s->desc.field_len, data, data_len);
>       for (s->desc.field_count = 0;
>            s->desc.field_count < NFT_REG32_COUNT;
>            s->desc.field_count++) {
>           if (!s->desc.field_len[s->desc.field_count]) // here
> 
> i.e. it relies on the inital zero state.
> 
> If for any reason a 2nd call is made that shinks field_len
                                            ~~~~~~
*shrinks

> array, the loop would read stale count from previous
> incarnation.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  src/set.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/src/set.c b/src/set.c
> index 22fd4a839f80..fc50f3f28055 100644
> --- a/src/set.c
> +++ b/src/set.c
> @@ -188,6 +188,7 @@ int nftnl_set_set_data(struct nftnl_set *s, uint16_t attr, const void *data,
>  		if (data_len > sizeof(s->desc.field_len))
>  			return -1;
>  
> +		memset(&s->desc.field_len, 0, sizeof(s->desc.field_len));
>  		memcpy(&s->desc.field_len, data, data_len);
>  		for (s->desc.field_count = 0;
>  		     s->desc.field_count < NFT_REG32_COUNT;
> -- 
> 2.55.0
> 
> 
> 
