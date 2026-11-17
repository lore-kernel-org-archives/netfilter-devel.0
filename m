Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794916278;
	b=RG7Pr+EczvpAwVCJxez9YY3ii0JXU7feTHMexp56n35SYB0AmSIMz6/WcR2N9CfczECQ
	 4I04wKVu1Zz3nkChy2QmAuHG7/s28yjwpfu74DGrlf57VV65JpwPhi9HnhpihD6m+mH63
	 guxYKXxiwSNUm0LOVfLkReA+Fj9goG5REfSpnCGQ0KDqN1KLXM3sqj91CUSnT1HcYGNEZ
	 J2Pt6tueTg6L3VC/hqVh9o0hKu+xu/7Fv/Lf89U+9s+jRmPQXHOX6vgvCtu5dswRMfjpD
	 vqN4zNwidTDwGhAZvEe5vwpppCWEeBRm1WR/XadwxZrjKh/zlPs5wC1vQ4vjtJLm8Pw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794916278;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=AF9Y7F0Q4on7pQ3hMUOAuq8WwySQWbN5zNGViyPyofk=;
	b=u14PONJerUd7G5esOoYm3lDXXPDmG4lglEQW0sdpTs0gqu4RbFlz5bwuM0NcWyB5JJte
	 FJKHwvX0YtAj7/SDo0BlLQBW0gbj7zuiR7VLeVqf1OIrnBEPKKgjaLaweEe4rjx3KPX3c
	 otSmKT9D+qBGdzs+Xc4EYNOz809U4yfEyTBOXL4lvF8F7fVd8SD/wTt2IVCEVzvJ2iiQU
	 pJ6TZ52HCKctiMy926+yKj3irGCC/I2JUTW5GGUQpmBGkna3OsP/g7I9G0ijRSKwsfv2y
	 n/QgU0q7mMjuIaDF7PeEe34qD8WasojbrZ8WjWCyc5U9v+psUnRPO76nXGgxwTKibOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A26C606A329
	for <netfilter-devel@vger.kernel.org>; Tue, 17 Nov 2026 11:51:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9A26C606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id F41E16055A; Tue, 17 Nov 2026 12:51:15 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 5/6] netfilter: nfnetlink_log: don't log hwheader on output hooks
Date: Tue, 17 Nov 2026 12:50:45 +0100
Message-ID: <20261117115046.15435-6-fw@strlen.de>
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

On output hooks (LOCAL_OUT, POST_ROUTING and their per-family
equivalents) the mac header is either unset or still belongs to the
ingress device, not the egress one, so we would log stale data.  Only
emit the hardware header attributes while the packet is still on the
input path.

The check has to use both family and hook value, hook numbers are family
specific, e.g. NF_BR_BROUTING has the same value as NF_INET_INGRESS.

nfulnl_pre_egress(pf, hooknum) answers the question the check cares
about: has the packet left indev's input path yet, i.e. does skb's mac
header still belong to indev.

This keeps hwheader logging working for the nftables inet ingress hook
(nft_do_chain_inet_ingress() sets pf to NFPROTO_IPV4/IPV6 with hook =
NF_INET_INGRESS) and for the ebtables broute table (NF_BR_BROUTING,
indev and mac header are those of the received frame).  For NFPROTO_ARP
and NFPROTO_NETDEV only NF_ARP_IN and NF_NETDEV_INGRESS are accepted.

Fixes: 72961ecf84d6 ("netfilter: nfnetlink_log: send complete hardware header")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nfnetlink_log.c | 34 +++++++++++++++++++++++++++++++++-
 1 file changed, 33 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index edc1e018c869..ee006d9df0a4 100644
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
@@ -650,7 +681,8 @@ __build_packet_message(struct nfnl_log_net *log,
 	if (nfnetlink_put_hwaddr(inst->skb, skb, indev, NFULA_HWADDR))
 		goto nla_put_failure;
 
-	if (indev && skb_mac_header_was_set(skb) &&
+	if (nfulnl_pre_egress(pf, hooknum) &&
+	    indev && skb_mac_header_was_set(skb) &&
 	    nfulnl_put_hwheader(inst->skb, skb, indev))
 		goto nla_put_failure;
 
-- 
2.56.1

