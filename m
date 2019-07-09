Return-Path: <SRS0=D85U=VG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61715C73C41
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Jul 2019 13:02:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1867E20861
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Jul 2019 13:02:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Om3NdPZ1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbfGINCf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 9 Jul 2019 09:02:35 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:51888 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726047AbfGINCf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Jul 2019 09:02:35 -0400
Received: by mail-wm1-f68.google.com with SMTP id 207so3017994wma.1
        for <netfilter-devel@vger.kernel.org>; Tue, 09 Jul 2019 06:02:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=W/1af/+CguTWj9O7gKhdiSe26k4dHMkUdSFrauY2AqQ=;
        b=Om3NdPZ1IU1fKGzvLmYUkK9aJIRNxqgZcSuKzpu1dZYFQRl1Zi6rWxSeBixlSElu6z
         9qGHxnNzPzIWelmrnZ7bNGgMzBu4JzxUNJj9MYNE9NjuYa36hkNIzc7JNNA6VyLxm/a+
         9VI9YmXr84MZlu44m15l89yuCTL4dPy07fSTsGfsTm4SbyCRAEH2fGDuA3mnl4XGCRQ5
         r55IgrCPPBjcztVOu5B+wVwPpP5fiI6IVhSrmrsehf4cd9hxRoERzEJAUPABoAJtYAw5
         DGULAmjuyJNtxpPqypi01Rnn/KjWWUcoGpLnO2C5jwW/xN7+OaomQfkohziV6Qzxec1s
         /now==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=W/1af/+CguTWj9O7gKhdiSe26k4dHMkUdSFrauY2AqQ=;
        b=Hp8EV6vKpaQfreKms8JC4i31Bh+4QjBL+Yp2Xy6eeCqQhy6YPPSeflINXiO2R9nGGN
         bTTFU/l0U/ZnzA0ym1THdI9H8ENgjBscsKnsfTiO7Ca1RTAYJZRHJTK0iT0q/w8FUqQ9
         y0DiL668ujiqxSTOXst96+ttX7xsLrSrmxIvr8I77tLjdZmKbUOuQRol9F6jv0w1IubE
         GLItcqT3mfhllh5CgU7z4+akSvtlLMP0+I0PQdeqNvz9nLecmV/TEAMKhnRmI0eYbafO
         hUagMpSIc5SUGHd+Y3bfO0yf7DzB74GxQr5vBNP3fiCxY/GXyzJso37hNCKUzBN5fOO7
         lVLg==
X-Gm-Message-State: APjAAAUsZRSdq5cuXAWbhWLbrRuSWylyAiTJ8hn883ouNDFD3cGi9SoF
        +xZKK86aMtLREgjXrtxcQJ715QED
X-Google-Smtp-Source: APXvYqxJYCwpUfVgJK7rSbFQwgoc2fA3bDU+LSs5XJMzW/uuY4KXY/K9Xy9mFTSx6OMkveU4OshSaA==
X-Received: by 2002:a7b:cd8e:: with SMTP id y14mr22553707wmj.155.1562677350813;
        Tue, 09 Jul 2019 06:02:30 -0700 (PDT)
Received: from VGer.neptura.lan ([2a01:e35:8aed:1991::ab91:6451])
        by smtp.gmail.com with ESMTPSA id x6sm20756866wrt.63.2019.07.09.06.02.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 09 Jul 2019 06:02:30 -0700 (PDT)
From:   =?UTF-8?q?St=C3=A9phane=20Veyret?= <sveyret@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     =?UTF-8?q?St=C3=A9phane=20Veyret?= <sveyret@gmail.com>
Subject: [PATCH nftables v5 1/1] add ct expectations support
Date:   Tue,  9 Jul 2019 15:02:09 +0200
Message-Id: <20190709130209.24639-2-sveyret@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190709130209.24639-1-sveyret@gmail.com>
References: <20190709130209.24639-1-sveyret@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This modification allow to directly add/list/delete expectations.

Signed-off-by: Stéphane Veyret <sveyret@gmail.com>
---
 doc/libnftables-json.adoc                     | 55 +++++++++++++++-
 doc/stateful-objects.txt                      | 49 +++++++++++++++
 include/linux/netfilter/nf_tables.h           | 14 ++++-
 include/rule.h                                | 10 +++
 src/evaluate.c                                |  4 ++
 src/json.c                                    | 11 ++++
 src/mnl.c                                     | 13 ++++
 src/netlink.c                                 | 12 ++++
 src/parser_bison.y                            | 62 ++++++++++++++++++-
 src/parser_json.c                             | 45 ++++++++++++++
 src/rule.c                                    | 35 +++++++++++
 src/scanner.l                                 |  1 +
 src/statement.c                               |  4 ++
 tests/py/ip/objects.t                         |  9 +++
 tests/py/ip/objects.t.payload                 |  4 ++
 tests/py/nft-test.py                          |  4 ++
 tests/shell/testcases/listing/0013objects_0   | 10 ++-
 .../testcases/nft-f/0018ct_expectation_obj_0  | 18 ++++++
 18 files changed, 354 insertions(+), 6 deletions(-)
 create mode 100755 tests/shell/testcases/nft-f/0018ct_expectation_obj_0

diff --git a/doc/libnftables-json.adoc b/doc/libnftables-json.adoc
index 429f530..6877f05 100644
--- a/doc/libnftables-json.adoc
+++ b/doc/libnftables-json.adoc
@@ -23,7 +23,7 @@ libnftables-json - Supported JSON schema by libnftables
 
 'LIST_OBJECT' := 'TABLE' | 'CHAIN' | 'RULE' | 'SET' | 'MAP' | 'ELEMENT' |
 		 'FLOWTABLE' | 'COUNTER' | 'QUOTA' | 'CT_HELPER' | 'LIMIT' |
-		 'METAINFO_OBJECT' | 'CT_TIMEOUT'
+		 'METAINFO_OBJECT' | 'CT_TIMEOUT' | 'CT_EXPECTATION'
 
 == DESCRIPTION
 libnftables supports JSON formatted input and output. This is implemented as an
@@ -118,7 +118,7 @@ ____
 
 'ADD_OBJECT' := 'TABLE' | 'CHAIN' | 'RULE' | 'SET' | 'MAP' | 'ELEMENT' |
                 'FLOWTABLE' | 'COUNTER | QUOTA' | 'CT_HELPER' | 'LIMIT' |
-		'CT_TIMEOUT'
+		'CT_TIMEOUT' | 'CT_EXPECTATION'
 ____
 
 Add a new ruleset element to the kernel.
@@ -162,7 +162,8 @@ ____
 'LIST_OBJECT' := 'TABLE' | 'TABLES' | 'CHAIN' | 'CHAINS' | 'SET' | 'SETS' |
                  'MAP' | 'MAPS | COUNTER' | 'COUNTERS' | 'QUOTA' | 'QUOTAS' |
                  'CT_HELPER' | 'CT_HELPERS' | 'LIMIT' | 'LIMITS | RULESET' |
-                 'METER' | 'METERS' | 'FLOWTABLES' | 'CT_TIMEOUT'
+                 'METER' | 'METERS' | 'FLOWTABLES' | 'CT_TIMEOUT' |
+                 'CT_EXPECTATION'
 ____
 
 List ruleset elements. The plural forms are used to list all objects of that
@@ -597,6 +598,45 @@ This object represents a named conntrack timeout policy.
 *l3proto*::
 	The ct timeout object's layer 3 protocol, e.g. *"ip"* or *"ip6"*.
 
+=== CT EXPECTATION
+[verse]
+____
+*{ "ct expectation": {
+	"family":* 'STRING'*,
+	"table":* 'STRING'*,
+	"name":* 'STRING'*,
+	"handle":* 'NUMBER'*,
+	"l3proto":* 'STRING'
+	"protocol":* 'CTH_PROTO'*,
+	"dport":* 'NUMBER'*,
+	"timeout:* 'NUMBER'*,
+	"size:* 'NUMBER'*,
+*}}*
+
+'CTH_PROTO' := *"tcp"* | *"udp"* | *"dccp"* | *"sctp"* | *"gre"* | *"icmpv6"* | *"icmp"* | *"generic"*
+____
+
+This object represents a named conntrack expectation.
+
+*family*::
+	The table's family.
+*table*::
+	The table's name.
+*name*::
+	The ct expectation object's name.
+*handle*::
+	The ct expectation object's handle. In input, it is used by *delete* command only.
+*l3proto*::
+	The ct expectation object's layer 3 protocol, e.g. *"ip"* or *"ip6"*.
+*protocol*::
+	The ct expectation object's layer 4 protocol.
+*dport*::
+	The destination port of the expected connection.
+*timeout*::
+	The time in millisecond that this expectation will live.
+*size*::
+	The maximum count of expectations to be living in the same time.
+
 == STATEMENTS
 Statements are the building blocks for rules. Each rule consists of at least
 one.
@@ -1004,6 +1044,15 @@ Assign connection tracking timeout policy.
 *ct timeout*::
 	CT timeout reference.
 
+=== CT EXPECTATION
+[verse]
+*{ "ct expectation":* 'EXPRESSION' *}*
+
+Assign connection tracking expectation.
+
+*ct expectation*::
+	CT expectation reference.
+
 === XT
 [verse]
 *{ "xt": null }*
diff --git a/doc/stateful-objects.txt b/doc/stateful-objects.txt
index cc1b698..32a3a5c 100644
--- a/doc/stateful-objects.txt
+++ b/doc/stateful-objects.txt
@@ -95,6 +95,55 @@ sport=22 dport=41360 [UNREPLIED] src=172.16.19.1 dst=172.16.19.128
 sport=41360 dport=22
 ----------------------------------
 
+CT EXPECTATION
+~~~~~~~~~~~~~~
+[verse]
+*ct expectation* 'name' *{ protocol* 'protocol' *; dport* 'dport' *; timeout* 'timeout' *; size* 'size' *; [*l3proto* 'family' *;*] *}*
+
+Ct expectation is used to create connection expectations. Expectations are
+assigned with the *ct expectation set* statement. 'protocol', 'dport',
+'timeout' and 'size' are mandatory, l3proto is derived from the table family
+by default.
+
+.conntrack expectation specifications
+[options="header"]
+|=================
+|Keyword | Description | Type
+|protocol |
+layer 4 protocol of the expectation object |
+string (e.g. ip)
+|dport |
+destination port of expected connection |
+unsigned integer
+|timeout |
+timeout value for expectation |
+unsigned integer
+|size |
+size value for expectation |
+unsigned integer
+|l3proto |
+layer 3 protocol of the expectation object |
+address family (e.g. ip)
+|=================
+
+.defining and assigning ct expectation policy
+---------------------------------------------
+table ip filter {
+	ct expectation expect {
+		protocol udp
+		dport 9876
+		timeout 2m
+		size 8
+		l3proto ip
+	}
+
+	chain input {
+		type filter hook input priority filter; policy accept;
+		ct expectation set "expect"
+	}
+}
+----------------------------------
+
 COUNTER
 ~~~~~~~
 [verse]
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 393bcb5..709fbc8 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -1445,6 +1445,17 @@ enum nft_ct_timeout_timeout_attributes {
 };
 #define NFTA_CT_TIMEOUT_MAX	(__NFTA_CT_TIMEOUT_MAX - 1)
 
+enum nft_ct_expect_attributes {
+	NFTA_CT_EXPECT_UNSPEC,
+	NFTA_CT_EXPECT_L3PROTO,
+	NFTA_CT_EXPECT_L4PROTO,
+	NFTA_CT_EXPECT_DPORT,
+	NFTA_CT_EXPECT_TIMEOUT,
+	NFTA_CT_EXPECT_SIZE,
+	__NFTA_CT_EXPECT_MAX,
+};
+#define NFTA_CT_EXPECT_MAX	(__NFTA_CT_EXPECT_MAX - 1)
+
 #define NFT_OBJECT_UNSPEC	0
 #define NFT_OBJECT_COUNTER	1
 #define NFT_OBJECT_QUOTA	2
@@ -1454,7 +1465,8 @@ enum nft_ct_timeout_timeout_attributes {
 #define NFT_OBJECT_TUNNEL	6
 #define NFT_OBJECT_CT_TIMEOUT	7
 #define NFT_OBJECT_SECMARK	8
-#define __NFT_OBJECT_MAX	9
+#define NFT_OBJECT_CT_EXPECT	9
+#define __NFT_OBJECT_MAX	10
 #define NFT_OBJECT_MAX		(__NFT_OBJECT_MAX - 1)
 
 /**
diff --git a/include/rule.h b/include/rule.h
index aefb24d..22cae86 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -355,6 +355,14 @@ struct ct_timeout {
 	struct list_head timeout_list;
 };
 
+struct ct_expect {
+	uint16_t l3proto;
+	uint8_t l4proto;
+	uint16_t dport;
+	uint32_t timeout;
+	uint8_t size;
+};
+
 struct limit {
 	uint64_t	rate;
 	uint64_t	unit;
@@ -389,6 +397,7 @@ struct obj {
 		struct limit		limit;
 		struct ct_timeout	ct_timeout;
 		struct secmark		secmark;
+		struct ct_expect	ct_expect;
 	};
 };
 
@@ -523,6 +532,7 @@ enum cmd_obj {
 	CMD_OBJ_CT_TIMEOUT,
 	CMD_OBJ_SECMARK,
 	CMD_OBJ_SECMARKS,
+	CMD_OBJ_CT_EXPECT,
 };
 
 struct markup {
diff --git a/src/evaluate.c b/src/evaluate.c
index 8086f75..da9e806 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -3520,6 +3520,7 @@ static int cmd_evaluate_add(struct eval_ctx *ctx, struct cmd *cmd)
 	case CMD_OBJ_LIMIT:
 	case CMD_OBJ_CT_TIMEOUT:
 	case CMD_OBJ_SECMARK:
+	case CMD_OBJ_CT_EXPECT:
 		return obj_evaluate(ctx, cmd->object);
 	default:
 		BUG("invalid command object type %u\n", cmd->obj);
@@ -3542,6 +3543,7 @@ static int cmd_evaluate_delete(struct eval_ctx *ctx, struct cmd *cmd)
 	case CMD_OBJ_CT_TIMEOUT:
 	case CMD_OBJ_LIMIT:
 	case CMD_OBJ_SECMARK:
+	case CMD_OBJ_CT_EXPECT:
 		return 0;
 	default:
 		BUG("invalid command object type %u\n", cmd->obj);
@@ -3686,6 +3688,8 @@ static int cmd_evaluate_list(struct eval_ctx *ctx, struct cmd *cmd)
 		return cmd_evaluate_list_obj(ctx, cmd, NFT_OBJECT_LIMIT);
 	case CMD_OBJ_SECMARK:
 		return cmd_evaluate_list_obj(ctx, cmd, NFT_OBJECT_SECMARK);
+	case CMD_OBJ_CT_EXPECT:
+		return cmd_evaluate_list_obj(ctx, cmd, NFT_OBJECT_CT_EXPECT);
 	case CMD_OBJ_COUNTERS:
 	case CMD_OBJ_QUOTAS:
 	case CMD_OBJ_CT_HELPERS:
diff --git a/src/json.c b/src/json.c
index 1006d7b..55ea6f1 100644
--- a/src/json.c
+++ b/src/json.c
@@ -325,6 +325,17 @@ static json_t *obj_print_json(const struct obj *obj)
 		json_object_update(root, tmp);
 		json_decref(tmp);
 		break;
+	case NFT_OBJECT_CT_EXPECT:
+		tmp = json_pack("{s:o, s:I, s:I, s:s, s:I}",
+				"protocol",
+				proto_name_json(obj->ct_expect.l4proto),
+				"dport", obj->ct_expect.dport,
+				"timeout", obj->ct_expect.timeout,
+				"size", obj->ct_expect.size,
+				"l3proto", family2str(obj->ct_expect.l3proto));
+		json_object_update(root, tmp);
+		json_decref(tmp);
+		break;
 	case NFT_OBJECT_LIMIT:
 		rate = obj->limit.rate;
 		burst = obj->limit.burst;
diff --git a/src/mnl.c b/src/mnl.c
index c145cc5..37e1d21 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -1003,6 +1003,19 @@ int mnl_nft_obj_add(struct netlink_ctx *ctx, const struct cmd *cmd,
 		nftnl_obj_set(nlo, NFTNL_OBJ_CT_TIMEOUT_ARRAY,
 			      obj->ct_timeout.timeout);
 		break;
+	case NFT_OBJECT_CT_EXPECT:
+		if (obj->ct_expect.l3proto)
+			nftnl_obj_set_u16(nlo, NFTNL_OBJ_CT_EXPECT_L3PROTO,
+					  obj->ct_expect.l3proto);
+		nftnl_obj_set_u8(nlo, NFTNL_OBJ_CT_EXPECT_L4PROTO,
+				 obj->ct_expect.l4proto);
+		nftnl_obj_set_u16(nlo, NFTNL_OBJ_CT_EXPECT_DPORT,
+				  obj->ct_expect.dport);
+		nftnl_obj_set_u32(nlo, NFTNL_OBJ_CT_EXPECT_TIMEOUT,
+				  obj->ct_expect.timeout);
+		nftnl_obj_set_u8(nlo, NFTNL_OBJ_CT_EXPECT_SIZE,
+				 obj->ct_expect.size);
+		break;
 	case NFT_OBJECT_SECMARK:
 		nftnl_obj_set_str(nlo, NFTNL_OBJ_SECMARK_CTX,
 				  obj->secmark.ctx);
diff --git a/src/netlink.c b/src/netlink.c
index 97eb082..d953b16 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -996,6 +996,18 @@ struct obj *netlink_delinearize_obj(struct netlink_ctx *ctx,
 		obj->limit.flags =
 			nftnl_obj_get_u32(nlo, NFTNL_OBJ_LIMIT_FLAGS);
 		break;
+	case NFT_OBJECT_CT_EXPECT:
+		obj->ct_expect.l3proto =
+			nftnl_obj_get_u16(nlo, NFTNL_OBJ_CT_EXPECT_L3PROTO);
+		obj->ct_expect.l4proto =
+			nftnl_obj_get_u8(nlo, NFTNL_OBJ_CT_EXPECT_L4PROTO);
+		obj->ct_expect.dport =
+			nftnl_obj_get_u16(nlo, NFTNL_OBJ_CT_EXPECT_DPORT);
+		obj->ct_expect.timeout =
+			nftnl_obj_get_u32(nlo, NFTNL_OBJ_CT_EXPECT_TIMEOUT);
+		obj->ct_expect.size =
+			nftnl_obj_get_u8(nlo, NFTNL_OBJ_CT_EXPECT_SIZE);
+		break;
 	}
 	obj->type = type;
 
diff --git a/src/parser_bison.y b/src/parser_bison.y
index a4905f2..a0007bb 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -435,6 +435,7 @@ int nft_lex(void *, void *, void *);
 %token ZONE			"zone"
 %token DIRECTION		"direction"
 %token EVENT			"event"
+%token EXPECTATION		"expectation"
 %token EXPIRATION		"expiration"
 %token HELPER			"helper"
 %token LABEL			"label"
@@ -582,7 +583,7 @@ int nft_lex(void *, void *, void *);
 %type <flowtable>		flowtable_block_alloc flowtable_block
 %destructor { flowtable_free($$); }	flowtable_block_alloc
 
-%type <obj>			obj_block_alloc counter_block quota_block ct_helper_block ct_timeout_block limit_block secmark_block
+%type <obj>			obj_block_alloc counter_block quota_block ct_helper_block ct_timeout_block ct_expect_block limit_block secmark_block
 %destructor { obj_free($$); }	obj_block_alloc
 
 %type <list>			stmt_list
@@ -984,6 +985,10 @@ add_cmd			:	TABLE		table_spec
 			{
 				$$ = cmd_alloc_obj_ct(CMD_ADD, NFT_OBJECT_CT_TIMEOUT, &$3, &@$, $4);
 			}
+			|	CT	EXPECTATION	obj_spec	ct_obj_alloc	'{' ct_expect_block '}'
+			{
+				$$ = cmd_alloc_obj_ct(CMD_ADD, NFT_OBJECT_CT_EXPECT, &$3, &@$, $4);
+			}
 			|	LIMIT		obj_spec	limit_obj
 			{
 				$$ = cmd_alloc(CMD_ADD, CMD_OBJ_LIMIT, &$2, &@$, $3);
@@ -1073,6 +1078,10 @@ create_cmd		:	TABLE		table_spec
 			{
 				$$ = cmd_alloc_obj_ct(CMD_CREATE, NFT_OBJECT_CT_TIMEOUT, &$3, &@$, $4);
 			}
+			|	CT	EXPECTATION obj_spec	ct_obj_alloc	'{' ct_expect_block '}'
+			{
+				$$ = cmd_alloc_obj_ct(CMD_CREATE, NFT_OBJECT_CT_EXPECT, &$3, &@$, $4);
+			}
 			|	LIMIT		obj_spec	limit_obj
 			{
 				$$ = cmd_alloc(CMD_CREATE, CMD_OBJ_LIMIT, &$2, &@$, $3);
@@ -1293,6 +1302,10 @@ list_cmd		:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_CT_TIMEOUT, &$4, &@$, NULL);
 			}
+			|	CT		EXPECTATION		TABLE		table_spec
+			{
+				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_CT_EXPECT, &$4, &@$, NULL);
+			}
 			;
 
 reset_cmd		:	COUNTERS	ruleset_spec
@@ -1533,6 +1546,15 @@ table_block		:	/* empty */	{ $$ = $<table>-1; }
 				list_add_tail(&$5->list, &$1->objs);
 				$$ = $1;
 			}
+			|	table_block	CT	EXPECTATION obj_identifier obj_block_alloc '{'	ct_expect_block	'}' stmt_separator
+			{
+				$5->location = @4;
+				$5->type = NFT_OBJECT_CT_EXPECT;
+				handle_merge(&$5->handle, &$4);
+				handle_free(&$4);
+				list_add_tail(&$5->list, &$1->objs);
+				$$ = $1;
+			}
 			|	table_block	LIMIT		obj_identifier
 					obj_block_alloc	'{'	limit_block	'}'
 					stmt_separator
@@ -1857,6 +1879,15 @@ ct_timeout_block	:	/*empty */	{ $$ = $<obj>-1; }
 			}
 			;
 
+ct_expect_block		:	/*empty */	{ $$ = $<obj>-1; }
+			|	ct_expect_block     common_block
+			|	ct_expect_block     stmt_separator
+			|	ct_expect_block     ct_expect_config
+			{
+				$$ = $1;
+			}
+			;
+
 limit_block		:	/* empty */	{ $$ = $<obj>-1; }
 			|       limit_block     common_block
 			|       limit_block     stmt_separator
@@ -3471,6 +3502,7 @@ secmark_obj		:	secmark_config
 
 ct_obj_type		:	HELPER		{ $$ = NFT_OBJECT_CT_HELPER; }
 			|	TIMEOUT		{ $$ = NFT_OBJECT_CT_TIMEOUT; }
+			|	EXPECTATION	{ $$ = NFT_OBJECT_CT_EXPECT; }
 			;
 
 ct_l4protoname		:	TCP	{ $$ = IPPROTO_TCP; }
@@ -3547,6 +3579,28 @@ ct_timeout_config	:	PROTOCOL	ct_l4protoname	stmt_separator
 			}
 			;
 
+ct_expect_config	:	PROTOCOL	ct_l4protoname	stmt_separator
+			{
+				$<obj>0->ct_expect.l4proto = $2;
+			}
+			|	DPORT	NUM	stmt_separator
+			{
+				$<obj>0->ct_expect.dport = $2;
+			}
+			|	TIMEOUT	time_spec	stmt_separator
+			{
+				$<obj>0->ct_expect.timeout = $2;
+			}
+			|	SIZE	NUM	stmt_separator
+			{
+				$<obj>0->ct_expect.size = $2;
+			}
+			|	L3PROTOCOL	family_spec_explicit	stmt_separator
+			{
+				$<obj>0->ct_expect.l3proto = $2;
+			}
+			;
+
 ct_obj_alloc		:
 			{
 				$$ = obj_alloc(&@$);
@@ -4166,6 +4220,12 @@ ct_stmt			:	CT	ct_key		SET	stmt_expr
 				$$->objref.expr = $4;
 
 			}
+			|	CT	EXPECTATION	SET	stmt_expr
+			{
+				$$ = objref_stmt_alloc(&@$);
+				$$->objref.type = NFT_OBJECT_CT_EXPECT;
+				$$->objref.expr = $4;
+			}
 			|	CT	ct_dir	ct_key_dir_optional SET	stmt_expr
 			{
 				$$ = ct_stmt_alloc(&@$, $3, $2, $5);
diff --git a/src/parser_json.c b/src/parser_json.c
index f701ebd..ee8bd33 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -2210,6 +2210,21 @@ static struct stmt *json_parse_cttimeout_stmt(struct json_ctx *ctx,
 	return stmt;
 }
 
+static struct stmt *json_parse_ctexpect_stmt(struct json_ctx *ctx,
+					     const char *key, json_t *value)
+{
+	struct stmt *stmt = objref_stmt_alloc(int_loc);
+
+	stmt->objref.type = NFT_OBJECT_CT_EXPECT;
+	stmt->objref.expr = json_parse_stmt_expr(ctx, value);
+	if (!stmt->objref.expr) {
+		json_error(ctx, "Invalid ct expectation reference.");
+		stmt_free(stmt);
+		return NULL;
+	}
+	return stmt;
+}
+
 static struct stmt *json_parse_meter_stmt(struct json_ctx *ctx,
 					  const char *key, json_t *value)
 {
@@ -2355,6 +2370,7 @@ static struct stmt *json_parse_stmt(struct json_ctx *ctx, json_t *root)
 		{ "log", json_parse_log_stmt },
 		{ "ct helper", json_parse_cthelper_stmt },
 		{ "ct timeout", json_parse_cttimeout_stmt },
+		{ "ct expectation", json_parse_ctexpect_stmt },
 		{ "meter", json_parse_meter_stmt },
 		{ "queue", json_parse_queue_stmt },
 		{ "ct count", json_parse_connlimit_stmt },
@@ -3014,6 +3030,33 @@ static struct cmd *json_parse_cmd_add_object(struct json_ctx *ctx,
 			return NULL;
 		}
 		break;
+	case NFT_OBJECT_CT_EXPECT:
+		cmd_obj = CMD_OBJ_CT_EXPECT;
+		obj->type = NFT_OBJECT_CT_EXPECT;
+		if (!json_unpack(root, "{s:s}", "l3proto", &tmp) &&
+		    parse_family(tmp, &l3proto)) {
+			json_error(ctx, "Invalid ct expectation l3proto '%s'.", tmp);
+			obj_free(obj);
+			return NULL;
+		}
+		obj->ct_expect.l3proto = l3proto;
+		if (!json_unpack(root, "{s:s}", "protocol", &tmp)) {
+			if (!strcmp(tmp, "tcp")) {
+				obj->ct_expect.l4proto = IPPROTO_TCP;
+			} else if (!strcmp(tmp, "udp")) {
+				obj->ct_expect.l4proto = IPPROTO_UDP;
+			} else {
+				json_error(ctx, "Invalid ct expectation protocol '%s'.", tmp);
+				obj_free(obj);
+				return NULL;
+			}
+		}
+		if (!json_unpack(root, "{s:o}", "dport", &tmp))
+			obj->ct_expect.dport = atoi(tmp);
+		json_unpack(root, "{s:I}", "timeout", &obj->ct_expect.timeout);
+		if (!json_unpack(root, "{s:o}", "size", &tmp))
+			obj->ct_expect.size = atoi(tmp);
+		break;
 	case CMD_OBJ_LIMIT:
 		obj->type = NFT_OBJECT_LIMIT;
 		if (json_unpack_err(ctx, root, "{s:I, s:s}",
@@ -3069,6 +3112,7 @@ static struct cmd *json_parse_cmd_add(struct json_ctx *ctx,
 		{ "quota", CMD_OBJ_QUOTA, json_parse_cmd_add_object },
 		{ "ct helper", NFT_OBJECT_CT_HELPER, json_parse_cmd_add_object },
 		{ "ct timeout", NFT_OBJECT_CT_TIMEOUT, json_parse_cmd_add_object },
+		{ "ct expectation", NFT_OBJECT_CT_EXPECT, json_parse_cmd_add_object },
 		{ "limit", CMD_OBJ_LIMIT, json_parse_cmd_add_object },
 		{ "secmark", CMD_OBJ_SECMARK, json_parse_cmd_add_object }
 	};
@@ -3234,6 +3278,7 @@ static struct cmd *json_parse_cmd_list(struct json_ctx *ctx,
 		{ "ct helper", NFT_OBJECT_CT_HELPER, json_parse_cmd_add_object },
 		{ "ct helpers", CMD_OBJ_CT_HELPERS, json_parse_cmd_list_multiple },
 		{ "ct timeout", NFT_OBJECT_CT_TIMEOUT, json_parse_cmd_add_object },
+		{ "ct expectation", NFT_OBJECT_CT_EXPECT, json_parse_cmd_add_object },
 		{ "limit", CMD_OBJ_LIMIT, json_parse_cmd_add_object },
 		{ "limits", CMD_OBJ_LIMIT, json_parse_cmd_list_multiple },
 		{ "ruleset", CMD_OBJ_RULESET, json_parse_cmd_list_multiple },
diff --git a/src/rule.c b/src/rule.c
index 0a91917..be24c4b 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1442,6 +1442,7 @@ void cmd_free(struct cmd *cmd)
 		case CMD_OBJ_QUOTA:
 		case CMD_OBJ_CT_HELPER:
 		case CMD_OBJ_CT_TIMEOUT:
+		case CMD_OBJ_CT_EXPECT:
 		case CMD_OBJ_LIMIT:
 		case CMD_OBJ_SECMARK:
 			obj_free(cmd->object);
@@ -1532,6 +1533,7 @@ static int do_command_add(struct netlink_ctx *ctx, struct cmd *cmd, bool excl)
 	case CMD_OBJ_QUOTA:
 	case CMD_OBJ_CT_HELPER:
 	case CMD_OBJ_CT_TIMEOUT:
+	case CMD_OBJ_CT_EXPECT:
 	case CMD_OBJ_LIMIT:
 	case CMD_OBJ_SECMARK:
 		return mnl_nft_obj_add(ctx, cmd, flags);
@@ -1613,6 +1615,8 @@ static int do_command_delete(struct netlink_ctx *ctx, struct cmd *cmd)
 		return mnl_nft_obj_del(ctx, cmd, NFT_OBJECT_CT_HELPER);
 	case CMD_OBJ_CT_TIMEOUT:
 		return mnl_nft_obj_del(ctx, cmd, NFT_OBJECT_CT_TIMEOUT);
+	case CMD_OBJ_CT_EXPECT:
+		return mnl_nft_obj_del(ctx, cmd, NFT_OBJECT_CT_EXPECT);
 	case CMD_OBJ_LIMIT:
 		return mnl_nft_obj_del(ctx, cmd, NFT_OBJECT_LIMIT);
 	case CMD_OBJ_SECMARK:
@@ -1842,6 +1846,30 @@ static void obj_print_data(const struct obj *obj,
 		print_proto_timeout_policy(obj->ct_timeout.l4proto,
 					   obj->ct_timeout.timeout, opts, octx);
 		break;
+	case NFT_OBJECT_CT_EXPECT:
+		nft_print(octx, " %s {", obj->handle.obj.name);
+		if (nft_output_handle(octx))
+			nft_print(octx, " # handle %" PRIu64, obj->handle.handle.id);
+		nft_print(octx, "%s", opts->nl);
+		nft_print(octx, "%s%sprotocol ", opts->tab, opts->tab);
+		print_proto_name_proto(obj->ct_expect.l4proto, octx);
+		nft_print(octx, "%s", opts->stmt_separator);
+		nft_print(octx, "%s%sdport %d%s",
+			  opts->tab, opts->tab,
+			  obj->ct_expect.dport,
+			  opts->stmt_separator);
+		nft_print(octx, "%s%stimeout ", opts->tab, opts->tab);
+		time_print(obj->ct_expect.timeout, octx);
+		nft_print(octx, "%s", opts->stmt_separator);
+		nft_print(octx, "%s%ssize %d%s",
+			  opts->tab, opts->tab,
+			  obj->ct_expect.size,
+			  opts->stmt_separator);
+		nft_print(octx, "%s%sl3proto %s%s",
+			  opts->tab, opts->tab,
+			  family2str(obj->ct_expect.l3proto),
+			  opts->stmt_separator);
+		break;
 	case NFT_OBJECT_LIMIT: {
 		bool inv = obj->limit.flags & NFT_LIMIT_F_INV;
 		const char *data_unit;
@@ -1891,6 +1919,7 @@ static const char * const obj_type_name_array[] = {
 	[NFT_OBJECT_LIMIT]	= "limit",
 	[NFT_OBJECT_CT_TIMEOUT] = "ct timeout",
 	[NFT_OBJECT_SECMARK]	= "secmark",
+	[NFT_OBJECT_CT_EXPECT]	= "ct expectation",
 };
 
 const char *obj_type_name(enum stmt_types type)
@@ -1907,6 +1936,7 @@ static uint32_t obj_type_cmd_array[NFT_OBJECT_MAX + 1] = {
 	[NFT_OBJECT_LIMIT]	= CMD_OBJ_LIMIT,
 	[NFT_OBJECT_CT_TIMEOUT] = CMD_OBJ_CT_TIMEOUT,
 	[NFT_OBJECT_SECMARK]	= CMD_OBJ_SECMARK,
+	[NFT_OBJECT_CT_EXPECT]	= CMD_OBJ_CT_EXPECT,
 };
 
 uint32_t obj_type_to_cmd(uint32_t type)
@@ -2265,6 +2295,8 @@ static int do_command_list(struct netlink_ctx *ctx, struct cmd *cmd)
 		return do_list_obj(ctx, cmd, NFT_OBJECT_CT_HELPER);
 	case CMD_OBJ_CT_TIMEOUT:
 		return do_list_obj(ctx, cmd, NFT_OBJECT_CT_TIMEOUT);
+	case CMD_OBJ_CT_EXPECT:
+		return do_list_obj(ctx, cmd, NFT_OBJECT_CT_EXPECT);
 	case CMD_OBJ_LIMIT:
 	case CMD_OBJ_LIMITS:
 		return do_list_obj(ctx, cmd, NFT_OBJECT_LIMIT);
@@ -2456,6 +2488,9 @@ struct cmd *cmd_alloc_obj_ct(enum cmd_ops op, int type, const struct handle *h,
 	case NFT_OBJECT_CT_TIMEOUT:
 		cmd_obj = CMD_OBJ_CT_TIMEOUT;
 		break;
+	case NFT_OBJECT_CT_EXPECT:
+		cmd_obj = CMD_OBJ_CT_EXPECT;
+		break;
 	default:
 		BUG("missing type mapping");
 	}
diff --git a/src/scanner.l b/src/scanner.l
index 7f6c043..51bf64f 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -529,6 +529,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "reply"			{ return REPLY; }
 "direction"		{ return DIRECTION; }
 "event"			{ return EVENT; }
+"expectation"		{ return EXPECTATION; }
 "expiration"		{ return EXPIRATION; }
 "helper"		{ return HELPER; }
 "helpers"		{ return HELPERS; }
diff --git a/src/statement.c b/src/statement.c
index c559423..a82c1b3 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -208,6 +208,7 @@ static const char *objref_type[NFT_OBJECT_MAX + 1] = {
 	[NFT_OBJECT_LIMIT]	= "limit",
 	[NFT_OBJECT_CT_TIMEOUT] = "ct timeout",
 	[NFT_OBJECT_SECMARK]	= "secmark",
+	[NFT_OBJECT_CT_EXPECT]	= "ct expectation",
 };
 
 const char *objref_type_name(uint32_t type)
@@ -227,6 +228,9 @@ static void objref_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 	case NFT_OBJECT_CT_TIMEOUT:
 		nft_print(octx, "ct timeout set ");
 		break;
+	case NFT_OBJECT_CT_EXPECT:
+		nft_print(octx, "ct expectation set ");
+		break;
 	default:
 		nft_print(octx, "%s name ",
 			  objref_type_name(stmt->objref.type));
diff --git a/tests/py/ip/objects.t b/tests/py/ip/objects.t
index fc2ee26..35d0110 100644
--- a/tests/py/ip/objects.t
+++ b/tests/py/ip/objects.t
@@ -41,3 +41,12 @@ limit name tcp dport map {443 : "lim1", 80 : "lim2", 22 : "lim1"};ok
 %cttime5 type ct timeout {protocol tcp; policy = { estalbished:100 } ;};fail
 
 ct timeout set "cttime1";ok
+
+# ct expectation
+%ctexpect1 type ct expectation { protocol tcp; dport 1234; timeout 2m; size 12; };ok
+%ctexpect2 type ct expectation { protocol udp; };fail
+%ctexpect3 type ct expectation { protocol tcp; dport 4321; };fail
+%ctexpect4 type ct expectation { protocol tcp; dport 4321; timeout 2m; };fail
+%ctexpect5 type ct expectation { protocol udp; dport 9876; timeout 2m; size 12; l3proto ip; };ok
+
+ct expectation set "ctexpect1";ok
diff --git a/tests/py/ip/objects.t.payload b/tests/py/ip/objects.t.payload
index 719b6c3..ef3e86a 100644
--- a/tests/py/ip/objects.t.payload
+++ b/tests/py/ip/objects.t.payload
@@ -63,3 +63,7 @@ ip test-ip4 output
 # ct timeout set "cttime1"
 ip test-ip4 output
   [ objref type 7 name cttime1 ]
+
+# ct expectation set "ctexpect1"
+ip test-ip4 output
+  [ objref type 9 name ctexpect1 ]
diff --git a/tests/py/nft-test.py b/tests/py/nft-test.py
index fcbd28c..7f424cf 100755
--- a/tests/py/nft-test.py
+++ b/tests/py/nft-test.py
@@ -1123,6 +1123,10 @@ def obj_process(obj_line, filename, lineno):
        obj_type = "ct timeout"
        tokens[3] = ""
 
+    if obj_type == "ct" and tokens[3] == "expectation":
+       obj_type = "ct expectation"
+       tokens[3] = ""
+
     if len(tokens) > 3:
         obj_spcf = " ".join(tokens[3:])
 
diff --git a/tests/shell/testcases/listing/0013objects_0 b/tests/shell/testcases/listing/0013objects_0
index da782a6..f691579 100755
--- a/tests/shell/testcases/listing/0013objects_0
+++ b/tests/shell/testcases/listing/0013objects_0
@@ -18,6 +18,14 @@ EXPECTED="table ip test {
 		policy = { unreplied : 15, replied : 12 }
 	}
 
+	ct expectation ctexpect {
+		protocol tcp
+		dport 5432
+		timeout 1h
+		size 12
+		l3proto ip
+	}
+
 	chain input {
 	}
 }"
@@ -29,6 +37,7 @@ $NFT add chain test input
 $NFT add quota test https-quota 25 mbytes
 $NFT add ct helper test cthelp { type \"sip\" protocol tcp \; }
 $NFT add ct timeout test cttime { protocol udp \; policy = {replied : 12, unreplied : 15 } \; }
+$NFT add ct expectation test ctexpect { protocol tcp \; dport 5432 \; timeout 1h \; size 12 \; }
 $NFT add table test-ip
 
 GET="$($NFT list table test)"
@@ -37,4 +46,3 @@ if [ "$EXPECTED" != "$GET" ] ; then
 	[ -x $DIFF ] && $DIFF -u <(echo "$EXPECTED") <(echo "$GET")
 	exit 1
 fi
-
diff --git a/tests/shell/testcases/nft-f/0018ct_expectation_obj_0 b/tests/shell/testcases/nft-f/0018ct_expectation_obj_0
new file mode 100755
index 0000000..eb9df3c
--- /dev/null
+++ b/tests/shell/testcases/nft-f/0018ct_expectation_obj_0
@@ -0,0 +1,18 @@
+#!/bin/bash
+
+EXPECTED='table ip filter {
+	ct expectation ctexpect{
+		protocol tcp
+		dport 9876
+		timeout 1m
+		size 12
+		l3proto ip
+	}
+
+	chain c {
+		ct expectation set "ctexpect"
+	}
+}'
+
+set -e
+$NFT -f - <<< $EXPECTED
-- 
2.21.0

