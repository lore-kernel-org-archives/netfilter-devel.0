From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 05/09]: nfnetlink: support attribute policies
Date: Thu, 27 Sep 2007 15:46:07 +0200 (MEST)
Message-ID: <20070927134606.10198.70574.sendpatchset@localhost.localdomain>
References: <20070927134559.10198.64673.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58747 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819AbXI0NqI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Sep 2007 09:46:08 -0400
In-Reply-To: <20070927134559.10198.64673.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

[NETFILTER]: nfnetlink: support attribute policies

Add support for automatic checking of per-callback attribute policies.

Also fix attribute parsing for empty messages, the attribute array
wasn't cleared and contained random crap before.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 5ee4018ae6360a2d6aad8068e7a91c82851dc8ec
tree a99a19c0a6db32a0622443924869b95e21d45ff3
parent e8e16c2608c3a4ac863db49f3c30cae87c582c45
author Patrick McHardy <kaber@trash.net> Thu, 27 Sep 2007 14:22:11 +0200
committer Patrick McHardy <kaber@trash.net> Thu, 27 Sep 2007 14:22:11 +0200

 include/linux/netfilter/nfnetlink.h |    3 +-
 net/netfilter/nfnetlink.c           |   47 +++++++++--------------------------
 2 files changed, 14 insertions(+), 36 deletions(-)

diff --git a/include/linux/netfilter/nfnetlink.h b/include/linux/netfilter/nfnetlink.h
index 0bd6086..3ee136a 100644
--- a/include/linux/netfilter/nfnetlink.h
+++ b/include/linux/netfilter/nfnetlink.h
@@ -58,7 +58,8 @@ struct nfnl_callback
 {
 	int (*call)(struct sock *nl, struct sk_buff *skb, 
 		struct nlmsghdr *nlh, struct nlattr *cda[]);
-	u_int16_t attr_count;	/* number of nlattr's */
+	const struct nla_policy *policy;	/* netlink attribute policy */
+	const u_int16_t attr_count;		/* number of nlattr's */
 };
 
 struct nfnetlink_subsystem
diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index e212102..bda0f10 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -111,35 +111,6 @@ nfnetlink_find_client(u_int16_t type, const struct nfnetlink_subsystem *ss)
 	return &ss->cb[cb_id];
 }
 
-/**
- * nfnetlink_check_attributes - check and parse nfnetlink attributes
- *
- * subsys: nfnl subsystem for which this message is to be parsed
- * nlmsghdr: netlink message to be checked/parsed
- * cda: array of pointers, needs to be at least subsys->attr_count+1 big
- *
- */
-static int
-nfnetlink_check_attributes(const struct nfnetlink_subsystem *subsys,
-			   struct nlmsghdr *nlh, struct nlattr *cda[])
-{
-	int min_len = NLMSG_SPACE(sizeof(struct nfgenmsg));
-	u_int8_t cb_id = NFNL_MSG_TYPE(nlh->nlmsg_type);
-	u_int16_t attr_count = subsys->cb[cb_id].attr_count;
-
-	/* check attribute lengths. */
-	if (likely(nlh->nlmsg_len > min_len)) {
-		struct nlattr *attr = (void *)nlh + NLMSG_ALIGN(min_len);
-		int attrlen = nlh->nlmsg_len - NLMSG_ALIGN(min_len);
-		nla_parse(cda, attr_count, attr, attrlen, NULL);
-	}
-
-	/* implicit: if nlmsg_len == min_len, we return 0, and an empty
-	 * (zeroed) cda[] array. The message is valid, but empty. */
-
-	return 0;
-}
-
 int nfnetlink_has_listeners(unsigned int group)
 {
 	return netlink_has_listeners(nfnl, group);
@@ -163,7 +134,7 @@ static int nfnetlink_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 {
 	const struct nfnl_callback *nc;
 	const struct nfnetlink_subsystem *ss;
-	int type, err;
+	int type;
 
 	if (security_netlink_recv(skb, CAP_NET_ADMIN))
 		return -EPERM;
@@ -192,15 +163,21 @@ static int nfnetlink_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 		return -EINVAL;
 
 	{
-		u_int16_t attr_count =
-			ss->cb[NFNL_MSG_TYPE(nlh->nlmsg_type)].attr_count;
+		int min_len = NLMSG_SPACE(sizeof(struct nfgenmsg));
+		u_int8_t cb_id = NFNL_MSG_TYPE(nlh->nlmsg_type);
+		u_int16_t attr_count = ss->cb[cb_id].attr_count;
 		struct nlattr *cda[attr_count+1];
 
 		memset(cda, 0, sizeof(struct nlattr *) * attr_count);
 
-		err = nfnetlink_check_attributes(ss, nlh, cda);
-		if (err < 0)
-			return err;
+		if (likely(nlh->nlmsg_len >= min_len)) {
+			struct nlattr *attr = (void *)nlh + NLMSG_ALIGN(min_len);
+			int attrlen = nlh->nlmsg_len - NLMSG_ALIGN(min_len);
+			nla_parse(cda, attr_count, attr, attrlen,
+				  ss->cb[cb_id].policy);
+		} else
+			return -EINVAL;
+
 		return nc->call(nfnl, skb, nlh, cda);
 	}
 }
