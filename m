From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/5] netfilter: nfnetlink: Improve input length sanitization in nfnetlink_rcv
Date: Tue, 18 Jul 2017 12:13:55 +0200
Message-ID: <1500372839-6735-2-git-send-email-pablo@netfilter.org>
References: <1500372839-6735-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44274 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751413AbdGRKOM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Jul 2017 06:14:12 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B5FA1A4177
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Jul 2017 12:13:58 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A5DE3CFDD2
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Jul 2017 12:13:58 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8D24ACE360
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Jul 2017 12:13:56 +0200 (CEST)
In-Reply-To: <1500372839-6735-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Mateusz Jurczyk <mjurczyk@google.com>

Verify that the length of the socket buffer is sufficient to cover the
nlmsghdr structure before accessing the nlh->nlmsg_len field for further
input sanitization. If the client only supplies 1-3 bytes of data in
sk_buff, then nlh->nlmsg_len remains partially uninitialized and
contains leftover memory from the corresponding kernel allocation.
Operating on such data may result in indeterminate evaluation of the
nlmsg_len < NLMSG_HDRLEN expression.

The bug was discovered by a runtime instrumentation designed to detect
use of uninitialized memory in the kernel. The patch prevents this and
other similar tools (e.g. KMSAN) from flagging this behavior in the future.

Signed-off-by: Mateusz Jurczyk <mjurczyk@google.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nfnetlink.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index 92b05e188fd1..733d3e4a30d8 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -472,8 +472,7 @@ static void nfnetlink_rcv_skb_batch(struct sk_buff *skb, struct nlmsghdr *nlh)
 	if (msglen > skb->len)
 		msglen = skb->len;
 
-	if (nlh->nlmsg_len < NLMSG_HDRLEN ||
-	    skb->len < NLMSG_HDRLEN + sizeof(struct nfgenmsg))
+	if (skb->len < NLMSG_HDRLEN + sizeof(struct nfgenmsg))
 		return;
 
 	err = nla_parse(cda, NFNL_BATCH_MAX, attr, attrlen, nfnl_batch_policy,
@@ -500,7 +499,8 @@ static void nfnetlink_rcv(struct sk_buff *skb)
 {
 	struct nlmsghdr *nlh = nlmsg_hdr(skb);
 
-	if (nlh->nlmsg_len < NLMSG_HDRLEN ||
+	if (skb->len < NLMSG_HDRLEN ||
+	    nlh->nlmsg_len < NLMSG_HDRLEN ||
 	    skb->len < nlh->nlmsg_len)
 		return;
 
-- 
2.1.4

