From: Krzysztof Piotr Oledzki <ole@ans.pl>
Subject: [PATCH 1/2] Netlink: add NLA_PUT_BE64 macro
Date: Thu, 19 Jun 2008 13:00:22 +0200
Message-ID: <485a3c46.olkruYb9LvrAfxtt%ole@ans.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bizon.gios.gov.pl ([212.244.124.8]:35035 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582AbYFSLA0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Jun 2008 07:00:26 -0400
Received: from bizon.gios.gov.pl (ole@localhost6 [IPv6:::1])
	by bizon.gios.gov.pl (8.14.2/8.14.1) with ESMTP id m5JB0MVF022160
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <netfilter-devel@vger.kernel.org>; Thu, 19 Jun 2008 13:00:24 +0200
Received: (from ole@localhost)
	by bizon.gios.gov.pl (8.14.2/8.14.1/Submit) id m5JB0Mee022159
	for netfilter-devel@vger.kernel.org; Thu, 19 Jun 2008 13:00:22 +0200
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

>From bb5c78816df6d9506f5e0aa1c1e7432dcd6efc0d Mon Sep 17 00:00:00 2001
From: Krzysztof Piotr Oledzki <ole@ans.pl>
Date: Mon, 16 Jun 2008 22:48:49 +0200
Subject: Netlink: add NLA_PUT_BE64 macro

Add NLA_PUT_BE64 macro required for 64bit counters in netfilter

Signed-off-by: Krzysztof Piotr Oledzki <ole@ans.pl>
---
 include/net/netlink.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/net/netlink.h b/include/net/netlink.h
index 112dcdf..4518490 100644
--- a/include/net/netlink.h
+++ b/include/net/netlink.h
@@ -898,6 +898,9 @@ static inline int nla_put_msecs(struct sk_buff *skb, int attrtype,
 #define NLA_PUT_U64(skb, attrtype, value) \
 	NLA_PUT_TYPE(skb, u64, attrtype, value)
 
+#define NLA_PUT_BE64(skb, attrtype, value) \
+	NLA_PUT_TYPE(skb, __be64, attrtype, value)
+
 #define NLA_PUT_STRING(skb, attrtype, value) \
 	NLA_PUT(skb, attrtype, strlen(value) + 1, value)
 
-- 
1.5.5.4

