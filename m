Return-Path: <SRS0=sEEs=Z2=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCE03C43603
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Dec 2019 14:49:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 96669207DD
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Dec 2019 14:49:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727930AbfLDOtm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 4 Dec 2019 09:49:42 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:58610 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727887AbfLDOtm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 Dec 2019 09:49:42 -0500
Received: from localhost ([::1]:43468 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1icVyF-0000Jw-Ke; Wed, 04 Dec 2019 15:49:39 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [libnftnl PATCH] examples: Replace use of deprecated symbols
Date:   Wed,  4 Dec 2019 15:49:30 +0100
Message-Id: <20191204144930.22005-1-phil@nwl.cc>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Do not use unqualified setters to avoid the warnings. Pass a (false)
zero length value to nftnl_flowtable_set_data() when assigning to
NFTNL_FLOWTABLE_DEVICES as the length value is unused and not even
usable. Maybe one should introduce a dedicated
nftnl_flowtable_set_devices() at a later point.

Fixes: 7349a70634fa0 ("Deprecate untyped data setters")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 examples/nft-chain-add.c               | 4 ++--
 examples/nft-chain-del.c               | 4 ++--
 examples/nft-chain-get.c               | 4 ++--
 examples/nft-ct-helper-get.c           | 6 +++---
 examples/nft-ct-timeout-add.c          | 3 ++-
 examples/nft-ct-timeout-get.c          | 6 +++---
 examples/nft-flowtable-add.c           | 6 +++---
 examples/nft-flowtable-del.c           | 4 ++--
 examples/nft-flowtable-get.c           | 4 ++--
 examples/nft-obj-get.c                 | 6 +++---
 examples/nft-rule-add.c                | 4 ++--
 examples/nft-rule-ct-expectation-add.c | 4 ++--
 examples/nft-rule-ct-helper-add.c      | 4 ++--
 examples/nft-rule-ct-timeout-add.c     | 4 ++--
 examples/nft-rule-del.c                | 4 ++--
 examples/nft-set-del.c                 | 4 ++--
 examples/nft-set-elem-add.c            | 4 ++--
 examples/nft-set-elem-del.c            | 4 ++--
 examples/nft-set-elem-get.c            | 4 ++--
 examples/nft-table-get.c               | 2 +-
 examples/nft-table-upd.c               | 2 +-
 21 files changed, 44 insertions(+), 43 deletions(-)

diff --git a/examples/nft-chain-add.c b/examples/nft-chain-add.c
index 5796d10f8668c..cde4c974759a0 100644
--- a/examples/nft-chain-add.c
+++ b/examples/nft-chain-add.c
@@ -48,8 +48,8 @@ static struct nftnl_chain *chain_add_parse(int argc, char *argv[])
 		perror("OOM");
 		return NULL;
 	}
-	nftnl_chain_set(t, NFTNL_CHAIN_TABLE, argv[2]);
-	nftnl_chain_set(t, NFTNL_CHAIN_NAME, argv[3]);
+	nftnl_chain_set_str(t, NFTNL_CHAIN_TABLE, argv[2]);
+	nftnl_chain_set_str(t, NFTNL_CHAIN_NAME, argv[3]);
 	if (argc == 6) {
 		nftnl_chain_set_u32(t, NFTNL_CHAIN_HOOKNUM, hooknum);
 		nftnl_chain_set_u32(t, NFTNL_CHAIN_PRIO, atoi(argv[5]));
diff --git a/examples/nft-chain-del.c b/examples/nft-chain-del.c
index 09a47182fe499..9956009bb20b7 100644
--- a/examples/nft-chain-del.c
+++ b/examples/nft-chain-del.c
@@ -30,8 +30,8 @@ static struct nftnl_chain *chain_del_parse(int argc, char *argv[])
 		return NULL;
 	}
 
-	nftnl_chain_set(t, NFTNL_CHAIN_TABLE, argv[2]);
-	nftnl_chain_set(t, NFTNL_CHAIN_NAME, argv[3]);
+	nftnl_chain_set_str(t, NFTNL_CHAIN_TABLE, argv[2]);
+	nftnl_chain_set_str(t, NFTNL_CHAIN_NAME, argv[3]);
 
 	return t;
 }
diff --git a/examples/nft-chain-get.c b/examples/nft-chain-get.c
index fcccbf718fd7e..4e3b3c1459dc8 100644
--- a/examples/nft-chain-get.c
+++ b/examples/nft-chain-get.c
@@ -86,8 +86,8 @@ int main(int argc, char *argv[])
 		}
 		nlh = nftnl_chain_nlmsg_build_hdr(buf, NFT_MSG_GETCHAIN, family,
 						NLM_F_ACK, seq);
-		nftnl_chain_set(t, NFTNL_CHAIN_TABLE, argv[2]);
-		nftnl_chain_set(t, NFTNL_CHAIN_NAME, argv[3]);
+		nftnl_chain_set_str(t, NFTNL_CHAIN_TABLE, argv[2]);
+		nftnl_chain_set_str(t, NFTNL_CHAIN_NAME, argv[3]);
 		nftnl_chain_nlmsg_build_payload(nlh, t);
 		nftnl_chain_free(t);
 	} else if (argc >= 2) {
diff --git a/examples/nft-ct-helper-get.c b/examples/nft-ct-helper-get.c
index eb0313322ca79..34134af196a83 100644
--- a/examples/nft-ct-helper-get.c
+++ b/examples/nft-ct-helper-get.c
@@ -90,13 +90,13 @@ int main(int argc, char *argv[])
 		nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_GETOBJ, family,
 					    NLM_F_DUMP, seq);
 		if (argc == 3) {
-			nftnl_obj_set(t, NFTNL_OBJ_TABLE, argv[2]);
+			nftnl_obj_set_str(t, NFTNL_OBJ_TABLE, argv[2]);
 			nftnl_obj_nlmsg_build_payload(nlh, t);
 			nftnl_obj_free(t);
 		}
 	} else {
-		nftnl_obj_set(t, NFTNL_OBJ_TABLE, argv[2]);
-		nftnl_obj_set(t, NFTNL_OBJ_NAME, argv[3]);
+		nftnl_obj_set_str(t, NFTNL_OBJ_TABLE, argv[2]);
+		nftnl_obj_set_str(t, NFTNL_OBJ_NAME, argv[3]);
 
 		nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_GETOBJ, family,
 					    NLM_F_ACK, seq);
diff --git a/examples/nft-ct-timeout-add.c b/examples/nft-ct-timeout-add.c
index 57c0cf00ea7a4..913290f92340d 100644
--- a/examples/nft-ct-timeout-add.c
+++ b/examples/nft-ct-timeout-add.c
@@ -71,7 +71,8 @@ static struct nftnl_obj *obj_add_parse(int argc, char *argv[])
 	nftnl_obj_set_str(t, NFTNL_OBJ_NAME, argv[3]);
 	nftnl_obj_set_u8(t, NFTNL_OBJ_CT_TIMEOUT_L4PROTO, l4proto);
 	nftnl_obj_set_u16(t, NFTNL_OBJ_CT_TIMEOUT_L3PROTO, NFPROTO_IPV4);
-	nftnl_obj_set(t, NFTNL_OBJ_CT_TIMEOUT_ARRAY, timeout);
+	nftnl_obj_set_data(t, NFTNL_OBJ_CT_TIMEOUT_ARRAY,
+			   timeout, timeout_array_size);
 	return t;
 
 }
diff --git a/examples/nft-ct-timeout-get.c b/examples/nft-ct-timeout-get.c
index badcd234529b9..18aed52e987e4 100644
--- a/examples/nft-ct-timeout-get.c
+++ b/examples/nft-ct-timeout-get.c
@@ -89,13 +89,13 @@ int main(int argc, char *argv[])
 		nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_GETOBJ, family,
 					    NLM_F_DUMP, seq);
 		if (argc == 3) {
-			nftnl_obj_set(t, NFTNL_OBJ_TABLE, argv[2]);
+			nftnl_obj_set_str(t, NFTNL_OBJ_TABLE, argv[2]);
 			nftnl_obj_nlmsg_build_payload(nlh, t);
 			nftnl_obj_free(t);
 		}
 	} else {
-		nftnl_obj_set(t, NFTNL_OBJ_TABLE, argv[2]);
-		nftnl_obj_set(t, NFTNL_OBJ_NAME, argv[3]);
+		nftnl_obj_set_str(t, NFTNL_OBJ_TABLE, argv[2]);
+		nftnl_obj_set_str(t, NFTNL_OBJ_NAME, argv[3]);
 
 		nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_GETOBJ, family,
 					    NLM_F_ACK, seq);
diff --git a/examples/nft-flowtable-add.c b/examples/nft-flowtable-add.c
index 8363027deb544..f42d20667c978 100644
--- a/examples/nft-flowtable-add.c
+++ b/examples/nft-flowtable-add.c
@@ -27,13 +27,13 @@ static struct nftnl_flowtable *flowtable_add_parse(int argc, char *argv[])
 		perror("OOM");
 		return NULL;
 	}
-	nftnl_flowtable_set(t, NFTNL_FLOWTABLE_TABLE, argv[2]);
-	nftnl_flowtable_set(t, NFTNL_FLOWTABLE_NAME, argv[3]);
+	nftnl_flowtable_set_str(t, NFTNL_FLOWTABLE_TABLE, argv[2]);
+	nftnl_flowtable_set_str(t, NFTNL_FLOWTABLE_NAME, argv[3]);
 	if (argc == 6) {
 		nftnl_flowtable_set_u32(t, NFTNL_FLOWTABLE_HOOKNUM, hooknum);
 		nftnl_flowtable_set_u32(t, NFTNL_FLOWTABLE_PRIO, atoi(argv[5]));
 	}
-	nftnl_flowtable_set(t, NFTNL_FLOWTABLE_DEVICES, dev_array);
+	nftnl_flowtable_set_data(t, NFTNL_FLOWTABLE_DEVICES, dev_array, 0);
 
 	return t;
 }
diff --git a/examples/nft-flowtable-del.c b/examples/nft-flowtable-del.c
index b25f041a6f6d7..4866ea2c2ae44 100644
--- a/examples/nft-flowtable-del.c
+++ b/examples/nft-flowtable-del.c
@@ -19,8 +19,8 @@ static struct nftnl_flowtable *flowtable_del_parse(int argc, char *argv[])
 		return NULL;
 	}
 
-	nftnl_flowtable_set(t, NFTNL_FLOWTABLE_TABLE, argv[2]);
-	nftnl_flowtable_set(t, NFTNL_FLOWTABLE_NAME, argv[3]);
+	nftnl_flowtable_set_str(t, NFTNL_FLOWTABLE_TABLE, argv[2]);
+	nftnl_flowtable_set_str(t, NFTNL_FLOWTABLE_NAME, argv[3]);
 
 	return t;
 }
diff --git a/examples/nft-flowtable-get.c b/examples/nft-flowtable-get.c
index 1a034ce60579b..0d92fff3cf2e0 100644
--- a/examples/nft-flowtable-get.c
+++ b/examples/nft-flowtable-get.c
@@ -75,8 +75,8 @@ int main(int argc, char *argv[])
 		}
 		nlh = nftnl_flowtable_nlmsg_build_hdr(buf, NFT_MSG_GETFLOWTABLE, family,
 						NLM_F_ACK, seq);
-		nftnl_flowtable_set(t, NFTNL_FLOWTABLE_TABLE, argv[2]);
-		nftnl_flowtable_set(t, NFTNL_FLOWTABLE_NAME, argv[3]);
+		nftnl_flowtable_set_str(t, NFTNL_FLOWTABLE_TABLE, argv[2]);
+		nftnl_flowtable_set_str(t, NFTNL_FLOWTABLE_NAME, argv[3]);
 		nftnl_flowtable_nlmsg_build_payload(nlh, t);
 		nftnl_flowtable_free(t);
 	} else if (argc >= 2) {
diff --git a/examples/nft-obj-get.c b/examples/nft-obj-get.c
index e6a19fe3baf8e..87be3b48bc3f2 100644
--- a/examples/nft-obj-get.c
+++ b/examples/nft-obj-get.c
@@ -89,13 +89,13 @@ int main(int argc, char *argv[])
 		nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_GETOBJ, family,
 					    NLM_F_DUMP, seq);
 		if (argc == 3) {
-			nftnl_obj_set(t, NFTNL_OBJ_TABLE, argv[2]);
+			nftnl_obj_set_str(t, NFTNL_OBJ_TABLE, argv[2]);
 			nftnl_obj_nlmsg_build_payload(nlh, t);
 			nftnl_obj_free(t);
 		}
 	} else {
-		nftnl_obj_set(t, NFTNL_OBJ_TABLE, argv[2]);
-		nftnl_obj_set(t, NFTNL_OBJ_NAME, argv[3]);
+		nftnl_obj_set_str(t, NFTNL_OBJ_TABLE, argv[2]);
+		nftnl_obj_set_str(t, NFTNL_OBJ_NAME, argv[3]);
 		nftnl_obj_set_u32(t, NFTNL_OBJ_TYPE, NFT_OBJECT_COUNTER);
 
 		nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_GETOBJ, family,
diff --git a/examples/nft-rule-add.c b/examples/nft-rule-add.c
index 6aaf5a0650f8a..97805155ba07e 100644
--- a/examples/nft-rule-add.c
+++ b/examples/nft-rule-add.c
@@ -93,8 +93,8 @@ static struct nftnl_rule *setup_rule(uint8_t family, const char *table,
 		exit(EXIT_FAILURE);
 	}
 
-	nftnl_rule_set(r, NFTNL_RULE_TABLE, table);
-	nftnl_rule_set(r, NFTNL_RULE_CHAIN, chain);
+	nftnl_rule_set_str(r, NFTNL_RULE_TABLE, table);
+	nftnl_rule_set_str(r, NFTNL_RULE_CHAIN, chain);
 	nftnl_rule_set_u32(r, NFTNL_RULE_FAMILY, family);
 
 	if (handle != NULL) {
diff --git a/examples/nft-rule-ct-expectation-add.c b/examples/nft-rule-ct-expectation-add.c
index 238e224b409b2..2012b3cfc7572 100644
--- a/examples/nft-rule-ct-expectation-add.c
+++ b/examples/nft-rule-ct-expectation-add.c
@@ -69,8 +69,8 @@ static struct nftnl_rule *setup_rule(uint8_t family, const char *table,
 		exit(EXIT_FAILURE);
 	}
 
-	nftnl_rule_set(r, NFTNL_RULE_TABLE, table);
-	nftnl_rule_set(r, NFTNL_RULE_CHAIN, chain);
+	nftnl_rule_set_str(r, NFTNL_RULE_TABLE, table);
+	nftnl_rule_set_str(r, NFTNL_RULE_CHAIN, chain);
 	nftnl_rule_set_u32(r, NFTNL_RULE_FAMILY, family);
 
 	if (handle != NULL) {
diff --git a/examples/nft-rule-ct-helper-add.c b/examples/nft-rule-ct-helper-add.c
index 1a4fefd46e488..632cc5ccd4e8a 100644
--- a/examples/nft-rule-ct-helper-add.c
+++ b/examples/nft-rule-ct-helper-add.c
@@ -56,8 +56,8 @@ static struct nftnl_rule *setup_rule(uint8_t family, const char *table,
 		exit(EXIT_FAILURE);
 	}
 
-	nftnl_rule_set(r, NFTNL_RULE_TABLE, table);
-	nftnl_rule_set(r, NFTNL_RULE_CHAIN, chain);
+	nftnl_rule_set_str(r, NFTNL_RULE_TABLE, table);
+	nftnl_rule_set_str(r, NFTNL_RULE_CHAIN, chain);
 	nftnl_rule_set_u32(r, NFTNL_RULE_FAMILY, family);
 
 	if (handle != NULL) {
diff --git a/examples/nft-rule-ct-timeout-add.c b/examples/nft-rule-ct-timeout-add.c
index d779d9a1b3b85..d3f843ed1c73b 100644
--- a/examples/nft-rule-ct-timeout-add.c
+++ b/examples/nft-rule-ct-timeout-add.c
@@ -56,8 +56,8 @@ static struct nftnl_rule *setup_rule(uint8_t family, const char *table,
 		exit(EXIT_FAILURE);
 	}
 
-	nftnl_rule_set(r, NFTNL_RULE_TABLE, table);
-	nftnl_rule_set(r, NFTNL_RULE_CHAIN, chain);
+	nftnl_rule_set_str(r, NFTNL_RULE_TABLE, table);
+	nftnl_rule_set_str(r, NFTNL_RULE_CHAIN, chain);
 	nftnl_rule_set_u32(r, NFTNL_RULE_FAMILY, family);
 
 	if (handle != NULL) {
diff --git a/examples/nft-rule-del.c b/examples/nft-rule-del.c
index bfd37abf1621d..fee3011bc4a5e 100644
--- a/examples/nft-rule-del.c
+++ b/examples/nft-rule-del.c
@@ -58,8 +58,8 @@ int main(int argc, char *argv[])
 	}
 
 	seq = time(NULL);
-	nftnl_rule_set(r, NFTNL_RULE_TABLE, argv[2]);
-	nftnl_rule_set(r, NFTNL_RULE_CHAIN, argv[3]);
+	nftnl_rule_set_str(r, NFTNL_RULE_TABLE, argv[2]);
+	nftnl_rule_set_str(r, NFTNL_RULE_CHAIN, argv[3]);
 
 	/* If no handle is specified, delete all rules in the chain */
 	if (argc == 5)
diff --git a/examples/nft-set-del.c b/examples/nft-set-del.c
index 8c216df861d7b..7f20e218705e1 100644
--- a/examples/nft-set-del.c
+++ b/examples/nft-set-del.c
@@ -63,8 +63,8 @@ int main(int argc, char *argv[])
 	nlh = nftnl_set_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
 					NFT_MSG_DELSET, family,
 					NLM_F_ACK, seq);
-	nftnl_set_set(t, NFTNL_SET_TABLE, argv[2]);
-	nftnl_set_set(t, NFTNL_SET_NAME, argv[3]);
+	nftnl_set_set_str(t, NFTNL_SET_TABLE, argv[2]);
+	nftnl_set_set_str(t, NFTNL_SET_NAME, argv[3]);
 
 	nftnl_set_nlmsg_build_payload(nlh, t);
 	nftnl_set_free(t);
diff --git a/examples/nft-set-elem-add.c b/examples/nft-set-elem-add.c
index d5d93d3cf9415..438966f4d57d0 100644
--- a/examples/nft-set-elem-add.c
+++ b/examples/nft-set-elem-add.c
@@ -57,8 +57,8 @@ int main(int argc, char *argv[])
 		exit(EXIT_FAILURE);
 	}
 
-	nftnl_set_set(s, NFTNL_SET_TABLE, argv[2]);
-	nftnl_set_set(s, NFTNL_SET_NAME, argv[3]);
+	nftnl_set_set_str(s, NFTNL_SET_TABLE, argv[2]);
+	nftnl_set_set_str(s, NFTNL_SET_NAME, argv[3]);
 
 	/* Add to dummy elements to set */
 	e = nftnl_set_elem_alloc();
diff --git a/examples/nft-set-elem-del.c b/examples/nft-set-elem-del.c
index b53a86bd908e7..7f63eaf50b7ca 100644
--- a/examples/nft-set-elem-del.c
+++ b/examples/nft-set-elem-del.c
@@ -55,8 +55,8 @@ int main(int argc, char *argv[])
 		exit(EXIT_FAILURE);
 	}
 
-	nftnl_set_set(s, NFTNL_SET_TABLE, argv[2]);
-	nftnl_set_set(s, NFTNL_SET_NAME, argv[3]);
+	nftnl_set_set_str(s, NFTNL_SET_TABLE, argv[2]);
+	nftnl_set_set_str(s, NFTNL_SET_NAME, argv[3]);
 
 	/* Add to dummy elements to set */
 	e = nftnl_set_elem_alloc();
diff --git a/examples/nft-set-elem-get.c b/examples/nft-set-elem-get.c
index 1bc9abca3711a..778e40f1ba014 100644
--- a/examples/nft-set-elem-get.c
+++ b/examples/nft-set-elem-get.c
@@ -81,8 +81,8 @@ int main(int argc, char *argv[])
 
 	nlh = nftnl_set_nlmsg_build_hdr(buf, NFT_MSG_GETSETELEM, family,
 					NLM_F_DUMP|NLM_F_ACK, seq);
-	nftnl_set_set(t, NFTNL_SET_NAME, argv[3]);
-	nftnl_set_set(t, NFTNL_SET_TABLE, argv[2]);
+	nftnl_set_set_str(t, NFTNL_SET_NAME, argv[3]);
+	nftnl_set_set_str(t, NFTNL_SET_TABLE, argv[2]);
 	nftnl_set_elems_nlmsg_build_payload(nlh, t);
 	nftnl_set_free(t);
 
diff --git a/examples/nft-table-get.c b/examples/nft-table-get.c
index eac2f2f6dfc8f..c0c845470c851 100644
--- a/examples/nft-table-get.c
+++ b/examples/nft-table-get.c
@@ -91,7 +91,7 @@ int main(int argc, char *argv[])
 	} else {
 		nlh = nftnl_table_nlmsg_build_hdr(buf, NFT_MSG_GETTABLE, family,
 						NLM_F_ACK, seq);
-		nftnl_table_set(t, NFTNL_TABLE_NAME, argv[2]);
+		nftnl_table_set_str(t, NFTNL_TABLE_NAME, argv[2]);
 		nftnl_table_nlmsg_build_payload(nlh, t);
 		nftnl_table_free(t);
 	}
diff --git a/examples/nft-table-upd.c b/examples/nft-table-upd.c
index 586d84ca48a6f..1c7f9b3fda3a1 100644
--- a/examples/nft-table-upd.c
+++ b/examples/nft-table-upd.c
@@ -72,7 +72,7 @@ int main(int argc, char *argv[])
 		exit(EXIT_FAILURE);
 	}
 
-	nftnl_table_set(t, NFTNL_TABLE_NAME, argv[2]);
+	nftnl_table_set_str(t, NFTNL_TABLE_NAME, argv[2]);
 	nftnl_table_set_u32(t, NFTNL_TABLE_FLAGS, flags);
 
 	table_seq = seq;
-- 
2.24.0

