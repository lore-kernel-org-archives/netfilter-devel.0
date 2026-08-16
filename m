Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C09A630F932;
	Sun, 16 Aug 2026 20:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786912686; cv=none; b=sN7Zg8leN8bPcml+iMtlSLc2LfQJnuz766W9dY+37vwXnAAmAMtKnRa6GUlRYjYf95C4z4RF9Rtr8+v4HE28I9wEFFAjBuuA7p2pEv+YBnx/B8RatzAtxSIwUQ+asi3L5D3TnmyD1xZ4l60oaCdty66vEB8g7jOzEAF96IosHzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786912686; c=relaxed/simple;
	bh=uwRNL0HvoPYHMmCv4OhOZA5642DexDlNG03kn5E9DaQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MYFVw2xyBRj9jhKLuDqsmJ72gMVikO8vZZK8wfnRlskxXrXkuciJZEHB3bfJnVytdbTtY/Alrclhl2cZ6JiomtDdtGG1j2UDwFkgnioIZCGG4xLYrTaadruipbm7jtu2y0Famu1IW5aekl6+hrtqleV0KNiKTgzzH1foYF9lbZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=pyg3gT9E; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="pyg3gT9E"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1786912674;
	bh=8Bx3gzwPLxWWAJE/GUHaYNjsteJ7lVcVXr9MBy/KJCw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pyg3gT9EdNVl2tLgGli0TlnNs4Tvj+bfxaHmEKwm+yAuPeIXFVPieZeJPR5+Z8zQ0
	 h5ftgNiIC51nOJD3qVr5ILc2L24FDwhZmyXQDBgq6yQJfAB4d0+YJyh2VIRVxFVSnc
	 i5v7GNoCflhlBYjPcm0iT/fhO43nW4mJcHIzR57zScpg7BEDhdUdNcwU/OTf+M7xvI
	 Ufo+1p3OMb+muTuyWMEXIZGJC/QfaFiA8xPLrqhhbnno5uq/Kqukwr8W+i7k/Mlr8o
	 +386WaaU6ISGLqQvyCpAHR1M2Y2IyYZ/uytgswPie4KY/xq/nEfn+TD5GPE2gFU+07
	 cr8gHfiPVBYEw==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id A6F3F6005D;
	Sun, 16 Aug 2026 22:37:54 +0200 (CEST)
Date: Sun, 16 Aug 2026 22:37:51 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Bernard Ladenthin <bernard.ladenthin@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, fw@strlen.de,
	netfilter-devel@vger.kernel.org, kunit-dev@googlegroups.com,
	davem@davemloft.net
Subject: Re: [PATCH 1/4] lib/ts_bm: advance state->offset past the reported
 match
Message-ID: <aoIfn1SzxQKa5t8m@chamomile>
References: <20260816170541.3384-1-bernard.ladenthin@gmail.com>
 <20260816170541.3384-2-bernard.ladenthin@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260816170541.3384-2-bernard.ladenthin@gmail.com>

On Sun, Aug 16, 2026 at 07:05:37PM +0200, Bernard Ladenthin wrote:
> bm_find() reads state->offset to decide where to resume, but never writes
> it back. textsearch_find() zeroes state->offset before the first call.
> textsearch_next() then relies on the algorithm having moved it past the
> match it just reported. With the "bm" algorithm every textsearch_next()
> call restarts from the same place and re-reports the first match. A caller
> looping until UINT_MAX never terminates.

Yes, for a good reason.

> Searching "xxABxxABxx" for "AB" reports offset 2 on every call. The match
> at offset 6 is never reached.

With bm, it reports offset 6, because it looks from right to left,
this is how the original Boyer-Moore algorithm works.

> kmp_find() and fsm_find() both update state->offset already. This is
> an inconsistency between implementations of one interface, not a
> documented limitation of Boyer-Moore.
> 
> Set state->offset to the end of the match and derive the return value from
> it, mirroring kmp_find().

Why? What do you get by setting state->offset?

What are you trying to fix?

> No in-tree code called textsearch_next() before this series. The KUnit
> tests added in the following patch are the first. The function is exported
> though, and lib/textsearch.c documents it as the way to fetch subsequent
> occurrences "regardless of the linearity of the data". Which algorithm a
> caller selected should not decide whether that works.

Why?

> xt_string lets userspace pick the algorithm, so "bm" is a live
> choice.

Yes, and people that use it rely on the current behaviour, so you have
to explain what you are aiming at fixing.

> skb_find_text() also mentions textsearch_next() in its kernel-doc. That
> comment has been stale since commit 059a2440fd3c ("net: Remove state
> argument from skb_find_text()") moved ts_state into the function's own
> scope. It is not evidence of a working caller.
> 
> Fixes: 8082e4ed0a61 ("[LIB]: Boyer-Moore extension for textsearch infrastructure strike #2")
> Signed-off-by: Bernard Ladenthin <bernard.ladenthin@gmail.com>
> ---
> This is my first kernel submission. Corrections on anything I got wrong in
> the process are welcome.

You are not specifying any tree for this patches.

> 
>  lib/ts_bm.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/ts_bm.c b/lib/ts_bm.c
> index 676105e84005..eacc49e64c56 100644
> --- a/lib/ts_bm.c
> +++ b/lib/ts_bm.c
> @@ -98,7 +98,8 @@ static unsigned int bm_find(struct ts_config *conf, struct ts_state *state)
>  			if (i == bm->patlen) {
>  				/* London calling... */
>  				DEBUGP("found!\n");
> -				return consumed + (shift-(bm->patlen-1));
> +				state->offset = consumed + shift + 1;
> +				return state->offset - bm->patlen;
>  			}
>  
>  			bs = bm->bad_shift[text[shift-i]];
> -- 
> 2.49.0.windows.1
> 
