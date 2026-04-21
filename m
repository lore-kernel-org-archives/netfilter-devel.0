Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0D772BE7BE
	for <netfilter-devel@vger.kernel.org>; Tue, 21 Apr 2026 18:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776796526; cv=none; b=obbQ92he0gbCTo9wD1SaIUy2hh7WRUuighEuJ4mkMAaG0/x40wWS9uvHEZXw2DQxYdsqn2O9Abz1MdNyKHrpy5yVuVh7TFOv135qCkOnLgb/B0dkv+RUSB7Qx+r9FUEaPSSslJXXJDRYVwlvnRmELmrcY0f3FAVe60XhBdtTv4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776796526; c=relaxed/simple;
	bh=kC8ZCTDsJAYQL8OlZ+k+6JY9z8/Sqx7fYh1Qpcb4iqU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nj9T62NNOtQW3dRB05js2N8DmiNJHEW67h0S6FgiHWI902I4pDypVZSq38w9MqEClW7VMvOcHBZe8ly+jswQ/K/PIs0nbH6Ei8Cw03kTwu3M1Hz019zwuMowCaXFGwu8xw4RGlyLz1+ugvP5q0TMm51VP6qrr6jj7JH/edcOQ7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=gBld8f+x; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="gBld8f+x"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 343D960255;
	Tue, 21 Apr 2026 20:35:18 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1776796518;
	bh=4F8FKUzN+rQdLlW6EPbWJ59sgS7CjxTIoDPe8l9IDcg=;
	h=From:To:Cc:Subject:Date:From;
	b=gBld8f+x0TGRciqKPq3qRPG3jWmKiJCKkeEdJzgllOVZxbvjZRUGhPHfH6mUhxIcs
	 qwFeVLM69tccs5E8vofkLuZdl2mllhUIIzq0+ZBuHoz64Os66sV5MKy+qsPRtNyR39
	 ll6Mg6P30D/KcGNklA7KBpdqCnu9/lRr4BkhO+KrSenbC6t6wAw3cfhhK4BSmTBX+M
	 UoH/OHFd1SH7VxqtiGDVUBO6eWcWAuc1owSeAJvgLNumKy29qefmaOYJBc4X+/hMii
	 HPejTkyfYqG+ewPMsg1uzn5wbNqjkQdT1gXR2siHLkVAoC9xxTmlzipPNjC7FRz+S/
	 luZikbXRW1wdw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: [PATCH nf,v5] netfilter: arp_tables: fix IEEE1394 ARP payload parsing
Date: Tue, 21 Apr 2026 20:35:14 +0200
Message-ID: <20260421183514.167201-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Weiming Shi says:

"arp_packet_match() unconditionally parses the ARP payload assuming two
hardware addresses are present (source and target). However,
IPv4-over-IEEE1394 ARP (RFC 2734) omits the target hardware address
field, and arp_hdr_len() already accounts for this by returning a
shorter length for ARPHRD_IEEE1394 devices.

As a result, on IEEE1394 interfaces arp_packet_match() advances past a
nonexistent target hardware address and reads the wrong bytes for both
the target device address comparison and the target IP address. This
causes arptables rules to match against garbage data, leading to
incorrect filtering decisions: packets that should be accepted may be
dropped and vice versa.

The ARP stack in net/ipv4/arp.c (arp_create and arp_process) already
handles this correctly by skipping the target hardware address for
ARPHRD_IEEE1394. Apply the same pattern to arp_packet_match()."

This patch always returns 0 (no match) in case user matches on the target
hardware address which is never present in IEEE1394.

Note that this returns 0 (no match) for either normal and inverse match
because matching in the target hardware address in ARPHRD_IEEE1394 has
never been supported by arptables. This is intentional, matching on the
target hardware address should never evaluate true for ARPHRD_IEEE1394.

Moreover, adjust arpt_mangle to drop the packet if user tries to mangle
target hardware and IP address in IEEE1394, this has never been
supported.

Fixes: 6752c8db8e0c ("firewire net, ipv4 arp: Extend hardware address and remove driver-level packet inspection.")
Reported-by: Xiang Mei <xmei5@asu.edu>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v5: check for arphdr->ar_hrd == htons(ARPHRD_IEEE1394) in
    arp_packet_match() too.

 net/ipv4/netfilter/arp_tables.c  | 19 ++++++++++++++++---
 net/ipv4/netfilter/arpt_mangle.c |  8 ++++++++
 2 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 1cdd9c28ab2d..e4b2106d0456 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -110,13 +110,26 @@ static inline int arp_packet_match(const struct arphdr *arphdr,
 	arpptr += dev->addr_len;
 	memcpy(&src_ipaddr, arpptr, sizeof(u32));
 	arpptr += sizeof(u32);
-	tgt_devaddr = arpptr;
-	arpptr += dev->addr_len;
+
+	if (IS_ENABLED(CONFIG_FIREWIRE_NET) &&
+	    arphdr->ar_hrd == htons(ARPHRD_IEEE1394)) {
+		if (unlikely(memchr_inv(arpinfo->tgt_devaddr.mask, 0,
+					sizeof(arpinfo->tgt_devaddr.mask))))
+			return 0;
+
+		tgt_devaddr = NULL;
+	} else {
+		tgt_devaddr = arpptr;
+		arpptr += dev->addr_len;
+	}
 	memcpy(&tgt_ipaddr, arpptr, sizeof(u32));
 
 	if (NF_INVF(arpinfo, ARPT_INV_SRCDEVADDR,
 		    arp_devaddr_compare(&arpinfo->src_devaddr, src_devaddr,
-					dev->addr_len)) ||
+					dev->addr_len)))
+		return 0;
+
+	if (tgt_devaddr &&
 	    NF_INVF(arpinfo, ARPT_INV_TGTDEVADDR,
 		    arp_devaddr_compare(&arpinfo->tgt_devaddr, tgt_devaddr,
 					dev->addr_len)))
diff --git a/net/ipv4/netfilter/arpt_mangle.c b/net/ipv4/netfilter/arpt_mangle.c
index a4e07e5e9c11..285b1123b05c 100644
--- a/net/ipv4/netfilter/arpt_mangle.c
+++ b/net/ipv4/netfilter/arpt_mangle.c
@@ -40,6 +40,10 @@ target(struct sk_buff *skb, const struct xt_action_param *par)
 	}
 	arpptr += pln;
 	if (mangle->flags & ARPT_MANGLE_TDEV) {
+		if (IS_ENABLED(CONFIG_FIREWIRE_NET) &&
+		    arp->ar_hrd == htons(ARPHRD_IEEE1394))
+			return NF_DROP;
+
 		if (ARPT_DEV_ADDR_LEN_MAX < hln ||
 		   (arpptr + hln > skb_tail_pointer(skb)))
 			return NF_DROP;
@@ -47,6 +51,10 @@ target(struct sk_buff *skb, const struct xt_action_param *par)
 	}
 	arpptr += hln;
 	if (mangle->flags & ARPT_MANGLE_TIP) {
+		if (IS_ENABLED(CONFIG_FIREWIRE_NET) &&
+		    arp->ar_hrd == htons(ARPHRD_IEEE1394))
+			return NF_DROP;
+
 		if (ARPT_MANGLE_ADDR_LEN_MAX < pln ||
 		   (arpptr + pln > skb_tail_pointer(skb)))
 			return NF_DROP;
-- 
2.47.3

