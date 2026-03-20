Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE1F4314B73
	for <netfilter-devel@vger.kernel.org>; Fri, 20 Mar 2026 11:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774007287; cv=none; b=erkozClVI6hQKdBDTErrmQArPW8yPx/DitkDgD5+Z0/PnKC9hr5kQ508QwE6n4lFdsVoUBI37p2l5GDGkj5yUn/m+F1L3E13FcyAhtuoaBg8XcNlQ98iBMqx5btpJ8II2iPCBKFQkPs3IrRkSXZCQanJ2an/q99Hn2T1S4B9GnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774007287; c=relaxed/simple;
	bh=v7Tt4TJy/Pja0OMgQof4SlJaBD1yBqHrqp1sEX2s5+c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u177j6sRjFQNrTMXWjW1hi21CmG+DtUiJDsNUuD7jpOGaQTy9MTV1n9w1rwDBIS2OAMbEh8jDUo9FpXbN+Fj2bYkBuNwPWlCaHLOjWkCEXxh8z5/Pv0qrVbzDp6lk7bsV+hJVv/desU4RR8zAVllINKQwOBXRZm2UcCCYO/j4Ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=j6GJkAjg; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="j6GJkAjg"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 3BBE960262;
	Fri, 20 Mar 2026 12:48:03 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1774007283;
	bh=bkgVM+GhLA8SXDyLVTRn3pUBUOSaWe1u7efq1FdYzwQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=j6GJkAjg7qnwx+jY7Qr4QEBH/q+bJY2wxzjP/3iWkkSTAV0gUcQIJx+RXhuMgmTwO
	 1ibmpjsWYoFwESRPDrmpgj3RLUFXsg+ATYYyE6ngNdSQe8Q9Fnw75hqO/+nmbNfFi9
	 uKqqSM5zKszFhWCo1Z8EnB5JhZol+WhujN6mqNasT1x70gxbq4tzVv0kPyOkhS3RPS
	 5SHRXsSjEPe3J0AH0pmA/Jv1ncme5UI0P+w1HmXHy0J6do2DtaKgirsYYCWV8CKC9X
	 aeatR0rPu9PQ9GVLabUenfTjfXz74QCceC3LXYZhDuzkXDYoy9J3KU4/LZwv/zzNW/
	 xN1vZEFNpAuXw==
Date: Fri, 20 Mar 2026 12:48:00 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Anna Wilcox <AWilcox@wilcox-tech.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [libnftnl PATCH] examples: nft-rule-add: Fix compile on musl libc
Message-ID: <ab0z8HmTHljlaUEg@chamomile>
References: <20260320084340.26543-2-AWilcox@Wilcox-Tech.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260320084340.26543-2-AWilcox@Wilcox-Tech.com>

On Fri, Mar 20, 2026 at 03:43:04AM -0500, Anna Wilcox wrote:
> Without `_GNU_SOURCE`, the `dest` field on `tcphdr` is not present:
> 
> nft-rule-add.c: In function 'setup_rule':
> nft-rule-add.c:108:21: error: 'struct tcphdr' has no member named 'dest'

Do more examples need this?

> Signed-off-by: Anna Wilcox <AWilcox@Wilcox-Tech.com>
> ---
>  examples/nft-rule-add.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/examples/nft-rule-add.c b/examples/nft-rule-add.c
> index 937b436..486544a 100644
> --- a/examples/nft-rule-add.c
> +++ b/examples/nft-rule-add.c
> @@ -5,6 +5,7 @@
>   * This software has been sponsored by Sophos Astaro <http://www.sophos.com>
>   */
>  
> +#define _GNU_SOURCE	/* for tcphdr.dest */
>  #include <stdlib.h>
>  #include <time.h>
>  #include <string.h>
> -- 
> 2.52.0
> 
> 
