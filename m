Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.227.132
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795877111;
	b=jonG4k7y0XC3UJTK6u4LWNHuTI0G+4KzeO74F4Ml/TpPZx4nfME082l6XdSeEDO7EQhO
	 5qvoj6SZ1DrlR35sfAwXR2l2McAv+b74Rln661rowVZQwbl9T+FzhH67ws7T9ESMcyvlt
	 n0VwkGRd6UJps5HHdQ5sfpMOS+zmIs3xEIrPtZQxacGNYqSFqtggEjtwiAZ6u5PlUTc2g
	 x+nfg5bZQK56xgamZt28nDw2MKBksRcD69g5x/aBvJpYO9xkcIDqauCorasTLMxqLEeLP
	 hXcNQccu5HzvhQm07ezGOd1Ae1Y8T+I0oMQSUnUrgPT2qLmn3pP5ARawffCtCCrlUoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795877111;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=yYzGGwI5EbgAAj/SOn20ulTMZQ+hqedEJnub6nNYwrI=;
	b=kl5AVStNNH8TlGl3ahU1pIYSQDgNTE5FNncua11ZlC0kvA++ZODzAFi/W1xx17h35bId
	 zMvOMBae+p7eDW9yfmU02m/n6vgNh16cLToL/XMHcjZWVCKNQGpOS1SIwXuBj3t3c+FhK
	 XhJJb/vIwk6gaSib9GWBaGY/RiEdgXEG0+q6Rp9ARE/HyKBkqcRd1KutWskPe81vxxhWX
	 yrwS3a18VjSztHr+2HKVjw2Y2Hg8ieI+rPM3nC65X/5VCR8FLFU0ZW/pPEAaJII5hw9Ao
	 4Uz9tz7CRt9/YgOCm1ocqXIWAEf2l/r/d5Zw/ngpOR43KVYkO5/RrHtkSBz2Sez9ufw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=f5Ikc0j2;
	arc=none smtp.remote-ip=74.125.227.132
Received: from mail-pj2-f4.google.com (mail-pj2-f4.google.com [74.125.227.132])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 778F5606A323
	for <netfilter-devel@vger.kernel.org>; Sat, 28 Nov 2026 14:45:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 778F5606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=f5Ikc0j2
Received: by mail-pj2-f4.google.com with SMTP id d9443c01a7336-2f0440f49f4so61746175ad.0
        for <netfilter-devel@vger.kernel.org>; Sat, 28 Nov 2026 06:45:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795877110; x=1796481910; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=yYzGGwI5EbgAAj/SOn20ulTMZQ+hqedEJnub6nNYwrI=;
        b=f5Ikc0j2v2pFZM0WwyInT2c7aCfYqJz8kDfU8fBjRpkBqDwuO4YdXUHal05a4qkF9T
         AD2wmjdDMR/3XwfO5vU1P0MWw+vB+gGW+tboGT2c5SBBQgBzXEx86MSmd6Qrzp29fkxp
         PTjjvDf8oep726sMLOKvcvzpRUOcrOwholUndk7q8L9UgaB0hOrNeTiKiQ/wqNHOYssn
         Jf0z88ovj9MvIfWp5nYEEcpvnJ1IYpcqJOpGQYWrfZW76vWisF6ugUHmSsakCVuikD/U
         FfdDDkVRleEVoHkRKAKRvq3kSkZm1Jf/cgpYp61J3KXW5Qot1Chk+pSQr4WG4MBBJRrk
         dOpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795877110; x=1796481910;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yYzGGwI5EbgAAj/SOn20ulTMZQ+hqedEJnub6nNYwrI=;
        b=QrrN60DZWqTrNzJ6ScBCGy1nGATE9F+GCxN4fho5H/q1il7eqLYhPJMl4oaqWU1xH4
         qd/9+R6ijb5v9c2BQVSy53PA13xQvUWHN1UNZJY9cIhE5HX2i3aUlgg3ht6HpH4LHBUe
         OG0iRutGCyNSkesF59+T7suDBZsn9P9MENQuMz0oNvSBsWzQbG9cfNCr0FcMX1NO5u6Y
         8VQe2uLETVpGSeNbDIQsVd/mjvzdkPqrPRmCBCu+X9ACPzYF2zZr24HlEmbRTahE5Ehu
         DbizlYm5/8+p9oq8+RBG1yr/qv0Gx3SWhy5uO2+9eq3FP802ytu3aoTf8S4GOpSNojzk
         oHKA==
X-Forwarded-Encrypted: i=1; AL+hErF3niw0CT9npSFODU3Xmt3djmGWM3puSffpvEGAyH+N2bGfJnS3WXRJl2UdJ7UitQc2EZ2N6yPv6QbS+eCkrsE=@vger.kernel.org
X-Gm-Message-State: APuU4Z9RZv4io8CtTCTX0UvQIR6plhPKyagnRTTwY8LFZT/9kMWO34xV
	OAGSdwYRMvXclD8dzDNUvsLkxoMP+MG+79S4Whn5QLBpzBPAPJbVMsDf
X-Gm-Gg: AZFdTZc/Et6kBo0Yoj02ezH6v54O8gdRAr3K+ieGIgffqRzeywb25dQXrvfRhxQpHLt
	sJzc5zJNx93NN09ggDqLubEWfPXhIB/5UgwzcoFvaYvDBY/yUbcFtGREtpxB3/bXhu56PcsP1xJ
	cqDyU43rqt8sWUKElnidqQ2AUFCrSBAyWb0YQJUcqKm80x80ah80Pjud0hnpiiLRODO/g3wF7u7
	Ayd7xaoQUTqw6WkaQaOM7FdhpYAiWcm00YUh9VPhG54BW2plQ4BNcvxcCbKRC7mItD1lWhl58o6
	toL62wvX/D5exZyjC5CL5tzP7q1xqrnO9iXHnt39MI9bPmICEvTlHcgYHKD/80vDicTEL2sgjoB
	3U2lCeOuRXFsUJXxmmISqc5pgJDQLqIAhAA7dyFpZp8mdTaPefVau+LjjVQf+zdD+sAq/s11uuM
	kYOli9Q0THlnFvbJpp039eNVDiYK54zppUqXihx2Ra/ChhBb+urqbiei7DywQfrE/nn95TH5d3R
	t/6+Jlef2t2HAA3dGtHLDLk4RZuI06J31bWVMxWsciIcT/rQMFreS62JDeVk25h2BhEtfCzoXqk
	/2Qf1AgDHEQzQtPDcewWDDq+C8jH5YA7jUpEnBtdHrpUctcNe7jL8td3ucY94b8P5hgGhc6pBQ=
	=
X-Received: by 2002:a17:903:2285:b0:2f0:41c7:9a40 with SMTP id d9443c01a7336-2f041c7b268mr303096595ad.4.1795877109640;
        Sat, 28 Nov 2026 06:45:09 -0800 (PST)
Received: from BSDHENRYMA-PC1.localdomain ([43.132.141.31])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cdec1168866sm4926108a12.25.2026.11.28.06.45.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Nov 2026 06:45:09 -0800 (PST)
From: Henry Martin <bsdhenrymartin@gmail.com>
To: David Ahern <dsahern@kernel.org>,
	Ido Schimmel <idosch@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemb@google.com>,
	Simon Horman <horms@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	Peter Oskolkov <posk@google.com>
Cc: netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	Henry Martin <bsdhenrymartin@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH net] netfilter: ipv6: fix out-of-bounds write in fragment reassembly
Date: Sat, 28 Nov 2026 22:44:37 +0800
Message-ID: <20261128144437.819730-1-bsdhenrymartin@gmail.com>
X-Mailer: git-send-email 2.53.0
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

nf_ct_frag6_queue() trusts the on-wire payload_len, which IPV6_HDRINCL
lets diverge from the real packet length.  A fragment whose payload_len
is smaller than its extension header chain yields end < offset.  Only
end == offset was rejected, pskb_trim_rcsum() takes the negative length
as a huge unsigned value and does not trim, and the lying fragment is
queued as is.

inet_frag_queue_insert() walks the rb-tree by offset, so a fragment with
end < offset lands on the wrong side and breaks the invariant that
rb_first() is the first fragment.  When the queue completes,
nf_ct_frag6_reasm() mistakes a small later fragment for the head and
stores the trailing nexthdr byte at
skb_network_header(skb)[fq->nhoffset].  nhoffset is controlled through
the extension header chain and can point far beyond the head buffer.

The result is a one-byte controlled out-of-bounds write past a heap
object, which corrupts neighbouring slab objects and panics the kernel,
e.g. on mainline v7.4.0-rc4 (KASAN build):

 Oops: general protection fault, probably for non-canonical address
 0xed6d696d6d6d6d6d: 0000 [#1] SMP KASAN NOPTI
 CPU: 0 UID: 1000 PID: 78 Comm: poc Tainted: G        W
 RIP: 0010:skb_release_data+0x1e7/0x640
 Call Trace:
  <IRQ>
  sk_skb_reason_drop+0xbd/0x320
  nf_ct_frag6_gather+0x13f2/0x28a0
  ipv6_defrag+0xa6/0x190
  nf_hook_slow+0xa5/0x1c0
  ipv6_rcv+0x147/0x260
 Kernel panic - not syncing: Fatal exception in interrupt

Fix the class rather than a single comparison:

 * reject a payload_len that promises more than the skb holds before it
   is used to derive end;
 * reject end <= offset right after the range check and before the
   MF/LAST_IN state machine, so a dropped fragment cannot leave
   fq->q.len and INET_FRAG_LAST_IN modified;
 * apply the same ordering to ip6_frag_queue() and ip_frag_queue(),
   which share the check and the rb-tree invariant.

end == offset was already rejected; end < offset is never a valid
fragment.

This issue was discovered by Tencent CodeBuddy Security.

Cc: stable@vger.kernel.org
Fixes: fa0f527358bd9 ("ip: use rb trees for IP frag queue.")
Signed-off-by: Henry Martin <bsdhenrymartin@gmail.com>
---
 net/ipv4/ip_fragment.c                  | 13 +++++++++++--
 net/ipv6/netfilter/nf_conntrack_reasm.c | 18 +++++++++++++++---
 net/ipv6/reassembly.c                   | 17 ++++++++++++++---
 3 files changed, 40 insertions(+), 8 deletions(-)

diff --git a/net/ipv4/ip_fragment.c b/net/ipv4/ip_fragment.c
index 0688be8142c4b..3cc12e8b1786b 100644
--- a/net/ipv4/ip_fragment.c
+++ b/net/ipv4/ip_fragment.c
@@ -294,6 +294,17 @@ static int ip_frag_queue(struct ipq *qp, struct sk_buff *skb, int *refs)
 	end = offset + skb->len - skb_network_offset(skb) - ihl;
 	err = -EINVAL;
 
+	/* A fragment must carry at least one byte after its IP header,
+	 * otherwise end < offset and the rb-tree ordering breaks.  Reject
+	 * before touching any qp state.
+	 */
+	if (end <= offset)
+		goto discard_qp;
+
+	/* tot_len must fit in the skb; IP_HDRINCL lets it diverge. */
+	if (ntohs(ip_hdr(skb)->tot_len) > skb->len - skb_network_offset(skb))
+		goto discard_qp;
+
 	/* Is this the final fragment? */
 	if ((flags & IP_MF) == 0) {
 		/* If we already have some bits beyond end
@@ -317,8 +328,6 @@ static int ip_frag_queue(struct ipq *qp, struct sk_buff *skb, int *refs)
 			qp->q.len = end;
 		}
 	}
-	if (end == offset)
-		goto discard_qp;
 
 	err = -ENOMEM;
 	if (!pskb_pull(skb, skb_network_offset(skb) + ihl))
diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index f25ff2a12a824..953eb25e440c7 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -184,6 +184,14 @@ static int nf_ct_frag6_queue(struct frag_queue *fq, struct sk_buff *skb,
 
 	payload_len = ntohs(ipv6_hdr(skb)->payload_len);
 
+	/* IPV6_HDRINCL allows payload_len to differ from the real packet
+	 * length.  Never let it promise more than the skb actually holds.
+	 */
+	if (payload_len + sizeof(struct ipv6hdr) > skb->len) {
+		pr_debug("payload_len exceeds skb length.\n");
+		goto err;
+	}
+
 	offset = ntohs(fhdr->frag_off) & ~0x7;
 	end = offset + (payload_len -
 			((u8 *)(fhdr + 1) - (u8 *)(ipv6_hdr(skb) + 1)));
@@ -193,6 +201,13 @@ static int nf_ct_frag6_queue(struct frag_queue *fq, struct sk_buff *skb,
 		return -EINVAL;
 	}
 
+	/* A fragment must carry at least one byte after its fragment
+	 * header, otherwise end < offset and the rb-tree ordering breaks.
+	 * Reject before touching any fq state.
+	 */
+	if (end <= offset)
+		goto err;
+
 	ecn = ip6_frag_ecn(ipv6_hdr(skb));
 
 	if (skb->ip_summed == CHECKSUM_COMPLETE) {
@@ -236,9 +251,6 @@ static int nf_ct_frag6_queue(struct frag_queue *fq, struct sk_buff *skb,
 		}
 	}
 
-	if (end == offset)
-		goto err;
-
 	/* Point into the IP datagram 'data' part. */
 	if (!pskb_pull(skb, (u8 *) (fhdr + 1) - skb->data)) {
 		pr_debug("queue: message is too short.\n");
diff --git a/net/ipv6/reassembly.c b/net/ipv6/reassembly.c
index 91a65fe673500..2f20b0f745cf5 100644
--- a/net/ipv6/reassembly.c
+++ b/net/ipv6/reassembly.c
@@ -124,6 +124,13 @@ static int ip6_frag_queue(struct net *net,
 	}
 
 	err = -EINVAL;
+
+	/* IPV6_HDRINCL allows payload_len to differ from the real packet
+	 * length.  Never let it promise more than the skb actually holds.
+	 */
+	if (ntohs(ipv6_hdr(skb)->payload_len) + sizeof(struct ipv6hdr) > skb->len)
+		goto discard_fq;
+
 	offset = ntohs(fhdr->frag_off) & ~0x7;
 	end = offset + (ntohs(ipv6_hdr(skb)->payload_len) -
 			((u8 *)(fhdr + 1) - (u8 *)(ipv6_hdr(skb) + 1)));
@@ -138,6 +145,13 @@ static int ip6_frag_queue(struct net *net,
 		return -1;
 	}
 
+	/* A fragment must carry at least one byte after its fragment
+	 * header, otherwise end < offset and the rb-tree ordering breaks.
+	 * Reject before touching any fq state.
+	 */
+	if (end <= offset)
+		goto discard_fq;
+
 	ecn = ip6_frag_ecn(ipv6_hdr(skb));
 
 	if (skb->ip_summed == CHECKSUM_COMPLETE) {
@@ -178,9 +192,6 @@ static int ip6_frag_queue(struct net *net,
 		}
 	}
 
-	if (end == offset)
-		goto discard_fq;
-
 	err = -ENOMEM;
 	/* Point into the IP datagram 'data' part. */
 	if (!pskb_pull(skb, (u8 *) (fhdr + 1) - skb->data))
-- 
2.53.0

