Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792514081;
	b=MjOFNS9piIeGC9CWwhf18YyWj5odLAdeBEw/CqGW/YVqvGjAlQSeI17BBpasD2th26Tl
	 vZ+3KfdRjoCL03ROKTlE6C3xPsyqe69aVrruPc7YaWJ2XVdWuL92FCuHYjZGAXI7k9jG3
	 ZlwZ/sDytbFwZCjzSrENMV7j0KZ4FdA3fQpNwIbh6rHdkAy5Fp9iLD7E5YsL1KFH2n+Y0
	 uK9K3ZMBbvZdcLZFSfBdwD8Eqgis1w4jV+jxIra4whh9hofvuNYWg6RvNjg1u+AYetiqY
	 5NSWYoNIiPWDmWKjhEN+EuZlzgFghzCS37TP1xMNwoR+EtQoxrXUw+7oDDChYXPEumg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792514081;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Status:X-Spam-Checker-Version;
	bh=LIqqPfHFUUczNEnM2a2UsPxGW20ESAysmnMIYxF9fic=;
	b=iC/lKAYl+nQArhOVQZrQ+1XvNoqnRr62q/VSdnsW7ujAxeCfdmGW0Pr1uIoUKbYAlDR9
	 YEQ1XILwvwodDCFx/ffsJmA52txqA0awmcHNmbdJywS3GsvqKgBjKlHnjuAkYAjkXOuuH
	 fEI8pd/x/OhECMzo5xfICCTXbfBnAi/l3QXlqQhicSN5NaI7JzGCK5WXL1RVM+PN2hxXK
	 wvC2tH+pHMFZRxx+65+2+FB56zjumaN0hQSaa9qyN1utUDSLWyatifoi6B5LnoGVD/+J+
	 n9Pj4d9W7VXjRYlEzzK6vg2QOc7L5U8peO6wG0/f8QoZbNpEjDaaU1J5hw/z8gzyNvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=gdDJUluL;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 7E54F606A31A
	for <netfilter-devel@vger.kernel.org>; Tue, 20 Oct 2026 16:34:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7E54F606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=gdDJUluL
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1792514072;
	bh=LIqqPfHFUUczNEnM2a2UsPxGW20ESAysmnMIYxF9fic=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gdDJUluLRgoWNQSa8ED81B48zdsz/88hRzSACiCn2YrG9a0YPIkl0moQoeKALMI8K
	 w17szEKKlUo6E5AHkJeRUPERn8z0lq8fe7W5WPEDX877Cgl5edEGuITG7pOD9dZHqh
	 L+35btz3YlT+q8OixDq5povZsEbsVlLaaloGODv/UvwBdIVl8jyAfoDcnDTmdn173Q
	 wlb5iXZwiOLFuky5+W5H0/keHao8tBGW9t2uQtklBSRVRI+V1Bs20MDALpAe393D18
	 CzzAaXTPEChjGNZMAAJ3DjuRuMQW6nGUcepxnQSqiUiJVtjMvAkZOmCME79+2OeiIC
	 KNMd8Sxqm0kDQ==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id EE15B60051;
	Tue, 20 Oct 2026 18:34:31 +0200 (CEST)
Date: Tue, 20 Oct 2026 18:34:30 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] src: add misspell hint for ct timeout policy names
Message-ID: <ateYFjeljGXUz1g_@chamomile>
References: <20261020124925.17318-1-fw@strlen.de>
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
In-Reply-To: <20261020124925.17318-1-fw@strlen.de>

On Tue, Oct 20, 2026 at 02:49:20PM +0200, Florian Westphal wrote:
> before:
> Error: invalid state for this protocol
> add ct timeout t foo { protocol tcp; policy = { estblshed : 2 }; }
>                                                 ^^^^^^^^^
> after:
> Error: invalid state 'estblshed' for this protocol; did you mean 'established'?
> add ct timeout t foo { protocol tcp; policy = { estblshed : 2 }; }
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>

> ---
>  include/rule.h |  1 +
>  src/evaluate.c | 19 +++++++++++++++++--
>  src/rule.c     | 19 +++++++++++++++++++
>  3 files changed, 37 insertions(+), 2 deletions(-)
> 
> diff --git a/include/rule.h b/include/rule.h
> index 7b7b7eb1012d..09fd045c7385 100644
> --- a/include/rule.h
> +++ b/include/rule.h
> @@ -882,5 +882,6 @@ struct timeout_protocol {
>  
>  extern struct timeout_protocol timeout_protocol[UINT8_MAX + 1];
>  extern int timeout_str2num(uint16_t l4proto, struct timeout_state *ts);
> +extern const char *timeout_lookup_fuzzy(uint16_t l4proto, const char *name);
>  
>  #endif /* NFTABLES_RULE_H */
> diff --git a/src/evaluate.c b/src/evaluate.c
> index 01b4afbbb10d..f424b987f8f8 100644
> --- a/src/evaluate.c
> +++ b/src/evaluate.c
> @@ -5826,6 +5826,21 @@ static int ct_expect_evaluate(struct eval_ctx *ctx, struct obj *obj)
>  	return 0;
>  }
>  
> +static int timeout_not_found(struct eval_ctx *ctx, const struct location *loc,
> +			     uint16_t l4proto, const char *state_name)
> +{
> +	const char *suggestion;
> +
> +	suggestion = timeout_lookup_fuzzy(l4proto, state_name);
> +	if (suggestion == NULL)
> +		return cmd_error(ctx, loc, "invalid state '%s' for this protocol",
> +				 state_name);
> +
> +	return cmd_error(ctx, loc,
> +			 "invalid state '%s' for this protocol; did you mean '%s'?",
> +			 state_name, suggestion);
> +}
> +
>  static int ct_timeout_evaluate(struct eval_ctx *ctx, struct obj *obj)
>  {
>  	struct ct_timeout *ct = &obj->ct_timeout;
> @@ -5837,8 +5852,8 @@ static int ct_timeout_evaluate(struct eval_ctx *ctx, struct obj *obj)
>  
>  	list_for_each_entry_safe(ts, next, &ct->timeout_list, head) {
>  		if (timeout_str2num(ct->l4proto, ts) < 0)
> -			return __stmt_binary_error(ctx, &ts->location, NULL,
> -						   "invalid state for this protocol");
> +			return timeout_not_found(ctx, &ts->location,
> +						 ct->l4proto, ts->timeout_str);
>  
>  		ct->timeout[ts->timeout_index] = ts->timeout_value;
>  		list_del(&ts->head);
> diff --git a/src/rule.c b/src/rule.c
> index 552c17df05f8..d232582b6080 100644
> --- a/src/rule.c
> +++ b/src/rule.c
> @@ -89,6 +89,25 @@ struct timeout_protocol timeout_protocol[UINT8_MAX + 1] = {
>  	},
>  };
>  
> +const char *timeout_lookup_fuzzy(uint16_t l4proto, const char *name)
> +{
> +	struct string_misspell_state st;
> +	unsigned int i;
> +
> +	if (!name)
> +		return NULL;
> +
> +	string_misspell_init(&st);
> +
> +	for (i = 0; i < timeout_protocol[l4proto].array_size; i++)
> +		string_misspell_update(timeout_protocol[l4proto].state_to_name[i],
> +				       name,
> +				       (void *)timeout_protocol[l4proto].state_to_name[i],
> +				       &st);
> +
> +	return st.obj;
> +}
> +
>  int timeout_str2num(uint16_t l4proto, struct timeout_state *ts)
>  {
>  	unsigned int i;
> -- 
> 2.55.0
> 
> 
