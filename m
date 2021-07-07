Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 567A8C07E96
	for <netfilter-devel@archiver.kernel.org>; Wed,  7 Jul 2021 01:26:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C4A961C81
	for <netfilter-devel@archiver.kernel.org>; Wed,  7 Jul 2021 01:26:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbhGGB31 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 6 Jul 2021 21:29:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbhGGB30 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Jul 2021 21:29:26 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F104C061574
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Jul 2021 18:26:46 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id 37so617579pgq.0
        for <netfilter-devel@vger.kernel.org>; Tue, 06 Jul 2021 18:26:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gMUprEkvNKDrSeeU7av7wZtNJ8awLhDL6P/If9WDOjo=;
        b=M1xLDC5mMf9JB+suc6maeIazp0uWbQaqmbDK7PlTaI3UrMz+Mhbdc0Y5dyu7drvRr2
         X8Hc6hKeMeT87GAKV2y9cczBOf2SUf6MdeVb1S/39oEPdfaLDTGhkiFnQSgKVTWTd5Ey
         6nvWhUZUSyzYYMat1fkQNvzEDEWgK4dPlhCY98oZhrOeFgiL2S4WnmEm/q4gjdI4g8BD
         p69rqEZ89yTpCFkFgefYu3nUjKTw7DwQ9X/0OEujmEE6B+JXEBme26NHQEbWm4DavxGo
         VBc+2teIDrm1/aYyhWQMEPBr9cqQffl3PzrKDx4SGgi3oLORKFqxaYWP379ALnnRR3QX
         z5Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=gMUprEkvNKDrSeeU7av7wZtNJ8awLhDL6P/If9WDOjo=;
        b=toUZpxs4yyHz3fkl08J/w6SLhQ46lNFKqCw529Y+QLqvEn04kkge9a7upd0FgbCqWm
         KEmjdyI0GpXKN3wao5A6cCGzdGQaMknZF/16aKBnGVbxftr3m51IBOZsZHK/OY+Xfp/5
         hVkKUB8EKJ7El1P4tDtt0zU5fhyFBL0kwpXULJ/opAmrqHbYrXkca/XxIVlSfK87C9eT
         7tvIe0tinlbTyGey/vuj4hq3cWQ+Y7DfWe3tNAC5lBtIIC4rJxY5BuXlsoQnUsdefqEI
         Z8aAZ4bmVoSoB1ZLRL9EpSUc+mUer8AREVIpiXWTZUkkjsgEOgR6mpt/pkhC1GX921XD
         nl7Q==
X-Gm-Message-State: AOAM5336WJELGig8gVgyejlbcSQSGmz2abe2QcbUDQntPqx5EFRmnewn
        OA1cDX7IBjjJPLfjI6tDKqI=
X-Google-Smtp-Source: ABdhPJzYJxvWnYGhQkLP/WgLTibx5JBGkPnkrhvixu05JaAqMoq077GEx1kao67SQYl6OFjjCV1LDw==
X-Received: by 2002:a63:5513:: with SMTP id j19mr23438680pgb.192.1625621205617;
        Tue, 06 Jul 2021 18:26:45 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id y11sm5257384pfm.190.2021.07.06.18.26.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jul 2021 18:26:45 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue] include: refer to nfnetlink_conntrack.h, not nf_conntrack_netlink.h
Date:   Wed,  7 Jul 2021 11:26:41 +1000
Message-Id: <20210707012641.12229-1-duncan_roe@optusnet.com.au>
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
 include/libnetfilter_queue/linux_nfnetlink_queue.h | 4 ++--
 include/linux/netfilter/nfnetlink_queue.h          | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

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

