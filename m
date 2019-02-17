From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 11/11] netfilter: nf_conntrack_sip: add sip_external_media logic
Date: Mon, 18 Feb 2019 00:23:57 +0100
Message-ID: <20190217232357.29858-12-pablo@netfilter.org>
References: <20190217232357.29858-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190217232357.29858-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Alin Nastac <alin.nastac@gmail.com>

When enabled, the sip_external_media logic will leave SDP
payload untouched when it detects that interface towards INVITEd
party is the same with the one towards media endpoint.

The typical scenario for this logic is when a LAN SIP agent has more
than one IP address (uses a different address for media streams than
the one used on signalling stream) and it also forwards calls to a
voice mailbox located on the WAN side. In such case sip_direct_media
must be disabled (so normal calls could be handled by the SIP
helper), but media streams that are not traversing this router must
also be excluded from address translation (e.g. call forwards).

Signed-off-by: Alin Nastac <alin.nastac@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_sip.c | 42 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index c8d2b6688a2a..f067c6b50857 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -21,6 +21,8 @@
 #include <linux/tcp.h>
 #include <linux/netfilter.h>
 
+#include <net/route.h>
+#include <net/ip6_route.h>
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_core.h>
 #include <net/netfilter/nf_conntrack_expect.h>
@@ -54,6 +56,11 @@ module_param(sip_direct_media, int, 0600);
 MODULE_PARM_DESC(sip_direct_media, "Expect Media streams between signalling "
 				   "endpoints only (default 1)");
 
+static int sip_external_media __read_mostly = 0;
+module_param(sip_external_media, int, 0600);
+MODULE_PARM_DESC(sip_external_media, "Expect Media streams between external "
+				     "endpoints (default 0)");
+
 const struct nf_nat_sip_hooks *nf_nat_sip_hooks;
 EXPORT_SYMBOL_GPL(nf_nat_sip_hooks);
 
@@ -861,6 +868,41 @@ static int set_expected_rtp_rtcp(struct sk_buff *skb, unsigned int protoff,
 		if (!nf_inet_addr_cmp(daddr, &ct->tuplehash[dir].tuple.src.u3))
 			return NF_ACCEPT;
 		saddr = &ct->tuplehash[!dir].tuple.src.u3;
+	} else if (sip_external_media) {
+		struct net_device *dev = skb_dst(skb)->dev;
+		struct net *net = dev_net(dev);
+		struct rtable *rt;
+		struct flowi4 fl4 = {};
+#if IS_ENABLED(CONFIG_IPV6)
+		struct flowi6 fl6 = {};
+#endif
+		struct dst_entry *dst = NULL;
+
+		switch (nf_ct_l3num(ct)) {
+			case NFPROTO_IPV4:
+				fl4.daddr = daddr->ip;
+				rt = ip_route_output_key(net, &fl4);
+				if (!IS_ERR(rt))
+					dst = &rt->dst;
+				break;
+
+#if IS_ENABLED(CONFIG_IPV6)
+			case NFPROTO_IPV6:
+				fl6.daddr = daddr->in6;
+				dst = ip6_route_output(net, NULL, &fl6);
+				if (dst->error) {
+					dst_release(dst);
+					dst = NULL;
+				}
+				break;
+#endif
+		}
+
+		/* Don't predict any conntracks when media endpoint is reachable
+		 * through the same interface as the signalling peer.
+		 */
+		if (dst && dst->dev == dev)
+			return NF_ACCEPT;
 	}
 
 	/* We need to check whether the registration exists before attempting
-- 
2.11.0
