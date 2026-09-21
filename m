Received: from cmccmta8.chinamobile.com (cmccmta8.chinamobile.com [111.22.67.151])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A129490C08;
	Tue, 22 Sep 2026 05:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=111.22.67.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790056657; cv=none; b=E3e7vFtSyDmg1VLbyDQ6P+cvcinb61MCA+MdBJ3g9tueWAmyGN5rosXHl3zMWdqXSDCV8Nws/C5P7pN1Tsr8paKG7uGM44BTg+70Bk2rw8Pit5iyqxcNBh3t+pFbzU5rwxfFp3Z7a82Ustol0mdipXdJa45Mv+9be7mvh5eoWYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790056657; c=relaxed/simple;
	bh=QfiaBWqjN5vkZ0yP5ONXEOxCZ5+I4WD1PG33vC4TwHM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iCVwuJuoCX4YrbrBDEUxopbEPIepk/FtUdO9PwynKmr8sebamMeNz6Wh5Qz64DldOvngDnL9gS6/nvGRN4gW8nbR4c0CLO7TY/0MTsVezYq2F+qlrs5Y6cmLhoQJyFXdEZjnbW8Q63rbLndNCguy16nw/yH5x10dVZN4NVkMgk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmss.chinamobile.com; spf=pass smtp.mailfrom=cmss.chinamobile.com; dkim=pass (1024-bit key) header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.b=rjC9+pcJ; arc=none smtp.client-ip=111.22.67.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.b="rjC9+pcJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=cmss.chinamobile.com; s=default; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=rjC9+pcJw0yFaVyW1ol0SOxKBEmvWrs+94XlcGAfm0Oj1iM9/9DvjM5v6wrDSTZ6ZK29NrIxUKwNO
	 62ouHIyaMcCwgYrUzcou3uuJkT4vEEIcGjEEY8bhYyKsKr2JCXWabM5mk+AyuY9dbt6xD8niC0qX1c
	 AdTk/Id6pbIP/ryg=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from spf.mail.chinamobile.com (unknown[10.188.0.87])
	by rmmx-syy-dmz-app06-12006 (RichMail) with SMTP id 2ee66ab2180d0e8-19fe7;
	Tue, 22 Sep 2026 13:54:22 +0800 (CST)
X-RM-TRANSID:2ee66ab2180d0e8-19fe7
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from localhost.localdomain (unknown[223.108.79.102])
	by rmsmtp-syy-appsvr01-12001 (RichMail) with SMTP id 2ee16ab21803bbe-a69b4;
	Tue, 22 Sep 2026 13:54:22 +0800 (CST)
X-RM-TRANSID:2ee16ab21803bbe-a69b4
From: lvjunyu <lvjunyu@cmss.chinamobile.com>
To: pablo@netfilter.org
Cc: fw@strlen.de,
	phil@nwl.cc,
	netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	lvjunyu <lvjunyu@cmss.chinamobile.com>
Subject: [PATCH v2] netfilter: nf_nat: Fix stale outer UDP checksum on VXLAN encapsulated packets
Date: Mon, 21 Sep 2026 21:03:12 +0800
Message-ID: <20260921130312.686493-1-lvjunyu@cmss.chinamobile.com>
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

Changes in v2:
- Fix both address and port delta (v1 only fixed port delta)
- Use offload-target test instead of skb->encapsulation as the LCO
  discriminator (addresses Sashiko AI review feedback)
- Update comment to describe both CHECKSUM_PARTIAL states

v1: https://lore.kernel.org/netdev/20260920074543.525572-1-lvjunyu@cmss.chinamobile.com/
---
 net/netfilter/nf_nat_proto.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/net/netfilter/nf_nat_proto.c b/net/netfilter/nf_nat_proto.c
index 64b9bac228e..cb70d85716b 100644
--- a/net/netfilter/nf_nat_proto.c
+++ b/net/netfilter/nf_nat_proto.c
@@ -54,9 +54,35 @@ __udp_manip_pkt(struct sk_buff *skb,
 		portptr = &hdr->dest;
 	}
 	if (do_csum) {
+		/* When udp_set_csum() takes the LCO branch (encapsulated
+		 * CHECKSUM_PARTIAL, non-GSO), uh->check holds a complete
+		 * (folded and complemented) checksum while csum_start
+		 * points at the inner transport header, not at this outer
+		 * udphdr.  In that state, inet_proto_csum_replace*() and
+		 * nf_csum_update() take the pseudo-header branch which
+		 * operates on an uncomplemented seed, applying the address
+		 * and port deltas with the wrong sign.  Temporarily flip
+		 * ip_summed so they use csum_replace*() instead.
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



