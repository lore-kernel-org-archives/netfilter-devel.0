Return-Path: <SRS0=Z556=6P=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83EC9C47253
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 May 2020 15:57:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6553424956
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 May 2020 15:57:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729903AbgEAP5W (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 1 May 2020 11:57:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729858AbgEAP5V (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 1 May 2020 11:57:21 -0400
X-Greylist: delayed 528 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 01 May 2020 08:57:21 PDT
Received: from smail.fem.tu-ilmenau.de (smail.fem.tu-ilmenau.de [IPv6:2001:638:904:ffbf::41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D14AC061A0C
        for <netfilter-devel@vger.kernel.org>; Fri,  1 May 2020 08:57:21 -0700 (PDT)
Received: from mail.fem.tu-ilmenau.de (mail-zuse.net.fem.tu-ilmenau.de [172.21.220.54])
        (using TLSv1 with cipher ADH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by smail.fem.tu-ilmenau.de (Postfix) with ESMTPS id C3EA92049A;
        Fri,  1 May 2020 17:48:29 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by mail.fem.tu-ilmenau.de (Postfix) with ESMTP id 94D336208;
        Fri,  1 May 2020 17:48:29 +0200 (CEST)
X-Virus-Scanned: amavisd-new at fem.tu-ilmenau.de
Received: from mail.fem.tu-ilmenau.de ([127.0.0.1])
        by localhost (mail.fem.tu-ilmenau.de [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id DnMbFI5nz6-A; Fri,  1 May 2020 17:48:26 +0200 (CEST)
Received: from mail-backup.fem.tu-ilmenau.de (mail-backup.net.fem.tu-ilmenau.de [10.42.40.22])
        (using TLSv1 with cipher ADH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mail.fem.tu-ilmenau.de (Postfix) with ESMTPS;
        Fri,  1 May 2020 17:48:26 +0200 (CEST)
Received: from a234.fem.tu-ilmenau.de (ray-controller.net.fem.tu-ilmenau.de [10.42.51.234])
        by mail-backup.fem.tu-ilmenau.de (Postfix) with ESMTP id A3B0555116;
        Fri,  1 May 2020 17:48:26 +0200 (CEST)
Received: by a234.fem.tu-ilmenau.de (Postfix, from userid 1000)
        id 39604306AC0A; Fri,  1 May 2020 17:48:25 +0200 (CEST)
From:   Michael Braun <michael-dev@fami-braun.de>
To:     netfilter-devel@vger.kernel.org
Cc:     Michael Braun <michael-dev@fami-braun.de>
Subject: [PATCH 2/3] utils: fix UBSAN warning in fls
Date:   Fri,  1 May 2020 17:48:17 +0200
Message-Id: <20200501154819.2984-2-michael-dev@fami-braun.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200501154819.2984-1-michael-dev@fami-braun.de>
References: <20200501154819.2984-1-michael-dev@fami-braun.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

../include/utils.h:120:5: runtime error: left shift of 1103101952 by 1 places cannot be represented in type 'int'

Signed-off-by: Michael Braun <michael-dev@fami-braun.de>
---
 include/utils.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/utils.h b/include/utils.h
index 647e8bbe..f45f2513 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -94,7 +94,7 @@
  * This is defined the same way as ffs.
  * Note fls(0) = 0, fls(1) = 1, fls(0x80000000) = 32.
  */
-static inline int fls(int x)
+static inline int fls(uint32_t x)
 {
 	int r = 32;
 
-- 
2.20.1

