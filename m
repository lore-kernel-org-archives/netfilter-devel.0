Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A29042E3B15
	for <netfilter-devel@vger.kernel.org>; Mon, 20 Apr 2026 19:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776713580; cv=none; b=NtlSNcDmJ7fkq+HXA0XHfXtPMrCyZAboDRw8tKhHLBBAc8qC29ajCG8Kf+bdw0UrdqY7THDQ3cOxNPO/nUMR/ME7K8rTNou5ceC3GgAyXDi42L5YiUrtCC8tR8fxXFUSz1uOAgRxIrrJ+e0YCJ6lnU00wrNSJT4BqaKsWwptT8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776713580; c=relaxed/simple;
	bh=1aFBGsHaUFIm1HGicmIAFfnCNCAUwkz3a3TCJSg1tz8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HvMSOkx+vVP4wEvzYdnJH+ZaANSqRkfO62kor1K/Jay9My/OJ5ae4tlV8HaArnU72fjMBNjDBLwaPritjzjjPyN9sw4vPSYpF1zCEUWqfHhxAJ/Gir9Bq/sli5OIpsMZyIlxxNOZiW/sa3aORQgaa73ict6GsMmVQ3EPTTx02ZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=G3KdVpsh; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="G3KdVpsh"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id C312C60178;
	Mon, 20 Apr 2026 21:32:56 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1776713577;
	bh=uTPZI1TJNrdtr/OhcusNyAp/cMoRDRS6dLigtdMIrcs=;
	h=From:To:Cc:Subject:Date:From;
	b=G3KdVpshF1t5eTIfzsblOSAhjQjr6Tfd8/ILm5rPA58bp5vGJGYINCe+I96mmuE7D
	 LKXwumJ0YpC2FZoa7Mg6Ms4DsYUIdHLBlWqqg2tcV31aMUqQHf21Dbghax4jqnuIa7
	 ARm91C8C+SsGjXqnaUhA2N62eblWxgX4bkgdZIQtOSTIW2GtokKEzaHTZJMx9e8BUh
	 egKj0zbcPAZn85VHt1JUSsnAO6nRXHQsfyQGJHXaB96fGBcrrSAcBbGw98ie5Vz06u
	 rl3qZFvhw4rsei9OdEb/YY1WARib2oFrT7nRILeGj7NDS30EyQMC15c2CKYuJ+Ra7u
	 Es1fxaW+Zwjkw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: [PATCH nf,v3] netfilter: arp_tables: fix IEEE1394 ARP payload parsing
Date: Mon, 20 Apr 2026 21:32:53 +0200
Message-ID: <20260420193253.33042-1-pablo@netfilter.org>
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

Mangle the original patch to always return 0 (no match) in case user
matches on the target hardware address which is never present in
IEEE1394.

Note that this returns 0 (no match) for either normal and inverse match
because matching in the target hardware address in ARPHRD_IEEE1394 has
never been supported by arptables. This is intentional, matching on the
target hardware address should never evaluate true for ARPHRD_IEEE1394.

Moreover, adjust arpt_mangle to drop the packet too as AI suggests:

In arpt_mangle, the logic assumes a standard ARP layout. Because
IEEE1394 (FireWire) omits the target hardware address, the linear
pointer arithmetic miscalculates the offset for the target IP address.
This causes mangling operations to write to the wrong location, leading
to packet corruption. To ensure safety, this patch drops packets
(NF_DROP) when mangling is requested for these fields on IEEE1394
devices, as the current implementation cannot correctly map the FireWire
ARP payload.

This omits both mangling target hardware and IP address. Even if IP
address mangling should be possible in IEEE1394, this would require
to adjust arpt_mangle offset calculation, which has been never
supported.

Based on patch from Weiming Shi <bestswngs@gmail.com>.

Fixes: 6752c8db8e0c ("firewire net, ipv4 arp: Extend hardware address and remove driver-level packet inspection.")
Reported-by: Xiang Mei <xmei5@asu.edu>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v3: Only changes in the commit title and description to make AI happy.

Added this paragraph:

Note that this returns 0 (no match) for either normal and inverse match
because matching in the target hardware address in ARPHRD_IEEE1394 has
never been supported by arptables. This is intentional, matching on the
target hardware address should never evaluate true for ARPHRD_IEEE1394.

AI says:

"Does returning 0 unconditionally here break inverted target MAC matches?
If a rule specifies an inverted match (e.g., ! --tgt-mac AA:BB:CC:DD:EE:FF),
a FireWire packet lacking a target MAC logically satisfies the condition
and should continue rule evaluation. Unconditionally returning 0 forces
the inverted match to fail, which could allow FireWire packets to bypass
restrictive firewall policies."

Answer: No, matching in target mac address in IEEE1394 makes absolutely
no sense, and it should never ever evaluate true neither normal or inverse
match. Such field is not present.

arptables has not ever supported IEEE1394 intentionally, this patch is not
intending to add support for ARP IEEE1394 to arp_tables.

 net/ipv4/netfilter/arp_tables.c  | 18 +++++++++++++++---
 net/ipv4/netfilter/arpt_mangle.c |  8 ++++++++
 2 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 1cdd9c28ab2d..97ead883e4a1 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -110,13 +110,25 @@ static inline int arp_packet_match(const struct arphdr *arphdr,
 	arpptr += dev->addr_len;
 	memcpy(&src_ipaddr, arpptr, sizeof(u32));
 	arpptr += sizeof(u32);
-	tgt_devaddr = arpptr;
-	arpptr += dev->addr_len;
+
+	if (IS_ENABLED(CONFIG_FIREWIRE_NET) && dev->type == ARPHRD_IEEE1394) {
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
index a4e07e5e9c11..f65dd339208e 100644
--- a/net/ipv4/netfilter/arpt_mangle.c
+++ b/net/ipv4/netfilter/arpt_mangle.c
@@ -40,6 +40,10 @@ target(struct sk_buff *skb, const struct xt_action_param *par)
 	}
 	arpptr += pln;
 	if (mangle->flags & ARPT_MANGLE_TDEV) {
+		if (unlikely(IS_ENABLED(CONFIG_FIREWIRE_NET) &&
+			     skb->dev->type == ARPHRD_IEEE1394))
+			return NF_DROP;
+
 		if (ARPT_DEV_ADDR_LEN_MAX < hln ||
 		   (arpptr + hln > skb_tail_pointer(skb)))
 			return NF_DROP;
@@ -47,6 +51,10 @@ target(struct sk_buff *skb, const struct xt_action_param *par)
 	}
 	arpptr += hln;
 	if (mangle->flags & ARPT_MANGLE_TIP) {
+		if (unlikely(IS_ENABLED(CONFIG_FIREWIRE_NET) &&
+			     skb->dev->type == ARPHRD_IEEE1394))
+			return NF_DROP;
+
 		if (ARPT_MANGLE_ADDR_LEN_MAX < pln ||
 		   (arpptr + pln > skb_tail_pointer(skb)))
 			return NF_DROP;
-- 
2.47.3

