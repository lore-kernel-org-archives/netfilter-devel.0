Return-Path: <SRS0=6+Vk=V4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD92BC32751
	for <netfilter-devel@archiver.kernel.org>; Wed, 31 Jul 2019 13:02:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9A979206B8
	for <netfilter-devel@archiver.kernel.org>; Wed, 31 Jul 2019 13:02:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729353AbfGaNCh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 31 Jul 2019 09:02:37 -0400
Received: from correo.us.es ([193.147.175.20]:50720 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729349AbfGaNCh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 31 Jul 2019 09:02:37 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 15989154E85
        for <netfilter-devel@vger.kernel.org>; Wed, 31 Jul 2019 15:02:35 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 03F1318524
        for <netfilter-devel@vger.kernel.org>; Wed, 31 Jul 2019 15:02:35 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id EDB04DA704; Wed, 31 Jul 2019 15:02:34 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E6EEDDA704;
        Wed, 31 Jul 2019 15:02:32 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 31 Jul 2019 15:02:32 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [47.60.32.83])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id A6CB64265A32;
        Wed, 31 Jul 2019 15:02:32 +0200 (CEST)
Date:   Wed, 31 Jul 2019 15:02:30 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 1/2] src: store expr, not dtype to track data in sets
Message-ID: <20190731130230.nc5fj437st7ejkne@salvia>
References: <20190730143732.2126-1-fw@strlen.de>
 <20190730143732.2126-2-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190730143732.2126-2-fw@strlen.de>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jul 30, 2019 at 04:37:31PM +0200, Florian Westphal wrote:
[...]
> diff --git a/include/rule.h b/include/rule.h
> index ee881b9ccd17..dfb6b5482a1c 100644
> --- a/include/rule.h
> +++ b/include/rule.h
> @@ -277,8 +277,7 @@ extern struct rule *rule_lookup_by_index(const struct chain *chain,
>   * @gc_int:	garbage collection interval
>   * @timeout:	default timeout value
>   * @key:	key expression (data type, length))
> - * @datatype:	mapping data type
> - * @datalen:	mapping data len
> + * @data:	mapping data expression
>   * @objtype:	mapping object type
>   * @init:	initializer
>   * @rg_cache:	cached range element (left)
> @@ -295,8 +294,7 @@ struct set {
>  	uint32_t		gc_int;
>  	uint64_t		timeout;
>  	struct expr		*key;
> -	const struct datatype	*datatype;
> -	unsigned int		datalen;
> +	struct expr		*data;
>  	uint32_t		objtype;
>  	struct expr		*init;
>  	struct expr		*rg_cache;
[...]
> diff --git a/src/evaluate.c b/src/evaluate.c
> index 48c65cd2f35a..6277f6545c1b 100644
> --- a/src/evaluate.c
> +++ b/src/evaluate.c
> @@ -1332,6 +1332,63 @@ static int expr_evaluate_set(struct eval_ctx *ctx, struct expr **expr)
>  	return 0;
>  }
>  
> +static struct expr *concat_expr_alloc_by_type_FIXME(uint32_t type)
> +{
> +	struct expr *concat_expr = concat_expr_alloc(&netlink_location);
> +	unsigned int n;
> +	int size = 0;
> +
> +	n = div_round_up(fls(type), TYPE_BITS);
> +	while (n > 0 && concat_subtype_id(type, --n)) {
> +		const struct datatype *i;
> +		struct expr *expr;
> +
> +		i = concat_subtype_lookup(type, n);
> +		if (i == NULL)
> +			return NULL;
> +
> +		if (i->size == 0)
> +			size = -1;
> +		else if (size >= 0)
> +			size += i->size;
> +
> +		expr = constant_expr_alloc(&netlink_location, i, i->byteorder,
> +					   i->size, NULL);
> +
> +		compound_expr_add(concat_expr, expr);
> +	}
> +
> +	/* can be incorrect in case of i->size being 0 (variable length). */
> +	concat_expr->len = size > 0 ? size : 0;
> +
> +	return concat_expr;
> +}
> +
> +static struct expr *
> +data_expr_alloc_by_type_FIXME(enum nft_data_types type, enum byteorder keybyteorder)

There is no support for concatenations from the right hand side of the
mapping, so I would just calloc a constant expression itself. Hence,
you wont' need concat_expr_alloc_by_type_FIXME() and this function
will be more simple. Same comment applies to dtype_map_from_kernel().

In general, I agree in the direction where this is going, that is,
turn the datatype field in the set object into an expression.

Thanks.
