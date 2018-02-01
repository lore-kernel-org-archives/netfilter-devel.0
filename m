From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libnftnl] examples: do not call nftnl_batch_is_supported()
Date: Thu,  1 Feb 2018 19:33:52 +0100
Message-ID: <20180201183354.21947-1-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39782 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751567AbeBASeC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Feb 2018 13:34:02 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D9075392E06
        for <netfilter-devel@vger.kernel.org>; Thu,  1 Feb 2018 19:34:00 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BFB44BAC2B
        for <netfilter-devel@vger.kernel.org>; Thu,  1 Feb 2018 19:34:00 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2AE1DBAC2F
        for <netfilter-devel@vger.kernel.org>; Thu,  1 Feb 2018 19:33:58 +0100 (CET)
Received: from salvia.here (129.166.216.87.static.jazztel.es [87.216.166.129])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id BA3074265A2F
        for <netfilter-devel@vger.kernel.org>; Thu,  1 Feb 2018 19:33:57 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is only required by Linux kernel <= 3.16.x, that's too old and at
that time nft was very limited in term of features, so let's remove this
check from example files.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 examples/nft-chain-add.c          | 19 ++++---------------
 examples/nft-chain-del.c          | 20 +++++---------------
 examples/nft-chain-parse-add.c    | 19 +++++--------------
 examples/nft-flowtable-add.c      | 19 ++++---------------
 examples/nft-flowtable-del.c      | 20 +++++---------------
 examples/nft-map-add.c            | 20 +++++---------------
 examples/nft-rule-add.c           | 20 +++++---------------
 examples/nft-rule-del.c           | 20 +++++---------------
 examples/nft-rule-parse-add.c     | 20 +++++---------------
 examples/nft-ruleset-parse-file.c | 20 +++++---------------
 examples/nft-set-add.c            | 20 +++++---------------
 examples/nft-set-parse-add.c      | 19 +++++--------------
 examples/nft-table-add.c          | 20 +++++---------------
 examples/nft-table-del.c          | 20 +++++---------------
 examples/nft-table-parse-add.c    | 19 +++++--------------
 examples/nft-table-upd.c          | 20 +++++---------------
 16 files changed, 78 insertions(+), 237 deletions(-)

diff --git a/examples/nft-chain-add.c b/examples/nft-chain-add.c
index e0d889df40eb..5796d10f8668 100644
--- a/examples/nft-chain-add.c
+++ b/examples/nft-chain-add.c
@@ -67,7 +67,6 @@ int main(int argc, char *argv[])
 	int ret, family;
 	struct nftnl_chain *t;
 	struct mnl_nlmsg_batch *batch;
-	int batching;
 
 	if (argc != 4 && argc != 6) {
 		fprintf(stderr, "Usage: %s <family> <table> <chain> "
@@ -93,19 +92,11 @@ int main(int argc, char *argv[])
 	if (t == NULL)
 		exit(EXIT_FAILURE);
 
-	batching = nftnl_batch_is_supported();
-	if (batching < 0) {
-		perror("cannot talk to nfnetlink");
-		exit(EXIT_FAILURE);
-	}
-
 	seq = time(NULL);
 	batch = mnl_nlmsg_batch_start(buf, sizeof(buf));
 
-	if (batching) {
-		nftnl_batch_begin(mnl_nlmsg_batch_current(batch), seq++);
-		mnl_nlmsg_batch_next(batch);
-	}
+	nftnl_batch_begin(mnl_nlmsg_batch_current(batch), seq++);
+	mnl_nlmsg_batch_next(batch);
 
 	chain_seq = seq;
 	nlh = nftnl_chain_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
@@ -115,10 +106,8 @@ int main(int argc, char *argv[])
 	nftnl_chain_free(t);
 	mnl_nlmsg_batch_next(batch);
 
-	if (batching) {
-		nftnl_batch_end(mnl_nlmsg_batch_current(batch), seq++);
-		mnl_nlmsg_batch_next(batch);
-	}
+	nftnl_batch_end(mnl_nlmsg_batch_current(batch), seq++);
+	mnl_nlmsg_batch_next(batch);
 
 	nl = mnl_socket_open(NETLINK_NETFILTER);
 	if (nl == NULL) {
diff --git a/examples/nft-chain-del.c b/examples/nft-chain-del.c
index e99bb8a2474f..09a47182fe49 100644
--- a/examples/nft-chain-del.c
+++ b/examples/nft-chain-del.c
@@ -44,7 +44,7 @@ int main(int argc, char *argv[])
 	struct nlmsghdr *nlh;
 	uint32_t portid, seq, chain_seq;
 	struct nftnl_chain *t;
-	int ret, family, batching;
+	int ret, family;
 
 	if (argc != 4) {
 		fprintf(stderr, "Usage: %s <family> <table> <chain>\n",
@@ -69,19 +69,11 @@ int main(int argc, char *argv[])
 	if (t == NULL)
 		exit(EXIT_FAILURE);
 
-	batching = nftnl_batch_is_supported();
-	if (batching < 0) {
-		perror("cannot talk to nfnetlink");
-		exit(EXIT_FAILURE);
-	}
-
 	seq = time(NULL);
 	batch = mnl_nlmsg_batch_start(buf, sizeof(buf));
 
-	if (batching) {
-		nftnl_batch_begin(mnl_nlmsg_batch_current(batch), seq++);
-		mnl_nlmsg_batch_next(batch);
-	}
+	nftnl_batch_begin(mnl_nlmsg_batch_current(batch), seq++);
+	mnl_nlmsg_batch_next(batch);
 
 	chain_seq = seq;
 	nlh = nftnl_chain_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
@@ -91,10 +83,8 @@ int main(int argc, char *argv[])
 	nftnl_chain_free(t);
 	mnl_nlmsg_batch_next(batch);
 
-	if (batching) {
-		nftnl_batch_end(mnl_nlmsg_batch_current(batch), seq++);
-		mnl_nlmsg_batch_next(batch);
-	}
+	nftnl_batch_end(mnl_nlmsg_batch_current(batch), seq++);
+	mnl_nlmsg_batch_next(batch);
 
 	nl = mnl_socket_open(NETLINK_NETFILTER);
 	if (nl == NULL) {
diff --git a/examples/nft-chain-parse-add.c b/examples/nft-chain-parse-add.c
index a9ee8e9259b2..9198615d9a5f 100644
--- a/examples/nft-chain-parse-add.c
+++ b/examples/nft-chain-parse-add.c
@@ -77,8 +77,8 @@ int main(int argc, char *argv[])
 	uint32_t portid, seq, chain_seq;
 	struct nftnl_chain *c;
 	uint16_t family, format, outformat;
-	int ret, batching;
 	struct mnl_nlmsg_batch *batch;
+	int ret;
 
 	if (argc < 3) {
 		printf("Usage: %s {json} <file>\n", argv[0]);
@@ -104,18 +104,11 @@ int main(int argc, char *argv[])
 	family = nftnl_chain_get_u32(c, NFTNL_CHAIN_FAMILY);
 
 	seq = time(NULL);
-	batching = nftnl_batch_is_supported();
-	if (batching < 0) {
-		perror("cannot talk to nfnetlink");
-		exit(EXIT_FAILURE);
-	}
 
 	batch = mnl_nlmsg_batch_start(buf, sizeof(buf));
 
-	if (batching) {
-		nftnl_batch_begin(mnl_nlmsg_batch_current(batch), seq++);
-		mnl_nlmsg_batch_next(batch);
-	}
+	nftnl_batch_begin(mnl_nlmsg_batch_current(batch), seq++);
+	mnl_nlmsg_batch_next(batch);
 
 	chain_seq = seq;
 	nlh = nftnl_chain_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
@@ -125,10 +118,8 @@ int main(int argc, char *argv[])
 	nftnl_chain_free(c);
 	mnl_nlmsg_batch_next(batch);
 
-	if (batching) {
-		nftnl_batch_end(mnl_nlmsg_batch_current(batch), seq++);
-		mnl_nlmsg_batch_next(batch);
-	}
+	nftnl_batch_end(mnl_nlmsg_batch_current(batch), seq++);
+	mnl_nlmsg_batch_next(batch);
 
 	nl = mnl_socket_open(NETLINK_NETFILTER);
 	if (nl == NULL) {
diff --git a/examples/nft-flowtable-add.c b/examples/nft-flowtable-add.c
index bd6cd0f59b79..45886c53d8aa 100644
--- a/examples/nft-flowtable-add.c
+++ b/examples/nft-flowtable-add.c
@@ -47,7 +47,6 @@ int main(int argc, char *argv[])
 	int ret, family;
 	struct nftnl_flowtable *t;
 	struct mnl_nlmsg_batch *batch;
-	int batching;
 
 	if (argc != 6) {
 		fprintf(stderr, "Usage: %s <family> <table> <name> <hook> <prio>\n",
@@ -72,19 +71,11 @@ int main(int argc, char *argv[])
 	if (t == NULL)
 		exit(EXIT_FAILURE);
 
-	batching = nftnl_batch_is_supported();
-	if (batching < 0) {
-		perror("cannot talk to nfnetlink");
-		exit(EXIT_FAILURE);
-	}
-
 	seq = time(NULL);
 	batch = mnl_nlmsg_batch_start(buf, sizeof(buf));
 
-	if (batching) {
-		nftnl_batch_begin(mnl_nlmsg_batch_current(batch), seq++);
-		mnl_nlmsg_batch_next(batch);
-	}
+	nftnl_batch_begin(mnl_nlmsg_batch_current(batch), seq++);
+	mnl_nlmsg_batch_next(batch);
 
 	flowtable_seq = seq;
 	nlh = nftnl_flowtable_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
@@ -94,10 +85,8 @@ int main(int argc, char *argv[])
 	nftnl_flowtable_free(t);
 	mnl_nlmsg_batch_next(batch);
 
-	if (batching) {
-		nftnl_batch_end(mnl_nlmsg_batch_current(batch), seq++);
-		mnl_nlmsg_batch_next(batch);
-	}
+	nftnl_batch_end(mnl_nlmsg_batch_current(batch), seq++);
+	mnl_nlmsg_batch_next(batch);
 
 	nl = mnl_socket_open(NETLINK_NETFILTER);
 	if (nl == NULL) {
diff --git a/examples/nft-flowtable-del.c b/examples/nft-flowtable-del.c
index b25f041a6f6d..366380488b9f 100644
--- a/examples/nft-flowtable-del.c
+++ b/examples/nft-flowtable-del.c
@@ -33,7 +33,7 @@ int main(int argc, char *argv[])
 	struct nlmsghdr *nlh;
 	uint32_t portid, seq, flowtable_seq;
 	struct nftnl_flowtable *t;
-	int ret, family, batching;
+	int ret, family;
 
 	if (argc != 4) {
 		fprintf(stderr, "Usage: %s <family> <table> <flowtable>\n",
@@ -58,19 +58,11 @@ int main(int argc, char *argv[])
 	if (t == NULL)
 		exit(EXIT_FAILURE);
 
-	batching = nftnl_batch_is_supported();
-	if (batching < 0) {
-		perror("cannot talk to nfnetlink");
-		exit(EXIT_FAILURE);
-	}
-
 	seq = time(NULL);
 	batch = mnl_nlmsg_batch_start(buf, sizeof(buf));
 
-	if (batching) {
-		nftnl_batch_begin(mnl_nlmsg_batch_current(batch), seq++);
-		mnl_nlmsg_batch_next(batch);
-	}
+	nftnl_batch_begin(mnl_nlmsg_batch_current(batch), seq++);
+	mnl_nlmsg_batch_next(batch);
 
 	flowtable_seq = seq;
 	nlh = nftnl_flowtable_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
@@ -80,10 +72,8 @@ int main(int argc, char *argv[])
 	nftnl_flowtable_free(t);
 	mnl_nlmsg_batch_next(batch);
 
-	if (batching) {
-		nftnl_batch_end(mnl_nlmsg_batch_current(batch), seq++);
-		mnl_nlmsg_batch_next(batch);
-	}
+	nftnl_batch_end(mnl_nlmsg_batch_current(batch), seq++);
+	mnl_nlmsg_batch_next(batch);
 
 	nl = mnl_socket_open(NETLINK_NETFILTER);
 	if (nl == NULL) {
diff --git a/examples/nft-map-add.c b/examples/nft-map-add.c
index a906d2dfeba9..d87d84160f77 100644
--- a/examples/nft-map-add.c
+++ b/examples/nft-map-add.c
@@ -63,7 +63,7 @@ int main(int argc, char *argv[])
 	uint8_t family;
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	uint32_t seq = time(NULL);
-	int ret, batching;
+	int ret;
 
 	if (argc != 4) {
 		fprintf(stderr, "Usage: %s <family> <table> <setname>\n", argv[0]);
@@ -96,18 +96,10 @@ int main(int argc, char *argv[])
 		exit(EXIT_FAILURE);
 	}
 
-	batching = nftnl_batch_is_supported();
-	if (batching < 0) {
-		perror("cannot talk to nfnetlink");
-		exit(EXIT_FAILURE);
-	}
-
 	batch = mnl_nlmsg_batch_start(buf, sizeof(buf));
 
-	if (batching) {
-		nftnl_batch_begin(mnl_nlmsg_batch_current(batch), seq++);
-		mnl_nlmsg_batch_next(batch);
-	}
+	nftnl_batch_begin(mnl_nlmsg_batch_current(batch), seq++);
+	mnl_nlmsg_batch_next(batch);
 
 	nlh = nftnl_set_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
 				      NFT_MSG_NEWSET, family,
@@ -117,10 +109,8 @@ int main(int argc, char *argv[])
 	nftnl_set_free(s);
 	mnl_nlmsg_batch_next(batch);
 
-	if (batching) {
-		nftnl_batch_end(mnl_nlmsg_batch_current(batch), seq++);
-		mnl_nlmsg_batch_next(batch);
-	}
+	nftnl_batch_end(mnl_nlmsg_batch_current(batch), seq++);
+	mnl_nlmsg_batch_next(batch);
 
 	ret = mnl_socket_sendto(nl, mnl_nlmsg_batch_head(batch),
 				mnl_nlmsg_batch_size(batch));
diff --git a/examples/nft-rule-add.c b/examples/nft-rule-add.c
index 3aeb2e06ee42..6aaf5a0650f8 100644
--- a/examples/nft-rule-add.c
+++ b/examples/nft-rule-add.c
@@ -126,7 +126,7 @@ int main(int argc, char *argv[])
 	uint8_t family;
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	uint32_t seq = time(NULL);
-	int ret, batching;
+	int ret;
 
 	if (argc < 4 || argc > 5) {
 		fprintf(stderr, "Usage: %s <family> <table> <chain>\n", argv[0]);
@@ -158,18 +158,10 @@ int main(int argc, char *argv[])
 		exit(EXIT_FAILURE);
 	}
 
-	batching = nftnl_batch_is_supported();
-	if (batching < 0) {
-		perror("cannot talk to nfnetlink");
-		exit(EXIT_FAILURE);
-	}
-
 	batch = mnl_nlmsg_batch_start(buf, sizeof(buf));
 
-	if (batching) {
-		nftnl_batch_begin(mnl_nlmsg_batch_current(batch), seq++);
-		mnl_nlmsg_batch_next(batch);
-	}
+	nftnl_batch_begin(mnl_nlmsg_batch_current(batch), seq++);
+	mnl_nlmsg_batch_next(batch);
 
 	nlh = nftnl_rule_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
 			NFT_MSG_NEWRULE,
@@ -180,10 +172,8 @@ int main(int argc, char *argv[])
 	nftnl_rule_free(r);
 	mnl_nlmsg_batch_next(batch);
 
-	if (batching) {
-		nftnl_batch_end(mnl_nlmsg_batch_current(batch), seq++);
-		mnl_nlmsg_batch_next(batch);
-	}
+	nftnl_batch_end(mnl_nlmsg_batch_current(batch), seq++);
+	mnl_nlmsg_batch_next(batch);
 
 	ret = mnl_socket_sendto(nl, mnl_nlmsg_batch_head(batch),
 				mnl_nlmsg_batch_size(batch));
diff --git a/examples/nft-rule-del.c b/examples/nft-rule-del.c
index 5c68363e7a74..bfd37abf1621 100644
--- a/examples/nft-rule-del.c
+++ b/examples/nft-rule-del.c
@@ -30,7 +30,7 @@ int main(int argc, char *argv[])
 	struct mnl_nlmsg_batch *batch;
 	uint32_t portid, seq;
 	struct nftnl_rule *r = NULL;
-	int ret, batching, family;
+	int ret, family;
 
 	if (argc < 4 || argc > 5) {
 		fprintf(stderr, "Usage: %s <family> <table> <chain> [<handle>]\n",
@@ -65,18 +65,10 @@ int main(int argc, char *argv[])
 	if (argc == 5)
 		nftnl_rule_set_u64(r, NFTNL_RULE_HANDLE, atoi(argv[4]));
 
-	batching = nftnl_batch_is_supported();
-	if (batching < 0) {
-		perror("cannot talk to nfnetlink");
-		exit(EXIT_FAILURE);
-	}
-
 	batch = mnl_nlmsg_batch_start(buf, sizeof(buf));
 
-	if (batching) {
-		nftnl_batch_begin(mnl_nlmsg_batch_current(batch), seq++);
-		mnl_nlmsg_batch_next(batch);
-	}
+	nftnl_batch_begin(mnl_nlmsg_batch_current(batch), seq++);
+	mnl_nlmsg_batch_next(batch);
 
 	nlh = nftnl_rule_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
 				NFT_MSG_DELRULE,
@@ -87,10 +79,8 @@ int main(int argc, char *argv[])
 	nftnl_rule_free(r);
 	mnl_nlmsg_batch_next(batch);
 
-	if (batching) {
-		nftnl_batch_end(mnl_nlmsg_batch_current(batch), seq++);
-		mnl_nlmsg_batch_next(batch);
-	}
+	nftnl_batch_end(mnl_nlmsg_batch_current(batch), seq++);
+	mnl_nlmsg_batch_next(batch);
 
 	nl = mnl_socket_open(NETLINK_NETFILTER);
 	if (nl == NULL) {
diff --git a/examples/nft-rule-parse-add.c b/examples/nft-rule-parse-add.c
index e6946c87866f..3fcf2691295b 100644
--- a/examples/nft-rule-parse-add.c
+++ b/examples/nft-rule-parse-add.c
@@ -80,7 +80,7 @@ int main(int argc, char *argv[])
 	struct nlmsghdr *nlh;
 	uint32_t portid, seq, rule_seq;
 	struct nftnl_rule *r;
-	int ret, batching;
+	int ret;
 	uint16_t family, format, outformat;
 
 	if (argc < 3) {
@@ -103,19 +103,11 @@ int main(int argc, char *argv[])
 	nftnl_rule_fprintf(stdout, r, outformat, 0);
 	fprintf(stdout, "\n");
 
-	batching = nftnl_batch_is_supported();
-	if (batching < 0) {
-		perror("Cannot talk to nfnetlink");
-		exit(EXIT_FAILURE);
-	}
-
 	seq = time(NULL);
 	batch = mnl_nlmsg_batch_start(buf, sizeof(buf));
 
-	if (batching) {
-		nftnl_batch_begin(mnl_nlmsg_batch_current(batch), seq++);
-		mnl_nlmsg_batch_next(batch);
-	}
+	nftnl_batch_begin(mnl_nlmsg_batch_current(batch), seq++);
+	mnl_nlmsg_batch_next(batch);
 
 	rule_seq = seq;
 	family = nftnl_rule_get_u32(r, NFTNL_RULE_FAMILY);
@@ -127,10 +119,8 @@ int main(int argc, char *argv[])
 	nftnl_rule_free(r);
 	mnl_nlmsg_batch_next(batch);
 
-	if (batching) {
-		nftnl_batch_end(mnl_nlmsg_batch_current(batch), seq++);
-		mnl_nlmsg_batch_next(batch);
-	}
+	nftnl_batch_end(mnl_nlmsg_batch_current(batch), seq++);
+	mnl_nlmsg_batch_next(batch);
 
 	nl = mnl_socket_open(NETLINK_NETFILTER);
 	if (nl == NULL) {
diff --git a/examples/nft-ruleset-parse-file.c b/examples/nft-ruleset-parse-file.c
index 505c43c78da8..be0994fd84f5 100644
--- a/examples/nft-ruleset-parse-file.c
+++ b/examples/nft-ruleset-parse-file.c
@@ -379,7 +379,7 @@ int main(int argc, char *argv[])
 	struct nftnl_parse_err *err;
 	const char *filename;
 	FILE *fp;
-	int ret = -1, len, batching, portid;
+	int ret = -1, len, portid;
 	uint32_t ruleset_seq;
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct mnl_socket *nl;
@@ -402,19 +402,11 @@ int main(int argc, char *argv[])
 		exit(EXIT_FAILURE);
 	}
 
-	batching = nftnl_batch_is_supported();
-	if (batching < 0) {
-		perror("Cannot talk to nfnetlink");
-		exit(EXIT_FAILURE);
-	}
-
 	seq = time(NULL);
 	batch = mnl_nlmsg_batch_start(buf, sizeof(buf));
 
-	if (batching) {
-		nftnl_batch_begin(mnl_nlmsg_batch_current(batch), seq++);
-		mnl_nlmsg_batch_next(batch);
-	}
+	nftnl_batch_begin(mnl_nlmsg_batch_current(batch), seq++);
+	mnl_nlmsg_batch_next(batch);
 	ruleset_seq = seq;
 
 	filename = argv[1];
@@ -435,10 +427,8 @@ int main(int argc, char *argv[])
 
 	fclose(fp);
 
-	if (batching) {
-		nftnl_batch_end(mnl_nlmsg_batch_current(batch), seq++);
-		mnl_nlmsg_batch_next(batch);
-	}
+	nftnl_batch_end(mnl_nlmsg_batch_current(batch), seq++);
+	mnl_nlmsg_batch_next(batch);
 
 	nl = mnl_socket_open(NETLINK_NETFILTER);
 	if (nl == NULL) {
diff --git a/examples/nft-set-add.c b/examples/nft-set-add.c
index bdb93737a9e0..d8e3e4e848b6 100644
--- a/examples/nft-set-add.c
+++ b/examples/nft-set-add.c
@@ -59,7 +59,7 @@ int main(int argc, char *argv[])
 	uint8_t family;
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	uint32_t seq = time(NULL);
-	int ret, batching;
+	int ret;
 
 	if (argc != 4) {
 		fprintf(stderr, "Usage: %s <family> <table> <setname>\n", argv[0]);
@@ -92,18 +92,10 @@ int main(int argc, char *argv[])
 		exit(EXIT_FAILURE);
 	}
 
-	batching = nftnl_batch_is_supported();
-	if (batching < 0) {
-		perror("cannot talk to nfnetlink");
-		exit(EXIT_FAILURE);
-	}
-
 	batch = mnl_nlmsg_batch_start(buf, sizeof(buf));
 
-	if (batching) {
-		nftnl_batch_begin(mnl_nlmsg_batch_current(batch), seq++);
-		mnl_nlmsg_batch_next(batch);
-	}
+	nftnl_batch_begin(mnl_nlmsg_batch_current(batch), seq++);
+	mnl_nlmsg_batch_next(batch);
 
 	nlh = nftnl_set_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
 				      NFT_MSG_NEWSET, family,
@@ -113,10 +105,8 @@ int main(int argc, char *argv[])
 	nftnl_set_free(s);
 	mnl_nlmsg_batch_next(batch);
 
-	if (batching) {
-		nftnl_batch_end(mnl_nlmsg_batch_current(batch), seq++);
-		mnl_nlmsg_batch_next(batch);
-	}
+	nftnl_batch_end(mnl_nlmsg_batch_current(batch), seq++);
+	mnl_nlmsg_batch_next(batch);
 
 	ret = mnl_socket_sendto(nl, mnl_nlmsg_batch_head(batch),
 				mnl_nlmsg_batch_size(batch));
diff --git a/examples/nft-set-parse-add.c b/examples/nft-set-parse-add.c
index 2882f141551c..5197dc30aafe 100644
--- a/examples/nft-set-parse-add.c
+++ b/examples/nft-set-parse-add.c
@@ -80,9 +80,9 @@ int main(int argc, char *argv[])
 	struct nlmsghdr *nlh;
 	uint32_t portid, seq, set_seq;
 	struct nftnl_set *s;
-	int ret, batching;
 	uint16_t family, format, outformat;
 	struct mnl_nlmsg_batch *batch;
+	int ret;
 
 	if (argc < 2) {
 		printf("Usage: %s {json} <file>\n", argv[0]);
@@ -105,18 +105,11 @@ int main(int argc, char *argv[])
 	fprintf(stdout, "\n");
 
 	seq = time(NULL);
-	batching = nftnl_batch_is_supported();
-	if (batching < 0) {
-		perror("cannot talk to nfnetlink");
-		exit(EXIT_FAILURE);
-	}
 
 	batch = mnl_nlmsg_batch_start(buf, sizeof(buf));
 
-	if (batching) {
-		nftnl_batch_begin(mnl_nlmsg_batch_current(batch), seq++);
-		mnl_nlmsg_batch_next(batch);
-	}
+	nftnl_batch_begin(mnl_nlmsg_batch_current(batch), seq++);
+	mnl_nlmsg_batch_next(batch);
 
 	family = nftnl_set_get_u32(s, NFTNL_SET_FAMILY);
 
@@ -128,10 +121,8 @@ int main(int argc, char *argv[])
 	nftnl_set_free(s);
 	mnl_nlmsg_batch_next(batch);
 
-	if (batching) {
-		nftnl_batch_end(mnl_nlmsg_batch_current(batch), seq++);
-		mnl_nlmsg_batch_next(batch);
-	}
+	nftnl_batch_end(mnl_nlmsg_batch_current(batch), seq++);
+	mnl_nlmsg_batch_next(batch);
 
 	nl = mnl_socket_open(NETLINK_NETFILTER);
 	if (nl == NULL) {
diff --git a/examples/nft-table-add.c b/examples/nft-table-add.c
index aa6e2688fb6e..4418a51fb010 100644
--- a/examples/nft-table-add.c
+++ b/examples/nft-table-add.c
@@ -58,7 +58,7 @@ int main(int argc, char *argv[])
 	uint32_t portid, seq, table_seq, family;
 	struct nftnl_table *t;
 	struct mnl_nlmsg_batch *batch;
-	int ret, batching;
+	int ret;
 
 	if (argc != 3) {
 		fprintf(stderr, "%s <family> <name>\n", argv[0]);
@@ -69,19 +69,11 @@ int main(int argc, char *argv[])
 	if (t == NULL)
 		exit(EXIT_FAILURE);
 
-	batching = nftnl_batch_is_supported();
-	if (batching < 0) {
-		perror("cannot talk to nfnetlink");
-		exit(EXIT_FAILURE);
-	}
-
 	seq = time(NULL);
 	batch = mnl_nlmsg_batch_start(buf, sizeof(buf));
 
-	if (batching) {
-		nftnl_batch_begin(mnl_nlmsg_batch_current(batch), seq++);
-		mnl_nlmsg_batch_next(batch);
-	}
+	nftnl_batch_begin(mnl_nlmsg_batch_current(batch), seq++);
+	mnl_nlmsg_batch_next(batch);
 
 	table_seq = seq;
 	family = nftnl_table_get_u32(t, NFTNL_TABLE_FAMILY);
@@ -92,10 +84,8 @@ int main(int argc, char *argv[])
 	nftnl_table_free(t);
 	mnl_nlmsg_batch_next(batch);
 
-	if (batching) {
-		nftnl_batch_end(mnl_nlmsg_batch_current(batch), seq++);
-		mnl_nlmsg_batch_next(batch);
-	}
+	nftnl_batch_end(mnl_nlmsg_batch_current(batch), seq++);
+	mnl_nlmsg_batch_next(batch);
 
 	nl = mnl_socket_open(NETLINK_NETFILTER);
 	if (nl == NULL) {
diff --git a/examples/nft-table-del.c b/examples/nft-table-del.c
index 9d1f3be97bf0..aa1827d7168c 100644
--- a/examples/nft-table-del.c
+++ b/examples/nft-table-del.c
@@ -58,7 +58,7 @@ int main(int argc, char *argv[])
 	uint32_t portid, seq, table_seq, family;
 	struct nftnl_table *t;
 	struct mnl_nlmsg_batch *batch;
-	int ret, batching;
+	int ret;
 
 	if (argc != 3) {
 		fprintf(stderr, "%s <family> <name>\n", argv[0]);
@@ -69,19 +69,11 @@ int main(int argc, char *argv[])
 	if (t == NULL)
 		exit(EXIT_FAILURE);
 
-	batching = nftnl_batch_is_supported();
-	if (batching < 0) {
-		perror("cannot talk to nfnetlink");
-		exit(EXIT_FAILURE);
-	}
-
 	seq = time(NULL);
 	batch = mnl_nlmsg_batch_start(buf, sizeof(buf));
 
-	if (batching) {
-		nftnl_batch_begin(mnl_nlmsg_batch_current(batch), seq++);
-		mnl_nlmsg_batch_next(batch);
-	}
+	nftnl_batch_begin(mnl_nlmsg_batch_current(batch), seq++);
+	mnl_nlmsg_batch_next(batch);
 
 	table_seq = seq;
 	family = nftnl_table_get_u32(t, NFTNL_TABLE_FAMILY);
@@ -92,10 +84,8 @@ int main(int argc, char *argv[])
 	mnl_nlmsg_batch_next(batch);
 	nftnl_table_free(t);
 
-	if (batching) {
-		nftnl_batch_end(mnl_nlmsg_batch_current(batch), seq++);
-		mnl_nlmsg_batch_next(batch);
-	}
+	nftnl_batch_end(mnl_nlmsg_batch_current(batch), seq++);
+	mnl_nlmsg_batch_next(batch);
 
 	nl = mnl_socket_open(NETLINK_NETFILTER);
 	if (nl == NULL) {
diff --git a/examples/nft-table-parse-add.c b/examples/nft-table-parse-add.c
index cb4bcc67dced..55dbc132ecea 100644
--- a/examples/nft-table-parse-add.c
+++ b/examples/nft-table-parse-add.c
@@ -75,9 +75,9 @@ int main(int argc, char *argv[])
 	struct nlmsghdr *nlh;
 	uint32_t portid, seq, table_seq;
 	struct nftnl_table *t = NULL;
-	int ret, batching;
 	uint16_t family, format, outformat;
 	struct mnl_nlmsg_batch *batch;
+	int ret;
 
 	if (argc < 3) {
 		printf("Usage: %s {json} <file>\n", argv[0]);
@@ -100,18 +100,11 @@ int main(int argc, char *argv[])
 	fprintf(stdout, "\n");
 
 	seq = time(NULL);
-	batching = nftnl_batch_is_supported();
-	if (batching < 0) {
-		perror("cannot talk to nfnetlink");
-		exit(EXIT_FAILURE);
-	}
 
 	batch = mnl_nlmsg_batch_start(buf, sizeof(buf));
 
-	if (batching) {
-		nftnl_batch_begin(mnl_nlmsg_batch_current(batch), seq++);
-		mnl_nlmsg_batch_next(batch);
-	}
+	nftnl_batch_begin(mnl_nlmsg_batch_current(batch), seq++);
+	mnl_nlmsg_batch_next(batch);
 
 	family = nftnl_table_get_u32(t, NFTNL_TABLE_FAMILY);
 
@@ -123,10 +116,8 @@ int main(int argc, char *argv[])
 	nftnl_table_free(t);
 	mnl_nlmsg_batch_next(batch);
 
-	if (batching) {
-		nftnl_batch_end(mnl_nlmsg_batch_current(batch), seq++);
-		mnl_nlmsg_batch_next(batch);
-	}
+	nftnl_batch_end(mnl_nlmsg_batch_current(batch), seq++);
+	mnl_nlmsg_batch_next(batch);
 
 	nl = mnl_socket_open(NETLINK_NETFILTER);
 	if (nl == NULL) {
diff --git a/examples/nft-table-upd.c b/examples/nft-table-upd.c
index 9b960bbfdf24..586d84ca48a6 100644
--- a/examples/nft-table-upd.c
+++ b/examples/nft-table-upd.c
@@ -28,7 +28,7 @@ int main(int argc, char *argv[])
 	uint32_t portid, seq, table_seq, family, flags;
 	struct nftnl_table *t = NULL;
 	struct mnl_nlmsg_batch *batch;
-	int ret, batching;
+	int ret;
 
 	if (argc != 4) {
 		fprintf(stderr, "%s <family> <name> <state>\n", argv[0]);
@@ -41,19 +41,11 @@ int main(int argc, char *argv[])
 		exit(EXIT_FAILURE);
 	}
 
-	batching = nftnl_batch_is_supported();
-	if (batching < 0) {
-		perror("cannot talk to nfnetlink");
-		exit(EXIT_FAILURE);
-	}
-
 	seq = time(NULL);
 	batch = mnl_nlmsg_batch_start(buf, sizeof(buf));
 
-	if (batching) {
-		nftnl_batch_begin(mnl_nlmsg_batch_current(batch), seq++);
-		mnl_nlmsg_batch_next(batch);
-	}
+	nftnl_batch_begin(mnl_nlmsg_batch_current(batch), seq++);
+	mnl_nlmsg_batch_next(batch);
 
 	if (strcmp(argv[1], "ip") == 0)
 		family = NFPROTO_IPV4;
@@ -91,10 +83,8 @@ int main(int argc, char *argv[])
 	nftnl_table_free(t);
 	mnl_nlmsg_batch_next(batch);
 
-	if (batching) {
-		nftnl_batch_end(mnl_nlmsg_batch_current(batch), seq++);
-		mnl_nlmsg_batch_next(batch);
-	}
+	nftnl_batch_end(mnl_nlmsg_batch_current(batch), seq++);
+	mnl_nlmsg_batch_next(batch);
 
 	nl = mnl_socket_open(NETLINK_NETFILTER);
 	if (nl == NULL) {
-- 
2.11.0

