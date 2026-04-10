Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B0EF39EF0E;
	Fri, 10 Apr 2026 11:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775820287; cv=none; b=VVYoye3wOoiBYZTRIvOsIbdgp8rh1JTDFxpu1OIDOE2XV4efaZtHlpFrk4/N6ukpiIYF6JdkdrLg0KvpTmSf0gtP0bT5Y3aTqaSC5QMBjZM7cbRfc39N3hmqMLR8p5sGWvYUFQaqylRGYnAOQqKnkeucLC72n4jggEwiFvzvRB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775820287; c=relaxed/simple;
	bh=l8eqKPw4VBFkae+sqDnJAoR0w1YLMWEY7HtRpB6fItI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TuxHYTAiAgPO2JwNwqSP1XXeA5zMpesmifTixjGCAj/zD/cHh3iGaht28DCYs8IwXUJnBWL2Ncke7ySvureGi1atmpThrGVRStN6xoJMIXxL3abeE+qmv+iEsO7iJayV8RtJVCDbIDytSY64i/ZgixVcgpRLJkk/FayLr8pTRjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id D50CC60C9C; Fri, 10 Apr 2026 13:24:43 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net-next 11/11] netfilter: require Ethernet MAC header before using eth_hdr()
Date: Fri, 10 Apr 2026 13:23:52 +0200
Message-ID: <20260410112352.23599-12-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260410112352.23599-1-fw@strlen.de>
References: <20260410112352.23599-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zhengchuan Liang <zcliangcn@gmail.com>

`ip6t_eui64`, `xt_mac`, the `bitmap:ip,mac`, `hash:ip,mac`, and
`hash:mac` ipset types, and `nf_log_syslog` access `eth_hdr(skb)`
after either assuming that the skb is associated with an Ethernet
device or checking only that the `ETH_HLEN` bytes at
`skb_mac_header(skb)` lie between `skb->head` and `skb->data`.

Make these paths first verify that the skb is associated with an
Ethernet device, that the MAC header was set, and that it spans at
least a full Ethernet header before accessing `eth_hdr(skb)`.

Suggested-by: Florian Westphal <fw@strlen.de>
Tested-by: Ren Wei <enjou1224z@gmail.com>
Signed-off-by: Zhengchuan Liang <zcliangcn@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/ipv6/netfilter/ip6t_eui64.c           | 7 +++++--
 net/netfilter/ipset/ip_set_bitmap_ipmac.c | 5 +++--
 net/netfilter/ipset/ip_set_hash_ipmac.c   | 9 +++++----
 net/netfilter/ipset/ip_set_hash_mac.c     | 5 +++--
 net/netfilter/nf_log_syslog.c             | 8 +++++++-
 net/netfilter/xt_mac.c                    | 4 +---
 6 files changed, 24 insertions(+), 14 deletions(-)

diff --git a/net/ipv6/netfilter/ip6t_eui64.c b/net/ipv6/netfilter/ip6t_eui64.c
index da69a27e8332..bbb684f9964c 100644
--- a/net/ipv6/netfilter/ip6t_eui64.c
+++ b/net/ipv6/netfilter/ip6t_eui64.c
@@ -7,6 +7,7 @@
 #include <linux/module.h>
 #include <linux/skbuff.h>
 #include <linux/ipv6.h>
+#include <linux/if_arp.h>
 #include <linux/if_ether.h>
 
 #include <linux/netfilter/x_tables.h>
@@ -21,8 +22,10 @@ eui64_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	unsigned char eui64[8];
 
-	if (!(skb_mac_header(skb) >= skb->head &&
-	      skb_mac_header(skb) + ETH_HLEN <= skb->data)) {
+	if (!skb->dev || skb->dev->type != ARPHRD_ETHER)
+		return false;
+
+	if (!skb_mac_header_was_set(skb) || skb_mac_header_len(skb) < ETH_HLEN) {
 		par->hotdrop = true;
 		return false;
 	}
diff --git a/net/netfilter/ipset/ip_set_bitmap_ipmac.c b/net/netfilter/ipset/ip_set_bitmap_ipmac.c
index 2c625e0f49ec..752f59ef8744 100644
--- a/net/netfilter/ipset/ip_set_bitmap_ipmac.c
+++ b/net/netfilter/ipset/ip_set_bitmap_ipmac.c
@@ -11,6 +11,7 @@
 #include <linux/etherdevice.h>
 #include <linux/skbuff.h>
 #include <linux/errno.h>
+#include <linux/if_arp.h>
 #include <linux/if_ether.h>
 #include <linux/netlink.h>
 #include <linux/jiffies.h>
@@ -220,8 +221,8 @@ bitmap_ipmac_kadt(struct ip_set *set, const struct sk_buff *skb,
 		return -IPSET_ERR_BITMAP_RANGE;
 
 	/* Backward compatibility: we don't check the second flag */
-	if (skb_mac_header(skb) < skb->head ||
-	    (skb_mac_header(skb) + ETH_HLEN) > skb->data)
+	if (!skb->dev || skb->dev->type != ARPHRD_ETHER ||
+	    !skb_mac_header_was_set(skb) || skb_mac_header_len(skb) < ETH_HLEN)
 		return -EINVAL;
 
 	e.id = ip_to_id(map, ip);
diff --git a/net/netfilter/ipset/ip_set_hash_ipmac.c b/net/netfilter/ipset/ip_set_hash_ipmac.c
index 467c59a83c0a..b9a2681e2488 100644
--- a/net/netfilter/ipset/ip_set_hash_ipmac.c
+++ b/net/netfilter/ipset/ip_set_hash_ipmac.c
@@ -11,6 +11,7 @@
 #include <linux/skbuff.h>
 #include <linux/errno.h>
 #include <linux/random.h>
+#include <linux/if_arp.h>
 #include <linux/if_ether.h>
 #include <net/ip.h>
 #include <net/ipv6.h>
@@ -89,8 +90,8 @@ hash_ipmac4_kadt(struct ip_set *set, const struct sk_buff *skb,
 	struct hash_ipmac4_elem e = { .ip = 0, { .foo[0] = 0, .foo[1] = 0 } };
 	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, set);
 
-	if (skb_mac_header(skb) < skb->head ||
-	    (skb_mac_header(skb) + ETH_HLEN) > skb->data)
+	if (!skb->dev || skb->dev->type != ARPHRD_ETHER ||
+	    !skb_mac_header_was_set(skb) || skb_mac_header_len(skb) < ETH_HLEN)
 		return -EINVAL;
 
 	if (opt->flags & IPSET_DIM_TWO_SRC)
@@ -205,8 +206,8 @@ hash_ipmac6_kadt(struct ip_set *set, const struct sk_buff *skb,
 	};
 	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, set);
 
-	if (skb_mac_header(skb) < skb->head ||
-	    (skb_mac_header(skb) + ETH_HLEN) > skb->data)
+	if (!skb->dev || skb->dev->type != ARPHRD_ETHER ||
+	    !skb_mac_header_was_set(skb) || skb_mac_header_len(skb) < ETH_HLEN)
 		return -EINVAL;
 
 	if (opt->flags & IPSET_DIM_TWO_SRC)
diff --git a/net/netfilter/ipset/ip_set_hash_mac.c b/net/netfilter/ipset/ip_set_hash_mac.c
index 718814730acf..41a122591fe2 100644
--- a/net/netfilter/ipset/ip_set_hash_mac.c
+++ b/net/netfilter/ipset/ip_set_hash_mac.c
@@ -8,6 +8,7 @@
 #include <linux/etherdevice.h>
 #include <linux/skbuff.h>
 #include <linux/errno.h>
+#include <linux/if_arp.h>
 #include <linux/if_ether.h>
 #include <net/netlink.h>
 
@@ -77,8 +78,8 @@ hash_mac4_kadt(struct ip_set *set, const struct sk_buff *skb,
 	struct hash_mac4_elem e = { { .foo[0] = 0, .foo[1] = 0 } };
 	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, set);
 
-	if (skb_mac_header(skb) < skb->head ||
-	    (skb_mac_header(skb) + ETH_HLEN) > skb->data)
+	if (!skb->dev || skb->dev->type != ARPHRD_ETHER ||
+	    !skb_mac_header_was_set(skb) || skb_mac_header_len(skb) < ETH_HLEN)
 		return -EINVAL;
 
 	if (opt->flags & IPSET_DIM_ONE_SRC)
diff --git a/net/netfilter/nf_log_syslog.c b/net/netfilter/nf_log_syslog.c
index 0507d67cad27..7a8952b049d1 100644
--- a/net/netfilter/nf_log_syslog.c
+++ b/net/netfilter/nf_log_syslog.c
@@ -78,7 +78,10 @@ dump_arp_packet(struct nf_log_buf *m,
 	else
 		logflags = NF_LOG_DEFAULT_MASK;
 
-	if (logflags & NF_LOG_MACDECODE) {
+	if ((logflags & NF_LOG_MACDECODE) &&
+	    skb->dev && skb->dev->type == ARPHRD_ETHER &&
+	    skb_mac_header_was_set(skb) &&
+	    skb_mac_header_len(skb) >= ETH_HLEN) {
 		nf_log_buf_add(m, "MACSRC=%pM MACDST=%pM ",
 			       eth_hdr(skb)->h_source, eth_hdr(skb)->h_dest);
 		nf_log_dump_vlan(m, skb);
@@ -797,6 +800,9 @@ static void dump_mac_header(struct nf_log_buf *m,
 
 	switch (dev->type) {
 	case ARPHRD_ETHER:
+		if (!skb_mac_header_was_set(skb) || skb_mac_header_len(skb) < ETH_HLEN)
+			return;
+
 		nf_log_buf_add(m, "MACSRC=%pM MACDST=%pM ",
 			       eth_hdr(skb)->h_source, eth_hdr(skb)->h_dest);
 		nf_log_dump_vlan(m, skb);
diff --git a/net/netfilter/xt_mac.c b/net/netfilter/xt_mac.c
index 81649da57ba5..4798cd2ca26e 100644
--- a/net/netfilter/xt_mac.c
+++ b/net/netfilter/xt_mac.c
@@ -29,9 +29,7 @@ static bool mac_mt(const struct sk_buff *skb, struct xt_action_param *par)
 
 	if (skb->dev == NULL || skb->dev->type != ARPHRD_ETHER)
 		return false;
-	if (skb_mac_header(skb) < skb->head)
-		return false;
-	if (skb_mac_header(skb) + ETH_HLEN > skb->data)
+	if (!skb_mac_header_was_set(skb) || skb_mac_header_len(skb) < ETH_HLEN)
 		return false;
 	ret  = ether_addr_equal(eth_hdr(skb)->h_source, info->srcaddr);
 	ret ^= info->invert;
-- 
2.52.0

