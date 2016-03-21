From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 4/4 v5] nftables: rule: Change the field "rule->comment"
 for an nftnl_udata_buf
Date: Mon, 21 Mar 2016 23:13:30 +0100
Message-ID: <20160321221330.GA2534@salvia>
References: <1458073687-23870-1-git-send-email-carlosfg@riseup.net>
 <1458073687-23870-4-git-send-email-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Carlos Falgueras =?iso-8859-1?Q?Garc=EDa?= <carlosfg@riseup.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37949 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750844AbcCUWNi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Mar 2016 18:13:38 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 2F740C125B
	for <netfilter-devel@vger.kernel.org>; Mon, 21 Mar 2016 23:13:37 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 1F666DA8F9
	for <netfilter-devel@vger.kernel.org>; Mon, 21 Mar 2016 23:13:37 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 32818DA8F9
	for <netfilter-devel@vger.kernel.org>; Mon, 21 Mar 2016 23:13:35 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1458073687-23870-4-git-send-email-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 15, 2016 at 09:28:07PM +0100, Carlos Falgueras Garc=EDa wro=
te:
> Now it is possible to store multiple variable length user data into r=
ule.
> Modify the parser in order to fill the nftnl_udata with the comment, =
and
> the print function for extract these commentary and print it to user.
>=20
> Signed-off-by: Carlos Falgueras Garc=EDa <carlosfg@riseup.net>
> ---
>  include/rule.h            |  7 +++++++
>  src/netlink_delinearize.c | 52 +++++++++++++++++++++++++++++++++++++=
++++++++--
>  src/netlink_linearize.c   | 16 +++++++++++++--
>  3 files changed, 71 insertions(+), 4 deletions(-)
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
> index d431588..5fcb5c1 100644
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
> @@ -1746,6 +1747,54 @@ static void rule_parse_postprocess(struct netl=
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
> +	struct nftnl_udata_buf *udata;
> +	uint8_t attr_len;
> +	char *comment =3D NULL;
> +
> +	udata =3D nftnl_udata_alloc(data_len);
> +	if (!udata)
> +		memory_allocation_error();
> +	nftnl_udata_copy_data(udata, data, data_len);
> +
> +	if (nftnl_udata_parse(udata, parse_udata_cb, tb) <=3D 0)
> +		goto exit;

I think this should be instead:

	if (nftnl_udata_parse(data, data_len, parse_udata_cb, tb) <=3D 0)

So you don't need to allocate the buffer then copy data into it.

I think the buffer infrastructure is only necessary to build the TLV
attributes, not to parse it.

> +	if (!tb[UDATA_TYPE_COMMENT])
> +		goto exit;
> +
> +	attr_len =3D nftnl_udata_attr_len(tb[UDATA_TYPE_COMMENT]);
> +	comment =3D xmalloc(attr_len);
> +	memcpy(comment, nftnl_udata_attr_value(tb[UDATA_TYPE_COMMENT]),
> +	       attr_len);

I'd suggest:

        comment =3D xstrdup(nftnl_udata_attr_get_str(tb[UDATA_TYPE_COMM=
ENT]));

> +
> +exit:
> +	nftnl_udata_free(udata);
> +	return comment;
> +}
> +
>  struct rule *netlink_delinearize_rule(struct netlink_ctx *ctx,
>  				      const struct nftnl_rule *nlr)
>  {
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
