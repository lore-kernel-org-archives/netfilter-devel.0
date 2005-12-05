From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6/8] fix racy conntrack mark
Date: Mon, 05 Dec 2005 12:21:10 +0100
Message-ID: <439422A6.3040604@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------090000030207010501040009"
Cc: Patrick McHardy <kaber@trash.net>
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
--------------090000030207010501040009
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris

--------------090000030207010501040009
Content-Type: text/plain;
 name="15.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="15.patch"

Set conntrack mark before it is in hashes.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Index: netfilter-2.6.14.git/net/ipv4/netfilter/ip_conntrack_netlink.c
===================================================================
--- netfilter-2.6.14.git.orig/net/ipv4/netfilter/ip_conntrack_netlink.c	2005-12-05 11:44:55.000000000 +0100
+++ netfilter-2.6.14.git/net/ipv4/netfilter/ip_conntrack_netlink.c	2005-12-05 11:45:12.000000000 +0100
@@ -1032,6 +1032,11 @@ ctnetlink_create_conntrack(struct nfattr
 			return err;
 	}
 
+#if defined(CONFIG_IP_NF_CONNTRACK_MARK)
+	if (cda[CTA_MARK-1])
+	ct->mark = ntohl(*(u_int32_t *)NFA_DATA(cda[CTA_MARK-1]));
+#endif
+
 	ct->helper = ip_conntrack_helper_find_get(rtuple);
 
 	add_timer(&ct->timeout);
@@ -1040,11 +1045,6 @@ ctnetlink_create_conntrack(struct nfattr
 	if (ct->helper)
 		ip_conntrack_helper_put(ct->helper);
 
-#if defined(CONFIG_IP_NF_CONNTRACK_MARK)
-	if (cda[CTA_MARK-1])
-		ct->mark = ntohl(*(u_int32_t *)NFA_DATA(cda[CTA_MARK-1]));
-#endif
-
 	DEBUGP("conntrack with id %u inserted\n", ct->id);
 	return 0;
 

--------------090000030207010501040009--
