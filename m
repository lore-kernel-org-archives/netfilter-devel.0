Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCFEA2EF646
	for <netfilter-devel@vger.kernel.org>; Mon, 20 Oct 2025 22:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760998090; cv=none; b=U5nkk88lihWyamt5hufNQ2XHJ9CUnPdzzk1rta//U1nabvzl9dpDJjfPyIn0VAHnSwbohEbZTYCmD/QK2p+3IRnCFkEw9WFIfB9hpWgO5IzEgpH1oPvzwzNlA+UDGfUxHmk/FvXf7shUXVzU/7PIB8WaTMiBnrYXzaKnIjYpIMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760998090; c=relaxed/simple;
	bh=wR8FiwZSsJ5rZcM7Y1B29utirIsxuJhqwC8r6MPJWM0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d4GXg1OyKSzpkPNGtir9zkH7c9RILrvPQGfxOQyiU3tUdN0sjuquFD1yjZrYM7dhLCjvMJMVvdz+6O3aJVnjUb41FpcQqmY/juwg28VohD62UrW3KPDPzlkRWqpJJUQRjiTNk4z1Cai8le97lc20lpzIWBmM6D3d6tKDm73FDFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=BMle+Nf6; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="BMle+Nf6"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 78E22602A6;
	Tue, 21 Oct 2025 00:08:04 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1760998084;
	bh=Y9Tuoqe0fOQu0MsjbFF4/MwRDL+UBJo8+tsmb27mBUQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BMle+Nf6zXGQUP31VqTrMrOlCS0c6qVNWuzFrfWIrc4181yWjecYnmE3n4UH88AZh
	 b9L4wVlQdTzYoFybma3s5XthP+nv3L/irqvndABMK3wsMVEBWVMah80evUXuHjc7oG
	 +KRedDDt58JxmAczqwz1Bpm71jZTxADVAz24ftOZSs2LYOB/bkc9qnCc5F/V4gPTGS
	 gKEy/gY49IHE3LmkBWxauT+9nGzdPwums/VCivKCmXYQUFbK9OwpxdR1cbo+ZTaxsg
	 hCW5PLjUtaFB0fYKgjdbhc3+znCdBaeHK8lIMyDqsIMsLOkW0SNRD6Wi77ycqaJ1C9
	 S7grqFI3DiLHw==
Date: Tue, 21 Oct 2025 00:08:01 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v2 nft] src: add and use refcount assert helper
Message-ID: <aPaywVyKhzUuj8Mn@calendula>
References: <20251020072937.1938-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20251020072937.1938-1-fw@strlen.de>

On Mon, Oct 20, 2025 at 09:29:34AM +0200, Florian Westphal wrote:
> _get() functions must not be used when refcnt is 0, as expr_free() releases
> expressions on 1 -> 0 transition.
> 
> Also, check that a refcount would not overflow from UINT_MAX to 0.
> Use INT_MAX to also catch refcount leaks sooner, we don't expect 2**31
> get()s on same object.
> 
> This helps catching use-after-free refcounting bugs even when nft is built
> without ASAN support.
> 
> v2: Use a generic helper instead of open-coding.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  include/rule.h   |  2 +-
>  include/utils.h  |  7 +++++++
>  src/expression.c |  5 +++++
>  src/rule.c       | 14 ++++++++++++++
>  4 files changed, 27 insertions(+), 1 deletion(-)
> 
> diff --git a/include/rule.h b/include/rule.h
> index 8d2f29d09337..bcdc50cad59d 100644
> --- a/include/rule.h
> +++ b/include/rule.h
> @@ -115,7 +115,7 @@ struct symbol {
>  	struct list_head	list;
>  	const char		*identifier;
>  	struct expr		*expr;
> -	int			refcnt;
> +	unsigned int		refcnt;
>  };
>  
>  extern void symbol_bind(struct scope *scope, const char *identifier,
> diff --git a/include/utils.h b/include/utils.h
> index 474c7595f7cd..3594ce6edf32 100644
> --- a/include/utils.h
> +++ b/include/utils.h
> @@ -6,6 +6,7 @@
>  #include <stdio.h>
>  #include <unistd.h>
>  #include <assert.h>
> +#include <limits.h>
>  #include <list.h>
>  #include <gmputil.h>
>  
> @@ -39,6 +40,12 @@
>  #define __must_be_array(a) \
>  	BUILD_BUG_ON_ZERO(__builtin_types_compatible_p(typeof(a), typeof(&a[0])))
>  
> +static inline void assert_refcount_safe(unsigned int ref)
> +{
> +	assert(ref > 0);
> +	assert(ref < INT_MAX);

Will this point to the right file and line when the assertion is hit?
IIRC we have to use a macro here?

> +}
> +
>  #define container_of(ptr, type, member) ({			\
>  	typeof( ((type *)0)->member ) *__mptr = (ptr);		\
>  	(type *)( (void *)__mptr - offsetof(type,member) );})
> diff --git a/src/expression.c b/src/expression.c
> index 019c263f187b..6c7bebe0a3d1 100644
> --- a/src/expression.c
> +++ b/src/expression.c
> @@ -68,6 +68,7 @@ struct expr *expr_clone(const struct expr *expr)
>  
>  struct expr *expr_get(struct expr *expr)
>  {
> +	assert_refcount_safe(expr->refcnt);
>  	expr->refcnt++;
>  	return expr;
>  }
> @@ -84,6 +85,8 @@ void expr_free(struct expr *expr)
>  {
>  	if (expr == NULL)
>  		return;
> +
> +	assert_refcount_safe(expr->refcnt);
>  	if (--expr->refcnt > 0)
>  		return;
>  
> @@ -343,11 +346,13 @@ static void variable_expr_clone(struct expr *new, const struct expr *expr)
>  	new->scope      = expr->scope;
>  	new->sym	= expr->sym;
>  
> +	assert_refcount_safe(expr->sym->refcnt);
>  	expr->sym->refcnt++;
>  }
>  
>  static void variable_expr_destroy(struct expr *expr)
>  {
> +	assert_refcount_safe(expr->sym->refcnt);
>  	expr->sym->refcnt--;
>  }
>  
> diff --git a/src/rule.c b/src/rule.c
> index d0a62a3ee002..f51d605cc1ad 100644
> --- a/src/rule.c
> +++ b/src/rule.c
> @@ -181,6 +181,7 @@ struct set *set_clone(const struct set *set)
>  
>  struct set *set_get(struct set *set)
>  {
> +	assert_refcount_safe(set->refcnt);
>  	set->refcnt++;
>  	return set;
>  }
> @@ -189,6 +190,7 @@ void set_free(struct set *set)
>  {
>  	struct stmt *stmt, *next;
>  
> +	assert_refcount_safe(set->refcnt);
>  	if (--set->refcnt > 0)
>  		return;
>  
> @@ -484,12 +486,14 @@ struct rule *rule_alloc(const struct location *loc, const struct handle *h)
>  
>  struct rule *rule_get(struct rule *rule)
>  {
> +	assert_refcount_safe(rule->refcnt);
>  	rule->refcnt++;
>  	return rule;
>  }
>  
>  void rule_free(struct rule *rule)
>  {
> +	assert_refcount_safe(rule->refcnt);
>  	if (--rule->refcnt > 0)
>  		return;
>  	stmt_list_free(&rule->stmts);
> @@ -606,6 +610,7 @@ struct symbol *symbol_get(const struct scope *scope, const char *identifier)
>  	if (!sym)
>  		return NULL;
>  
> +	assert_refcount_safe(sym->refcnt);
>  	sym->refcnt++;
>  
>  	return sym;
> @@ -613,6 +618,7 @@ struct symbol *symbol_get(const struct scope *scope, const char *identifier)
>  
>  static void symbol_put(struct symbol *sym)
>  {
> +	assert_refcount_safe(sym->refcnt);
>  	if (--sym->refcnt == 0) {
>  		free_const(sym->identifier);
>  		expr_free(sym->expr);
> @@ -732,6 +738,7 @@ struct chain *chain_alloc(void)
>  
>  struct chain *chain_get(struct chain *chain)
>  {
> +	assert_refcount_safe(chain->refcnt);
>  	chain->refcnt++;
>  	return chain;
>  }
> @@ -741,6 +748,7 @@ void chain_free(struct chain *chain)
>  	struct rule *rule, *next;
>  	int i;
>  
> +	assert_refcount_safe(chain->refcnt);
>  	if (--chain->refcnt > 0)
>  		return;
>  	list_for_each_entry_safe(rule, next, &chain->rules, list)
> @@ -1176,6 +1184,7 @@ void table_free(struct table *table)
>  	struct set *set, *nset;
>  	struct obj *obj, *nobj;
>  
> +	assert_refcount_safe(table->refcnt);
>  	if (--table->refcnt > 0)
>  		return;
>  	if (table->comment)
> @@ -1214,6 +1223,7 @@ void table_free(struct table *table)
>  
>  struct table *table_get(struct table *table)
>  {
> +	assert_refcount_safe(table->refcnt);
>  	table->refcnt++;
>  	return table;
>  }
> @@ -1687,12 +1697,14 @@ struct obj *obj_alloc(const struct location *loc)
>  
>  struct obj *obj_get(struct obj *obj)
>  {
> +	assert_refcount_safe(obj->refcnt);
>  	obj->refcnt++;
>  	return obj;
>  }
>  
>  void obj_free(struct obj *obj)
>  {
> +	assert_refcount_safe(obj->refcnt);
>  	if (--obj->refcnt > 0)
>  		return;
>  	free_const(obj->comment);
> @@ -2270,6 +2282,7 @@ struct flowtable *flowtable_alloc(const struct location *loc)
>  
>  struct flowtable *flowtable_get(struct flowtable *flowtable)
>  {
> +	assert_refcount_safe(flowtable->refcnt);
>  	flowtable->refcnt++;
>  	return flowtable;
>  }
> @@ -2278,6 +2291,7 @@ void flowtable_free(struct flowtable *flowtable)
>  {
>  	int i;
>  
> +	assert_refcount_safe(flowtable->refcnt);
>  	if (--flowtable->refcnt > 0)
>  		return;
>  	handle_free(&flowtable->handle);
> -- 
> 2.51.0
> 
> 
