Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795003092;
	b=b3eX/NCsRoK3bI+rjWVW6URC5RnvMaKtQJSDm1Xi3dMupo5Yo/lgVuY5nf8HaN6Bthag
	 6jdq6blBRphXVtuWmUAoMfcKS8k6w6H2OxK7gmqRWOpfGXhlCg00uFxUeDJuJSC0puLey
	 Rd+HbM1cvh48Fuh8UfmP6uT3pta6MJlaBS6Msx5XFqwIBEqCUCZYokCXjKFRnTCq7QCjr
	 YXi2OWrkFm1X6yLqiht1C95shyLBgEXJXTC4JGBcuXnLVsXFzeX6STHJTLscRGQ/GmaaX
	 KbaLUDzGR4lje417BiTEKI80muu0W4zFvJhdtwALTYAZpvKUqeWzmdLZa/gDeZNezyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795003092;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=Be94r3FUWWgu7riLw9nQXseO6eBvXERUZ5FeTrFeT8A=;
	b=cAhyg64kHXFM4vkUoP65YAI/sVCXqt6TOOnXbBCXq6oFxYM4Zfh1OsOhJxCBUaXpufIY
	 uQYZ/0FKSS70qcBiGR+ybTIjNt5uEE6MjgOZC38+0uUHp6cyUO3vKe4LzpdZQOCfY+nl/
	 5uKrvBFBwOJCN+DMec8Gbuaa56Qc/AYgUB5WtRK0MNlYLT4pPqPI3ksDQx8RSlyYNBls6
	 g3pIAezB+voUGgiXdukYyGdJ5BJoQEAw1CAPvlYKNE/AbXfv8g1hz6XpvxqysHz0VB+vB
	 vj/G6MqZt7jijJHA529S1Bn6G/QZymIzOUzLLRa6nM9u6wBxiHB+4+4+Sk69DXvfBkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D784D606A325
	for <netfilter-devel@vger.kernel.org>; Wed, 18 Nov 2026 11:58:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D784D606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id B90EC60633; Wed, 18 Nov 2026 12:58:09 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v2 6/6] netfilter: nfnetlink_log: only add timestamp on the input path
Date: Wed, 18 Nov 2026 12:57:32 +0100
Message-ID: <20261118115732.9529-7-fw@strlen.de>
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

The timestamp attribute should only be emitted while the packet is on
the input path, like the hardware header attributes.  On output hooks
skb->tstamp can hold the SO_TXTIME transmit time, a delivery deadline
rather than the time the packet was observed.

The old check compared the raw hooknum against NF_INET_FORWARD, which is
meaningless for families with their own hook numbering: it was too
liberal for NFPROTO_ARP and NFPROTO_NETDEV.  Use nfulnl_pre_egress()
instead, so those no longer emit a timestamp at their output hooks.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 v2: adapt to changes in earlier patches, no changes per se.

 net/netfilter/nfnetlink_log.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index 5645297b4b3b..697ca7fb1dba 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -548,6 +548,22 @@ static int nfulnl_put_hwheader(struct sk_buff *nlskb, const struct sk_buff *skb,
 	return nla_put(nlskb, NFULA_HWHEADER, len, hwhdrp);
 }
 
+/* The timestamp is the time the packet was observed at the hook.
+ * Only called while the packet is on the input path: on output
+ * hooks skb->tstamp can hold the SO_TXTIME transmit time, which
+ * is a delivery deadline, not an observation time.
+ */
+static int nfulnl_put_timestamp(struct sk_buff *nlskb, const struct sk_buff *skb)
+{
+	struct timespec64 kts = ktime_to_timespec64(skb_tstamp_cond(skb, true));
+	struct nfulnl_msg_packet_timestamp ts = {
+		.sec = cpu_to_be64(kts.tv_sec),
+		.usec = cpu_to_be64(kts.tv_nsec / NSEC_PER_USEC),
+	};
+
+	return nla_put(nlskb, NFULA_TIMESTAMP, sizeof(ts), &ts);
+}
+
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
 static int nflog_put_master_ifindex(struct sk_buff *nlskb, int attr,
 				    const struct net_device *dev)
@@ -685,15 +701,8 @@ __build_packet_message(struct nfnl_log_net *log,
 		if (indev && skb_mac_header_was_set(skb) &&
 		    nfulnl_put_hwheader(inst->skb, skb, indev))
 			goto nla_put_failure;
-	}
-
-	if (hooknum <= NF_INET_FORWARD) {
-		struct timespec64 kts = ktime_to_timespec64(skb_tstamp_cond(skb, true));
-		struct nfulnl_msg_packet_timestamp ts;
-		ts.sec = cpu_to_be64(kts.tv_sec);
-		ts.usec = cpu_to_be64(kts.tv_nsec / NSEC_PER_USEC);
 
-		if (nla_put(inst->skb, NFULA_TIMESTAMP, sizeof(ts), &ts))
+		if (nfulnl_put_timestamp(inst->skb, skb))
 			goto nla_put_failure;
 	}
 
-- 
2.56.1

