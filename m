Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795003083;
	b=1iqS3IOj2w+Yb9mNQn7ZlOSZWUSBpfYDE4VU2mBbxGdduZY/93rlciNecT4npRV0TE4m
	 MthKMIgBAl57M/iA80E27SMNIIr/Nv2qWWwzcQUUgkVNX8hFUyJkXT2Zn9yGzS9qnt4Bv
	 7sQpOZjm07l1JNA0sL85clsf7Airk96hEQ1+B2IQMDZH1ZrHP6EEjpBS+S+dB4oXpOQy9
	 QypmQTlR5kDu1POdiS8EGikdgvrsoFdSDPeptBHlExPSU1yqLVHRjcHnEG2vgk36R9u7h
	 KRY3J/WfUaEiZgDxU/2h3dKm4hG5qSA0/vD9qvi3p/n1I60Ph5pQuIVuFw+wawkhPOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795003083;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=zOm/F6/lrb2a/jexMn0nYwo8jtnw6/3o558xIB4ljow=;
	b=btf/QnMxU9MLWkbwYliDt0fz8iVVP/8leRx8l3+Ge+fHpDG43HHNZPrYSDnw3v3O2XYr
	 DYb01BEVf38eMQVJBOWnuEIf+5xvnrH7uM6wGLCpTIp1z2K2+N0iIf1YhMGqGNZTiZz0G
	 I+QK0yBKmnbFwqY0K7QeY6X9U4w+XbftG1AWh06G4d6qEgZmYz8rMndAEGzzg9Okmq/2K
	 e+8jw5h0oSfZ5onDIkqRF3AHyuwhV7AemJetOrMcnTH/fA1Umob1Q8BzA/7/i5fv3kbWy
	 ragIfFXP65TUTB+NCGrDKNVXHrF9q8jnQ2AF5B9h5Qt6e9iUgDmDxcD8KngXZjejN/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7EAF606A32A
	for <netfilter-devel@vger.kernel.org>; Wed, 18 Nov 2026 11:58:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A7EAF606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 3BC3C60633; Wed, 18 Nov 2026 12:58:01 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v2 4/6] netfilter: nfnetlink_log: use real mac header length for hwheader
Date: Wed, 18 Nov 2026 12:57:30 +0100
Message-ID: <20261118115732.9529-5-fw@strlen.de>
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

nfnetlink_log uses skb->dev->hard_header_len for the length of the
NFULA_HWHEADER attribute.

hard_header_len says how long a link layer header can get, not how many
bytes this packet holds.  Use skb_mac_header_len() instead and cap at
hard_header_len, as before, if needed.

Also take hwtype and hard_header_len from indev instead of skb->dev:
skb->dev may have been changed since the packet was received, indev is
the device that wrote the mac header.

If the resulting length is 0, omit NFULA_HWHEADER instead of sending an
empty attribute.  NFULA_HWLEN is still sent, userspace relies on it.

I suspect that this is almost exclusively used with plain ethernet,
where hard_header_len and skb_mac_header_len() are both 14 bytes, which
would explain the absence of bug reports.

Fixes: 72961ecf84d6 ("netfilter: nfnetlink_log: send complete hardware header")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nfnetlink_log.c | 75 +++++++++++++++++++++++++++++------
 1 file changed, 62 insertions(+), 13 deletions(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index 37f3e7b6b538..b54fbfe56795 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -458,6 +458,65 @@ static int nfulnl_put_bridge(struct nfulnl_instance *inst, const struct sk_buff
 	return -1;
 }
 
+/**
+ * nfulnl_put_hwheader - Append link-layer header info to the netlink skb.
+ * @nlskb:      Target netlink message to append attributes to.
+ * @skb:        Original packet skb whose link-layer header is described.
+ * @indev:      The input device that received @skb.
+ *
+ * Emits the NFULA_HWTYPE and NFULA_HWLEN netlink attributes into @nlskb
+ * based on the link-layer header of @skb.
+ *
+ * @indev, not @skb->dev, is the source of the device's type and
+ * hard_header_len: on bridging and br_netfilter paths skb->dev is
+ * repointed to the logical or egress device while @indev keeps
+ * referring to the device that actually wrote @skb's mac header.
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
+ * Caller must ensure @indev is not NULL and check
+ * skb_mac_header_was_set(skb) before using this function.
+ *
+ * Return: -EMSGSIZE if the tailroom of the skb is insufficient to store
+ * the attribute header and payload.
+ */
+static int nfulnl_put_hwheader(struct sk_buff *nlskb, const struct sk_buff *skb,
+			       const struct net_device *indev)
+{
+	unsigned int hwlen = READ_ONCE(indev->hard_header_len);
+	const unsigned char *hwhdrp = skb_mac_header(skb);
+	int len = skb_mac_header_len(skb);
+	u16 hwtype = indev->type;
+
+	if (nla_put_be16(nlskb, NFULA_HWTYPE, htons(hwtype)))
+		return -EMSGSIZE;
+
+	if (len < 0)
+		len = 0;
+	else if ((unsigned int)len > hwlen)
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
@@ -494,7 +553,6 @@ __build_packet_message(struct nfnl_log_net *log,
 	struct nlmsghdr *nlh;
 	sk_buff_data_t old_tail = inst->skb->tail;
 	struct sock *sk;
-	const unsigned char *hwhdrp;
 
 	nlh = nfnl_msg_put(inst->skb, 0, 0,
 			   nfnl_msg_type(NFNL_SUBSYS_ULOG, NFULNL_MSG_PACKET),
@@ -592,18 +650,9 @@ __build_packet_message(struct nfnl_log_net *log,
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
+	if (indev && skb_mac_header_was_set(skb) &&
+	    nfulnl_put_hwheader(inst->skb, skb, indev))
+		goto nla_put_failure;
 
 	if (hooknum <= NF_INET_FORWARD) {
 		struct timespec64 kts = ktime_to_timespec64(skb_tstamp_cond(skb, true));
-- 
2.56.1

