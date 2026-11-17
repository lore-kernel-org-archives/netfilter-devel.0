Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794916269;
	b=CmZjf4oHcg08YpOlqoiBRlIjpzPEtLyQqZtS+8FMEwEK3eOrKcI9MU/rLys+cqi6njTC
	 zbzNyngUAkZ95gX9F6vpnghs04oRNjof3cQ2bsWgp5xagxYUTf5xd9Uxsj21oZo38piLo
	 vAib+qyWHMmIeWHT/ktprscePn28hiHoJJ1HEtyxyTgkWjaFXFykZ4+0SuFORr0RV94rg
	 DHJlmQicxV0Eb1Amb4Xi2nKu9f5VkfmKcTyb0vEzxhoPaifF7KLGTM6rtwCgWbNxgXIM+
	 L40YMaNIAQTQbIzWue1bKBrWClnawAT0Cdfj/c4KyZP9L9aXgxzezmOMP4kBVncLrWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794916269;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=cAAlTYxstibplK03J8cUC5ODIIN8pcbkISBXQOvSILQ=;
	b=He/1sVTf87sG/3UxLgYmh5sx8daL/A0YnUxbEMkBTztTUycaly6sLlQxC27ha5etf1wX
	 OE8Zl40e0qmqUwKnWm7rB8mYaDMlZbAidXcCUme/POBaZcsJURL9abdCePHjqHYNv3g5a
	 v3thDrs0XWXftF6fMcaZwjnOrRm1I6ekzUEaMzxkyy6ij2LvlZFhaIWLbYbYIME88lZCd
	 2HyQvx/ugtfNyEwQcruF9FxedRV2lN88fEjvZNAVMpi3/E1d8EkeTSa4Ltyb71MO7Q908
	 zhRNZDr15SCSIJQcWW2AZyCcjxn/sC29+6ENrx0p5dM+tA9C500Pa6fbPMtfF3lA5eQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10262606A332
	for <netfilter-devel@vger.kernel.org>; Tue, 17 Nov 2026 11:51:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 10262606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 7392560D75; Tue, 17 Nov 2026 12:51:07 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 3/6] netfilter: nfnetlink_log: fix up dev_parse_header usage
Date: Tue, 17 Nov 2026 12:50:43 +0100
Message-ID: <20261117115046.15435-4-fw@strlen.de>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261117115046.15435-1-fw@strlen.de>
References: <20261117115046.15435-1-fw@strlen.de>
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
		     const struct net_device *dev,
		     unsigned char *haddr) {
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

This is an LLM finding, no bug was ever reported about this.

Fixes: 0597f2680d66 ("[NETFILTER]: Add new "nfnetlink_log" userspace packet logging facility")
Fixes: 7af4cc3fa158 ("[NETFILTER]: Add "nfnetlink_queue" netfilter queue handler over nfnetlink")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nfnetlink_log.c        |  18 +----
 net/netfilter/nfnetlink_log_common.h | 106 +++++++++++++++++++++++++++
 net/netfilter/nfnetlink_queue.c      |  18 +----
 3 files changed, 114 insertions(+), 28 deletions(-)
 create mode 100644 net/netfilter/nfnetlink_log_common.h

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index 0b590c117f4c..29530b753928 100644
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
index 000000000000..498725d3457a
--- /dev/null
+++ b/net/netfilter/nfnetlink_log_common.h
@@ -0,0 +1,106 @@
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
+ *  - L2 header is present and at least @indev's minimum header length,
+ *    so header_ops->parse does not read past a short or missing header.
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
+	mac_len = skb_mac_header_len(skb);
+	if (mac_len == 0 || mac_len < indev->min_header_len)
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
index 90d887546f7d..7c0fb4777852 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -56,6 +56,8 @@
 #include <net/netfilter/nf_conntrack.h>
 #endif
 
+#include "nfnetlink_log_common.h"
+
 #define NFQNL_QMAX_DEFAULT 1024
 #define NFQNL_HASH_MIN     8
 #define NFQNL_HASH_MAX     32768
@@ -906,20 +908,8 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
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

