Return-Path: <SRS0=sICu=SR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A33EC282DA
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Apr 2019 17:01:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3810A2075B
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Apr 2019 17:01:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727784AbfDORAi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 15 Apr 2019 13:00:38 -0400
Received: from mail.us.es ([193.147.175.20]:50426 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727412AbfDORAi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 Apr 2019 13:00:38 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2F9961C442F
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Apr 2019 19:00:36 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 193C8DA70E
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Apr 2019 19:00:36 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 0E304DA70B; Mon, 15 Apr 2019 19:00:36 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 09E7FDA701;
        Mon, 15 Apr 2019 19:00:34 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 15 Apr 2019 19:00:34 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id D49F14265A31;
        Mon, 15 Apr 2019 19:00:33 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 01/22] time: Introduce jiffies64_to_msecs()
Date:   Mon, 15 Apr 2019 19:00:07 +0200
Message-Id: <20190415170028.3470-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190415170028.3470-1-pablo@netfilter.org>
References: <20190415170028.3470-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Li RongQing <lirongqing@baidu.com>

there is a similar helper in net/netfilter/nf_tables_api.c,
this maybe become a common request someday, so move it to
time.c

Signed-off-by: Zhang Yu <zhangyu31@baidu.com>
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Acked-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
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
index c3f756f8534b..9e3f79d4f5a8 100644
--- a/kernel/time/time.c
+++ b/kernel/time/time.c
@@ -783,6 +783,16 @@ u64 jiffies64_to_nsecs(u64 j)
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
index 90e6b09ef2af..ee1b0d1445aa 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3193,9 +3193,7 @@ static int nf_msecs_to_jiffies64(const struct nlattr *nla, u64 *result)
 
 static __be64 nf_jiffies64_to_msecs(u64 input)
 {
-	u64 ms = jiffies64_to_nsecs(input);
-
-	return cpu_to_be64(div_u64(ms, NSEC_PER_MSEC));
+	return cpu_to_be64(jiffies64_to_msecs(input));
 }
 
 static int nf_tables_fill_set(struct sk_buff *skb, const struct nft_ctx *ctx,
-- 
2.11.0

