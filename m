Return-Path: <SRS0=/ozj=TY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6BF3C072B5
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 May 2019 19:04:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C73A22184E
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 May 2019 19:04:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391181AbfEXTEo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 24 May 2019 15:04:44 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:56329 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727115AbfEXTEo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 24 May 2019 15:04:44 -0400
X-Greylist: delayed 1456 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 May 2019 15:04:43 EDT
Received: from [31.4.219.201] (helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.84_2)
        (envelope-from <pablo@gnumonks.org>)
        id 1hUF7A-0000nb-HC; Fri, 24 May 2019 20:40:26 +0200
Date:   Fri, 24 May 2019 20:40:22 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     Eric Garver <e@erig.me>, netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 3/3] src: Support intra-transaction rule references
Message-ID: <20190524183934.uzqg6ps5kw36ucxp@salvia>
References: <20190522153035.19806-1-phil@nwl.cc>
 <20190522153035.19806-4-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190522153035.19806-4-phil@nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

One comment see below.

On Wed, May 22, 2019 at 05:30:35PM +0200, Phil Sutter wrote:
> @@ -3237,10 +3222,62 @@ static int rule_evaluate(struct eval_ctx *ctx, struct rule *rule)
>  		return -1;
>  	}
>  
> -	if (rule->handle.index.id &&
> -	    rule_translate_index(ctx, rule))
> -		return -1;
> +	table = table_lookup(&rule->handle, &ctx->nft->cache);
> +	if (!table)
> +		return table_not_found(ctx);
> +
> +	chain = chain_lookup(table, &rule->handle);
> +	if (!chain)
> +		return chain_not_found(ctx);
>  
> +	if (rule->handle.index.id) {
> +		ref = rule_lookup_by_index(chain, rule->handle.index.id);
> +		if (!ref)
> +			return cmd_error(ctx, &rule->handle.index.location,
> +					 "Could not process rule: %s",
> +					 strerror(ENOENT));
> +
> +		link_rules(rule, ref);
> +	} else if (rule->handle.handle.id) {
> +		ref = rule_lookup(chain, rule->handle.handle.id);
> +		if (!ref)
> +			return cmd_error(ctx, &rule->handle.handle.location,
> +					 "Could not process rule: %s",
> +					 strerror(ENOENT));
> +	} else if (rule->handle.position.id) {
> +		ref = rule_lookup(chain, rule->handle.position.id);
> +		if (!ref)
> +			return cmd_error(ctx, &rule->handle.position.location,
> +					 "Could not process rule: %s",
> +					 strerror(ENOENT));
> +	}
> +

Nitpick: Probably move this code below into a function, something
like rule_cache_update().

> +	switch (op) {
> +	case CMD_INSERT:
> +		rule_get(rule);
> +		if (ref)
> +			list_add_tail(&rule->list, &ref->list);
> +		else
> +			list_add(&rule->list, &chain->rules);
> +		break;
> +	case CMD_ADD:
> +		rule_get(rule);
> +		if (ref)
> +			list_add(&rule->list, &ref->list);
> +		else
> +			list_add_tail(&rule->list, &chain->rules);
> +		break;
> +	case CMD_REPLACE:
> +		rule_get(rule);
> +		list_add(&rule->list, &ref->list);
> +		/* fall through */
> +	case CMD_DELETE:
> +		list_del(&ref->list);
> +		rule_free(ref);
> +		break;
> +	default:
> +		break;
> +	}
>  	return 0;
>  }

Not related to this patch, but now that we have the cache completeness
logic, I think we need a flag to specify that cache has been modified.

If that is a problem, I can just apply this patch and we fix that
use-case I'm refering to later on.
