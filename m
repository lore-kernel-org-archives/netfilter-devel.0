Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023582;
	b=FAkGPBpOZmUennNha4H4thVHKqKNj/G0JT0ri6gST2Rutw9TqgHyq/BPO4JM75seGJE+
	 X/HTZJDUPhrKYTCoQBl+8NWTCkHFYnmGX/ssOnFzwRDK4Su7/ZWhCYdTNlXpix7+4Ck/m
	 +4XEseVqStogGdBorgpQhJsONNM/Zja6U8/ppAHVTGtBOH23L9TcQ8YihVm3f64nX/ZFU
	 grOxG9SdCtVpgz93N7dXt55wkiZoyZrO1IZYjnpV5OaRuKgDcWUpBDJbcfumIR74mKz6E
	 55aubPOg1HyJ+3G5EOwzaQw9ymUNuLQUrc5tzr2FeZbrfDCqL3BSjV1ydpdqPgLsTpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023582;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=kT+TpyePtlUQSVR8NMZtvAJ6V5LYmv6oBS8tXT6CUMU=;
	b=5OwQPnIDo7gdr91pKgmm8F8nR4bFLt0KIriv9JIkOgB6EzMaEHVd2eEF/VFruTkLzJrn
	 /y/OYlO7hXKZrcgt6M9l5z1QmnUlj4q7Krf97fTQqvFQ2sdx4xHTcXhPSuYmAKGEo8oKg
	 Q5kMuSEqIL4tfCFZSbLC5MxUNtZlZVdeHTimKEVFQoopAcUPTtqu3v1Cr+kK280uAf6v1
	 42bo3v8sn69t6yqLFnGtHBV+i+s4LrOm8G92XxBiPJQ42cOut8x7Hdy7zejLRezp/meBt
	 rasYLTyRGV/iNhVpmaz7NpLOnlMHEaPBNMfBbCVKmqWGPvZfG2xluKsEhFGzYCuR8cw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1352160A2609
	for <netfilter-devel@vger.kernel.org>; Wed, 18 Nov 2026 17:39:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1352160A2609
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 87E6C60225; Wed, 18 Nov 2026 18:39:40 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v3 5/6] netfilter: nfnetlink: don't log hwaddr/hwheader on output hooks
Date: Wed, 18 Nov 2026 18:39:12 +0100
Message-ID: <20261118173913.22592-6-fw@strlen.de>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261118173913.22592-1-fw@strlen.de>
References: <20261118173913.22592-1-fw@strlen.de>
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

On output hooks (LOCAL_OUT, POST_ROUTING and their per-family
equivalents) the mac header is either unset or still belongs to the
ingress device, not the egress one, so we would log stale data.  Only
emit the hardware header attributes while the packet is still on the
input path.

Same for the HWADDR attribute: it is parsed with the ingress device's
header_ops, but ip_output() and xfrm4_output() pass the pre-switch
skb->dev as indev while the packet may have been re-routed or
re-encapsulated, so the source address can be stale.

The check has to use both family and hook value, hook numbers are family
specific, e.g. NF_BR_BROUTING has the same value as NF_INET_INGRESS.

nfulnl_pre_egress(pf, hooknum) answers the question the check cares
about: has the packet left indev's input path yet, i.e. does skb's mac
header still belong to indev.

This keeps hwaddr/hwheader logging working for the nftables inet ingress
hook (nft_do_chain_inet_ingress() sets pf to NFPROTO_IPV4/IPV6 with hook
= NF_INET_INGRESS) and for the ebtables broute table (NF_BR_BROUTING,
indev and mac header are those of the received frame).  For NFPROTO_ARP
and NFPROTO_NETDEV only NF_ARP_IN and NF_NETDEV_INGRESS are accepted.

nfnetlink_queue uses the hook number only; its only supported in the
ipv4/ipv6/inet/bridge families.

Fixes: 72961ecf84d6 ("netfilter: nfnetlink_log: send complete hardware header")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nfnetlink_log.c   | 43 +++++++++++++++++++++++++++++----
 net/netfilter/nfnetlink_queue.c |  3 ++-
 2 files changed, 40 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index b54fbfe56795..5645297b4b3b 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -21,6 +21,7 @@
 #include <linux/netdevice.h>
 #include <linux/netfilter.h>
 #include <linux/netfilter_bridge.h>
+#include <linux/netfilter_arp.h>
 #include <net/netlink.h>
 #include <linux/netfilter/nfnetlink.h>
 #include <linux/netfilter/nfnetlink_log.h>
@@ -458,6 +459,36 @@ static int nfulnl_put_bridge(struct nfulnl_instance *inst, const struct sk_buff
 	return -1;
 }
 
+/**
+ * nfulnl_pre_egress - Can @skb's mac header still be attributed to @indev?
+ * @pf: protocol family of the hook this packet is being logged from.
+ * @hooknum: hook number within @pf's family.
+ *
+ * True only for hook points where the packet has not yet left @indev's
+ * input path, i.e. where @skb's mac header still reflects what @indev
+ * actually received. Past LOCAL_OUT/POST_ROUTING (and their per-family
+ * equivalents) the packet may have been re-routed, re-encapsulated, or
+ * is headed to a different device than it arrived on.
+ *
+ * Return: true if mac header can be attributed to indev
+ */
+static bool nfulnl_pre_egress(u8 pf, unsigned int hooknum)
+{
+	switch (pf) {
+	case NFPROTO_IPV4:
+	case NFPROTO_IPV6:
+		return hooknum <= NF_INET_FORWARD || hooknum == NF_INET_INGRESS;
+	case NFPROTO_BRIDGE:
+		return hooknum <= NF_BR_FORWARD || hooknum == NF_BR_BROUTING;
+	case NFPROTO_ARP:
+		return hooknum == NF_ARP_IN;
+	case NFPROTO_NETDEV:
+		return hooknum == NF_NETDEV_INGRESS;
+	default:
+		return false;
+	}
+}
+
 /**
  * nfulnl_put_hwheader - Append link-layer header info to the netlink skb.
  * @nlskb:      Target netlink message to append attributes to.
@@ -647,12 +678,14 @@ __build_packet_message(struct nfnl_log_net *log,
 	    nla_put_be32(inst->skb, NFULA_MARK, htonl(skb->mark)))
 		goto nla_put_failure;
 
-	if (nfnetlink_put_hwaddr(inst->skb, skb, indev, NFULA_HWADDR))
-		goto nla_put_failure;
+	if (nfulnl_pre_egress(pf, hooknum)) {
+		if (nfnetlink_put_hwaddr(inst->skb, skb, indev, NFULA_HWADDR))
+			goto nla_put_failure;
 
-	if (indev && skb_mac_header_was_set(skb) &&
-	    nfulnl_put_hwheader(inst->skb, skb, indev))
-		goto nla_put_failure;
+		if (indev && skb_mac_header_was_set(skb) &&
+		    nfulnl_put_hwheader(inst->skb, skb, indev))
+			goto nla_put_failure;
+	}
 
 	if (hooknum <= NF_INET_FORWARD) {
 		struct timespec64 kts = ktime_to_timespec64(skb_tstamp_cond(skb, true));
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 37f8953b7c49..c1afeb0c3e2a 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -919,7 +919,8 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 	    nla_put_be32(skb, NFQA_PRIORITY, htonl(entskb->priority)))
 		goto nla_put_failure;
 
-	if (nfnetlink_put_hwaddr(skb, entskb, indev, NFQA_HWADDR))
+	if (entry->state.hook <= NF_INET_FORWARD &&
+	    nfnetlink_put_hwaddr(skb, entskb, indev, NFQA_HWADDR))
 		goto nla_put_failure;
 
 	if (nfqnl_put_bridge(entry, skb) < 0)
-- 
2.56.1

