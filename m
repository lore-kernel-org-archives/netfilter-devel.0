Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27C2FC433EF
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Apr 2022 08:11:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234449AbiDYIOh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 25 Apr 2022 04:14:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234333AbiDYIOd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 25 Apr 2022 04:14:33 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B1B041985
        for <netfilter-devel@vger.kernel.org>; Mon, 25 Apr 2022 01:11:29 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id h12so21578170plf.12
        for <netfilter-devel@vger.kernel.org>; Mon, 25 Apr 2022 01:11:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=t+tpa5UCYuc64vAh/xMILdTd158zKxTnE8LNTVUTafM=;
        b=YtuaRRzjgP7XvwRrw4XY2UEe72GUbRQ8Bh8I39n+yWQiehLfjLyLhdVN6GdonS2lwK
         csxt5dwBSdUy/4iLLGg1JBT4PmHICSkJvRWyClmlcVwbNV325sexnFFqAN6CDjfTlAU0
         ZknpVN893KbnehAS3aFMzlYSms6yu5HNcUy6ZK9INm+NkZd+KR7bX37rNGIH1HjpP13Q
         3UcE47B0qsgY/MWCU9GXBrm4D3wv7hT66Kmxlreqe49qiGSf3ol0IwdP5WVNVAacP1PO
         +ayQ+7gxRa6Jwk0ocqV2/S/WcOCsRIsx16bP8wP9Zg1nMPfqERQqlGF9Ae80TlH49fHT
         8DxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=t+tpa5UCYuc64vAh/xMILdTd158zKxTnE8LNTVUTafM=;
        b=DThT3SpZBUlJBN9zO+Wzvq7Bd0klo3wZXOXsHNagwfBqVM/412HbxQ1gMXVEN2L6s6
         FDG9W4puqXq/kgorwfZeAgZY9pdCVZMsynH7abcPWSerzkYlQZzGRE6MVig+eI26C+TK
         cdkVel41GsI37dXb7SXsytQaAEPewyc6BvPEhDfJGULXvIm5UBTT5A0UkOViNOGlyvmI
         wy0A+vKAjIwQXSNZ/A7uxU+V6udrHKUJjBzbWg+Zg8T+ibruLTnSqcV9sfBB2Rqo06TV
         CnsocNHTKpSDpIuHz1jmdBlokbUJcnaHUsNPQatyFoZ3Ba2gdoXS+jBv1HwMKZdB4KmM
         N0cg==
X-Gm-Message-State: AOAM5312NZgyq6jrs9QT/lesKk0AsSKKJEDLjklYnOIBEfW0rMSD8bIO
        Xb0iZPMrUWjIkRsGeUo5vDnrwbKp4fk=
X-Google-Smtp-Source: ABdhPJyCu5XAEbe+/RmicRXi39Loz+FvVPjXzyWk/Z0QC7H7CxgzoQdd4ctTrWC7u2SUa+d8ffFVCw==
X-Received: by 2002:a17:902:d714:b0:153:2e9:3bcc with SMTP id w20-20020a170902d71400b0015302e93bccmr16990200ply.83.1650874288565;
        Mon, 25 Apr 2022 01:11:28 -0700 (PDT)
Received: from SX14.u-tokyo.ac.jp ([157.82.194.10])
        by smtp.gmail.com with ESMTPSA id o34-20020a634e62000000b0039cc4376415sm8824915pgl.63.2022.04.25.01.11.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Apr 2022 01:11:27 -0700 (PDT)
From:   Ritaro Takenaka <ritarot634@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Ritaro Takenaka <ritarot634@gmail.com>
Subject: [PATCH] nf_flowtable: ensure dst.dev is not blackhole
Date:   Mon, 25 Apr 2022 17:08:38 +0900
Message-Id: <20220425080835.5765-1-ritarot634@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Fixes sporadic IPv6 packet loss when flow offloading is enabled.
IPv6 route GC calls dst_dev_put() which makes dst.dev blackhole_netdev
even if dst is cached in flow offload. If a packet passes through this
invalid flow, packet loss will occur.
This is from Commit 227e1e4d0d6c (netfilter: nf_flowtable: skip device
lookup from interface index), as outdev was cached independently before.
Packet loss is reported on OpenWrt with Linux 5.4 and later.

Signed-off-by: Ritaro Takenaka <ritarot634@gmail.com>
---
 net/netfilter/nf_flow_table_ip.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 32c0eb1b4..12f81661d 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -624,6 +624,11 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 	if (nf_flow_state_check(flow, ip6h->nexthdr, skb, thoff))
 		return NF_ACCEPT;
 
+	if (unlikely(tuplehash->tuple.dst_cache->dev == blackhole_netdev)) {
+		flow_offload_teardown(flow);
+		return NF_ACCEPT;
+	}
+
 	if (skb_try_make_writable(skb, thoff + hdrsize))
 		return NF_DROP;
 
-- 
2.25.1

