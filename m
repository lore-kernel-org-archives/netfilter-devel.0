Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE0513955C0
	for <netfilter-devel@vger.kernel.org>; Thu, 10 Sep 2026 09:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789030866; cv=none; b=RGTOS3xf54zXmjyPEzmnODpYkHU0ofqR+1NDDeJkU4GV2vu3YRQffElkU/KedpnGDmD+cU14XqxWCEkkSwy3DfV3798fnj2mszGyMWTid8qwWoZQ9NF34E5K1BJRfgyfTqLs0bgd+dPYfhqz9I6LGGJhO424enXMUYL+UrokrsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789030866; c=relaxed/simple;
	bh=tYhCwCWxuhguq6pfAupubVPjCxdBVlF4RC/Qb+PCngw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mg1qjHzW2frvlh/JS9vNv20OcxX6arj0kgaHL+rtJ5Y23sDc8j2EdTacS1uaUk+nU/xQB3mHxhHkh9pdG9RWynC/iU0lbCbsBenJVynlMePYxWJhVv3cEE9G07TIL1DOPRiwbNgtgdoeBWUckrY5pL+UPeJjYAwFR5Fi9mJqPpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=N1xfBMQp; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="N1xfBMQp"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-c2940d16190so196630766b.3
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Sep 2026 02:00:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1789030854; x=1789635654; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=znPVXyZXPnFTO1sJfrnUQLvHd7wsibn1+GKNiaFiRTA=;
        b=N1xfBMQpU9V0Gdm/PhYI6O8emI+YJt5rZG+nYrxO0tu+E7et4PV9qBZJ0AvB3aNNAk
         PPLqDG5oUyBUugTFoxEFA0Fb/uxu0QEJMNx01IOmNh9aDozViYtt5S4/SYwmWDVPDRiG
         qwuF6ff2NZfLuPWnrwfE3cExCxFqxVSerNwiatG0sar9Cxa39FSUWGGYYD8yPI59MBDw
         HS/kXPB/Cjb4AK62Acaa6PwiU9Pq+ojDJq7jKdaKD9bEkJfuH9idzfV+U0Jo1jo+dBmV
         MKY+ti5wUyF2TmIbmTeXSCbds3c18RWrHbb1wN4B7ZpTZ7ybSmWifXoZ8zlKBi9Ci7wg
         lqVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789030854; x=1789635654;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=znPVXyZXPnFTO1sJfrnUQLvHd7wsibn1+GKNiaFiRTA=;
        b=j3cPUKQG3ZwVuBK/vM3pVkzAXPZna4TxFYHK/AgR/g/j7sNuBmG9p5wWnJzWIXEXqe
         uQZWAuWYN4By1KDdQDhLsiRDF2t+qgJGIgWbfyGHcLFzLTz0VVjHMCzxRnHPSNPYe2w8
         e4M67aY25do8WGRtctOJefdX7fnmsZzrDAGr9orneeL9fg4SBdJ8/Ej7aufwf7CzfjPR
         VRrPKq9wLTvB0fyYqVHMTCHZ69EY+jAXipZDls/9PPDv8rRj6/RXdrqs3oISh+9hpzHE
         SiU+kqNGhFZTERiwKfaOxIP/iSB/RsEqen3LScPpPow6CKD+E6AF7U+VknxyWMd66Alx
         izFg==
X-Forwarded-Encrypted: i=1; AKwUvBwjog6QlAF0qN5qtKCvSfREzxOF81G+t3kilBvRTSXM/uKAppohskNJez1gTDrcC+UNNxJQwm3ZEsbzQY8T2cM=@vger.kernel.org
X-Gm-Message-State: AFuF++mNwAfSedx5Z1dkcmZ/iVbMgLd7xYdQHVqF0K4xlMEwTTZCcta5
	pieLWh/T6d2bD3eTRXnyIreG+v+7/cLej1sxXVOnw6pcG//LHQoU6WOgjPddFS7o5A==
X-Gm-Gg: AYBFou3wnUxxHBWUwnfBRKsxpIy5K7ETO/HGiPeLi5vOyc4gGsMbA8ibYPlhc6gRA7d
	nY/ySMfetLxH5rAtcOqs6VcT0CjTSOgjfHfm9RcEBqzssc7jIdEda2uENeACStXSDc64WuzHCud
	JtjOcCNs7WzNIl1A3atrB3rohudhMYqOhvRHNAFTKtt33bJzH7cDSL2QX3yCltYlZahpXEbpvU9
	PVYIrvzoHyDWsBusZ4mZ4gelbjfIYwIyUq2rxxV8HGoi05Mmyqdud8osfKULWS987TjB+9WA5AT
	8eP2KaYiN6CC7hqysuP13c7m8tGD16jOtpaE2o5Y5PdWOxntwY0MFZNq7PJrUTxtjTs5LQPpcBj
	SZEt3K958sw0/QFKRCvvGPVAFcC3+YUxzqy+B2Y1YzPDXLo015ua10GAGZMPKQzihz09KGt1UfJ
	aXeKUQluv3AxZcVURxK9HfxZfu8BpZe79qwh4dfwRQ0IyuFc8Vhey9jSxJMS0nEf54tuTxyjKs5
	z5ikD8EyLs+ymUZwb98IP88O/7pQzmtfDDjq9Geuhvwp1Oeyp16GcAfgotOx9c6VpRTsN4sR3qi
	iWp2pKMxDVE06ExSZqF/gpRHiB/DvPKyf9OyZPupJscQb7n2bZwdyco9dlZSNAh4vgqF2mfWCTq
	rjV7d+M0NOi71E/R2XdJPcUeZhyzudO6Pcvs/Mo06yiEl/sCgWEnr23Fw86R0f3ub3KnO6fD04X
	u4maKGPw==
X-Received: by 2002:a17:906:8d89:b0:c24:c250:a6b5 with SMTP id a640c23a62f3a-c260c993a9amr1596510266b.12.1789030854121;
        Thu, 10 Sep 2026 02:00:54 -0700 (PDT)
Received: from Desktop.fritz.box ([217.26.235.87])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c293eaf1ae8sm156106766b.40.2026.09.10.02.00.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 02:00:53 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: pablo@netfilter.org,
	netfilter-devel@vger.kernel.org
Cc: kadlec@netfilter.org,
	fw@strlen.de,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	geldot@protonmail.com
Subject: [PATCH nf-next 2/4] netfilter: flowtable: promote a flow offloaded in one direction only
Date: Thu, 10 Sep 2026 11:00:50 +0200
Message-ID: <20260910090052.2034970-3-julius@bairaktaris.de>
In-Reply-To: <20260910090052.2034970-1-julius@bairaktaris.de>
References: <20260910090052.2034970-1-julius@bairaktaris.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A flow offloaded in the original direction alone carries a reply tuple
that conntrack has never seen a packet for. Leave that direction on the
classic path, so conntrack tracks it, and offload it as well once the
connection is assured.

act_ct promotes its unidirectional UDP flows on the same condition.

Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
Assisted-by: Claude:claude-opus-5
---
 net/netfilter/nf_flow_table_ip.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index c8c29a9a1684..f2cd5c2c5365 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -465,6 +465,26 @@ nf_flow_offload_lookup(struct nf_flowtable_ctx *ctx,
 	return flow_offload_lookup(flow_table, &tuple);
 }
 
+/* The reply direction of a flow offloaded in one direction only stays on the
+ * classic path so that conntrack sees it. Once conntrack has, the flow is
+ * offloaded in both directions.
+ */
+static bool nf_flow_reply_unoffloaded(struct nf_flowtable *flow_table,
+				      struct flow_offload *flow,
+				      enum flow_offload_tuple_dir dir)
+{
+	if (dir != FLOW_OFFLOAD_DIR_REPLY ||
+	    test_bit(NF_FLOW_HW_BIDIRECTIONAL, &flow->flags))
+		return false;
+
+	if (test_bit(IPS_ASSURED_BIT, &flow->ct->status)) {
+		set_bit(NF_FLOW_HW_BIDIRECTIONAL, &flow->flags);
+		flow_offload_refresh(flow_table, flow, true);
+	}
+
+	return true;
+}
+
 static int nf_flow_offload_forward(struct nf_flowtable_ctx *ctx,
 				   struct nf_flowtable *flow_table,
 				   struct flow_offload_tuple_rhash *tuplehash,
@@ -478,6 +498,9 @@ static int nf_flow_offload_forward(struct nf_flowtable_ctx *ctx,
 	dir = tuplehash->tuple.dir;
 	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
 
+	if (nf_flow_reply_unoffloaded(flow_table, flow, dir))
+		return 0;
+
 	mtu = flow->tuplehash[dir].tuple.mtu + ctx->offset;
 	if (flow->tuplehash[!dir].tuple.tun_num)
 		mtu -= sizeof(*iph);
@@ -1074,6 +1097,9 @@ static int nf_flow_offload_ipv6_forward(struct nf_flowtable_ctx *ctx,
 	dir = tuplehash->tuple.dir;
 	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
 
+	if (nf_flow_reply_unoffloaded(flow_table, flow, dir))
+		return 0;
+
 	mtu = flow->tuplehash[dir].tuple.mtu + ctx->offset;
 	if (flow->tuplehash[!dir].tuple.tun_num)
 		mtu -= sizeof(*ip6h);
-- 
2.53.0

