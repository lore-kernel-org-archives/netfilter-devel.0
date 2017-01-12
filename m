From: Elise Lennion <elise.lennion@gmail.com>
Subject: [PATCH] examples: Remove the use of nftnl_mnl_batch_put()
Date: Thu, 12 Jan 2017 17:22:55 -0200
Message-ID: <20170112192255.GA20246@lennorien.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vk0-f67.google.com ([209.85.213.67]:34207 "EHLO
        mail-vk0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750755AbdALTXC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 12 Jan 2017 14:23:02 -0500
Received: by mail-vk0-f67.google.com with SMTP id r136so2153133vke.1
        for <netfilter-devel@vger.kernel.org>; Thu, 12 Jan 2017 11:23:02 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

use nftnl_batch_begin() and nftnl_batch_end() instead, to keep examples
consistent and avoid code duplication.

Signed-off-by: Elise Lennion <elise.lennion@gmail.com>
---
 examples/nft-map-add.c  | 38 +++++++++++++++-----------------------
 examples/nft-rule-add.c | 38 +++++++++++++++-----------------------
 examples/nft-rule-del.c | 38 +++++++++++++++-----------------------
 examples/nft-set-add.c  | 38 +++++++++++++++-----------------------
 4 files changed, 60 insertions(+), 92 deletions(-)

diff --git a/examples/nft-map-add.c b/examples/nft-map-add.c
index 53244f5..a906d2d 100644
--- a/examples/nft-map-add.c
+++ b/examples/nft-map-add.c
@@ -54,22 +54,6 @@ static struct nftnl_set *setup_set(uint8_t family, const char *table,
 	return s;
 }
 
-static void nftnl_mnl_batch_put(char *buf, uint16_t type, uint32_t seq)
-{
-	struct nlmsghdr *nlh;
-	struct nfgenmsg *nfg;
-
-	nlh = mnl_nlmsg_put_header(buf);
-	nlh->nlmsg_type = type;
-	nlh->nlmsg_flags = NLM_F_REQUEST;
-	nlh->nlmsg_seq = seq;
-
-	nfg = mnl_nlmsg_put_extra_header(nlh, sizeof(*nfg));
-	nfg->nfgen_family = AF_INET;
-	nfg->version = NFNETLINK_V0;
-	nfg->res_id = NFNL_SUBSYS_NFTABLES;
-}
-
 int main(int argc, char *argv[])
 {
 	struct mnl_socket *nl;
@@ -79,7 +63,7 @@ int main(int argc, char *argv[])
 	uint8_t family;
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	uint32_t seq = time(NULL);
-	int ret;
+	int ret, batching;
 
 	if (argc != 4) {
 		fprintf(stderr, "Usage: %s <family> <table> <setname>\n", argv[0]);
@@ -112,11 +96,18 @@ int main(int argc, char *argv[])
 		exit(EXIT_FAILURE);
 	}
 
+	batching = nftnl_batch_is_supported();
+	if (batching < 0) {
+		perror("cannot talk to nfnetlink");
+		exit(EXIT_FAILURE);
+	}
+
 	batch = mnl_nlmsg_batch_start(buf, sizeof(buf));
 
-	nftnl_mnl_batch_put(mnl_nlmsg_batch_current(batch),
-			  NFNL_MSG_BATCH_BEGIN, seq++);
-	mnl_nlmsg_batch_next(batch);
+	if (batching) {
+		nftnl_batch_begin(mnl_nlmsg_batch_current(batch), seq++);
+		mnl_nlmsg_batch_next(batch);
+	}
 
 	nlh = nftnl_set_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
 				      NFT_MSG_NEWSET, family,
@@ -126,9 +117,10 @@ int main(int argc, char *argv[])
 	nftnl_set_free(s);
 	mnl_nlmsg_batch_next(batch);
 
-	nftnl_mnl_batch_put(mnl_nlmsg_batch_current(batch), NFNL_MSG_BATCH_END,
-			 seq++);
-	mnl_nlmsg_batch_next(batch);
+	if (batching) {
+		nftnl_batch_end(mnl_nlmsg_batch_current(batch), seq++);
+		mnl_nlmsg_batch_next(batch);
+	}
 
 	ret = mnl_socket_sendto(nl, mnl_nlmsg_batch_head(batch),
 				mnl_nlmsg_batch_size(batch));
diff --git a/examples/nft-rule-add.c b/examples/nft-rule-add.c
index d27c6d7..3aeb2e0 100644
--- a/examples/nft-rule-add.c
+++ b/examples/nft-rule-add.c
@@ -117,22 +117,6 @@ static struct nftnl_rule *setup_rule(uint8_t family, const char *table,
 	return r;
 }
 
-static void nftnl_mnl_batch_put(char *buf, uint16_t type, uint32_t seq)
-{
-	struct nlmsghdr *nlh;
-	struct nfgenmsg *nfg;
-
-	nlh = mnl_nlmsg_put_header(buf);
-	nlh->nlmsg_type = type;
-	nlh->nlmsg_flags = NLM_F_REQUEST;
-	nlh->nlmsg_seq = seq;
-
-	nfg = mnl_nlmsg_put_extra_header(nlh, sizeof(*nfg));
-	nfg->nfgen_family = AF_INET;
-	nfg->version = NFNETLINK_V0;
-	nfg->res_id = NFNL_SUBSYS_NFTABLES;
-}
-
 int main(int argc, char *argv[])
 {
 	struct mnl_socket *nl;
@@ -142,7 +126,7 @@ int main(int argc, char *argv[])
 	uint8_t family;
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	uint32_t seq = time(NULL);
-	int ret;
+	int ret, batching;
 
 	if (argc < 4 || argc > 5) {
 		fprintf(stderr, "Usage: %s <family> <table> <chain>\n", argv[0]);
@@ -174,11 +158,18 @@ int main(int argc, char *argv[])
 		exit(EXIT_FAILURE);
 	}
 
+	batching = nftnl_batch_is_supported();
+	if (batching < 0) {
+		perror("cannot talk to nfnetlink");
+		exit(EXIT_FAILURE);
+	}
+
 	batch = mnl_nlmsg_batch_start(buf, sizeof(buf));
 
-	nftnl_mnl_batch_put(mnl_nlmsg_batch_current(batch),
-			  NFNL_MSG_BATCH_BEGIN, seq++);
-	mnl_nlmsg_batch_next(batch);
+	if (batching) {
+		nftnl_batch_begin(mnl_nlmsg_batch_current(batch), seq++);
+		mnl_nlmsg_batch_next(batch);
+	}
 
 	nlh = nftnl_rule_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
 			NFT_MSG_NEWRULE,
@@ -189,9 +180,10 @@ int main(int argc, char *argv[])
 	nftnl_rule_free(r);
 	mnl_nlmsg_batch_next(batch);
 
-	nftnl_mnl_batch_put(mnl_nlmsg_batch_current(batch), NFNL_MSG_BATCH_END,
-			 seq++);
-	mnl_nlmsg_batch_next(batch);
+	if (batching) {
+		nftnl_batch_end(mnl_nlmsg_batch_current(batch), seq++);
+		mnl_nlmsg_batch_next(batch);
+	}
 
 	ret = mnl_socket_sendto(nl, mnl_nlmsg_batch_head(batch),
 				mnl_nlmsg_batch_size(batch));
diff --git a/examples/nft-rule-del.c b/examples/nft-rule-del.c
index 4bc9727..5c68363 100644
--- a/examples/nft-rule-del.c
+++ b/examples/nft-rule-del.c
@@ -22,22 +22,6 @@
 #include <libmnl/libmnl.h>
 #include <libnftnl/rule.h>
 
-static void nftnl_mnl_batch_put(char *buf, uint16_t type, uint32_t seq)
-{
-	struct nlmsghdr *nlh;
-	struct nfgenmsg *nfg;
-
-	nlh = mnl_nlmsg_put_header(buf);
-	nlh->nlmsg_type = type;
-	nlh->nlmsg_flags = NLM_F_REQUEST;
-	nlh->nlmsg_seq = seq;
-
-	nfg = mnl_nlmsg_put_extra_header(nlh, sizeof(*nfg));
-	nfg->nfgen_family = AF_INET;
-	nfg->version = NFNETLINK_V0;
-	nfg->res_id = NFNL_SUBSYS_NFTABLES;
-}
-
 int main(int argc, char *argv[])
 {
 	struct mnl_socket *nl;
@@ -46,7 +30,7 @@ int main(int argc, char *argv[])
 	struct mnl_nlmsg_batch *batch;
 	uint32_t portid, seq;
 	struct nftnl_rule *r = NULL;
-	int ret, family;
+	int ret, batching, family;
 
 	if (argc < 4 || argc > 5) {
 		fprintf(stderr, "Usage: %s <family> <table> <chain> [<handle>]\n",
@@ -81,11 +65,18 @@ int main(int argc, char *argv[])
 	if (argc == 5)
 		nftnl_rule_set_u64(r, NFTNL_RULE_HANDLE, atoi(argv[4]));
 
+	batching = nftnl_batch_is_supported();
+	if (batching < 0) {
+		perror("cannot talk to nfnetlink");
+		exit(EXIT_FAILURE);
+	}
+
 	batch = mnl_nlmsg_batch_start(buf, sizeof(buf));
 
-	nftnl_mnl_batch_put(mnl_nlmsg_batch_current(batch),
-			  NFNL_MSG_BATCH_BEGIN, seq++);
-	mnl_nlmsg_batch_next(batch);
+	if (batching) {
+		nftnl_batch_begin(mnl_nlmsg_batch_current(batch), seq++);
+		mnl_nlmsg_batch_next(batch);
+	}
 
 	nlh = nftnl_rule_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
 				NFT_MSG_DELRULE,
@@ -96,9 +87,10 @@ int main(int argc, char *argv[])
 	nftnl_rule_free(r);
 	mnl_nlmsg_batch_next(batch);
 
-	nftnl_mnl_batch_put(mnl_nlmsg_batch_current(batch), NFNL_MSG_BATCH_END,
-			  seq++);
-	mnl_nlmsg_batch_next(batch);
+	if (batching) {
+		nftnl_batch_end(mnl_nlmsg_batch_current(batch), seq++);
+		mnl_nlmsg_batch_next(batch);
+	}
 
 	nl = mnl_socket_open(NETLINK_NETFILTER);
 	if (nl == NULL) {
diff --git a/examples/nft-set-add.c b/examples/nft-set-add.c
index bae6e8e..bdb9373 100644
--- a/examples/nft-set-add.c
+++ b/examples/nft-set-add.c
@@ -50,22 +50,6 @@ static struct nftnl_set *setup_set(uint8_t family, const char *table,
 	return s;
 }
 
-static void nftnl_mnl_batch_put(char *buf, uint16_t type, uint32_t seq)
-{
-	struct nlmsghdr *nlh;
-	struct nfgenmsg *nfg;
-
-	nlh = mnl_nlmsg_put_header(buf);
-	nlh->nlmsg_type = type;
-	nlh->nlmsg_flags = NLM_F_REQUEST;
-	nlh->nlmsg_seq = seq;
-
-	nfg = mnl_nlmsg_put_extra_header(nlh, sizeof(*nfg));
-	nfg->nfgen_family = AF_INET;
-	nfg->version = NFNETLINK_V0;
-	nfg->res_id = NFNL_SUBSYS_NFTABLES;
-}
-
 int main(int argc, char *argv[])
 {
 	struct mnl_socket *nl;
@@ -75,7 +59,7 @@ int main(int argc, char *argv[])
 	uint8_t family;
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	uint32_t seq = time(NULL);
-	int ret;
+	int ret, batching;
 
 	if (argc != 4) {
 		fprintf(stderr, "Usage: %s <family> <table> <setname>\n", argv[0]);
@@ -108,11 +92,18 @@ int main(int argc, char *argv[])
 		exit(EXIT_FAILURE);
 	}
 
+	batching = nftnl_batch_is_supported();
+	if (batching < 0) {
+		perror("cannot talk to nfnetlink");
+		exit(EXIT_FAILURE);
+	}
+
 	batch = mnl_nlmsg_batch_start(buf, sizeof(buf));
 
-	nftnl_mnl_batch_put(mnl_nlmsg_batch_current(batch),
-			  NFNL_MSG_BATCH_BEGIN, seq++);
-	mnl_nlmsg_batch_next(batch);
+	if (batching) {
+		nftnl_batch_begin(mnl_nlmsg_batch_current(batch), seq++);
+		mnl_nlmsg_batch_next(batch);
+	}
 
 	nlh = nftnl_set_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
 				      NFT_MSG_NEWSET, family,
@@ -122,9 +113,10 @@ int main(int argc, char *argv[])
 	nftnl_set_free(s);
 	mnl_nlmsg_batch_next(batch);
 
-	nftnl_mnl_batch_put(mnl_nlmsg_batch_current(batch), NFNL_MSG_BATCH_END,
-			 seq++);
-	mnl_nlmsg_batch_next(batch);
+	if (batching) {
+		nftnl_batch_end(mnl_nlmsg_batch_current(batch), seq++);
+		mnl_nlmsg_batch_next(batch);
+	}
 
 	ret = mnl_socket_sendto(nl, mnl_nlmsg_batch_head(batch),
 				mnl_nlmsg_batch_size(batch));
-- 
2.7.4

