From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH libnftnl] Fix string length calculations
Date: Sat, 2 Jul 2016 08:54:48 +0200
Message-ID: <20160702065316.GA26375@salvia>
References: <20160701142247.GA8806@salvia>
 <1467389503-27143-1-git-send-email-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Carlos Falgueras =?iso-8859-1?Q?Garc=EDa?= <carlosfg@riseup.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58872 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750766AbcGBGy6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 Jul 2016 02:54:58 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 6DE8FE7DAF
	for <netfilter-devel@vger.kernel.org>; Sat,  2 Jul 2016 08:54:52 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 5FF609EBAB
	for <netfilter-devel@vger.kernel.org>; Sat,  2 Jul 2016 08:54:52 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 423EA9EBA8
	for <netfilter-devel@vger.kernel.org>; Sat,  2 Jul 2016 08:54:50 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1467389503-27143-1-git-send-email-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jul 01, 2016 at 06:11:43PM +0200, Carlos Falgueras Garc=EDa wro=
te:
> These lengths must be one character longer to take account the null
> character

Please, place the change for src/set.c in this patch so I only need to
apply one patch.

Another comment below.

> Signed-off-by: Carlos Falgueras Garc=EDa <carlosfg@riseup.net>
> ---
>  src/chain.c    | 2 +-
>  src/rule.c     | 2 +-
>  src/set_elem.c | 2 +-
>  src/table.c    | 2 +-
>  src/trace.c    | 6 +++---
>  5 files changed, 7 insertions(+), 7 deletions(-)
>=20
> diff --git a/src/chain.c b/src/chain.c
> index bfffbe0..cab64b5 100644
> --- a/src/chain.c
> +++ b/src/chain.c
> @@ -260,7 +260,7 @@ EXPORT_SYMBOL_ALIAS(nftnl_chain_set_u8, nft_chain=
_attr_set_u8);
> =20
>  int nftnl_chain_set_str(struct nftnl_chain *c, uint16_t attr, const =
char *str)
>  {
> -	return nftnl_chain_set_data(c, attr, str, strlen(str));
> +	return nftnl_chain_set_data(c, attr, str, strlen(str) + 1);
>  }
>  EXPORT_SYMBOL_ALIAS(nftnl_chain_set_str, nft_chain_attr_set_str);
> =20
> diff --git a/src/rule.c b/src/rule.c
> index c87fea7..2b23c8e 100644
> --- a/src/rule.c
> +++ b/src/rule.c
> @@ -198,7 +198,7 @@ EXPORT_SYMBOL_ALIAS(nftnl_rule_set_u64, nft_rule_=
attr_set_u64);
> =20
>  int nftnl_rule_set_str(struct nftnl_rule *r, uint16_t attr, const ch=
ar *str)
>  {
> -	return nftnl_rule_set_data(r, attr, str, strlen(str));
> +	return nftnl_rule_set_data(r, attr, str, strlen(str) + 1);
>  }
>  EXPORT_SYMBOL_ALIAS(nftnl_rule_set_str, nft_rule_attr_set_str);
> =20
> diff --git a/src/set_elem.c b/src/set_elem.c
> index 00b7327..40b5bfe 100644
> --- a/src/set_elem.c
> +++ b/src/set_elem.c
> @@ -149,7 +149,7 @@ EXPORT_SYMBOL_ALIAS(nftnl_set_elem_set_u64, nft_s=
et_elem_attr_set_u64);
> =20
>  int nftnl_set_elem_set_str(struct nftnl_set_elem *s, uint16_t attr, =
const char *str)
>  {
> -	return nftnl_set_elem_set(s, attr, str, strlen(str));
> +	return nftnl_set_elem_set(s, attr, str, strlen(str) + 1);
>  }
>  EXPORT_SYMBOL_ALIAS(nftnl_set_elem_set_str, nft_set_elem_attr_set_st=
r);
> =20
> diff --git a/src/table.c b/src/table.c
> index 32d119f..966b923 100644
> --- a/src/table.c
> +++ b/src/table.c
> @@ -131,7 +131,7 @@ EXPORT_SYMBOL_ALIAS(nftnl_table_set_u8, nft_table=
_attr_set_u8);
> =20
>  int nftnl_table_set_str(struct nftnl_table *t, uint16_t attr, const =
char *str)
>  {
> -	return nftnl_table_set_data(t, attr, str, 0);
> +	return nftnl_table_set_data(t, attr, str, strlen(str) + 1);
>  }
>  EXPORT_SYMBOL_ALIAS(nftnl_table_set_str, nft_table_attr_set_str);
> =20
> diff --git a/src/trace.c b/src/trace.c
> index d8f561d..1a50390 100644
> --- a/src/trace.c
> +++ b/src/trace.c
> @@ -165,13 +165,13 @@ const void *nftnl_trace_get_data(const struct n=
ftnl_trace *trace,
>  		*data_len =3D sizeof(uint32_t);
>  		return &trace->type;
>  	case NFTNL_TRACE_CHAIN:
> -		*data_len =3D strlen(trace->chain);
> +		*data_len =3D strlen(trace->chain) + 1;
>  		return trace->chain;
>  	case NFTNL_TRACE_TABLE:
> -		*data_len =3D strlen(trace->table);
> +		*data_len =3D strlen(trace->table) + 1;
>  		return trace->table;
>  	case NFTNL_TRACE_JUMP_TARGET:
> -		*data_len =3D strlen(trace->jump_target);
> +		*data_len =3D strlen(trace->jump_target) + 1;
>  		return trace->jump_target;
>  	case NFTNL_TRACE_TRANSPORT_HEADER:
>  		*data_len =3D trace->th.len;

Are you really sure we need this chunk too?
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
