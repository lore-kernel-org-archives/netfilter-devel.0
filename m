Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B012DC05052
	for <netfilter-devel@archiver.kernel.org>; Fri, 18 Aug 2023 09:59:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359473AbjHRJ7C (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 18 Aug 2023 05:59:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359521AbjHRJ6j (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 18 Aug 2023 05:58:39 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96F4E420B
        for <netfilter-devel@vger.kernel.org>; Fri, 18 Aug 2023 02:58:18 -0700 (PDT)
Received: from [78.30.34.192] (port=59868 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qWwEo-000MrY-4n; Fri, 18 Aug 2023 11:57:53 +0200
Date:   Fri, 18 Aug 2023 11:57:49 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Thomas Haller <thaller@redhat.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [nft PATCH v2] src: use reentrant
 getprotobyname_r()/getprotobynumber_r()/getservbyport_r()
Message-ID: <ZN9AnetYNCRBODhb@calendula>
References: <20230810123035.3866306-1-thaller@redhat.com>
 <20230818091926.526246-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230818091926.526246-1-thaller@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Tomas,

A few pedantic comments of mine.

On Fri, Aug 18, 2023 at 11:18:26AM +0200, Thomas Haller wrote:
> If the reentrant versions of the functions are available, use them so
> that libnftables is thread-safe in this regard.
> 
> Signed-off-by: Thomas Haller <thaller@redhat.com>
> ---
> Changes to v1:
> 
> - have nft_getprotobyname() return a negative integer on error or the
>   non-negative port number.
> 
>  configure.ac    |  4 +++
>  include/utils.h |  4 +++
>  src/datatype.c  | 32 +++++++++---------
>  src/json.c      | 21 ++++++------
>  src/rule.c      |  6 ++--
>  src/utils.c     | 88 +++++++++++++++++++++++++++++++++++++++++++++++++
>  6 files changed, 125 insertions(+), 30 deletions(-)
> 
> diff --git a/configure.ac b/configure.ac
> index b0201ac3528e..42f0dc4cf392 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -108,6 +108,10 @@ AC_DEFINE([HAVE_LIBJANSSON], [1], [Define if you have libjansson])
>  ])
>  AM_CONDITIONAL([BUILD_JSON], [test "x$with_json" != xno])
>  
> +AC_CHECK_DECLS([getprotobyname_r, getprotobynumber_r, getservbyport_r], [], [], [[
> +#include <netdb.h>
> +]])
> +
>  AC_CONFIG_FILES([					\
>  		Makefile				\
>  		libnftables.pc				\
> diff --git a/include/utils.h b/include/utils.h
> index d5073e061033..80d57dae87cb 100644
> --- a/include/utils.h
> +++ b/include/utils.h
> @@ -138,4 +138,8 @@ extern char *xstrdup(const char *s);
>  extern void xstrunescape(const char *in, char *out);
>  extern int round_pow_2(unsigned int value);
>  
> +bool nft_getprotobynumber(int number, char *out_name, size_t name_len);
> +int nft_getprotobyname(const char *name);
> +bool nft_getservbyport(int port, const char *proto, char *out_name, size_t name_len);
> +
>  #endif /* NFTABLES_UTILS_H */
> diff --git a/src/datatype.c b/src/datatype.c
> index da802a18bccd..02d5c3ebf9b7 100644
> --- a/src/datatype.c
> +++ b/src/datatype.c
> @@ -697,12 +697,11 @@ const struct datatype ip6addr_type = {
>  static void inet_protocol_type_print(const struct expr *expr,
>  				      struct output_ctx *octx)
>  {
> -	struct protoent *p;
> -
>  	if (!nft_output_numeric_proto(octx)) {
> -		p = getprotobynumber(mpz_get_uint8(expr->value));
> -		if (p != NULL) {
> -			nft_print(octx, "%s", p->p_name);
> +		char name[1024];

Is there any definition that could be used instead of 1024. Same
comment for all other hardcoded buffers. Or maybe add a definition for
this?

> +
> +		if (nft_getprotobynumber(mpz_get_uint8(expr->value), name, sizeof(name))) {
> +			nft_print(octx, "%s", name);
>  			return;
>  		}
>  	}
> @@ -711,15 +710,15 @@ static void inet_protocol_type_print(const struct expr *expr,
>  
>  static void inet_protocol_type_describe(struct output_ctx *octx)
>  {
> -	struct protoent *p;
>  	uint8_t protonum;
>  
>  	for (protonum = 0; protonum < UINT8_MAX; protonum++) {
> -		p = getprotobynumber(protonum);
> -		if (!p)
> +		char name[1024];
> +
> +		if (!nft_getprotobynumber(protonum, name, sizeof(name)))
>  			continue;
>  
> -		nft_print(octx, "\t%-30s\t%u\n", p->p_name, protonum);
> +		nft_print(octx, "\t%-30s\t%u\n", name, protonum);
>  	}
>  }
>  
> @@ -727,7 +726,6 @@ static struct error_record *inet_protocol_type_parse(struct parse_ctx *ctx,
>  						     const struct expr *sym,
>  						     struct expr **res)
>  {
> -	struct protoent *p;
>  	uint8_t proto;
>  	uintmax_t i;
>  	char *end;
> @@ -740,11 +738,13 @@ static struct error_record *inet_protocol_type_parse(struct parse_ctx *ctx,
>  
>  		proto = i;
>  	} else {
> -		p = getprotobyname(sym->identifier);
> -		if (p == NULL)
> +		int r;
> +
> +		r = nft_getprotobyname(sym->identifier);
> +		if (r < 0)
>  			return error(&sym->location, "Could not resolve protocol name");
>  
> -		proto = p->p_proto;
> +		proto = r;
>  	}
>  
>  	*res = constant_expr_alloc(&sym->location, &inet_protocol_type,
> @@ -768,12 +768,12 @@ const struct datatype inet_protocol_type = {
>  static void inet_service_print(const struct expr *expr, struct output_ctx *octx)
>  {
>  	uint16_t port = mpz_get_be16(expr->value);
> -	const struct servent *s = getservbyport(port, NULL);
> +	char name[1024];
>
> -	if (s == NULL)
> +	if (!nft_getservbyport(port, NULL, name, sizeof(name)))
>  		nft_print(octx, "%hu", ntohs(port));
>  	else
> -		nft_print(octx, "\"%s\"", s->s_name);
> +		nft_print(octx, "\"%s\"", name);
>  }
>  
>  void inet_service_type_print(const struct expr *expr, struct output_ctx *octx)
> diff --git a/src/json.c b/src/json.c
> index a119dfc4f1eb..969b44e3004a 100644
> --- a/src/json.c
> +++ b/src/json.c
> @@ -297,10 +297,10 @@ static json_t *chain_print_json(const struct chain *chain)
>  
>  static json_t *proto_name_json(uint8_t proto)
>  {
> -	const struct protoent *p = getprotobynumber(proto);
> +	char name[1024];
>  
> -	if (p)
> -		return json_string(p->p_name);
> +	if (nft_getprotobynumber(proto, name, sizeof(name)))
> +		return json_string(name);
>  	return json_integer(proto);
>  }
>  
> @@ -1093,12 +1093,11 @@ json_t *boolean_type_json(const struct expr *expr, struct output_ctx *octx)
>  json_t *inet_protocol_type_json(const struct expr *expr,
>  				struct output_ctx *octx)
>  {
> -	struct protoent *p;
> -
>  	if (!nft_output_numeric_proto(octx)) {
> -		p = getprotobynumber(mpz_get_uint8(expr->value));
> -		if (p != NULL)
> -			return json_string(p->p_name);
> +		char name[1024];
> +
> +		if (nft_getprotobynumber(mpz_get_uint8(expr->value), name, sizeof(name)))
> +			return json_string(name);
>  	}
>  	return integer_type_json(expr, octx);
>  }
> @@ -1106,13 +1105,13 @@ json_t *inet_protocol_type_json(const struct expr *expr,
>  json_t *inet_service_type_json(const struct expr *expr, struct output_ctx *octx)
>  {
>  	uint16_t port = mpz_get_be16(expr->value);
> -	const struct servent *s = NULL;
> +	char name[1024];
>  
>  	if (!nft_output_service(octx) ||
> -	    (s = getservbyport(port, NULL)) == NULL)
> +	    !nft_getservbyport(port, NULL, name, sizeof(name)))
>  		return json_integer(ntohs(port));
>  
> -	return json_string(s->s_name);
> +	return json_string(name);
>  }
>  
>  json_t *mark_type_json(const struct expr *expr, struct output_ctx *octx)
> diff --git a/src/rule.c b/src/rule.c
> index 99c4f0bb8b00..c32c7303a28e 100644
> --- a/src/rule.c
> +++ b/src/rule.c
> @@ -1666,10 +1666,10 @@ struct obj *obj_lookup_fuzzy(const char *obj_name,
>  
>  static void print_proto_name_proto(uint8_t l4, struct output_ctx *octx)
>  {
> -	const struct protoent *p = getprotobynumber(l4);
> +	char name[1024];
>  
> -	if (p)
> -		nft_print(octx, "%s", p->p_name);
> +	if (nft_getprotobynumber(l4, name, sizeof(name)))
> +		nft_print(octx, "%s", name);
>  	else
>  		nft_print(octx, "%d", l4);
>  }
> diff --git a/src/utils.c b/src/utils.c
> index a5815018c775..5ab7be8fb323 100644
> --- a/src/utils.c
> +++ b/src/utils.c
> @@ -14,6 +14,7 @@
>  #include <stdio.h>
>  #include <unistd.h>
>  #include <string.h>
> +#include <netdb.h>
>  
>  #include <nftables.h>
>  #include <utils.h>
> @@ -105,3 +106,90 @@ int round_pow_2(unsigned int n)
>  {
>  	return 1UL << fls(n - 1);
>  }
> +

Could you move this new code to a new file instead of utils.c? We are
slowing moving towards GPLv2 or any later for new code. Probably
netdb.c or pick a better name that you like.

> +bool nft_getprotobynumber(int proto, char *out_name, size_t name_len)
> +{
> +	const struct protoent *result;
> +
> +#if HAVE_DECL_GETPROTOBYNUMBER_R
> +	struct protoent result_buf;
> +	char buf[2048];
> +	int r;
> +
> +	r = getprotobynumber_r(proto,
> +	                       &result_buf,
> +	                       buf,
> +	                       sizeof(buf),
> +	                       (struct protoent **) &result);
> +	if (r != 0 || result != &result_buf)
> +		result = NULL;
> +#else
> +	result = getprotobynumber(proto);
> +#endif

I'd suggest wrap this code with #ifdef's in a helper function.

> +
> +	if (!result)
> +		return false;
> +
> +	if (strlen(result->p_name) >= name_len)
> +		return false;
> +	strcpy(out_name, result->p_name);
> +	return true;
> +}
> +
> +int nft_getprotobyname(const char *name)
> +{
> +	const struct protoent *result;
> +
> +#if HAVE_DECL_GETPROTOBYNAME_R
> +	struct protoent result_buf;
> +	char buf[2048];
> +	int r;
> +
> +	r = getprotobyname_r(name,
> +	                     &result_buf,
> +	                     buf,
> +	                     sizeof(buf),
> +	                     (struct protoent **) &result);
> +	if (r != 0 || result != &result_buf)
> +		result = NULL;
> +#else
> +	result = getprotobyname(name);
> +#endif

same here.

> +
> +	if (!result)
> +		return -1;
> +
> +	if (result->p_proto < 0 || result->p_proto > UINT8_MAX)
> +		return -1;
> +	return (uint8_t) result->p_proto;
> +}
> +
> +bool nft_getservbyport(int port, const char *proto, char *out_name, size_t name_len)
> +{
> +	const struct servent *result;
> +
> +#if HAVE_DECL_GETSERVBYPORT_R
> +	struct servent result_buf;
> +	char buf[2048];
> +	int r;
> +
> +	r = getservbyport_r(port,
> +	                    proto,
> +	                    &result_buf,
> +	                    buf,
> +	                    sizeof(buf),
> +	                    (struct servent**) &result);
> +	if (r != 0 || result != &result_buf)
> +		result = NULL;
> +#else
> +	result = getservbyport(port, proto);
> +#endif

same here.

> +
> +	if (!result)
> +		return false;
> +
> +	if (strlen(result->s_name) >= name_len)
> +		return false;
> +	strcpy(out_name, result->s_name);
> +	return true;
> +}
> -- 
> 2.41.0
> 
