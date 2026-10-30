Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793375101;
	b=z2vffUOeZzbfqPlwm2hkj2s9+eFKfDvKFJiLfdRBAHNG8lbhhA5twWYe1cYc9GNyXvwF
	 ogg9gks2u5E/etdfRyQF11DcNBk26NdHIITgdEk9MYfNJdfvfkU/sonY/+laBxZ3avi6t
	 bucq8EnfUBl54wmqKQlMzwQZlKRYuyeR//KuflpknbNHR9r/cM7GDsyKgcXFZpUjHwoSM
	 bDk9wKIQrsLblmVuDyyAlYS9MkI7fJd2LI/is9E42uFDzvKLbrP2Ztcm8xjgpoJexYKbA
	 cilatTVzejxKlEo1Ux4+r2nHNczotdXCM7tznsdkz/27p7Yj858Dj1xU9QX8YwUf2Ow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793375101;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=mdZnQd2QcwlDYi2ACt1sAKyt4j7ycsvHx8j4lBU9Qd4=;
	b=B2nYdpukRVXOPFeQl6Q1xh16f7B2y+j4D5esXSSxRuY1jk1IO7lVdHPiTlyTTflOD4IN
	 9P0E2ki3ySrxA6nMTTjOySNc0o1OY/5LvPI++wexmHYQHPZMHqJpsA13dChpPXkMwz6JJ
	 oq2+3z1DwP9Y1X1lPmN07f7sqgS5TLLb7JTvMqDrrhE43Pji0Q4zR3SK2mrU54U89/usL
	 jr/dvtwQaTuole4hQmaB1TOuAC6ppWZrQd/1sNeyRtjrgGqQKGg0RnfbV3tTp0vrSCgr0
	 jC7XKSWUpfpvL971y+ifuA9Bay2B0y4yyhRnlahQg388pRdUOhQdXy6NCUGxHvT1fpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E118F606A31A
	for <netfilter-devel@vger.kernel.org>; Fri, 30 Oct 2026 15:45:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E118F606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 6199F609D0; Fri, 30 Oct 2026 16:44:59 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf 4/4] netfilter: nfnetlink_log: rework mac header logging
Date: Fri, 30 Oct 2026 16:44:33 +0100
Message-ID: <20261030154433.13601-5-fw@strlen.de>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261030154433.13601-1-fw@strlen.de>
References: <20261030154433.13601-1-fw@strlen.de>
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

For unknown reasons this uses dev->hard_header_len.

LLM says that hard_header_len says how long a link layer header can get,
not how many bytes this packet holds. Use skb_mac_header_len instead and
cap if needed.

AFAICS this should have dumped skb_mac_header_len bytes instead, with one
single attribute (plus maybe skb->protocol).

Keep it close to the original version: if hard_header_len is larger than
the mac header size of the packet, then clamp to that value.

While at it, also move this so that we don't call this for POST_ROUTING
hook; mac header is still that of the incoming device, not the egress one.

I suspect that this is almost exclusively used with plain ethernet,
where hard_header_len and skb_mac_header_len() are 14 bytes which
would explain absence of bug reports.

Fixes: 72961ecf84d6 ("netfilter: nfnetlink_log: send complete hardware header")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nfnetlink_log.c | 68 +++++++++++++++++++++++++++--------
 1 file changed, 54 insertions(+), 14 deletions(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index 29530b753928..e6877ac36d26 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -458,6 +458,56 @@ static int nfulnl_put_bridge(struct nfulnl_instance *inst, const struct sk_buff
 	return -1;
 }
 
+/**
+ * nfulnl_put_hwheader - Append link-layer header info to the netlink skb.
+ * @nlskb:      Target netlink message to append attributes to.
+ * @skb:        Original packet skb whose link-layer header is described.
+ *
+ * Emits the NFULA_HWTYPE and NFULA_HWLEN netlink attributes into @nlskb
+ * based on the link-layer header of @skb.
+ *
+ * The device's hard_header_len describes the maximum size a link-layer
+ * header can grow to, not the actual size of this packet's header.
+ * The actual length is taken from skb_mac_header_len() and capped at
+ * hard_header_len if needed.
+ *
+ * The NFULA_HWLEN attribute is retained for backward compatibility.
+ * Userspace should derive the length from the NFULA_HWHEADER attribute
+ * size instead.
+ *
+ * Caller must check skb_mac_header_was_set(skb) before using this
+ * function.
+ *
+ * Return: -EMSGSIZE if the tailroom of the skb is insufficient to store
+ * the attribute header and payload.
+ */
+static int nfulnl_put_hwheader(struct sk_buff *nlskb, const struct sk_buff *skb)
+{
+	unsigned int hwlen = READ_ONCE(skb->dev->hard_header_len);
+	const unsigned char *hwhdrp = skb_mac_header(skb);
+	int len = skb_mac_header_len(skb);
+	u16 hwtype = skb->dev->type;
+
+	if (nla_put_be16(nlskb, NFULA_HWTYPE, htons(hwtype)))
+		return -EMSGSIZE;
+
+	if (len > hwlen)
+		len = hwlen;
+
+	/* This attribute should not exist, userspace should
+	 * use NFULA_HWHEADER attribute size. Removing
+	 * this breaks existing users which unfortunately
+	 * rely on NFULA_HWLEN presence.
+	 */
+	if (nla_put_be16(nlskb, NFULA_HWLEN, htons(len)))
+		return -EMSGSIZE;
+
+	if (len == 0)
+		return 0;
+
+	return nla_put(nlskb, NFULA_HWHEADER, len, hwhdrp);
+}
+
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
 static int nflog_put_master_ifindex(struct sk_buff *nlskb, int attr,
 				    const struct net_device *dev)
@@ -494,7 +544,6 @@ __build_packet_message(struct nfnl_log_net *log,
 	struct nlmsghdr *nlh;
 	sk_buff_data_t old_tail = inst->skb->tail;
 	struct sock *sk;
-	const unsigned char *hwhdrp;
 
 	nlh = nfnl_msg_put(inst->skb, 0, 0,
 			   nfnl_msg_type(NFNL_SUBSYS_ULOG, NFULNL_MSG_PACKET),
@@ -592,25 +641,16 @@ __build_packet_message(struct nfnl_log_net *log,
 	if (nfnetlink_put_hwaddr(inst->skb, skb, indev, NFULA_HWADDR))
 		goto nla_put_failure;
 
-	if (indev && skb_mac_header_was_set(skb)) {
-		if (nla_put_be16(inst->skb, NFULA_HWTYPE, htons(skb->dev->type)) ||
-		    nla_put_be16(inst->skb, NFULA_HWLEN,
-				 htons(skb->dev->hard_header_len)))
-			goto nla_put_failure;
-
-		hwhdrp = skb_mac_header(skb);
-
-		if (nla_put(inst->skb, NFULA_HWHEADER,
-			    skb->dev->hard_header_len, hwhdrp))
-			goto nla_put_failure;
-	}
-
 	if (hooknum <= NF_INET_FORWARD) {
 		struct timespec64 kts = ktime_to_timespec64(skb_tstamp_cond(skb, true));
 		struct nfulnl_msg_packet_timestamp ts;
 		ts.sec = cpu_to_be64(kts.tv_sec);
 		ts.usec = cpu_to_be64(kts.tv_nsec / NSEC_PER_USEC);
 
+		if (indev && skb->dev && skb_mac_header_was_set(skb) &&
+		    nfulnl_put_hwheader(inst->skb, skb))
+			goto nla_put_failure;
+
 		if (nla_put(inst->skb, NFULA_TIMESTAMP, sizeof(ts), &ts))
 			goto nla_put_failure;
 	}
-- 
2.56.0

