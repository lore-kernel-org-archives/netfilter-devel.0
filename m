From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/2,libnftnl] Check memory allocations in setters
Date: Thu, 2 Jun 2016 12:57:06 +0200
Message-ID: <20160602105706.GB3013@salvia>
References: <1464864024-12108-1-git-send-email-carlosfg@riseup.net>
 <1464864024-12108-2-git-send-email-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Carlos Falgueras =?iso-8859-1?Q?Garc=EDa?= <carlosfg@riseup.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59602 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751833AbcFBK5M (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Jun 2016 06:57:12 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id A0AD44941E7
	for <netfilter-devel@vger.kernel.org>; Thu,  2 Jun 2016 12:57:10 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 904681B4058
	for <netfilter-devel@vger.kernel.org>; Thu,  2 Jun 2016 12:57:10 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 770CE1B4063
	for <netfilter-devel@vger.kernel.org>; Thu,  2 Jun 2016 12:57:08 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1464864024-12108-2-git-send-email-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jun 02, 2016 at 12:40:24PM +0200, Carlos Falgueras Garc=EDa wro=
te:
> When you set an object attribute the memory is copied, sometimes an
> allocations is needed and it must be checked. By now all setters meth=
ods
> returns void, so the policy adopted in case of error is keep the obje=
ct
> unchanged.
>=20
> What this patch makes:
> 	* All memory allocations inside setters are checked
> 	* The object remains unchanged in case of error
> 	* Unsetters are used if is possible in order to consolidate
>=20
> Signed-off-by: Carlos Falgueras Garc=EDa <carlosfg@riseup.net>
> ---
>  src/chain.c          | 26 +++++++++++++++++---------
>  src/expr/dynset.c    |  8 +++++++-
>  src/expr/immediate.c |  9 ++++++---
>  src/expr/log.c       | 12 +++++++++---
>  src/expr/lookup.c    |  8 +++++++-
>  src/rule.c           | 28 +++++++++++++++++-----------
>  src/set.c            | 18 ++++++++++++------
>  src/set_elem.c       | 21 +++++++++++++--------
>  8 files changed, 88 insertions(+), 42 deletions(-)
>=20
> diff --git a/src/chain.c b/src/chain.c
> index 990c576..c4c4ff7 100644
> --- a/src/chain.c
> +++ b/src/chain.c
> @@ -168,6 +168,8 @@ static uint32_t nftnl_chain_validate[NFTNL_CHAIN_=
MAX + 1] =3D {
>  void nftnl_chain_set_data(struct nftnl_chain *c, uint16_t attr,
>  			     const void *data, uint32_t data_len)
>  {
> +	char *newstr;
> +
>  	if (attr > NFTNL_CHAIN_MAX)
>  		return;
> =20
> @@ -178,10 +180,12 @@ void nftnl_chain_set_data(struct nftnl_chain *c=
, uint16_t attr,
>  		strncpy(c->name, data, NFT_CHAIN_MAXNAMELEN);
>  		break;
>  	case NFTNL_CHAIN_TABLE:
> -		if (c->table)
> -			xfree(c->table);
> +		newstr =3D strdup(data);
> +		if (!newstr)
> +			return;
> =20
> -		c->table =3D strdup(data);
> +		nftnl_chain_unset(c, attr);
> +		c->table =3D newstr;

This looks a bit tangled. Probably something more simple, like this
below?

                xfree(c->table);
                c->table =3D strdup(data);
                if (!c->table)
                        return;

Another comment below.

[...]
> diff --git a/src/expr/log.c b/src/expr/log.c
> index c3dc0a6..369174f 100644
> --- a/src/expr/log.c
> +++ b/src/expr/log.c
> @@ -34,13 +34,17 @@ static int nftnl_expr_log_set(struct nftnl_expr *=
e, uint16_t type,
>  				 const void *data, uint32_t data_len)
>  {
>  	struct nftnl_expr_log *log =3D nftnl_expr_data(e);
> +	char *newstr;
> =20
>  	switch(type) {
>  	case NFTNL_EXPR_LOG_PREFIX:
> -		if (log->prefix)
> -			xfree(log->prefix);
> +		newstr =3D strdup(data);
> +		if (!newstr)
> +			return -1;
> =20
> -		log->prefix =3D strdup(data);
> +		if (log->flags & (1 << NFTNL_EXPR_LOG_PREFIX))
> +			xfree(log->prefix);
> +		log->prefix =3D newstr;
>  		break;
>  	case NFTNL_EXPR_LOG_GROUP:
>  		log->group =3D *((uint16_t *)data);
> @@ -60,6 +64,8 @@ static int nftnl_expr_log_set(struct nftnl_expr *e,=
 uint16_t type,
>  	default:
>  		return -1;
>  	}
> +
> +	log->flags |=3D (1 << type);

Do we need this here?

>  	return 0;
>  }
> =20
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
