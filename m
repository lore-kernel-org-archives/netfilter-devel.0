From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf] netfilter: xt_ipcomp: add "ip[6]t_ipcomp" module alias name
Date: Wed, 12 Oct 2016 21:09:22 +0800
Message-ID: <1476277762-58471-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-14.163.com ([220.181.12.14]:50330 "EHLO m12-14.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755700AbcJLNKT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 12 Oct 2016 09:10:19 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

Otherwise, user cannot add related rules if xt_ipcomp.ko is not loaded:
  # iptables -A OUTPUT -p 108 -m ipcomp --ipcompspi 1
  iptables: No chain/target/match by that name.

Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
 net/netfilter/xt_ipcomp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/xt_ipcomp.c b/net/netfilter/xt_ipcomp.c
index 89d5310..000e703 100644
--- a/net/netfilter/xt_ipcomp.c
+++ b/net/netfilter/xt_ipcomp.c
@@ -26,6 +26,8 @@
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Fan Du <fan.du@windriver.com>");
 MODULE_DESCRIPTION("Xtables: IPv4/6 IPsec-IPComp SPI match");
+MODULE_ALIAS("ipt_ipcomp");
+MODULE_ALIAS("ip6t_ipcomp");
 
 /* Returns 1 if the spi is matched by the range, 0 otherwise */
 static inline bool
-- 
2.5.5


