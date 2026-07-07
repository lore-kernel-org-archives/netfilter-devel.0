Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03480392C39
	for <netfilter-devel@vger.kernel.org>; Tue,  7 Jul 2026 09:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783415484; cv=none; b=D63ALOZkk7RPjAabN8LzTgi6hOkzGUQHlbZ1PIytpTFB/ksNkCI/fZexFP4E9bY9ywGBy7bu6LHiXEdNa3aaJSEaBhhA275GeHELnnUn5Yky6MKs9N5gaW5vuCl+CX1KC886bMutOaKMJG9umhQKZ7c6VfEesDiCdCM23kIiobw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783415484; c=relaxed/simple;
	bh=YBNEZ0JuBYpp39J19uIA6JD+g8DwilN2ygweuBY+Wvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oug2JtS+z+xDiZlgSJcXCyMBbpXy9qr1n76Rim0Dt2IgoME+tvjogOwvT1w03/KuvqXQBlhdFXGEqX0u0NgPHo9gBHkuhv85FnTvlO39Rjkuvu0Nas/he43PgDZ40/dAHWChBuxcajB5ut0VdukkkNgA3epuw7Ma2y3zbLf5VuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N/w1nAY2; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N/w1nAY2"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-698aa8d4dafso3918624a12.0
        for <netfilter-devel@vger.kernel.org>; Tue, 07 Jul 2026 02:11:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783415481; x=1784020281; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1ab4D2p/3Z+QNLOMIvIrg+NC0XFgS2lOf5VtGliLMbQ=;
        b=N/w1nAY2yQOsx7RdrILWrIFBBO3VoguSM2c3VRV2k9KxGeGPN26eyIC7RXxSokqwCK
         SMI3ZGh7pFU2ducfiGxGNGjtcUAlMaNnO8Zx+ReOJTpeSAZKHiVqwpKOzdkOQ43+9lR2
         P0rs2uqFhQikOJE3XMIo/YGe6CRb9iqBfAdtYILL1RNys8o4rbqMQG0x+Lyodf2FwJA+
         7wejT7MfoLLTjQzN3nVYkWRP/ydur5+4pL/6MAcO0BhoGQ3cnpnandE+Fw9S1yilysEz
         DDr2ruBn5W6j4i+vlcXa6i6FcYzsBhsVllRIK25YKdYomw+NakM53Gy/reZfLW6R6OZ/
         hrCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783415481; x=1784020281;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1ab4D2p/3Z+QNLOMIvIrg+NC0XFgS2lOf5VtGliLMbQ=;
        b=H1nkCMZnyZcY5T04ARLgntTuoT70uyr35F823JaAq8mpqs1fHn7iJfUtoXR1eUdFMs
         ehEPDzFLPmnAwb+5JykjDLsm2XzQ+KfdK/AmjixD5P0n/ATjp3GFIsMdJgMVNgaPgCzf
         I1xOIEmepvkNQ0QP2qKCs/DMja5jQxgLHL08dNhHXQkqOkkBT7LZRTk4o65LtuoZE/F5
         cIdmPjwlHDxjs7S+Js3ZbNR5fI7UgNRkT26PhO3NB9llgqSxbpfl/gZ/MlGhmlU9GJv5
         qIvrJWm4WI7hHpSkFz5IDKR8GNDZTzdnin1SsIBKmPvEfqHCqcLfHs8yh/aE5EDiQ8f9
         QOng==
X-Forwarded-Encrypted: i=1; AHgh+RqkdXSWy5Q4XFqTvlJHHIWm/Pws7P13AA2I772vDxsTB6+S4kX1nbiAnNygYzdKdWkb5e/BVq70QGbrffDtfm8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz2VCOzRLc44B4/jZIAxLNeOyc6lCKRP9DLVFgnzkljVYnbq/kR
	+XsEoCf1oBsago1oJafaCA7+nACZDoDJX2nB6qn8zW+4HYOEaBcuDzdC
X-Gm-Gg: AfdE7cnVD/KQuQUgYl4N5X/C3n/n74IMFt55aLVEhg8dI0xrDabAZry1WqpHUbWeaLv
	Qvd88gwy65Jzy9DoKmq7t9wL/OL4wPTy5cre1tLq4rx81ka2AkyBe805cmgrrTeyxoYNYnV5Bj9
	Ec+25h4xIfKuRVsFV9f88m6WKF8LfmlrrGBoexE2dBn7YU/Swiq1L7uFlJSbG9HSckIZ9cYiMBW
	wtsC2XUzBtHSGG0tiM0ufIjuM2+6/W8a0lmeYonp6HKsXG0uNXs7vkth8tS1FR+Uyf5tplTzv33
	fl818b4g2405Cd3W/qkMQF0zi2HlNc+xmfMhRMWpEULR95LtieMaRSwPKMrskFmjo0QcPl1koal
	G79jxMUk6JpxV3pqBTtypqgrNIjbaW9RRKhJxvfVqK/l710vyqrEkiGT4P5EDtiRLXzmfwGNoHk
	Z7+COfRFU6DunMjLCtIwUqHFGVyCn5wzbOzgp5tHtuRAKmYqWDxjvINdDwcpmHllyu5vq4gHY/d
	eFIVG/j4pN+kisyQnEuJRVhocF6JXFmaYz0f6fRu5J8
X-Received: by 2002:a05:6402:1d55:b0:698:e595:a5c with SMTP id 4fb4d7f45d1cf-69a85651f63mr2079368a12.6.1783415481357;
        Tue, 07 Jul 2026 02:11:21 -0700 (PDT)
Received: from eric (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-69a19cd87d6sm5297152a12.6.2026.07.07.02.11.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 02:11:20 -0700 (PDT)
From: Eric Woudstra <ericwouds@gmail.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Stanislav Fomichev <sdf.kernel@gmail.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Krishna Kumar <krikku@gmail.com>,
	Martin Karsten <mkarsten@uwaterloo.ca>
Cc: netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	bridge@lists.linux.dev,
	Eric Woudstra <ericwouds@gmail.com>
Subject: [PATCH v12 nf-next 5/7] netfilter: nft_flow_offload: nft_flow_offload_eval: check thoff==0
Date: Tue,  7 Jul 2026 11:10:43 +0200
Message-ID: <20260707091045.967678-6-ericwouds@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260707091045.967678-1-ericwouds@gmail.com>
References: <20260707091045.967678-1-ericwouds@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In case of flow through bridge, when evaluating traffic with double vlan,
pppoe and pppoe-in-q. In this case thoff will be valid only when meta has
been processed. If meta was not processed in nftables, thoff is zero.

Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
---
 net/netfilter/nft_flow_offload.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index f8c7f9f631e48..4f68fb64f1657 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -59,7 +59,7 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
 	struct flow_offload *flow;
 	enum ip_conntrack_dir dir;
 	struct nf_conn *ct;
-	int ret;
+	int ret, thoff;
 
 	if (nft_flow_offload_skip(pkt->skb, nft_pf(pkt)))
 		goto out;
@@ -70,8 +70,11 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
 
 	switch (ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum) {
 	case IPPROTO_TCP:
-		tcph = skb_header_pointer(pkt->skb, nft_thoff(pkt),
-					  sizeof(_tcph), &_tcph);
+		thoff = nft_thoff(pkt);
+		if (thoff == 0)
+			goto out;
+		tcph = skb_header_pointer(pkt->skb, thoff, sizeof(_tcph),
+					  &_tcph);
 		if (unlikely(!tcph || tcph->fin || tcph->rst ||
 			     !nf_conntrack_tcp_established(ct)))
 			goto out;
-- 
2.53.0

