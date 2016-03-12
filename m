From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 4/4 v4] nftables: rule: Change the field "rule->comment"
 for an nftnl_udata_buf
Date: Sat, 12 Mar 2016 12:29:55 +0100
Message-ID: <20160312112955.GC1764@salvia>
References: <1457645836-10996-1-git-send-email-carlosfg@riseup.net>
 <1457645836-10996-4-git-send-email-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Carlos Falgueras =?iso-8859-1?Q?Garc=EDa?= <carlosfg@riseup.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47203 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752251AbcCLLaF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 12 Mar 2016 06:30:05 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 49F6C4B9E5
	for <netfilter-devel@vger.kernel.org>; Sat, 12 Mar 2016 12:30:03 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 36CA7DA8FA
	for <netfilter-devel@vger.kernel.org>; Sat, 12 Mar 2016 12:30:03 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id C69BBDA8FB
	for <netfilter-devel@vger.kernel.org>; Sat, 12 Mar 2016 12:30:00 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1457645836-10996-4-git-send-email-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Mar 10, 2016 at 10:37:16PM +0100, Carlos Falgueras Garc=EDa wro=
te:
> Now it is possible to store multiple variable length user data into r=
ule.
> Modify the parser in order to fill the nftnl_udata with the comment, =
and
> the print function for extract these commentary and print it to user.
>=20
> Signed-off-by: Carlos Falgueras Garc=EDa <carlosfg@riseup.net>
> ---
>  include/rule.h            | 11 +++++++++--
>  src/netlink_delinearize.c |  7 +++++--
>  src/netlink_linearize.c   |  6 ++++--
>  src/parser_bison.y        | 14 +++++++++++++-
>  src/rule.c                | 45 +++++++++++++++++++++++++++++++++++++=
+++++---
>  5 files changed, 73 insertions(+), 10 deletions(-)
>=20
> diff --git a/include/rule.h b/include/rule.h
> index c848f0f..c500e88 100644
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
> @@ -155,7 +156,7 @@ extern void chain_print_plain(const struct chain =
*chain);
>   * @location:	location the rule was defined at
>   * @stmt:	list of statements
>   * @num_stmts:	number of statements in stmts list
> - * @comment:	comment
> + * @udata:	user data
>   */
>  struct rule {
>  	struct list_head	list;
> @@ -163,7 +164,7 @@ struct rule {
>  	struct location		location;
>  	struct list_head	stmts;
>  	unsigned int		num_stmts;
> -	const char		*comment;
> +	struct nftnl_udata_buf	*udata;

I think we should keep the:

        const char              *comment;

The nftnl_udata_buf should only be used when building the TLV area
from the netlink_linearize step, and when parsing the TLV and covert
it to attribute from netlink_delinearize. Otherwise, we have to deal
with this internal layout from other parts of nft that are not netlink
specific.

>  };
> =20
>  extern struct rule *rule_alloc(const struct location *loc,
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
> index d431588..e655e00 100644
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
> @@ -1773,8 +1774,10 @@ struct rule *netlink_delinearize_rule(struct n=
etlink_ctx *ctx,
>  		uint32_t len;
> =20
>  		data =3D nftnl_rule_get_data(nlr, NFTNL_RULE_USERDATA, &len);
> -		pctx->rule->comment =3D xmalloc(len);
> -		memcpy((char *)pctx->rule->comment, data, len);
> +		pctx->rule->udata =3D nftnl_udata_alloc(len);
> +		if (!pctx->rule->udata)
> +			memory_allocation_error();
> +		nftnl_udata_copy_data(pctx->rule->udata, data, len);

Therefore, here you should extract the data from the udata and set
pctx->rule->comment.

>  	}
> =20
>  	nftnl_expr_foreach((struct nftnl_rule *)nlr, netlink_parse_expr, pc=
tx);
> diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
> index bb51de7..5ac438e 100644
> --- a/src/netlink_linearize.c
> +++ b/src/netlink_linearize.c
> @@ -21,6 +21,7 @@
>  #include <netinet/in.h>
> =20
>  #include <linux/netfilter.h>
> +#include <libnftnl/udata.h>
> =20
> =20
>  struct netlink_linearize_ctx {
> @@ -1171,9 +1172,10 @@ void netlink_linearize_rule(struct netlink_ctx=
 *ctx, struct nftnl_rule *nlr,
>  	list_for_each_entry(stmt, &rule->stmts, list)
>  		netlink_gen_stmt(&lctx, stmt);
> =20
> -	if (rule->comment)
> +	if (rule->udata)
>  		nftnl_rule_set_data(nlr, NFTNL_RULE_USERDATA,
> -				    rule->comment, strlen(rule->comment) + 1);
> +				    nftnl_udata_data(rule->udata),
> +				    nftnl_udata_len(rule->udata));

When linearizing, you should do something like:

if (rule->comment) {
	udata =3D nftnl_udata_alloc(NFT_USERDATA_MAXLEN));
        if (!udata)
                memory_allocation_error();

	if (!nftnl_udata_put_strz(udata, UDATA_TYPE_COMMENT, rule->comment))
                memory_allocation_error();

        nftnl_rule_set_data(nlr, NFTNL_RULE_USERDATA,
                            nftnl_udata_data(udata),
                            nftnl_udata_len(udata));
}

>
>  	netlink_dump_rule(nlr);
>  }
> diff --git a/src/parser_bison.y b/src/parser_bison.y
> index 90978ab..9f8c005 100644
> --- a/src/parser_bison.y
> +++ b/src/parser_bison.y
> @@ -24,6 +24,7 @@
>  #include <netinet/icmp6.h>
>  #include <libnftnl/common.h>
>  #include <libnftnl/set.h>
> +#include <libnftnl/udata.h>
> =20
>  #include <rule.h>
>  #include <statement.h>
> @@ -1303,7 +1304,18 @@ rule			:	stmt_list	comment_spec
>  				struct stmt *i;
> =20
>  				$$ =3D rule_alloc(&@$, NULL);
> -				$$->comment =3D $2;
> +
> +				if ($2) {
> +					if (!($$->udata =3D nftnl_udata_alloc(NFT_USERDATA_MAXLEN)))
> +						memory_allocation_error();
> +
> +					if (!nftnl_udata_put_strz($$->udata, UDATA_TYPE_COMMENT, $2)) {
> +						erec_queue(error(&@2, "Comment too long: \"%s\"", $2),
> +							state->msgs);
> +						YYERROR;
> +					}
> +				}

With the change I propose above, you don't need to update the parser
anymore.

> +
>  				list_for_each_entry(i, $1, list)
>  					$$->num_stmts++;
>  				list_splice_tail($1, &$$->stmts);
> diff --git a/src/rule.c b/src/rule.c
> index 0b78549..112ae85 100644
> --- a/src/rule.c
> +++ b/src/rule.c
> @@ -23,6 +23,7 @@
> =20
>  #include <libnftnl/common.h>
>  #include <libnftnl/ruleset.h>
> +#include <libnftnl/udata.h>
>  #include <netinet/ip.h>
>  #include <linux/netfilter.h>
>  #include <linux/netfilter_arp.h>
> @@ -375,21 +376,59 @@ void rule_free(struct rule *rule)
>  {
>  	stmt_list_free(&rule->stmts);
>  	handle_free(&rule->handle);
> -	xfree(rule->comment);
> +	nftnl_udata_free(rule->udata);

This change, you will not need it with the change I'm proposing.

>  	xfree(rule);
>  }
> =20
> +static int rule_parse_udata_cb(const struct nftnl_udata *attr, void =
*data)
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
> +static void rule_print_udata(const struct nftnl_udata *tb[], uint8_t=
 type)
> +{
> +	if (!tb[type])
> +		return;
> +
> +	switch (type) {
> +	case UDATA_TYPE_COMMENT:
> +		printf("comment \"%s\" ",
> +		       (char *)nftnl_udata_attr_value(tb[type]));
> +		break;
> +	default:
> +		break;
> +	}
> +}

=2E.. And these functions, you will place them in netlink_delinearize.c=
,
which is where they belong since they are dealing with a low-level
netlink aspect.

>  void rule_print(const struct rule *rule)
>  {
>  	const struct stmt *stmt;
> +	const struct nftnl_udata *tb[UDATA_TYPE_MAX + 1] =3D {};
> =20
>  	list_for_each_entry(stmt, &rule->stmts, list) {
>  		stmt->ops->print(stmt);
>  		printf(" ");
>  	}
> =20
> -	if (rule->comment)
> -		printf("comment \"%s\" ", rule->comment);
> +	if (rule->udata) {
> +		if (nftnl_udata_parse(rule->udata, rule_parse_udata_cb, tb) > 0)
> +			rule_print_udata(tb, UDATA_TYPE_COMMENT);
> +	}

With the change I'm proposing above, you will not need this either.

>  	if (handle_output > 0)
>  		printf("# handle %" PRIu64, rule->handle.handle);
> --=20
> 2.7.2
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-d=
evel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
