From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 4/4 v6] nftables: rule: Change the field "rule->comment"
 for an nftnl_udata_buf
Date: Thu, 14 Apr 2016 02:01:13 +0200
Message-ID: <20160414000113.GC12737@salvia>
References: <1458675987-32398-1-git-send-email-carlosfg@riseup.net>
 <1458675987-32398-4-git-send-email-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Carlos Falgueras =?iso-8859-1?Q?Garc=EDa?= <carlosfg@riseup.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44586 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754185AbcDNABl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Apr 2016 20:01:41 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id C140E73F4
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Apr 2016 02:01:39 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id B0F27A861
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Apr 2016 02:01:39 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 36E5CEBADB
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Apr 2016 02:01:37 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1458675987-32398-4-git-send-email-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 22, 2016 at 08:46:27PM +0100, Carlos Falgueras Garc=EDa wro=
te:
> Now it is possible to store multiple variable length user data into r=
ule.
> Modify the parser in order to fill the nftnl_udata with the comment, =
and
> the print function for extract these commentary and print it to user.

Applied with minor changes, see below. thanks Carlos.

> Signed-off-by: Carlos Falgueras Garc=EDa <carlosfg@riseup.net>
> ---
>  include/rule.h            |  7 +++++++
>  src/netlink_delinearize.c | 40 +++++++++++++++++++++++++++++++++++++=
+--
>  src/netlink_linearize.c   | 18 ++++++++++++++++--
>  3 files changed, 61 insertions(+), 4 deletions(-)
>=20
> diff --git a/include/rule.h b/include/rule.h
> index c848f0f..b52f0ac 100644
> --- a/include/rule.h
> +++ b/include/rule.h
> @@ -4,6 +4,7 @@
>  #include <stdint.h>
>  #include <nftables.h>
>  #include <list.h>
> +#include <libnftnl/udata.h>
> =20
>  /**
>   * struct handle - handle for tables, chains, rules and sets
> @@ -396,4 +397,10 @@ extern int do_command(struct netlink_ctx *ctx, s=
truct cmd *cmd);
>  extern int cache_update(enum cmd_ops cmd, struct list_head *msgs);
>  extern void cache_release(void);
> =20
> +enum udata_type {
> +	UDATA_TYPE_COMMENT,
> +	__UDATA_TYPE_MAX,
> +};
> +#define UDATA_TYPE_MAX (__UDATA_TYPE_MAX - 1)
> +
>  #endif /* NFTABLES_RULE_H */
> diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
> index d431588..1171e6f 100644
> --- a/src/netlink_delinearize.c
> +++ b/src/netlink_delinearize.c
> @@ -25,6 +25,7 @@
>  #include <utils.h>
>  #include <erec.h>
>  #include <sys/socket.h>
> +#include <libnftnl/udata.h>
> =20
>  struct netlink_parse_ctx {
>  	struct list_head	*msgs;
> @@ -1746,6 +1747,42 @@ static void rule_parse_postprocess(struct netl=
ink_parse_ctx *ctx, struct rule *r
>  	}
>  }
> =20
> +static int parse_udata_cb(const struct nftnl_udata *attr, void *data=
)
> +{
> +	unsigned char *value =3D nftnl_udata_attr_value(attr);
> +	uint8_t type =3D nftnl_udata_attr_type(attr);
> +	uint8_t len =3D nftnl_udata_attr_len(attr);
> +	const struct nftnl_udata **tb =3D data;
> +
> +	switch (type) {
> +	case UDATA_TYPE_COMMENT:
> +		if (value[len - 1] !=3D '\0')
> +			return -1;
> +		break;
> +	default:
> +		break;
> +	};
> +
> +	tb[type] =3D attr;
> +	return 1;
> +}
> +
> +static char *udata_get_comment(const void *data, uint32_t data_len)
> +{
> +	const struct nftnl_udata *tb[UDATA_TYPE_MAX + 1] =3D {};
> +	char *comment =3D NULL;
> +
> +	if (nftnl_udata_parse(data, data_len, parse_udata_cb, tb) <=3D 0)
> +		return NULL;
> +
> +	if (!tb[UDATA_TYPE_COMMENT])
> +		return NULL;
> +
> +	comment =3D xstrdup(nftnl_udata_attr_value(tb[UDATA_TYPE_COMMENT]))=
;

No need for char *comment, we can just:

        return xstrdup(...);
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
