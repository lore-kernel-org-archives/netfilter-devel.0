Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C2AFC433B4
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 May 2021 18:17:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E8D1761059
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 May 2021 18:17:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351478AbhERSTG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 18 May 2021 14:19:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351489AbhERSTF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 May 2021 14:19:05 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E5E7C061573
        for <netfilter-devel@vger.kernel.org>; Tue, 18 May 2021 11:17:47 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id p24so14821902ejb.1
        for <netfilter-devel@vger.kernel.org>; Tue, 18 May 2021 11:17:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VWuenKyGLGmgMt4Fj13+QAAVE4zZdn7Ji0fGSV4doQ4=;
        b=OfzI1q2nVtBIgJyxmpPHD2De/2zgFx9z0gYKUflgQ6WsqiINya79AP3+cxsSjw/B23
         G/YUli3Hu4L2jWbcmD9PXyIZcjfpjbN4QN/owJaQG6uVdvDXJDSJYnqkiMqkTqnh6Cn4
         zdTspE2Gl/lFbmjhY4yV7s+muusjEEsAAdwaXSo6FxkJaMIfmoXOPBDGGZIT4GHk0Hh3
         c517JkyLb+cunruqOdYGuP7kRg1SAtcXGY5RI/d4d6Wdo1c2UoW97JHr3ux2CfhdGnNV
         Luq7HdjdcdesYL/t8uyom6R/IipfIBFhrkwtw71/2neS5M8HhYIYRsW7l4HCdh9vQSxg
         Z8vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VWuenKyGLGmgMt4Fj13+QAAVE4zZdn7Ji0fGSV4doQ4=;
        b=VkzjMiwEixUWSe1MMpfZYVoTRyTLFYLdiJBw3OcNdhX4Gwvubv2BzEz4OX/8l3zDkn
         Pjs1OmJ8pEvRLetJ2HWvy/2reqbDibgBs4RTCh8hg6OoG16wVWiigdj9KJ6GicPCRxry
         oLp9bc64sMFxnts6OOwJj99+xpDcc26Z8iCiYQRre5ktui0kR5n6ySI4DDliTGje1wkN
         DWqVPIw8hlXxzq77/ki821/Cyk0vqmUwceuP36gXckGjHMAE5wLWOlOif+msXtspsrC2
         43kWx4gu9JFqL8fd+9rFy5Cse3IWiO5tqmZDs7fc7sorxF9J6W3fxHMYbSpR/8K6i9Ow
         CvIg==
X-Gm-Message-State: AOAM533qHCmeIrSUAxyfZDAU2jnLAKdq+m/NJoamOp8wwNG9n+wvJjfG
        p7JvnylgevEbYkzzmfHEN9DdOrdc42XYGxcaJ5I=
X-Google-Smtp-Source: ABdhPJxGVzWtHcTnH0Vcp/BSKdlCVPd9qxHTxNmaNVABy92RHihmnXtgBL/cxGvZqB8TIcIxWxW30w==
X-Received: by 2002:a17:907:7671:: with SMTP id kk17mr7430168ejc.185.1621361866101;
        Tue, 18 May 2021 11:17:46 -0700 (PDT)
Received: from localhost (ptr-5gw9tx0z7f066xyxzn.18120a2.ip6.access.telenet.be. [2a02:1810:510:3800:124:6af2:167b:d993])
        by smtp.gmail.com with ESMTPSA id cn21sm6560839edb.36.2021.05.18.11.17.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 May 2021 11:17:45 -0700 (PDT)
From:   Thomas De Schampheleire <patrickdepinguin@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     thomas.de_schampheleire@nokia.com
Subject: [ebtables PATCH 1/2] ebtables.h: restore KERNEL_64_USERSPACE_32 checks
Date:   Tue, 18 May 2021 20:17:29 +0200
Message-Id: <20210518181730.13436-1-patrickdepinguin@gmail.com>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Thomas De Schampheleire <thomas.de_schampheleire@nokia.com>

Commit e6359eedfbf497e52d52451072aea4713ed80a88 replaced the file ebtables.h
but removed the usage of KERNEL_64_USERSPACE_32. This breaks boards where
such flag is relevant, with following messages:

[ 6364.971346] kernel msg: ebtables bug: please report to author: Standard target size too big

Unable to update the kernel. Two possible causes:
1. Multiple ebtables programs were executing simultaneously. The ebtables
   userspace tool doesn't by default support multiple ebtables programs running
   concurrently. The ebtables option --concurrent or a tool like flock can be
   used to support concurrent scripts that update the ebtables kernel tables.
2. The kernel doesn't support a certain ebtables extension, consider
   recompiling your kernel or insmod the extension.

Analysis shows that the structure 'ebt_replace' passed from userspace
ebtables to the kernel, is too small, i.e 80 bytes instead of 120 in case of
64-bit kernel.

Note that the ebtables build system seems to assume that 'sparc64' is the
only case where KERNEL_64_USERSPACE_32 is relevant, but this is not true.
This situation can happen on many architectures, especially in embedded
systems. For example, an Aarch64 processor with kernel in 64-bit but
userland built for 32-bit Arm. Or a 64-bit MIPS Octeon III processor, with
userland running in the 'n32' ABI.

Signed-off-by: Thomas De Schampheleire <thomas.de_schampheleire@nokia.com>
---
 include/linux/netfilter_bridge/ebtables.h | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/include/linux/netfilter_bridge/ebtables.h b/include/linux/netfilter_bridge/ebtables.h
index 5be75f2..3c2b61e 100644
--- a/include/linux/netfilter_bridge/ebtables.h
+++ b/include/linux/netfilter_bridge/ebtables.h
@@ -49,12 +49,21 @@ struct ebt_replace {
 	/* total size of the entries */
 	unsigned int entries_size;
 	/* start of the chains */
+#ifdef KERNEL_64_USERSPACE_32
+	uint64_t hook_entry[NF_BR_NUMHOOKS];
+#else
 	struct ebt_entries *hook_entry[NF_BR_NUMHOOKS];
+#endif
 	/* nr of counters userspace expects back */
 	unsigned int num_counters;
 	/* where the kernel will put the old counters */
+#ifdef KERNEL_64_USERSPACE_32
+	uint64_t counters;
+	uint64_t entries;
+#else
 	struct ebt_counter *counters;
 	char *entries;
+#endif
 };
 
 struct ebt_replace_kernel {
@@ -129,6 +138,9 @@ struct ebt_entry_match {
 	} u;
 	/* size of data */
 	unsigned int match_size;
+#ifdef KERNEL_64_USERSPACE_32
+	unsigned int pad;
+#endif
 	unsigned char data[0] __attribute__ ((aligned (__alignof__(struct ebt_replace))));
 };
 
@@ -142,6 +154,9 @@ struct ebt_entry_watcher {
 	} u;
 	/* size of data */
 	unsigned int watcher_size;
+#ifdef KERNEL_64_USERSPACE_32
+	unsigned int pad;
+#endif
 	unsigned char data[0] __attribute__ ((aligned (__alignof__(struct ebt_replace))));
 };
 
@@ -155,6 +170,9 @@ struct ebt_entry_target {
 	} u;
 	/* size of data */
 	unsigned int target_size;
+#ifdef KERNEL_64_USERSPACE_32
+	unsigned int pad;
+#endif
 	unsigned char data[0] __attribute__ ((aligned (__alignof__(struct ebt_replace))));
 };
 
@@ -162,6 +180,9 @@ struct ebt_entry_target {
 struct ebt_standard_target {
 	struct ebt_entry_target target;
 	int verdict;
+#ifdef KERNEL_64_USERSPACE_32
+	unsigned int pad;
+#endif
 };
 
 /* one entry */
-- 
2.26.3

