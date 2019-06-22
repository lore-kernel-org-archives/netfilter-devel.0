Return-Path: <SRS0=paks=UV=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB787C43613
	for <netfilter-devel@archiver.kernel.org>; Sat, 22 Jun 2019 17:12:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7BD7C20673
	for <netfilter-devel@archiver.kernel.org>; Sat, 22 Jun 2019 17:12:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="FlMpusK+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726310AbfFVRMU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 22 Jun 2019 13:12:20 -0400
Received: from mx1.riseup.net ([198.252.153.129]:39376 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726299AbfFVRMU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 22 Jun 2019 13:12:20 -0400
Received: from capuchin.riseup.net (capuchin-pn.riseup.net [10.0.1.176])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id 9723F1A3153
        for <netfilter-devel@vger.kernel.org>; Sat, 22 Jun 2019 10:12:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1561223538; bh=Ys1nRvvemlErGyYZwiP7sTNqSn0hYfhnX7nou5/snNo=;
        h=From:To:Cc:Subject:Date:From;
        b=FlMpusK+m0kXk/0N8nrICaoJbNpjJQjhSVGaP71add6HEP5Kx8FN5DIJ641i1XgF3
         +fq1z1vYIZFKhzxHKv9WY2x5zAFF4F1BTXSYo+ZrM/HSMkvFIAOqn6tsoeFL5iSArW
         bf5GzDFJegsptJMlbgUlzCAAfTPvN14f6XN8NsuA=
X-Riseup-User-ID: 50384374DA67E81E800D8542CBC6E956DFA09FF4635F974DD8A8371CAE83F554
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by capuchin.riseup.net (Postfix) with ESMTPSA id 57CFC12057E;
        Sat, 22 Jun 2019 10:12:17 -0700 (PDT)
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
To:     netfilter-devel@vger.kernel.org
Cc:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Subject: [PATCH nft v2] src: introduce SYNPROXY matching
Date:   Sat, 22 Jun 2019 19:12:08 +0200
Message-Id: <20190622171207.818-1-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add support for "synproxy" statement. Example:

table ip x {
	chain y {
		type filter hook prerouting priority raw; policy accept;
		tcp flags syn notrack
	}

	chain z {
		type filter hook input priority filter; policy accept;
		ct state { invalid, untracked } synproxy mss 1460 wscale 7 timestamp sack-perm
		ct state invalid drop
	}
}

Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
---
v1: initial patch
v2: rename synproxy uapi header
---
 doc/statements.txt                    | 87 +++++++++++++++++++++++++
 include/json.h                        |  1 +
 include/linux/netfilter/nf_synproxy.h | 23 +++++++
 include/linux/netfilter/nf_tables.h   | 17 +++++
 include/statement.h                   | 11 ++++
 src/evaluate.c                        | 15 +++++
 src/json.c                            | 29 +++++++++
 src/netlink_delinearize.c             | 17 +++++
 src/netlink_linearize.c               | 17 +++++
 src/parser_bison.y                    | 48 ++++++++++++++
 src/parser_json.c                     | 94 +++++++++++++++++++++++++++
 src/scanner.l                         |  6 ++
 src/statement.c                       | 51 +++++++++++++++
 tests/py/inet/synproxy.t              | 13 ++++
 tests/py/inet/synproxy.t.json         | 71 ++++++++++++++++++++
 tests/py/inet/synproxy.t.payload      | 72 ++++++++++++++++++++
 16 files changed, 572 insertions(+)
 create mode 100644 include/linux/netfilter/nf_synproxy.h
 create mode 100644 tests/py/inet/synproxy.t
 create mode 100644 tests/py/inet/synproxy.t.json
 create mode 100644 tests/py/inet/synproxy.t.payload

diff --git a/doc/statements.txt b/doc/statements.txt
index bc2f944..e17068a 100644
--- a/doc/statements.txt
+++ b/doc/statements.txt
@@ -483,6 +483,93 @@ table inet x {
 }
 -------------------------------------
 
+SYNPROXY STATEMENT
+~~~~~~~~~~~~~~~~~~
+This statement will process TCP three-way-handshake parallel in netfilter
+context to protect either local or backend system. This statement requires
+connection tracking because sequence numbers need to be translated.
+
+[verse]
+*synproxy* [*mss* 'mss_value'] [*wscale* 'wscale_value'] ['SYNPROXY_FLAGS']
+
+.synproxy statement attributes
+[options="header"]
+|=================
+| Name | Description
+| mss | Maximum segment size announced to clients. This must match the backend.
+| wscale | Window scale announced to clients. This must match the backend.
+|=================
+
+.synproxy statement flags
+[options="header"]
+|=================
+| Flag | Description
+| sack-perm |
+Pass client selective acknowledgement option to backend (will be disabled if
+not present).
+| timestamp |
+Pass client timestamp option to backend (will be disabled if not present, also
+needed for selective acknowledgement and window scaling).
+|=================
+
+.Example ruleset for synproxy statement
+---------------------------------------
+Determine tcp options used by backend, from an external system
+
+              tcpdump -pni eth0 -c 1 'tcp[tcpflags] == (tcp-syn|tcp-ack)'
+                  port 80 &
+              telnet 192.0.2.42 80
+              18:57:24.693307 IP 192.0.2.42.80 > 192.0.2.43.48757:
+                  Flags [S.], seq 360414582, ack 788841994, win 14480,
+                  options [mss 1460,sackOK,
+                  TS val 1409056151 ecr 9690221,
+                  nop,wscale 9],
+                  length 0
+
+Switch tcp_loose mode off, so conntrack will mark out-of-flow packets as state INVALID.
+
+              echo 0 > /proc/sys/net/netfilter/nf_conntrack_tcp_loose
+
+Make SYN packets untracked.
+
+	table ip x {
+		chain y {
+			type filter hook prerouting priority raw; policy accept;
+			tcp flags syn notrack
+		}
+	}
+
+Catch UNTRACKED (SYN  packets) and INVALID (3WHS ACK packets) states and send
+them to SYNPROXY. This rule will respond to SYN packets with SYN+ACK
+syncookies, create ESTABLISHED for valid client response (3WHS ACK packets) and
+drop incorrect cookies. Flags combinations not expected during  3WHS will not
+match and continue (e.g. SYN+FIN, SYN+ACK). Finally, drop invalid packets, this
+will be out-of-flow packets that were not matched by SYNPROXY.
+
+    table ip foo {
+            chain z {
+                    type filter hook input priority filter; policy accept;
+                    ct state { invalid, untracked } synproxy mss 1460 wscale 9 timestamp sack-perm
+                    ct state invalid drop
+            }
+    }
+
+The outcome ruleset of the steps above should be similar to the one below.
+
+	table ip x {
+		chain y {
+			type filter hook prerouting priority raw; policy accept;
+	                tcp flags syn notrack
+		}
+
+		chain z {
+			type filter hook input priority filter; policy accept;
+	                ct state { invalid, untracked } synproxy mss 1460 wscale 9 timestamp sack-perm
+		        ct state invalid drop
+	        }
+	}
+---------------------------------------
+
 FLOW STATEMENT
 ~~~~~~~~~~~~~~
 A flow statement allows us to select what flows you want to accelerate
diff --git a/include/json.h b/include/json.h
index c724c29..ce57c9f 100644
--- a/include/json.h
+++ b/include/json.h
@@ -83,6 +83,7 @@ json_t *queue_stmt_json(const struct stmt *stmt, struct output_ctx *octx);
 json_t *verdict_stmt_json(const struct stmt *stmt, struct output_ctx *octx);
 json_t *connlimit_stmt_json(const struct stmt *stmt, struct output_ctx *octx);
 json_t *tproxy_stmt_json(const struct stmt *stmt, struct output_ctx *octx);
+json_t *synproxy_stmt_json(const struct stmt *stmt, struct output_ctx *octx);
 
 int do_command_list_json(struct netlink_ctx *ctx, struct cmd *cmd);
 
diff --git a/include/linux/netfilter/nf_synproxy.h b/include/linux/netfilter/nf_synproxy.h
new file mode 100644
index 0000000..0e7c391
--- /dev/null
+++ b/include/linux/netfilter/nf_synproxy.h
@@ -0,0 +1,23 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _NF_SYNPROXY_H
+#define _NF_SYNPROXY_H
+
+#include <linux/types.h>
+
+#define NF_SYNPROXY_OPT_MSS		0x01
+#define NF_SYNPROXY_OPT_WSCALE		0x02
+#define NF_SYNPROXY_OPT_SACK_PERM	0x04
+#define NF_SYNPROXY_OPT_TIMESTAMP	0x08
+#define NF_SYNPROXY_OPT_ECN		0x10
+#define NF_SYNPROXY_FLAGMASK		(NF_SYNPROXY_OPT_MSS | \
+					 NF_SYNPROXY_OPT_WSCALE | \
+					 NF_SYNPROXY_OPT_SACK_PERM | \
+					 NF_SYNPROXY_OPT_TIMESTAMP)
+
+struct nf_synproxy_info {
+	__u8	options;
+	__u8	wscale;
+	__u16	mss;
+};
+
+#endif /* _NF_SYNPROXY_H */
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 7bdb234..28de476 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -1529,6 +1529,23 @@ enum nft_osf_attributes {
 };
 #define NFTA_OSF_MAX (__NFTA_OSF_MAX - 1)
 
+/**
+ * enum nft_synproxy_attributes - nftables synproxy expression
+ * netlink attributes
+ *
+ * @NFTA_SYNPROXY_MSS: mss value sent to the backend (NLA_U16)
+ * @NFTA_SYNPROXY_WSCALE: wscale value sent to the backend (NLA_U8)
+ * @NFTA_SYNPROXY_FLAGS: flags (NLA_U32)
+ */
+enum nft_synproxy_attributes {
+	NFTA_SYNPROXY_UNSPEC,
+	NFTA_SYNPROXY_MSS,
+	NFTA_SYNPROXY_WSCALE,
+	NFTA_SYNPROXY_FLAGS,
+	__NFTA_SYNPROXY_MAX,
+};
+#define NFTA_SYNPROXY_MAX (__NFTA_SYNPROXY_MAX - 1)
+
 /**
  * enum nft_device_attributes - nf_tables device netlink attributes
  *
diff --git a/include/statement.h b/include/statement.h
index 91d6e0e..f789ced 100644
--- a/include/statement.h
+++ b/include/statement.h
@@ -203,6 +203,14 @@ struct map_stmt {
 
 extern struct stmt *map_stmt_alloc(const struct location *loc);
 
+struct synproxy_stmt {
+	uint16_t	mss;
+	uint8_t		wscale;
+	uint32_t	flags;
+};
+
+extern struct stmt *synproxy_stmt_alloc(const struct location *loc);
+
 struct meter_stmt {
 	struct expr		*set;
 	struct expr		*key;
@@ -270,6 +278,7 @@ extern struct stmt *xt_stmt_alloc(const struct location *loc);
  * @STMT_FLOW_OFFLOAD:	flow offload statement
  * @STMT_CONNLIMIT:	connection limit statement
  * @STMT_MAP:		map statement
+ * @STMT_SYNPROXY:	synproxy statement
  */
 enum stmt_types {
 	STMT_INVALID,
@@ -297,6 +306,7 @@ enum stmt_types {
 	STMT_FLOW_OFFLOAD,
 	STMT_CONNLIMIT,
 	STMT_MAP,
+	STMT_SYNPROXY,
 };
 
 /**
@@ -361,6 +371,7 @@ struct stmt {
 		struct objref_stmt	objref;
 		struct flow_stmt	flow;
 		struct map_stmt		map;
+		struct synproxy_stmt	synproxy;
 	};
 };
 
diff --git a/src/evaluate.c b/src/evaluate.c
index 511f9f1..feaa875 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -17,6 +17,7 @@
 #include <linux/netfilter.h>
 #include <linux/netfilter_arp.h>
 #include <linux/netfilter/nf_tables.h>
+#include <linux/netfilter/nf_synproxy.h>
 #include <linux/netfilter_ipv4.h>
 #include <netinet/ip_icmp.h>
 #include <netinet/icmp6.h>
@@ -2706,6 +2707,18 @@ static int stmt_evaluate_tproxy(struct eval_ctx *ctx, struct stmt *stmt)
 	return 0;
 }
 
+static int stmt_evaluate_synproxy(struct eval_ctx *ctx, struct stmt *stmt)
+{
+	if (stmt->synproxy.flags != 0 &&
+	    !(stmt->synproxy.flags & (NF_SYNPROXY_OPT_MSS |
+				      NF_SYNPROXY_OPT_WSCALE |
+				      NF_SYNPROXY_OPT_TIMESTAMP |
+				      NF_SYNPROXY_OPT_SACK_PERM)))
+		return stmt_error(ctx, stmt, "This flags are not supported for SYNPROXY");
+
+	return 0;
+}
+
 static int stmt_evaluate_dup(struct eval_ctx *ctx, struct stmt *stmt)
 {
 	int err;
@@ -3050,6 +3063,8 @@ int stmt_evaluate(struct eval_ctx *ctx, struct stmt *stmt)
 		return stmt_evaluate_objref(ctx, stmt);
 	case STMT_MAP:
 		return stmt_evaluate_map(ctx, stmt);
+	case STMT_SYNPROXY:
+		return stmt_evaluate_synproxy(ctx, stmt);
 	default:
 		BUG("unknown statement type %s\n", stmt->ops->name);
 	}
diff --git a/src/json.c b/src/json.c
index a503a97..de33d1a 100644
--- a/src/json.c
+++ b/src/json.c
@@ -16,6 +16,7 @@
 #include <linux/netfilter/nf_log.h>
 #include <linux/netfilter/nf_nat.h>
 #include <linux/netfilter/nf_tables.h>
+#include <linux/netfilter/nf_synproxy.h>
 #include <linux/xfrm.h>
 #include <pwd.h>
 #include <grp.h>
@@ -1458,6 +1459,34 @@ json_t *tproxy_stmt_json(const struct stmt *stmt, struct output_ctx *octx)
 	return json_pack("{s:o}", "tproxy", root);
 }
 
+json_t *synproxy_stmt_json(const struct stmt *stmt, struct output_ctx *octx)
+{
+	json_t *root = json_object(), *flags = json_array();
+
+	if (stmt->synproxy.flags & NF_SYNPROXY_OPT_MSS)
+		json_object_set_new(root, "mss",
+				    json_integer(stmt->synproxy.mss));
+	if (stmt->synproxy.flags & NF_SYNPROXY_OPT_WSCALE)
+		json_object_set_new(root, "wscale",
+				    json_integer(stmt->synproxy.wscale));
+	if (stmt->synproxy.flags & NF_SYNPROXY_OPT_TIMESTAMP)
+		json_array_append_new(flags, json_string("timestamp"));
+	if (stmt->synproxy.flags & NF_SYNPROXY_OPT_SACK_PERM)
+		json_array_append_new(flags, json_string("sack-perm"));
+
+	if (json_array_size(flags) > 0)
+		json_object_set_new(root, "flags", flags);
+	else
+		json_decref(flags);
+
+	if (!json_object_size(root)) {
+		json_decref(root);
+		root = json_null();
+	}
+
+	return json_pack("{s:o}", "synproxy", root);
+}
+
 static json_t *table_print_json_full(struct netlink_ctx *ctx,
 				     struct table *table)
 {
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 1f63d9d..a03971e 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -1010,6 +1010,22 @@ out_err:
 	xfree(stmt);
 }
 
+static void netlink_parse_synproxy(struct netlink_parse_ctx *ctx,
+				   const struct location *loc,
+				   const struct nftnl_expr *nle)
+{
+	struct stmt *stmt;
+
+	stmt = synproxy_stmt_alloc(loc);
+	stmt->synproxy.mss = nftnl_expr_get_u16(nle, NFTNL_EXPR_SYNPROXY_MSS);
+	stmt->synproxy.wscale = nftnl_expr_get_u8(nle,
+						  NFTNL_EXPR_SYNPROXY_WSCALE);
+	stmt->synproxy.flags = nftnl_expr_get_u32(nle,
+						  NFTNL_EXPR_SYNPROXY_FLAGS);
+
+	ctx->stmt = stmt;
+}
+
 static void netlink_parse_tproxy(struct netlink_parse_ctx *ctx,
 			      const struct location *loc,
 			      const struct nftnl_expr *nle)
@@ -1476,6 +1492,7 @@ static const struct {
 	{ .name = "tcpopt",	.parse = netlink_parse_exthdr },
 	{ .name = "flow_offload", .parse = netlink_parse_flow_offload },
 	{ .name = "xfrm",	.parse = netlink_parse_xfrm },
+	{ .name = "synproxy",	.parse = netlink_parse_synproxy },
 };
 
 static int netlink_parse_expr(const struct nftnl_expr *nle,
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 2c6aa64..498326d 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -1141,6 +1141,21 @@ static void netlink_gen_tproxy_stmt(struct netlink_linearize_ctx *ctx,
 	nftnl_rule_add_expr(ctx->nlr, nle);
 }
 
+static void netlink_gen_synproxy_stmt(struct netlink_linearize_ctx *ctx,
+				      const struct stmt *stmt)
+{
+	struct nftnl_expr *nle;
+
+	nle = alloc_nft_expr("synproxy");
+	nftnl_expr_set_u16(nle, NFTNL_EXPR_SYNPROXY_MSS, stmt->synproxy.mss);
+	nftnl_expr_set_u8(nle, NFTNL_EXPR_SYNPROXY_WSCALE,
+			  stmt->synproxy.wscale);
+	nftnl_expr_set_u32(nle, NFTNL_EXPR_SYNPROXY_FLAGS,
+			   stmt->synproxy.flags);
+
+	nftnl_rule_add_expr(ctx->nlr, nle);
+}
+
 static void netlink_gen_dup_stmt(struct netlink_linearize_ctx *ctx,
 				 const struct stmt *stmt)
 {
@@ -1382,6 +1397,8 @@ static void netlink_gen_stmt(struct netlink_linearize_ctx *ctx,
 		return netlink_gen_nat_stmt(ctx, stmt);
 	case STMT_TPROXY:
 		return netlink_gen_tproxy_stmt(ctx, stmt);
+	case STMT_SYNPROXY:
+		return netlink_gen_synproxy_stmt(ctx, stmt);
 	case STMT_DUP:
 		return netlink_gen_dup_stmt(ctx, stmt);
 	case STMT_QUEUE:
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 1c0b60c..8bf942d 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -23,6 +23,7 @@
 #include <linux/netfilter/nf_nat.h>
 #include <linux/netfilter/nf_log.h>
 #include <linux/netfilter/nfnetlink_osf.h>
+#include <linux/netfilter/nf_synproxy.h>
 #include <linux/xfrm.h>
 #include <netinet/ip_icmp.h>
 #include <netinet/icmp6.h>
@@ -200,6 +201,12 @@ int nft_lex(void *, void *, void *);
 
 %token OSF			"osf"
 
+%token SYNPROXY			"synproxy"
+%token MSS			"mss"
+%token WSCALE			"wscale"
+%token TIMESTAMP		"timestamp"
+%token SACKPERM			"sack-perm"
+
 %token HOOK			"hook"
 %token DEVICE			"device"
 %token DEVICES			"devices"
@@ -601,6 +608,9 @@ int nft_lex(void *, void *, void *);
 %type <val>			nf_nat_flags nf_nat_flag offset_opt
 %type <stmt>			tproxy_stmt
 %destructor { stmt_free($$); }	tproxy_stmt
+%type <stmt>			synproxy_stmt synproxy_stmt_alloc
+%destructor { stmt_free($$); }	synproxy_stmt synproxy_stmt_alloc
+
 
 %type <stmt>			queue_stmt queue_stmt_alloc
 %destructor { stmt_free($$); }	queue_stmt queue_stmt_alloc
@@ -2245,6 +2255,7 @@ stmt			:	verdict_stmt
 			|	fwd_stmt
 			|	set_stmt
 			|	map_stmt
+			|	synproxy_stmt
 			;
 
 verdict_stmt		:	verdict_expr
@@ -2675,6 +2686,43 @@ tproxy_stmt		:	TPROXY TO stmt_expr
 			}
 			;
 
+synproxy_stmt		:	synproxy_stmt_alloc
+			|	synproxy_stmt_alloc	synproxy_args
+			;
+
+synproxy_stmt_alloc	:	SYNPROXY
+			{
+				$$ = synproxy_stmt_alloc(&@$);
+			}
+			;
+
+synproxy_args		:	synproxy_arg
+			{
+				$<stmt>$	= $<stmt>0;
+			}
+			|	synproxy_args	synproxy_arg
+			;
+
+synproxy_arg		:	MSS	NUM
+			{
+				$<stmt>0->synproxy.mss = $2;
+				$<stmt>0->synproxy.flags |= NF_SYNPROXY_OPT_MSS;
+			}
+			|	WSCALE	NUM
+			{
+				$<stmt>0->synproxy.wscale = $2;
+				$<stmt>0->synproxy.flags |= NF_SYNPROXY_OPT_WSCALE;
+			}
+			|	TIMESTAMP
+			{
+				$<stmt>0->synproxy.flags |= NF_SYNPROXY_OPT_TIMESTAMP;
+			}
+			|	SACKPERM
+			{
+				$<stmt>0->synproxy.flags |= NF_SYNPROXY_OPT_SACK_PERM;
+			}
+			;
+
 primary_stmt_expr	:	symbol_expr		{ $$ = $1; }
 			|	integer_expr		{ $$ = $1; }
 			|	boolean_expr		{ $$ = $1; }
diff --git a/src/parser_json.c b/src/parser_json.c
index af7701f..bd22a48 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -23,6 +23,7 @@
 #include <linux/netfilter/nf_conntrack_tuple_common.h>
 #include <linux/netfilter/nf_log.h>
 #include <linux/netfilter/nf_nat.h>
+#include <linux/netfilter/nf_synproxy.h>
 #include <linux/netfilter/nf_tables.h>
 #include <jansson.h>
 
@@ -2119,6 +2120,98 @@ static struct stmt *json_parse_log_stmt(struct json_ctx *ctx,
 	return stmt;
 }
 
+static int json_parse_synproxy_flag(struct json_ctx *ctx,
+				    json_t *root, int *flags)
+{
+	const struct {
+		const char *flag;
+		int val;
+	} flag_tbl[] = {
+		{ "timestamp", NF_SYNPROXY_OPT_TIMESTAMP },
+		{ "sack-perm", NF_SYNPROXY_OPT_SACK_PERM },
+	};
+	const char *flag;
+	unsigned int i;
+
+	assert(flags);
+
+	if (!json_is_string(root)) {
+		json_error(ctx, "Invalid log flag type %s, expected string.",
+			   json_typename(root));
+		return 1;
+	}
+	flag = json_string_value(root);
+	for (i = 0; i < array_size(flag_tbl); i++) {
+		if (!strcmp(flag, flag_tbl[i].flag)) {
+			*flags |= flag_tbl[i].val;
+			return 0;
+		}
+	}
+	json_error(ctx, "Unknown log flag '%s'.", flag);
+	return 1;
+}
+
+static int json_parse_synproxy_flags(struct json_ctx *ctx, json_t *root)
+{
+	int flags = 0;
+	json_t *value;
+	size_t index;
+
+	if (json_is_string(root)) {
+		json_parse_synproxy_flag(ctx, root, &flags);
+		return flags;
+	} else if (!json_is_array(root)) {
+		json_error(ctx, "Invalid log flags type %s.",
+			   json_typename(root));
+		return -1;
+	}
+	json_array_foreach(root, index, value) {
+		if (json_parse_synproxy_flag(ctx, value, &flags))
+			json_error(ctx, "Parsing log flag at index %zu failed.",
+				   index);
+	}
+	return flags;
+}
+
+static struct stmt *json_parse_synproxy_stmt(struct json_ctx *ctx,
+					     const char *key, json_t *value)
+{
+	struct stmt *stmt;
+	json_t *jflags;
+	int tmp, flags;
+
+	stmt = synproxy_stmt_alloc(int_loc);
+
+	if (!json_unpack(value, "{s:i}", "mss", &tmp)) {
+		if (tmp < 0) {
+			json_error(ctx, "Invalid synproxy mss value '%d'", tmp);
+			stmt_free(stmt);
+			return NULL;
+		}
+		stmt->synproxy.mss = tmp;
+		stmt->synproxy.flags |= NF_SYNPROXY_OPT_MSS;
+	}
+	if (!json_unpack(value, "{s:i}", "wscale", &tmp)) {
+		if (tmp < 0) {
+			json_error(ctx, "Invalid synproxy wscale value '%d'", tmp);
+			stmt_free(stmt);
+			return NULL;
+		}
+		stmt->synproxy.wscale = tmp;
+		stmt->synproxy.flags |= NF_SYNPROXY_OPT_WSCALE;
+	}
+	if (!json_unpack(value, "{s:o}", "flags", &jflags)) {
+		flags = json_parse_synproxy_flags(ctx, jflags);
+
+		if (flags < 0) {
+			stmt_free(stmt);
+			return NULL;
+		}
+		stmt->synproxy.flags |= flags;
+	}
+	return stmt;
+}
+
 static struct stmt *json_parse_cthelper_stmt(struct json_ctx *ctx,
 					     const char *key, json_t *value)
 {
@@ -2298,6 +2391,7 @@ static struct stmt *json_parse_stmt(struct json_ctx *ctx, json_t *root)
 		{ "queue", json_parse_queue_stmt },
 		{ "ct count", json_parse_connlimit_stmt },
 		{ "tproxy", json_parse_tproxy_stmt },
+		{ "synproxy", json_parse_synproxy_stmt },
 	};
 	const char *type;
 	unsigned int i;
diff --git a/src/scanner.l b/src/scanner.l
index d1f6e87..e990cc6 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -543,6 +543,12 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 
 "osf"			{ return OSF; }
 
+"synproxy"		{ return SYNPROXY; }
+"mss"			{ return MSS; }
+"wscale"		{ return WSCALE; }
+"timestamp"		{ return TIMESTAMP; }
+"sack-perm"		{ return SACKPERM; }
+
 "notrack"		{ return NOTRACK; }
 
 "options"		{ return OPTIONS; }
diff --git a/src/statement.c b/src/statement.c
index a9e8b3a..7519afa 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -29,6 +29,7 @@
 #include <netinet/in.h>
 #include <linux/netfilter/nf_nat.h>
 #include <linux/netfilter/nf_log.h>
+#include <linux/netfilter/nf_synproxy.h>
 
 struct stmt *stmt_alloc(const struct location *loc,
 			const struct stmt_ops *ops)
@@ -877,3 +878,53 @@ struct stmt *xt_stmt_alloc(const struct location *loc)
 {
 	return stmt_alloc(loc, &xt_stmt_ops);
 }
+
+static const char *synproxy_sack_to_str(const uint32_t flags)
+{
+	if (flags & NF_SYNPROXY_OPT_SACK_PERM)
+		return " sack-perm";
+
+	return "";
+}
+
+static const char *synproxy_timestamp_to_str(const uint32_t flags)
+{
+	if (flags & NF_SYNPROXY_OPT_TIMESTAMP)
+		return " timestamp";
+
+	return "";
+}
+
+static void synproxy_stmt_print(const struct stmt *stmt,
+				struct output_ctx *octx)
+{
+	uint32_t flags = stmt->synproxy.flags;
+	const char *ts_str = synproxy_timestamp_to_str(flags);
+	const char *sack_str = synproxy_sack_to_str(flags);
+
+	if (flags & (NF_SYNPROXY_OPT_MSS | NF_SYNPROXY_OPT_WSCALE))
+		nft_print(octx, "synproxy mss %u wscale %u%s%s",
+			  stmt->synproxy.mss, stmt->synproxy.wscale,
+			  ts_str, sack_str);
+	else if (flags & NF_SYNPROXY_OPT_MSS)
+		nft_print(octx, "synproxy mss %u%s%s", stmt->synproxy.mss,
+			  ts_str, sack_str);
+	else if (flags & NF_SYNPROXY_OPT_WSCALE)
+		nft_print(octx, "synproxy wscale %u%s%s", stmt->synproxy.wscale,
+			  ts_str, sack_str);
+	else
+		nft_print(octx, "synproxy%s%s", ts_str, sack_str);
+
+}
+
+static const struct stmt_ops synproxy_stmt_ops = {
+	.type		= STMT_SYNPROXY,
+	.name		= "synproxy",
+	.print		= synproxy_stmt_print,
+	.json		= synproxy_stmt_json,
+};
+
+struct stmt *synproxy_stmt_alloc(const struct location *loc)
+{
+	return stmt_alloc(loc, &synproxy_stmt_ops);
+}
diff --git a/tests/py/inet/synproxy.t b/tests/py/inet/synproxy.t
new file mode 100644
index 0000000..55a05e1
--- /dev/null
+++ b/tests/py/inet/synproxy.t
@@ -0,0 +1,13 @@
+:synproxychain;type filter hook input priority 0
+
+*ip;synproxyip;synproxychain
+*ip6;synproxyip6;synproxychain
+*inet;synproxyinet;synproxychain
+
+synproxy;ok
+synproxy mss 1460 wscale 7;ok
+synproxy mss 1460 wscale 5 timestamp sack-perm;ok
+synproxy timestamp sack-perm;ok
+synproxy timestamp;ok
+synproxy sack-perm;ok
+
diff --git a/tests/py/inet/synproxy.t.json b/tests/py/inet/synproxy.t.json
new file mode 100644
index 0000000..313fa9f
--- /dev/null
+++ b/tests/py/inet/synproxy.t.json
@@ -0,0 +1,71 @@
+# synproxy
+[
+    {
+        "synproxy":null
+    }
+]
+
+# synproxy mss 1460
+[
+    {
+        "synproxy": {
+            "mss": 1460
+        }
+    }
+]
+
+# synproxy wscale 7
+[
+    {
+        "synproxy": {
+            "wscale": 7
+        }
+    }
+]
+
+# synproxy mss 1460 wscale 7
+[
+    {
+        "synproxy": {
+            "mss": 1460,
+            "wscale": 7
+        }
+    }
+]
+
+# synproxy timestamp
+[
+    {
+        "synproxy": {
+            "flags": [
+                "timestamp"
+            ]
+        }
+    }
+]
+
+# synproxy timestamp sack-perm
+[
+    {
+        "synproxy": {
+            "flags": [
+                "timestamp",
+                "sack-perm"
+            ]
+        }
+    }
+]
+
+# synproxy mss 1460 wscale 7 timestamp sack-perm
+[
+    {
+        "synproxy": {
+            "mss": 1460,
+            "wscale": 7,
+            "flags": [
+                "timestamp",
+                "sack-perm"
+            ]
+        }
+    }
+]
diff --git a/tests/py/inet/synproxy.t.payload b/tests/py/inet/synproxy.t.payload
new file mode 100644
index 0000000..2e6feaa
--- /dev/null
+++ b/tests/py/inet/synproxy.t.payload
@@ -0,0 +1,72 @@
+# synproxy
+ip synproxyip synproxychain
+  [ synproxy mss 0 wscale 0 ]
+
+# synproxy
+ip6 synproxyip6 synproxychain
+  [ synproxy mss 0 wscale 0 ]
+
+# synproxy
+inet synproxyinet synproxychain
+  [ synproxy mss 0 wscale 0 ]
+
+# synproxy mss 1460 wscale 7
+ip synproxyip synproxychain
+  [ synproxy mss 1460 wscale 7 ]
+
+# synproxy mss 1460 wscale 7
+ip6 synproxyip6 synproxychain
+  [ synproxy mss 1460 wscale 7 ]
+
+# synproxy mss 1460 wscale 7
+inet synproxyinet synproxychain
+  [ synproxy mss 1460 wscale 7 ]
+
+# synproxy mss 1460 wscale 5 timestamp sack-perm
+ip synproxyip synproxychain
+  [ synproxy mss 1460 wscale 5 ]
+
+# synproxy mss 1460 wscale 5 timestamp sack-perm
+ip6 synproxyip6 synproxychain
+  [ synproxy mss 1460 wscale 5 ]
+
+# synproxy mss 1460 wscale 5 timestamp sack-perm
+inet synproxyinet synproxychain
+  [ synproxy mss 1460 wscale 5 ]
+
+# synproxy timestamp sack-perm
+ip synproxyip synproxychain
+  [ synproxy mss 0 wscale 0 ]
+
+# synproxy timestamp sack-perm
+ip6 synproxyip6 synproxychain
+  [ synproxy mss 0 wscale 0 ]
+
+# synproxy timestamp sack-perm
+inet synproxyinet synproxychain
+  [ synproxy mss 0 wscale 0 ]
+
+# synproxy timestamp
+ip synproxyip synproxychain
+  [ synproxy mss 0 wscale 0 ]
+
+# synproxy timestamp
+ip6 synproxyip6 synproxychain
+  [ synproxy mss 0 wscale 0 ]
+
+# synproxy timestamp
+inet synproxyinet synproxychain
+  [ synproxy mss 0 wscale 0 ]
+
+# synproxy sack-perm
+ip synproxyip synproxychain
+  [ synproxy mss 0 wscale 0 ]
+
+# synproxy sack-perm
+ip6 synproxyip6 synproxychain
+  [ synproxy mss 0 wscale 0 ]
+
+# synproxy sack-perm
+inet synproxyinet synproxychain
+  [ synproxy mss 0 wscale 0 ]
+
-- 
2.20.1

