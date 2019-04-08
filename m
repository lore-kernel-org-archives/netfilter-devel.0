Return-Path: <SRS0=Xgm7=SK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7ED25C10F13
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Apr 2019 22:14:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 343C321473
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Apr 2019 22:14:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726387AbfDHWOR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 8 Apr 2019 18:14:17 -0400
Received: from mail.us.es ([193.147.175.20]:51450 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726343AbfDHWOR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Apr 2019 18:14:17 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 430613066A2
        for <netfilter-devel@vger.kernel.org>; Tue,  9 Apr 2019 00:14:12 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2A6C8DA714
        for <netfilter-devel@vger.kernel.org>; Tue,  9 Apr 2019 00:14:12 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 29582DA718; Tue,  9 Apr 2019 00:14:12 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BE492DA717;
        Tue,  9 Apr 2019 00:14:09 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 09 Apr 2019 00:14:09 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 9C3244265A31;
        Tue,  9 Apr 2019 00:14:09 +0200 (CEST)
Date:   Tue, 9 Apr 2019 00:14:09 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nftables] src: add nat support for the inet family
Message-ID: <20190408221409.j7b6kk5yd6a2n3fk@salvia>
References: <20190327073208.9517-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190327073208.9517-1-fw@strlen.de>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Mar 27, 2019 at 08:32:08AM +0100, Florian Westphal wrote:
> consider a simple ip6 nat table:
> 
> table ip6 nat { chain output {
>   type nat hook output priority 0; policy accept;
>   dnat to dead:2::99
> }
> 
> Now consider same ruleset, but using 'table inet nat':
> nft now lacks context to determine address family to parse 'to $address'.
> 
> This adds code to make the following work:
> 
> table inet nat { [ .. ]
>   # detect af from network protocol context:
>   ip6 daddr dead::2::1 dnat to dead:2::99
> 
>   # use new dnat ip6 keyword:
>   dnat ip6 to dead:2::99
>   }
> 
> On list side, the keyword is only shown in the inet family, else the
> short version (dnat to ...) is used as the family is redundant when the
> table already mandates the ip protocol version supported.
> 
> Address mismatches such as
> 
> table ip6 { ..
> 	dnat ip to 1.2.3.4
> 
> are detected/handled during the evaluation phase.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>

Thanks!
>  
>  extern struct stmt *nat_stmt_alloc(const struct location *loc,
> diff --git a/src/evaluate.c b/src/evaluate.c
> index 54afc3340186..4914129711b8 100644
> --- a/src/evaluate.c
> +++ b/src/evaluate.c
> @@ -2504,9 +2504,28 @@ static int stmt_evaluate_reject(struct eval_ctx *ctx, struct stmt *stmt)
>  
>  static int nat_evaluate_family(struct eval_ctx *ctx, struct stmt *stmt)
>  {
> +	const struct proto_desc *nproto;
> +
>  	switch (ctx->pctx.family) {
>  	case NFPROTO_IPV4:
>  	case NFPROTO_IPV6:
> +		if (stmt->nat.family == NFPROTO_UNSPEC)
> +			stmt->nat.family = ctx->pctx.family;
> +		return 0;
> +	case NFPROTO_INET:
> +		if (!stmt->nat.addr)
> +			return 0;
> +
> +		if (stmt->nat.family != NFPROTO_UNSPEC)
> +			return 0;
> +
> +		nproto = ctx->pctx.protocol[PROTO_BASE_NETWORK_HDR].desc;
> +
> +		if (nproto == &proto_ip)
> +			stmt->nat.family = NFPROTO_IPV4;
> +		else if (nproto == &proto_ip6)
> +			stmt->nat.family = NFPROTO_IPV6;
> +
>  		return 0;
>  	default:
>  		return stmt_error(ctx, stmt,
> @@ -2548,6 +2567,53 @@ static int nat_evaluate_transport(struct eval_ctx *ctx, struct stmt *stmt,
>  				 BYTEORDER_BIG_ENDIAN, expr);
>  }
>  
> +static int stmt_evaluate_l3proto(struct eval_ctx *ctx,
> +				 struct stmt *stmt, uint8_t family)
> +{
> +	const struct proto_desc *nproto;
> +
> +	nproto = ctx->pctx.protocol[PROTO_BASE_NETWORK_HDR].desc;
> +
> +	if ((nproto == &proto_ip && family != NFPROTO_IPV4) ||
> +	    (nproto == &proto_ip6 && family != NFPROTO_IPV6))
> +		return stmt_error(ctx, stmt,
> +				  "Conflicting network layer protocols (context %s vs. family %d)",
> +				  nproto->name, family);
> +	return 0;
> +}
> +
> +static int stmt_evaluate_addr(struct eval_ctx *ctx, struct stmt *stmt,
> +			      uint8_t family,
> +			      struct expr **addr)
> +{
> +	const struct datatype *dtype;
> +	unsigned int len;
> +	int err;
> +
> +	if (ctx->pctx.family == NFPROTO_INET) {
> +		switch (family) {
> +		case NFPROTO_IPV4:
> +			dtype = &ipaddr_type;
> +			len   = 4 * BITS_PER_BYTE;
> +			break;
> +		case NFPROTO_IPV6:
> +			dtype = &ip6addr_type;
> +			len   = 16 * BITS_PER_BYTE;
> +			break;
> +		default:
> +			return stmt_error(ctx, stmt,
> +					  "ip or ip6 must be specified with address for inet tables.");
> +		}
> +
> +		err = stmt_evaluate_arg(ctx, stmt, dtype, len,
> +					BYTEORDER_BIG_ENDIAN, addr);
> +	} else {
> +		err = evaluate_addr(ctx, stmt, addr);
> +	}
> +
> +	return err;
> +}
> +
>  static int stmt_evaluate_nat(struct eval_ctx *ctx, struct stmt *stmt)
>  {
>  	int err;
> @@ -2557,7 +2623,12 @@ static int stmt_evaluate_nat(struct eval_ctx *ctx, struct stmt *stmt)
>  		return err;
>  
>  	if (stmt->nat.addr != NULL) {
> -		err = evaluate_addr(ctx, stmt, &stmt->nat.addr);
> +		err = stmt_evaluate_l3proto(ctx, stmt, stmt->nat.family);
> +		if (err < 0)
> +			return err;
> +
> +		err = stmt_evaluate_addr(ctx, stmt, stmt->nat.family,
> +					 &stmt->nat.addr);
>  		if (err < 0)
>  			return err;
>  	}
> @@ -2573,9 +2644,7 @@ static int stmt_evaluate_nat(struct eval_ctx *ctx, struct stmt *stmt)
>  
>  static int stmt_evaluate_tproxy(struct eval_ctx *ctx, struct stmt *stmt)
>  {
> -	const struct proto_desc *nproto;
> -	const struct datatype *dtype;
> -	int err, len;
> +	int err;
>  
>  	switch (ctx->pctx.family) {
>  	case NFPROTO_IPV4:
> @@ -2597,43 +2666,19 @@ static int stmt_evaluate_tproxy(struct eval_ctx *ctx, struct stmt *stmt)
>  	if (!stmt->tproxy.addr && !stmt->tproxy.port)
>  		return stmt_error(ctx, stmt, "Either address or port must be specified!");
>  
> -	nproto = ctx->pctx.protocol[PROTO_BASE_NETWORK_HDR].desc;
> -	if ((nproto == &proto_ip && stmt->tproxy.family != NFPROTO_IPV4) ||
> -	    (nproto == &proto_ip6 && stmt->tproxy.family != NFPROTO_IPV6))
> -		/* this prevents us from rules like
> -		 * ip protocol tcp tproxy ip6 to [dead::beef]
> -		 */
> -		return stmt_error(ctx, stmt,
> -				  "Conflicting network layer protocols.");
> +	err = stmt_evaluate_l3proto(ctx, stmt, stmt->tproxy.family);
> +	if (err < 0)
> +		return err;
>  
>  	if (stmt->tproxy.addr != NULL) {
>  		if (stmt->tproxy.addr->etype == EXPR_RANGE)
>  			return stmt_error(ctx, stmt, "Address ranges are not supported for tproxy.");
> -		if (ctx->pctx.family == NFPROTO_INET) {
> -			switch (stmt->tproxy.family) {
> -			case NFPROTO_IPV4:
> -				dtype = &ipaddr_type;
> -				len   = 4 * BITS_PER_BYTE;
> -				break;
> -			case NFPROTO_IPV6:
> -				dtype = &ip6addr_type;
> -				len   = 16 * BITS_PER_BYTE;
> -				break;
> -			default:
> -				return stmt_error(ctx, stmt,
> -						  "Family must be specified in tproxy statement with address for inet tables.");
> -			}
> -			err = stmt_evaluate_arg(ctx, stmt, dtype, len,
> -						BYTEORDER_BIG_ENDIAN,
> -						&stmt->tproxy.addr);
> -			if (err < 0)
> -				return err;
> -		}
> -		else {
> -			err = evaluate_addr(ctx, stmt, &stmt->tproxy.addr);
> -			if (err < 0)
> -				return err;
> -		}
> +
> +		err = stmt_evaluate_addr(ctx, stmt, stmt->tproxy.family,
> +					 &stmt->tproxy.addr);
> +
> +		if (err < 0)
> +			return err;
>  	}
>  
>  	if (stmt->tproxy.port != NULL) {
> diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
> index d0eaf5b62203..7b09dba60a2c 100644
> --- a/src/netlink_delinearize.c
> +++ b/src/netlink_delinearize.c
> @@ -930,6 +930,9 @@ static void netlink_parse_nat(struct netlink_parse_ctx *ctx,
>  
>  	family = nftnl_expr_get_u32(nle, NFTNL_EXPR_NAT_FAMILY);
>  
> +	if (ctx->table->handle.family == NFPROTO_INET)
> +		stmt->nat.family = family;
> +
>  	if (nftnl_expr_is_set(nle, NFTNL_EXPR_NAT_FLAGS))
>  		stmt->nat.flags = nftnl_expr_get_u32(nle, NFTNL_EXPR_NAT_FLAGS);
>  
> diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
> index 61149bffcc83..df40ee7b6cff 100644
> --- a/src/netlink_linearize.c
> +++ b/src/netlink_linearize.c
> @@ -1024,7 +1024,7 @@ static void netlink_gen_nat_stmt(struct netlink_linearize_ctx *ctx,
>  		nle = alloc_nft_expr("nat");
>  		nftnl_expr_set_u32(nle, NFTNL_EXPR_NAT_TYPE, stmt->nat.type);
>  
> -		family = nftnl_rule_get_u32(ctx->nlr, NFTNL_RULE_FAMILY);
> +		family = stmt->nat.family;
>  		nftnl_expr_set_u32(nle, NFTNL_EXPR_NAT_FAMILY, family);
>  
>  		nftnl_flag_attr = NFTNL_EXPR_NAT_FLAGS;
> diff --git a/src/parser_bison.y b/src/parser_bison.y
> index 65b3fb3ebac2..9764b7e13aa6 100644
> --- a/src/parser_bison.y
> +++ b/src/parser_bison.y
> @@ -2810,6 +2810,11 @@ nat_stmt_args		:	stmt_expr
>  			{
>  				$<stmt>0->nat.addr = $2;
>  			}
> +			|	nf_key_proto	TO	stmt_expr
> +			{
> +				$<stmt>0->nat.family = $1;
> +				$<stmt>0->nat.addr = $3;
> +			}
>  			|	stmt_expr	COLON	stmt_expr
>  			{
>  				$<stmt>0->nat.addr = $1;
> @@ -2820,6 +2825,12 @@ nat_stmt_args		:	stmt_expr
>  				$<stmt>0->nat.addr = $2;
>  				$<stmt>0->nat.proto = $4;
>  			}
> +			|	nf_key_proto	TO	 stmt_expr	COLON	stmt_expr
> +			{
> +				$<stmt>0->nat.family = $1;
> +				$<stmt>0->nat.addr = $3;
> +				$<stmt>0->nat.proto = $5;
> +			}
>  			|	COLON		stmt_expr
>  			{
>  				$<stmt>0->nat.proto = $2;
> diff --git a/src/statement.c b/src/statement.c
> index b9324fd7b2ed..de74a15529b0 100644
> --- a/src/statement.c
> +++ b/src/statement.c
> @@ -567,8 +567,18 @@ const char *nat_etype2str(enum nft_nat_etypes type)
>  static void nat_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
>  {
>  	nft_print(octx, "%s", nat_etype2str(stmt->nat.type));
> -	if (stmt->nat.addr || stmt->nat.proto)
> +	if (stmt->nat.addr || stmt->nat.proto) {
> +		switch (stmt->nat.family) {
> +		case NFPROTO_IPV4:
> +			nft_print(octx, " ip");
> +			break;
> +		case NFPROTO_IPV6:
> +			nft_print(octx, " ip6");
> +			break;
> +		}
> +
>  		nft_print(octx, " to");
> +	}
>  
>  	if (stmt->nat.addr) {
>  		nft_print(octx, " ");
> diff --git a/tests/py/inet/dnat.t b/tests/py/inet/dnat.t
> new file mode 100644
> index 000000000000..fcdf9436c676
> --- /dev/null
> +++ b/tests/py/inet/dnat.t
> @@ -0,0 +1,16 @@
> +:prerouting;type nat hook prerouting priority 0
> +
> +*inet;test-inet;prerouting
> +
> +iifname "foo" tcp dport 80 redirect to :8080;ok
> +
> +iifname "eth0" tcp dport 443 dnat ip to 192.168.3.2;ok
> +iifname "eth0" tcp dport 443 dnat ip6 to [dead::beef]:4443;ok
> +
> +dnat ip to ct mark map { 0x00000014 : 1.2.3.4};ok
> +dnat ip to ct mark . ip daddr map { 0x00000014 . 1.1.1.1 : 1.2.3.4};ok
> +
> +dnat ip6 to 1.2.3.4;fail
> +dnat to 1.2.3.4;fail
> +dnat ip6 to ct mark . ip daddr map { 0x00000014 . 1.1.1.1 : 1.2.3.4};fail
> +ip6 daddr dead::beef dnat to 10.1.2.3;fail
> diff --git a/tests/py/inet/dnat.t.payload b/tests/py/inet/dnat.t.payload
> new file mode 100644
> index 000000000000..b81caf7bc66d
> --- /dev/null
> +++ b/tests/py/inet/dnat.t.payload
> @@ -0,0 +1,54 @@
> +# iifname "foo" tcp dport 80 redirect to :8080
> +inet test-inet prerouting
> +  [ meta load iifname => reg 1 ]
> +  [ cmp eq reg 1 0x006f6f66 0x00000000 0x00000000 0x00000000 ]
> +  [ meta load l4proto => reg 1 ]
> +  [ cmp eq reg 1 0x00000006 ]
> +  [ payload load 2b @ transport header + 2 => reg 1 ]
> +  [ cmp eq reg 1 0x00005000 ]
> +  [ immediate reg 1 0x0000901f ]
> +  [ redir proto_min reg 1 ]
> +
> +# iifname "eth0" tcp dport 443 dnat ip to 192.168.3.2
> +inet test-inet prerouting
> +  [ meta load iifname => reg 1 ]
> +  [ cmp eq reg 1 0x30687465 0x00000000 0x00000000 0x00000000 ]
> +  [ meta load l4proto => reg 1 ]
> +  [ cmp eq reg 1 0x00000006 ]
> +  [ payload load 2b @ transport header + 2 => reg 1 ]
> +  [ cmp eq reg 1 0x0000bb01 ]
> +  [ immediate reg 1 0x0203a8c0 ]
> +  [ nat dnat ip addr_min reg 1 addr_max reg 0 ]
> +
> +# iifname "eth0" tcp dport 443 dnat ip6 to [dead::beef]:4443
> +inet test-inet prerouting
> +  [ meta load iifname => reg 1 ]
> +  [ cmp eq reg 1 0x30687465 0x00000000 0x00000000 0x00000000 ]
> +  [ meta load l4proto => reg 1 ]
> +  [ cmp eq reg 1 0x00000006 ]
> +  [ payload load 2b @ transport header + 2 => reg 1 ]
> +  [ cmp eq reg 1 0x0000bb01 ]
> +  [ immediate reg 1 0x0000adde 0x00000000 0x00000000 0xefbe0000 ]
> +  [ immediate reg 2 0x00005b11 ]
> +  [ nat dnat ip6 addr_min reg 1 addr_max reg 0 proto_min reg 2 proto_max reg 0 ]
> +
> +# dnat ip to ct mark map { 0x00000014 : 1.2.3.4}
> +__map%d test-inet b size 1
> +__map%d test-inet 0
> +        element 00000014  : 04030201 0 [end]
> +inet test-inet prerouting
> +  [ ct load mark => reg 1 ]
> +  [ lookup reg 1 set __map%d dreg 1 ]
> +  [ nat dnat ip addr_min reg 1 addr_max reg 0 ]
> +
> +# dnat ip to ct mark . ip daddr map { 0x00000014 . 1.1.1.1 : 1.2.3.4}
> +__map%d test-inet b size 1
> +__map%d test-inet 0
> +        element 00000014 01010101  : 04030201 0 [end]
> +inet test-inet prerouting
> +  [ meta load nfproto => reg 1 ]
> +  [ cmp eq reg 1 0x00000002 ]
> +  [ ct load mark => reg 1 ]
> +  [ payload load 4b @ network header + 16 => reg 9 ]
> +  [ lookup reg 1 set __map%d dreg 1 ]
> +  [ nat dnat ip addr_min reg 1 addr_max reg 0 ]
> diff --git a/tests/py/inet/snat.t b/tests/py/inet/snat.t
> new file mode 100644
> index 000000000000..cf23b5cff1bb
> --- /dev/null
> +++ b/tests/py/inet/snat.t
> @@ -0,0 +1,21 @@
> +:postrouting;type nat hook postrouting priority 0
> +
> +*inet;test-inet;postrouting
> +
> +# explicit family: 'snat to ip':
> +iifname "eth0" tcp dport 81 snat ip to 192.168.3.2;ok
> +
> +# infer snat target family from network header base:
> +iifname "eth0" tcp dport 81 ip saddr 10.1.1.1 snat to 192.168.3.2;ok;iifname "eth0" tcp dport 81 ip saddr 10.1.1.1 snat ip to 192.168.3.2
> +iifname "eth0" tcp dport 81 snat ip6 to dead::beef;ok
> +
> +iifname "foo" masquerade random;ok
> +
> +
> +snat to 192.168.3.2;fail
> +snat ip6 to 192.168.3.2;fail
> +snat to dead::beef;fail
> +snat ip to dead::beef;fail
> +snat ip daddr 1.2.3.4 to dead::beef;fail
> +snat ip daddr 1.2.3.4 ip6 to dead::beef;fail
> +snat ip6 saddr dead::beef to 1.2.3.4;fail
> diff --git a/tests/py/inet/snat.t.payload b/tests/py/inet/snat.t.payload
> new file mode 100644
> index 000000000000..00bb937fd843
> --- /dev/null
> +++ b/tests/py/inet/snat.t.payload
> @@ -0,0 +1,42 @@
> +# iifname "eth0" tcp dport 81 snat ip to 192.168.3.2
> +inet test-inet postrouting
> +  [ meta load iifname => reg 1 ]
> +  [ cmp eq reg 1 0x30687465 0x00000000 0x00000000 0x00000000 ]
> +  [ meta load l4proto => reg 1 ]
> +  [ cmp eq reg 1 0x00000006 ]
> +  [ payload load 2b @ transport header + 2 => reg 1 ]
> +  [ cmp eq reg 1 0x00005100 ]
> +  [ immediate reg 1 0x0203a8c0 ]
> +  [ nat snat ip addr_min reg 1 addr_max reg 0 ]
> +
> +# iifname "eth0" tcp dport 81 ip saddr 10.1.1.1 snat to 192.168.3.2
> +inet test-inet postrouting
> +  [ meta load iifname => reg 1 ]
> +  [ cmp eq reg 1 0x30687465 0x00000000 0x00000000 0x00000000 ]
> +  [ meta load l4proto => reg 1 ]
> +  [ cmp eq reg 1 0x00000006 ]
> +  [ payload load 2b @ transport header + 2 => reg 1 ]
> +  [ cmp eq reg 1 0x00005100 ]
> +  [ meta load nfproto => reg 1 ]
> +  [ cmp eq reg 1 0x00000002 ]
> +  [ payload load 4b @ network header + 12 => reg 1 ]
> +  [ cmp eq reg 1 0x0101010a ]
> +  [ immediate reg 1 0x0203a8c0 ]
> +  [ nat snat ip addr_min reg 1 addr_max reg 0 ]
> +
> +# iifname "eth0" tcp dport 81 snat ip6 to dead::beef
> +inet test-inet postrouting
> +  [ meta load iifname => reg 1 ]
> +  [ cmp eq reg 1 0x30687465 0x00000000 0x00000000 0x00000000 ]
> +  [ meta load l4proto => reg 1 ]
> +  [ cmp eq reg 1 0x00000006 ]
> +  [ payload load 2b @ transport header + 2 => reg 1 ]
> +  [ cmp eq reg 1 0x00005100 ]
> +  [ immediate reg 1 0x0000adde 0x00000000 0x00000000 0xefbe0000 ]
> +  [ nat snat ip6 addr_min reg 1 addr_max reg 0 ]
> +
> +# iifname "foo" masquerade random
> +inet test-inet postrouting
> +  [ meta load iifname => reg 1 ]
> +  [ cmp eq reg 1 0x006f6f66 0x00000000 0x00000000 0x00000000 ]
> +  [ masq flags 0x4 ]
> -- 
> 2.19.2
> 
