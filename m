Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2830C433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 May 2022 10:04:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245758AbiEQKEC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 May 2022 06:04:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236593AbiEQKDu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 May 2022 06:03:50 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57BA531343
        for <netfilter-devel@vger.kernel.org>; Tue, 17 May 2022 03:03:09 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id i1so16888738plg.7
        for <netfilter-devel@vger.kernel.org>; Tue, 17 May 2022 03:03:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=95DxLC4mkLtWZPPHNSp67ka4g5vecCJOeLo3i9qlERI=;
        b=akDX2n9PTgDjZN9BKotu6/Tb89RIFOBywznQWh8lDDGtx5fkbalgOEfRWRCJxe0fxR
         rIZPJWCIbOtrkBy455VCx8E5JtDZaMbaXhq++abmShZkMOjBIWG2HlbwOhieC8pT8sQO
         btuaopqHW44PMdfsR8IoJf5OjRU5f/UgLb5NvMHDCXN4kdmK3XejSCldyX3vWfJC+kzf
         pwgRXlKqPcN6uESj7lOV24mqhoOtnKkwJGPc00TtDe6JukgE+RtK/kZAfTLBiHHJAOb9
         tTbxvXemZTQsGUwNLtmcDlV8FPq8GlhpDfYKkqzb0Bguj67tBFbXDEjzr5CMx2cB+SaU
         YNwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=95DxLC4mkLtWZPPHNSp67ka4g5vecCJOeLo3i9qlERI=;
        b=L6cn4FLlqk0HR3qem+gIApZeI577yigDxZ31BAdJzYKkI+7vxjmpjVU+Hu1GNnAeJD
         o/v/eqY6AVvb1be6DCWZaV+XK7GskG1HFirKxj44dIIBzPQSAYCe2n+Bb4nHfYbsnnWK
         GJQE3yuzLxNI2NYysqJawWG4gRxvV/LChWRqJ7c9T55AAuFyZixPrCQrNHUQA/NQZQC8
         /UoF+Tg8jo7N/BUOW9qM82Tb5j4wTHEJsIpdWsa2DgP+Jy9Iz5KEh0HlTbw5PP70eMXX
         +LxhDn2GzMuFY4DVgS7MqkDL23KoJ6lEhPLInZjXBf37Ae0fz+qDEnnJG60FwxzsuDQk
         GeWQ==
X-Gm-Message-State: AOAM53368jKt8vOZN7DmVE9ypikuCgaxPpU3LNTwmScNMkAqKcPFQ+la
        mzXgJfn7ZXm64WeVcASIg5h4Q41V12kowyZO
X-Google-Smtp-Source: ABdhPJy+190VDlkO7I+hDyjfn3iFdaKM9g6Z6ig4aJ0dPBE79IFsqc63i59y/B5QngXfi47yXcOJTQ==
X-Received: by 2002:a17:903:1111:b0:15f:7f0:bbf3 with SMTP id n17-20020a170903111100b0015f07f0bbf3mr21741142plh.12.1652781787764;
        Tue, 17 May 2022 03:03:07 -0700 (PDT)
Received: from LE480.. (fpa446b85c.tkyc319.ap.nuro.jp. [164.70.184.92])
        by smtp.gmail.com with ESMTPSA id cu5-20020a056a00448500b0050dc76281b2sm8714184pfb.140.2022.05.17.03.03.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 03:03:07 -0700 (PDT)
From:   Ritaro Takenaka <ritarot634@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Ritaro Takenaka <ritarot634@gmail.com>
Subject: [PATCH v3] netfilter: nf_flowtable: move dst_check to packet path
Date:   Tue, 17 May 2022 19:00:43 +0900
Message-Id: <20220517100041.966527-1-ritarot634@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Fixes sporadic IPv6 packet loss when flow offloading is enabled.

IPv6 route GC and flowtable GC are not synchronized.
When dst_cache becomes stale and a packet passes through the flow before
the flowtable GC teardowns it, the packet can be dropped.
So, it is necessary to check dst every time in packet path.

Fixes: 227e1e4d0d6c ("netfilter: nf_flowtable: skip device lookup from interface index")
Signed-off-by: Ritaro Takenaka <ritarot634@gmail.com>
---
 net/netfilter/nf_flow_table_core.c | 23 +----------------------
 net/netfilter/nf_flow_table_ip.c   | 19 +++++++++++++++++++
 2 files changed, 20 insertions(+), 22 deletions(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 3db256da919b..1d99afaf22c1 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -438,32 +438,11 @@ nf_flow_table_iterate(struct nf_flowtable *flow_table,
 	return err;
 }
 
-static bool flow_offload_stale_dst(struct flow_offload_tuple *tuple)
-{
-	struct dst_entry *dst;
-
-	if (tuple->xmit_type == FLOW_OFFLOAD_XMIT_NEIGH ||
-	    tuple->xmit_type == FLOW_OFFLOAD_XMIT_XFRM) {
-		dst = tuple->dst_cache;
-		if (!dst_check(dst, tuple->dst_cookie))
-			return true;
-	}
-
-	return false;
-}
-
-static bool nf_flow_has_stale_dst(struct flow_offload *flow)
-{
-	return flow_offload_stale_dst(&flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple) ||
-	       flow_offload_stale_dst(&flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple);
-}
-
 static void nf_flow_offload_gc_step(struct nf_flowtable *flow_table,
 				    struct flow_offload *flow, void *data)
 {
 	if (nf_flow_has_expired(flow) ||
-	    nf_ct_is_dying(flow->ct) ||
-	    nf_flow_has_stale_dst(flow))
+	    nf_ct_is_dying(flow->ct))
 		set_bit(NF_FLOW_TEARDOWN, &flow->flags);
 
 	if (test_bit(NF_FLOW_TEARDOWN, &flow->flags)) {
diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 32c0eb1b4821..b350fe9d00b0 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -248,6 +248,15 @@ static bool nf_flow_exceeds_mtu(const struct sk_buff *skb, unsigned int mtu)
 	return true;
 }
 
+static inline bool nf_flow_dst_check(struct flow_offload_tuple *tuple)
+{
+	if (tuple->xmit_type != FLOW_OFFLOAD_XMIT_NEIGH &&
+	    tuple->xmit_type != FLOW_OFFLOAD_XMIT_XFRM)
+		return true;
+
+	return dst_check(tuple->dst_cache, tuple->dst_cookie);
+}
+
 static unsigned int nf_flow_xmit_xfrm(struct sk_buff *skb,
 				      const struct nf_hook_state *state,
 				      struct dst_entry *dst)
@@ -367,6 +376,11 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 	if (nf_flow_state_check(flow, iph->protocol, skb, thoff))
 		return NF_ACCEPT;
 
+	if (!nf_flow_dst_check(&tuplehash->tuple)) {
+		flow_offload_teardown(flow);
+		return NF_ACCEPT;
+	}
+
 	if (skb_try_make_writable(skb, thoff + hdrsize))
 		return NF_DROP;
 
@@ -624,6 +638,11 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 	if (nf_flow_state_check(flow, ip6h->nexthdr, skb, thoff))
 		return NF_ACCEPT;
 
+	if (!nf_flow_dst_check(&tuplehash->tuple)) {
+		flow_offload_teardown(flow);
+		return NF_ACCEPT;
+	}
+
 	if (skb_try_make_writable(skb, thoff + hdrsize))
 		return NF_DROP;
 
-- 
2.34.1

