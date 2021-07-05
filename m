Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43390C07E99
	for <netfilter-devel@archiver.kernel.org>; Mon,  5 Jul 2021 12:38:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D298613B6
	for <netfilter-devel@archiver.kernel.org>; Mon,  5 Jul 2021 12:38:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230266AbhGEMlO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 5 Jul 2021 08:41:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230188AbhGEMlN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 5 Jul 2021 08:41:13 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEF37C061574
        for <netfilter-devel@vger.kernel.org>; Mon,  5 Jul 2021 05:38:35 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id h6so9050008plf.11
        for <netfilter-devel@vger.kernel.org>; Mon, 05 Jul 2021 05:38:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=U2m1PyHgjrJ3xRqTnmgir/ik4hMjaC5+XMr7CnyVw5o=;
        b=SMp8g/i9JNbk4jLFLgl6n1IVf5lhP48EltSvV3bwMT6HL+sxX22/5aAVCX+R8liPny
         5bqMVMgCkvtTYYfODAv8EfuBP6tFH8770oMEm8H4Us5r+Rx4SwQHMyknv0Rk+A2o0l1A
         kV4b80Q5eRha+pNSmJ8AmCKF3XQc2CxH6MIO6NJ6aJPtlPRkRTa0u4mXJueOPUW1yeol
         87Be00qeLaERkghzmo6raSYLhMacWj9OjX8qkcqUxcBnogv8qh4SzBe2ZQfHe0/Wrk+9
         8qWjRY1RIb2/wNzxCAa9L9Om89PLkWCbM6Epq884xJTyJxYrCgMVTXxFpLGGxz+jX1oI
         ysWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=U2m1PyHgjrJ3xRqTnmgir/ik4hMjaC5+XMr7CnyVw5o=;
        b=B4s9YlcSrVyWc3A20r+mozn5wsZNDEJ+HGz8jLckYtdmWvYEYFTxmTzFQVQCTekFUA
         zWoa5mOBlmTI5+pxT19oDEizoODYoEzhg6z9ShZzD5YpaZYKj5yDZNAdZPPbjfI6y5pO
         4RYThevwGW96rz1iXBFZRskEpp8K4SPVFiDWPu4mnfhdey2l3smyj6xwC92tIraa+ML2
         jka5+JF5lUj1RSV6ZtalPpwaR0rY7EEpjYoObhkjsybrgdJPZ4F7xL9Lne3kUJ9hangQ
         omLDrNGhJklAlRtWRE2uJtJBzaW1TqyCAJBTbpyNdvk0Or76vd+QkUDkY+/m5GGriMr2
         hGng==
X-Gm-Message-State: AOAM530VuZzlRVVMVTIIToTxPBXr3+JjKB0NTqTFbTER7ZzaXoHVfDWH
        LKuFQN29zu/pIL88dA0G/dg=
X-Google-Smtp-Source: ABdhPJxkLF6o1IHUsU7Nuqcx7lqUNltxA7zHCBaNCLZiPsECieMleRgTbWkIc37CdYpf3oYeXuxQGw==
X-Received: by 2002:a17:90a:130e:: with SMTP id h14mr14565936pja.50.1625488715212;
        Mon, 05 Jul 2021 05:38:35 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id cs1sm20754212pjb.56.2021.07.05.05.38.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jul 2021 05:38:34 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next] include: fix header file name in 3 comments
Date:   Mon,  5 Jul 2021 22:38:29 +1000
Message-Id: <20210705123829.10090-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 include/uapi/linux/netfilter/nfnetlink_log.h   | 2 +-
 include/uapi/linux/netfilter/nfnetlink_queue.h | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/netfilter/nfnetlink_log.h b/include/uapi/linux/netfilter/nfnetlink_log.h
index 45c8d3b027e0..0af9c113d665 100644
--- a/include/uapi/linux/netfilter/nfnetlink_log.h
+++ b/include/uapi/linux/netfilter/nfnetlink_log.h
@@ -61,7 +61,7 @@ enum nfulnl_attr_type {
 	NFULA_HWTYPE,			/* hardware type */
 	NFULA_HWHEADER,			/* hardware header */
 	NFULA_HWLEN,			/* hardware header length */
-	NFULA_CT,                       /* nf_conntrack_netlink.h */
+	NFULA_CT,                       /* nfnetlink_conntrack.h */
 	NFULA_CT_INFO,                  /* enum ip_conntrack_info */
 	NFULA_VLAN,			/* nested attribute: packet vlan info */
 	NFULA_L2HDR,			/* full L2 header */
diff --git a/include/uapi/linux/netfilter/nfnetlink_queue.h b/include/uapi/linux/netfilter/nfnetlink_queue.h
index bcb2cb5d40b9..aed90c4df0c8 100644
--- a/include/uapi/linux/netfilter/nfnetlink_queue.h
+++ b/include/uapi/linux/netfilter/nfnetlink_queue.h
@@ -51,11 +51,11 @@ enum nfqnl_attr_type {
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
-- 
2.17.5

