Received: from cmccmta8.chinamobile.com (cmccmta8.chinamobile.com [111.22.67.151])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5524B3B9927;
	Thu,  8 Oct 2026 05:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=111.22.67.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791438176; cv=none; b=Iuigxkb7bLVSUYXEQVbwxpnmG9RXD1QzS4fK0PVsjrmF48hIMIWR8fz+MsEzI7rJGMXAsulGlqPJsZKkUzFE4sdKyDr4uvU7CnBXmAq5ZegRmfSZpEdVuVQHSwsLfoytcNK1qzNIi3oZr4ux764LcICeKrFL6eAirGYmVvKob1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791438176; c=relaxed/simple;
	bh=ygZeOiN67Rzk+FnquSronkA+wHQJCrOrkL8Gahj1UQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=c4d9Oor29Ou9UtNrnXTo5d0XYYZgKk3QqclmPUtn51avSZizLSS2y6IrScvU1kc0XPIImACwQlJ4xrRCx/uaYAwy8vBE7jSCX21MJJwZ0WM9DwNhBPCX699OU2KNs/Upb28sn1cMiweMWL4wS3RzrXPj6R90/NNZsJu8oCEBj8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmss.chinamobile.com; spf=pass smtp.mailfrom=cmss.chinamobile.com; dkim=pass (1024-bit key) header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.b=hLWiwyjd; arc=none smtp.client-ip=111.22.67.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.b="hLWiwyjd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=cmss.chinamobile.com; s=default; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=hLWiwyjdjz2A3l2lUmL+95cC6Q+rIBZnqySrLLGV/TzpXXdJAbOaAFAKRDLM3bJcTUbHGKyXy/y6B
	 cMeo3oAUYWCLU8zx3zD0PqZjZu/swpjy2jsQb3fi8OmtX03pFev+JHevtZmdKHrHgjRHZg+xGIId90
	 CLuJ6QIW4aRzokBk=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from spf.mail.chinamobile.com (unknown[10.188.0.87])
	by rmmx-syy-dmz-app02-12002 (RichMail) with SMTP id 2ee26ac72d4e7cb-eda89;
	Thu, 08 Oct 2026 13:42:42 +0800 (CST)
X-RM-TRANSID:2ee26ac72d4e7cb-eda89
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from localhost.localdomain (unknown[223.108.79.99])
	by rmsmtp-syy-appsvr01-12001 (RichMail) with SMTP id 2ee16ac72d4794b-e52a2;
	Thu, 08 Oct 2026 13:42:42 +0800 (CST)
X-RM-TRANSID:2ee16ac72d4794b-e52a2
From: lvjunyu <lvjunyu@cmss.chinamobile.com>
To: pablo@netfilter.org
Cc: fw@strlen.de,
	phil@nwl.cc,
	netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	lvjunyu <lvjunyu@cmss.chinamobile.com>
Subject: [PATCH v3] netfilter: nf_nat: Fix stale outer UDP checksum on VXLAN encapsulated packets
Date: Thu,  8 Oct 2026 13:42:28 +0800
Message-ID: <20261008054228.752274-1-lvjunyu@cmss.chinamobile.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When MASQUERADE --random-fully rewrites the outer UDP source port and
address of a VXLAN-encapsulated packet whose inner header has
CHECKSUM_PARTIAL, the outer UDP checksum is not updated correctly.

udp_set_csum() takes the LCO (Local Checksum Offload) branch for
encapsulated CHECKSUM_PARTIAL non-GSO packets, writing a complete
(folded and complemented) checksum into uh->check while leaving
csum_start pointing at the inner transport header.  In this state:

  - inet_proto_csum_replace2() is a no-op (pseudohdr=false,
    CHECKSUM_PARTIAL)
  - nf_csum_update() -> inet_proto_csum_replace4(pseudohdr=true)
    takes the pseudo-header branch which treats uh->check as an
    uncomplemented seed, applying the address delta with the wrong
    sign

Fix this by using the offload target (csum_start + csum_offset) to
distinguish the LCO state from the seed/offload state, and temporarily
flipping ip_summed to CHECKSUM_NONE so both the address and port updates
use csum_replace*() (the complete-checksum path).

Test results (10 connections, single netns vxlan + veth environment):
  Before fix: ~1080ms avg first-connection latency, 10 SYN retransmits,
              UdpInCsumErrors incremented per connection
  After fix:  ~29ms avg first-connection latency, 0 SYN retransmits,
              UdpInCsumErrors unchanged

Fixes: faec18dbb0405 ("netfilter: nat: remove l4proto->manip_pkt")
Cc: stable@vger.kernel.org
Signed-off-by: lvjunyu <lvjunyu@cmss.chinamobile.com>

---

Changes in v3:
- Reword comment to distinguish port delta (no-op) from address
  delta (wrong sign) as suggested by Sashiko AI review

Changes in v2:
- Fix both address and port delta (v1 only fixed port delta)
- Use offload-target test instead of skb->encapsulation as the LCO
  discriminator (addresses Sashiko AI review feedback)
- Update comment to describe both CHECKSUM_PARTIAL states

v2: https://lore.kernel.org/netdev/20260921130312.686493-1-lvjunyu@cmss.chinamobile.com/
---
 net/netfilter/nf_nat_proto.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/net/netfilter/nf_nat_proto.c b/net/netfilter/nf_nat_proto.c
index 64b9bac228e..6779e9f2812 100644
--- a/net/netfilter/nf_nat_proto.c
+++ b/net/netfilter/nf_nat_proto.c
@@ -54,9 +54,39 @@ __udp_manip_pkt(struct sk_buff *skb,
 		portptr = &hdr->dest;
 	}
 	if (do_csum) {
+		/* When udp_set_csum() takes the LCO branch (encapsulated
+		 * CHECKSUM_PARTIAL, non-GSO), uh->check holds a complete
+		 * (folded and complemented) checksum while csum_start
+		 * points at the inner transport header, not at this outer
+		 * udphdr.  In that state:
+		 *   - nf_csum_update() -> inet_proto_csum_replace4(pseudohdr=true)
+		 *     takes the pseudo-header branch and applies the address
+		 *     delta with the wrong sign (to an uncomplemented seed).
+		 *   - inet_proto_csum_replace2(pseudohdr=false) is a no-op:
+		 *     neither branch is taken for CHECKSUM_PARTIAL when
+		 *     pseudohdr is false.
+		 * Temporarily flip ip_summed so both use the csum_replace*()
+		 * path that correctly updates the complete checksum.
+		 *
+		 * The seed/offload branch of udp_set_csum() sets csum_start
+		 * to the outer UDP header, so the offload-target test
+		 * below distinguishes the two states.
+		 */
+		bool lco = skb->ip_summed == CHECKSUM_PARTIAL &&
+			   !skb_is_gso(skb) &&
+			   (skb->head + skb->csum_start + skb->csum_offset) !=
+			   (unsigned char *)&hdr->check;
+
+		if (lco)
+			skb->ip_summed = CHECKSUM_NONE;
+
 		nf_csum_update(skb, iphdroff, &hdr->check, tuple, maniptype);
 		inet_proto_csum_replace2(&hdr->check, skb, *portptr, newport,
 					 false);
+
+		if (lco)
+			skb->ip_summed = CHECKSUM_PARTIAL;
+
 		if (!hdr->check)
 			hdr->check = CSUM_MANGLED_0;
 	}
--
2.43.0



