From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 02/21] netfilter: nf_osf: add nf_osf_find()
Date: Sun,  5 Aug 2018 23:21:22 +0200
Message-ID: <20180805212141.3033-3-pablo@netfilter.org>
References: <20180805212141.3033-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180805212141.3033-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This new function returns the OS genre as a string. Plan is to use to
from the new nft_osf extension.

Note that this doesn't yet support ttl options, but it could be easily
extended to do so.

Tested-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/nf_osf.h |  9 +++++++++
 net/netfilter/nf_osf.c           | 30 ++++++++++++++++++++++++++++++
 2 files changed, 39 insertions(+)

diff --git a/include/linux/netfilter/nf_osf.h b/include/linux/netfilter/nf_osf.h
index 0e114c492fb8..aee460fcbd31 100644
--- a/include/linux/netfilter/nf_osf.h
+++ b/include/linux/netfilter/nf_osf.h
@@ -1,3 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _NFOSF_H
+#define _NFOSF_H
+
 #include <uapi/linux/netfilter/nf_osf.h>
 
 /* Initial window size option state machine: multiple of mss, mtu or
@@ -31,3 +35,8 @@ bool nf_osf_match(const struct sk_buff *skb, u_int8_t family,
 		  int hooknum, struct net_device *in, struct net_device *out,
 		  const struct nf_osf_info *info, struct net *net,
 		  const struct list_head *nf_osf_fingers);
+
+const char *nf_osf_find(const struct sk_buff *skb,
+                        const struct list_head *nf_osf_fingers);
+
+#endif /* _NFOSF_H */
diff --git a/net/netfilter/nf_osf.c b/net/netfilter/nf_osf.c
index b44d62d5d9a9..f4c75e982902 100644
--- a/net/netfilter/nf_osf.c
+++ b/net/netfilter/nf_osf.c
@@ -249,4 +249,34 @@ nf_osf_match(const struct sk_buff *skb, u_int8_t family,
 }
 EXPORT_SYMBOL_GPL(nf_osf_match);
 
+const char *nf_osf_find(const struct sk_buff *skb,
+			const struct list_head *nf_osf_fingers)
+{
+	const struct iphdr *ip = ip_hdr(skb);
+	const struct nf_osf_user_finger *f;
+	unsigned char opts[MAX_IPOPTLEN];
+	const struct nf_osf_finger *kf;
+	struct nf_osf_hdr_ctx ctx;
+	const struct tcphdr *tcp;
+	const char *genre = NULL;
+
+	memset(&ctx, 0, sizeof(ctx));
+
+	tcp = nf_osf_hdr_ctx_init(&ctx, skb, ip, opts);
+	if (!tcp)
+		return false;
+
+	list_for_each_entry_rcu(kf, &nf_osf_fingers[ctx.df], finger_entry) {
+		f = &kf->finger;
+		if (!nf_osf_match_one(skb, f, -1, &ctx))
+			continue;
+
+		genre = f->genre;
+		break;
+	}
+
+	return genre;
+}
+EXPORT_SYMBOL_GPL(nf_osf_find);
+
 MODULE_LICENSE("GPL");
-- 
2.11.0
