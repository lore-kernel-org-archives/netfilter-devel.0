Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795003087;
	b=gcEpDIYBQn47C/BLptDAsShexWDpMw5rlB4giHBxhNuBI9qHG59nDsXzy0oPpcuZ14o6
	 +vRwiUOOg/7VZIG97PYCPkRw82MJWtOSXVmDFu0EclpT2XhZmaW0lyUkQE4CoujCYuJsf
	 +3IPBzJQbcSUORyCl67Z2/XsdvbK4GECgC/Fpju3sqbXxI1/h71QRllvMKXXqUiiRW2eK
	 v4SR43YvaBtdd2LLI52e3rwvmHJjZNC3nXj4IUsyPOTwpjb3L1KJtL2mDR+6sJwixh1M/
	 SbyDi1Ujq0QOD7fVwTO5Z9+OIS+NNy/fkQRYl8dJr1WA4hrEs/LeAmOgx2YBl+midxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795003087;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=0wN5ajRBoJVO15p4DdSDq0+gE/KNz4Xyy8TLukArImY=;
	b=FZ/PXIEtkBS7JMZBRkGP0ChPVvfi/J09FQWS5yG7zNyAWLF/Rfb99/ezlg9YqsXrJJXl
	 742vE4XWLBYxSq2LaZhj+By7iVyvVjADDd8PKvHgluXdsECatHxQwJldyVy3iUuvHgoUv
	 l2GcBEVotg6p+A6M8DnYSM+fEzh4P4Lv0n9+ZP7xTZydhbg0kawWspMCPzIoYPKbK0FaN
	 E6aQ0I6ZhTtL7zL0bO+FEheHdMIPNPLf1zYOcoFdwI1MspPGYB1C8YLDjP7r+tb2vWVpf
	 fZypsjHrCggk7M/JQw1atp+P3zQQZgKTtgrZVI4WYMVC6hLZ2W/T7WK5Yvtloh68UgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16DED606A31C
	for <netfilter-devel@vger.kernel.org>; Wed, 18 Nov 2026 11:58:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 16DED606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 78CFA60D56; Wed, 18 Nov 2026 12:58:05 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v2 5/6] netfilter: nfnetlink: don't log hwaddr/hwheader on output hooks
Date: Wed, 18 Nov 2026 12:57:31 +0100
Message-ID: <20261118115732.9529-6-fw@strlen.de>
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
 v2: restrict hwaddr too.

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

