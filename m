From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/9] netfilter: nfnetlink: cleanup for nfnetlink_rcv_msg()
	function
Date: Tue, 02 Jun 2009 20:18:05 +0200
Message-ID: <20090602181805.18573.72028.stgit@Decadence>
References: <20090602181336.18573.85368.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51712 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751048AbZFBSbI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Jun 2009 14:31:08 -0400
In-Reply-To: <20090602181336.18573.85368.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch cleans up the message handling path in two aspects:

 * it uses NLMSG_LENGTH() instead of NLMSG_SPACE() like rtnetlink
does in this case to check if there is enough room for the
Netlink/nfnetlink headers. No need to check for the padding room.

 * it removes a redundant header size checking that has been
 already do at the beginning of the function.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---

 net/netfilter/nfnetlink.c |   23 +++++++++--------------
 1 files changed, 9 insertions(+), 14 deletions(-)

diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index b8ab37a..9dbd570 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -136,7 +136,7 @@ static int nfnetlink_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 		return -EPERM;
 
 	/* All the messages must at least contain nfgenmsg */
-	if (nlh->nlmsg_len < NLMSG_SPACE(sizeof(struct nfgenmsg)))
+	if (nlh->nlmsg_len < NLMSG_LENGTH(sizeof(struct nfgenmsg)))
 		return 0;
 
 	type = nlh->nlmsg_type;
@@ -160,19 +160,14 @@ replay:
 	{
 		int min_len = NLMSG_SPACE(sizeof(struct nfgenmsg));
 		u_int8_t cb_id = NFNL_MSG_TYPE(nlh->nlmsg_type);
-		u_int16_t attr_count = ss->cb[cb_id].attr_count;
-		struct nlattr *cda[attr_count+1];
-
-		if (likely(nlh->nlmsg_len >= min_len)) {
-			struct nlattr *attr = (void *)nlh + NLMSG_ALIGN(min_len);
-			int attrlen = nlh->nlmsg_len - NLMSG_ALIGN(min_len);
-
-			err = nla_parse(cda, attr_count, attr, attrlen,
-					ss->cb[cb_id].policy);
-			if (err < 0)
-				return err;
-		} else
-			return -EINVAL;
+		struct nlattr *cda[ss->cb[cb_id].attr_count + 1];
+		struct nlattr *attr = (void *)nlh + min_len;
+		int attrlen = nlh->nlmsg_len - min_len;
+
+		err = nla_parse(cda, ss->cb[cb_id].attr_count,
+				attr, attrlen, ss->cb[cb_id].policy);
+		if (err < 0)
+			return err;
 
 		err = nc->call(nfnl, skb, nlh, cda);
 		if (err == -EAGAIN)

