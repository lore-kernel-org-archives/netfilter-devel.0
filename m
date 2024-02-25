Received: from azazel.net (taras.nevrast.org [35.176.194.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1C371094E
	for <netfilter-devel@vger.kernel.org>; Sun, 25 Feb 2024 11:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.176.194.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708861819; cv=none; b=Hom8BkN4AV14n1zgF6nzRK+aYG7Ap3QgzmBdwRho1kvr8scvx01dzXMaMxmcJu7UUnskhBMeZWkNTb5NFfWODsBHJ6ClpubTXlZEtWhjN02p4QNwgOAi2H/lf7kkaSuqz3huaRT934rKN9xl5mK/Z58v/mv6px0zQyKtcsvugTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708861819; c=relaxed/simple;
	bh=XZ53uhMvSakdXR9vfkLTxMdb8PRPAUF3B8Vt+i4qRDs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M8RkBA8nCw425nNCaGj51bB/Mt7jTtPcLTs2PYUIThNYYm2ZQSFsBSD2bKWLg0wg2bTCGnjPwtWH/sJ4X2L3wo3Xq5izZ3RyJNuDMfZmHZ8J+bx4uki4VQRkyzXVJKQD0p1Z3ysTF5h09O90Kzjof5g9GOqELwkfm1egnDBtgYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net; spf=pass smtp.mailfrom=azazel.net; dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b=PtAM22Aj; arc=none smtp.client-ip=35.176.194.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=azazel.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="PtAM22Aj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=9Ex9GJVjdurmwIRfn3V6YmSrTuTJ9aKqa5SY12UKFN8=; b=PtAM22AjyHVdxYA/LiS2mFXagv
	QKOb/M8snGIVtr4j0j8+N5n1YIggCXZXd0dLCSO7gU5L22NzcwJhMvfdeW5p9L2ENmePszAX8O6FR
	A81ncuyxWgA3DVsX0+Z/Orr1yAT4Y/wIV2RIaFsmagOfDKLfFf8NTLZ/+ncWrGfG2FWOuRpRATCo6
	oAwkhKY+WhASDB0uczZlHKPS/QM3vteIrA0T6UjJ6zDATTrBeMLk1qG3VWGC+Cp87Dl3OrjR5txe0
	oCYW2sXzdK6Jx1FqfuqNM9l9F9iAMECKgZgSmvBtzxpx9A68kYx3pcujtNMDK9CCimnL1sENok/me
	v15c/GKw==;
Received: from host86-142-57-152.range86-142.btcentralplus.com ([86.142.57.152] helo=celephais.dreamlands)
	by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <jeremy@azazel.net>)
	id 1reD15-00E3rr-2T;
	Sun, 25 Feb 2024 11:49:59 +0000
Date: Sun, 25 Feb 2024 11:49:58 +0000
From: Jeremy Sowden <jeremy@azazel.net>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Arturo Borrero Gonzalez <arturo@debian.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [RFC] nftables 0.9.8 -stable backports
Message-ID: <20240225114958.GA5487@celephais.dreamlands>
References: <20240218135600.GA4998@siaphelec.sdnalmaerd>
 <ZdSaqOwcEukd4lj4@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="cAh5kvF2wLq7nXcV"
Content-Disposition: inline
In-Reply-To: <ZdSaqOwcEukd4lj4@calendula>
X-SA-Exim-Connect-IP: 86.142.57.152
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false


--cAh5kvF2wLq7nXcV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2024-02-20, at 13:27:30 +0100, Pablo Neira Ayuso wrote:
> Hi Jeremy,
>=20
> On Sun, Feb 18, 2024 at 01:56:00PM +0000, Jeremy Sowden wrote:
> > On 2024-02-17, at 20:11:42 +0000, Jeremy Sowden wrote:
> > > Does this look good to you?
> >=20
> > Forgot to run the test-suite.  Doing so revealed that this doesn't quite
> > work because `set_alloc` doesn't initialize `s->list`.
>=20
> I'd suggest instead a backport of the patch that fixes the set cache
> for 0.9.8 instead.
>=20
> See attached patch, it is partial backport of a upstream patch.
>=20
> I have run tests/shell (two tests don't pass, because 5.15 does not
> support multiple statements) and tests/py for that nftables 0.9.8 version.

Thanks, Pablo.  Looks good.

J.

> From 92908c439d1e33f10ee96daf63eae50d1dfcbb52 Mon Sep 17 00:00:00 2001
> From: Pablo Neira Ayuso <pablo@netfilter.org>
> Date: Tue, 20 Feb 2024 10:26:22 +0100
> Subject: [PATCH] partial backport of df48e56e987f ("cache: add hashtable =
cache
>  for sets")
>=20
> This patch splits table->sets in two:
>=20
> - Sets that reside in the cache are stored in the new
>   tables->cache_set and tables->cache_set_ht.
>=20
> - Set that defined via command line / ruleset file reside in
>   tables->set.
>=20
> Sets in the cache (already in the kernel) are not placed in the
> table->sets list.
>=20
> By keeping separated lists, sets defined via command line / ruleset file
> can be added to cache.
> ---
>  include/cache.h   |  7 +++++
>  include/netlink.h |  1 -
>  include/rule.h    |  3 ++-
>  src/cache.c       | 69 +++++++++++++++++++++++++++++++++++++++++++++++
>  src/evaluate.c    |  2 +-
>  src/json.c        |  4 +--
>  src/monitor.c     |  2 +-
>  src/netlink.c     | 31 ---------------------
>  src/rule.c        | 34 ++++++++++++++---------
>  9 files changed, 104 insertions(+), 49 deletions(-)
>=20
> diff --git a/include/cache.h b/include/cache.h
> index baa2bb29f1e7..d4abe67611bc 100644
> --- a/include/cache.h
> +++ b/include/cache.h
> @@ -59,4 +59,11 @@ void chain_cache_add(struct chain *chain, struct table=
 *table);
>  struct chain *chain_cache_find(const struct table *table,
>  			       const struct handle *handle);
> =20
> +struct nftnl_set_list;
> +
> +struct nftnl_set_list *set_cache_dump(struct netlink_ctx *ctx, int *err);
> +int set_cache_init(struct netlink_ctx *ctx, struct table *table,
> +		   struct nftnl_set_list *set_list);
> +void set_cache_add(struct set *set, struct table *table);
> +
>  #endif /* _NFT_CACHE_H_ */
> diff --git a/include/netlink.h b/include/netlink.h
> index cf8aae465324..f93c5322100f 100644
> --- a/include/netlink.h
> +++ b/include/netlink.h
> @@ -139,7 +139,6 @@ extern int netlink_list_tables(struct netlink_ctx *ct=
x, const struct handle *h);
>  extern struct table *netlink_delinearize_table(struct netlink_ctx *ctx,
>  					       const struct nftnl_table *nlt);
> =20
> -extern int netlink_list_sets(struct netlink_ctx *ctx, const struct handl=
e *h);
>  extern struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
>  					   const struct nftnl_set *nls);
> =20
> diff --git a/include/rule.h b/include/rule.h
> index f880cfd32bd8..7d1bd75e9d7e 100644
> --- a/include/rule.h
> +++ b/include/rule.h
> @@ -157,6 +157,7 @@ struct table {
>  	struct list_head	*cache_chain_ht;
>  	struct list_head	cache_chain;
>  	struct list_head	chains;
> +	struct list_head	cache_set;
>  	struct list_head	sets;
>  	struct list_head	objs;
>  	struct list_head	flowtables;
> @@ -323,6 +324,7 @@ void rule_stmt_insert_at(struct rule *rule, struct st=
mt *nstmt,
>   */
>  struct set {
>  	struct list_head	list;
> +	struct list_head	cache_list;
>  	struct handle		handle;
>  	struct location		location;
>  	unsigned int		refcnt;
> @@ -351,7 +353,6 @@ extern struct set *set_alloc(const struct location *l=
oc);
>  extern struct set *set_get(struct set *set);
>  extern void set_free(struct set *set);
>  extern struct set *set_clone(const struct set *set);
> -extern void set_add_hash(struct set *set, struct table *table);
>  extern struct set *set_lookup(const struct table *table, const char *nam=
e);
>  extern struct set *set_lookup_global(uint32_t family, const char *table,
>  				     const char *name, struct nft_cache *cache);
> diff --git a/src/cache.c b/src/cache.c
> index 32e6eea4ac5c..600e6f02d22e 100644
> --- a/src/cache.c
> +++ b/src/cache.c
> @@ -15,6 +15,8 @@
>  #include <netlink.h>
>  #include <mnl.h>
>  #include <libnftnl/chain.h>
> +#include <include/linux/netfilter.h>
> +#include <linux/netfilter/nf_tables.h>
> =20
>  static unsigned int evaluate_cache_add(struct cmd *cmd, unsigned int fla=
gs)
>  {
> @@ -256,3 +258,70 @@ struct chain *chain_cache_find(const struct table *t=
able,
> =20
>  	return NULL;
>  }
> +
> +struct set_cache_dump_ctx {
> +	struct netlink_ctx	*nlctx;
> +	struct table		*table;
> +};
> +
> +static int set_cache_cb(struct nftnl_set *nls, void *arg)
> +{
> +	struct set_cache_dump_ctx *ctx =3D arg;
> +	const char *set_table;
> +	uint32_t set_family;
> +	struct set *set;
> +
> +	set_table =3D nftnl_set_get_str(nls, NFTNL_SET_TABLE);
> +	set_family =3D nftnl_set_get_u32(nls, NFTNL_SET_FAMILY);
> +
> +	if (set_family !=3D ctx->table->handle.family ||
> +	    strcmp(set_table, ctx->table->handle.table.name))
> +		return 0;
> +
> +	set =3D netlink_delinearize_set(ctx->nlctx, nls);
> +	if (!set)
> +		return -1;
> +
> +	list_add_tail(&set->cache_list, &ctx->table->cache_set);
> +
> +	nftnl_set_list_del(nls);
> +	nftnl_set_free(nls);
> +	return 0;
> +}
> +
> +int set_cache_init(struct netlink_ctx *ctx, struct table *table,
> +		   struct nftnl_set_list *set_list)
> +{
> +	struct set_cache_dump_ctx dump_ctx =3D {
> +		.nlctx	=3D ctx,
> +		.table	=3D table,
> +	};
> +
> +	nftnl_set_list_foreach(set_list, set_cache_cb, &dump_ctx);
> +
> +	return 0;
> +}
> +
> +void set_cache_add(struct set *set, struct table *table)
> +{
> +	list_add_tail(&set->cache_list, &table->cache_set);
> +}
> +
> +struct nftnl_set_list *set_cache_dump(struct netlink_ctx *ctx, int *err)
> +{
> +	struct nftnl_set_list *set_list;
> +	const char *table =3D NULL;
> +	int family =3D AF_UNSPEC;
> +
> +	set_list =3D mnl_nft_set_dump(ctx, family, table);
> +	if (!set_list) {
> +		if (errno =3D=3D EINTR) {
> +			*err =3D -1;
> +			return NULL;
> +		}
> +		*err =3D 0;
> +		return NULL;
> +	}
> +
> +	return set_list;
> +}
> diff --git a/src/evaluate.c b/src/evaluate.c
> index 232ae39020cc..7378174ceb97 100644
> --- a/src/evaluate.c
> +++ b/src/evaluate.c
> @@ -3760,7 +3760,7 @@ static int set_evaluate(struct eval_ctx *ctx, struc=
t set *set)
>  	ctx->set =3D NULL;
> =20
>  	if (set_lookup(table, set->handle.set.name) =3D=3D NULL)
> -		set_add_hash(set_get(set), table);
> +		set_cache_add(set_get(set), table);
> =20
>  	return 0;
>  }
> diff --git a/src/json.c b/src/json.c
> index 737e73b08b5a..13079230af22 100644
> --- a/src/json.c
> +++ b/src/json.c
> @@ -1584,7 +1584,7 @@ static json_t *table_print_json_full(struct netlink=
_ctx *ctx,
>  		tmp =3D obj_print_json(obj);
>  		json_array_append_new(root, tmp);
>  	}
> -	list_for_each_entry(set, &table->sets, list) {
> +	list_for_each_entry(set, &table->cache_set, cache_list) {
>  		if (set_is_anonymous(set->flags))
>  			continue;
>  		tmp =3D set_print_json(&ctx->nft->output, set);
> @@ -1717,7 +1717,7 @@ static json_t *do_list_sets_json(struct netlink_ctx=
 *ctx, struct cmd *cmd)
>  		    cmd->handle.family !=3D table->handle.family)
>  			continue;
> =20
> -		list_for_each_entry(set, &table->sets, list) {
> +		list_for_each_entry(set, &table->cache_set, cache_list) {
>  			if (cmd->obj =3D=3D CMD_OBJ_SETS &&
>  			    !set_is_literal(set->flags))
>  				continue;
> diff --git a/src/monitor.c b/src/monitor.c
> index af2998d4272b..946621e28ec0 100644
> --- a/src/monitor.c
> +++ b/src/monitor.c
> @@ -632,7 +632,7 @@ static void netlink_events_cache_addset(struct netlin=
k_mon_handler *monh,
>  		goto out;
>  	}
> =20
> -	set_add_hash(s, t);
> +	set_cache_add(s, t);
>  out:
>  	nftnl_set_free(nls);
>  }
> diff --git a/src/netlink.c b/src/netlink.c
> index ec2dad29ace1..dcac0ab8f871 100644
> --- a/src/netlink.c
> +++ b/src/netlink.c
> @@ -970,37 +970,6 @@ struct set *netlink_delinearize_set(struct netlink_c=
tx *ctx,
>  	return set;
>  }
> =20
> -static int list_set_cb(struct nftnl_set *nls, void *arg)
> -{
> -	struct netlink_ctx *ctx =3D arg;
> -	struct set *set;
> -
> -	set =3D netlink_delinearize_set(ctx, nls);
> -	if (set =3D=3D NULL)
> -		return -1;
> -	list_add_tail(&set->list, &ctx->list);
> -	return 0;
> -}
> -
> -int netlink_list_sets(struct netlink_ctx *ctx, const struct handle *h)
> -{
> -	struct nftnl_set_list *set_cache;
> -	int err;
> -
> -	set_cache =3D mnl_nft_set_dump(ctx, h->family, h->table.name);
> -	if (set_cache =3D=3D NULL) {
> -		if (errno =3D=3D EINTR)
> -			return -1;
> -
> -		return 0;
> -	}
> -
> -	ctx->data =3D h;
> -	err =3D nftnl_set_list_foreach(set_cache, list_set_cb, ctx);
> -	nftnl_set_list_free(set_cache);
> -	return err;
> -}
> -
>  void alloc_setelem_cache(const struct expr *set, struct nftnl_set *nls)
>  {
>  	struct nftnl_set_elem *nlse;
> diff --git a/src/rule.c b/src/rule.c
> index 9c74b89c1fb1..4b2682455253 100644
> --- a/src/rule.c
> +++ b/src/rule.c
> @@ -153,6 +153,7 @@ static int cache_init_tables(struct netlink_ctx *ctx,=
 struct handle *h,
>  static int cache_init_objects(struct netlink_ctx *ctx, unsigned int flag=
s)
>  {
>  	struct nftnl_chain_list *chain_list =3D NULL;
> +	struct nftnl_set_list *set_list =3D NULL;
>  	struct rule *rule, *nrule;
>  	struct table *table;
>  	struct chain *chain;
> @@ -164,16 +165,22 @@ static int cache_init_objects(struct netlink_ctx *c=
tx, unsigned int flags)
>  		if (!chain_list)
>  			return ret;
>  	}
> +	if (flags & NFT_CACHE_SET_BIT) {
> +		set_list =3D set_cache_dump(ctx, &ret);
> +		if (!set_list) {
> +			ret =3D -1;
> +			goto cache_fails;
> +		}
> +	}
> =20
>  	list_for_each_entry(table, &ctx->nft->cache.list, list) {
>  		if (flags & NFT_CACHE_SET_BIT) {
> -			ret =3D netlink_list_sets(ctx, &table->handle);
> -			list_splice_tail_init(&ctx->list, &table->sets);
> +			ret =3D set_cache_init(ctx, table, set_list);
>  			if (ret < 0)
>  				return -1;
>  		}
>  		if (flags & NFT_CACHE_SETELEM_BIT) {
> -			list_for_each_entry(set, &table->sets, list) {
> +			list_for_each_entry(set, &table->cache_set, cache_list) {
>  				ret =3D netlink_list_setelems(ctx, &set->handle,
>  							    set);
>  				if (ret < 0)
> @@ -212,6 +219,10 @@ static int cache_init_objects(struct netlink_ctx *ct=
x, unsigned int flags)
>  		}
>  	}
> =20
> +cache_fails:
> +	if (set_list)
> +		nftnl_set_list_free(set_list);
> +
>  	if (flags & NFT_CACHE_CHAIN_BIT)
>  		nftnl_chain_list_free(chain_list);
> =20
> @@ -389,16 +400,11 @@ void set_free(struct set *set)
>  	xfree(set);
>  }
> =20
> -void set_add_hash(struct set *set, struct table *table)
> -{
> -	list_add_tail(&set->list, &table->sets);
> -}
> -
>  struct set *set_lookup(const struct table *table, const char *name)
>  {
>  	struct set *set;
> =20
> -	list_for_each_entry(set, &table->sets, list) {
> +	list_for_each_entry(set, &table->cache_set, cache_list) {
>  		if (!strcmp(set->handle.set.name, name))
>  			return set;
>  	}
> @@ -416,7 +422,7 @@ struct set *set_lookup_fuzzy(const char *set_name,
>  	string_misspell_init(&st);
> =20
>  	list_for_each_entry(table, &cache->list, list) {
> -		list_for_each_entry(set, &table->sets, list) {
> +		list_for_each_entry(set, &table->cache_set, cache_list) {
>  			if (set_is_anonymous(set->flags))
>  				continue;
>  			if (!strcmp(set->handle.set.name, set_name)) {
> @@ -1323,6 +1329,7 @@ struct table *table_alloc(void)
>  	init_list_head(&table->chains);
>  	init_list_head(&table->cache_chain);
>  	init_list_head(&table->sets);
> +	init_list_head(&table->cache_set);
>  	init_list_head(&table->objs);
>  	init_list_head(&table->flowtables);
>  	init_list_head(&table->chain_bindings);
> @@ -1357,6 +1364,9 @@ void table_free(struct table *table)
>  		chain_free(chain);
>  	list_for_each_entry_safe(set, nset, &table->sets, list)
>  		set_free(set);
> +	/* this is implicitly releasing sets in the cache */
> +	list_for_each_entry_safe(set, nset, &table->cache_set, cache_list)
> +		set_free(set);
>  	list_for_each_entry_safe(ft, nft, &table->flowtables, list)
>  		flowtable_free(ft);
>  	list_for_each_entry_safe(obj, nobj, &table->objs, list)
> @@ -1457,7 +1467,7 @@ static void table_print(const struct table *table, =
struct output_ctx *octx)
>  		obj_print(obj, octx);
>  		delim =3D "\n";
>  	}
> -	list_for_each_entry(set, &table->sets, list) {
> +	list_for_each_entry(set, &table->cache_set, cache_list) {
>  		if (set_is_anonymous(set->flags))
>  			continue;
>  		nft_print(octx, "%s", delim);
> @@ -1910,7 +1920,7 @@ static int do_list_sets(struct netlink_ctx *ctx, st=
ruct cmd *cmd)
>  			  family2str(table->handle.family),
>  			  table->handle.table.name);
> =20
> -		list_for_each_entry(set, &table->sets, list) {
> +		list_for_each_entry(set, &table->cache_set, cache_list) {
>  			if (cmd->obj =3D=3D CMD_OBJ_SETS &&
>  			    !set_is_literal(set->flags))
>  				continue;
> --=20
> 2.30.2
>=20


--cAh5kvF2wLq7nXcV
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmXbKV8ACgkQKYasCr3x
BA2AFRAAui6jtydkKzltUXyo16Rq2MN9RiOW5Ews4yNL7364P5l/laNGSPsnVnU6
Ft2rJhmHU9xKsOMHMjTSFALLOf6zMan+UJ5gqmLdx053/RqQl8+AIZyIPNs+Unx0
bPl8OXPT3pXyhbTfO7ui3bshV4FPw8QPi46kzp/zZXvIyIVqVENFwLhbCYcY1D5F
i7jBkySyv5wo4wsiJpY62UQTOEFyIiiP0DLIQe5smvEa3bsk0OUlSuPxTZISV0D9
iGH7B8FX66Fzv7VfU7e8RWkNDnJqCusWAuxFzkiQZSZfo9KM3Y0TKVDx2fp34Pph
GpY6Jucp67ITs27hl6EFv+4iB7TQ/OcfH9tq/ymacY1hcnGLjHRDzsuFLGKVzbuL
EKh/2o/nPBdEsmzkw2G68Lvht6MFx+5XAnxg2/hrB7ts4Y1D5T7OK8ANsoTU3GF0
ZtvIYuehQC3q/ftvQmpqdYCyskY4xyb3yocCoH3gKIZxBpkv16SpnY/GHv22/sa3
OXSRhRjYpz48Dj6XSwO1gJ7oP3mW7I/168NErdg8XvK3+DDXFYnb2UaLu46QdtMT
UQyTfvOvJBwXbm6BUIov5q5KC92NAnSfWMdx33r7jv5LXSPUDdvL6uVTTC2eZdMo
2EiTYtLvTPhtz/pT/6Mhi38w10J60Mx7TL8TP1pRKPIvVRYpiCA=
=7pqC
-----END PGP SIGNATURE-----

--cAh5kvF2wLq7nXcV--
