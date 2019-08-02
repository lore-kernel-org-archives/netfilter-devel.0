Return-Path: <SRS0=xWIb=V6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1577C32750
	for <netfilter-devel@archiver.kernel.org>; Fri,  2 Aug 2019 09:21:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6720C20665
	for <netfilter-devel@archiver.kernel.org>; Fri,  2 Aug 2019 09:21:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="MATOkN//"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388134AbfHBJVa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 2 Aug 2019 05:21:30 -0400
Received: from mx1.riseup.net ([198.252.153.129]:54654 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731644AbfHBJVa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 2 Aug 2019 05:21:30 -0400
Received: from bell.riseup.net (bell-pn.riseup.net [10.0.1.178])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id BE92E1B8FBF
        for <netfilter-devel@vger.kernel.org>; Fri,  2 Aug 2019 02:21:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1564737689; bh=dFy1riJg840a8Vvah75plq1hBz+MSLDGIdKUuSAu9hY=;
        h=Date:In-Reply-To:References:Subject:To:From:From;
        b=MATOkN//HIS0nrur+s5xuPlMyAo4ME6I52i/pm6Auh7PkszOfgXtPpBC2isHGA+hO
         a5tF30ZU/x4E9wXBhcowe6pgQ7vpPJxsCH2plrFSuE8TSH3fRlcV44iKpwqaUK2nzO
         4UNRROqdimUfxr9ukPQn+pafeOoLFEDEqY8o7J6k=
X-Riseup-User-ID: 51D0F952E1D3A8CFBD4ACCCDEC4F41154F8CE6BB4AD5AF6B47D0C9B0A87F09FD
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by bell.riseup.net (Postfix) with ESMTPSA id D47DB223192
        for <netfilter-devel@vger.kernel.org>; Fri,  2 Aug 2019 02:21:27 -0700 (PDT)
Date:   Fri, 02 Aug 2019 11:21:22 +0200
In-Reply-To: <20190802091335.10778-2-ffmancera@riseup.net>
References: <20190802091335.10778-1-ffmancera@riseup.net> <20190802091335.10778-2-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 1/2 nft v3] src: allow variables in the chain priority specification
To:     netfilter-devel@vger.kernel.org
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
Message-ID: <DED66911-1FB7-4B4D-84D2-B32470A295F5@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Oh, I missed a detail in this patch=2E I am going to send a v4 in a few min=
utes=2E Sorry!=20
El 2 de agosto de 2019 11:13:35 CEST, Fernando Fernandez Mancera <ffmancer=
a@riseup=2Enet> escribi=C3=B3:
>This patch introduces the use of nft input files variables in chain
>priority
>specification=2E e=2Eg=2E
>
>define pri =3D filter
>define prinum =3D 10
>define priplusnum =3D "filter - 150"
>
>add table ip foo
>add chain ip foo bar {type filter hook input priority $pri;}
>add chain ip foo ber {type filter hook input priority $prinum;}
>add chain ip foo bor {type filter hook input priority $priplusnum;}
>
>table ip foo {
>	chain bar {
>		type filter hook input priority filter; policy accept;
>	}
>
>	chain ber {
>		type filter hook input priority filter + 10; policy accept;
>	}
>
>	chain bor {
>		type filter hook input priority mangle; policy accept;
>	}
>}
>
>Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup=2Enet>
>---
> include/datatype=2Eh                            |  1 +
> include/rule=2Eh                                |  7 +--
> src/datatype=2Ec                                | 26 ++++++++
> src/evaluate=2Ec                                | 63 ++++++++++++++-----
> src/json=2Ec                                    | 11 +++-
> src/mnl=2Ec                                     | 13 ++--
> src/netlink=2Ec                                 | 22 +++++--
> src/parser_bison=2Ey                            | 35 +++++++++--
> src/parser_json=2Ec                             | 11 +++-
> src/rule=2Ec                                    | 15 ++---
> =2E=2E=2E/testcases/nft-f/0021priority_variable_0   | 17 +++++
> =2E=2E=2E/testcases/nft-f/0022priority_variable_0   | 17 +++++
> =2E=2E=2E/testcases/nft-f/0023priority_variable_1   | 18 ++++++
> =2E=2E=2E/testcases/nft-f/0024priority_variable_1   | 18 ++++++
> =2E=2E=2E/nft-f/dumps/0021priority_variable_0=2Enft   |  5 ++
> =2E=2E=2E/nft-f/dumps/0022priority_variable_0=2Enft   |  5 ++
> 16 files changed, 238 insertions(+), 46 deletions(-)
> mode change 100644 =3D> 100755 src/evaluate=2Ec
> create mode 100755 tests/shell/testcases/nft-f/0021priority_variable_0
> create mode 100755 tests/shell/testcases/nft-f/0022priority_variable_0
> create mode 100755 tests/shell/testcases/nft-f/0023priority_variable_1
> create mode 100755 tests/shell/testcases/nft-f/0024priority_variable_1
>create mode 100644
>tests/shell/testcases/nft-f/dumps/0021priority_variable_0=2Enft
>create mode 100644
>tests/shell/testcases/nft-f/dumps/0022priority_variable_0=2Enft
>
>diff --git a/include/datatype=2Eh b/include/datatype=2Eh
>index 63617eb=2E=2E1b012d5 100644
>--- a/include/datatype=2Eh
>+++ b/include/datatype=2Eh
>@@ -256,6 +256,7 @@ extern const struct datatype icmpx_code_type;
> extern const struct datatype igmp_type_type;
> extern const struct datatype time_type;
> extern const struct datatype boolean_type;
>+extern const struct datatype priority_type;
>=20
>void inet_service_type_print(const struct expr *expr, struct output_ctx
>*octx);
>=20
>diff --git a/include/rule=2Eh b/include/rule=2Eh
>index ee881b9=2E=2Ea071531 100644
>--- a/include/rule=2Eh
>+++ b/include/rule=2Eh
>@@ -174,13 +174,10 @@ enum chain_flags {
>  * struct prio_spec - extendend priority specification for mixed
>  *                    textual/numerical parsing=2E
>  *
>- * @str:  name of the standard priority value
>- * @num:  Numerical value=2E This MUST contain the parsed value of str
>after
>- *        evaluation=2E
>+ * @expr:  expr of the standard priority value
>  */
> struct prio_spec {
>-	const char  *str;
>-	int          num;
>+	struct expr	*expr;
> 	struct location loc;
> };
>=20
>diff --git a/src/datatype=2Ec b/src/datatype=2Ec
>index 6d6826e=2E=2Eb7418e7 100644
>--- a/src/datatype=2Ec
>+++ b/src/datatype=2Ec
>@@ -1246,3 +1246,29 @@ const struct datatype boolean_type =3D {
> 	=2Esym_tbl	=3D &boolean_tbl,
> 	=2Ejson		=3D boolean_type_json,
> };
>+
>+static struct error_record *priority_type_parse(const struct expr
>*sym,
>+						struct expr **res)
>+{
>+	int num;
>+
>+	if (isdigit(sym->identifier[0])) {
>+		num =3D atoi(sym->identifier);
>+		*res =3D constant_expr_alloc(&sym->location, &integer_type,
>+					   BYTEORDER_HOST_ENDIAN,
>+					   sizeof(int) * BITS_PER_BYTE,
>+					   &num);
>+	} else
>+		*res =3D constant_expr_alloc(&sym->location, &string_type,
>+					   BYTEORDER_HOST_ENDIAN,
>+					   strlen(sym->identifier) *
>+					   BITS_PER_BYTE, sym->identifier);
>+	return NULL;
>+}
>+
>+const struct datatype priority_type =3D {
>+	=2Etype		=3D TYPE_STRING,
>+	=2Ename		=3D "priority",
>+	=2Edesc		=3D "priority type",
>+	=2Eparse		=3D priority_type_parse,
>+};
>diff --git a/src/evaluate=2Ec b/src/evaluate=2Ec
>old mode 100644
>new mode 100755
>index 48c65cd=2E=2E0ea8090
>--- a/src/evaluate=2Ec
>+++ b/src/evaluate=2Ec
>@@ -3241,19 +3241,54 @@ static int set_evaluate(struct eval_ctx *ctx,
>struct set *set)
> 	return 0;
> }
>=20
>-static bool evaluate_priority(struct prio_spec *prio, int family, int
>hook)
>+static bool evaluate_priority(struct eval_ctx *ctx, struct prio_spec
>*prio,
>+			      int family, int hook)
> {
>+	char prio_str[NFT_NAME_MAXLEN];
>+	char prio_fst[NFT_NAME_MAXLEN];
>+	struct location loc;
> 	int priority;
>+	int prio_snd;
>+	char op;
>=20
>-	/* A numeric value has been used to specify priority=2E */
>-	if (prio->str =3D=3D NULL)
>+	ctx->ectx=2Edtype =3D &priority_type;
>+	ctx->ectx=2Elen =3D NFT_NAME_MAXLEN * BITS_PER_BYTE;
>+	if (expr_evaluate(ctx, &prio->expr) < 0)
>+		return false;
>+	if (prio->expr->etype !=3D EXPR_VALUE) {
>+		expr_error(ctx->msgs, prio->expr, "%s is not a valid "
>+			   "priority expression", expr_name(prio->expr));
>+		return false;
>+	}
>+	if (prio->expr->dtype->type =3D=3D TYPE_INTEGER)
> 		return true;
>=20
>-	priority =3D std_prio_lookup(prio->str, family, hook);
>-	if (priority =3D=3D NF_IP_PRI_LAST)
>-		return false;
>-	prio->num +=3D priority;
>+	mpz_export_data(prio_str, prio->expr->value,
>+			BYTEORDER_HOST_ENDIAN,
>+			NFT_NAME_MAXLEN);
>+	loc =3D prio->expr->location;
>+	expr_free(prio->expr);
>=20
>+	if (sscanf(prio_str, "%s %c %d", prio_fst, &op, &prio_snd) < 3) {
>+		priority =3D std_prio_lookup(prio_str, family, hook);
>+		if (priority =3D=3D NF_IP_PRI_LAST)
>+			return false;
>+	} else {
>+		priority =3D std_prio_lookup(prio_fst, family, hook);
>+		if (priority =3D=3D NF_IP_PRI_LAST)
>+			return false;
>+		if (op =3D=3D '+')
>+			priority +=3D prio_snd;
>+		else if (op =3D=3D '-')
>+			priority -=3D prio_snd;
>+		else
>+			return false;
>+	}
>+	prio->expr =3D constant_expr_alloc(&loc, &integer_type,
>+					 BYTEORDER_HOST_ENDIAN,
>+					 sizeof(int) *
>+					 BITS_PER_BYTE,
>+					 &priority);
> 	return true;
> }
>=20
>@@ -3271,10 +3306,10 @@ static int flowtable_evaluate(struct eval_ctx
>*ctx, struct flowtable *ft)
> 	if (ft->hooknum =3D=3D NF_INET_NUMHOOKS)
> 		return chain_error(ctx, ft, "invalid hook %s", ft->hookstr);
>=20
>-	if (!evaluate_priority(&ft->priority, NFPROTO_NETDEV, ft->hooknum))
>+	if (!evaluate_priority(ctx, &ft->priority, NFPROTO_NETDEV,
>ft->hooknum))
> 		return __stmt_binary_error(ctx, &ft->priority=2Eloc, NULL,
>-					   "'%s' is invalid priority=2E",
>-					   ft->priority=2Estr);
>+					   "invalid priority expression %s=2E",
>+					   expr_name(ft->priority=2Eexpr));
>=20
> 	if (!ft->dev_expr)
>		return chain_error(ctx, ft, "Unbound flowtable not allowed (must
>specify devices)");
>@@ -3469,11 +3504,11 @@ static int chain_evaluate(struct eval_ctx *ctx,
>struct chain *chain)
> 			return chain_error(ctx, chain, "invalid hook %s",
> 					   chain->hookstr);
>=20
>-		if (!evaluate_priority(&chain->priority, chain->handle=2Efamily,
>-				       chain->hooknum))
>+		if (!evaluate_priority(ctx, &chain->priority,
>+				       chain->handle=2Efamily, chain->hooknum))
> 			return __stmt_binary_error(ctx, &chain->priority=2Eloc, NULL,
>-						   "'%s' is invalid priority in this context=2E",
>-						   chain->priority=2Estr);
>+						   "invalid priority expression %s in this context=2E",
>+						   expr_name(chain->priority=2Eexpr));
> 	}
>=20
> 	list_for_each_entry(rule, &chain->rules, list) {
>diff --git a/src/json=2Ec b/src/json=2Ec
>index 33e0ec1=2E=2E05f089e 100644
>--- a/src/json=2Ec
>+++ b/src/json=2Ec
>@@ -223,6 +223,7 @@ static json_t *rule_print_json(struct output_ctx
>*octx,
> static json_t *chain_print_json(const struct chain *chain)
> {
> 	json_t *root, *tmp;
>+	int priority;
>=20
> 	root =3D json_pack("{s:s, s:s, s:s, s:I}",
> 			 "family", family2str(chain->handle=2Efamily),
>@@ -231,11 +232,13 @@ static json_t *chain_print_json(const struct
>chain *chain)
> 			 "handle", chain->handle=2Ehandle=2Eid);
>=20
> 	if (chain->flags & CHAIN_F_BASECHAIN) {
>+		mpz_export_data(&priority, chain->priority=2Eexpr->value,
>+				BYTEORDER_HOST_ENDIAN, sizeof(int));
> 		tmp =3D json_pack("{s:s, s:s, s:i, s:s}",
> 				"type", chain->type,
> 				"hook", hooknum2str(chain->handle=2Efamily,
> 						    chain->hooknum),
>-				"prio", chain->priority=2Enum,
>+				"prio", priority,
> 				"policy", chain_policy2str(chain->policy));
> 		if (chain->dev)
> 			json_object_set_new(tmp, "dev", json_string(chain->dev));
>@@ -373,14 +376,16 @@ static json_t *obj_print_json(const struct obj
>*obj)
> static json_t *flowtable_print_json(const struct flowtable *ftable)
> {
> 	json_t *root, *devs =3D NULL;
>-	int i;
>+	int i, priority;
>=20
>+	mpz_export_data(&priority, ftable->priority=2Eexpr->value,
>+			BYTEORDER_HOST_ENDIAN, sizeof(int));
> 	root =3D json_pack("{s:s, s:s, s:s, s:s, s:i}",
> 			"family", family2str(ftable->handle=2Efamily),
> 			"name", ftable->handle=2Eflowtable,
> 			"table", ftable->handle=2Etable=2Ename,
> 			"hook", hooknum2str(NFPROTO_NETDEV, ftable->hooknum),
>-			"prio", ftable->priority=2Enum);
>+			"prio", priority);
>=20
> 	for (i =3D 0; i < ftable->dev_array_len; i++) {
> 		const char *dev =3D ftable->dev_array[i];
>diff --git a/src/mnl=2Ec b/src/mnl=2Ec
>index eab8d54=2E=2E8921ccf 100644
>--- a/src/mnl=2Ec
>+++ b/src/mnl=2Ec
>@@ -518,6 +518,7 @@ int mnl_nft_chain_add(struct netlink_ctx *ctx,
>const struct cmd *cmd,
> {
> 	struct nftnl_chain *nlc;
> 	struct nlmsghdr *nlh;
>+	int priority;
>=20
> 	nlc =3D nftnl_chain_alloc();
> 	if (nlc =3D=3D NULL)
>@@ -531,8 +532,10 @@ int mnl_nft_chain_add(struct netlink_ctx *ctx,
>const struct cmd *cmd,
> 		if (cmd->chain->flags & CHAIN_F_BASECHAIN) {
> 			nftnl_chain_set_u32(nlc, NFTNL_CHAIN_HOOKNUM,
> 					    cmd->chain->hooknum);
>-			nftnl_chain_set_s32(nlc, NFTNL_CHAIN_PRIO,
>-					    cmd->chain->priority=2Enum);
>+			mpz_export_data(&priority,
>+					cmd->chain->priority=2Eexpr->value,
>+					BYTEORDER_HOST_ENDIAN, sizeof(int));
>+			nftnl_chain_set_s32(nlc, NFTNL_CHAIN_PRIO, priority);
> 			nftnl_chain_set_str(nlc, NFTNL_CHAIN_TYPE,
> 					    cmd->chain->type);
> 		}
>@@ -1371,6 +1374,7 @@ int mnl_nft_flowtable_add(struct netlink_ctx
>*ctx, const struct cmd *cmd,
> 	const char *dev_array[8];
> 	struct nlmsghdr *nlh;
> 	struct expr *expr;
>+	int priority;
> 	int i =3D 0;
>=20
> 	flo =3D nftnl_flowtable_alloc();
>@@ -1385,8 +1389,9 @@ int mnl_nft_flowtable_add(struct netlink_ctx
>*ctx, const struct cmd *cmd,
> 				cmd->handle=2Eflowtable);
> 	nftnl_flowtable_set_u32(flo, NFTNL_FLOWTABLE_HOOKNUM,
> 				cmd->flowtable->hooknum);
>-	nftnl_flowtable_set_u32(flo, NFTNL_FLOWTABLE_PRIO,
>-				cmd->flowtable->priority=2Enum);
>+	mpz_export_data(&priority, cmd->flowtable->priority=2Eexpr->value,
>+			BYTEORDER_HOST_ENDIAN, sizeof(int));
>+	nftnl_flowtable_set_u32(flo, NFTNL_FLOWTABLE_PRIO, priority);
>=20
>	list_for_each_entry(expr, &cmd->flowtable->dev_expr->expressions,
>list)
> 		dev_array[i++] =3D expr->identifier;
>diff --git a/src/netlink=2Ec b/src/netlink=2Ec
>index 14b0df4=2E=2Ea0e4d63 100644
>--- a/src/netlink=2Ec
>+++ b/src/netlink=2Ec
>@@ -369,6 +369,7 @@ struct chain *netlink_delinearize_chain(struct
>netlink_ctx *ctx,
> 					const struct nftnl_chain *nlc)
> {
> 	struct chain *chain;
>+	int priority;
>=20
> 	chain =3D chain_alloc(nftnl_chain_get_str(nlc, NFTNL_CHAIN_NAME));
> 	chain->handle=2Efamily =3D
>@@ -386,8 +387,13 @@ struct chain *netlink_delinearize_chain(struct
>netlink_ctx *ctx,
> 			nftnl_chain_get_u32(nlc, NFTNL_CHAIN_HOOKNUM);
> 		chain->hookstr       =3D
> 			hooknum2str(chain->handle=2Efamily, chain->hooknum);
>-		chain->priority=2Enum  =3D
>-			nftnl_chain_get_s32(nlc, NFTNL_CHAIN_PRIO);
>+		priority =3D nftnl_chain_get_s32(nlc, NFTNL_CHAIN_PRIO);
>+		chain->priority=2Eexpr =3D
>+				constant_expr_alloc(&netlink_location,
>+						    &integer_type,
>+						    BYTEORDER_HOST_ENDIAN,
>+						    sizeof(int) *
>+						    BITS_PER_BYTE, &priority);
> 		chain->type          =3D
> 			xstrdup(nftnl_chain_get_str(nlc, NFTNL_CHAIN_TYPE));
> 		chain->policy          =3D
>@@ -1080,7 +1086,7 @@ netlink_delinearize_flowtable(struct netlink_ctx
>*ctx,
> {
> 	struct flowtable *flowtable;
> 	const char * const *dev_array;
>-	int len =3D 0, i;
>+	int len =3D 0, i, priority;
>=20
> 	flowtable =3D flowtable_alloc(&netlink_location);
> 	flowtable->handle=2Efamily =3D
>@@ -1099,8 +1105,14 @@ netlink_delinearize_flowtable(struct netlink_ctx
>*ctx,
>=20
> 	flowtable->dev_array_len =3D len;
>=20
>-	flowtable->priority=2Enum =3D
>-		nftnl_flowtable_get_u32(nlo, NFTNL_FLOWTABLE_PRIO);
>+	priority =3D nftnl_flowtable_get_u32(nlo, NFTNL_FLOWTABLE_PRIO);
>+	flowtable->priority=2Eexpr =3D
>+				constant_expr_alloc(&netlink_location,
>+						    &integer_type,
>+						    BYTEORDER_HOST_ENDIAN,
>+						    sizeof(int) *
>+						    BITS_PER_BYTE,
>+						    &priority);
> 	flowtable->hooknum =3D
> 		nftnl_flowtable_get_u32(nlo, NFTNL_FLOWTABLE_HOOKNUM);
>=20
>diff --git a/src/parser_bison=2Ey b/src/parser_bison=2Ey
>index b463a14=2E=2E3f763f0 100644
>--- a/src/parser_bison=2Ey
>+++ b/src/parser_bison=2Ey
>@@ -1972,27 +1972,50 @@ extended_prio_name	:	OUT
> extended_prio_spec	:	int_num
> 			{
> 				struct prio_spec spec =3D {0};
>-				spec=2Enum =3D $1;
>+				spec=2Eexpr =3D constant_expr_alloc(&@$, &integer_type,
>+								BYTEORDER_HOST_ENDIAN,
>+								sizeof(int) *
>+								BITS_PER_BYTE, &$1);
>+				$$ =3D spec;
>+			}
>+			|	variable_expr
>+			{
>+				struct prio_spec spec =3D {0};
>+				datatype_set($1->sym->expr, &priority_type);
>+				spec=2Eexpr =3D $1;
> 				$$ =3D spec;
> 			}
> 			|	extended_prio_name
> 			{
> 				struct prio_spec spec =3D {0};
>-				spec=2Estr =3D $1;
>+				spec=2Eexpr =3D constant_expr_alloc(&@$, &string_type,
>+								BYTEORDER_HOST_ENDIAN,
>+								strlen($1) *
>+								BITS_PER_BYTE, $1);
>+				xfree($1);
> 				$$ =3D spec;
> 			}
> 			|	extended_prio_name PLUS NUM
> 			{
> 				struct prio_spec spec =3D {0};
>-				spec=2Enum =3D $3;
>-				spec=2Estr =3D $1;
>+				char str[NFT_NAME_MAXLEN];
>+				snprintf(str, sizeof(str), "%s + %" PRIu64, $1, $3);
>+				spec=2Eexpr =3D constant_expr_alloc(&@$, &string_type,
>+								BYTEORDER_HOST_ENDIAN,
>+								strlen(str) *
>+								BITS_PER_BYTE, str);
>+				xfree($1);
> 				$$ =3D spec;
> 			}
> 			|	extended_prio_name DASH NUM
> 			{
> 				struct prio_spec spec =3D {0};
>-				spec=2Enum =3D -$3;
>-				spec=2Estr =3D $1;
>+				char str[NFT_NAME_MAXLEN];
>+				snprintf(str, sizeof(str), "%s - %" PRIu64, $1, $3);
>+				spec=2Eexpr =3D constant_expr_alloc(&@$, &string_type,
>+								BYTEORDER_HOST_ENDIAN,
>+								strlen(str) *
>+								BITS_PER_BYTE, str);
> 				$$ =3D spec;
> 			}
> 			;
>diff --git a/src/parser_json=2Ec b/src/parser_json=2Ec
>index 76c0a5c=2E=2E0e2fd6b 100644
>--- a/src/parser_json=2Ec
>+++ b/src/parser_json=2Ec
>@@ -2580,7 +2580,11 @@ static struct cmd
>*json_parse_cmd_add_chain(struct json_ctx *ctx, json_t *root,
> 	chain =3D chain_alloc(NULL);
> 	chain->flags |=3D CHAIN_F_BASECHAIN;
> 	chain->type =3D xstrdup(type);
>-	chain->priority=2Enum =3D prio;
>+	chain->priority=2Eexpr =3D constant_expr_alloc(int_loc, &integer_type,
>+						   BYTEORDER_HOST_ENDIAN,
>+						   sizeof(int) *
>+						   BITS_PER_BYTE,
>+						   &prio);
> 	chain->hookstr =3D chain_hookname_lookup(hookstr);
> 	if (!chain->hookstr) {
> 		json_error(ctx, "Invalid chain hook '%s'=2E", hookstr);
>@@ -2947,7 +2951,10 @@ static struct cmd
>*json_parse_cmd_add_flowtable(struct json_ctx *ctx,
>=20
> 	flowtable =3D flowtable_alloc(int_loc);
> 	flowtable->hookstr =3D hookstr;
>-	flowtable->priority=2Enum =3D prio;
>+	flowtable->priority=2Eexpr =3D constant_expr_alloc(int_loc,
>&integer_type,
>+						       BYTEORDER_HOST_ENDIAN,
>+						       sizeof(int) *
>+						       BITS_PER_BYTE, &prio);
>=20
> 	flowtable->dev_expr =3D json_parse_flowtable_devs(ctx, devs);
> 	if (!flowtable->dev_expr) {
>diff --git a/src/rule=2Ec b/src/rule=2Ec
>index 2936065=2E=2E2aca8af 100644
>--- a/src/rule=2Ec
>+++ b/src/rule=2Ec
>@@ -821,7 +821,7 @@ void chain_free(struct chain *chain)
> 	xfree(chain->type);
> 	if (chain->dev !=3D NULL)
> 		xfree(chain->dev);
>-	xfree(chain->priority=2Estr);
>+	expr_free(chain->priority=2Eexpr);
> 	xfree(chain);
> }
>=20
>@@ -1051,14 +1051,15 @@ int std_prio_lookup(const char *std_prio_name,
>int family, int hook)
>=20
> static const char *prio2str(const struct output_ctx *octx,
> 			    char *buf, size_t bufsize, int family, int hook,
>-			    int prio)
>+			    const struct expr *expr)
> {
> 	const struct prio_tag *prio_arr;
>+	int std_prio, offset, prio;
> 	const char *std_prio_str;
> 	const int reach =3D 10;
>-	int std_prio, offset;
> 	size_t i, arr_size;
>=20
>+	mpz_export_data(&prio, expr->value, BYTEORDER_HOST_ENDIAN,
>sizeof(int));
> 	if (family =3D=3D NFPROTO_BRIDGE) {
> 		prio_arr =3D bridge_std_prios;
> 		arr_size =3D array_size(bridge_std_prios);
>@@ -1110,7 +1111,7 @@ static void chain_print_declaration(const struct
>chain *chain,
> 		nft_print(octx, " priority %s; policy %s;\n",
> 			  prio2str(octx, priobuf, sizeof(priobuf),
> 				   chain->handle=2Efamily, chain->hooknum,
>-				   chain->priority=2Enum),
>+				   chain->priority=2Eexpr),
> 			  chain_policy2str(chain->policy));
> 	}
> }
>@@ -1141,7 +1142,7 @@ void chain_print_plain(const struct chain *chain,
>struct output_ctx *octx)
> 			  chain->type, chain->hookstr,
> 			  prio2str(octx, priobuf, sizeof(priobuf),
> 				   chain->handle=2Efamily, chain->hooknum,
>-				   chain->priority=2Enum),
>+				   chain->priority=2Eexpr),
> 			  chain_policy2str(chain->policy));
> 	}
> 	if (nft_output_handle(octx))
>@@ -2047,7 +2048,7 @@ void flowtable_free(struct flowtable *flowtable)
> 	if (--flowtable->refcnt > 0)
> 		return;
> 	handle_free(&flowtable->handle);
>-	xfree(flowtable->priority=2Estr);
>+	expr_free(flowtable->priority=2Eexpr);
> 	xfree(flowtable);
> }
>=20
>@@ -2077,7 +2078,7 @@ static void flowtable_print_declaration(const
>struct flowtable *flowtable,
> 		  opts->tab, opts->tab,
> 		  hooknum2str(NFPROTO_NETDEV, flowtable->hooknum),
> 		  prio2str(octx, priobuf, sizeof(priobuf), NFPROTO_NETDEV,
>-			   flowtable->hooknum, flowtable->priority=2Enum),
>+			   flowtable->hooknum, flowtable->priority=2Eexpr),
> 		  opts->stmt_separator);
>=20
> 	nft_print(octx, "%s%sdevices =3D { ", opts->tab, opts->tab);
>diff --git a/tests/shell/testcases/nft-f/0021priority_variable_0
>b/tests/shell/testcases/nft-f/0021priority_variable_0
>new file mode 100755
>index 0000000=2E=2E2b143db
>--- /dev/null
>+++ b/tests/shell/testcases/nft-f/0021priority_variable_0
>@@ -0,0 +1,17 @@
>+#!/bin/bash
>+
>+# Tests use of variables in priority specification
>+
>+set -e
>+
>+RULESET=3D"
>+define pri =3D filter
>+
>+table inet global {
>+    chain prerouting {
>+        type filter hook prerouting priority \$pri
>+        policy accept
>+    }
>+}"
>+
>+$NFT -f - <<< "$RULESET"
>diff --git a/tests/shell/testcases/nft-f/0022priority_variable_0
>b/tests/shell/testcases/nft-f/0022priority_variable_0
>new file mode 100755
>index 0000000=2E=2E51bc5eb
>--- /dev/null
>+++ b/tests/shell/testcases/nft-f/0022priority_variable_0
>@@ -0,0 +1,17 @@
>+#!/bin/bash
>+
>+# Tests use of variables in priority specification
>+
>+set -e
>+
>+RULESET=3D"
>+define pri =3D 10
>+
>+table inet global {
>+    chain prerouting {
>+        type filter hook prerouting priority \$pri
>+        policy accept
>+    }
>+}"
>+
>+$NFT -f - <<< "$RULESET"
>diff --git a/tests/shell/testcases/nft-f/0023priority_variable_1
>b/tests/shell/testcases/nft-f/0023priority_variable_1
>new file mode 100755
>index 0000000=2E=2Eeddaf5b
>--- /dev/null
>+++ b/tests/shell/testcases/nft-f/0023priority_variable_1
>@@ -0,0 +1,18 @@
>+#!/bin/bash
>+
>+# Tests use of variables in priority specification
>+
>+set -e
>+
>+RULESET=3D"
>+define pri =3D *
>+
>+table inet global {
>+    chain prerouting {
>+        type filter hook prerouting priority \$pri
>+        policy accept
>+    }
>+}"
>+
>+$NFT -f - <<< "$RULESET" && exit 1
>+exit 0
>diff --git a/tests/shell/testcases/nft-f/0024priority_variable_1
>b/tests/shell/testcases/nft-f/0024priority_variable_1
>new file mode 100755
>index 0000000=2E=2E592cb56
>--- /dev/null
>+++ b/tests/shell/testcases/nft-f/0024priority_variable_1
>@@ -0,0 +1,18 @@
>+#!/bin/bash
>+
>+# Tests use of variables in priority specification
>+
>+set -e
>+
>+RULESET=3D"
>+define pri =3D { 127=2E0=2E0=2E1 }
>+
>+table inet global {
>+    chain prerouting {
>+        type filter hook prerouting priority \$pri
>+        policy accept
>+    }
>+}"
>+
>+$NFT -f - <<< "$RULESET" && exit 1
>+exit 0
>diff --git
>a/tests/shell/testcases/nft-f/dumps/0021priority_variable_0=2Enft
>b/tests/shell/testcases/nft-f/dumps/0021priority_variable_0=2Enft
>new file mode 100644
>index 0000000=2E=2Ef409309
>--- /dev/null
>+++ b/tests/shell/testcases/nft-f/dumps/0021priority_variable_0=2Enft
>@@ -0,0 +1,5 @@
>+table inet global {
>+	chain prerouting {
>+		type filter hook prerouting priority filter; policy accept;
>+	}
>+}
>diff --git
>a/tests/shell/testcases/nft-f/dumps/0022priority_variable_0=2Enft
>b/tests/shell/testcases/nft-f/dumps/0022priority_variable_0=2Enft
>new file mode 100644
>index 0000000=2E=2E2e94459
>--- /dev/null
>+++ b/tests/shell/testcases/nft-f/dumps/0022priority_variable_0=2Enft
>@@ -0,0 +1,5 @@
>+table inet global {
>+	chain prerouting {
>+		type filter hook prerouting priority filter + 10; policy accept;
>+	}
>+}

