From: =?UTF-8?q?Carlos=20Falgueras=20Garc=C3=ADa?= <carlosfg@riseup.net>
Subject: [PATCH] src: Add command "replace" for rules
Date: Tue, 27 Oct 2015 12:58:07 +0100
Message-ID: <1445947087-25861-1-git-send-email-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:52015 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752322AbbJ0L60 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 Oct 2015 07:58:26 -0400
Received: from piha.riseup.net (unknown [10.0.1.163])
	(using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
	by mx1.riseup.net (Postfix) with ESMTPS id A970D1A2D78
	for <netfilter-devel@vger.kernel.org>; Tue, 27 Oct 2015 04:58:25 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Modify the parser and add necessary functions to provide the command "n=
ft
replace rule <ruleid_spec> <new_rule>"

Example of use:
	# nft list ruleset -a
	table ip filter {
		chain output {
			ip daddr 8.8.8.7 counter packets 0 bytes 0 # handle 3
		}
	}
	# nft replace rule filter output handle 3 ip daddr 8.8.8.8 counter
	# nft list ruleset -a
	table ip filter {
		chain output {
			ip daddr 8.8.8.8 counter packets 0 bytes 0 # handle 3
		}
	}

Signed-off-by: Carlos Falgueras Garc=C3=ADa <carlosfg@riseup.net>
---
 include/mnl.h      |  2 ++
 include/netlink.h  |  4 ++++
 include/rule.h     |  2 ++
 src/evaluate.c     |  1 +
 src/mnl.c          | 16 ++++++++++++++++
 src/netlink.c      | 18 ++++++++++++++++++
 src/parser_bison.y | 12 ++++++++++--
 src/rule.c         | 14 ++++++++++++++
 src/scanner.l      |  1 +
 9 files changed, 68 insertions(+), 2 deletions(-)

diff --git a/include/mnl.h b/include/mnl.h
index 9c14e1a..f74dfee 100644
--- a/include/mnl.h
+++ b/include/mnl.h
@@ -26,6 +26,8 @@ int mnl_nft_rule_batch_add(struct nftnl_rule *nlr, un=
signed int flags,
 			   uint32_t seqnum);
 int mnl_nft_rule_batch_del(struct nftnl_rule *nlr, unsigned int flags,
 			   uint32_t seqnum);
+int mnl_nft_rule_batch_replace(struct nftnl_rule *nlr, unsigned int fl=
ags,
+			       uint32_t seqnum);
=20
 int mnl_nft_rule_add(struct mnl_socket *nf_sock, struct nftnl_rule *r,
 		     unsigned int flags);
diff --git a/include/netlink.h b/include/netlink.h
index 7bf7ea0..8444742 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -98,6 +98,10 @@ extern int netlink_add_rule_batch(struct netlink_ctx=
 *ctx,
 extern int netlink_del_rule_batch(struct netlink_ctx *ctx,
 				  const struct handle *h,
 				  const struct location *loc);
+extern int netlink_replace_rule_batch(struct netlink_ctx *ctx,
+				      const struct handle *h,
+				      const struct rule *rule,
+				      const struct location *loc);
=20
 extern int netlink_add_chain(struct netlink_ctx *ctx, const struct han=
dle *h,
 			     const struct location *loc,
diff --git a/include/rule.h b/include/rule.h
index 30b4597..a86f600 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -237,6 +237,7 @@ extern void set_print_plain(const struct set *s);
  *
  * @CMD_INVALID:	invalid
  * @CMD_ADD:		add object (non-exclusive)
+ * @CMD_REPLACE,	replace object
  * @CMD_CREATE:		create object (exclusive)
  * @CMD_INSERT:		insert object
  * @CMD_DELETE:		delete object
@@ -250,6 +251,7 @@ extern void set_print_plain(const struct set *s);
 enum cmd_ops {
 	CMD_INVALID,
 	CMD_ADD,
+	CMD_REPLACE,
 	CMD_CREATE,
 	CMD_INSERT,
 	CMD_DELETE,
diff --git a/src/evaluate.c b/src/evaluate.c
index 4f9299e..4c34d1b 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2229,6 +2229,7 @@ int cmd_evaluate(struct eval_ctx *ctx, struct cmd=
 *cmd)
 	ctx->cmd =3D cmd;
 	switch (cmd->op) {
 	case CMD_ADD:
+	case CMD_REPLACE:
 	case CMD_CREATE:
 	case CMD_INSERT:
 		return cmd_evaluate_add(ctx, cmd);
diff --git a/src/mnl.c b/src/mnl.c
index e4253e5..52875f4 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -301,6 +301,22 @@ int mnl_nft_rule_batch_add(struct nftnl_rule *nlr,=
 unsigned int flags,
 	return 0;
 }
=20
+int mnl_nft_rule_batch_replace(struct nftnl_rule *nlr, unsigned int fl=
ags,
+			       uint32_t seqnum)
+{
+	struct nlmsghdr *nlh;
+
+	nlh =3D nftnl_rule_nlmsg_build_hdr(nftnl_batch_buffer(batch),
+			NFT_MSG_NEWRULE,
+			nftnl_rule_get_u32(nlr, NFTNL_RULE_FAMILY),
+			NLM_F_REPLACE | flags, seqnum);
+
+	nftnl_rule_nlmsg_build_payload(nlh, nlr);
+	mnl_nft_batch_continue();
+
+	return 0;
+}
+
 int mnl_nft_rule_batch_del(struct nftnl_rule *nlr, unsigned int flags,
 			   uint32_t seqnum)
 {
diff --git a/src/netlink.c b/src/netlink.c
index 4d1e977..ad86084 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -382,6 +382,24 @@ int netlink_add_rule_batch(struct netlink_ctx *ctx=
,
 	return err;
 }
=20
+int netlink_replace_rule_batch(struct netlink_ctx *ctx, const struct h=
andle *h,
+			       const struct rule *rule,
+			       const struct location *loc)
+{
+	struct nftnl_rule *nlr;
+	int err;
+
+	nlr =3D alloc_nftnl_rule(&rule->handle);
+	netlink_linearize_rule(ctx, nlr, rule);
+	err =3D mnl_nft_rule_batch_replace(nlr, 0, ctx->seqnum);
+	nftnl_rule_free(nlr);
+
+	if (err < 0)
+		netlink_io_error(ctx, loc, "Could not replace rule to batch: %s",
+				 strerror(errno));
+	return err;
+}
+
 int netlink_add_rule_list(struct netlink_ctx *ctx, const struct handle=
 *h,
 			  struct list_head *rule_list)
 {
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 98480b6..49988f6 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -184,6 +184,7 @@ static void location_update(struct location *loc, s=
truct location *rhs, int n)
=20
 %token ADD			"add"
 %token UPDATE			"update"
+%token REPLACE			"replace"
 %token CREATE			"create"
 %token INSERT			"insert"
 %token DELETE			"delete"
@@ -413,8 +414,8 @@ static void location_update(struct location *loc, s=
truct location *rhs, int n)
 %type <cmd>			line
 %destructor { cmd_free($$); }	line
=20
-%type <cmd>			base_cmd add_cmd create_cmd insert_cmd delete_cmd list_c=
md flush_cmd rename_cmd export_cmd monitor_cmd describe_cmd
-%destructor { cmd_free($$); }	base_cmd add_cmd create_cmd insert_cmd d=
elete_cmd list_cmd flush_cmd rename_cmd export_cmd monitor_cmd describe=
_cmd
+%type <cmd>			base_cmd add_cmd replace_cmd create_cmd insert_cmd delet=
e_cmd list_cmd flush_cmd rename_cmd export_cmd monitor_cmd describe_cmd
+%destructor { cmd_free($$); }	base_cmd add_cmd replace_cmd create_cmd =
insert_cmd delete_cmd list_cmd flush_cmd rename_cmd export_cmd monitor_=
cmd describe_cmd
=20
 %type <handle>			table_spec chain_spec chain_identifier ruleid_spec ru=
leset_spec
 %destructor { handle_free(&$$); } table_spec chain_spec chain_identifi=
er ruleid_spec ruleset_spec
@@ -649,6 +650,7 @@ line			:	common_block			{ $$ =3D NULL; }
=20
 base_cmd		:	/* empty */	add_cmd		{ $$ =3D $1; }
 	  		|	ADD		add_cmd		{ $$ =3D $2; }
+	  		|	REPLACE		replace_cmd	{ $$ =3D $2; }
 			|	CREATE		create_cmd	{ $$ =3D $2; }
 			|	INSERT		insert_cmd	{ $$ =3D $2; }
 			|	DELETE		delete_cmd	{ $$ =3D $2; }
@@ -711,6 +713,12 @@ add_cmd			:	TABLE		table_spec
 			}
 			;
=20
+replace_cmd		:	RULE		ruleid_spec	rule
+			{
+				$$ =3D cmd_alloc(CMD_REPLACE, CMD_OBJ_RULE, &$2, &@$, $3);
+			}
+			;
+
 create_cmd		:	TABLE		table_spec
 			{
 				$$ =3D cmd_alloc(CMD_CREATE, CMD_OBJ_TABLE, &$2, &@$, NULL);
diff --git a/src/rule.c b/src/rule.c
index 0a81469..c154062 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -935,6 +935,18 @@ static int do_command_add(struct netlink_ctx *ctx,=
 struct cmd *cmd, bool excl)
 	return 0;
 }
=20
+static int do_command_replace(struct netlink_ctx *ctx, struct cmd *cmd=
)
+{
+	switch (cmd->obj) {
+	case CMD_OBJ_RULE:
+		return netlink_replace_rule_batch(ctx, &cmd->handle, cmd->rule,
+						  &cmd->location);
+	default:
+		BUG("invalid command object type %u\n", cmd->obj);
+	}
+	return 0;
+}
+
 static int do_command_insert(struct netlink_ctx *ctx, struct cmd *cmd)
 {
 	switch (cmd->obj) {
@@ -1229,6 +1241,8 @@ int do_command(struct netlink_ctx *ctx, struct cm=
d *cmd)
 		return do_command_add(ctx, cmd, true);
 	case CMD_INSERT:
 		return do_command_insert(ctx, cmd);
+	case CMD_REPLACE:
+		return do_command_replace(ctx, cmd);
 	case CMD_DELETE:
 		return do_command_delete(ctx, cmd);
 	case CMD_LIST:
diff --git a/src/scanner.l b/src/scanner.l
index b827489..1a9f43f 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -259,6 +259,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "netdev"		{ return NETDEV; }
=20
 "add"			{ return ADD; }
+"replace"		{ return REPLACE; }
 "update"		{ return UPDATE; }
 "create"		{ return CREATE; }
 "insert"		{ return INSERT; }
--=20
2.6.2

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
