Received: from cmccmta2.chinamobile.com (cmccmta2.chinamobile.com [111.22.67.135])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B05C377004;
	Thu,  8 Oct 2026 03:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=111.22.67.135
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791429557; cv=none; b=tGZ/NAAHOOy7PictgGYNZmS8WRGk9EK0nOAy7J4SP/bNY6knDprIirFrYa5KQ5B4q7dHCf0ZIPQBwxJkeXzRK0gW4O+oCL3yAIRq8IKubv/mnJn+Cx8l/pofy4AcvXwZYDRVbrG4mMrXZxWz82A5YI6JFKVJLUelbOiICyJN+Hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791429557; c=relaxed/simple;
	bh=ygZeOiN67Rzk+FnquSronkA+wHQJCrOrkL8Gahj1UQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZDhBDFPFU1ELw6hiMVZvOdwa52i+NYhAGWoJMaf31y0N6ePO4kiQSuHHFrI0P6rruTwBq/nl0qMx4VFPsmo82ATaE2PdyNEAqeogytiRUMn+NUDNZlqDXc5CGHeAn42lQBvDbWWAJERPQJ1KB4H+HkoLfoZGXUEFoQifa6zsitU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmss.chinamobile.com; spf=pass smtp.mailfrom=cmss.chinamobile.com; dkim=pass (1024-bit key) header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.b=GQBpAUDt; arc=none smtp.client-ip=111.22.67.135
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.b="GQBpAUDt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=cmss.chinamobile.com; s=default; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=GQBpAUDtorvm29I2PbDRVgZks3wqK/2xaJWLcaRHer42TMDW4zAfYTwb/pdePVvJXPgMyFqmuSVY2
	 nUEJe/pNbmSbZo6SQULEPrWGsWBZ3isz3GfumSO8nHKcATR2+3MMmicann56GE+GcZ+SWtMzmNsyz+
	 f0w9zHPgM1CX9rNc=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from spf.mail.chinamobile.com (unknown[10.188.0.87])
	by rmmx-syy-dmz-app07-12007 (RichMail) with SMTP id 2ee76ac70bae06d-b1d6d;
	Thu, 08 Oct 2026 11:19:11 +0800 (CST)
X-RM-TRANSID:2ee76ac70bae06d-b1d6d
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from localhost.localdomain (unknown[223.108.79.99])
	by rmsmtp-syy-appsvr04-12004 (RichMail) with SMTP id 2ee46ac70ba7eb5-03ba6;
	Thu, 08 Oct 2026 11:19:11 +0800 (CST)
X-RM-TRANSID:2ee46ac70ba7eb5-03ba6
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
Date: Tue, 22 Sep 2026 14:23:05 +0800
Message-ID: <20260922062305.752147-1-lvjunyu@cmss.chinamobile.com>
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



