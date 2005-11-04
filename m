From: Pablo Neira <pablo@netfilter.org>
Subject: [PATCH 7/7] fix wrong allocation flag
Date: Fri, 04 Nov 2005 19:00:47 +0100
Message-ID: <436BA1CF.6020907@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------060706070701000404000805"
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
--------------060706070701000404000805
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

ctnetlink_get_conntrack is always called from user context, so
GFP_KERNEL is enough.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris

--------------060706070701000404000805
Content-Type: text/plain;
 name="10-allocation.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="10-allocation.patch"

ctnetlink_get_conntrack is always called from user context, so GFP_KERNEL
is enough.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Index: net-2.6.git/net/ipv4/netfilter/ip_conntrack_netlink.c
===================================================================
--- net-2.6.git.orig/net/ipv4/netfilter/ip_conntrack_netlink.c	2005-11-04 18:16:26.000000000 +0100
+++ net-2.6.git/net/ipv4/netfilter/ip_conntrack_netlink.c	2005-11-04 18:17:39.000000000 +0100
@@ -779,7 +779,7 @@ ctnetlink_get_conntrack(struct sock *ctn
 	ct = tuplehash_to_ctrack(h);
 
 	err = -ENOMEM;
-	skb2 = alloc_skb(NLMSG_GOODSIZE, GFP_ATOMIC);
+	skb2 = alloc_skb(NLMSG_GOODSIZE, GFP_KERNEL);
 	if (!skb2) {
 		ip_conntrack_put(ct);
 		return -ENOMEM;

--------------060706070701000404000805--
