From: Josh Hunt <johunt@akamai.com>
Subject: [PATCH 1/4] net: netfilter: add nf_inet_addr_mask_inplace helper fn
Date: Tue, 21 Mar 2017 14:29:01 -0400
Message-ID: <1490120944-1770-2-git-send-email-johunt@akamai.com>
References: <1490120944-1770-1-git-send-email-johunt@akamai.com>
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, Josh Hunt <johunt@akamai.com>
To: kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from prod-mail-xrelay06.akamai.com ([96.6.114.98]:41443 "EHLO
        prod-mail-xrelay06.akamai.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1757580AbdCUSfC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Mar 2017 14:35:02 -0400
In-Reply-To: <1490120944-1770-1-git-send-email-johunt@akamai.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Adds new  helper function to be used for ipset nf_inet_addr netmask support.

Signed-off-by: Josh Hunt <johunt@akamai.com>
---
 include/linux/netfilter.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index a4b97be..4218969 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -39,6 +39,15 @@ static inline void nf_inet_addr_mask(const union nf_inet_addr *a1,
 	result->all[3] = a1->all[3] & mask->all[3];
 }
 
+static inline void nf_inet_addr_mask_inplace(union nf_inet_addr *a1,
+					     const union nf_inet_addr *mask)
+{
+	a1->all[0] &= mask->all[0];
+	a1->all[1] &= mask->all[1];
+	a1->all[2] &= mask->all[2];
+	a1->all[3] &= mask->all[3];
+}
+
 int netfilter_init(void);
 
 struct sk_buff;
-- 
1.9.1

