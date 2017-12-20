From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: uapi: correct UNTRACKED conntrack state bit number
Date: Wed, 20 Dec 2017 12:08:33 +0100
Message-ID: <20171220110833.20312-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:42708 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754675AbdLTLIn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Dec 2017 06:08:43 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

nft_ct exposes this bit to userspace.  This used to be

  #define NF_CT_STATE_UNTRACKED_BIT              (1 << (IP_CT_NUMBER + 1))
  (IP_CT_NUMBER is 5, so this was 0x40)

.. but this got changed to 8 (0x100) when the untracked object got removed.
Replace this with a literal 6 to prevent further incompatible changes
in case IP_CT_NUMBER ever increases.

Fixes: cc41c84b7e7f2 ("netfilter: kill the fake untracked conntrack objects")
Reported-by: Li Shuang <shuali@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
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
2.13.6

