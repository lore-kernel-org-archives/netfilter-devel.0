From: Patrick McHardy <kaber@trash.net>
Subject: [NETLINK 38/64]: Add NLA_PUT_BE16/nla_get_be16()
Date: Tue, 18 Dec 2007 00:47:05 +0100 (MET)
Message-ID: <20071217234704.23601.94483.sendpatchset@localhost.localdomain>
References: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38998 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760240AbXLQXrG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Dec 2007 18:47:06 -0500
In-Reply-To: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETLINK]: Add NLA_PUT_BE16/nla_get_be16()

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 114dd2440180d6f7ffc861b75ea0b0f09441b7e2
tree 4d5074a1840ba8244f196a62708ea31441a2dace
parent b44099f1aeaa1b0b60ce3bbc9ec647f42fb2fc77
author Patrick McHardy <kaber@trash.net> Mon, 17 Dec 2007 14:58:24 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 18 Dec 2007 00:24:57 +0100

 include/net/netlink.h |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/include/net/netlink.h b/include/net/netlink.h
index db4b935..a52d036 100644
--- a/include/net/netlink.h
+++ b/include/net/netlink.h
@@ -881,6 +881,9 @@ static inline int nla_put_msecs(struct sk_buff *skb, int attrtype,
 #define NLA_PUT_LE16(skb, attrtype, value) \
 	NLA_PUT_TYPE(skb, __le16, attrtype, value)
 
+#define NLA_PUT_BE16(skb, attrtype, value) \
+	NLA_PUT_TYPE(skb, __be16, attrtype, value)
+
 #define NLA_PUT_U32(skb, attrtype, value) \
 	NLA_PUT_TYPE(skb, u32, attrtype, value)
 
@@ -927,6 +930,15 @@ static inline u16 nla_get_u16(struct nlattr *nla)
 }
 
 /**
+ * nla_get_be16 - return payload of __be16 attribute
+ * @nla: __be16 netlink attribute
+ */
+static inline __be16 nla_get_be16(struct nlattr *nla)
+{
+	return *(__be16 *) nla_data(nla);
+}
+
+/**
  * nla_get_le16 - return payload of __le16 attribute
  * @nla: __le16 netlink attribute
  */
