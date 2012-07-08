From: Josh Hunt <johunt@akamai.com>
Subject: [PATCH v2 6/6] netfilter: tarpit: Enable IPv6 userspace support
Date: Sun,  8 Jul 2012 11:11:25 -0700
Message-ID: <1341771085-5771-7-git-send-email-johunt@akamai.com>
References: <1341771085-5771-1-git-send-email-johunt@akamai.com>
Cc: Josh Hunt <johunt@akamai.com>
To: jengelh@inai.de, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from prod-mail-xrelay06.akamai.com ([96.6.114.98]:41151 "EHLO
	prod-mail-xrelay06.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751541Ab2GHSL0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 8 Jul 2012 14:11:26 -0400
In-Reply-To: <1341771085-5771-1-git-send-email-johunt@akamai.com>
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

