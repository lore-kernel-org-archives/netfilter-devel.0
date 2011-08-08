From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 5/7] build: strengthen check for overlong lladdr components
Date: Mon,  8 Aug 2011 02:42:21 +0200
Message-ID: <1312764144-23849-6-git-send-email-jengelh@medozas.de>
References: <1312764144-23849-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:44411 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753175Ab1HHAmc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 7 Aug 2011 20:42:32 -0400
In-Reply-To: <1312764144-23849-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

ethermac[i] > UINT8_MAX is quite pointless, because ethermac[i] is
just uint8_t. To catch values that are not in the range "00"-"ff", use
a string length check (end-arg>2). I am willingly using 2 there,
because no one is going to specify an Ethernet LL address as
"0x00:0x24:0xbe:0xc2:0x7f:0x16" -- because it is always interpreted as
hexadecimal anyway even without the 0x prefix.

xtoptions.c: In function "xtopt_parse_ethermac":
xtoptions.c:760:3: warning: comparison is always false due to limited range of data type
xtoptions.c:766:2: warning: comparison is always false due to limited range of data type

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 iptables/xtoptions.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/iptables/xtoptions.c b/iptables/xtoptions.c
index 1423724..7095e3e 100644
--- a/iptables/xtoptions.c
+++ b/iptables/xtoptions.c
@@ -757,13 +757,13 @@ static void xtopt_parse_ethermac(struct xt_option_call *cb)
 
 	for (i = 0; i < ARRAY_SIZE(cb->val.ethermac) - 1; ++i) {
 		cb->val.ethermac[i] = strtoul(arg, &end, 16);
-		if (cb->val.ethermac[i] > UINT8_MAX || *end != ':')
+		if (*end != ':' || end - arg > 2)
 			goto out;
 		arg = end + 1;
 	}
 	i = ARRAY_SIZE(cb->val.ethermac) - 1;
 	cb->val.ethermac[i] = strtoul(arg, &end, 16);
-	if (cb->val.ethermac[i] > UINT8_MAX || *end != '\0')
+	if (*end != '\0' || end - arg > 2)
 		goto out;
 	if (cb->entry->flags & XTOPT_PUT)
 		memcpy(XTOPT_MKPTR(cb), cb->val.ethermac,
-- 
1.7.3.4

