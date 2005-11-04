From: Pablo Neira <pablo@netfilter.org>
Subject: [PATCH 3/7] Add conntrack marking support from userspace
Date: Fri, 04 Nov 2005 19:00:28 +0100
Message-ID: <436BA1BC.8090100@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------040108090902040500050706"
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
--------------040108090902040500050706
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

This patch adds support for conntrack marking from user space.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris

--------------040108090902040500050706
Content-Type: text/plain;
 name="06-set-mark.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="06-set-mark.patch"

This patch adds support for conntrack marking from user space.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Index: net-2.6.git/net/ipv4/netfilter/ip_conntrack_netlink.c
===================================================================
--- net-2.6.git.orig/net/ipv4/netfilter/ip_conntrack_netlink.c	2005-11-04 17:45:21.000000000 +0100
+++ net-2.6.git/net/ipv4/netfilter/ip_conntrack_netlink.c	2005-11-04 18:31:06.000000000 +0100
@@ -979,6 +979,11 @@ ctnetlink_change_conntrack(struct ip_con
 			return err;
 	}
 
+#if defined(CONFIG_IP_NF_CONNTRACK_MARK)
+	if (cda[CTA_MARK-1])
+		ct->mark = ntohl(*(u_int32_t *)NFA_DATA(cda[CTA_MARK-1]));
+#endif
+
 	DEBUGP("all done\n");
 	return 0;
 }
@@ -1022,6 +1027,11 @@ ctnetlink_create_conntrack(struct nfattr
 	if (ct->helper)
 		ip_conntrack_helper_put(ct->helper);
 
+#if defined(CONFIG_IP_NF_CONNTRACK_MARK)
+	if (cda[CTA_MARK-1])
+		ct->mark = ntohl(*(u_int32_t *)NFA_DATA(cda[CTA_MARK-1]));
+#endif
+
 	DEBUGP("conntrack with id %u inserted\n", ct->id);
 	return 0;
 

--------------040108090902040500050706--
