Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795003079;
	b=W4lcKljGEK8kk/6+VhU6PTOIMTopvcH/xVxH0j87DCSsYSzI/qmf+1RG64oHmmGPd0oV
	 x+seyFZvTQ/gqgqZ6Sjdmtq2XLnqfwKkl9xMUO/yrxNk0YaPwnCm97bIiz5coBIf4AkTA
	 Z8DqF4aGIb6VIWdyLvzzw/dntB90GZtfGz/a44tRuggk3PQm58bHKmAv1Ka41H6TqGguI
	 Jv8+joTAz/zO75zWPyLo2wC6bgrMuxLE/ULrNW4qGXOKObhj/ueS3JjP043aT5kzbyjfF
	 ZBoVIxW9yms9B0Vqy+6HM1tmMzeSbWAwYEtEOf3lF/GPtBJWN5Q0JDucjfUYh5oB1PA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795003079;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=PboycpyJSQVKX1Ua3mPKeblcIjJVkPl2+Y+HGZGFVH4=;
	b=uY+2r/UF06RWPNjE80VoLxlsWEaIAMhZx12bnBZjIuTPXNaCD1viDg96FCf9CTZXx93z
	 J/u3oN1noO9AdQUlzKlK3xHt2BrCyaSBezDpTb0/YBqpO+tWgjh1Z6Gsm/PF9/OJiYl06
	 3zT6NNiBdbobSP8QVL+mv9GAE+BhKIi0aEKQ4YgEtWau8d8vRxLnYtrIEOymW43Fh7ZSz
	 ldA63VYyjQoZYD2ZwWv3LRp2SBISnZKCm3GlRHO2Ft/OomTgd5r+GEHzD5PwCeV7MSuFf
	 kXxoIzoJTpaEW+WfI+no2eR6F2HH8VVx61ICktfAA4b4N+DiC5zvgxmlP/a/nEJnnKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7222606A32C
	for <netfilter-devel@vger.kernel.org>; Wed, 18 Nov 2026 11:57:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E7222606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id EEC8960633; Wed, 18 Nov 2026 12:57:56 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v2 3/6] netfilter: nfnetlink_log: fix up dev_parse_header usage
Date: Wed, 18 Nov 2026 12:57:29 +0100
Message-ID: <20261118115732.9529-4-fw@strlen.de>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261118115732.9529-1-fw@strlen.de>
References: <20261118115732.9529-1-fw@strlen.de>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

dev_parse_header() grabs the source hw address from the skb and stores
it in the given buffer.

e.g.: eth_header_parse() is a simple:

int eth_header_parse(const struct sk_buff *skb,
		     const struct net_device *dev, unsigned char *haddr) {
	memcpy(haddr, eth_hdr(skb)->h_source, ETH_ALEN);
	return ETH_ALEN;
}

Problem is that the compound structure used by the UABI in nfnetlink_log
and nfnetlink_queue has a fixed 8-byte size.

Enough for ETH_ALEN, but not necessarily enough for other address types.
Move this to a helper and allow sharing it between the copypasted users.

The struct layout of the two container structures have same layout:
add BUILD_BUG_ON checks to assert this.

Due to the nature of the dev_parse_header() helpers:

1. skb MUST have a valid mac header, else we read garbage
2. users MUST NOT use this when ingress device and skb->dev
have diverged (we can't know we would decode something
meaningful anymore).
3. Because container structure only has space for 8 octets,
   we have to clamp the result.

Do all of this in the common helper.

The helper also rejects skbs whose network header ended up below the
mac header: encapsulation (ip_encap(), xfrm) can do this and the
unsigned skb_mac_header_len() would then wrap to a huge value,
bypassing the sanity checks.  The mac header must also span the
device's full hard_header_len, not just min_header_len:
header_ops->parse() implementations read fixed offsets sized for the
complete header format (ipgre leaves min_header_len at 0 but
ipgre_header_parse() reads offset 12..15 of the mac header).

This is an LLM finding, no bug was ever reported about this.

Fixes: 0597f2680d66 ("[NETFILTER]: Add new "nfnetlink_log" userspace packet logging facility")
Fixes: 7af4cc3fa158 ("[NETFILTER]: Add "nfnetlink_queue" netfilter queue handler over nfnetlink")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 v2: more paranoia checks that AI insists are needed
 (ip_encap, ipgre, ...)

 net/netfilter/nfnetlink_log.c        |  18 +----
 net/netfilter/nfnetlink_log_common.h | 117 +++++++++++++++++++++++++++
 net/netfilter/nfnetlink_queue.c      |  18 +----
 3 files changed, 125 insertions(+), 28 deletions(-)
 create mode 100644 net/netfilter/nfnetlink_log_common.h

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index 90e87c34df85..37f3e7b6b538 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -47,6 +47,8 @@
 #include <net/netfilter/nf_conntrack.h>
 #endif
 
+#include "nfnetlink_log_common.h"
+
 #define NFULNL_COPY_DISABLED	0xff
 #define NFULNL_NLBUFSIZ_DEFAULT	NLMSG_GOODSIZE
 #define NFULNL_TIMEOUT_DEFAULT 	100	/* every second */
@@ -587,20 +589,8 @@ __build_packet_message(struct nfnl_log_net *log,
 	    nla_put_be32(inst->skb, NFULA_MARK, htonl(skb->mark)))
 		goto nla_put_failure;
 
-	if (indev && skb->dev &&
-	    skb_mac_header_was_set(skb) &&
-	    skb_mac_header_len(skb) != 0) {
-		struct nfulnl_msg_packet_hw phw;
-		int len;
-
-		memset(&phw, 0, sizeof(phw));
-		len = dev_parse_header(skb, phw.hw_addr);
-		if (len > 0) {
-			phw.hw_addrlen = htons(len);
-			if (nla_put(inst->skb, NFULA_HWADDR, sizeof(phw), &phw))
-				goto nla_put_failure;
-		}
-	}
+	if (nfnetlink_put_hwaddr(inst->skb, skb, indev, NFULA_HWADDR))
+		goto nla_put_failure;
 
 	if (indev && skb_mac_header_was_set(skb)) {
 		if (nla_put_be16(inst->skb, NFULA_HWTYPE, htons(skb->dev->type)) ||
diff --git a/net/netfilter/nfnetlink_log_common.h b/net/netfilter/nfnetlink_log_common.h
new file mode 100644
index 000000000000..99012543b32f
--- /dev/null
+++ b/net/netfilter/nfnetlink_log_common.h
@@ -0,0 +1,117 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _NF_NETLINK_LOG_COMMON_H
+#define _NF_NETLINK_LOG_COMMON_H
+
+#include <linux/netdevice.h>
+#include <linux/skbuff.h>
+#include <net/netlink.h>
+#include <linux/netfilter/nfnetlink_queue.h>
+#include <linux/netfilter/nfnetlink_log.h>
+
+/* nfnetlink_log and nfnetlink_queue suffer from copypaste; avoid adding
+ * more and place shared code here.
+ */
+static __always_inline void assert_nfqnl_nfunl_hdrs(void)
+{
+	struct nfulnl_msg_packet_hw phwu;
+	struct nfqnl_msg_packet_hw phwq;
+
+	BUILD_BUG_ON(sizeof(phwu) != sizeof(phwq));
+
+#define X(memb) offsetof(struct nfulnl_msg_packet_hw, memb) != \
+		offsetof(struct nfqnl_msg_packet_hw, memb)
+
+	BUILD_BUG_ON(X(hw_addrlen));
+	BUILD_BUG_ON(X(hw_addr));
+#undef X
+#define X(memb) sizeof(phwu.memb) != sizeof(phwq.memb)
+	BUILD_BUG_ON(X(hw_addrlen));
+#undef X
+}
+
+/**
+ * nfnetlink_put_hwaddr - Serialize L2 hardware address into netlink attr
+ *
+ * @nlskb: netlink message to append the attribute to.
+ * @skb: the packet whose hardware address is being serialized.
+ * @indev: the input device that received @skb.
+ * @attr: netlink attribute type identifier.
+ *
+ * Extracts the MAC header from @skb using @indev's header_ops and appends
+ * it as a netlink attribute of type @attr to @nlskb.
+ *
+ * UAPI NOTE: The attribute is serialized in a legacy container structure
+ * (nfulnl_msg_packet_hw / nfqnl_msg_packet_hw) rather than a plain
+ * nla_put(hwaddr, len).
+ * The hw_addrlen member in that structure is redundant -- userspace knows
+ * the size from the netlink attribute length -- but is retained for ABI
+ * compatibility. nfnetlink_queue duplicates this layout; both structs are
+ * layout-identical, so this one helper serves both.
+ *
+ * The maximum address length is 8 octets, even though netlink itself
+ * supports longer addresses. This is a limitation of the
+ * compound-structure ABI (hw_addr[8] member).
+ *
+ * This helper checks:
+ *  - @indev is non-NULL and implements header_ops->parse.
+ *  - network_header is not below mac_header (encapsulation), so
+ *    skb_mac_header_len() does not wrap.
+ *  - L2 header is present and at least @indev's hard_header_len, so
+ *    header_ops->parse does not read past a short or missing header.
+ *
+ * @indev, not @skb->dev, is used: @skb->dev may have been changed since
+ * the packet was received, so it is not necessarily the device whose
+ * header_ops can parse the L2 header.
+ *
+ * Return: 0 on success or if the attribute is skipped (no parser, no or
+ * short L2 header, or empty address), -EMSGSIZE if the tailroom of the
+ * skb is insufficient to store the attribute header and payload.
+ */
+static inline int
+nfnetlink_put_hwaddr(struct sk_buff *nlskb,
+		     const struct sk_buff *skb,
+		     const struct net_device *indev,
+		     u16 attr)
+{
+	char hw_addr[MAX_ADDR_LEN];
+	unsigned int mac_len;
+	int len;
+
+	if (!indev || !indev->header_ops || !indev->header_ops->parse ||
+	    !skb_mac_header_was_set(skb))
+		return 0;
+
+	/* encap (ip_encap, xfrm) can set network_header < mac_header:
+	 * skb_mac_header_len() would wrap and bypass the checks below.
+	 */
+	if (skb->network_header < skb->mac_header)
+		return 0;
+
+	mac_len = skb_mac_header_len(skb);
+	/* parse() reads fixed offsets sized for the full header
+	 * (ipgre: min_header_len 0, reads offset 12..15).
+	 */
+	if (mac_len == 0 || mac_len < indev->hard_header_len)
+		return 0;
+
+	len = indev->header_ops->parse(skb, indev, hw_addr);
+	if (len > 0) {
+		struct nfulnl_msg_packet_hw phw;
+		const int max_hwlen = (int)sizeof(phw.hw_addr);
+
+		assert_nfqnl_nfunl_hdrs();
+
+		/* UAPI limitation, must clamp. */
+		if (len > max_hwlen)
+			len = max_hwlen;
+
+		memset(&phw, 0, sizeof(phw));
+		memcpy(phw.hw_addr, hw_addr, len);
+		phw.hw_addrlen = htons(len);
+
+		return nla_put(nlskb, attr, sizeof(phw), &phw);
+	}
+
+	return 0;
+}
+#endif
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 862d2a762106..37f8953b7c49 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -57,6 +57,8 @@
 #include <net/netfilter/nf_conntrack.h>
 #endif
 
+#include "nfnetlink_log_common.h"
+
 #define NFQNL_QMAX_DEFAULT 1024
 #define NFQNL_HASH_MIN     8
 #define NFQNL_HASH_MAX     32768
@@ -917,20 +919,8 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 	    nla_put_be32(skb, NFQA_PRIORITY, htonl(entskb->priority)))
 		goto nla_put_failure;
 
-	if (indev && entskb->dev &&
-	    skb_mac_header_was_set(entskb) &&
-	    skb_mac_header_len(entskb) != 0) {
-		struct nfqnl_msg_packet_hw phw;
-		int len;
-
-		memset(&phw, 0, sizeof(phw));
-		len = dev_parse_header(entskb, phw.hw_addr);
-		if (len) {
-			phw.hw_addrlen = htons(len);
-			if (nla_put(skb, NFQA_HWADDR, sizeof(phw), &phw))
-				goto nla_put_failure;
-		}
-	}
+	if (nfnetlink_put_hwaddr(skb, entskb, indev, NFQA_HWADDR))
+		goto nla_put_failure;
 
 	if (nfqnl_put_bridge(entry, skb) < 0)
 		goto nla_put_failure;
-- 
2.56.1

