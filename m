Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89C2610E0
	for <netfilter-devel@vger.kernel.org>; Thu, 20 Mar 2025 09:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742463202; cv=none; b=tgDWQ1xfh8Q/HVvGZ81YCu6ZAWSB7KQMKNbEjAWTVCkfLl1Le+G3gjst5+bfqNe3d8qM036TVufacGzZLDQTX0PvUoj0ZZJ41ksaFjr2jQlYc1kMWcb8hKPVDcQCIMrBOxPrgYksRHgZRhwlJJIfHefNvs0fBGDadeJ31IvFur8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742463202; c=relaxed/simple;
	bh=chZgW0tB+JdrVcFXJifxLdbQjnpe/OlMXMOWp8l4XTM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kriS0ZuLbdVYmmyoF24s+tmeuSzQm2hKU0CFpmV2jpLjCX5+HwA7PJG/O5oBfiNlY6ZOsvSwBoF6OSd9RCi3oC9xg9E0oop4jhBoFQJy9RjA/T4uS4SyLSoxwiLWg9UYiPilGImsSCw5StxGvHg10TuZaflFX9B1cHeGOyOYnw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=YGetDcxS; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=UfmzE+8k; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="YGetDcxS";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="UfmzE+8k"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 58D7760319; Thu, 20 Mar 2025 10:33:10 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1742463190;
	bh=Qndvy7ZcOIuSDOfnxCkZoUSNQDK+jgJR20LRnQuTkKE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YGetDcxS2d8TLyzM7xfwDioVP8dIg01LTE8m/DZHmw81wRpK4X3suMEKzGsChdKR5
	 WTKndNmPdh27zAzZJWj1HBrXHrOjC1/sAGFz7CTkPKu1166y7WwrJ2hkM696luzKOW
	 V//bB+GpsjZ94rkrqCQwGXt4YN81nau/V3KxcAt0RgmBkg0EXhPI5TqAATFlp1qmLZ
	 EQcSUruVd3PPCr+KtEQ3osFx7mPjvzPnn2ccFdDH+dDdgcu5Owwoh8lEcCcLGhCKYH
	 FLime5wCsjhxXqibEHHEAmgMZ/UI6y0/8xEMV79ogzDpLC+RFUV3W0Kf8MIX+FxvjL
	 niHrVlIjuBHyw==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 717F260319;
	Thu, 20 Mar 2025 10:33:09 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1742463189;
	bh=Qndvy7ZcOIuSDOfnxCkZoUSNQDK+jgJR20LRnQuTkKE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UfmzE+8kBt1FrNk12oB0We6uiTCERwTGNy7BP707mM3szv6rq2rUFAPzU81hrou67
	 FkspThEpICR39CoTKVT1DhYQPSXSw40QCIqAqlKuczfPJa82858F9fIextX4NyNvK3
	 fDRqokzBfucUUhrVpjuwTT5l1JUBWg0qCJxXHLynKkw2MO4Ihz3vglv4abQNGxjIOz
	 UUAUoHDup2FlvNijOb8+kg4hmK+n4CXd40uMLETU2UU9ebnaR61OTUorCmzb8LDUyx
	 xv10ZrF5NIUz9FD4pChnWm573L7JCUMBxr8mwi7hEmtk3NioTg/CUUewDeLHG38xsJ
	 x259Ym3crYIEw==
Date: Thu, 20 Mar 2025 10:33:06 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft v2] expression: tolerate named set protocol dependency
Message-ID: <Z9vg0gqLSv-FYR88@calendula>
References: <20250320083448.12272-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250320083448.12272-1-fw@strlen.de>

On Thu, Mar 20, 2025 at 09:34:45AM +0100, Florian Westphal wrote:
> Included test will fail with:
> /dev/stdin:8:38-52: Error: Transparent proxy support requires transport protocol match
>    meta l4proto @protos tproxy to :1088
>                         ^^^^^^^^^^^^^^^
> Tolerate a set reference too.  Because the set can be empty (or there
> can be removals later), add a fake 0-rhs value.
> 
> This will make pctx_update assign proto_unknown as the transport protocol
> in use, Thats enough to avoid 'requires transport protocol' error.
> 
> v2: restrict it to meta lhs for now (Pablo Neira Ayuso)
> 
> Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1686
> Signed-off-by: Florian Westphal <fw@strlen.de>

Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>

Thanks.

> ---
>  src/expression.c                              | 11 +++
>  .../dumps/named_set_as_protocol_dep.json-nft  | 75 +++++++++++++++++++
>  .../nft-f/dumps/named_set_as_protocol_dep.nft | 11 +++
>  .../testcases/nft-f/named_set_as_protocol_dep |  5 ++
>  4 files changed, 102 insertions(+)
>  create mode 100644 tests/shell/testcases/nft-f/dumps/named_set_as_protocol_dep.json-nft
>  create mode 100644 tests/shell/testcases/nft-f/dumps/named_set_as_protocol_dep.nft
>  create mode 100755 tests/shell/testcases/nft-f/named_set_as_protocol_dep
> 
> diff --git a/src/expression.c b/src/expression.c
> index 413f446772bb..156a66eb37f0 100644
> --- a/src/expression.c
> +++ b/src/expression.c
> @@ -945,6 +945,17 @@ void relational_expr_pctx_update(struct proto_ctx *ctx,
>  				    i->key->etype == EXPR_VALUE)
>  					ops->pctx_update(ctx, &expr->location, left, i->key);
>  			}
> +		} else if (ops == &meta_expr_ops &&
> +			   right->etype == EXPR_SET_REF) {
> +			const struct expr *key = right->set->key;
> +			struct expr *tmp;
> +
> +			tmp = constant_expr_alloc(&expr->location, key->dtype,
> +						  key->byteorder, key->len,
> +						  NULL);
> +
> +			ops->pctx_update(ctx, &expr->location, left, tmp);
> +			expr_free(tmp);
>  		}
>  	}
>  }
> diff --git a/tests/shell/testcases/nft-f/dumps/named_set_as_protocol_dep.json-nft b/tests/shell/testcases/nft-f/dumps/named_set_as_protocol_dep.json-nft
> new file mode 100644
> index 000000000000..4bc24aa319ab
> --- /dev/null
> +++ b/tests/shell/testcases/nft-f/dumps/named_set_as_protocol_dep.json-nft
> @@ -0,0 +1,75 @@
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
> +        "family": "inet",
> +        "name": "test",
> +        "handle": 0
> +      }
> +    },
> +    {
> +      "chain": {
> +        "family": "inet",
> +        "table": "test",
> +        "name": "prerouting",
> +        "handle": 0,
> +        "type": "filter",
> +        "hook": "prerouting",
> +        "prio": -150,
> +        "policy": "accept"
> +      }
> +    },
> +    {
> +      "set": {
> +        "family": "inet",
> +        "name": "protos",
> +        "table": "test",
> +        "type": {
> +          "typeof": {
> +            "meta": {
> +              "key": "l4proto"
> +            }
> +          }
> +        },
> +        "handle": 0,
> +        "elem": [
> +          "tcp",
> +          "udp"
> +        ]
> +      }
> +    },
> +    {
> +      "rule": {
> +        "family": "inet",
> +        "table": "test",
> +        "chain": "prerouting",
> +        "handle": 0,
> +        "expr": [
> +          {
> +            "match": {
> +              "op": "==",
> +              "left": {
> +                "meta": {
> +                  "key": "l4proto"
> +                }
> +              },
> +              "right": "@protos"
> +            }
> +          },
> +          {
> +            "tproxy": {
> +              "port": 1088
> +            }
> +          }
> +        ]
> +      }
> +    }
> +  ]
> +}
> diff --git a/tests/shell/testcases/nft-f/dumps/named_set_as_protocol_dep.nft b/tests/shell/testcases/nft-f/dumps/named_set_as_protocol_dep.nft
> new file mode 100644
> index 000000000000..2bc0c2adb38c
> --- /dev/null
> +++ b/tests/shell/testcases/nft-f/dumps/named_set_as_protocol_dep.nft
> @@ -0,0 +1,11 @@
> +table inet test {
> +	set protos {
> +		typeof meta l4proto
> +		elements = { tcp, udp }
> +	}
> +
> +	chain prerouting {
> +		type filter hook prerouting priority mangle; policy accept;
> +		meta l4proto @protos tproxy to :1088
> +	}
> +}
> diff --git a/tests/shell/testcases/nft-f/named_set_as_protocol_dep b/tests/shell/testcases/nft-f/named_set_as_protocol_dep
> new file mode 100755
> index 000000000000..5c516e421cd6
> --- /dev/null
> +++ b/tests/shell/testcases/nft-f/named_set_as_protocol_dep
> @@ -0,0 +1,5 @@
> +#!/bin/bash
> +
> +dumpfile=$(dirname $0)/dumps/$(basename $0).nft
> +
> +$NFT -f "$dumpfile" || exit 1
> -- 
> 2.48.1
> 
> 
