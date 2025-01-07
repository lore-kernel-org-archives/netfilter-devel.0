Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8B6A1F37C8
	for <netfilter-devel@vger.kernel.org>; Tue,  7 Jan 2025 23:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736294033; cv=none; b=QOi/LgunhmElR3RrdhLqJrdhkqKXMcPWvvN1Hjtk3wlfa7dWgyHP6rg6lj6oR7/7Qkgsm2o8cP1uGh3urTg1Rmypic0ogI3HS4d4TfuuvOWdIvLcFSI8YrbX5l8cEb0VWaNCNlmGpD5UDMiqQYh+tH15nztXPWjdiNwoRz/WSx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736294033; c=relaxed/simple;
	bh=R4cvj2ZRHv3Hhn4YuM4lEl+LrZN7OWk8tgBYAv0QC8k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BHcusgO+YFTV1QeZkq7VdFnuQMnwDADKsAKQrwEFZF9T3AfYEQm9tUOgg+FIV4L9e/Jb+3uucinovZzEmOUX3suDTI+36k+er8g5G95yDdgynu8Gn0x5xsWHn0JtrCUQTxMlNi2cInrYqgftsOZ011SU97hyJSJJJVwKWtAo2RY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Date: Wed, 8 Jan 2025 00:53:48 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] parser_bison: fix UaF when reporting table parse
 error
Message-ID: <Z32-jODK1oDsAYRp@calendula>
References: <20250107225509.6539-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250107225509.6539-1-fw@strlen.de>

On Tue, Jan 07, 2025 at 11:55:06PM +0100, Florian Westphal wrote:
> It passed already-freed memory to erec function.  Found with afl++ and asan.
> 
> Fixes: 4955ae1a81b7 ("Add support for table's persist flag")
> Signed-off-by: Florian Westphal <fw@strlen.de>

Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>

> ---
>  src/parser_bison.y | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/src/parser_bison.y b/src/parser_bison.y
> index 6e6f3cf8335d..7ab15244be52 100644
> --- a/src/parser_bison.y
> +++ b/src/parser_bison.y
> @@ -1943,12 +1943,14 @@ table_flags		:	table_flag
>  table_flag		:	STRING
>  			{
>  				$$ = parse_table_flag($1);
> -				free_const($1);
>  				if ($$ == 0) {
>  					erec_queue(error(&@1, "unknown table option %s", $1),
>  						   state->msgs);
> +					free_const($1);
>  					YYERROR;
>  				}
> +
> +				free_const($1);
>  			}
>  			;
>  
> -- 
> 2.45.2
> 
> 
