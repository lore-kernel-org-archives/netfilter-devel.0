From: Pablo Neira <pablo@eurodev.net>
Subject: [PATCH 3/7] Fix warnings when debug mode is on
Date: Mon, 01 Aug 2005 19:05:03 +0200
Message-ID: <42EE563F.9000607@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------030606000000050205040506"
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
--------------030606000000050205040506
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Fix some warnings when DEBUGP is set.

--------------030606000000050205040506
Content-Type: text/x-patch;
 name="02debug-warning.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="02debug-warning.patch"

Index: netfilter-2.6.14/net/ipv4/netfilter/ip_conntrack_netlink.c
===================================================================
--- netfilter-2.6.14.orig/net/ipv4/netfilter/ip_conntrack_netlink.c	2005-08-01 16:25:00.000000000 +0200
+++ netfilter-2.6.14/net/ipv4/netfilter/ip_conntrack_netlink.c	2005-08-01 16:25:04.000000000 +0200
@@ -436,7 +436,7 @@
 	struct list_head *i;
 	u_int32_t *id = (u_int32_t *) &cb->args[1];
 
-	DEBUGP("entered %s, last bucket=%u id=%u\n", __FUNCTION__, 
+	DEBUGP("entered %s, last bucket=%lu id=%u\n", __FUNCTION__, 
 			cb->args[0], *id);
 
 	write_lock_bh(&ip_conntrack_lock);
@@ -1207,7 +1207,7 @@
 	struct list_head *i;
 	u_int32_t *id = (u_int32_t *) &cb->args[0];
 
-	DEBUGP("entered %s, last id=%llu\n", __FUNCTION__, *id);
+	DEBUGP("entered %s, last id=%u\n", __FUNCTION__, *id);
 
 	read_lock_bh(&ip_conntrack_lock);
 	list_for_each(i, &ip_conntrack_expect_list) {
@@ -1224,7 +1224,7 @@
 out:	
 	read_unlock_bh(&ip_conntrack_lock);
 
-	DEBUGP("leaving, last id=%llu\n", *id);
+	DEBUGP("leaving, last id=%u\n", *id);
 
 	return skb->len;
 }

--------------030606000000050205040506--
