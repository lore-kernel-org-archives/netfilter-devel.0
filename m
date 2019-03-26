Return-Path: <SRS0=49hf=R5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CDBAC43381
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Mar 2019 12:06:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4EB992075C
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Mar 2019 12:06:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726266AbfCZMGg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 26 Mar 2019 08:06:36 -0400
Received: from mx58.baidu.com ([61.135.168.58]:12400 "EHLO
        tc-sys-mailedm04.tc.baidu.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726261AbfCZMGf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 26 Mar 2019 08:06:35 -0400
Received: from localhost (cp01-cos-dev01.cp01.baidu.com [10.92.119.46])
        by tc-sys-mailedm04.tc.baidu.com (Postfix) with ESMTP id B4576236C006
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Mar 2019 20:06:20 +0800 (CST)
From:   Li RongQing <lirongqing@baidu.com>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH][nf-next] netfilter: optimize nf_inet_addr_cmp
Date:   Tue, 26 Mar 2019 20:06:20 +0800
Message-Id: <1553601980-5016-1-git-send-email-lirongqing@baidu.com>
X-Mailer: git-send-email 1.7.1
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

optimize nf_inet_addr_cmp by 64bit xor computation
similar to ipv6_addr_equal()

Signed-off-by: Yuan Linsi <yuanlinsi01@baidu.com>
Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 include/linux/netfilter.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 72cb19c3db6a..4e0145ea033e 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -24,10 +24,17 @@ static inline int NF_DROP_GETERR(int verdict)
 static inline int nf_inet_addr_cmp(const union nf_inet_addr *a1,
 				   const union nf_inet_addr *a2)
 {
+#if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) && BITS_PER_LONG == 64
+	const unsigned long *ul1 = (const unsigned long *)a1;
+	const unsigned long *ul2 = (const unsigned long *)a2;
+
+	return ((ul1[0] ^ ul2[0]) | (ul1[1] ^ ul2[1])) == 0UL;
+#else
 	return a1->all[0] == a2->all[0] &&
 	       a1->all[1] == a2->all[1] &&
 	       a1->all[2] == a2->all[2] &&
 	       a1->all[3] == a2->all[3];
+#endif
 }
 
 static inline void nf_inet_addr_mask(const union nf_inet_addr *a1,
-- 
2.16.2

