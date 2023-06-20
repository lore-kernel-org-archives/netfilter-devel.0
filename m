Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A7F4EB64D7
	for <netfilter-devel@archiver.kernel.org>; Tue, 20 Jun 2023 16:02:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232057AbjFTQCo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 20 Jun 2023 12:02:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229896AbjFTQCn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 20 Jun 2023 12:02:43 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6C66D188
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Jun 2023 09:02:41 -0700 (PDT)
Date:   Tue, 20 Jun 2023 18:02:36 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 4/6] parser: reject zero-length interface names
Message-ID: <ZJHNnJVsLZL3AmH3@calendula>
References: <20230619204306.11785-1-fw@strlen.de>
 <20230619204306.11785-5-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230619204306.11785-5-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Jun 19, 2023 at 10:43:04PM +0200, Florian Westphal wrote:
> device "" results in an assertion during evaluation.
> Before:
> nft: expression.c:426: constant_expr_alloc: Assertion `(((len) + (8) - 1) / (8)) > 0' failed.
> After:
> zero_length_devicename_assert:3:42-49: Error: you cannot set an empty interface name
> type filter hook ingress device""lo" priority -1
>                          ^^^^^^^^
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  src/parser_bison.y                            | 36 ++++++++++++++++---
>  .../nft-f/zero_length_devicename_assert       |  5 +++
>  2 files changed, 36 insertions(+), 5 deletions(-)
>  create mode 100644 tests/shell/testcases/bogons/nft-f/zero_length_devicename_assert
> 
> diff --git a/src/parser_bison.y b/src/parser_bison.y
> index f5f6bf04d064..d5a2f85387cb 100644
> --- a/src/parser_bison.y
> +++ b/src/parser_bison.y
> @@ -144,6 +144,33 @@ static bool already_set(const void *attr, const struct location *loc,
>  	return true;
>  }
>  
> +static struct expr* ifname_expr_alloc(const struct location *location,

Nitpick:

static struct expr *ifname_expr_alloc(const struct location *location,
                   ^

> +				      struct list_head *queue,
> +				      const char *name)
> +{
> +	unsigned int length = strlen(name);
> +	struct expr *expr;
> +
> +	if (length == 0) {
> +		xfree(name);
> +		erec_queue(error(location, "empty interface name"), queue);
> +		return NULL;
> +	}
> +
> +	if (length > 16) {

                     IFNAMSIZ instead of 16?

> +		xfree(name);
> +		erec_queue(error(location, "interface name too long"), queue);
> +		return NULL;
> +	}
> +
> +	expr = constant_expr_alloc(location, &ifname_type, BYTEORDER_HOST_ENDIAN,
> +				   length * BITS_PER_BYTE, name);
> +
> +	xfree(name);
> +
> +	return expr;
> +}
> +
>  #define YYLLOC_DEFAULT(Current, Rhs, N)	location_update(&Current, Rhs, N)
>  
>  #define symbol_value(loc, str) \
> @@ -2664,12 +2691,11 @@ int_num			:	NUM			{ $$ = $1; }
>  
>  dev_spec		:	DEVICE	string
>  			{
> -				struct expr *expr;
> +				struct expr *expr = ifname_expr_alloc(&@$, state->msgs, $2);
> +
> +				if (!expr)
> +					YYERROR;
>  
> -				expr = constant_expr_alloc(&@$, &string_type,
> -							   BYTEORDER_HOST_ENDIAN,
> -							   strlen($2) * BITS_PER_BYTE, $2);
> -				xfree($2);
>  				$$ = compound_expr_alloc(&@$, EXPR_LIST);
>  				compound_expr_add($$, expr);
>  
> diff --git a/tests/shell/testcases/bogons/nft-f/zero_length_devicename_assert b/tests/shell/testcases/bogons/nft-f/zero_length_devicename_assert
> new file mode 100644
> index 000000000000..84f330730fce
> --- /dev/null
> +++ b/tests/shell/testcases/bogons/nft-f/zero_length_devicename_assert
> @@ -0,0 +1,5 @@
> +table ip x {
> +        chain Main_Ingress1 {
> +                type filter hook ingress device""lo" priority -1
> +	}
> +}
> -- 
> 2.39.3
> 
