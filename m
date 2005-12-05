From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4/8] use is u_int32_t not unsigned int
Date: Mon, 05 Dec 2005 12:21:05 +0100
Message-ID: <439422A1.2090307@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------090306050200070802020205"
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
--------------090306050200070802020205
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris

--------------090306050200070802020205
Content-Type: text/plain;
 name="13.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="13.patch"

Use u_int32_t instead of unsigned int.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Index: netfilter-2.6.14.git/net/ipv4/netfilter/ip_conntrack_netlink.c
===================================================================
--- netfilter-2.6.14.git.orig/net/ipv4/netfilter/ip_conntrack_netlink.c	2005-12-04 03:44:27.000000000 +0100
+++ netfilter-2.6.14.git/net/ipv4/netfilter/ip_conntrack_netlink.c	2005-12-04 03:51:56.000000000 +0100
@@ -229,7 +229,7 @@ nfattr_failure:
 static inline int
 ctnetlink_dump_use(struct sk_buff *skb, const struct ip_conntrack *ct)
 {
-	unsigned int use = htonl(atomic_read(&ct->ct_general.use));
+	u_int32_t use = htonl(atomic_read(&ct->ct_general.use));
 	
 	NFA_PUT(skb, CTA_USE, sizeof(u_int32_t), &use);
 	return 0;

--------------090306050200070802020205--
