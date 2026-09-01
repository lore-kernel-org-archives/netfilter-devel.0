Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C226412276
	for <netfilter-devel@vger.kernel.org>; Tue,  1 Sep 2026 14:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788274576; cv=none; b=lj2fDVIW/C2lvb6kvoBOneN5GInG+hlX/GHs+f5i4e4K0Tg1JDQTG9s9ptqiOxnwwX6ix4rY4/Y4nDlJyG+6ph8oZcbagnXHrWXuF4MKNxw10DLZrp3eo+Lul2Et6FjfBsw+H5Iht3OALwJrw+/Vbo1aYD0bPIbJDEZ2gkCB81E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788274576; c=relaxed/simple;
	bh=vRI/CPmjunANHCoGKoh9h3VO/0mfa3Z/eB3AFzpaWR4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aRhiQxZ6gz6mGgA4wKgmy+MkcSoVt3kDrboZqWGCim8FSXZE+UkkTdJIFOm+5gqDooveTttXp9amICSCM/zEL5oaRYnCZnx+ryF81OKO/rl6w4TCgpc+Mw0M7a05N66YStKwZvE7jIcSma3kUCi4yP/MFLbEvM4hO/Te8kfBwXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=sYgYc509; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="sYgYc509"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1788274570;
	bh=BvOlphvJy6PJpsS8oxw5fBYMuZY4vdRc75nFUFBnkYU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sYgYc509PZ1koZRExafkxunVgMCotXU51v08sJMKx8BpOMYZ/Q74001pcxUCfw7D5
	 Fx0AFDUwgjQYZwU2YEfQbTPx7Z0ZitC/VgV/nH9d/fhmko0LzwsF/Ahj2QmsQIlnGe
	 VmdZ7r/C56xP/aOp8UQ1JR3Kj749x1wIuObwl6+R58Pwoyx7ZwTy+dx+xJ+hjje9d2
	 IQf/kg1LM/xvzeUkfzDR3wr0c8thoL4XL8drAwWMRUH2uyLzYiR93pXRahoD4XrAIV
	 CWFH9E137hLs4sVfCkK/QRcDOqrhVIx+E37/Dbifv/wjD/f2hEeRK0wjOMB2C3tdZy
	 I+wBudTv7E+Qg==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id EC37360093;
	Tue,  1 Sep 2026 16:56:09 +0200 (CEST)
Date: Tue, 1 Sep 2026 16:56:07 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] libnftables: Drop symbol
 nft_bison_have_extended_errors
Message-ID: <apbnh53-c6IGNYut@chamomile>
References: <20260901094852.104268-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260901094852.104268-1-phil@nwl.cc>

On Tue, Sep 01, 2026 at 11:48:52AM +0200, Phil Sutter wrote:
> It was merely used to indicate extended parser error support in 'nft
> --version' output. Not worth bumping library version just for that, so
> drop it again.
> 
> Fixes: b315dd551dd96 ("parser_bison: Fix for bison < 3.6")
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>

Thanks

> ---
>  include/nftables/libnftables.h |  2 --
>  src/libnftables.map            |  4 ----
>  src/main.c                     | 15 ++++++---------
>  src/parser_bison.y             |  4 ----
>  4 files changed, 6 insertions(+), 19 deletions(-)
> 
> diff --git a/include/nftables/libnftables.h b/include/nftables/libnftables.h
> index 90b3f1b84a66f..c1d48d765a423 100644
> --- a/include/nftables/libnftables.h
> +++ b/include/nftables/libnftables.h
> @@ -99,8 +99,6 @@ void nft_ctx_clear_vars(struct nft_ctx *ctx);
>  int nft_run_cmd_from_buffer(struct nft_ctx *nft, const char *buf);
>  int nft_run_cmd_from_filename(struct nft_ctx *nft, const char *filename);
>  
> -extern bool nft_bison_have_extended_errors;
> -
>  #ifdef __cplusplus
>  } /* extern "C" */
>  #endif
> diff --git a/src/libnftables.map b/src/libnftables.map
> index 55c64f40e6a28..9369f44f35367 100644
> --- a/src/libnftables.map
> +++ b/src/libnftables.map
> @@ -38,7 +38,3 @@ LIBNFTABLES_4 {
>    nft_ctx_input_get_flags;
>    nft_ctx_input_set_flags;
>  } LIBNFTABLES_3;
> -
> -LIBNFTABLES_5 {
> -  nft_bison_have_extended_errors;
> -} LIBNFTABLES_4;
> diff --git a/src/main.c b/src/main.c
> index 976410b05fba8..c8430174f5450 100644
> --- a/src/main.c
> +++ b/src/main.c
> @@ -237,7 +237,7 @@ static void show_help(const char *name)
>  
>  static void show_version(void)
>  {
> -	const char *cli, *minigmp, *json, *xt, *ext_bsn_err;
> +	const char *cli, *minigmp, *json, *xt;
>  
>  #if defined(HAVE_LIBREADLINE)
>  	cli = "readline";
> @@ -266,16 +266,13 @@ static void show_version(void)
>  #else
>  	xt = "no";
>  #endif
> -	ext_bsn_err = nft_bison_have_extended_errors ? "yes" : "no";
> -
>  	printf("%s v%s (%s)\n"
> -	       "  cli:				%s\n"
> -	       "  json:				%s\n"
> -	       "  minigmp:			%s\n"
> -	       "  libxtables:			%s\n"
> -	       "  extended parser errors:	%s\n",
> +	       "  cli:		%s\n"
> +	       "  json:		%s\n"
> +	       "  minigmp:	%s\n"
> +	       "  libxtables:	%s\n",
>  	       PACKAGE_NAME, PACKAGE_VERSION, RELEASE_NAME,
> -	       cli, json, minigmp, xt, ext_bsn_err);
> +	       cli, json, minigmp, xt);
>  
>  }
>  
> diff --git a/src/parser_bison.y b/src/parser_bison.y
> index 3967993472960..c63007321e339 100644
> --- a/src/parser_bison.y
> +++ b/src/parser_bison.y
> @@ -6677,8 +6677,4 @@ yyreport_syntax_error(const yypcontext_t *yyctx, struct nft_ctx *nft,
>  	return 0;
>  }
>  
> -bool nft_bison_have_extended_errors = true;
> -#else /* ! YY_LAC_ESTABLISH */
> -bool nft_bison_have_extended_errors = false;
>  #endif /* YY_LAC_ESTABLISH */
> -EXPORT_SYMBOL(nft_bison_have_extended_errors);
> -- 
> 2.54.0
> 
