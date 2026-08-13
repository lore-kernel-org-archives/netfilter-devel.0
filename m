Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8065337F314
	for <netfilter-devel@vger.kernel.org>; Thu, 13 Aug 2026 11:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786620119; cv=none; b=R2EOJABXVzRz6nEw0Xvau0SX4Ff1cbmkI0YoDu/37ThYvNKWhx2k/dqx/XrbmkDyBFf+iScYqoObT/61ikADr/61Y7VPSecdYRl/skkWtf6Rl+xEwmI3O9RM0YdEmNNclie1esuD6e3JqfmvcFBOc2QHC1QBj4RNU81SZR/MbJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786620119; c=relaxed/simple;
	bh=HLbKDMkrAMda79Z9/c/dJY5P3uvQipwy/77qvYo9Ou8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BH/Q/DecEbONGvnl//gdAZhq+1v45jDdqpzywd0HAzNhPB+eqqpiPCNY8NHgrvdVHfRFenBOa5nhYgmVX/JHB2OlGoYkV7gekFIB76w28ky5JAtTQMujGBspcpeyWPg0zHP+YuSnZR/CTXi+FAeDyhhc2dqez4WDISU4tgV/cSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=MDC7/+aM; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="MDC7/+aM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=lNyc+Nh5H1Vp0zwWtJwfG32d25vI/KXni+bOZ2kV70I=; b=MDC7/+aMuRRoun+Y/QTgDL+zKT
	1Y9b0FLWBIwMDqSLWN2nUEsxNvQ3XLHYs5id11gP9JG6ca0PtiIZ+CFtaUJgigWWNTXjTN7nx3cJX
	i46P/CsuOrcSjIZzuxwbOj7f1vg/Ztq/yGlc20qziKu4C6PBJKhgrxEFjr43bfuZIhUFx7Amlt+Oq
	5PcVgELHxpvsB3vWjiKE7alvYY95Br6p9JFzZtPZvO/+0TVvSWLj1VBINou+Xpt/s3DNBFYjwQKNe
	SLrLeWikCZoglveiGvxrRQS8mYooCPAZZuZu+SMm5/+n8PGW1CSMGCBkQ+19KlHARNs2v2Fk6XApx
	gqiNVWwg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1wuTVR-000000001xh-1St3;
	Thu, 13 Aug 2026 13:21:53 +0200
Date: Thu, 13 Aug 2026 13:21:53 +0200
From: Phil Sutter <phil@nwl.cc>
To: Avinash Duduskar <avinash.duduskar@gmail.com>
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] evaluate: reject negative values for unsigned
 datatypes
Message-ID: <an2o0fusJ0K-_CbS@orbyte.nwl.cc>
References: <20260808013318.2766219-1-avinash.duduskar@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260808013318.2766219-1-avinash.duduskar@gmail.com>

On Sat, Aug 08, 2026 at 07:03:18AM +0530, Avinash Duduskar wrote:
> expr_evaluate_integer() only tests the upper bound, so a negative value
> passes the range check and mpz_export() then drops the sign:
> 
>   # nft add element ip t m { "-1" }
>   # nft list set ip t m
>   table ip t {
>           set m {
>                   type mark
>                   elements = { 0x00000001 }
>           }
>   }
> 
> The error string has read "Value %s exceeds valid range 0-%s" since the
> check was added, so the contract was already unsigned; only the upper
> half of it was enforced. The result is not a wrap either: "-1" gives 1
> while "-4294967295" gives 0xffffffff.
> 
> Reject a negative value, unless the evaluation context is a chain
> priority, which is signed.
> 
> Fixes: cb7cb885d65e ("evaluate: add expr_evaluate_integer()")
> Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
> Signed-off-by: Avinash Duduskar <avinash.duduskar@gmail.com>
> ---
>  src/evaluate.c                                | 12 +++++
>  tests/py/any/meta.t                           |  2 +
>  .../parsing/dumps/negative_values_0.nodump    |  0
>  .../shell/testcases/parsing/negative_values_0 | 46 +++++++++++++++++++
>  4 files changed, 60 insertions(+)
>  create mode 100644 tests/shell/testcases/parsing/dumps/negative_values_0.nodump
>  create mode 100755 tests/shell/testcases/parsing/negative_values_0
> 
> diff --git a/src/evaluate.c b/src/evaluate.c
> index 8bb7b609..f5b88c0b 100644
> --- a/src/evaluate.c
> +++ b/src/evaluate.c
> @@ -447,6 +447,18 @@ static int expr_evaluate_integer(struct eval_ctx *ctx, struct expr **exprp)
>  		return -1;
>  	}
>  
> +	/* chain priorities are signed, everything else is an unsigned key:
> +	 * mpz_export() drops the sign, so "-1" would silently become 1.
> +	 */
> +	if (mpz_sgn(expr->value) < 0 && ctx->ectx.dtype != &priority_type) {

Although it might remain the only case, I don't like the special-casing
here. Looking at struct datatype, we have a 32bit field for flags with
only two bits used yet. Maybe introduce an 'is_signed' bit to check
here?

Thanks, Phil

> +		valstr = mpz_get_str(NULL, 10, expr->value);
> +		expr_error(ctx->msgs, expr,
> +			   "Value %s is negative, expecting an unsigned value",
> +			   valstr);
> +		nft_gmp_free(valstr);
> +		return -1;
> +	}
> +
>  	if (ctx->stmt_len > ctx->ectx.len)
>  		masklen = ctx->stmt_len;
>  	else
> diff --git a/tests/py/any/meta.t b/tests/py/any/meta.t
> index c5ab2ad9..4f486307 100644
> --- a/tests/py/any/meta.t
> +++ b/tests/py/any/meta.t
> @@ -56,6 +56,8 @@ meta mark and 0x03 == 0x01;ok;meta mark & 0x00000003 == 0x00000001
>  meta mark and 0x03 != 0x01;ok;meta mark & 0x00000003 != 0x00000001
>  meta mark 0x10;ok;meta mark 0x00000010
>  meta mark != 0x10;ok;meta mark != 0x00000010
> +meta mark "-1";fail
> +meta mark "-4294967295";fail
>  meta mark 0xffffff00/24;ok;meta mark & 0xffffff00 == 0xffffff00
>  
>  meta mark or 0x03 == 0x01;ok;meta mark | 0x00000003 == 0x00000001
> diff --git a/tests/shell/testcases/parsing/dumps/negative_values_0.nodump b/tests/shell/testcases/parsing/dumps/negative_values_0.nodump
> new file mode 100644
> index 00000000..e69de29b
> diff --git a/tests/shell/testcases/parsing/negative_values_0 b/tests/shell/testcases/parsing/negative_values_0
> new file mode 100755
> index 00000000..663579a0
> --- /dev/null
> +++ b/tests/shell/testcases/parsing/negative_values_0
> @@ -0,0 +1,46 @@
> +#!/bin/bash
> +
> +# mpz_export() drops the sign, so a negative value used to land as its
> +# absolute value: "-1" became 1. Chain priorities are signed and must keep
> +# working.
> +
> +set -e
> +
> +$NFT add table ip t
> +$NFT add set ip t s '{ type mark; }'
> +
> +if $NFT add element ip t s '{ "-1" }' 2>/dev/null; then
> +	echo "E: accepted a negative set element" >&2
> +	$NFT list set ip t s >&2
> +	exit 1
> +fi
> +
> +# a rejected add must not have committed anything
> +out=$($NFT list set ip t s)
> +case "$out" in
> +*elements*)
> +	echo "E: something was stored by the failed add" >&2
> +	echo "$out" >&2
> +	exit 1
> +	;;
> +esac
> +
> +$NFT add chain ip t c
> +
> +if $NFT add rule ip t c meta mark '"-1"' 2>/dev/null; then
> +	echo "E: accepted a negative value in a rule" >&2
> +	exit 1
> +fi
> +
> +# the signed exception: every spelling of a negative chain priority
> +$NFT add chain ip t c1 '{ type filter hook prerouting priority -300; }'
> +$NFT add chain ip t c2 '{ type filter hook prerouting priority filter - 10; }'
> +
> +$NFT -f - <<'NFT'
> +define p = -300
> +table ip t2 {
> +	chain c { type filter hook prerouting priority $p; policy accept; }
> +}
> +NFT
> +
> +exit 0
> 
> base-commit: 49e418238ece947e92f87a35ef6cf50755485370
> -- 
> 2.55.0
> 
> 
