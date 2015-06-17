From: Daniel Mack <daniel@zonque.org>
Subject: [PATCH nf-next 3/3] netfilter: nft_meta: fix cgroup socket lookups
Date: Wed, 17 Jun 2015 02:08:12 +0200
Message-ID: <1434499692-9832-4-git-send-email-daniel@zonque.org>
References: <1434499692-9832-1-git-send-email-daniel@zonque.org>
Cc: fw@strlen.de, daniel@iogearbox.net, a.perevalov@samsung.com,
	netfilter-devel@vger.kernel.org, Daniel Mack <daniel@zonque.org>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from svenfoo.org ([82.94.215.22]:39582 "EHLO mail.zonque.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751819AbbFQARc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Jun 2015 20:17:32 -0400
In-Reply-To: <1434499692-9832-1-git-send-email-daniel@zonque.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The cgroup matching logic in nft_meta currently bails out early
if skb->sk == NULL, ie, when the check is run on a socket that has
not yet been looked up by early demux.

To fix this, use the socket lookup helpers to determine the receiver
socket in such cases.

Signed-off-by: Daniel Mack <daniel@zonque.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Alexey Perevalov <a.perevalov@samsung.com>
Cc: Florian Westphal <fw@strlen.de>
---
 net/netfilter/Kconfig    |  2 ++
 net/netfilter/nft_meta.c | 35 ++++++++++++++++++++++++++++++++---
 2 files changed, 34 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 11c7e37..2d3294c 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -475,6 +475,8 @@ config NFT_EXTHDR
 
 config NFT_META
 	tristate "Netfilter nf_tables meta module"
+	select NF_SOCK_IPV4
+	select NF_SOCK_IPV6 if IP6_NF_IPTABLES
 	help
 	  This option adds the "meta" expression that you can use to match and
 	  to set packet metainformation such as the packet mark.
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 52561e1..ecc3de8 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -13,6 +13,8 @@
 #include <linux/module.h>
 #include <linux/netlink.h>
 #include <linux/netfilter.h>
+#include <linux/netfilter_ipv4.h>
+#include <linux/netfilter_ipv6.h>
 #include <linux/netfilter/nf_tables.h>
 #include <linux/in.h>
 #include <linux/ip.h>
@@ -166,11 +168,38 @@ void nft_meta_get_eval(const struct nft_expr *expr,
 			goto err;
 		*dest = out->group;
 		break;
-	case NFT_META_CGROUP:
-		if (skb->sk == NULL || !sk_fullsock(skb->sk))
+	case NFT_META_CGROUP: {
+		struct sock *sk;
+
+		if (skb->sk && sk_fullsock(skb->sk)) {
+			*dest = skb->sk->sk_classid;
+			break;
+		}
+
+		if (!in)
 			goto err;
-		*dest = skb->sk->sk_classid;
+
+		switch (pkt->ops->pf) {
+		case NFPROTO_IPV4:
+			sk = nf_socket_lookup_v4(skb, in);
+			break;
+		case NFPROTO_IPV6:
+			sk = nf_socket_lookup_v6(skb, in);
+			break;
+		default:
+			goto err;
+		}
+
+		if (!sk)
+			goto err;
+
+		*dest = sk->sk_classid;
+
+		if (!sk_fullsock(sk))
+			sock_gen_put(sk);
+
 		break;
+	}
 	default:
 		WARN_ON(1);
 		goto err;
-- 
2.4.0

