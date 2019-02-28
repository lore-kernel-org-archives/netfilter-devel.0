Return-Path: <SRS0=zt5D=RD=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46094C43381
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 Feb 2019 05:13:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 119F5205C9
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 Feb 2019 05:13:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730263AbfB1FNl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 28 Feb 2019 00:13:41 -0500
Received: from mx137-tc.baidu.com ([61.135.168.137]:33502 "EHLO
        tc-sys-mailedm05.tc.baidu.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725899AbfB1FNl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 28 Feb 2019 00:13:41 -0500
Received: from localhost (cp01-cos-dev01.cp01.baidu.com [10.92.119.46])
        by tc-sys-mailedm05.tc.baidu.com (Postfix) with ESMTP id F3AF31EBA004;
        Thu, 28 Feb 2019 13:13:26 +0800 (CST)
From:   Li RongQing <lirongqing@baidu.com>
To:     netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        sboyd@kernel.org, tglx@linutronix.de, john.stultz@linaro.org
Subject: [PATCH][v2] time: Introduce jiffies64_to_msecs()
Date:   Thu, 28 Feb 2019 13:13:26 +0800
Message-Id: <1551330806-12502-1-git-send-email-lirongqing@baidu.com>
X-Mailer: git-send-email 1.7.1
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

there is a similar helper in net/netfilter/nf_tables_api.c,
this maybe become a common request someday, so move it to
time.c

Signed-off-by: Zhang Yu <zhangyu31@baidu.com>
Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 v1-->v2: using jiffies64_to_msecs in nf_tables_api.c

 include/linux/jiffies.h       |  1 +
 kernel/time/time.c            | 10 ++++++++++
 net/netfilter/nf_tables_api.c |  4 +---
 3 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/include/linux/jiffies.h b/include/linux/jiffies.h
index fa928242567d..1b6d31da7cbc 100644
--- a/include/linux/jiffies.h
+++ b/include/linux/jiffies.h
@@ -297,6 +297,7 @@ static inline u64 jiffies_to_nsecs(const unsigned long j)
 }
 
 extern u64 jiffies64_to_nsecs(u64 j);
+extern u64 jiffies64_to_msecs(u64 j);
 
 extern unsigned long __msecs_to_jiffies(const unsigned int m);
 #if HZ <= MSEC_PER_SEC && !(MSEC_PER_SEC % HZ)
diff --git a/kernel/time/time.c b/kernel/time/time.c
index 2edb5088a70b..0083eb711fb7 100644
--- a/kernel/time/time.c
+++ b/kernel/time/time.c
@@ -719,6 +719,16 @@ u64 jiffies64_to_nsecs(u64 j)
 }
 EXPORT_SYMBOL(jiffies64_to_nsecs);
 
+u64 jiffies64_to_msecs(const u64 j)
+{
+#if HZ <= MSEC_PER_SEC && !(MSEC_PER_SEC % HZ)
+	return (MSEC_PER_SEC / HZ) * j;
+#else
+	return div_u64(j * HZ_TO_MSEC_NUM, HZ_TO_MSEC_DEN);
+#endif
+}
+EXPORT_SYMBOL(jiffies64_to_msecs);
+
 /**
  * nsecs_to_jiffies64 - Convert nsecs in u64 to jiffies64
  *
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index e1a88ba2249e..8763b2798788 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3184,9 +3184,7 @@ static int nf_msecs_to_jiffies64(const struct nlattr *nla, u64 *result)
 
 static __be64 nf_jiffies64_to_msecs(u64 input)
 {
-	u64 ms = jiffies64_to_nsecs(input);
-
-	return cpu_to_be64(div_u64(ms, NSEC_PER_MSEC));
+	return cpu_to_be64(jiffies64_to_msecs(input));
 }
 
 static int nf_tables_fill_set(struct sk_buff *skb, const struct nft_ctx *ctx,
-- 
2.16.2

