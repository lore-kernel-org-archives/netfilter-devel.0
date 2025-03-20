Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02D95A923
	for <netfilter-devel@vger.kernel.org>; Thu, 20 Mar 2025 00:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742429905; cv=none; b=KnYnWpeYVAJKyLu6t8Rns8AOkocoCGSGu9N3wY5R8E/6d3l78wz2AXRfbbE3skJxbofdq2KLnaxLYiLquud5gIw9hwa5N2vtIcQ2UTx0YZKB/z5UY3bEiAl/GVHtBNd8eA2uAnfL9uJA2eD2yItlpujsG6Yq5Qzll+bhYu8xNxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742429905; c=relaxed/simple;
	bh=wmQrHE+Mlkz53dlQExWzm0o+ycqLM6eAkgQITbdsZJE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kx2X+TjE/ekJl0mxgqOcLmx2vqiLsEsZeV+HCmKBADh0zj5elu8bxqjBf5uM5yqe9kTyra6Nmh5myGiONw2o5XnFtiBDd3s/YrgsdVGSqgTKKr1Gb7bCeLn80ll1Yp410h4wH+c6niULqpFhl5y6iFForEdm5u30MxnE5NjHrSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=HwUReX3t; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=HS3WcfPh; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="HwUReX3t";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="HS3WcfPh"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 27A56603BD; Thu, 20 Mar 2025 01:18:21 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1742429901;
	bh=MR78da8H8OVNptRrtev1sKYtZx41A3aoT9VMQ1kRk9c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HwUReX3tbTvLBvuDdxjU2WxGwwLOUwETN4JeY2yCvjeLQP8HyEWzwLqRMbVUgDoQi
	 hL8etw/UMQZ5AD83cttKVttjcqDZS26UVDRyLiiWchu63nVUop/uSayxLLWRxE3qSU
	 kVAxnQbYyuIjWpmTG8MhTtXinYo1g+Ky1a9cICYZXZu5d0AIfMlyAJyctFn5pToCnA
	 PjOJL77Ul3L/L/5tSgQQBZCaix4OlRbvtLCEl+Jg7Dxe/yI0SXirRfU1uoizLyGlQg
	 LQ/yhGDgeirqN1XvxpBsIGgJbX1UieqBwhNOc2sg0mk9P06lD4D/4/plo28vQsXiXv
	 G6Y0oBgmGsdvg==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 38D83603BD;
	Thu, 20 Mar 2025 01:18:20 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1742429900;
	bh=MR78da8H8OVNptRrtev1sKYtZx41A3aoT9VMQ1kRk9c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HS3WcfPhZDDH1KGwaaUxYxahj3L/GDiK1SSaA5nMn1mRpFdW6i9ayYZjV+9vJk0v2
	 WYgc1BD4Q8WEIw3/1ztmF5ZBCuYIscTbij88cMEYv+TvpgnP7SYoCcdhkHmK0+Iqb0
	 W8JH27GqKst6x1SQi6sJMe3Ew3ej4FgjOYwtI7tXcX/c+UdaYwb4dEozay9zh5AdPQ
	 UJitbh1B4b6tnYVpImJeFYvqYYE5JHuJ8YLiGcg3gfO3Not5TilIV48EhsJ6VpmrD/
	 Bfokwqe75TtEu/nLub9lvQV6XBR+ZSk/MzLIiRFSex0AKVc4AGnAhPdJUxDNtNPQDb
	 DXFwzbwSc9Vxw==
Date: Thu, 20 Mar 2025 01:18:17 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] expression: tolerate named set protocol dependency
Message-ID: <Z9teyXKA-B25J2mO@calendula>
References: <20250313163955.13487-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250313163955.13487-1-fw@strlen.de>

On Thu, Mar 13, 2025 at 05:39:51PM +0100, Florian Westphal wrote:
> Included test will fail with:
> /dev/stdin:8:38-52: Error: Transparent proxy support requires transport protocol match
>    meta l4proto @protos tproxy to :1088
>                         ^^^^^^^^^^^^^^^
> Tolerate a set reference too.  Because the set can be empty (or there
> can be removals later), add a fake 0-rhs value.
> 
> This will make pctx_update assign proto_unknown as the transport protocol

this is correct for meta, so...

> in use, Thats enough to avoid 'requires transport protocol' error.
> 
> Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1686
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  src/expression.c                              | 10 +++
>  .../dumps/named_set_as_protocol_dep.json-nft  | 75 +++++++++++++++++++
>  .../nft-f/dumps/named_set_as_protocol_dep.nft | 11 +++
>  .../testcases/nft-f/named_set_as_protocol_dep |  5 ++
>  4 files changed, 101 insertions(+)
>  create mode 100644 tests/shell/testcases/nft-f/dumps/named_set_as_protocol_dep.json-nft
>  create mode 100644 tests/shell/testcases/nft-f/dumps/named_set_as_protocol_dep.nft
>  create mode 100755 tests/shell/testcases/nft-f/named_set_as_protocol_dep
> 
> diff --git a/src/expression.c b/src/expression.c
> index 8a90e09dd1c5..38d3ad6d6a4b 100644
> --- a/src/expression.c
> +++ b/src/expression.c
> @@ -945,6 +945,16 @@ void relational_expr_pctx_update(struct proto_ctx *ctx,
>  				    i->key->etype == EXPR_VALUE)
>  					ops->pctx_update(ctx, &expr->location, left, i->key);
>  			}
> +		} else if (right->etype == EXPR_SET_REF) {
> +			const struct expr *key = right->set->key;
> +			struct expr *tmp;
> +
> +			tmp = constant_expr_alloc(&expr->location, key->dtype,
> +						  key->byteorder, key->len,
> +						  NULL);
> +
> +			ops->pctx_update(ctx, &expr->location, left, tmp);
> +			expr_free(tmp);

maybe narrow down this to meta on the lhs? I am not sure of the effect
of this update for payload and ct, they also provide .pctx_update.

If there is a use-case for these two other expression, this can be
revisited.

Thanks.

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
> 2.45.3
> 
> 
