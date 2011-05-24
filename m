From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 14/24] libip6t_rt: restore --rt-type storing
Date: Wed, 25 May 2011 01:08:15 +0200
Message-ID: <1306278506-11463-15-git-send-email-jengelh@medozas.de>
References: <1306278506-11463-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:40966 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752365Ab1EXXIn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 May 2011 19:08:43 -0400
In-Reply-To: <1306278506-11463-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libip6t_rt.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/extensions/libip6t_rt.c b/extensions/libip6t_rt.c
index eb30820..9e6868d 100644
--- a/extensions/libip6t_rt.c
+++ b/extensions/libip6t_rt.c
@@ -31,8 +31,8 @@ IP6T_RT_HOPS);
 
 #define s struct ip6t_rt
 static const struct xt_option_entry rt_opts[] = {
-	{.name = "rt-type", .id = O_RT_TYPE, .type = XTTYPE_UINT32RC,
-	 .flags = XTOPT_INVERT},
+	{.name = "rt-type", .id = O_RT_TYPE, .type = XTTYPE_UINT32,
+	 .flags = XTOPT_INVERT | XTOPT_PUT, XTOPT_POINTER(s, rt_type)},
 	{.name = "rt-segsleft", .id = O_RT_SEGSLEFT, .type = XTTYPE_UINT32RC,
 	 .flags = XTOPT_INVERT | XTOPT_PUT, XTOPT_POINTER(s, segsleft)},
 	{.name = "rt-len", .id = O_RT_LEN, .type = XTTYPE_UINT32,
-- 
1.7.3.4

