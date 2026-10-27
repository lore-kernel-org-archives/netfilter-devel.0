Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793125351;
	b=pJ5VyChtpMtxEqrJmzBXC7awuT9U7nXJv3EIzeOxNEeE17KXrfhUpQPMWlJa6FvsKnM7
	 2Rm3Gorc9g/FaJnwTCrMeTqDbN9qqKylnVRydFZOiF9PiPg45YSW62lUrCHhzulH20DAo
	 E7DzUALVXdVeomKRWWcGfHrjiheYHzX4S2LJFBUz5+SVfXouh+HfinqcJ+r0bqwzZ9+Ya
	 CLpCj4jQBzT8mMbln7ebc5laIV3Qi1myFvvddWlwgPwr0eMpfUi+Nlf5hCRGOpJA7IKyI
	 t3ZcepfOJM5xywqaHMZeQ5vCkuo9+Ft/hSFKelCSsin7+H/EKJfcfvmmJDWF8S0bYaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793125351;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Status:X-Spam-Checker-Version;
	bh=vP8+AbnUgfRFuz4xQ2yocTwphEg4+rrL/WGyt/5t/cg=;
	b=3Kck2B3Pwk5J8zdIcKLymguNk+6OTAFXLxaq58rRPibbZeWG8xjn7iUyf2IpG79rRl3A
	 GD2qSSvWWFaPtR5X8AMV6Tgt4KsaQdFZVR+eSNVbzRazGD6JKWgLx84Q329xZ5tfaSCvY
	 zfZGwY3mRIH6YwlyONbdZwh8kmvUwMSKiK90XPx+rvuHbvFbxi3PGOhs3HN+f62byNnRk
	 IoOq4X15uw9ZoxjH8i9685dgMLSXcEYzFqtgsLugxHlwf0j81Rw1/e6ehmDrKJSNNahva
	 rpwq1ouzd5/86YEPBRpJY7RnwFfsRzYangaXe4AgPKuRjkZjwtvluv9Tjv95YnSKD1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=rirssIAN;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id BE94C606A31D
	for <netfilter-devel@vger.kernel.org>; Tue, 27 Oct 2026 18:22:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BE94C606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=rirssIAN
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1793125340;
	bh=vP8+AbnUgfRFuz4xQ2yocTwphEg4+rrL/WGyt/5t/cg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rirssIANpBzh27Jze6M4J3xyruNLpZQE//cxKLhwcgNkrd9eaogmuCJxf61YglaH+
	 TZzH2kFO/0+nZGYAzxHuTAWKprwHYiABgyHy3xZ49ZGfGfBAOS7bjenKeuQQwfTmnQ
	 LAdDJIbM0Rt5Xf10GWMb7PBKV0OWlmTwpCjXL7/ElWBpV3hUbImm6YhJ7FReR80OW3
	 J/HLMjHUjprB8/VfcUbeu/lRYTU4+h07u/KlhuMqYHZNjqdQbvM1liuXMqQUzXAfKB
	 H8tt1+vRRrFPHbuZm4OuOOXPD6SggJllru+zoH8EMurZ9X5vQl2FSUmdUIkRosioK6
	 9+n5rcch4O4aA==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 9F76A60058;
	Tue, 27 Oct 2026 19:22:20 +0100 (CET)
Date: Tue, 27 Oct 2026 19:22:17 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Finke Lennart <lfinke@student.ethz.ch>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"linux@vger.kernel.org" <linux@vger.kernel.org>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH] lib/ts_bm: fix missed matches with TS_IGNORECASE
Message-ID: <auDr2Yb1WzBA5Gv-@chamomile>
References: <48F87C26-7D3C-490B-ADA1-2FB0E3E10F53@student.ethz.ch>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <48F87C26-7D3C-490B-ADA1-2FB0E3E10F53@student.ethz.ch>

On Tue, Oct 27, 2026 at 05:20:20PM +0000, Finke  Lennart wrote:
> With TS_IGNORECASE the pattern is stored upper-cased, but bm_find()
> looks up bad_shift[] with the raw text byte. The extra tolower()
> entries miss bytes like 0xff and 0xdf, whose toupper() is a different
> byte that lower-cases to itself, so matches are skipped: "\xffZ" is not
> found in "Y\xffZ".
> 
> Fold the text byte with toupper() before the lookup and drop the
> tolower() entries.

Better to handle this from configuration time.

> Fixes: 3b76d08190e6 ("textsearch: ts_bm: support case insensitive searching in Boyer-Moore algorithm")
> Cc: stable@vger.kernel.org
> Signed-off-by: Lennart Finke <lfinke@ethz.ch>
> ---
>  lib/ts_bm.c | 13 +++++--------
>  1 file changed, 5 insertions(+), 8 deletions(-)
> 
> diff --git a/lib/ts_bm.c b/lib/ts_bm.c
> index 676105e84005..f809aa05f5fc 100644
> --- a/lib/ts_bm.c
> +++ b/lib/ts_bm.c
> @@ -101,7 +101,8 @@ static unsigned int bm_find(struct ts_config *conf, struct ts_state *state)
>  				return consumed + (shift-(bm->patlen-1));
>  			}
>  
> -			bs = bm->bad_shift[text[shift-i]];
> +			bs = bm->bad_shift[icase ? toupper(text[shift-i]) :
> +						   text[shift-i]];
>  
>  			/* Now jumping to... */
>  			shift = max_t(int, shift-i+bs, shift+bm->good_shift[i]);
> @@ -130,18 +131,14 @@ static int subpattern(u8 *pattern, int i, int j, int g)
>  	return ret;
>  }
>  
> -static void compute_prefix_tbl(struct ts_bm *bm, int flags)
> +static void compute_prefix_tbl(struct ts_bm *bm)
>  {
>  	int i, j, g;
>  
>  	for (i = 0; i < ASIZE; i++)
>  		bm->bad_shift[i] = bm->patlen;
> -	for (i = 0; i < bm->patlen - 1; i++) {
> +	for (i = 0; i < bm->patlen - 1; i++)
>  		bm->bad_shift[bm->pattern[i]] = bm->patlen - 1 - i;
> -		if (flags & TS_IGNORECASE)
> -			bm->bad_shift[tolower(bm->pattern[i])]
> -			    = bm->patlen - 1 - i;
> -	}
>  
>  	/* Compute the good shift array, used to match reocurrences 
>  	 * of a subpattern */
> @@ -193,7 +190,7 @@ static struct ts_config *bm_init(const void *pattern, unsigned int len,
>  			bm->pattern[i] = toupper(((u8 *)pattern)[i]);
>  	else
>  		memcpy(bm->pattern, pattern, len);
> -	compute_prefix_tbl(bm, flags);
> +	compute_prefix_tbl(bm);
>  
>  	return conf;
>  }
> 
> base-commit: 21a7f44fd0765fcc5194130b28767786eba1d1e7
> -- 
> 2.50.1 (Apple Git-155)
> 
> 
