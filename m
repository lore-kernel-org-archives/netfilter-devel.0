Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.227.139
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795876644;
	b=XhxIH0elR5+OoHgd+vARXMw1hqbpbDM/Eh236nDJ/j+bhJq6FgqDnaYoeB8zAkqcpIVH
	 0tDn3L5QdRC4hvyipxBFVJ/q9T7i66L4MaDLCnUJ6aettwDtolC8aF1jYF2AEh75+I5JQ
	 THsjr9RKvq7Ap4XN0BoWjT33Jtbgs3KJtmeJIryXpX5Gp6i1KjTMMjQ7PyhjpArRTHjPz
	 CbnBvJOOXSUw+KucryMXe1ftJjW6XvWItR6oik95/JjBV9+TL+f3tWq7Ersur21e6o+SA
	 iLsWJrmYipd+PopYepBkynTT/KSZWNUQ+8BG2s/HdIB6IMe5ZbhELE3ZN6yEE8W7uYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795876644;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=yYzGGwI5EbgAAj/SOn20ulTMZQ+hqedEJnub6nNYwrI=;
	b=OAwoRKdba3y2oAFyqv30+3Ze+1Y511nctPr+dN1+0nzPhefyPApSgV87G5IsN15N8OmF
	 8mOP0LLCW9qbPZezffmYlaBE2NO5RZW6TW579kmafgVB2JP0gajS5ALzG0wBiNSas6xvB
	 Y4pJOgWXvCUVKNxAPV0x3k49kp5E6dmeItqQCSiZQJdoWU3urIyC+ohPH4JifpNdrm29a
	 8INa9TkBJVJJDtKdu+byfV5i2u2rng6HJFbeNgH3AuGLVQLNbw+LeZT/+kKwqS6Ad7MZT
	 ChnwonaiBaPr6I2jZP5Pa2IWZd3kJUZFLWMPkk3Y+YaEsLhmDgjWbL+gLBIrWKm7+fg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=wc4ZFCqq;
	arc=none smtp.remote-ip=74.125.227.139
Received: from mail-pj2-f11.google.com (mail-pj2-f11.google.com [74.125.227.139])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCAE2606A321
	for <netfilter-devel@vger.kernel.org>; Sat, 28 Nov 2026 14:37:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BCAE2606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=wc4ZFCqq
Received: by mail-pj2-f11.google.com with SMTP id 98e67ed59e1d1-3b3a24f9496so406484a91.1
        for <netfilter-devel@vger.kernel.org>; Sat, 28 Nov 2026 06:37:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795876643; x=1796481443; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=yYzGGwI5EbgAAj/SOn20ulTMZQ+hqedEJnub6nNYwrI=;
        b=wc4ZFCqq3wEvKNv4SIwxw5mdJHFIq7gKHb9bsh6VIY8HbE9Sm0IG5lcCoPgrpDtpX5
         waOsaADDFUIaQGzn5fdhAOkp467/vHWfbFJoS7lJP8R3aYsoOhlQYPKoK3vjyGwf7GVI
         ap1yCNOmftXkcznR3YI4lDboi2ja/+6e+0YYjAqODYysPec4fD0SQeOL04qGOWY4dhn5
         qEkH3SAWB5Ch53hENEy405Nvll31O/sud8DiY1lQA0leQHK1zWoZ4HsJfOOolpMaaamb
         yr6V8hnA22GulbWZ8BQkW3RqNLjxoOlIEuvnpawOJE9ShmQibT/yxqkz8cCxGfvDI9qu
         cOaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795876643; x=1796481443;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yYzGGwI5EbgAAj/SOn20ulTMZQ+hqedEJnub6nNYwrI=;
        b=SFKxqV1XGyBgWUlBtqx35s62uWbjFGDm2dj27RH+6I4C4WllhyUlzGd0kDpxfR3OrG
         ET0fdFuz1s7q/iYBf9DPW8YRpKf28ZRnuVaBVnghbD9XvffThnM3dolq3KGLBOKEz/bU
         z4tO9vjuu3RDxkO10qXQfU8k2i0FPOJP2/i/xC5C+0SWlqoaGJ48gYqJMIeHYk/PyNt+
         CZKgA7tU4xRRiZx0eHTr6ZxzvkL6uLLhqq2nfZRFzbyPukCLVJAi3p4ltJt9yI9Ku6YM
         s/v2dbwLhQ8U9mss3mUrFvRR5xf2tkwASQG8iJPJZC4ZoijwX7m9K8M9CNwHSyPXb0mN
         K9uQ==
X-Forwarded-Encrypted: i=1; AL+hErHsw4ubv79rhjuat5D417ZiGpCNExAY0lXRotaTTbUApYauSYjITeDEKQEPXO5sO5VZSTiMhq8awZgrGqWmc18=@vger.kernel.org
X-Gm-Message-State: APuU4Z/zKZ7HR3v7ZqOUiGkY2MWePFTMoCrUOD+d8GOGft1bAZusWuOm
	s+5Q682NyqbzyWtPqa/Fn2ttRV632zfj3zh7C48i79NZPvKG4SFPqfp2
X-Gm-Gg: AZFdTZfZhpRXPH4mButs5K6L7Fct+O0wu/emckR8kxtZfyJ/8ZNwBo2gUDTavHIST9I
	XanJHkswu3LORvAzM8hlvySvL/ccRdIzJw0VCUYZfIovzt+ERoOXa+aJr4y45Z9ggguQHADrBKm
	kjd9ftwzMbPBaoC+UHnzorbzRnf2m+qzzP23kpI9AFj79N86k/Q0WS44GYcXmmkdxP40ft9cuzk
	6TWEOn5vk759AtxrZU/0slHA4/ATN1hUaLC44GyRiLV4knh2h04qmvsSR6AF4F2zXMAhFPlI1Qm
	dw2q0pmFwJGdlWjRwrAFJoUBYEYAkEpRgQ5VY716q1ycnlqD1yD/DOwUKpSu8lsvgx1o40XbDNn
	CloZZPULBjpS12nx5AkH7ayb5cSxHjB/QsJCjQ0mbwLMP+5J+aU5OZ384inqlNgBOzDg4fpRakO
	WfPuUrFNmsYCV5XQb3Q+nBTB0zMi9DMHLbDjfS0tU3FjkFZ+rJVSpnujvLlia6g8ECRaB2fZy0M
	tB6lI/8Ttn3V4CZgyAf/FJWHzGHfpU7/4pnLC7PRjwk/DLCK6xgbatZ1zdab/UebDlUs3TBhFWd
	xlLlSWZrjW9QlA9smTnag2Kp9X5EzWwTZqNZCBYtjBVrLs+hV+MvFgsFAtB6i7XtV6BaisVUDFz
	2
X-Received: by 2002:a17:90b:3c11:b0:3a7:9ec3:ea0e with SMTP id 98e67ed59e1d1-3b41c908114mr17793259a91.22.1795876642889;
        Sat, 28 Nov 2026 06:37:22 -0800 (PST)
Received: from BSDHENRYMA-PC1.localdomain ([43.132.141.26])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b405ecb486sm46221316a91.16.2026.11.28.06.37.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Nov 2026 06:37:21 -0800 (PST)
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
	stable@vger.kernel.org
Subject: [PATCH net] netfilter: ipv6: fix out-of-bounds write in fragment reassembly
Date: Sat, 28 Nov 2026 22:37:09 +0800
Message-ID: <20261128143710.811389-1-bsdhenrymartin@gmail.com>
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

