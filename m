From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 5/5] libxt_CONNSECMARK: fix spacing in output
Date: Mon,  5 Sep 2011 20:22:53 +0200
Message-ID: <1315246974-11538-6-git-send-email-jengelh@medozas.de>
References: <1315246974-11538-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:33343 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752986Ab1IESXC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 5 Sep 2011 14:23:02 -0400
In-Reply-To: <1315246974-11538-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Tom Eastep <teastep@shorewall.net>

~# iptables -t mangle -A foo -j CONNSECMARK --save
~# iptables -t mangle -S
[...]
-A foo -j CONNSECMARK--save

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_CONNSECMARK.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/extensions/libxt_CONNSECMARK.c b/extensions/libxt_CONNSECMARK.c
index df2e6b8..0b3cd79 100644
--- a/extensions/libxt_CONNSECMARK.c
+++ b/extensions/libxt_CONNSECMARK.c
@@ -87,7 +87,7 @@ CONNSECMARK_save(const void *ip, const struct xt_entry_target *target)
 	const struct xt_connsecmark_target_info *info =
 		(struct xt_connsecmark_target_info*)target->data;
 
-	printf("--");
+	printf(" --");
 	print_connsecmark(info);
 }
 
-- 
1.7.3.4

