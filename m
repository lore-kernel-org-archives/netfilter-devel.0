From: Pablo Neira <pablo@netfilter.org>
Subject: [PATCH 2/8] Propagate error to userspace at getting
Date: Tue, 08 Nov 2005 02:44:22 +0100
Message-ID: <437002F6.9070809@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------080105070506070003090009"
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
--------------080105070506070003090009
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Propagate the error to userspace instead of returning -EPERM if the get
conntrack operation fails.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris

--------------080105070506070003090009
Content-Type: text/plain;
 name="01-return-val.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="01-return-val.patch"

Propagate the error to userspace instead of returning -EPERM if the get 
conntrack operation fails.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Index: netfilter-2.6.14.git/net/ipv4/netfilter/ip_conntrack_netlink.c
===================================================================
--- netfilter-2.6.14.git.orig/net/ipv4/netfilter/ip_conntrack_netlink.c	2005-11-06 19:03:46.000000000 +0100
+++ netfilter-2.6.14.git/net/ipv4/netfilter/ip_conntrack_netlink.c	2005-11-06 19:03:48.000000000 +0100
@@ -808,7 +808,7 @@ ctnetlink_get_conntrack(struct sock *ctn
 free:
 	kfree_skb(skb2);
 out:
-	return -1;
+	return err;
 }
 
 static inline int

--------------080105070506070003090009--
