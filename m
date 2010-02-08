From: Florian Westphal <fwestphal@astaro.com>
Subject: [PATCH nf-next] netfilter: fix build failure with CONNTRACK=y NAT=n
Date: Mon,  8 Feb 2010 11:57:49 +0100
Message-ID: <1265626669-24689-1-git-send-email-fwestphal@astaro.com>
Cc: Florian Westphal <fwestphal@astaro.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from exsmtpd002-1.dex002.intermedia.net ([64.78.19.133]:1956 "EHLO
	EXSMTPD002-1.dex002.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750772Ab0BHLMq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Feb 2010 06:12:46 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

net/ipv4/netfilter/nf_defrag_ipv4.c: In function 'ipv4_conntrack_defrag':
net/ipv4/netfilter/nf_defrag_ipv4.c:62: error: implicit declaration of function 'nf_ct_is_template'

Signed-off-by: Florian Westphal <fwestphal@astaro.com>
---
 net/ipv4/netfilter/nf_defrag_ipv4.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/ipv4/netfilter/nf_defrag_ipv4.c b/net/ipv4/netfilter/nf_defrag_ipv4.c
index 77627fa..f6f4668 100644
--- a/net/ipv4/netfilter/nf_defrag_ipv4.c
+++ b/net/ipv4/netfilter/nf_defrag_ipv4.c
@@ -17,6 +17,7 @@
 #include <linux/netfilter_bridge.h>
 #include <linux/netfilter_ipv4.h>
 #include <net/netfilter/ipv4/nf_defrag_ipv4.h>
+#include <net/netfilter/nf_conntrack.h>
 
 /* Returns new sk_buff, or NULL */
 static int nf_ct_ipv4_gather_frags(struct sk_buff *skb, u_int32_t user)
-- 
1.6.3.3

