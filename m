From: Pablo Neira <pablo@netfilter.org>
Subject: [PATCH 3/8] Identify expect by its ID
Date: Tue, 08 Nov 2005 02:44:27 +0100
Message-ID: <437002FB.4030407@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------040503070108080306010707"
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
--------------040503070108080306010707
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Add support to identify expectations by ID's at getting.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris

--------------040503070108080306010707
Content-Type: text/plain;
 name="02-expect-id.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="02-expect-id.patch"

Add support to identify expectations by ID's at getting.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Index: netfilter-2.6.14.git/net/ipv4/netfilter/ip_conntrack_netlink.c
===================================================================
--- netfilter-2.6.14.git.orig/net/ipv4/netfilter/ip_conntrack_netlink.c	2005-11-06 19:29:49.000000000 +0100
+++ netfilter-2.6.14.git/net/ipv4/netfilter/ip_conntrack_netlink.c	2005-11-06 19:49:37.000000000 +0100
@@ -1299,6 +1299,14 @@ ctnetlink_get_expect(struct sock *ctnl, 
 	if (!exp)
 		return -ENOENT;
 
+	if (cda[CTA_EXPECT_ID-1]) {
+		u_int32_t id = *(u_int32_t *)NFA_DATA(cda[CTA_EXPECT_ID-1]);
+		if (exp->id != ntohl(id)) {
+			ip_conntrack_expect_put(exp);
+			return -ENOENT;
+		}
+	}	
+
 	err = -ENOMEM;
 	skb2 = alloc_skb(NLMSG_GOODSIZE, GFP_KERNEL);
 	if (!skb2)

--------------040503070108080306010707--
