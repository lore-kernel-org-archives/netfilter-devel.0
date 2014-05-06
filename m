From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftnl PATCH 2/2] examples: use new nft_*_build_msg() functions
Date: Tue, 06 May 2014 22:19:41 +0200
Message-ID: <20140506201941.18158.46054.stgit@nfdev.cica.es>
References: <20140506201936.18158.83354.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:60542 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755203AbaEFUTy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 6 May 2014 16:19:54 -0400
In-Reply-To: <20140506201936.18158.83354.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Let's use these new functions in the examples.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 examples/nft-rule-add.c |    9 ++-------
 examples/nft-rule-del.c |   13 +++++--------
 2 files changed, 7 insertions(+), 15 deletions(-)

diff --git a/examples/nft-rule-add.c b/examples/nft-rule-add.c
index 6961d0d..32302c5 100644
--- a/examples/nft-rule-add.c
+++ b/examples/nft-rule-add.c
@@ -137,7 +137,6 @@ int main(int argc, char *argv[])
 {
 	struct mnl_socket *nl;
 	struct nft_rule *r;
-	struct nlmsghdr *nlh;
 	struct mnl_nlmsg_batch *batch;
 	uint8_t family;
 	char buf[MNL_SOCKET_BUFFER_SIZE];
@@ -180,12 +179,8 @@ int main(int argc, char *argv[])
 			  NFNL_MSG_BATCH_BEGIN, seq++);
 	mnl_nlmsg_batch_next(batch);
 
-	nlh = nft_rule_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
-			NFT_MSG_NEWRULE,
-			nft_rule_attr_get_u32(r, NFT_RULE_ATTR_FAMILY),
-			NLM_F_APPEND|NLM_F_CREATE|NLM_F_ACK, seq++);
-
-	nft_rule_nlmsg_build_payload(nlh, r);
+	nft_rule_build_msg(r, mnl_nlmsg_batch_current(batch), NFT_MSG_NEWRULE,
+			   NLM_F_APPEND|NLM_F_CREATE|NLM_F_ACK, seq++);
 	nft_rule_free(r);
 	mnl_nlmsg_batch_next(batch);
 
diff --git a/examples/nft-rule-del.c b/examples/nft-rule-del.c
index cec9440..50e8eb8 100644
--- a/examples/nft-rule-del.c
+++ b/examples/nft-rule-del.c
@@ -42,11 +42,10 @@ int main(int argc, char *argv[])
 {
 	struct mnl_socket *nl;
 	char buf[MNL_SOCKET_BUFFER_SIZE];
-	struct nlmsghdr *nlh;
 	struct mnl_nlmsg_batch *batch;
-	uint32_t portid, seq;
+	uint32_t portid, seq, family;
 	struct nft_rule *r = NULL;
-	int ret, family;
+	int ret;
 
 	if (argc < 4 || argc > 5) {
 		fprintf(stderr, "Usage: %s <family> <table> <chain> [<handle>]\n",
@@ -76,6 +75,7 @@ int main(int argc, char *argv[])
 	seq = time(NULL);
 	nft_rule_attr_set(r, NFT_RULE_ATTR_TABLE, argv[2]);
 	nft_rule_attr_set(r, NFT_RULE_ATTR_CHAIN, argv[3]);
+	nft_rule_attr_set_u32(r, NFT_RULE_ATTR_FAMILY, family);
 
 	/* If no handle is specified, delete all rules in the chain */
 	if (argc == 5)
@@ -87,12 +87,9 @@ int main(int argc, char *argv[])
 			  NFNL_MSG_BATCH_BEGIN, seq++);
 	mnl_nlmsg_batch_next(batch);
 
-	nlh = nft_rule_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
-				NFT_MSG_DELRULE,
-				family,
-				NLM_F_ACK, seq++);
+	nft_rule_build_msg(r, mnl_nlmsg_batch_current(batch), NFT_MSG_DELRULE,
+			   NLM_F_ACK, seq++);
 
-	nft_rule_nlmsg_build_payload(nlh, r);
 	nft_rule_free(r);
 	mnl_nlmsg_batch_next(batch);
 

