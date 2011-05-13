From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 12/12] libip6t_rt: rt-0-not-strict should take no arg
Date: Fri, 13 May 2011 02:47:36 +0200
Message-ID: <1305247657-29158-13-git-send-email-jengelh@medozas.de>
References: <1305247657-29158-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:54353 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759045Ab1EMAtl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 May 2011 20:49:41 -0400
In-Reply-To: <1305247657-29158-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This unfortunately got mixed up during the getopt -> guided parser
move.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libip6t_rt.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/extensions/libip6t_rt.c b/extensions/libip6t_rt.c
index 11bfda9..eb30820 100644
--- a/extensions/libip6t_rt.c
+++ b/extensions/libip6t_rt.c
@@ -39,7 +39,7 @@ static const struct xt_option_entry rt_opts[] = {
 	 .flags = XTOPT_INVERT | XTOPT_PUT, XTOPT_POINTER(s, hdrlen)},
 	{.name = "rt-0-res", .id = O_RT0RES, .type = XTTYPE_NONE},
 	{.name = "rt-0-addrs", .id = O_RT0ADDRS, .type = XTTYPE_STRING},
-	{.name = "rt-0-not-strict", .id = O_RT0NSTRICT, .type = XTTYPE_STRING},
+	{.name = "rt-0-not-strict", .id = O_RT0NSTRICT, .type = XTTYPE_NONE},
 	XTOPT_TABLEEND,
 };
 #undef s
-- 
1.7.1

