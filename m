From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 015/103] netfilter: xtables: realign struct xt_target_param
Date: Tue,  4 Aug 2009 09:24:59 +0200
Message-ID: <1249370787-17583-16-git-send-email-jengelh@medozas.de>
References: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:50620 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932544AbZHDH0t (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Aug 2009 03:26:49 -0400
In-Reply-To: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Saves 8 bytes on x86_64.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter/x_tables.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 1030b75..4fa6e4c 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -238,9 +238,9 @@ struct xt_mtdtor_param {
  */
 struct xt_target_param {
 	const struct net_device *in, *out;
-	unsigned int hooknum;
 	const struct xt_target *target;
 	const void *targinfo;
+	unsigned int hooknum;
 	u_int8_t family;
 };
 
-- 
1.6.3.3

