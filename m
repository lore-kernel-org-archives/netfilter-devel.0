From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf 1/3] netfilter: nfnetlink: validate nfnetlink header from batch
Date: Mon,  5 Jan 2015 12:06:25 +0100
Message-ID: <1420455986-5800-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52242 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753241AbbAELDw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 5 Jan 2015 06:03:52 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Make sure there is enough room for the nfnetlink header in the
netlink messages that are part of the batch. There is a similar
check in netlink_rcv_skb().

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nfnetlink.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index 13c2e17..c6619d4 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -321,7 +321,8 @@ replay:
 		nlh = nlmsg_hdr(skb);
 		err = 0;
 
-		if (nlh->nlmsg_len < NLMSG_HDRLEN) {
+		if (nlmsg_len(nlh) < sizeof(struct nfgenmsg) ||
+		    skb->len < nlh->nlmsg_len) {
 			err = -EINVAL;
 			goto ack;
 		}
-- 
1.7.10.4

