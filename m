From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] mnl: add mnl_nft_setelem_batch_flush() and use it from netlink_flush_setelems()
Date: Tue, 20 Dec 2016 01:23:46 +0100
Message-ID: <1482193426-11645-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44154 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752848AbcLTAX6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 19 Dec 2016 19:23:58 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4E5947642
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Dec 2016 01:23:54 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3E557DA7F6
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Dec 2016 01:23:54 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C097FDA804
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Dec 2016 01:23:50 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Commit 8bd99f2fca7e ("mnl: don't send empty set elements netlink message
to kernel") broke set flush because we still need to send the set
element netlink message header with no payload to flush sets.

To avoid more whack-a-mole games, add a new explicit function
mnl_nft_setelem_batch_flush() that is used to request a set flush.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/mnl.h |  2 ++
 src/mnl.c     | 15 +++++++++++++++
 src/netlink.c | 14 +++++++++++++-
 3 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/include/mnl.h b/include/mnl.h
index f74dfee5c8c6..87db96afd369 100644
--- a/include/mnl.h
+++ b/include/mnl.h
@@ -82,6 +82,8 @@ int mnl_nft_setelem_delete(struct mnl_socket *nf_sock, struct nftnl_set *nls,
 			   unsigned int flags);
 int mnl_nft_setelem_batch_del(struct nftnl_set *nls,
 			      unsigned int flags, uint32_t seq);
+int mnl_nft_setelem_batch_flush(struct nftnl_set *nls, unsigned int flags,
+				uint32_t seqnum);
 int mnl_nft_setelem_get(struct mnl_socket *nf_sock, struct nftnl_set *nls);
 
 struct nftnl_ruleset *mnl_nft_ruleset_dump(struct mnl_socket *nf_sock,
diff --git a/src/mnl.c b/src/mnl.c
index d107015c2743..257b630e2a26 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -902,6 +902,21 @@ int mnl_nft_setelem_batch_add(struct nftnl_set *nls, unsigned int flags,
 	return mnl_nft_setelem_batch(nls, NFT_MSG_NEWSETELEM, flags, seqnum);
 }
 
+int mnl_nft_setelem_batch_flush(struct nftnl_set *nls, unsigned int flags,
+				uint32_t seqnum)
+{
+	struct nlmsghdr *nlh;
+
+	nlh = nftnl_set_elem_nlmsg_build_hdr(nftnl_batch_buffer(batch),
+			NFT_MSG_DELSETELEM,
+			nftnl_set_get_u32(nls, NFTNL_SET_FAMILY),
+			NLM_F_CREATE | flags, seqnum);
+	nftnl_set_elems_nlmsg_build_payload(nlh, nls);
+	mnl_nft_batch_continue();
+
+	return 0;
+}
+
 int mnl_nft_setelem_batch_del(struct nftnl_set *nls, unsigned int flags,
 			      uint32_t seqnum)
 {
diff --git a/src/netlink.c b/src/netlink.c
index 714df4e892b2..d6d00199d746 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1410,7 +1410,19 @@ static int netlink_del_setelems_compat(struct netlink_ctx *ctx,
 int netlink_flush_setelems(struct netlink_ctx *ctx, const struct handle *h,
 			   const struct location *loc)
 {
-	return netlink_del_setelems_batch(ctx, h, NULL);
+	struct nftnl_set *nls;
+	int err;
+
+	nls = alloc_nftnl_set(h);
+	netlink_dump_set(nls);
+
+	err = mnl_nft_setelem_batch_flush(nls, 0, ctx->seqnum);
+	nftnl_set_free(nls);
+	if (err < 0)
+		netlink_io_error(ctx, loc,
+				 "Could not flush set elements: %s",
+				 strerror(errno));
+	return err;
 }
 
 static struct expr *netlink_parse_concat_elem(const struct datatype *dtype,
-- 
2.1.4

