Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 269DBC83F12
	for <netfilter-devel@archiver.kernel.org>; Mon, 28 Aug 2023 15:14:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230009AbjH1PNv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 28 Aug 2023 11:13:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232463AbjH1PNl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 28 Aug 2023 11:13:41 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FDE7CE
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Aug 2023 08:13:38 -0700 (PDT)
Received: from [78.30.34.192] (port=39402 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qadvp-00ALTW-St; Mon, 28 Aug 2023 17:13:36 +0200
Date:   Mon, 28 Aug 2023 17:13:33 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Thomas Haller <thaller@redhat.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft 5/8] src: rework SNPRINTF_BUFFER_SIZE() and avoid
 "-Wunused-but-set-variable"
Message-ID: <ZOy5nTEQJvu7zdrx@calendula>
References: <20230828144441.3303222-1-thaller@redhat.com>
 <20230828144441.3303222-6-thaller@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230828144441.3303222-6-thaller@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Aug 28, 2023 at 04:43:55PM +0200, Thomas Haller wrote:
> SNPRINTF_BUFFER_SIZE() causes a warning with clang.
> 
>     evaluate.c:4134:9: error: variable 'size' set but not used [-Werror,-Wunused-but-set-variable]
>             size_t size = 0;
>                    ^
> 
>     meta.c:1006:9: error: variable 'size' set but not used [-Werror,-Wunused-but-set-variable]
>             size_t size;
>                    ^
> 
> Fix that, and rework SNPRINTF_BUFFER_SIZE().
> 
> - before and now, the macro asserts against truncation. Remove error
>   handling related to truncation in the callers.
> 
> - wrap the macro in "do { ... } while(0)" to make it more
>   function-like.
> 
> - evaluate macro arguments exactly once, to make it more function-like.
> 
> - take pointers to the arguments that are being modified.
> 
> - use assert() instead of abort().
> 
> - use size_t type for arguments related to the buffer size.
> 
> - drop "size". It was unused, and, unless the string was truncated,
>   it was identical to "offset".
> 
> - "offset" previously was incremented before checking for truncation.
>   So it would point somewhere past the buffer. This behavior is not
>   useful, because we assert against truncation. Now, in case of
>   truncation, "len" will be zero and "offset" will be the original "len"
>   (that is, point after the buffer and one byte after the terminating NUL).
> 
> Signed-off-by: Thomas Haller <thaller@redhat.com>
> ---
>  include/utils.h | 32 +++++++++++++++++++++++---------
>  src/evaluate.c  | 11 +++++------
>  src/meta.c      | 10 +++++-----
>  3 files changed, 33 insertions(+), 20 deletions(-)
> 
> diff --git a/include/utils.h b/include/utils.h
> index cee1e5c1e8ae..873147fb54ec 100644
> --- a/include/utils.h
> +++ b/include/utils.h
> @@ -72,15 +72,29 @@
>  #define max(_x, _y) ({				\
>  	_x > _y ? _x : _y; })
>  
> -#define SNPRINTF_BUFFER_SIZE(ret, size, len, offset)	\
> -	if (ret < 0)					\
> -		abort();				\
> -	offset += ret;					\
> -	assert(ret < len);				\
> -	if (ret > len)					\
> -		ret = len;				\
> -	size += ret;					\
> -	len -= ret;
> +#define SNPRINTF_BUFFER_SIZE(ret, len, offset)			\
> +	do { \
> +		const int _ret = (ret);				\
> +		size_t *const _len = (len);			\
> +		size_t *const _offset = (offset);		\
> +		size_t _ret2;					\
> +								\
> +		assert(_ret >= 0);				\
> +								\
> +		if ((size_t) _ret >= *_len) {			\
> +			/* Fail an assertion on truncation.
> +			 *
> +			 * Anyway, we would set "len" to zero and "offset" one
> +			 * after the buffer size (past the terminating NUL
> +			 * byte). */				\
> +			assert((size_t) _ret < *_len);		\
> +			_ret2 = *_len;				\
> +		} else						\
> +			_ret2 = (size_t) _ret;			\
> +								\
> +		*_offset += _ret2;				\
> +		*_len -= _ret2;					\
> +	} while (0)

This macro is something I made myself, which I am particularly not
proud of it, but it getting slightly more complicated.

Probably it time to turn this into a real function?

>  #define MSEC_PER_SEC	1000L
>  
> diff --git a/src/evaluate.c b/src/evaluate.c
> index 1ae2ef0de10c..f8cd7b7afda3 100644
> --- a/src/evaluate.c
> +++ b/src/evaluate.c
> @@ -4129,14 +4129,16 @@ static int stmt_evaluate_queue(struct eval_ctx *ctx, struct stmt *stmt)
>  static int stmt_evaluate_log_prefix(struct eval_ctx *ctx, struct stmt *stmt)
>  {
>  	char prefix[NF_LOG_PREFIXLEN] = {}, tmp[NF_LOG_PREFIXLEN] = {};
> -	int len = sizeof(prefix), offset = 0, ret;
> +	size_t len = sizeof(prefix);
> +	size_t offset = 0;
>  	struct expr *expr;
> -	size_t size = 0;
>  
>  	if (stmt->log.prefix->etype != EXPR_LIST)
>  		return 0;
>  
>  	list_for_each_entry(expr, &stmt->log.prefix->expressions, list) {
> +		int ret;
> +
>  		switch (expr->etype) {
>  		case EXPR_VALUE:
>  			expr_to_string(expr, tmp);
> @@ -4150,12 +4152,9 @@ static int stmt_evaluate_log_prefix(struct eval_ctx *ctx, struct stmt *stmt)
>  			BUG("unknown expression type %s\n", expr_name(expr));
>  			break;
>  		}
> -		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
> +		SNPRINTF_BUFFER_SIZE(ret, &len, &offset);
>  	}
>  
> -	if (len == NF_LOG_PREFIXLEN)
> -		return stmt_error(ctx, stmt, "log prefix is too long");

No error anymore?

Not directly related, but are you sure tests we have are sufficient to
cover for all these updates?

> -
>  	expr = constant_expr_alloc(&stmt->log.prefix->location, &string_type,
>  				   BYTEORDER_HOST_ENDIAN,
>  				   strlen(prefix) * BITS_PER_BYTE, prefix);
> diff --git a/src/meta.c b/src/meta.c
> index 4f383269d032..6dada9719e5b 100644
> --- a/src/meta.c
> +++ b/src/meta.c
> @@ -999,11 +999,11 @@ struct error_record *meta_key_parse(const struct location *loc,
>                                      const char *str,
>                                      unsigned int *value)
>  {
> -	int ret, len, offset = 0;
>  	const char *sep = "";
> +	size_t offset = 0;
>  	unsigned int i;
>  	char buf[1024];
> -	size_t size;
> +	size_t len;
>  
>  	for (i = 0; i < array_size(meta_templates); i++) {
>  		if (!meta_templates[i].token || strcmp(meta_templates[i].token, str))
> @@ -1026,9 +1026,10 @@ struct error_record *meta_key_parse(const struct location *loc,
>  	}
>  
>  	len = (int)sizeof(buf);
> -	size = sizeof(buf);
>  
>  	for (i = 0; i < array_size(meta_templates); i++) {
> +		int ret;
> +
>  		if (!meta_templates[i].token)
>  			continue;
>  
> @@ -1036,8 +1037,7 @@ struct error_record *meta_key_parse(const struct location *loc,
>  			sep = ", ";
>  
>  		ret = snprintf(buf+offset, len, "%s%s", sep, meta_templates[i].token);
> -		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
> -		assert(offset < (int)sizeof(buf));
> +		SNPRINTF_BUFFER_SIZE(ret, &len, &offset);
>  	}
>  
>  	return error(loc, "syntax error, unexpected %s, known keys are %s", str, buf);
> -- 
> 2.41.0
> 
