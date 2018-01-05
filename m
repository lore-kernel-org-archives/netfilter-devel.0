From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/3] netfilter: uapi: correct UNTRACKED conntrack state bit number
Date: Fri,  5 Jan 2018 16:08:24 +0100
Message-ID: <20180105150825.18460-3-pablo@netfilter.org>
References: <20180105150825.18460-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38774 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751514AbeAEPIf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 5 Jan 2018 10:08:35 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0BDD2C5154
        for <netfilter-devel@vger.kernel.org>; Fri,  5 Jan 2018 16:08:34 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EE9E434D7
        for <netfilter-devel@vger.kernel.org>; Fri,  5 Jan 2018 16:08:33 +0100 (CET)
In-Reply-To: <20180105150825.18460-1-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Florian Westphal <fw@strlen.de>

nft_ct exposes this bit to userspace.  This used to be

  #define NF_CT_STATE_UNTRACKED_BIT              (1 << (IP_CT_NUMBER + 1))
  (IP_CT_NUMBER is 5, so this was 0x40)

.. but this got changed to 8 (0x100) when the untracked object got removed.
Replace this with a literal 6 to prevent further incompatible changes
in case IP_CT_NUMBER ever increases.

Fixes: cc41c84b7e7f2 ("netfilter: kill the fake untracked conntrack objects")
Reported-by: Li Shuang <shuali@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/nf_conntrack_common.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/netfilter/nf_conntrack_common.h b/include/uapi/linux/netfilter/nf_conntrack_common.h
index 3fea7709a441..57ccfb32e87f 100644
--- a/include/uapi/linux/netfilter/nf_conntrack_common.h
+++ b/include/uapi/linux/netfilter/nf_conntrack_common.h
@@ -36,7 +36,7 @@ enum ip_conntrack_info {
 
 #define NF_CT_STATE_INVALID_BIT			(1 << 0)
 #define NF_CT_STATE_BIT(ctinfo)			(1 << ((ctinfo) % IP_CT_IS_REPLY + 1))
-#define NF_CT_STATE_UNTRACKED_BIT		(1 << (IP_CT_UNTRACKED + 1))
+#define NF_CT_STATE_UNTRACKED_BIT		(1 << 6)
 
 /* Bitset representing status of connection. */
 enum ip_conntrack_status {
-- 
2.11.0

