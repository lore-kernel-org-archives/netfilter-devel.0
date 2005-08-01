From: Pablo Neira <pablo@eurodev.net>
Subject: [PATCH 6/7] Fix expectation creation
Date: Mon, 01 Aug 2005 19:06:53 +0200
Message-ID: <42EE56AD.40505@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------050103050002080203010401"
Cc: Harald Welte <laforge@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------050103050002080203010401
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Expectation creation is broken, now it works again.

--------------050103050002080203010401
Content-Type: text/x-patch;
 name="06fix-expect-new.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="06fix-expect-new.patch"

Index: netfilter-2.6.14/net/ipv4/netfilter/ip_conntrack_netlink.c
===================================================================
--- netfilter-2.6.14.orig/net/ipv4/netfilter/ip_conntrack_netlink.c	2005-08-01 18:21:18.000000000 +0200
+++ netfilter-2.6.14/net/ipv4/netfilter/ip_conntrack_netlink.c	2005-08-01 18:21:22.000000000 +0200
@@ -1415,9 +1415,9 @@
 }
 
 static int
-ctnetlink_create_expect(struct nfattr *cda[])
+ctnetlink_create_expect(struct nfattr *cda[], struct ip_conntrack_tuple *master)
 {
-	struct ip_conntrack_tuple tuple, mask, master_tuple;
+	struct ip_conntrack_tuple tuple, mask;
 	struct ip_conntrack_tuple_hash *h = NULL;
 	struct ip_conntrack_expect *exp;
 	struct ip_conntrack *ct;
@@ -1428,23 +1428,12 @@
 	err = ctnetlink_parse_tuple(cda, &tuple, CTA_EXPECT_TUPLE);
 	if (err < 0)
 		return err;
-	err = ctnetlink_parse_tuple(cda, &tuple, CTA_EXPECT_MASK);
-	if (err < 0)
-		return err;
-
-	if (cda[CTA_TUPLE_ORIG-1])
-		err = ctnetlink_parse_tuple(cda, &master_tuple, CTA_TUPLE_ORIG);
-	else if (cda[CTA_TUPLE_REPLY-1])
-		err = ctnetlink_parse_tuple(cda, &master_tuple, 
-					    CTA_TUPLE_REPLY);
-	else
-		return -EINVAL;
-
+	err = ctnetlink_parse_tuple(cda, &mask, CTA_EXPECT_MASK);
 	if (err < 0)
 		return err;
 
 	/* Look for master conntrack of this expectation */
-	h = ip_conntrack_find_get(&master_tuple, NULL);
+	h = ip_conntrack_find_get(master, NULL);
 	if (!h)
 		return -ENOENT;
 	ct = tuplehash_to_ctrack(h);
@@ -1478,16 +1467,30 @@
 ctnetlink_new_expect(struct sock *ctnl, struct sk_buff *skb,
 		     struct nlmsghdr *nlh, struct nfattr *cda[], int *errp)
 {
-	struct ip_conntrack_tuple tuple;
+	struct nfattr *tb[CTA_EXPECT_MAX];
+	struct ip_conntrack_tuple tuple, master;
 	struct ip_conntrack_expect *exp;
 	int err = 0;
 
-	DEBUGP("entered %s\n", __FUNCTION__);	
+	DEBUGP("entered %s\n", __FUNCTION__);
 
-	if (!cda[CTA_EXPECT_TUPLE-1] || !cda[CTA_EXPECT_MASK-1])
+	if (!cda[CTA_EXPECT-1])
+		return -EINVAL;
+
+	if (cda[CTA_TUPLE_ORIG-1])
+		err = ctnetlink_parse_tuple(cda, &master, CTA_TUPLE_ORIG);
+	else if (cda[CTA_TUPLE_REPLY-1])
+		err = ctnetlink_parse_tuple(cda, &master, CTA_TUPLE_REPLY);
+	else
 		return -EINVAL;
 
-	err = ctnetlink_parse_tuple(cda, &tuple, CTA_EXPECT_TUPLE);
+	if (err < 0)
+		return err;
+
+	if (nfattr_parse_nested(tb, CTA_EXPECT_MAX, cda[CTA_EXPECT-1]) < 0)
+		goto nfattr_failure;
+
+	err = ctnetlink_parse_tuple(tb, &tuple, CTA_EXPECT_TUPLE);
 	if (err < 0)
 		return err;
 
@@ -1498,7 +1501,7 @@
 		write_unlock_bh(&ip_conntrack_lock);
 		err = -ENOENT;
 		if (nlh->nlmsg_flags & NLM_F_CREATE)
-			err = ctnetlink_create_expect(cda);
+			err = ctnetlink_create_expect(tb, &master);
 		return err;
 	}
 
@@ -1510,6 +1513,9 @@
 	DEBUGP("leaving\n");
 	
 	return err;
+
+nfattr_failure:
+	return -1;
 }
 
 #ifdef CONFIG_IP_NF_CONNTRACK_EVENTS

--------------050103050002080203010401--
