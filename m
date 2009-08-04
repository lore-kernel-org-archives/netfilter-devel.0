From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 095/103] netfilter: xt_quota: enable module lookup via arpt
Date: Tue,  4 Aug 2009 09:26:19 +0200
Message-ID: <1249370787-17583-96-git-send-email-jengelh@medozas.de>
References: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:56959 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932623AbZHDH2P (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Aug 2009 03:28:15 -0400
In-Reply-To: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/netfilter/xt_quota.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/netfilter/xt_quota.c b/net/netfilter/xt_quota.c
index 69c8659..81062ec 100644
--- a/net/netfilter/xt_quota.c
+++ b/net/netfilter/xt_quota.c
@@ -22,6 +22,7 @@ MODULE_AUTHOR("Sam Johnston <samj@samj.net>");
 MODULE_DESCRIPTION("Xtables: counter match");
 MODULE_ALIAS("ipt_quota");
 MODULE_ALIAS("ip6t_quota");
+MODULE_ALIAS("arpt_quota");
 
 static DEFINE_SPINLOCK(quota_lock);
 
-- 
1.6.3.3

