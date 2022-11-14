Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97254C4332F
	for <netfilter-devel@archiver.kernel.org>; Mon, 14 Nov 2022 16:44:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237741AbiKNQoj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 14 Nov 2022 11:44:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237882AbiKNQoj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 14 Nov 2022 11:44:39 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6A4532A264
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Nov 2022 08:44:36 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnftnl] example: remove nftnl_batch_is_supported() call
Date:   Mon, 14 Nov 2022 17:44:32 +0100
Message-Id: <20221114164432.24407-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Linux kernel <= 3.13 needs for this check, remove it from examples.

Kernel commit:

  958bee14d071 ("netfilter: nf_tables: use new transaction infrastructure to handle sets")

added support for set into the batch.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 examples/nft-flowtable-add.c | 19 ++++---------------
 examples/nft-flowtable-del.c | 20 +++++---------------
 2 files changed, 9 insertions(+), 30 deletions(-)

diff --git a/examples/nft-flowtable-add.c b/examples/nft-flowtable-add.c
index 5ca62be01a01..4e0e50b95cbf 100644
--- a/examples/nft-flowtable-add.c
+++ b/examples/nft-flowtable-add.c
@@ -47,7 +47,6 @@ int main(int argc, char *argv[])
 	int ret, family;
 	struct nftnl_flowtable *t;
 	struct mnl_nlmsg_batch *batch;
-	int batching;
 
 	if (argc != 6) {
 		fprintf(stderr, "Usage: %s <family> <table> <name> <hook> <prio>\n",
@@ -74,19 +73,11 @@ int main(int argc, char *argv[])
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
@@ -96,10 +87,8 @@ int main(int argc, char *argv[])
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
index 91e5d3a74410..ffc83b25f716 100644
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
@@ -60,19 +60,11 @@ int main(int argc, char *argv[])
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
@@ -82,10 +74,8 @@ int main(int argc, char *argv[])
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
-- 
2.30.2

