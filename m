From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH iptables] extensions: libxt_TRACE: Add translation to nft
Date: Wed,  8 Jun 2016 20:47:03 +0800
Message-ID: <1465390023-28026-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-14.163.com ([220.181.12.14]:37419 "EHLO m12-14.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161596AbcFHMrg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Jun 2016 08:47:36 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

For example:

  # iptables-translate -t raw -A PREROUTING -j TRACE
  nft add rule ip raw PREROUTING counter nftrace set 1

Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
 extensions/libxt_TRACE.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/extensions/libxt_TRACE.c b/extensions/libxt_TRACE.c
index 0282e6f..7cb3585 100644
--- a/extensions/libxt_TRACE.c
+++ b/extensions/libxt_TRACE.c
@@ -7,12 +7,20 @@
 #include <xtables.h>
 #include <linux/netfilter/x_tables.h>
 
+static int trace_xlate(const void *ip, const struct xt_entry_target *target,
+		       struct xt_xlate *xl, int numeric)
+{
+	xt_xlate_add(xl, "nftrace set 1");
+	return 1;
+}
+
 static struct xtables_target trace_target = {
 	.family		= NFPROTO_UNSPEC,
 	.name		= "TRACE",
 	.version	= XTABLES_VERSION,
 	.size		= XT_ALIGN(0),
 	.userspacesize	= XT_ALIGN(0),
+	.xlate		= trace_xlate,
 };
 
 void _init(void)
-- 
2.5.5


