Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78B94C07E9B
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Jul 2021 01:37:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F47E61977
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Jul 2021 01:37:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229895AbhGFBjl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 5 Jul 2021 21:39:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229880AbhGFBjk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 5 Jul 2021 21:39:40 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65C8EC061574
        for <netfilter-devel@vger.kernel.org>; Mon,  5 Jul 2021 18:37:02 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id h4so19898416pgp.5
        for <netfilter-devel@vger.kernel.org>; Mon, 05 Jul 2021 18:37:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ttaOQmo/Dd83wfNbru2sFkECgKTbVAv/g/BowP+jrsU=;
        b=ZUCAGAaYpAV0b5wbut2QpRdXVBcyoOwYp1pVd70E/vg2xCoHXcEGmp7m+1wN0uKjn7
         MPWdftg40N51x/ey5P4Hcwxy627uLF1Xy2/i1rN9cswwf1fhNZzRA8G4/EieDuyxfkNG
         PoPalFUqnDfOZs2XTd4Kzq7I7aJiP795GKI4hsbq5bRYKw65jiWhps6v738sBeXd4JgY
         EG85+4iWispsI2Nssege4w2kYIL8PCCwfat7eGPfZ+8oGq9tJKkmY6ORHBqg7J+t4Co3
         95l0uJzqEorg5JATRKBGv/um93mL9NGCMqNWd3bFfMw7Lv91BcRPhMrkVRClXDNkY6sy
         boJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=ttaOQmo/Dd83wfNbru2sFkECgKTbVAv/g/BowP+jrsU=;
        b=P0+YQM/feAEZgJ30kWqsuXBSYE4DGW5yCF+ppUE/QYE1N1P9Jad+0U9LvasNClMOm9
         V2aeCb6sQLzgJbxcmhwSqAwPaPdX6q4BjE2i37+sMkmCGflf7wg9x1VWkZ8H3jA8N5CB
         NOICsMCDflQLUYwO/ehgf4kwXL+F7D9z/WIgqt2Jp3GMDgUb7FsCPb2Vy/U0r978VMTq
         Slfz8Jtx0u83+iET/7p5spU3wkmdbjmwrENw6REs0uzpgBmVyNGnCfwQlHcc5pigI0L7
         lvMg/Z68TEpl7nJG42hDesutrhRPP7WyszcHoQ9oMdfpTqhdRydzyuHPFbzMFxxkkMod
         L5og==
X-Gm-Message-State: AOAM532e+SKiyUbn12xTQzVeVq7tp+HLK1CvbwIPNlxANg08RCYzgjTz
        DE8ibuFKyVpu90/zHNfZlFFfLX5fy1g=
X-Google-Smtp-Source: ABdhPJzxPiLJNrDlkA/Dr5TIGyLVE+X8lz3aUj6ZHtcetQ08OW/mPCCyQuGZZMoF+BiwQhN64rX+cw==
X-Received: by 2002:a62:3344:0:b029:28c:6f0f:cb90 with SMTP id z65-20020a6233440000b029028c6f0fcb90mr17583404pfz.58.1625535421927;
        Mon, 05 Jul 2021 18:37:01 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id y11sm14533663pfo.160.2021.07.05.18.36.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jul 2021 18:37:01 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue v2] src: annotation: Correctly identify item for which header is needed
Date:   Tue,  6 Jul 2021 11:36:56 +1000
Message-Id: <20210706013656.10833-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <YOL6jXNMeRGh+BlX@slk1.local.net>
References: <YOL6jXNMeRGh+BlX@slk1.local.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Also fix header annotation to refer to nfnetlink_conntrack.h,
not nf_conntrack_netlink.h

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 examples/nf-queue.c                                | 2 +-
 include/libnetfilter_queue/linux_nfnetlink_queue.h | 4 ++--
 include/linux/netfilter/nfnetlink_queue.h          | 4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/examples/nf-queue.c b/examples/nf-queue.c
index 3da2c24..5b86e69 100644
--- a/examples/nf-queue.c
+++ b/examples/nf-queue.c
@@ -15,7 +15,7 @@
 
 #include <libnetfilter_queue/libnetfilter_queue.h>
 
-/* only for NFQA_CT, not needed otherwise: */
+/* NFQA_CT requires CTA_* attributes defined in nfnetlink_conntrack.h */
 #include <linux/netfilter/nfnetlink_conntrack.h>
 
 static struct mnl_socket *nl;
diff --git a/include/libnetfilter_queue/linux_nfnetlink_queue.h b/include/libnetfilter_queue/linux_nfnetlink_queue.h
index 1975dfa..caa6788 100644
--- a/include/libnetfilter_queue/linux_nfnetlink_queue.h
+++ b/include/libnetfilter_queue/linux_nfnetlink_queue.h
@@ -46,11 +46,11 @@ enum nfqnl_attr_type {
 	NFQA_IFINDEX_PHYSOUTDEV,	/* __u32 ifindex */
 	NFQA_HWADDR,			/* nfqnl_msg_packet_hw */
 	NFQA_PAYLOAD,			/* opaque data payload */
-	NFQA_CT,			/* nf_conntrack_netlink.h */
+	NFQA_CT,			/* nfnetlink_conntrack.h */
 	NFQA_CT_INFO,			/* enum ip_conntrack_info */
 	NFQA_CAP_LEN,			/* __u32 length of captured packet */
 	NFQA_SKB_INFO,			/* __u32 skb meta information */
-	NFQA_EXP,			/* nf_conntrack_netlink.h */
+	NFQA_EXP,			/* nfnetlink_conntrack.h */
 	NFQA_UID,			/* __u32 sk uid */
 	NFQA_GID,			/* __u32 sk gid */
 	NFQA_SECCTX,			/* security context string */
diff --git a/include/linux/netfilter/nfnetlink_queue.h b/include/linux/netfilter/nfnetlink_queue.h
index 030672d..8e2e469 100644
--- a/include/linux/netfilter/nfnetlink_queue.h
+++ b/include/linux/netfilter/nfnetlink_queue.h
@@ -42,11 +42,11 @@ enum nfqnl_attr_type {
 	NFQA_IFINDEX_PHYSOUTDEV,	/* __u32 ifindex */
 	NFQA_HWADDR,			/* nfqnl_msg_packet_hw */
 	NFQA_PAYLOAD,			/* opaque data payload */
-	NFQA_CT,			/* nf_conntrack_netlink.h */
+	NFQA_CT,			/* nfnetlink_conntrack.h */
 	NFQA_CT_INFO,			/* enum ip_conntrack_info */
 	NFQA_CAP_LEN,			/* __u32 length of captured packet */
 	NFQA_SKB_INFO,			/* __u32 skb meta information */
-	NFQA_EXP,			/* nf_conntrack_netlink.h */
+	NFQA_EXP,			/* nfnetlink_conntrack.h */
 	NFQA_UID,			/* __u32 sk uid */
 	NFQA_GID,			/* __u32 sk gid */
 	NFQA_SECCTX,
-- 
2.17.5

