Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B189C3BD246;
	Thu, 16 Apr 2026 13:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776345305; cv=none; b=Ww9l7LK91gHr+FZacMXaGh4HPiR/sZ1L3R6/5R9BL/oPA/Pt2AHhSaa3pMV3XqRLuIzSkvK1vW4jjzsAJeUwaP+ioK3Ymt/udrMwVrb5/soz8FDhy413pBJDHPTNbnDD1sXDJU/ZsHzp14908SVauWImnoM5nQlwca1E8JNEXAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776345305; c=relaxed/simple;
	bh=E+TqY3nur+I/j7EktcUsc/tC9j0NrLrhL7r3Z7S4k0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iCtaNXMtoZq415nenhB0EQoKhwgydXLHV6Y3gtMDBK4b60vHTTg5BtFp1HhWfX/eA3E1vGPwu30V6k9YumVvfIxBkuoqExXYaJaR3Lhxoj0XcOoQzp76vI+DkOTmLB+o/EnJLid9IDxQy7wnNKdbow9dPEggR9z5lAPM7bak+Y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=NgZPu9kl; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="NgZPu9kl"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 51F4060253;
	Thu, 16 Apr 2026 15:15:01 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1776345301;
	bh=UKA+A3aFYBFFgnZcbNAbiR56Du+bLjEnS3Riajgl8fg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NgZPu9klyq8xsRfNTXWB/oar9AdUGeNFczkn5IWtOiSMtBhJdeE8Ft46z1BpGeiSv
	 9JoNTyWRavFYK4QSbXW61SPS2maOkzqC2XEXKOyJqZkMKf8KrmesV5ii32QbmTb/PS
	 GnBJYR8Hib1iYhom2JzprK7CyHQKRBDzWriLgnppWPjMVNz51WlynUa9FopsVGSYQJ
	 BPMatb7MOsm09gSGNz2kiZmg+qTd+8o0PNuFYSZj72fuPj9SRBLz8cYfDeSYEoKcTC
	 sc73LIrCE1jrRzSd7JSOeNk4QmDjesac0EOihgriHwbocZ4Jk+qfCle0+BRSf8nAYt
	 AnRas55T9RX7g==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 01/11] netfilter: arp_tables: fix IEEE1394 ARP payload parsing in arp_packet_match()
Date: Thu, 16 Apr 2026 15:14:43 +0200
Message-ID: <20260416131453.308611-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260416131453.308611-1-pablo@netfilter.org>
References: <20260416131453.308611-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Weiming Shi <bestswngs@gmail.com>

arp_packet_match() unconditionally parses the ARP payload assuming two
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
ARPHRD_IEEE1394. Apply the same pattern to arp_packet_match().

[ Pablo has mangled this patch to include Simon Horman's suggestions ]

Fixes: 6752c8db8e0c ("firewire net, ipv4 arp: Extend hardware address and remove driver-level packet inspection.")
Reported-by: Xiang Mei <xmei5@asu.edu>
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter/arp_tables.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 1cdd9c28ab2d..a7a56890b5b5 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -110,13 +110,21 @@ static inline int arp_packet_match(const struct arphdr *arphdr,
 	arpptr += dev->addr_len;
 	memcpy(&src_ipaddr, arpptr, sizeof(u32));
 	arpptr += sizeof(u32);
-	tgt_devaddr = arpptr;
-	arpptr += dev->addr_len;
+
+	if (IS_ENABLED(CONFIG_FIREWIRE_NET) && dev->type == ARPHRD_IEEE1394) {
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
-- 
2.47.3

