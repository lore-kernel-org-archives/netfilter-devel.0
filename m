Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5254D39F17E;
	Fri, 17 Apr 2026 09:14:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776417274; cv=none; b=lAkoeavvUm4rIuS8az1CUI+hNDBRa3t3rIK9VYO/fRKav+nIOLtcvDtZlaftzMxNscwJNZHlbXKjBQBarRp6gntdj9G/zNy7eITH+98TXHo51bn0y20f4Oqhlprcg6HGi7lItri0MzqapyLrS7eaMG1D+ysL0MKruKdQdvpqMoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776417274; c=relaxed/simple;
	bh=apBX6wAZOFpRvuTkgStG4E5Tw2QnsWLT7AZqsMqkY9U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=b03o7Q3iom9t33SbSRDiWJqOdDwF0UQaTdd8zmg7iEANA+OmIeuMNCvAUvJ6NFbNhHn5aAkqmXqmw0zdfFYws19NqmLP+KVVJ21uEST7+nKU6Aw4d/LQWudxh3sxTnlY2seqGXmN6mMUkqudK7C0a8WS9uMap+rKOojBTdwPVUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=OUGxnpAz; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="OUGxnpAz"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id DF52760253;
	Fri, 17 Apr 2026 11:14:29 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1776417270;
	bh=v7CyyGXbXFYajaxKcvL6QvbWbXVdB61An37V9m/xwWY=;
	h=From:To:Cc:Subject:Date:From;
	b=OUGxnpAzOuTyUNI4n8jiLN3DDmuyCUZ2r+GHBXCIMHlRr+ENNSpr+ntAlBPMT+buW
	 vK+3LmyhfsaTL5Cdb/48dV1vd+EHHhOsdPBeiT6XGC59KRe9w4sARTFIVKCC5LGrLv
	 38Hfkzx31oYtfx9Hwwr5PZskWc8d1NqnJHAWXTZaG6Aut8pjeLF/Prtg5jqWohPqQ+
	 4aPxGOaiPQd6CFaYmKJCDcElO6gun//MoCraO0cTChfaWfOJUBUo1sM1fPdvI9KC5E
	 msxLY268hl+UFRFX/gEJ7w1OumV6gzJSgKaQ4q28uRCuDIPtduCjHU3nZeIk84qhYb
	 2iAm/e0XUW8qQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de,
	netdev@vger.kernel.org
Subject: [PATCH nf,v2] netfilter: arp_tables: fix IEEE1394 ARP payload parsing in arp_packet_match()
Date: Fri, 17 Apr 2026 11:14:22 +0200
Message-ID: <20260417091422.342615-1-pablo@netfilter.org>
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

Moreover, adjust arpt_mangle too as AI suggests:

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
v2: addressing AI suggestions.

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

