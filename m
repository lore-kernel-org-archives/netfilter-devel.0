Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F191617A2E7
	for <netfilter-devel@vger.kernel.org>; Mon, 10 Mar 2025 09:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741600195; cv=none; b=E0Q20PIhSmZbajFLDlZkgICXiDcq4CrhMnmVQ+YGewa65w5WeTfX+ItySbnPQaKC5em9czEFNBd3m5mDUaOStUIdrYB6oZ+NTR468n09uL6LpbdeNOkiolOUL4UE6uCWlMu5UDG/8p1HiOSsMjOTRAt7K467ClG8p6yI4/3pt+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741600195; c=relaxed/simple;
	bh=s5QdXij7p4/kgwwFgxBEe6YMm+YhGjO+8hJK6ao2qyM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IZDANHIeGl0pam238PCM+fsSpqpiyCKDsXE1CRCfT0/EfjF+RcYGRqVa52OG8J7a3rtv87bVNCWwESOU6rSS54/TtJ/0yP4p4fVp3oFwYbSDLLaANHiXBwtWjvg46qf6y+mmslbvR89tIeiE1aYGp7BlHZvFV+qDJF2k1duLjng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=oEwGrl3S; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=oEwGrl3S; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="oEwGrl3S";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="oEwGrl3S"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id D1DF260263; Mon, 10 Mar 2025 10:49:41 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741600181;
	bh=pRmr5YDQRiXSkfC0kNbhkFunWWvvJ2xfZEXh0HauHLM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oEwGrl3S7XKLJjOM6JPEkSTtdzuRdIIzf8/eUMQ/s8DkoWSfg1ynIP8EzLTn35CVt
	 wJVqaChAWMKdggFlRhOlYccH4ABQPwg/D2Ll3xYjgV9hQ534LpOJxndxC0Fa5flM/Q
	 7Ng3ifi+MYC6XOtfm5/fYzr+q0c8pJ4z9c+64oCxbQnxKjG3ccurDjgcme0pGvEz2M
	 CWKK1t0kCgU83Xl5e1ajLRSOsXhwjbLl3bugOdmxZoBixNxTZg1D9TnEHLP2tbDPRA
	 lCp3KBfHqNAUEXAFD3P0Y4VaqBQwOBsbD5+5N/2k7a7T5Cmnbs0dZFm2lWI59XC375
	 i/FZdFgvCEznA==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 12CED60263;
	Mon, 10 Mar 2025 10:49:41 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741600181;
	bh=pRmr5YDQRiXSkfC0kNbhkFunWWvvJ2xfZEXh0HauHLM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oEwGrl3S7XKLJjOM6JPEkSTtdzuRdIIzf8/eUMQ/s8DkoWSfg1ynIP8EzLTn35CVt
	 wJVqaChAWMKdggFlRhOlYccH4ABQPwg/D2Ll3xYjgV9hQ534LpOJxndxC0Fa5flM/Q
	 7Ng3ifi+MYC6XOtfm5/fYzr+q0c8pJ4z9c+64oCxbQnxKjG3ccurDjgcme0pGvEz2M
	 CWKK1t0kCgU83Xl5e1ajLRSOsXhwjbLl3bugOdmxZoBixNxTZg1D9TnEHLP2tbDPRA
	 lCp3KBfHqNAUEXAFD3P0Y4VaqBQwOBsbD5+5N/2k7a7T5Cmnbs0dZFm2lWI59XC375
	 i/FZdFgvCEznA==
Date: Mon, 10 Mar 2025 10:49:38 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] evaluate: don't crash if range has same start and
 end interval
Message-ID: <Z861sjNVv6vwSeLd@calendula>
References: <20250310072940.5524-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250310072940.5524-1-fw@strlen.de>

On Mon, Mar 10, 2025 at 08:29:37AM +0100, Florian Westphal wrote:
> In this case, evaluation step replaces the range expression with a
> single value and we'd crash as range->left/right contain garbage
> values.
> 
> Simply replace the input expression with the evaluation result.
> 
> Also add a test case modeled on the afl reproducer.
> 
> Fixes: fe6cc0ad29cd ("evaluate: consolidate evaluation of symbol range expression")
> Signed-off-by: Florian Westphal <fw@strlen.de>

Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>

Thanks for fixing this silly bug.

> ---
>  src/evaluate.c                                |  5 +++
>  .../dumps/range_with_same_start_end.json-nft  | 35 +++++++++++++++++++
>  .../sets/dumps/range_with_same_start_end.nft  |  7 ++++
>  .../testcases/sets/range_with_same_start_end  | 13 +++++++
>  4 files changed, 60 insertions(+)
>  create mode 100644 tests/shell/testcases/sets/dumps/range_with_same_start_end.json-nft
>  create mode 100644 tests/shell/testcases/sets/dumps/range_with_same_start_end.nft
>  create mode 100755 tests/shell/testcases/sets/range_with_same_start_end
> 
> diff --git a/src/evaluate.c b/src/evaluate.c
> index e27d08ce7ef8..722c11a23c2d 100644
> --- a/src/evaluate.c
> +++ b/src/evaluate.c
> @@ -2351,6 +2351,10 @@ static int expr_evaluate_symbol_range(struct eval_ctx *ctx, struct expr **exprp)
>  		expr_free(range);
>  		return -1;
>  	}
> +
> +	if (range->etype != EXPR_RANGE)
> +		goto out_done;
> +
>  	left = range->left;
>  	right = range->right;
>  
> @@ -2371,6 +2375,7 @@ static int expr_evaluate_symbol_range(struct eval_ctx *ctx, struct expr **exprp)
>  		return 0;
>  	}
>  
> +out_done:
>  	expr_free(expr);
>  	*exprp = range;
>  
> diff --git a/tests/shell/testcases/sets/dumps/range_with_same_start_end.json-nft b/tests/shell/testcases/sets/dumps/range_with_same_start_end.json-nft
> new file mode 100644
> index 000000000000..c4682475917e
> --- /dev/null
> +++ b/tests/shell/testcases/sets/dumps/range_with_same_start_end.json-nft
> @@ -0,0 +1,35 @@
> +{
> +  "nftables": [
> +    {
> +      "metainfo": {
> +        "version": "VERSION",
> +        "release_name": "RELEASE_NAME",
> +        "json_schema_version": 1
> +      }
> +    },
> +    {
> +      "table": {
> +        "family": "ip",
> +        "name": "t",
> +        "handle": 0
> +      }
> +    },
> +    {
> +      "set": {
> +        "family": "ip",
> +        "name": "X",
> +        "table": "t",
> +        "type": "inet_service",
> +        "handle": 0,
> +        "flags": [
> +          "interval"
> +        ],
> +        "elem": [
> +          10,
> +          30,
> +          35
> +        ]
> +      }
> +    }
> +  ]
> +}
> diff --git a/tests/shell/testcases/sets/dumps/range_with_same_start_end.nft b/tests/shell/testcases/sets/dumps/range_with_same_start_end.nft
> new file mode 100644
> index 000000000000..78979e9e0d5e
> --- /dev/null
> +++ b/tests/shell/testcases/sets/dumps/range_with_same_start_end.nft
> @@ -0,0 +1,7 @@
> +table ip t {
> +	set X {
> +		type inet_service
> +		flags interval
> +		elements = { 10, 30, 35 }
> +	}
> +}
> diff --git a/tests/shell/testcases/sets/range_with_same_start_end b/tests/shell/testcases/sets/range_with_same_start_end
> new file mode 100755
> index 000000000000..127f0921f0de
> --- /dev/null
> +++ b/tests/shell/testcases/sets/range_with_same_start_end
> @@ -0,0 +1,13 @@
> +#!/bin/bash
> +
> +set -e
> +
> +$NFT -f - <<EOF
> +table ip t {
> +	set X {
> +		type inet_service
> +		flags interval
> +		elements = { 10, 30-30, 30, 35 }
> +	}
> +}
> +EOF
> -- 
> 2.45.3
> 
> 
