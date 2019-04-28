Return-Path: <SRS0=GfVU=S6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D4FDC43219
	for <netfilter-devel@archiver.kernel.org>; Sun, 28 Apr 2019 07:12:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3C71520881
	for <netfilter-devel@archiver.kernel.org>; Sun, 28 Apr 2019 07:12:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbfD1HMh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 28 Apr 2019 03:12:37 -0400
Received: from mx133-tc.baidu.com ([61.135.168.133]:38402 "EHLO
        tc-sys-mailedm01.tc.baidu.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726133AbfD1HMh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 28 Apr 2019 03:12:37 -0400
Received: from localhost (cp01-cos-dev01.cp01.baidu.com [10.92.119.46])
        by tc-sys-mailedm01.tc.baidu.com (Postfix) with ESMTP id A1F612040053
        for <netfilter-devel@vger.kernel.org>; Sun, 28 Apr 2019 15:12:19 +0800 (CST)
From:   Li RongQing <lirongqing@baidu.com>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH][nf-next] netfilter: slightly optimize nf_inet_addr_mask
Date:   Sun, 28 Apr 2019 15:12:19 +0800
Message-Id: <1556435539-7346-1-git-send-email-lirongqing@baidu.com>
X-Mailer: git-send-email 1.7.1
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

using 64bit computation to slightly optimize nf_inet_addr_mask

Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 include/linux/netfilter.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index a7252f3baeb0..996bc247ef6e 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -41,10 +41,19 @@ static inline void nf_inet_addr_mask(const union nf_inet_addr *a1,
 				     union nf_inet_addr *result,
 				     const union nf_inet_addr *mask)
 {
+#if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) && BITS_PER_LONG == 64
+	const unsigned long *ua = (const unsigned long *)a1;
+	unsigned long *ur = (unsigned long *)result;
+	const unsigned long *um = (const unsigned long *)mask;
+
+	ur[0] = ua[0] & um[0];
+	ur[1] = ua[1] & um[1];
+#else
 	result->all[0] = a1->all[0] & mask->all[0];
 	result->all[1] = a1->all[1] & mask->all[1];
 	result->all[2] = a1->all[2] & mask->all[2];
 	result->all[3] = a1->all[3] & mask->all[3];
+#endif
 }
 
 int netfilter_init(void);
-- 
2.16.2

