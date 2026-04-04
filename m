Received: from azure-sdnproxy.icoremail.net (azure-sdnproxy.icoremail.net [52.229.168.213])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A84EA3A7F52;
	Sat,  4 Apr 2026 09:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.229.168.213
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775295653; cv=none; b=NtC6nRFUr/Xxf9/HCO0wo860T0Qjieusv4IzA/kaxzZkItk8z96zCmweVDjeXZ+X8epBHtJDl5KvUmEvr3d3JhkBnxG+Fr1SEDdqG1+NQjJ+NF8QA5rx6aSROpmWo5BjXPkf3SQMuso3PDL8AIBcn5GOLC2bgbD60sDufEjPT0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775295653; c=relaxed/simple;
	bh=OwPt9XHHkjnSsh68AOZSdcby1t48S2XGm/KMVKt3zlE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P3exEs52xNs1SMmvENl58idW3VQJ3XmWLxedsUz38KOrodaECOFfcRGtzh/AtIeRank/uGapctBP/2RvkwcKxvVzob8pBKgT+gQMGLtLA36+M+J2ikZkaoiPJo6+uouoTF+/w3JdCBC/b3udLwK5Mi/C9R/Ihoo21sgCogPklvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lzu.edu.cn; spf=pass smtp.mailfrom=lzu.edu.cn; arc=none smtp.client-ip=52.229.168.213
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lzu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lzu.edu.cn
Received: from enjou-Legion-Y7000P-2019.coin-barley.ts.net (unknown [172.23.56.36])
	by app1 (Coremail) with SMTP id ygmowADnXwB93NBps2+lAA--.38592S3;
	Sat, 04 Apr 2026 17:40:25 +0800 (CST)
From: Ren Wei <n05ec@lzu.edu.cn>
To: netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	davem@davemloft.net,
	dsahern@kernel.org,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	yifanwucs@gmail.com,
	tomapufckgml@gmail.com,
	yuantan098@gmail.com,
	bird@lzu.edu.cn,
	enjou1224z@gmail.com,
	zcliangcn@gmail.com,
	n05ec@lzu.edu.cn
Subject: [PATCH nf v2 2/2] netfilter: require Ethernet MAC header before using eth_hdr()
Date: Sat,  4 Apr 2026 17:39:48 +0800
Message-ID: <8a97a5560b3bcede951dbd1214e126754dc55cb4.1775260446.git.zcliangcn@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1774859629.git.zcliangcn@gmail.com>
References: <cover.1774859629.git.zcliangcn@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:ygmowADnXwB93NBps2+lAA--.38592S3
X-Coremail-Antispam: 1UD129KBjvJXoW3XryftF1DZryxKr1fGF18Grg_yoWxtF15pa
	1DCa4rJrs3Jr43Gr18Ca1xZr45Jw4kAF4S934Yy3sYv3WqgrZ5tay0kr4ag3W8XrZYgrsx
	W3Wjvw4ruws8XrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBY1xkIjI8I6I8E6xAIw20EY4v20xvaj40_JFC_Wr1l1IIY67AE
	w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
	IY67AKxVW8JVW5JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVWxJVW8Jr1l84ACjcxK6I8E
	87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcV
	Aq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j
	6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64
	vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0E
	n4kS14v26r4a6rW5MxkIecxEwVCm-wCF04k20xvY0x0EwIxGrwCF04k20xvE74AGY7Cv6c
	x26r48MxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCj
	r7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVW8ZVWrXwCIc40Y0x0EwIxGrwCI42IY6x
	IIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAI
	w20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x
	0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7sRi_HU3UUUUU==
X-CM-SenderInfo: zqqvvuo6o23hxhgxhubq/1tbiAQQHCWnP4nwFrAAAsa

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
---
Changes in v2:
This patch addresses suspicious `eth_hdr(skb)` users by requiring an
Ethernet device together with a valid MAC header before accessing it.

 net/ipv6/netfilter/ip6t_eui64.c           | 7 +++++--
 net/netfilter/ipset/ip_set_bitmap_ipmac.c | 5 +++--
 net/netfilter/ipset/ip_set_hash_ipmac.c   | 9 +++++----
 net/netfilter/ipset/ip_set_hash_mac.c     | 5 +++--
 net/netfilter/nf_log_syslog.c             | 7 ++++++-
 net/netfilter/xt_mac.c                    | 4 +---
 6 files changed, 23 insertions(+), 14 deletions(-)

diff --git a/net/ipv6/netfilter/ip6t_eui64.c b/net/ipv6/netfilter/ip6t_eui64.c
index da69a27e8332c..bbb684f9964c0 100644
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
index 2c625e0f49ec0..752f59ef87442 100644
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
index 467c59a83c0ab..b9a2681e24888 100644
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
index 718814730acf6..41a122591fe24 100644
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
index 41503847d9d7f..f62049d429653 100644
--- a/net/netfilter/nf_log_syslog.c
+++ b/net/netfilter/nf_log_syslog.c
@@ -78,7 +78,9 @@ dump_arp_packet(struct nf_log_buf *m,
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
@@ -789,6 +791,9 @@ static void dump_mac_header(struct nf_log_buf *m,
 
 	switch (dev->type) {
 	case ARPHRD_ETHER:
+		if (!skb_mac_header_was_set(skb) || skb_mac_header_len(skb) < ETH_HLEN)
+			return;
+
 		nf_log_buf_add(m, "MACSRC=%pM MACDST=%pM ",
 			       eth_hdr(skb)->h_source, eth_hdr(skb)->h_dest);
 		nf_log_dump_vlan(m, skb);
diff --git a/net/netfilter/xt_mac.c b/net/netfilter/xt_mac.c
index 81649da57ba5d..4798cd2ca26ed 100644
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
2.43.0

