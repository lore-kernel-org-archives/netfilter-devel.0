Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52C9FC83F15
	for <netfilter-devel@archiver.kernel.org>; Mon, 28 Aug 2023 15:03:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbjH1PCj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 28 Aug 2023 11:02:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232398AbjH1PC0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 28 Aug 2023 11:02:26 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8A02BF
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Aug 2023 08:02:23 -0700 (PDT)
Received: from [78.30.34.192] (port=39330 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qadkx-00AHh2-58; Mon, 28 Aug 2023 17:02:21 +0200
Date:   Mon, 28 Aug 2023 17:02:18 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Thomas Haller <thaller@redhat.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft 3/4] src: cache result of time() during parsing/output
Message-ID: <ZOy2+ln2nMnveET2@calendula>
References: <20230825132942.2733840-1-thaller@redhat.com>
 <20230825132942.2733840-4-thaller@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230825132942.2733840-4-thaller@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Aug 25, 2023 at 03:24:19PM +0200, Thomas Haller wrote:
> When we parse/output a larger set of data, we should only call time()
> once. With every call of time(), the value keeps ticking (and is subject
> to time reset). Previously, one parse/output operation will make
> decisions on potentially different timestamps.
> 
> Add a cache to the parse/output context, and only fetch time() once
> per operation.
> 
> Signed-off-by: Thomas Haller <thaller@redhat.com>
> ---
>  include/datatype.h |  6 ++++++
>  src/datatype.c     | 16 ++++++++++++++++
>  src/meta.c         |  4 ++--
>  3 files changed, 24 insertions(+), 2 deletions(-)
> 
> diff --git a/include/datatype.h b/include/datatype.h
> index 79d996edd348..abd093765703 100644
> --- a/include/datatype.h
> +++ b/include/datatype.h
> @@ -2,6 +2,7 @@
>  #define NFTABLES_DATATYPE_H
>  
>  #include <json.h>
> +#include <time.h>
>  
>  /**
>   * enum datatypes
> @@ -121,12 +122,17 @@ enum byteorder {
>  struct expr;
>  
>  struct ops_cache {
> +	time_t		time;
> +	bool		has_time;
>  };
>  
>  #define CTX_CACHE_INIT() \
>  	{ \
> +		.has_time = false, \
>  	}
>  
> +extern time_t ops_cache_get_time(struct ops_cache *cache);
> +
>  /**
>   * enum datatype_flags
>   *
> diff --git a/src/datatype.c b/src/datatype.c
> index dd6a5fbf5df8..933d832c4f4d 100644
> --- a/src/datatype.c
> +++ b/src/datatype.c
> @@ -35,6 +35,22 @@
>  
>  #include <netinet/ip_icmp.h>
>  
> +time_t ops_cache_get_time(struct ops_cache *cache)
> +{
> +	time_t t;
> +
> +	if (!cache || !cache->has_time) {
> +		t = time(NULL);
> +		if (cache) {
> +			cache->has_time = true;
> +			cache->time = time(NULL);
> +		}
> +	} else
> +		t = cache->time;
> +
> +	return t;
> +}
> +
>  static const struct datatype *datatypes[TYPE_MAX + 1] = {
>  	[TYPE_INVALID]		= &invalid_type,
>  	[TYPE_VERDICT]		= &verdict_type,
> diff --git a/src/meta.c b/src/meta.c
> index 4f383269d032..1d853b219fe6 100644
> --- a/src/meta.c
> +++ b/src/meta.c
> @@ -496,7 +496,7 @@ static void hour_type_print(const struct expr *expr, struct output_ctx *octx)
>  	time_t ts;
>  
>  	/* Obtain current tm, so that we can add tm_gmtoff */
> -	ts = time(NULL);
> +	ts = ops_cache_get_time(octx->ops_cache);

Following the idea of adding a specific time cache, I'd suggest:

        ts = nft_time_get(...);

or similar.

>  	if (ts != ((time_t) -1) && localtime_r(&ts, &cur_tm))
>  		seconds = (seconds + cur_tm.tm_gmtoff) % SECONDS_PER_DAY;
>  
> @@ -534,7 +534,7 @@ static struct error_record *hour_type_parse(struct parse_ctx *ctx,
>  	result = 0;
>  
>  	/* Obtain current tm, so that we can substract tm_gmtoff */
> -	ts = time(NULL);
> +	ts = ops_cache_get_time(ctx->ops_cache);
>  	if (ts != ((time_t) -1) && localtime_r(&ts, &cur_tm_data))
>  		cur_tm = &cur_tm_data;
>  	else
> -- 
> 2.41.0
> 
