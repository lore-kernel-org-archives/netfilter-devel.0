From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 7/8] netfilter: nfnetlink_queue: fix NFQA_VLAN_MAX definition
Date: Thu, 23 Feb 2017 12:14:08 +0100
Message-ID: <1487848449-2731-8-git-send-email-pablo@netfilter.org>
References: <1487848449-2731-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1487848449-2731-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>

Should be - 1 as in other _MAX definitions.

Signed-off-by: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/nfnetlink_queue.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/netfilter/nfnetlink_queue.h b/include/uapi/linux/netfilter/nfnetlink_queue.h
index ae30841ff94e..d42f0396fe30 100644
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
