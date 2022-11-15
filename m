Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C1A7C4332F
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Nov 2022 11:44:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232839AbiKOLog (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 15 Nov 2022 06:44:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbiKOLof (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 15 Nov 2022 06:44:35 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4207325EAD
        for <netfilter-devel@vger.kernel.org>; Tue, 15 Nov 2022 03:44:32 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnftnl] src: replace nftnl_*_nlmsg_build_hdr() by nftnl_nlmsg_build_hdr()
Date:   Tue, 15 Nov 2022 12:44:26 +0100
Message-Id: <20221115114426.172288-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Use nftnl_nlmsg_build_hdr() instead of nftnl_*_nlmsg_build_hdr().

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 examples/nft-chain-add.c               |  6 +++---
 examples/nft-chain-del.c               |  5 ++---
 examples/nft-chain-get.c               |  8 ++++----
 examples/nft-flowtable-add.c           |  6 +++---
 examples/nft-flowtable-del.c           |  6 +++---
 examples/nft-flowtable-get.c           |  8 ++++----
 examples/nft-map-add.c                 |  6 +++---
 examples/nft-rule-add.c                | 10 +++++-----
 examples/nft-rule-ct-expectation-add.c | 11 +++++------
 examples/nft-rule-ct-helper-add.c      | 10 +++++-----
 examples/nft-rule-ct-timeout-add.c     | 10 +++++-----
 examples/nft-rule-del.c                |  7 ++-----
 examples/nft-rule-get.c                |  4 ++--
 examples/nft-ruleset-get.c             | 20 ++++++++++----------
 examples/nft-set-add.c                 |  6 +++---
 examples/nft-set-del.c                 |  5 ++---
 examples/nft-set-elem-del.c            |  5 ++---
 examples/nft-set-elem-get.c            |  4 ++--
 examples/nft-set-get.c                 |  4 ++--
 examples/nft-table-add.c               |  6 +++---
 examples/nft-table-del.c               |  6 +++---
 examples/nft-table-get.c               |  8 ++++----
 examples/nft-table-upd.c               |  5 ++---
 src/common.c                           |  5 ++---
 tests/nft-chain-test.c                 |  3 +--
 tests/nft-expr_bitwise-test.c          |  6 +++---
 tests/nft-expr_byteorder-test.c        |  2 +-
 tests/nft-expr_cmp-test.c              |  2 +-
 tests/nft-expr_counter-test.c          |  2 +-
 tests/nft-expr_ct-test.c               |  2 +-
 tests/nft-expr_dup-test.c              |  2 +-
 tests/nft-expr_exthdr-test.c           |  2 +-
 tests/nft-expr_fwd-test.c              |  2 +-
 tests/nft-expr_hash-test.c             |  2 +-
 tests/nft-expr_immediate-test.c        |  2 +-
 tests/nft-expr_limit-test.c            |  2 +-
 tests/nft-expr_log-test.c              |  2 +-
 tests/nft-expr_lookup-test.c           |  2 +-
 tests/nft-expr_masq-test.c             |  2 +-
 tests/nft-expr_match-test.c            |  2 +-
 tests/nft-expr_meta-test.c             |  2 +-
 tests/nft-expr_nat-test.c              |  2 +-
 tests/nft-expr_numgen-test.c           |  2 +-
 tests/nft-expr_payload-test.c          |  2 +-
 tests/nft-expr_queue-test.c            |  2 +-
 tests/nft-expr_quota-test.c            |  2 +-
 tests/nft-expr_range-test.c            |  2 +-
 tests/nft-expr_redir-test.c            |  2 +-
 tests/nft-expr_reject-test.c           |  2 +-
 tests/nft-expr_target-test.c           |  2 +-
 tests/nft-rule-test.c                  |  2 +-
 tests/nft-set-test.c                   |  2 +-
 tests/nft-table-test.c                 |  3 +--
 53 files changed, 112 insertions(+), 123 deletions(-)

diff --git a/examples/nft-chain-add.c b/examples/nft-chain-add.c
index f711e098b52b..13be98232418 100644
--- a/examples/nft-chain-add.c
+++ b/examples/nft-chain-add.c
@@ -101,9 +101,9 @@ int main(int argc, char *argv[])
 	mnl_nlmsg_batch_next(batch);
 
 	chain_seq = seq;
-	nlh = nftnl_chain_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
-					NFT_MSG_NEWCHAIN, family,
-					NLM_F_CREATE|NLM_F_ACK, seq++);
+	nlh = nftnl_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
+				    NFT_MSG_NEWCHAIN, family,
+				    NLM_F_CREATE | NLM_F_ACK, seq++);
 	nftnl_chain_nlmsg_build_payload(nlh, t);
 	nftnl_chain_free(t);
 	mnl_nlmsg_batch_next(batch);
diff --git a/examples/nft-chain-del.c b/examples/nft-chain-del.c
index bcc714e61079..3cd483ea6c02 100644
--- a/examples/nft-chain-del.c
+++ b/examples/nft-chain-del.c
@@ -78,9 +78,8 @@ int main(int argc, char *argv[])
 	mnl_nlmsg_batch_next(batch);
 
 	chain_seq = seq;
-	nlh = nftnl_chain_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
-					NFT_MSG_DELCHAIN, family,
-					NLM_F_ACK, seq++);
+	nlh = nftnl_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
+				    NFT_MSG_DELCHAIN, family, NLM_F_ACK, seq++);
 	nftnl_chain_nlmsg_build_payload(nlh, t);
 	nftnl_chain_free(t);
 	mnl_nlmsg_batch_next(batch);
diff --git a/examples/nft-chain-get.c b/examples/nft-chain-get.c
index 8a6ef91298c7..612f58be7553 100644
--- a/examples/nft-chain-get.c
+++ b/examples/nft-chain-get.c
@@ -86,15 +86,15 @@ int main(int argc, char *argv[])
 			perror("OOM");
 			exit(EXIT_FAILURE);
 		}
-		nlh = nftnl_chain_nlmsg_build_hdr(buf, NFT_MSG_GETCHAIN, family,
-						NLM_F_ACK, seq);
+		nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_GETCHAIN, family,
+					    NLM_F_ACK, seq);
 		nftnl_chain_set_str(t, NFTNL_CHAIN_TABLE, argv[2]);
 		nftnl_chain_set_str(t, NFTNL_CHAIN_NAME, argv[3]);
 		nftnl_chain_nlmsg_build_payload(nlh, t);
 		nftnl_chain_free(t);
 	} else if (argc >= 2) {
-		nlh = nftnl_chain_nlmsg_build_hdr(buf, NFT_MSG_GETCHAIN, family,
-						NLM_F_DUMP, seq);
+		nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_GETCHAIN, family,
+					    NLM_F_DUMP, seq);
 	}
 
 	nl = mnl_socket_open(NETLINK_NETFILTER);
diff --git a/examples/nft-flowtable-add.c b/examples/nft-flowtable-add.c
index 4e0e50b95cbf..f509f23cf743 100644
--- a/examples/nft-flowtable-add.c
+++ b/examples/nft-flowtable-add.c
@@ -80,9 +80,9 @@ int main(int argc, char *argv[])
 	mnl_nlmsg_batch_next(batch);
 
 	flowtable_seq = seq;
-	nlh = nftnl_flowtable_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
-					NFT_MSG_NEWFLOWTABLE, family,
-					NLM_F_CREATE|NLM_F_ACK, seq++);
+	nlh = nftnl_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
+				    NFT_MSG_NEWFLOWTABLE, family,
+				    NLM_F_CREATE | NLM_F_ACK, seq++);
 	nftnl_flowtable_nlmsg_build_payload(nlh, t);
 	nftnl_flowtable_free(t);
 	mnl_nlmsg_batch_next(batch);
diff --git a/examples/nft-flowtable-del.c b/examples/nft-flowtable-del.c
index ffc83b25f716..c5ce339d69f5 100644
--- a/examples/nft-flowtable-del.c
+++ b/examples/nft-flowtable-del.c
@@ -67,9 +67,9 @@ int main(int argc, char *argv[])
 	mnl_nlmsg_batch_next(batch);
 
 	flowtable_seq = seq;
-	nlh = nftnl_flowtable_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
-					NFT_MSG_DELFLOWTABLE, family,
-					NLM_F_ACK, seq++);
+	nlh = nftnl_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
+				    NFT_MSG_DELFLOWTABLE, family,
+				    NLM_F_ACK, seq++);
 	nftnl_flowtable_nlmsg_build_payload(nlh, t);
 	nftnl_flowtable_free(t);
 	mnl_nlmsg_batch_next(batch);
diff --git a/examples/nft-flowtable-get.c b/examples/nft-flowtable-get.c
index 38929f317d67..1d10cc87c4ee 100644
--- a/examples/nft-flowtable-get.c
+++ b/examples/nft-flowtable-get.c
@@ -75,15 +75,15 @@ int main(int argc, char *argv[])
 			perror("OOM");
 			exit(EXIT_FAILURE);
 		}
-		nlh = nftnl_flowtable_nlmsg_build_hdr(buf, NFT_MSG_GETFLOWTABLE, family,
-						NLM_F_ACK, seq);
+		nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_GETFLOWTABLE, family,
+					    NLM_F_ACK, seq);
 		nftnl_flowtable_set_str(t, NFTNL_FLOWTABLE_TABLE, argv[2]);
 		nftnl_flowtable_set_str(t, NFTNL_FLOWTABLE_NAME, argv[3]);
 		nftnl_flowtable_nlmsg_build_payload(nlh, t);
 		nftnl_flowtable_free(t);
 	} else if (argc >= 2) {
-		nlh = nftnl_flowtable_nlmsg_build_hdr(buf, NFT_MSG_GETFLOWTABLE, family,
-						NLM_F_DUMP, seq);
+		nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_GETFLOWTABLE, family,
+					    NLM_F_DUMP, seq);
 	}
 
 	nl = mnl_socket_open(NETLINK_NETFILTER);
diff --git a/examples/nft-map-add.c b/examples/nft-map-add.c
index 7c6eeb93cb03..e5ce664af6b5 100644
--- a/examples/nft-map-add.c
+++ b/examples/nft-map-add.c
@@ -103,9 +103,9 @@ int main(int argc, char *argv[])
 	nftnl_batch_begin(mnl_nlmsg_batch_current(batch), seq++);
 	mnl_nlmsg_batch_next(batch);
 
-	nlh = nftnl_set_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
-				      NFT_MSG_NEWSET, family,
-				      NLM_F_CREATE|NLM_F_ACK, seq++);
+	nlh = nftnl_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
+				    NFT_MSG_NEWSET, family,
+				    NLM_F_CREATE | NLM_F_ACK, seq++);
 
 	nftnl_set_nlmsg_build_payload(nlh, s);
 	nftnl_set_free(s);
diff --git a/examples/nft-rule-add.c b/examples/nft-rule-add.c
index 77ee4805f4a4..7d13b92f6ef5 100644
--- a/examples/nft-rule-add.c
+++ b/examples/nft-rule-add.c
@@ -165,11 +165,11 @@ int main(int argc, char *argv[])
 	nftnl_batch_begin(mnl_nlmsg_batch_current(batch), seq++);
 	mnl_nlmsg_batch_next(batch);
 
-	nlh = nftnl_rule_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
-			NFT_MSG_NEWRULE,
-			nftnl_rule_get_u32(r, NFTNL_RULE_FAMILY),
-			NLM_F_APPEND|NLM_F_CREATE|NLM_F_ACK, seq++);
-
+	nlh = nftnl_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
+				    NFT_MSG_NEWRULE,
+				    nftnl_rule_get_u32(r, NFTNL_RULE_FAMILY),
+				    NLM_F_APPEND | NLM_F_CREATE | NLM_F_ACK,
+				    seq++);
 	nftnl_rule_nlmsg_build_payload(nlh, r);
 	nftnl_rule_free(r);
 	mnl_nlmsg_batch_next(batch);
diff --git a/examples/nft-rule-ct-expectation-add.c b/examples/nft-rule-ct-expectation-add.c
index 2012b3cfc757..07c8306d9154 100644
--- a/examples/nft-rule-ct-expectation-add.c
+++ b/examples/nft-rule-ct-expectation-add.c
@@ -123,12 +123,11 @@ int main(int argc, char *argv[])
 	nftnl_batch_begin(mnl_nlmsg_batch_current(batch), seq++);
 	mnl_nlmsg_batch_next(batch);
 
-	nlh = nftnl_rule_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
-					 NFT_MSG_NEWRULE,
-					 nftnl_rule_get_u32(r, NFTNL_RULE_FAMILY),
-					 NLM_F_APPEND|NLM_F_CREATE|NLM_F_ACK,
-					 seq++);
-
+	nlh = nftnl_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
+				    NFT_MSG_NEWRULE,
+				    nftnl_rule_get_u32(r, NFTNL_RULE_FAMILY),
+				    NLM_F_APPEND | NLM_F_CREATE | NLM_F_ACK,
+				    seq++);
 	nftnl_rule_nlmsg_build_payload(nlh, r);
 	nftnl_rule_free(r);
 	mnl_nlmsg_batch_next(batch);
diff --git a/examples/nft-rule-ct-helper-add.c b/examples/nft-rule-ct-helper-add.c
index e0338a8c0eff..594e6ba8e6dd 100644
--- a/examples/nft-rule-ct-helper-add.c
+++ b/examples/nft-rule-ct-helper-add.c
@@ -117,11 +117,11 @@ int main(int argc, char *argv[])
 	nftnl_batch_begin(mnl_nlmsg_batch_current(batch), seq++);
 	mnl_nlmsg_batch_next(batch);
 
-	nlh = nftnl_rule_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
-			NFT_MSG_NEWRULE,
-			nftnl_rule_get_u32(r, NFTNL_RULE_FAMILY),
-			NLM_F_APPEND|NLM_F_CREATE|NLM_F_ACK, seq++);
-
+	nlh = nftnl_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
+				    NFT_MSG_NEWRULE,
+				    nftnl_rule_get_u32(r, NFTNL_RULE_FAMILY),
+				    NLM_F_APPEND | NLM_F_CREATE | NLM_F_ACK,
+				    seq++);
 	nftnl_rule_nlmsg_build_payload(nlh, r);
 	nftnl_rule_free(r);
 	mnl_nlmsg_batch_next(batch);
diff --git a/examples/nft-rule-ct-timeout-add.c b/examples/nft-rule-ct-timeout-add.c
index d93cde11345c..0953cb4a396f 100644
--- a/examples/nft-rule-ct-timeout-add.c
+++ b/examples/nft-rule-ct-timeout-add.c
@@ -117,11 +117,11 @@ int main(int argc, char *argv[])
 	nftnl_batch_begin(mnl_nlmsg_batch_current(batch), seq++);
 	mnl_nlmsg_batch_next(batch);
 
-	nlh = nftnl_rule_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
-			NFT_MSG_NEWRULE,
-			nftnl_rule_get_u32(r, NFTNL_RULE_FAMILY),
-			NLM_F_APPEND|NLM_F_CREATE|NLM_F_ACK, seq++);
-
+	nlh = nftnl_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
+				    NFT_MSG_NEWRULE,
+				    nftnl_rule_get_u32(r, NFTNL_RULE_FAMILY),
+				    NLM_F_APPEND | NLM_F_CREATE | NLM_F_ACK,
+				    seq++);
 	nftnl_rule_nlmsg_build_payload(nlh, r);
 	nftnl_rule_free(r);
 	mnl_nlmsg_batch_next(batch);
diff --git a/examples/nft-rule-del.c b/examples/nft-rule-del.c
index 035aaa27476f..cb085ff10b3b 100644
--- a/examples/nft-rule-del.c
+++ b/examples/nft-rule-del.c
@@ -72,11 +72,8 @@ int main(int argc, char *argv[])
 	nftnl_batch_begin(mnl_nlmsg_batch_current(batch), seq++);
 	mnl_nlmsg_batch_next(batch);
 
-	nlh = nftnl_rule_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
-				NFT_MSG_DELRULE,
-				family,
-				NLM_F_ACK, seq++);
-
+	nlh = nftnl_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
+				    NFT_MSG_DELRULE, family, NLM_F_ACK, seq++);
 	nftnl_rule_nlmsg_build_payload(nlh, r);
 	nftnl_rule_free(r);
 	mnl_nlmsg_batch_next(batch);
diff --git a/examples/nft-rule-get.c b/examples/nft-rule-get.c
index 8fb654f36bdb..8da5b59ae372 100644
--- a/examples/nft-rule-get.c
+++ b/examples/nft-rule-get.c
@@ -111,8 +111,8 @@ int main(int argc, char *argv[])
 	}
 
 	seq = time(NULL);
-	nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_GETRULE, family,
-					 NLM_F_DUMP, seq);
+	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_GETRULE, family,
+				    NLM_F_DUMP, seq);
 
 	r = setup_rule(family, table, chain, NULL);
 	if (!r) {
diff --git a/examples/nft-ruleset-get.c b/examples/nft-ruleset-get.c
index cba9b098db0e..34ebe1fb6155 100644
--- a/examples/nft-ruleset-get.c
+++ b/examples/nft-ruleset-get.c
@@ -97,8 +97,8 @@ static struct nftnl_rule_list *mnl_rule_dump(struct mnl_socket *nf_sock,
 	if (nlr_list == NULL)
 		memory_allocation_error();
 
-	nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_GETRULE, family,
-				       NLM_F_DUMP, seq);
+	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_GETRULE, family,
+				    NLM_F_DUMP, seq);
 
 	ret = mnl_talk(nf_sock, nlh, nlh->nlmsg_len, rule_cb, nlr_list);
 	if (ret < 0)
@@ -145,8 +145,8 @@ static struct nftnl_chain_list *mnl_chain_dump(struct mnl_socket *nf_sock,
 	if (nlc_list == NULL)
 		memory_allocation_error();
 
-	nlh = nftnl_chain_nlmsg_build_hdr(buf, NFT_MSG_GETCHAIN, family,
-					NLM_F_DUMP, seq);
+	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_GETCHAIN, family,
+				    NLM_F_DUMP, seq);
 
 	ret = mnl_talk(nf_sock, nlh, nlh->nlmsg_len, chain_cb, nlc_list);
 	if (ret < 0)
@@ -193,8 +193,8 @@ static struct nftnl_table_list *mnl_table_dump(struct mnl_socket *nf_sock,
 	if (nlt_list == NULL)
 		memory_allocation_error();
 
-	nlh = nftnl_table_nlmsg_build_hdr(buf, NFT_MSG_GETTABLE, family,
-					NLM_F_DUMP, seq);
+	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_GETTABLE, family,
+				    NLM_F_DUMP, seq);
 
 	ret = mnl_talk(nf_sock, nlh, nlh->nlmsg_len, table_cb, nlt_list);
 	if (ret < 0)
@@ -221,8 +221,8 @@ static int mnl_setelem_get(struct mnl_socket *nf_sock, struct nftnl_set *nls)
 	struct nlmsghdr *nlh;
 	uint32_t family = nftnl_set_get_u32(nls, NFTNL_SET_FAMILY);
 
-	nlh = nftnl_set_nlmsg_build_hdr(buf, NFT_MSG_GETSETELEM, family,
-				      NLM_F_DUMP|NLM_F_ACK, seq);
+	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_GETSETELEM, family,
+				    NLM_F_DUMP | NLM_F_ACK, seq);
 	nftnl_set_nlmsg_build_payload(nlh, nls);
 
 	return mnl_talk(nf_sock, nlh, nlh->nlmsg_len, set_elem_cb, nls);
@@ -266,8 +266,8 @@ mnl_set_dump(struct mnl_socket *nf_sock, int family)
 	if (s == NULL)
 		memory_allocation_error();
 
-	nlh = nftnl_set_nlmsg_build_hdr(buf, NFT_MSG_GETSET, family,
-				      NLM_F_DUMP|NLM_F_ACK, seq);
+	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_GETSET, family,
+				    NLM_F_DUMP | NLM_F_ACK, seq);
 	nftnl_set_nlmsg_build_payload(nlh, s);
 	nftnl_set_free(s);
 
diff --git a/examples/nft-set-add.c b/examples/nft-set-add.c
index c9e249d09db5..109e33a75ac0 100644
--- a/examples/nft-set-add.c
+++ b/examples/nft-set-add.c
@@ -99,9 +99,9 @@ int main(int argc, char *argv[])
 	nftnl_batch_begin(mnl_nlmsg_batch_current(batch), seq++);
 	mnl_nlmsg_batch_next(batch);
 
-	nlh = nftnl_set_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
-				      NFT_MSG_NEWSET, family,
-				      NLM_F_CREATE|NLM_F_ACK, seq++);
+	nlh = nftnl_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
+				    NFT_MSG_NEWSET, family,
+				    NLM_F_CREATE | NLM_F_ACK, seq++);
 
 	nftnl_set_nlmsg_build_payload(nlh, s);
 	nftnl_set_free(s);
diff --git a/examples/nft-set-del.c b/examples/nft-set-del.c
index eafd5d750c57..5e8dea975a73 100644
--- a/examples/nft-set-del.c
+++ b/examples/nft-set-del.c
@@ -62,9 +62,8 @@ int main(int argc, char *argv[])
 	nftnl_batch_begin(mnl_nlmsg_batch_current(batch), seq++);
 	mnl_nlmsg_batch_next(batch);
 
-	nlh = nftnl_set_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
-					NFT_MSG_DELSET, family,
-					NLM_F_ACK, seq);
+	nlh = nftnl_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
+				    NFT_MSG_DELSET, family, NLM_F_ACK, seq);
 	nftnl_set_set_str(t, NFTNL_SET_TABLE, argv[2]);
 	nftnl_set_set_str(t, NFTNL_SET_NAME, argv[3]);
 
diff --git a/examples/nft-set-elem-del.c b/examples/nft-set-elem-del.c
index b569feaf3f69..1e6c90df8168 100644
--- a/examples/nft-set-elem-del.c
+++ b/examples/nft-set-elem-del.c
@@ -87,9 +87,8 @@ int main(int argc, char *argv[])
 	nftnl_batch_begin(mnl_nlmsg_batch_current(batch), seq++);
 	mnl_nlmsg_batch_next(batch);
 
-	nlh = nftnl_set_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
-					NFT_MSG_DELSETELEM, family,
-					NLM_F_ACK, seq);
+	nlh = nftnl_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
+				    NFT_MSG_DELSETELEM, family, NLM_F_ACK, seq);
 	nftnl_set_elems_nlmsg_build_payload(nlh, s);
 	nftnl_set_free(s);
 	mnl_nlmsg_batch_next(batch);
diff --git a/examples/nft-set-elem-get.c b/examples/nft-set-elem-get.c
index 52cdd516713f..7f99a602b031 100644
--- a/examples/nft-set-elem-get.c
+++ b/examples/nft-set-elem-get.c
@@ -81,8 +81,8 @@ int main(int argc, char *argv[])
 		exit(EXIT_FAILURE);
 	}
 
-	nlh = nftnl_set_nlmsg_build_hdr(buf, NFT_MSG_GETSETELEM, family,
-					NLM_F_DUMP|NLM_F_ACK, seq);
+	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_GETSETELEM, family,
+				    NLM_F_DUMP | NLM_F_ACK, seq);
 	nftnl_set_set_str(t, NFTNL_SET_NAME, argv[3]);
 	nftnl_set_set_str(t, NFTNL_SET_TABLE, argv[2]);
 	nftnl_set_elems_nlmsg_build_payload(nlh, t);
diff --git a/examples/nft-set-get.c b/examples/nft-set-get.c
index cbe3f85700b2..48a0699cad2b 100644
--- a/examples/nft-set-get.c
+++ b/examples/nft-set-get.c
@@ -83,8 +83,8 @@ int main(int argc, char *argv[])
 		exit(EXIT_FAILURE);
 	}
 
-	nlh = nftnl_set_nlmsg_build_hdr(buf, NFT_MSG_GETSET, family,
-					NLM_F_DUMP|NLM_F_ACK, seq);
+	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_GETSET, family,
+				    NLM_F_DUMP | NLM_F_ACK, seq);
 	/* Use this below if you want to obtain sets per table */
 /*	nftnl_set_set(t, NFT_SET_TABLE, argv[2]); */
 	nftnl_set_nlmsg_build_payload(nlh, t);
diff --git a/examples/nft-table-add.c b/examples/nft-table-add.c
index 5b5c1dd0db0f..3d54e0e5d509 100644
--- a/examples/nft-table-add.c
+++ b/examples/nft-table-add.c
@@ -79,9 +79,9 @@ int main(int argc, char *argv[])
 
 	table_seq = seq;
 	family = nftnl_table_get_u32(t, NFTNL_TABLE_FAMILY);
-	nlh = nftnl_table_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
-					NFT_MSG_NEWTABLE, family,
-					NLM_F_CREATE|NLM_F_ACK, seq++);
+	nlh = nftnl_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
+				    NFT_MSG_NEWTABLE, family,
+				    NLM_F_CREATE | NLM_F_ACK, seq++);
 	nftnl_table_nlmsg_build_payload(nlh, t);
 	nftnl_table_free(t);
 	mnl_nlmsg_batch_next(batch);
diff --git a/examples/nft-table-del.c b/examples/nft-table-del.c
index 3d78fd407d83..44f0b1f0e090 100644
--- a/examples/nft-table-del.c
+++ b/examples/nft-table-del.c
@@ -79,9 +79,9 @@ int main(int argc, char *argv[])
 
 	table_seq = seq;
 	family = nftnl_table_get_u32(t, NFTNL_TABLE_FAMILY);
-	nlh = nftnl_table_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
-					NFT_MSG_DELTABLE, family,
-					NLM_F_ACK, seq++);
+	nlh = nftnl_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
+				    NFT_MSG_DELTABLE, family,
+				    NLM_F_ACK, seq++);
 	nftnl_table_nlmsg_build_payload(nlh, t);
 	mnl_nlmsg_batch_next(batch);
 	nftnl_table_free(t);
diff --git a/examples/nft-table-get.c b/examples/nft-table-get.c
index 64fd66cac598..58eca9c1f32e 100644
--- a/examples/nft-table-get.c
+++ b/examples/nft-table-get.c
@@ -88,11 +88,11 @@ int main(int argc, char *argv[])
 
 	seq = time(NULL);
 	if (t == NULL) {
-		nlh = nftnl_table_nlmsg_build_hdr(buf, NFT_MSG_GETTABLE, family,
-						NLM_F_DUMP, seq);
+		nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_GETTABLE, family,
+					    NLM_F_DUMP, seq);
 	} else {
-		nlh = nftnl_table_nlmsg_build_hdr(buf, NFT_MSG_GETTABLE, family,
-						NLM_F_ACK, seq);
+		nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_GETTABLE, family,
+					    NLM_F_ACK, seq);
 		nftnl_table_set_str(t, NFTNL_TABLE_NAME, argv[2]);
 		nftnl_table_nlmsg_build_payload(nlh, t);
 		nftnl_table_free(t);
diff --git a/examples/nft-table-upd.c b/examples/nft-table-upd.c
index 663d09f07429..7346636d5d47 100644
--- a/examples/nft-table-upd.c
+++ b/examples/nft-table-upd.c
@@ -78,9 +78,8 @@ int main(int argc, char *argv[])
 	nftnl_table_set_u32(t, NFTNL_TABLE_FLAGS, flags);
 
 	table_seq = seq;
-	nlh = nftnl_table_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
-					NFT_MSG_NEWTABLE, family,
-					NLM_F_ACK, seq++);
+	nlh = nftnl_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
+				    NFT_MSG_NEWTABLE, family, NLM_F_ACK, seq++);
 	nftnl_table_nlmsg_build_payload(nlh, t);
 	nftnl_table_free(t);
 	mnl_nlmsg_batch_next(batch);
diff --git a/src/common.c b/src/common.c
index 08572c3fc917..ec84fa0db541 100644
--- a/src/common.c
+++ b/src/common.c
@@ -127,9 +127,8 @@ int nftnl_batch_is_supported(void)
 	mnl_nlmsg_batch_next(b);
 
 	req_seq = seq;
-	nftnl_set_nlmsg_build_hdr(mnl_nlmsg_batch_current(b),
-				NFT_MSG_NEWSET, AF_INET,
-				NLM_F_ACK, seq++);
+	nftnl_nlmsg_build_hdr(mnl_nlmsg_batch_current(b), NFT_MSG_NEWSET,
+			      AF_INET, NLM_F_ACK, seq++);
 	mnl_nlmsg_batch_next(b);
 
 	nftnl_batch_end(mnl_nlmsg_batch_current(b), seq++);
diff --git a/tests/nft-chain-test.c b/tests/nft-chain-test.c
index d678d46e556a..35a65be8d158 100644
--- a/tests/nft-chain-test.c
+++ b/tests/nft-chain-test.c
@@ -89,8 +89,7 @@ int main(int argc, char *argv[])
 	nftnl_chain_set_str(a, NFTNL_CHAIN_DEV, "eth0");
 
 	/* cmd extracted from include/linux/netfilter/nf_tables.h */
-	nlh = nftnl_chain_nlmsg_build_hdr(buf, NFT_MSG_NEWCHAIN, AF_INET,
-					0, 1234);
+	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_NEWCHAIN, AF_INET, 0, 1234);
 	nftnl_chain_nlmsg_build_payload(nlh, a);
 
 	if (nftnl_chain_nlmsg_parse(nlh, b) < 0)
diff --git a/tests/nft-expr_bitwise-test.c b/tests/nft-expr_bitwise-test.c
index f134728fdd86..44c4bf06f041 100644
--- a/tests/nft-expr_bitwise-test.c
+++ b/tests/nft-expr_bitwise-test.c
@@ -129,7 +129,7 @@ static void test_bool(void)
 
 	nftnl_rule_add_expr(a, ex);
 
-	nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
+	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
 	nftnl_rule_nlmsg_build_payload(nlh, a);
 
 	if (nftnl_rule_nlmsg_parse(nlh, b) < 0)
@@ -183,7 +183,7 @@ static void test_lshift(void)
 
 	nftnl_rule_add_expr(a, ex);
 
-	nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
+	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
 	nftnl_rule_nlmsg_build_payload(nlh, a);
 
 	if (nftnl_rule_nlmsg_parse(nlh, b) < 0)
@@ -237,7 +237,7 @@ static void test_rshift(void)
 
 	nftnl_rule_add_expr(a, ex);
 
-	nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
+	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
 	nftnl_rule_nlmsg_build_payload(nlh, a);
 
 	if (nftnl_rule_nlmsg_parse(nlh, b) < 0)
diff --git a/tests/nft-expr_byteorder-test.c b/tests/nft-expr_byteorder-test.c
index 5994e5bd7d22..30e64c0eb610 100644
--- a/tests/nft-expr_byteorder-test.c
+++ b/tests/nft-expr_byteorder-test.c
@@ -72,7 +72,7 @@ int main(int argc, char *argv[])
 
 	nftnl_rule_add_expr(a, ex);
 
-	nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
+	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
 	nftnl_rule_nlmsg_build_payload(nlh, a);
 
 	if (nftnl_rule_nlmsg_parse(nlh, b) < 0)
diff --git a/tests/nft-expr_cmp-test.c b/tests/nft-expr_cmp-test.c
index ec00bb92182c..0bab67b851a8 100644
--- a/tests/nft-expr_cmp-test.c
+++ b/tests/nft-expr_cmp-test.c
@@ -68,7 +68,7 @@ int main(int argc, char *argv[])
 
 	nftnl_rule_add_expr(a, ex);
 
-	nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
+	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
 	nftnl_rule_nlmsg_build_payload(nlh, a);
 
 	if (nftnl_rule_nlmsg_parse(nlh, b) < 0)
diff --git a/tests/nft-expr_counter-test.c b/tests/nft-expr_counter-test.c
index 519bc1f84592..81c3fe10d74b 100644
--- a/tests/nft-expr_counter-test.c
+++ b/tests/nft-expr_counter-test.c
@@ -60,7 +60,7 @@ int main(int argc, char *argv[])
 	nftnl_expr_set_u64(ex, NFTNL_EXPR_CTR_PACKETS, 0xf0123456789abcde);
 	nftnl_rule_add_expr(a, ex);
 
-	nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
+	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
 	nftnl_rule_nlmsg_build_payload(nlh, a);
 
 	if (nftnl_rule_nlmsg_parse(nlh, b) < 0)
diff --git a/tests/nft-expr_ct-test.c b/tests/nft-expr_ct-test.c
index e98fbabf9ccc..548a426dd846 100644
--- a/tests/nft-expr_ct-test.c
+++ b/tests/nft-expr_ct-test.c
@@ -62,7 +62,7 @@ int main(int argc, char *argv[])
 
 	nftnl_rule_add_expr(a, ex);
 
-	nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
+	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
 	nftnl_rule_nlmsg_build_payload(nlh, a);
 
 	if (nftnl_rule_nlmsg_parse(nlh, b) < 0)
diff --git a/tests/nft-expr_dup-test.c b/tests/nft-expr_dup-test.c
index 3c37d4a58462..0c5df9a9b7d4 100644
--- a/tests/nft-expr_dup-test.c
+++ b/tests/nft-expr_dup-test.c
@@ -59,7 +59,7 @@ int main(int argc, char *argv[])
 
 	nftnl_rule_add_expr(a, ex);
 
-	nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
+	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
 	nftnl_rule_nlmsg_build_payload(nlh, a);
 
 	if (nftnl_rule_nlmsg_parse(nlh, b) < 0)
diff --git a/tests/nft-expr_exthdr-test.c b/tests/nft-expr_exthdr-test.c
index fef2dd09f023..b2c72b7357c6 100644
--- a/tests/nft-expr_exthdr-test.c
+++ b/tests/nft-expr_exthdr-test.c
@@ -68,7 +68,7 @@ int main(int argc, char *argv[])
 
 	nftnl_rule_add_expr(a, ex);
 
-	nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
+	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
 	nftnl_rule_nlmsg_build_payload(nlh, a);
 	if (nftnl_rule_nlmsg_parse(nlh, b) < 0)
 		print_err("parsing problems");
diff --git a/tests/nft-expr_fwd-test.c b/tests/nft-expr_fwd-test.c
index 4fdf53d7bab1..825dad3a456b 100644
--- a/tests/nft-expr_fwd-test.c
+++ b/tests/nft-expr_fwd-test.c
@@ -55,7 +55,7 @@ int main(int argc, char *argv[])
 
 	nftnl_rule_add_expr(a, ex);
 
-	nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
+	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
 	nftnl_rule_nlmsg_build_payload(nlh, a);
 
 	if (nftnl_rule_nlmsg_parse(nlh, b) < 0)
diff --git a/tests/nft-expr_hash-test.c b/tests/nft-expr_hash-test.c
index 7be6e9efd8c3..6644bb7f3ac0 100644
--- a/tests/nft-expr_hash-test.c
+++ b/tests/nft-expr_hash-test.c
@@ -76,7 +76,7 @@ int main(int argc, char *argv[])
 
 	nftnl_rule_add_expr(a, ex);
 
-	nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
+	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
 	nftnl_rule_nlmsg_build_payload(nlh, a);
 	if (nftnl_rule_nlmsg_parse(nlh, b) < 0)
 		print_err("parsing problems");
diff --git a/tests/nft-expr_immediate-test.c b/tests/nft-expr_immediate-test.c
index c25eedb08710..5027813626b1 100644
--- a/tests/nft-expr_immediate-test.c
+++ b/tests/nft-expr_immediate-test.c
@@ -93,7 +93,7 @@ int main(int argc, char *argv[])
 	nftnl_rule_add_expr(a, ex_val);
 	nftnl_rule_add_expr(a, ex_ver);
 
-	nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
+	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
 	nftnl_rule_nlmsg_build_payload(nlh, a);
 
 	if (nftnl_rule_nlmsg_parse(nlh, b) < 0)
diff --git a/tests/nft-expr_limit-test.c b/tests/nft-expr_limit-test.c
index 2838941c4d74..38aaf56551e9 100644
--- a/tests/nft-expr_limit-test.c
+++ b/tests/nft-expr_limit-test.c
@@ -73,7 +73,7 @@ int main(int argc, char *argv[])
 
 	nftnl_rule_add_expr(a, ex);
 
-	nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
+	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
 	nftnl_rule_nlmsg_build_payload(nlh, a);
 
 	if (nftnl_rule_nlmsg_parse(nlh, b) < 0)
diff --git a/tests/nft-expr_log-test.c b/tests/nft-expr_log-test.c
index b7aa3023abcd..275ffaefc377 100644
--- a/tests/nft-expr_log-test.c
+++ b/tests/nft-expr_log-test.c
@@ -68,7 +68,7 @@ int main(int argc, char *argv[])
 
 	nftnl_rule_add_expr(a, ex);
 
-	nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
+	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
 	nftnl_rule_nlmsg_build_payload(nlh, a);
 	if (nftnl_rule_nlmsg_parse(nlh, b) < 0)
 		print_err("parsing problems");
diff --git a/tests/nft-expr_lookup-test.c b/tests/nft-expr_lookup-test.c
index 9e6e0513eeaf..9b7052565d6e 100644
--- a/tests/nft-expr_lookup-test.c
+++ b/tests/nft-expr_lookup-test.c
@@ -76,7 +76,7 @@ int main(int argc, char *argv[])
 
 	nftnl_rule_add_expr(a, ex);
 
-	nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
+	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
 	nftnl_rule_nlmsg_build_payload(nlh, a);
 
 	if (nftnl_rule_nlmsg_parse(nlh, b) < 0)
diff --git a/tests/nft-expr_masq-test.c b/tests/nft-expr_masq-test.c
index 3f9903ddfdd1..09179149421e 100644
--- a/tests/nft-expr_masq-test.c
+++ b/tests/nft-expr_masq-test.c
@@ -62,7 +62,7 @@ int main(int argc, char *argv[])
 
 	nftnl_rule_add_expr(a, ex);
 
-	nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
+	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
 	nftnl_rule_nlmsg_build_payload(nlh, a);
 
 	if (nftnl_rule_nlmsg_parse(nlh, b) < 0)
diff --git a/tests/nft-expr_match-test.c b/tests/nft-expr_match-test.c
index 39a49d8e29d4..fdeacc488e28 100644
--- a/tests/nft-expr_match-test.c
+++ b/tests/nft-expr_match-test.c
@@ -74,7 +74,7 @@ int main(int argc, char *argv[])
 	nftnl_expr_set(ex, NFTNL_EXPR_MT_INFO, strdup(data), sizeof(data));
 	nftnl_rule_add_expr(a, ex);
 
-	nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
+	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
 	nftnl_rule_nlmsg_build_payload(nlh, a);
 
 	if (nftnl_rule_nlmsg_parse(nlh, b) < 0)
diff --git a/tests/nft-expr_meta-test.c b/tests/nft-expr_meta-test.c
index 8fb78737421e..2f03fb16f7b8 100644
--- a/tests/nft-expr_meta-test.c
+++ b/tests/nft-expr_meta-test.c
@@ -60,7 +60,7 @@ int main(int argc, char *argv[])
 
 	nftnl_rule_add_expr(a, ex);
 
-	nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
+	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
 	nftnl_rule_nlmsg_build_payload(nlh, a);
 	if (nftnl_rule_nlmsg_parse(nlh, b) < 0)
 		print_err("parsing problems");
diff --git a/tests/nft-expr_nat-test.c b/tests/nft-expr_nat-test.c
index fd3a488fd6da..3a365dd307c2 100644
--- a/tests/nft-expr_nat-test.c
+++ b/tests/nft-expr_nat-test.c
@@ -81,7 +81,7 @@ int main(int argc, char *argv[])
 
 	nftnl_rule_add_expr(a, ex);
 
-	nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
+	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
 	nftnl_rule_nlmsg_build_payload(nlh, a);
 
 	if (nftnl_rule_nlmsg_parse(nlh, b) < 0)
diff --git a/tests/nft-expr_numgen-test.c b/tests/nft-expr_numgen-test.c
index 0d0a3bbf164d..94df50f6e40c 100644
--- a/tests/nft-expr_numgen-test.c
+++ b/tests/nft-expr_numgen-test.c
@@ -68,7 +68,7 @@ int main(int argc, char *argv[])
 
 	nftnl_rule_add_expr(a, ex);
 
-	nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
+	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
 	nftnl_rule_nlmsg_build_payload(nlh, a);
 	if (nftnl_rule_nlmsg_parse(nlh, b) < 0)
 		print_err("parsing problems");
diff --git a/tests/nft-expr_payload-test.c b/tests/nft-expr_payload-test.c
index 371372cdfb89..aec17106ef0f 100644
--- a/tests/nft-expr_payload-test.c
+++ b/tests/nft-expr_payload-test.c
@@ -69,7 +69,7 @@ int main(int argc, char *argv[])
 
 	nftnl_rule_add_expr(a, ex);
 
-	nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
+	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
 	nftnl_rule_nlmsg_build_payload(nlh, a);
 	if (nftnl_rule_nlmsg_parse(nlh, b) < 0)
 		print_err("parsing problems");
diff --git a/tests/nft-expr_queue-test.c b/tests/nft-expr_queue-test.c
index 81d7dd22c7fb..d007b98a7139 100644
--- a/tests/nft-expr_queue-test.c
+++ b/tests/nft-expr_queue-test.c
@@ -67,7 +67,7 @@ int main(int argc, char *argv[])
 
 	nftnl_rule_add_expr(a, ex);
 
-	nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
+	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
 	nftnl_rule_nlmsg_build_payload(nlh, a);
 
 	if (nftnl_rule_nlmsg_parse(nlh, b) < 0)
diff --git a/tests/nft-expr_quota-test.c b/tests/nft-expr_quota-test.c
index 232055118025..a3eb2e3c45f3 100644
--- a/tests/nft-expr_quota-test.c
+++ b/tests/nft-expr_quota-test.c
@@ -59,7 +59,7 @@ int main(int argc, char *argv[])
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_QUOTA_FLAGS, 0x12345678);
 	nftnl_rule_add_expr(a, ex);
 
-	nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
+	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
 	nftnl_rule_nlmsg_build_payload(nlh, a);
 
 	if (nftnl_rule_nlmsg_parse(nlh, b) < 0)
diff --git a/tests/nft-expr_range-test.c b/tests/nft-expr_range-test.c
index b92dfc0b94e6..6ef896beb08a 100644
--- a/tests/nft-expr_range-test.c
+++ b/tests/nft-expr_range-test.c
@@ -75,7 +75,7 @@ int main(int argc, char *argv[])
 
 	nftnl_rule_add_expr(a, ex);
 
-	nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
+	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
 	nftnl_rule_nlmsg_build_payload(nlh, a);
 
 	if (nftnl_rule_nlmsg_parse(nlh, b) < 0)
diff --git a/tests/nft-expr_redir-test.c b/tests/nft-expr_redir-test.c
index 6c8caec969c1..8e1f30c43332 100644
--- a/tests/nft-expr_redir-test.c
+++ b/tests/nft-expr_redir-test.c
@@ -62,7 +62,7 @@ int main(int argc, char *argv[])
 
 	nftnl_rule_add_expr(a, ex);
 
-	nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
+	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
 	nftnl_rule_nlmsg_build_payload(nlh, a);
 
 	if (nftnl_rule_nlmsg_parse(nlh, b) < 0)
diff --git a/tests/nft-expr_reject-test.c b/tests/nft-expr_reject-test.c
index d8189ea8dedb..049401da1565 100644
--- a/tests/nft-expr_reject-test.c
+++ b/tests/nft-expr_reject-test.c
@@ -61,7 +61,7 @@ int main(int argc, char *argv[])
 
 	nftnl_rule_add_expr(a, ex);
 
-	nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
+	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
 	nftnl_rule_nlmsg_build_payload(nlh, a);
 
 	if (nftnl_rule_nlmsg_parse(nlh, b) < 0)
diff --git a/tests/nft-expr_target-test.c b/tests/nft-expr_target-test.c
index ba56b278524e..a5172064c13b 100644
--- a/tests/nft-expr_target-test.c
+++ b/tests/nft-expr_target-test.c
@@ -74,7 +74,7 @@ int main(int argc, char *argv[])
 	nftnl_expr_set(ex, NFTNL_EXPR_TG_INFO, strdup(data), sizeof(data));
 	nftnl_rule_add_expr(a, ex);
 
-	nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
+	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
 	nftnl_rule_nlmsg_build_payload(nlh, a);
 
 	if (nftnl_rule_nlmsg_parse(nlh, b) < 0)
diff --git a/tests/nft-rule-test.c b/tests/nft-rule-test.c
index dee35305e560..3652bf62c513 100644
--- a/tests/nft-rule-test.c
+++ b/tests/nft-rule-test.c
@@ -90,7 +90,7 @@ int main(int argc, char *argv[])
 			    nftnl_udata_buf_len(udata));
 	nftnl_udata_buf_free(udata);
 
-	nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
+	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, AF_INET, 0, 1234);
 	nftnl_rule_nlmsg_build_payload(nlh, a);
 
 	if (nftnl_rule_nlmsg_parse(nlh, b) < 0)
diff --git a/tests/nft-set-test.c b/tests/nft-set-test.c
index 173c17f829e0..66916fe0d523 100644
--- a/tests/nft-set-test.c
+++ b/tests/nft-set-test.c
@@ -74,7 +74,7 @@ int main(int argc, char *argv[])
 	nftnl_set_set_str(a, NFTNL_SET_USERDATA, "testing user data");
 
 	/* cmd extracted from include/linux/netfilter/nf_tables.h */
-	nlh = nftnl_set_nlmsg_build_hdr(buf, NFT_MSG_NEWSET, AF_INET, 0, 1234);
+	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_NEWSET, AF_INET, 0, 1234);
 	nftnl_set_nlmsg_build_payload(nlh, a);
 
 	if (nftnl_set_nlmsg_parse(nlh, b) < 0)
diff --git a/tests/nft-table-test.c b/tests/nft-table-test.c
index 1031ffef09cc..1b2f280d22cc 100644
--- a/tests/nft-table-test.c
+++ b/tests/nft-table-test.c
@@ -55,8 +55,7 @@ int main(int argc, char *argv[])
 	nftnl_table_set_u32(a, NFTNL_TABLE_FLAGS, 0);
 
 	/* cmd extracted from include/linux/netfilter/nf_tables.h */
-	nlh = nftnl_table_nlmsg_build_hdr(buf, NFT_MSG_NEWTABLE, AF_INET, 0,
-					1234);
+	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_NEWTABLE, AF_INET, 0, 1234);
 	nftnl_table_nlmsg_build_payload(nlh, a);
 
 	if (nftnl_table_nlmsg_parse(nlh, b) < 0)
-- 
2.30.2

