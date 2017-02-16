From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [PATCH] netfilter: nfnetlink_queue: fix NFQA_VLAN_MAX definition
Date: Thu, 16 Feb 2017 18:20:33 +0900
Message-ID: <20170216092033.GA32010@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: The netfilter developer mailinglist
        <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:34424 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751982AbdBPJUh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Feb 2017 04:20:37 -0500
Received: by mail-pg0-f65.google.com with SMTP id v184so1511203pgv.1
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Feb 2017 01:20:37 -0800 (PST)
Received: from gmail.com (softbank218138040024.bbtec.net. [218.138.40.24])
        by smtp.gmail.com with ESMTPSA id u82sm12331464pfd.7.2017.02.16.01.20.35
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 16 Feb 2017 01:20:36 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
---
 include/uapi/linux/netfilter/nfnetlink_queue.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/netfilter/nfnetlink_queue.h b/include/uapi/linux/netfilter/nfnetlink_queue.h
index ae30841..d42f0396 100644
--- a/include/uapi/linux/netfilter/nfnetlink_queue.h
+++ b/include/uapi/linux/netfilter/nfnetlink_queue.h
@@ -36,7 +36,7 @@ enum nfqnl_vlan_attr {
 	NFQA_VLAN_TCI,			/* __be16 skb htons(vlan_tci) */
 	__NFQA_VLAN_MAX,
 };
-#define NFQA_VLAN_MAX (__NFQA_VLAN_MAX + 1)
+#define NFQA_VLAN_MAX (__NFQA_VLAN_MAX - 1)
 
 enum nfqnl_attr_type {
 	NFQA_UNSPEC,
-- 
2.1.4
