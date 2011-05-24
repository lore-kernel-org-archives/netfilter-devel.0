From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 12/24] libxt_ipvs: restore network-byte order
Date: Wed, 25 May 2011 01:08:13 +0200
Message-ID: <1306278506-11463-13-git-send-email-jengelh@medozas.de>
References: <1306278506-11463-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:40959 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933036Ab1EXXIl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 May 2011 19:08:41 -0400
In-Reply-To: <1306278506-11463-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_ipvs.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/extensions/libxt_ipvs.c b/extensions/libxt_ipvs.c
index 88d235f..4672766 100644
--- a/extensions/libxt_ipvs.c
+++ b/extensions/libxt_ipvs.c
@@ -32,12 +32,14 @@ static const struct xt_option_entry ipvs_mt_opts[] = {
 	{.name = "vaddr", .id = O_VADDR, .type = XTTYPE_HOSTMASK,
 	 .flags = XTOPT_INVERT},
 	{.name = "vport", .id = O_VPORT, .type = XTTYPE_PORT,
-	 .flags = XTOPT_INVERT | XTOPT_PUT, XTOPT_POINTER(s, vport)},
+	 .flags = XTOPT_NBO | XTOPT_INVERT | XTOPT_PUT,
+	 XTOPT_POINTER(s, vport)},
 	{.name = "vdir", .id = O_VDIR, .type = XTTYPE_STRING},
 	{.name = "vmethod", .id = O_VMETHOD, .type = XTTYPE_STRING,
 	 .flags = XTOPT_INVERT},
 	{.name = "vportctl", .id = O_VPORTCTL, .type = XTTYPE_PORT,
-	 .flags = XTOPT_INVERT | XTOPT_PUT, XTOPT_POINTER(s, vportctl)},
+	 .flags = XTOPT_NBO | XTOPT_INVERT | XTOPT_PUT,
+	 XTOPT_POINTER(s, vportctl)},
 	XTOPT_TABLEEND,
 };
 #undef s
-- 
1.7.3.4

