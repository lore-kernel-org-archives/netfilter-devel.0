From: Josh Hunt <johunt@akamai.com>
Subject: [PATCH 3/3] xtables: libxt_TARPIT: Enable IPv6 support
Date: Sat,  7 Jul 2012 14:21:01 -0700
Message-ID: <1341696061-21863-4-git-send-email-johunt@akamai.com>
References: <1341696061-21863-1-git-send-email-johunt@akamai.com>
Cc: Josh Hunt <johunt@akamai.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from prod-mail-xrelay06.akamai.com ([96.6.114.98]:54398 "EHLO
	prod-mail-xrelay06.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751010Ab2GGVVC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 7 Jul 2012 17:21:02 -0400
Received: from prod-mail-xrelay06.akamai.com (localhost.localdomain [127.0.0.1])
	by postfix.imss70 (Postfix) with ESMTP id 9AAD6165494
	for <netfilter-devel@vger.kernel.org>; Sat,  7 Jul 2012 21:21:01 +0000 (GMT)
Received: from prod-mail-relay03.akamai.com (prod-mail-relay03.akamai.com [172.27.8.26])
	by prod-mail-xrelay06.akamai.com (Postfix) with ESMTP id 8FB921653F6
	for <netfilter-devel@vger.kernel.org>; Sat,  7 Jul 2012 21:21:01 +0000 (GMT)
In-Reply-To: <1341696061-21863-1-git-send-email-johunt@akamai.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Enables userspace IPv6 tarpit support.

Signed-off-by: Josh Hunt <johunt@akamai.com>
---
 extensions/libxt_TARPIT.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/extensions/libxt_TARPIT.c b/extensions/libxt_TARPIT.c
index 59c190f..6b65b09 100644
--- a/extensions/libxt_TARPIT.c
+++ b/extensions/libxt_TARPIT.c
@@ -106,7 +106,7 @@ static void tarpit_tg_save(const void *ip,
 static struct xtables_target tarpit_tg_reg = {
 	.version       = XTABLES_VERSION,
 	.name          = "TARPIT",
-	.family        = NFPROTO_IPV4,
+	.family        = NFPROTO_UNSPEC,
 	.size          = XT_ALIGN(sizeof(struct xt_tarpit_tginfo)),
 	.userspacesize = XT_ALIGN(sizeof(struct xt_tarpit_tginfo)),
 	.help          = tarpit_tg_help,
-- 
1.7.0.4

