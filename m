From: Patrick McHardy <kaber@trash.net>
Subject: netlink 02/08: add NLA_PUT_BE64 macro
Date: Mon, 21 Jul 2008 18:17:25 +0200 (MEST)
Message-ID: <20080721161725.28572.50686.sendpatchset@localhost.localdomain>
References: <20080721161722.28572.97957.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:41611 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbYGUQR1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Jul 2008 12:17:27 -0400
In-Reply-To: <20080721161722.28572.97957.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

netlink: add NLA_PUT_BE64 macro

Add NLA_PUT_BE64 macro required for 64bit counters in netfilter

Signed-off-by: Krzysztof Piotr Oledzki <ole@ans.pl>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit fcb3e39fb15448bbbd8f0ab6fc8fbbe77a185f90
tree ef300d6b8c4aaf4202d0a6b35a2de716ef01bd85
parent 7af3d4eb70fd3a310c56c7080d7d09fc64ddd6a7
author Krzysztof Piotr Oledzki <ole@ans.pl> Mon, 21 Jul 2008 18:01:03 +0200
committer Patrick McHardy <kaber@trash.net> Mon, 21 Jul 2008 18:01:03 +0200

 include/net/netlink.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/net/netlink.h b/include/net/netlink.h
index dfc3701..18024b8 100644
--- a/include/net/netlink.h
+++ b/include/net/netlink.h
@@ -896,6 +896,9 @@ static inline int nla_put_msecs(struct sk_buff *skb, int attrtype,
 #define NLA_PUT_U64(skb, attrtype, value) \
 	NLA_PUT_TYPE(skb, u64, attrtype, value)
 
+#define NLA_PUT_BE64(skb, attrtype, value) \
+	NLA_PUT_TYPE(skb, __be64, attrtype, value)
+
 #define NLA_PUT_STRING(skb, attrtype, value) \
 	NLA_PUT(skb, attrtype, strlen(value) + 1, value)
 
