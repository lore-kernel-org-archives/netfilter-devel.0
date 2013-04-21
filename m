From: dmitry pervushin <dmitry.pervushin@linaro.org>
Subject: [PATCH 1/2] netfilter: idletimers, synchronize headers
Date: Sun, 21 Apr 2013 11:55:47 +0200
Message-ID: <1366538148-19759-2-git-send-email-dmitry.pervushin@linaro.org>
References: <1366538148-19759-1-git-send-email-dmitry.pervushin@linaro.org>
Cc: patches@linaro.org, dmitry pervushin <dmitry.pervushin@linaro.org>,
	Ashish Sharma <ashishsharma@google.com>,
	JP Abgrall <jpa@google.com>,
	John Stultz <john.stultz@linaro.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:34582 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223Ab3DUJ4J (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 21 Apr 2013 05:56:09 -0400
Received: by mail-wi0-f172.google.com with SMTP id hq17so2826440wib.5
        for <netfilter-devel@vger.kernel.org>; Sun, 21 Apr 2013 02:56:08 -0700 (PDT)
In-Reply-To: <1366538148-19759-1-git-send-email-dmitry.pervushin@linaro.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Synchronize include/linux/netfilter/xt_IDLETIMER.h with kernel

Cc: Ashish Sharma <ashishsharma@google.com>
Cc: JP Abgrall <jpa@google.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: dmitry pervushin <dmitry.pervushin@linaro.org>
---
 include/linux/netfilter/xt_IDLETIMER.h |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/include/linux/netfilter/xt_IDLETIMER.h b/include/linux/netfilter/xt_IDLETIMER.h
index 208ae93..96ed520 100644
--- a/include/linux/netfilter/xt_IDLETIMER.h
+++ b/include/linux/netfilter/xt_IDLETIMER.h
@@ -42,4 +42,18 @@ struct idletimer_tg_info {
 	struct idletimer_tg *timer __attribute__((aligned(8)));
 };
 
+#define NL_EVENT_TYPE_INACTIVE 0
+#define NL_EVENT_TYPE_ACTIVE 1
+
+struct idletimer_tg_info_v1 {
+	__u32 timeout;
+
+	char label[MAX_IDLETIMER_LABEL_SIZE];
+
+	/* Use netlink messages for notification in addition to sysfs */
+	__u8 send_nl_msg;
+
+	/* for kernel module internal use only */
+	struct idletimer_tg *timer __attribute__((aligned(8)));
+};
 #endif
-- 
1.7.10.4

