From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH RFC 1/4] netlink: add NLA_PAD definition
Date: Wed,  7 Feb 2018 02:37:10 +0100
Message-ID: <20180207013713.2432-2-pablo@netfilter.org>
References: <20180207013713.2432-1-pablo@netfilter.org>
Cc: netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53320 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932222AbeBGBhV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Feb 2018 20:37:21 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 703A2392E04
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Feb 2018 02:37:20 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 62E1DDA3AE
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Feb 2018 02:37:20 +0100 (CET)
In-Reply-To: <20180207013713.2432-1-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The new generic netlink description infrastructure needs this new type
to describe padding attributes.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netlink.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/net/netlink.h b/include/net/netlink.h
index 0c154f98e987..76e850ead593 100644
--- a/include/net/netlink.h
+++ b/include/net/netlink.h
@@ -180,6 +180,7 @@ enum {
 	NLA_S32,
 	NLA_S64,
 	NLA_BITFIELD32,
+	NLA_PAD,
 	__NLA_TYPE_MAX,
 };
 
@@ -209,6 +210,7 @@ enum {
  *                         given type fits, using it verifies minimum length
  *                         just like "All other"
  *    NLA_BITFIELD32      A 32-bit bitmap/bitselector attribute
+ *    NLA_PAD		   Empty attribute to align next attribute to 64-bits
  *    All other            Minimum length of attribute payload
  *
  * Example:
-- 
2.11.0

