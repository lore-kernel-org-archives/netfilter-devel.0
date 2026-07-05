Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F0C145039
	for <netfilter-devel@vger.kernel.org>; Sun,  5 Jul 2026 23:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783294597; cv=none; b=jJ7n3LYNsoHi1htImqoLzIf9QdevqK68TqI4hx45L2ndVRENYwvuyYOHOJ4ncL1a4maDC53kTFtjtrPeVftW1/qs4mRbHr53bqr+QaqwVxnN66B9K5B48f42qDfkQRPdMbgAEDfw/wESbt4TsAmMS65gmZRaVU89sLZE4T6odlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783294597; c=relaxed/simple;
	bh=oowJ0/pwMLpK+2FBTaTr7SQOcKOb4MiuA70vmsgUgiw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Lg3NTJcGKZaACr0dGEgAcNhRAv7unrtAYLELuLUM7nMlRNXGT4ZvWBFv3DJXiMiBGfukmAbAEtyJX5273XKnD4e7EGJiiXQ1P8lhnAOciSPd5CSyLVzcY4KDNld/y5vd0F9wjB+x+mcZTKbe+WgDollc/y2n7pFDKX21gGby3Xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu; spf=pass smtp.mailfrom=asu.edu; dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b=IbOtp/yG; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asu.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b="IbOtp/yG"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2caea3f742bso30250025ad.0
        for <netfilter-devel@vger.kernel.org>; Sun, 05 Jul 2026 16:36:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=asu.edu; s=google; t=1783294594; x=1783899394; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=wagndnGVb7E87oGYXUV2CXr6Jt9C4YXqmzSMkRBdYcU=;
        b=IbOtp/yGL43TB71pl2LIxr7TJYxD6/IH7fr3+xoM2BcumWs2EunymlOXLZnhID5EXh
         LLoNpf1jaEnsawRfXTJJ+zNX8qqi6X2x32yhIjXJEpzSViPGdoG6SjRCkPT+qvKpGk+m
         7wcnT06sU67vKv5kptQW0woFGw9WrtQeu7YoupEJQBoViPPcJ9SRG/IrO4rs/TSYFV1A
         mwBCtYgyN00MJU5uQh1ysEoaQhqBj/t8BHlR1GQ1PjuU+bLKRgl2hfJMquDoKkxBVCen
         lrPT6AA4RJ59rmrO+tj2epvaPgN+xfLvUEhL5vBShLTUqA6qBTmC5Np7aDkZx5g7nODg
         nzDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783294594; x=1783899394;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wagndnGVb7E87oGYXUV2CXr6Jt9C4YXqmzSMkRBdYcU=;
        b=GlY6lW9u0X7yIpANxPgU5dqY+kw76U7w0FK3gYdWShOWBisWa71Fq9HLyRASAwMwxY
         XafTZCA6uhQ/Iq17lQ/Qmf/6GW8L6pSoaEWVUUCXPvPRUmr2SYIpHq7c9Fdmi8oOM47x
         KW2q2Xjf1JVyvIRk0ABpvwPUnp+581KzWbVTVeoay17o0TxPCzXiAQTi03tuu6MvkiK8
         UV4R20C6iY+HFHVbt/NiXZ8bLzIPR9iR8KIZ2hkfX7wBwWzAgtD4Bs09NjnXG1+rBYEg
         ndnZlvLcn0NAwYaKi3yrvQ+TlCMHURvcs8i865MmQ61ZWj4LM2dSkrBF2rp+NZ2P7NRF
         reEA==
X-Forwarded-Encrypted: i=1; AHgh+RrXmGV7Bw80MlHoI+Mtmhl+D9dmYzyatAcCDY/is4322JUXSkKiNxYsY+be9p7vmOXnjalS6AWrkecuoypqv5E=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7YJLibJuLpi3GXRcRS3KHT7LoYEkfGEimRyzTc6/4/U7EORol
	Z1N60LMRuX6c28JSGRSD/w2q9+EaJ1t23z4fE6uHuLxWh6z3GxA5nqfsIX5r18oWiA==
X-Gm-Gg: AfdE7clCsyvJJNpIfvW6ZKpMvfvdMOUcthVjkjuBpvYO4CCsWYfFBQg5otBY5n8O7oa
	DUekMQeNUYcc9upL3gbm3kL7dK7ZMo5UnqgktN8BIDYTk9GepHyn89aCqW9K2LtOmg86TFw1Wkq
	uMELB5ZiAgT1Q2SnvQCzdHyOFsD7rl8zQGic2ujWUojH5mGEKPCAjpPu9jenA22/Q2udRkiAXXn
	utWLiIMGD/N61XE30/Bj3Q+gZyeumqXeJzby7pqD+rpxThbs/7Mthmqbi9X3dh1xyFXDcRZ+zuR
	COLSefidyGVpXXbdmXGSfu2iMt+yO2n99l1O3kTGojC3D79JODWAkHWWgsMO1wj7eIHuCck0XYn
	HrFm1IY5WhDIHH6uHYgExUg7Bb3FskfdFCZpo7JrwZ4y1ic5vaq7JhH9og3bqlAHtP562zMussg
	==
X-Received: by 2002:a17:902:db05:b0:2c9:a247:171 with SMTP id d9443c01a7336-2cb97e47b64mr75072215ad.1.1783294593851;
        Sun, 05 Jul 2026 16:36:33 -0700 (PDT)
Received: from p1.. ([2607:fb91:1529:e46a:7f70:6a22:47e0:673d])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cad7870f58sm38938695ad.59.2026.07.05.16.36.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Jul 2026 16:36:33 -0700 (PDT)
From: Xiang Mei <xmei5@asu.edu>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>
Cc: "David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>
Subject: [PATCH nf] netfilter: nf_conntrack_reasm: guard mac_header adjustment after IPv6 defrag
Date: Sun,  5 Jul 2026 16:36:29 -0700
Message-ID: <20260705233629.2287813-1-xmei5@asu.edu>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nf_ct_frag6_reasm() slides the packet head forward to drop the IPv6
fragment header and then unconditionally advances skb->mac_header:

	skb->mac_header += sizeof(struct frag_hdr);

On the NF_INET_LOCAL_OUT defrag path the skb has no link-layer header
yet, so skb->mac_header is still the "not set" sentinel (u16)~0U. Adding
sizeof(struct frag_hdr) wraps it to a small value (0xffff + 8 == 7),
after which skb_mac_header_was_set() wrongly reports a MAC header is
present and skb_mac_header() points into the headroom.

The reassembler has done this unconditional add since it was introduced;
it was harmless while mac_header was a bare pointer, but wrong once
mac_header became a u16 offset whose unset state is the ~0U sentinel
tested by skb_mac_header_was_set(). The sibling net/ipv6/reassembly.c
does the same relocation and does guard the adjustment; mirror the
guard here.

Fixes: 9fb9cbb1082d ("[NETFILTER]: Add nf_conntrack subsystem.")
Reported-by: Weiming Shi <bestswngs@gmail.com>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Xiang Mei <xmei5@asu.edu>
---
 net/ipv6/netfilter/nf_conntrack_reasm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index 64ab23ff559b..3637b20d3fa4 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -348,7 +348,8 @@ static int nf_ct_frag6_reasm(struct frag_queue *fq, struct sk_buff *skb,
 	skb_network_header(skb)[fq->nhoffset] = skb_transport_header(skb)[0];
 	memmove(skb->head + sizeof(struct frag_hdr), skb->head,
 		(skb->data - skb->head) - sizeof(struct frag_hdr));
-	skb->mac_header += sizeof(struct frag_hdr);
+	if (skb_mac_header_was_set(skb))
+		skb->mac_header += sizeof(struct frag_hdr);
 	skb->network_header += sizeof(struct frag_hdr);
 
 	skb_reset_transport_header(skb);
-- 
2.43.0

