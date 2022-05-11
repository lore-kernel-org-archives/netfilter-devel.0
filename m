Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7F2DC433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 May 2022 12:25:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234089AbiEKMZu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 11 May 2022 08:25:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235462AbiEKMZs (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 11 May 2022 08:25:48 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E30A6267
        for <netfilter-devel@vger.kernel.org>; Wed, 11 May 2022 05:25:45 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id 15so1663413pgf.4
        for <netfilter-devel@vger.kernel.org>; Wed, 11 May 2022 05:25:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=u/hM4QJTYh3y30fk30rBeLz9ogpAIeZoSa2pE4v2i5s=;
        b=PGeof6PAi79+bGTB1GwE9m3ar3eqf8ve0/f/Fz2vNBgNqzM0rgSgbDL0lXrhAZTY3r
         ywooZ5XRogJpojsrYlhYoaN3sJAGrfVn7A3CSWYyrDLGIIEiDx3Vosy14yvII7byCdYG
         MKcHRcYPEXesSyNHmmzc8zHnX+Rr8BFsJ5W9AVdLCptE5y1Jkfqm8Ev5YCaGiQrfbewP
         haOJjhfALrod3t5YyD3E0b1m0Arg5vjQT72VMfGJMFBdgr5zT9qDbS5w1729v14FP6/N
         pXGSExe47RgbzQQiPs0E/FDReuGP1WDjJuschcVFbLZjihQKU8MbL3RuHqZrxEcCRPTc
         puDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=u/hM4QJTYh3y30fk30rBeLz9ogpAIeZoSa2pE4v2i5s=;
        b=xBIiS2xy/2qxE08UCKFuI0kzWXAH+sjilxxazRp12INvW9PSkxZesjmmz5P8tdbLdv
         zUMZq+aDXyjafMRdOsyq+1Kme0xwWzmlktewVGUnE8gsrvdZPRK0hvpuVT8DonxuDHpV
         tS46ATNF1CjH+YLmd1ZzeRCVpDEAzSbWDJxTYN4slDWyjwy8aPgPInF8xeeyof+SbA/q
         w+Q/LHK71TQZ2TYLUaY+Cy1gD6Y1rk1w4IkbYoMTOQmAqDyw3azUlSAM5SxbVruvan14
         R7hjy5YWAD9PuqW9fG9YphJ9pN8oItFhiuOeSdcsCGjuvv192Nqop4P/R3v1p/4mTdVR
         cnrg==
X-Gm-Message-State: AOAM530WurHPglRdxu3VuPlfd4roQWKEzCe2KkU36HQCuYKzNuMH1qHQ
        AnNDEZe313MBy+awvh/JkR0OAY13PGEOvcYj
X-Google-Smtp-Source: ABdhPJxXs1hkL9ps5PYKW5vFppnCbaSC8IGaj0CWGhwR1DP/+r6sMIiG0vVH+XCsgEomWNa07gcmcw==
X-Received: by 2002:a62:e80f:0:b0:50d:3693:43df with SMTP id c15-20020a62e80f000000b0050d369343dfmr24910748pfi.36.1652271944286;
        Wed, 11 May 2022 05:25:44 -0700 (PDT)
Received: from LE480.. (fpa446b85c.tkyc319.ap.nuro.jp. [164.70.184.92])
        by smtp.gmail.com with ESMTPSA id z65-20020a623344000000b0050dc7628155sm1619603pfz.47.2022.05.11.05.25.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 May 2022 05:25:44 -0700 (PDT)
From:   Ritaro Takenaka <ritarot634@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Ritaro Takenaka <ritarot634@gmail.com>
Subject: [PATCH v2] netfilter: nf_flowtable: move dst_check to packet path
Date:   Wed, 11 May 2022 21:24:24 +0900
Message-Id: <20220511122423.556499-1-ritarot634@gmail.com>
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

Signed-off-by: Ritaro Takenaka <ritarot634@gmail.com>
---
 net/netfilter/nf_flow_table_core.c | 23 +----------------------
 net/netfilter/nf_flow_table_ip.c   | 17 +++++++++++++++++
 2 files changed, 18 insertions(+), 22 deletions(-)

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
index 32c0eb1b4821..402742dd054c 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -367,6 +367,14 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 	if (nf_flow_state_check(flow, iph->protocol, skb, thoff))
 		return NF_ACCEPT;
 
+	if (tuplehash->tuple.xmit_type == FLOW_OFFLOAD_XMIT_NEIGH ||
+	    tuplehash->tuple.xmit_type == FLOW_OFFLOAD_XMIT_XFRM) {
+		if (!dst_check(tuplehash->tuple.dst_cache, 0)) {
+			flow_offload_teardown(flow);
+			return NF_ACCEPT;
+		}
+	}
+
 	if (skb_try_make_writable(skb, thoff + hdrsize))
 		return NF_DROP;
 
@@ -624,6 +632,15 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 	if (nf_flow_state_check(flow, ip6h->nexthdr, skb, thoff))
 		return NF_ACCEPT;
 
+	if (tuplehash->tuple.xmit_type == FLOW_OFFLOAD_XMIT_NEIGH ||
+	    tuplehash->tuple.xmit_type == FLOW_OFFLOAD_XMIT_XFRM) {
+		if (!dst_check(tuplehash->tuple.dst_cache,
+			       tuplehash->tuple.dst_cookie)) {
+			flow_offload_teardown(flow);
+			return NF_ACCEPT;
+		}
+	}
+
 	if (skb_try_make_writable(skb, thoff + hdrsize))
 		return NF_DROP;
 
-- 
2.34.1

