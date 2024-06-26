Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD868190045
	for <netfilter-devel@vger.kernel.org>; Wed, 26 Jun 2024 16:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719418370; cv=none; b=jozfTJfO+ICTb7u3lXJ4OTPiCbBwdzOAWXeZH9+Z4i3rDhmCymrDDYFhr1dTqOteUYbppi2SeBL6L0MFsNgEr/jPccuBw9WrYSb2KWVF1KKrI/kf8IDE8Jb+2qFLbI9kdrOxR1mVI9l/W4vKwUG9NOfGmdi+0s2xycYq3t0vxxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719418370; c=relaxed/simple;
	bh=b8Mhb+GRNr5OO/+iWOMoch6HL0W4JUI+qyJMV3cP+KA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Yv4fC29DDH1iCytIto1Uu/QhBSzHDmyZNBRLC9FdKfQdHZXPWGDnfcjwkTKJ6QBz9gnkO1BOU+qSZCqdgfBg1VsWf0++SuyVj47i1+07YXMOyN6Jahgb1j6pzGmqcoUphw2tyTkuOso+dRk+AHtcuHt4IvIw9S5yREoVm9I4rVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=58316 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sMVGG-008DtX-N9; Wed, 26 Jun 2024 18:12:46 +0200
Date: Wed, 26 Jun 2024 18:12:43 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	Fabio <pedretti.fabio@gmail.com>
Subject: Re: [nf-next PATCH v2 1/2] netfilter: xt_recent: Reduce size of
 struct recent_entry::nstamps
Message-ID: <Znw9-9hAxauzr2Ie@calendula>
References: <20240614151641.28885-1-phil@nwl.cc>
 <20240614151641.28885-2-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240614151641.28885-2-phil@nwl.cc>
X-Spam-Score: -1.9 (-)

Hi Phil,

On Fri, Jun 14, 2024 at 05:16:40PM +0200, Phil Sutter wrote:
> There is no point in this change besides presenting its possibility
> separate from a follow-up patch extending the size of both 'index' and
> 'nstamps' fields.
> 
> The value of 'nstamps' is initialized to 1 in recent_entry_init() and
> adjusted in recent_entry_update() to match that of 'index' if it becomes
> larger after being incremented. Since 'index' is of type u8, it will at
> max become 255 (and wrap to 0 afterwards). Therefore, 'nstamps' will
> also never exceed the value 255.

Series LGTM.

I'd suggest you collapse these two patches while keeping the
description above, because nstamps is shrinked here in 1/2 then it
gets back to original u16 in 2/2.

Maybe something like:

The value of 'nstamps' is initialized to 1 in recent_entry_init() and
adjusted in recent_entry_update() to match that of 'index' if it becomes
larger after being incremented. Since 'index' is of type u8, it will at
max become 255 (and wrap to 0 afterwards). Therefore, 'nstamps' will
also never exceed the value 255. But this patch expands 'index' to
u16 and then 'nstamps' needs to use u16 too, which exactly the
existing field size in the existing codebase.

I can do this mangling if you prefer to save you cycles, in such case
if you also like better wording, just let me know.

Thanks.

> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  net/netfilter/xt_recent.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/xt_recent.c b/net/netfilter/xt_recent.c
> index ef93e0d3bee0..60259280b2d5 100644
> --- a/net/netfilter/xt_recent.c
> +++ b/net/netfilter/xt_recent.c
> @@ -70,7 +70,7 @@ struct recent_entry {
>  	u_int16_t		family;
>  	u_int8_t		ttl;
>  	u_int8_t		index;
> -	u_int16_t		nstamps;
> +	u_int8_t		nstamps;
>  	unsigned long		stamps[];
>  };
>  
> -- 
> 2.43.0
> 
> 
