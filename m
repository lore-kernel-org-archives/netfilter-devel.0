From: =?ISO-8859-1?Q?=C1lvaro_Neira_Ayuso?= <alvaroneay@gmail.com>
Subject: Re: [nft PATCH v2] nft: add reject support
Date: Wed, 20 Aug 2014 17:52:06 +0200
Message-ID: <53F4C426.8030807@gmail.com>
References: <1408350660-4430-1-git-send-email-alvaroneay@gmail.com> <20140818223129.GA3950@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:55674 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831AbaHTPwB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 20 Aug 2014 11:52:01 -0400
Received: by mail-wg0-f49.google.com with SMTP id k14so7905191wgh.8
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Aug 2014 08:51:59 -0700 (PDT)
In-Reply-To: <20140818223129.GA3950@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

El 19/08/14 00:31, Pablo Neira Ayuso escribi=F3:
> On Mon, Aug 18, 2014 at 10:31:00AM +0200, Alvaro Neira Ayuso wrote:
>> This patch allows to use the reject action in rules. Example:
>>
>> nft add rule filter input udp dport 22 reject
>>
>> In this rule, we assume that the reason is network unreachable. Also
>> we can specify the reason with the option "with" and the reason. Exa=
mple:
>>
>> nft add rule filter input tcp dport 22 reject with host-unreach
>>
>> In the bridge tables and inet tables, we can use this action too. Ex=
ample:
>>
>> nft add rule inet filter input reject with icmp-host-unreach
>>
>> In this rule above, this generates a meta nfproto dependency to matc=
h
>> ipv4 traffic because we use a icmpv4 reason to reject.
>>
>> Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
>> ---
>> [Changes in v2]
>> * Set Up the icmp code only if we establish it.
>>
>> [Tested with the rules]
>> [Error ways]
>> Reject not supported for arp
>>    * nft add rule arp filter input reject (reject not supported for =
arp)
>>
>> Use icmp code field in a ipv6 table or icmpv6 code field in ipv4 tab=
le
>>    * nft add rule ip filter input reject with icmpv6-no-route
>>    * nft add rule ip6 filter input reject with icmp-host-unreach
>>
>> Insufficient context for using reject
>>    * nft add rule inet filter input reject
>>    * nft add rule bridge filter input reject
>>
>> Use tcp reset with a udp rule
>>    * nft add rule ip filter input udp dport 9999 reject with tcp-res=
et
>>
>> [Hits ways]
>> IPV4
>>    * nft add rule ip filter input udp dport 9999 reject with
>>    * icmp-host-unreach
>>    * nft add rule ip filter input tcp dport 9999 reject
>>    * nft add rule ip filter input reject
>> IPV6
>>    * nft add rule ip6 filter input udp dport 9999 reject
>>    * nft add rule ip6 filter input tcp dport 9999 /
>> 		reject with icmpv6-admin-prohibited
>>    * nft add rule ip6 filter input reject
>> INET
>>    * nft add rule inet filter input reject with icmp-host-unreach
>>    * nft add rule inet filter input reject with icmpv6-no-route
>>    * nft add rule inet filter input udp dport 9999 counter /
>> 				      reject with icmpv6-no-route
>> BRIDGE
>>    * nft add rule bridge filter input reject with icmp-host-unreach
>>    * nft add rule bridge filter input reject with icmpv6-no-route
>>
>>   include/statement.h       |    2 +
>>   src/evaluate.c            |  116 +++++++++++++++++++++++++++++++++=
++++++++++--
>>   src/netlink_delinearize.c |   37 +++++++++++++++
>>   src/netlink_linearize.c   |    4 +-
>>   src/parser.y              |   74 +++++++++++++++++++++++++++--
>>   src/payload.c             |   31 ++++++++++--
>>   src/scanner.l             |    1 +
>>   src/statement.c           |   29 ++++++++++++
>>   8 files changed, 282 insertions(+), 12 deletions(-)
>>
>> diff --git a/include/statement.h b/include/statement.h
>> index 480b719..c971aa5 100644
>> --- a/include/statement.h
>> +++ b/include/statement.h
>> @@ -47,6 +47,8 @@ extern struct stmt *limit_stmt_alloc(const struct =
location *loc);
>>
>>   struct reject_stmt {
>>   	enum nft_reject_types	type;
>> +	int8_t			icmp_code;
>> +	unsigned int		family;
>>   };
>>
>>   extern struct stmt *reject_stmt_alloc(const struct location *loc);
>> diff --git a/src/evaluate.c b/src/evaluate.c
>> index e05473a..75fe3fe 100644
>> --- a/src/evaluate.c
>> +++ b/src/evaluate.c
>> @@ -17,6 +17,7 @@
>>   #include <linux/netfilter.h>
>>   #include <linux/netfilter_arp.h>
>>   #include <linux/netfilter/nf_tables.h>
>> +#include <netinet/ip_icmp.h>
>>
>>   #include <expression.h>
>>   #include <statement.h>
>> @@ -261,6 +262,18 @@ static int expr_evaluate_primary(struct eval_ct=
x *ctx, struct expr **expr)
>>   	return 0;
>>   }
>>
>> +static struct stmt *expr_stmt_alloc_eval(struct eval_ctx *ctx,
>> +					 struct expr *expr)
>> +{
>> +	struct stmt *nstmt;
>> +
>> +	nstmt =3D expr_stmt_alloc(&expr->location, expr);
>> +	if (stmt_evaluate(ctx, nstmt) < 0)
>> +		BUG("malformed dependency statement");
>
> Please, move this code to payload_gen_dependency() which should retur=
n
> the new statement.
>
> Look:
>
>   		if (payload_gen_dependency(ctx, payload, &nexpr) < 0)
>   			return -1;
> -		nstmt =3D expr_stmt_alloc(&nexpr->location, nexpr);
> -		if (stmt_evaluate(ctx, nstmt) < 0)
> -			return -1;
>
> and here:
>
> +	if (payload_gen_dependency(ctx, payload, &nexpr) < 0)
> +		BUG("error creating reject payload dependency");
> +
> +	nstmt =3D expr_stmt_alloc_eval(ctx, nexpr);
>
> in both places you call expr_stmt_alloc_eval() just after
> payload_gen_dependency() and you can skip this new function.
>
> This should come as an independent initial patch. Send it to me this
> cleanup asap, not need to collect it in a patch series.

Perfect, I'm going to do it.

>
>> +
>> +	return nstmt;
>> +}
>> +
>>   /*
>>    * Payload expression: check whether dependencies are fulfilled, o=
therwise
>>    * generate the necessary relational expression and prepend it to =
the current
>> @@ -276,9 +289,7 @@ static int expr_evaluate_payload(struct eval_ctx=
 *ctx, struct expr **expr)
>>   	if (ctx->pctx.protocol[base].desc =3D=3D NULL) {
>>   		if (payload_gen_dependency(ctx, payload, &nexpr) < 0)
>>   			return -1;
>> -		nstmt =3D expr_stmt_alloc(&nexpr->location, nexpr);
>> -		if (stmt_evaluate(ctx, nstmt) < 0)
>> -			return -1;
>> +		nstmt =3D expr_stmt_alloc_eval(ctx, nexpr);
>>   		list_add_tail(&nstmt->list, &ctx->stmt->list);
>>   	} else if (ctx->pctx.protocol[base].desc !=3D payload->payload.de=
sc)
>>   		return expr_error(ctx->msgs, payload,
>> @@ -1131,8 +1142,107 @@ static int stmt_evaluate_meta(struct eval_ct=
x *ctx, struct stmt *stmt)
>>   	return 0;
>>   }
>>
>> +static int stmt_reject_gen_dependency(struct stmt *stmt, struct exp=
r *expr,
>> +				      struct eval_ctx *ctx)
>> +{
>> +	struct expr *payload, *nexpr;
>> +	struct stmt *nstmt;
>> +
>> +	if (stmt->reject.icmp_code < 0)
>> +		return stmt_error(ctx, stmt, "missing icmp error type");
>> +
>> +	switch (stmt->reject.family) {
>> +	case NFPROTO_IPV4:
>> +		payload =3D payload_expr_alloc(&stmt->location, &proto_ip,
>> +					     IPHDR_PROTOCOL);
		^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^




>> +		break;
>> +	case NFPROTO_IPV6:
>> +		payload =3D payload_expr_alloc(&stmt->location, &proto_ip6,
>> +					     IP6HDR_NEXTHDR);
		^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Code important to understand the answer of the last questions.

>> +		break;
>> +	default:
>> +		BUG("unknown reject family");
>> +	}
>> +
>> +	if (payload_gen_dependency(ctx, payload, &nexpr) < 0)
>> +		BUG("error creating reject payload dependency");
>> +
>> +	nstmt =3D expr_stmt_alloc_eval(ctx, nexpr);
>> +	list_add(&nstmt->list, &ctx->cmd->rule->stmts);
>> +	return 0;
>> +}
>> +
>>   static int stmt_evaluate_reject(struct eval_ctx *ctx, struct stmt =
*stmt)
>>   {
>> +	struct proto_ctx *pctx =3D &ctx->pctx;
>> +	const struct proto_desc *desc, *base;
>> +	struct expr *expr =3D ctx->cmd->expr;
>> +	int protonum;
>> +
>> +	switch (ctx->pctx.family) {
>> +	case NFPROTO_ARP:
>> +		return stmt_error(ctx, stmt, "cannot use reject with arp");
>> +	case NFPROTO_INET:
>> +	case NFPROTO_BRIDGE:
>
>  From here:
>
>> +		if (stmt->reject.type !=3D NFT_REJECT_TCP_RST) {
>> +			desc =3D pctx->protocol[PROTO_BASE_NETWORK_HDR].desc;
>> +			if (desc =3D=3D NULL &&
>> +			    stmt_reject_gen_dependency(stmt, expr, ctx) < 0)
>> +				return -1;
>> +		}
>
> to there. You can put all this code in stmt_reject_gen_dependency().
> That function is only used once.

Perfect.

>
>> +		break;
>> +	case NFPROTO_IPV4:
>> +		if (stmt->reject.icmp_code >=3D 0 &&
>> +		    stmt->reject.family !=3D NFPROTO_IPV4 &&
>> +		    stmt->reject.type !=3D NFT_REJECT_TCP_RST) {
>> +			return stmt_error(ctx, stmt,
>> +				  "conflicting protocols specified: ip vs ip6");
>> +		}
>> +		break;
>> +	case NFPROTO_IPV6:
>> +		if (stmt->reject.icmp_code >=3D 0 &&
>> +		    stmt->reject.family !=3D NFPROTO_IPV6 &&
>> +		    stmt->reject.type !=3D NFT_REJECT_TCP_RST) {
>
> You can simplify the IPv4/IPv6 cases by doing:
>
>          case NFPROTO_IPV4:
>          case NFPROTO_IPV6:
>                  if (stmt->reject.family !=3D ctx->pctx.family)
> 			return stmt_error(ctx, stmt,
> 				  "conflicting protocols specified: ip vs ip6");
>
> OK?

Sure, ok.

>
>> +			return stmt_error(ctx, stmt,
>> +				  "conflicting protocols specified: ip6 vs ip");
>> +		}
>> +		break;
>> +	}
>> +
>> +	base =3D pctx->protocol[PROTO_BASE_NETWORK_HDR].desc;
>> +	desc =3D pctx->protocol[PROTO_BASE_TRANSPORT_HDR].desc;
>> +	/* No sufficient network and transport context */
>> +	if (base =3D=3D NULL || desc =3D=3D NULL) {
>
> You can simplify this code starting here... see below.
>
>> +		}
>> +		if (stmt->reject.icmp_code < 0) {
>> +			stmt->reject.type =3D NFT_REJECT_ICMP_UNREACH;
>> +			stmt->reject.icmp_code =3D ICMP_NET_UNREACH;
>> +		}
>>
>> +		if (stmt->reject.type =3D=3D NFT_REJECT_TCP_RST) {
>> +			return stmt_error(ctx, stmt,
>> +				    "insufficient context for using tcp-reset");
>> +		}
>> +		if (stmt->reject.icmp_code < 0) {
>> +			stmt->reject.type =3D NFT_REJECT_ICMP_UNREACH;
>> +			stmt->reject.icmp_code =3D ICMP_NET_UNREACH;
>> +		}
>> +	} else {
>> +		protonum =3D proto_find_num(base, desc);
>> +		switch (protonum) {
>> +		case IPPROTO_TCP:
>> +			if (stmt->reject.icmp_code >=3D 0 &&
>> +			    stmt->reject.type !=3D NFT_REJECT_TCP_RST) {
>> +				stmt->reject.type =3D NFT_REJECT_ICMP_UNREACH;
>> +				break;
>> +			} else
>> +				stmt->reject.type =3D NFT_REJECT_TCP_RST;
>> +			break;
>> +		default:
>> +			if (stmt->reject.type =3D=3D NFT_REJECT_TCP_RST) {
>> +				return stmt_error(ctx, stmt,
>> +				     "cannot use tcp-reset without a tcp rule");
>> +			}
>> +			if (stmt->reject.type !=3D NFT_REJECT_ICMP_UNREACH) {
>> +				stmt->reject.type =3D NFT_REJECT_ICMP_UNREACH;
>> +				stmt->reject.icmp_code =3D ICMP_NET_UNREACH;
>> +			}
>> +		}
>> +	}
>
> to something like:
>
>          protonum =3D proto_find_num(base, desc);
>          if (protonum =3D=3D IPPROTO_TCP) {
>                  ...
>                  return 0;
>          }
>
> 	if (stmt->reject.type =3D=3D NFT_REJECT_TCP_RST) {
> 		return stmt_error(ctx, stmt,
>                                    "specify ip protocol tcp with tcp-=
reset");
> 	} else if (stmt->reject.type !=3D NFT_REJECT_ICMP_UNREACH) {
> 		stmt->reject.type =3D NFT_REJECT_ICMP_UNREACH;
> 		stmt->reject.icmp_code =3D ICMP_NET_UNREACH;
> 	}
>
> You'll have to modify proto_find_num() to return -1 in case that base
> or desc are NULL.
>
> Don't forget to:
>
>    	stmt->flags |=3D STMT_F_TERMINAL;
>
> at the very beginning of stmt_evaluate_reject() as part of the
> simplification.

Oh look better like you say, I'm going to change it.

>
>>   	stmt->flags |=3D STMT_F_TERMINAL;
>>   	return 0;
>>   }
>> diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
>> index 5c6ca80..c57e164 100644
>> --- a/src/netlink_delinearize.c
>> +++ b/src/netlink_delinearize.c
>> @@ -14,6 +14,9 @@
>>   #include <string.h>
>>   #include <limits.h>
>>   #include <linux/netfilter/nf_tables.h>
>> +#include <arpa/inet.h>
>> +#include <linux/netfilter.h>
>> +#include <net/ethernet.h>
>>   #include <netlink.h>
>>   #include <rule.h>
>>   #include <statement.h>
>> @@ -456,6 +459,9 @@ static void netlink_parse_reject(struct netlink_=
parse_ctx *ctx,
>>   	struct stmt *stmt;
>>
>>   	stmt =3D reject_stmt_alloc(loc);
>> +	stmt->reject.type =3D nft_rule_expr_get_u32(expr, NFT_EXPR_REJECT_=
TYPE);
>> +	stmt->reject.icmp_code =3D nft_rule_expr_get_u8(expr,
>> +						      NFT_EXPR_REJECT_CODE);
>>   	list_add_tail(&stmt->list, &ctx->rule->stmts);
>>   }
>>
>> @@ -872,6 +878,34 @@ static void expr_postprocess(struct rule_pp_ctx=
 *ctx,
>>   	}
>>   }
>>
>> +static void stmt_reject_postprocess(struct rule_pp_ctx rctx, struct=
 stmt *stmt)
>> +{
>> +	const struct proto_desc *desc, *base;
>> +	int protocol;
>> +
>> +	switch (rctx.pctx.family) {
>> +	case NFPROTO_IPV4:
>> +	case NFPROTO_IPV6:
>> +		stmt->reject.family =3D rctx.pctx.family;
>> +		break;
>> +	case NFPROTO_INET:
>> +	case NFPROTO_BRIDGE:
>> +		if (rctx.pbase !=3D PROTO_BASE_INVALID) {
>
> Better:
>
>                  if (rctx.pbase =3D=3D PROTO_BASE_INVALID)
>                         return;
>
> So you can save one level of indentation in the code below...
>

Catched.

>> +			base =3D rctx.pctx.protocol[PROTO_BASE_LL_HDR].desc;
>> +			desc =3D rctx.pctx.protocol[PROTO_BASE_NETWORK_HDR].desc;
>> +			protocol =3D proto_find_num(base, desc);
>> +			if (protocol =3D=3D ETH_P_IP)
>> +				stmt->reject.family =3D NFPROTO_IPV4;
>> +			else if (protocol =3D=3D ETH_P_IPV6)
>> +				stmt->reject.family =3D NFPROTO_IPV6;
>> +			else
>> +				stmt->reject.family =3D protocol;
>> +		}
>> +		break;
>> +	default:
>> +		break;
>> +	}
>> +}
>>   static void rule_parse_postprocess(struct netlink_parse_ctx *ctx, =
struct rule *rule)
>>   {
>>   	struct rule_pp_ctx rctx;
>> @@ -899,6 +933,9 @@ static void rule_parse_postprocess(struct netlin=
k_parse_ctx *ctx, struct rule *r
>>   			if (stmt->nat.proto !=3D NULL)
>>   				expr_postprocess(&rctx, stmt, &stmt->nat.proto);
>>   			break;
>> +		case STMT_REJECT:
>> +			stmt_reject_postprocess(rctx, stmt);
>> +			break;
>>   		default:
>>   			break;
>>   		}
>> diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
>> index 5c1b46d..0e1d87c 100644
>> --- a/src/netlink_linearize.c
>> +++ b/src/netlink_linearize.c
>> @@ -609,7 +609,9 @@ static void netlink_gen_reject_stmt(struct netli=
nk_linearize_ctx *ctx,
>>
>>   	nle =3D alloc_nft_expr("reject");
>>   	nft_rule_expr_set_u32(nle, NFT_EXPR_REJECT_TYPE, stmt->reject.typ=
e);
>> -	nft_rule_expr_set_u8(nle, NFT_EXPR_REJECT_CODE, 0);
>> +	if (stmt->reject.icmp_code !=3D -1)
>> +		nft_rule_expr_set_u8(nle, NFT_EXPR_REJECT_CODE, stmt->reject.icmp=
_code);
>> +
>>   	nft_rule_add_expr(ctx->nlr, nle);
>>   }
>>
>> diff --git a/src/parser.y b/src/parser.y
>> index 3e08e21..5f15d9d 100644
>> --- a/src/parser.y
>> +++ b/src/parser.y
>> @@ -18,6 +18,8 @@
>>   #include <linux/netfilter.h>
>>   #include <linux/netfilter/nf_tables.h>
>>   #include <linux/netfilter/nf_conntrack_tuple_common.h>
>> +#include <netinet/ip_icmp.h>
>> +#include <netinet/icmp6.h>
>>   #include <libnftnl/common.h>
>>
>>   #include <rule.h>
>> @@ -359,6 +361,7 @@ static int monitor_lookup_event(const char *even=
t)
>>   %token WEEK			"week"
>>
>>   %token _REJECT			"reject"
>> +%token WITH			"with"
>>
>>   %token SNAT			"snat"
>>   %token DNAT			"dnat"
>> @@ -419,8 +422,8 @@ static int monitor_lookup_event(const char *even=
t)
>>   %type <stmt>			limit_stmt
>>   %destructor { stmt_free($$); }	limit_stmt
>>   %type <val>			time_unit
>> -%type <stmt>			reject_stmt
>> -%destructor { stmt_free($$); }	reject_stmt
>> +%type <stmt>			reject_stmt reject_stmt_alloc
>> +%destructor { stmt_free($$); }	reject_stmt reject_stmt_alloc
>>   %type <stmt>			nat_stmt nat_stmt_alloc
>>   %destructor { stmt_free($$); }	nat_stmt nat_stmt_alloc
>>   %type <stmt>			queue_stmt queue_stmt_alloc queue_range
>> @@ -1396,12 +1399,77 @@ time_unit		:	SECOND		{ $$ =3D 1ULL; }
>>   			|	WEEK		{ $$ =3D 1ULL * 60 * 60 * 24 * 7; }
>>   			;
>>
>> -reject_stmt		:	_REJECT
>> +reject_stmt		:	reject_stmt_alloc	reject_opts
>> +			;
>> +
>> +reject_stmt_alloc	:	_REJECT
>>   			{
>>   				$$ =3D reject_stmt_alloc(&@$);
>>   			}
>>   			;
>>
>> +reject_opts		:       /* empty */
>> +			{
>> +				$<stmt>0->reject.type =3D -1;
>> +				$<stmt>0->reject.icmp_code =3D -1;
>> +			}
>> +			|	WITH	STRING
>> +			{
>
> I think you can simplify this below by allocating a symbol:
>
>   $$ =3D symbol_expr_alloc(&@$, SYMBOL_VALUE,
>                          current_scope(state), $2);
>
> Then, use symbol_parse() from the evaluation path. You'll have to add
> a icmp_code_type datatype to src/datatype.c
>
> We'll need this sooner or later for matching by the icmp code support=
=2E
> This is currently missing.
>
> And you'll need to store the expression in stmt_reject instead of
> icmp_code. After the symbol_parse() you get a new expression which
> should be of value type.
>
>> +				if (strcmp($2, "icmp-net-unreach") =3D=3D 0) {
>> +					$<stmt>0->reject.icmp_code =3D ICMP_NET_UNREACH;
>> +					$<stmt>0->reject.family =3D NFPROTO_IPV4;
>> +					$<stmt>0->reject.type =3D NFT_REJECT_ICMP_UNREACH;
>> +				} else if (strcmp($2, "icmp-host-unreach") =3D=3D 0) {
>> +					$<stmt>0->reject.icmp_code =3D ICMP_HOST_UNREACH;
>> +					$<stmt>0->reject.family =3D NFPROTO_IPV4;
>> +					$<stmt>0->reject.type =3D NFT_REJECT_ICMP_UNREACH;
>> +				} else if (strcmp($2, "icmp-prot-unreach") =3D=3D 0) {
>> +					$<stmt>0->reject.icmp_code =3D ICMP_PROT_UNREACH;
>> +					$<stmt>0->reject.family =3D NFPROTO_IPV4;
>> +					$<stmt>0->reject.type =3D NFT_REJECT_ICMP_UNREACH;
>> +				} else if (strcmp($2, "icmp-port-unreach") =3D=3D 0) {
>> +					$<stmt>0->reject.icmp_code =3D ICMP_PORT_UNREACH;
>> +					$<stmt>0->reject.family =3D NFPROTO_IPV4;
>> +					$<stmt>0->reject.type =3D NFT_REJECT_ICMP_UNREACH;
>> +				} else if (strcmp($2, "icmp-net-prohibited") =3D=3D 0) {
>> +					$<stmt>0->reject.icmp_code =3D ICMP_NET_ANO;
>> +					$<stmt>0->reject.family =3D NFPROTO_IPV4;
>> +					$<stmt>0->reject.type =3D NFT_REJECT_ICMP_UNREACH;
>> +				} else if (strcmp($2, "icmp-host-prohibited") =3D=3D 0) {
>> +					$<stmt>0->reject.icmp_code =3D ICMP_HOST_ANO;
>> +					$<stmt>0->reject.family =3D NFPROTO_IPV4;
>> +					$<stmt>0->reject.type =3D NFT_REJECT_ICMP_UNREACH;
>> +				} else if (strcmp($2, "icmp-admin-prohibited") =3D=3D 0) {
>> +					$<stmt>0->reject.icmp_code =3D ICMP_PKT_FILTERED;
>> +					$<stmt>0->reject.family =3D NFPROTO_IPV4;
>> +					$<stmt>0->reject.type =3D NFT_REJECT_ICMP_UNREACH;
>> +				} else if (strcmp($2, "icmpv6-no-route") =3D=3D 0) {
>> +					$<stmt>0->reject.icmp_code =3D ICMP6_DST_UNREACH_NOROUTE;
>> +					$<stmt>0->reject.family =3D NFPROTO_IPV6;
>> +					$<stmt>0->reject.type =3D NFT_REJECT_ICMP_UNREACH;
>> +				} else if (strcmp($2, "icmpv6-admin-prohibited") =3D=3D 0) {
>> +					$<stmt>0->reject.icmp_code =3D ICMP6_DST_UNREACH_ADMIN;
>> +					$<stmt>0->reject.family =3D NFPROTO_IPV6;
>> +					$<stmt>0->reject.type =3D NFT_REJECT_ICMP_UNREACH;
>> +				} else if (strcmp($2, "icmpv6-addr-unreach") =3D=3D 0) {
>> +					$<stmt>0->reject.icmp_code =3D ICMP6_DST_UNREACH_ADDR;
>> +					$<stmt>0->reject.family =3D NFPROTO_IPV6;
>> +					$<stmt>0->reject.type =3D NFT_REJECT_ICMP_UNREACH;
>> +				} else if (strcmp($2, "icmpv6-port-unreach") =3D=3D 0) {
>> +					$<stmt>0->reject.icmp_code =3D ICMP6_DST_UNREACH_NOPORT;
>> +					$<stmt>0->reject.family =3D NFPROTO_IPV6;
>> +					$<stmt>0->reject.type =3D NFT_REJECT_ICMP_UNREACH;
>> +				} else if (strcmp($2, "tcp-reset") =3D=3D 0) {
>> +					$<stmt>0->reject.type =3D NFT_REJECT_TCP_RST;
>> +					$<stmt>0->reject.icmp_code =3D -1;
>> +				} else {
>> +					erec_queue(error(&@2, "invalid icmp code type '%s'",
>> +							 $2), state->msgs);
>> +					YYERROR;
>> +				}
>> +			}
>> +			;
>> +
>>   nat_stmt		:	nat_stmt_alloc	nat_stmt_args
>>   			;
>>
>> diff --git a/src/payload.c b/src/payload.c
>> index a1785a5..76c4ce1 100644
>> --- a/src/payload.c
>> +++ b/src/payload.c
>> @@ -183,11 +183,32 @@ int payload_gen_dependency(struct eval_ctx *ct=
x, const struct expr *expr,
>>   	}
>>
>>   	desc =3D ctx->pctx.protocol[expr->payload.base - 1].desc;
>> -	/* Special case for mixed IPv4/IPv6 tables: use meta L4 proto */
>> -	if (desc =3D=3D NULL &&
>> -	    ctx->pctx.family =3D=3D NFPROTO_INET &&
>> -	    expr->payload.base =3D=3D PROTO_BASE_TRANSPORT_HDR)
>> -		desc =3D &proto_inet_service;
>> +	/* Special case for mixed IPv4/IPv6 and bridge tables */
>> +	if (desc =3D=3D NULL) {
>> +		switch (ctx->pctx.family) {
>> +		case NFPROTO_INET:
>> +			switch (expr->payload.base) {
>> +			case PROTO_BASE_TRANSPORT_HDR:
>> +				desc =3D &proto_inet_service;
>> +				break;
>> +			case PROTO_BASE_LL_HDR:
>> +				desc =3D &proto_inet;
>> +				break;
>
> This PROTO_BASE_LL_HDR case is new, what are you catching up with
> this?

To add new dependencies for the network layer. First, to make sure if=20
the network protocol associated to the payload generate is supported fo=
r=20
the inet family. Second, use it for creating the new expression for=20
creating the new network protocol dependency.

Code in payload_gen_dependency (src/payload.c):

1-. We test it

protocol =3D proto_find_num(desc, expr->payload.desc);
if (protocol < 0)
	...

2-. And later, we create the new expresion and we use it:
=2E..
	left =3D payload_expr_alloc(&expr->location, desc,
				  desc->protocol_key);
=2E..

>
>> +			default:
>> +				break;
>> +			}
>> +			break;
>> +		case NFPROTO_BRIDGE:
>> +			switch (expr->payload.base)
>> +			case PROTO_BASE_LL_HDR:
>> +				desc =3D &proto_eth;
>> +				break;
>
> And why didn't we need this so far?

Look like that is the first time that we need this kind of dependencies=
=20
in bridge. I try to find another answer more complete but look like tha=
t.

>
>> +			default:
>> +				break;
>> +			}
>> +			break;
>> +		}
>> +	}
>>
>>   	if (desc =3D=3D NULL)
>>   		return expr_error(ctx->msgs, expr,
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
