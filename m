Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D0F7C07E96
	for <netfilter-devel@archiver.kernel.org>; Wed,  7 Jul 2021 00:57:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C3C761C3A
	for <netfilter-devel@archiver.kernel.org>; Wed,  7 Jul 2021 00:57:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbhGGBAh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 6 Jul 2021 21:00:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229834AbhGGBAg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Jul 2021 21:00:36 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF0BFC061574
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Jul 2021 17:57:56 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id a2so521031pgi.6
        for <netfilter-devel@vger.kernel.org>; Tue, 06 Jul 2021 17:57:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TqLYLHgD9gHRi94acC5BT5UtTpaF7CnJ0ZpCjgN7F0E=;
        b=gQblzrcDSBbw1/HGdgnRxJX/oqw6CLD85YYGGwGnAQowqHXQvclH9AcKOQHo+J0YXw
         rgfdRGRpLpRaZdZ7PXKF1KzkzYaccvd0o7hHSEQ7jb54M9urp4LxgCMYKvs91foRIkw+
         pxbVtxdJ/rf+TZQIduAQkdsp9Ww4pc+iXRXYH+L1SeuSj7WRyUhGdob8yvT5VY/R9119
         dh0a4pe8Amz43XVIK+v/pH9pO1lWZUnw97LiMndm8xO4YRm9JRLImzp7RDKiQckSEpCL
         eHK2WYbsNeFv2T5w2n0EV91J0p/79bDST7uoVG+7uheu0ntqMbDv1hnB/gvonxEEN2gg
         abww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=TqLYLHgD9gHRi94acC5BT5UtTpaF7CnJ0ZpCjgN7F0E=;
        b=DshzAGwdAuxynvr3n+jQuX7whuYJs/3k+sQwQKXzC2j/0dMTQYn4Y6RlgFwKh/cEZk
         U6SLjJzwr02W4Vmhkh9soU86F0qxVNecTVi5wwal6t6zHEGY7ZnRAetQaUy/YfJc7ye/
         GEsk5cWShDxIV+kRCTr8iaYRXqOVxYqgEzFkoSZA9h+6VHrk67YMxRKBwGHo6EaVSaHS
         EIpBoBoAE6epUiqCtnEvyUNpStjJPHoBW0Ojd1B5A/a1sOyWEPsswantO47iW23X5FSc
         YHmm7BBuS1W1U/qjeosreDl8yxUbJDIveoV/Gp70spCQDegaukrwIa0VAJfVFaB40E9J
         ISkw==
X-Gm-Message-State: AOAM5318uO17HDMLNjKKi0P8VHMx9g2yNbqHObdxzG2UwjWdDtT2+AJn
        /1Jdi9EYberUWPc7hlJP2VY=
X-Google-Smtp-Source: ABdhPJy4xF8vLze9540kZK8oJxxZQ8h0GWnKSEy+Ng7lrTkvGYwgok8TjNKN/MoawMqm4SbS6xMjmQ==
X-Received: by 2002:a63:4041:: with SMTP id n62mr23137427pga.204.1625619476457;
        Tue, 06 Jul 2021 17:57:56 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id n26sm19980418pgd.15.2021.07.06.17.57.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jul 2021 17:57:55 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf] netfilter: uapi: refer to nfnetlink_conntrack.h, not nf_conntrack_netlink.h
Date:   Wed,  7 Jul 2021 10:57:51 +1000
Message-Id: <20210707005751.12108-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210706224657.GA12859@salvia>
References: <20210706224657.GA12859@salvia>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

nf_conntrack_netlink.h does not exist, refer to nfnetlink_conntrack.h instead.

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

