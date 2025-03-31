Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74D701B4F0F
	for <netfilter-devel@vger.kernel.org>; Mon, 31 Mar 2025 11:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743420175; cv=none; b=l7gS88VQKxBpab1MHE/mqbDYV2E0WDXjKnaEcZN/3JwazjRStmp4oX0p/hQAuFpCWOK1kKB9A0VImsdqg7VpskbGnWyBtqO6rd9yyKxRr75f0daO2yDBeBsJVDj/aIouwQmeqr92d3SBbwOHyQ8AK/SowrEs9jlVw/utAFPVtw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743420175; c=relaxed/simple;
	bh=/9VDT3yJGZOI1N1/EgjlY/I5ke1Au2yXYxE1fNAdZLA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UFftg8I1yKu9tmxwEgRVZYtIFbmMM1jlhIFClCgOSiw70sixCfWj6AC1n9f1dCtFifo+kVESEP7/Y3JJp/SC+J1HoPkDDsHbVIrdOqJGR6mP1Dy0GsO2ROS+RMnrJSCcg/VChv0W+rOXqMxdD8Y43SYRelFAaU3n2HrCIDTEBFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=lyeWWLLP; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=IX9V9cHz; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="lyeWWLLP";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="IX9V9cHz"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 73958603C8; Mon, 31 Mar 2025 13:22:49 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1743420169;
	bh=paB53XXNAI/Hxnh58VpRTPoWYwVI0GZ4AF9rQxQSRAk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lyeWWLLP5AiwrlmIAr0KHUnZsbegnHVA3DhT2Ory925clSrm86jYu6gtLQFm/QTi3
	 4RC0CWG7JLgXax42/idG12TIdQP+9FQFnroyB5AK4RHYNNPDTxr1EDZj7/JWCOJzpw
	 781NVrtOnHncbZJMv6oJtZ/TdFvpGcfg8UJp1EVBNgq858NRgN6jyVYiaKItZ6d1T1
	 jH9y28rqxN3f28ZCfgYHBd2MZNLCPt9VQByVnC/1ceydUI8jbKpTtEO3gNodjH8AvG
	 UFkw3AtKydvl8F4kHoKL2O78ZZgInwpa4swC02IsRxY/X3qphyjmLC0lGM7sk667Hr
	 rr7HHlODUlm3Q==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id C3AE3603B5;
	Mon, 31 Mar 2025 13:22:48 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1743420168;
	bh=paB53XXNAI/Hxnh58VpRTPoWYwVI0GZ4AF9rQxQSRAk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IX9V9cHzwyOLxsfePfG/N9LUfv8IrA4wnUjTnpus2CafHw8U29Gq+VIgBiNd8hdG7
	 kac2Mua0I16Z5FW2nQ9boIq0vbPwkYl9LuHf9Z0JsFYPMDIepxigwC9TuTR2AldUPP
	 bGfT1+spjf5yvNPIXDxdY3XtfAMViUHW7fFUnqQWN13yXMgmH3L3jKe7z2eDAXHdMt
	 8RRjU1ZRDRqGWLNvz0GvzmH7ZSgrJ5Wr6PxQwD6LBbMat+wQ1t9yZZX1oCaLuzmVcN
	 GFzWsQeQy9lgZhquvpAkeXco1uI4clMTG1eXE8lXpfyVyEr0oQP8fdP5TfVUzRi/d5
	 AmNu3+6ac9Qlw==
Date: Mon, 31 Mar 2025 13:22:46 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] expression: don't try to import empty string
Message-ID: <Z-p7BmD6RqC9-IN4@calendula>
References: <20250327151720.17204-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="LbUjEXbZl5NVXe6E"
Content-Disposition: inline
In-Reply-To: <20250327151720.17204-1-fw@strlen.de>


--LbUjEXbZl5NVXe6E
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Florian,

On Thu, Mar 27, 2025 at 04:17:11PM +0100, Florian Westphal wrote:
> The bogon will trigger the assertion in mpz_import_data:
> src/expression.c:418: constant_expr_alloc: Assertion `(((len) + (8) - 1) / (8)) > 0' failed.

I took a quick look searching for {s:s} in src/parser_json.c

The common idiom is json_parse_err() then a helper parser function to
validate the string.

It seems it is missing in this case. Maybe tigthen json parser instead?

Caller invoking constant_expr_alloc() with data != NULL but no len
looks broken to me.

Maybe take both patches if you prefer?

> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  src/expression.c                              |  2 +-
>  .../bogons/nft-j-f/constant_expr_alloc_assert | 38 +++++++++++++++++++
>  2 files changed, 39 insertions(+), 1 deletion(-)
>  create mode 100644 tests/shell/testcases/bogons/nft-j-f/constant_expr_alloc_assert
> 
> diff --git a/src/expression.c b/src/expression.c
> index 156a66eb37f0..f230f5ad8935 100644
> --- a/src/expression.c
> +++ b/src/expression.c
> @@ -494,7 +494,7 @@ struct expr *constant_expr_alloc(const struct location *loc,
>  	expr->flags = EXPR_F_CONSTANT | EXPR_F_SINGLETON;
>  
>  	mpz_init2(expr->value, len);
> -	if (data != NULL)
> +	if (data != NULL && len)
>  		mpz_import_data(expr->value, data, byteorder,
>  				div_round_up(len, BITS_PER_BYTE));
>  
> diff --git a/tests/shell/testcases/bogons/nft-j-f/constant_expr_alloc_assert b/tests/shell/testcases/bogons/nft-j-f/constant_expr_alloc_assert
> new file mode 100644
> index 000000000000..9c40030212ef
> --- /dev/null
> +++ b/tests/shell/testcases/bogons/nft-j-f/constant_expr_alloc_assert
> @@ -0,0 +1,38 @@
> +{
> +  "nftables": [
> +    {
> +      "table": {
> +        "family": "ip",
> +        "name": "t",
> +        "handle": 0
> +      }
> +    },
> +    {
> +      "chain": {
> +        "family": "ip",
> +        "table": "t",
> +        "name": "testchain",
> +        "handle": 0
> +      }
> +    },
> +    {
> +      "map": {
> +        "family": "ip",
> +        "name": "testmap",
> +        "table": "t",
> +        "type": "ipv4_addr",
> +        "handle": 0,
> +        "map": "verdict",
> +        "elem": [
> +          [
> +            {
> +              "jump": {
> +                "target": ""
> +              }
> +            }
> +          ]
> +        ]
> +      }
> +    }
> +  ]
> +}
> -- 
> 2.48.1
> 
> 

--LbUjEXbZl5NVXe6E
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="x.patch"

diff --git a/src/parser_json.c b/src/parser_json.c
index 04d762741e4a..ef7740840710 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -1350,6 +1350,9 @@ static struct expr *json_parse_verdict_expr(struct json_ctx *ctx,
 		    json_unpack_err(ctx, root, "{s:s}", "target", &chain))
 			return NULL;
 
+		if (!chain || chain[0] == '\0')
+			return NULL;
+
 		return verdict_expr_alloc(int_loc, verdict_tbl[i].verdict,
 					  json_alloc_chain_expr(chain));
 	}

--LbUjEXbZl5NVXe6E--
