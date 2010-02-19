From: timg@tpi.com (Tim Gardner)
Subject: [PATCH] xt_recent: Fix false hit_count match
Date: Fri, 19 Feb 2010 10:49:04 -0700 (MST)
Message-ID: <20100219174904.1F62CF8C3F@sepang.rtg.net>
Cc: coreteam@netfilter.org, netfilter-devel@vger.kernel.org,
	netfilter@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.tpi.com ([70.99.223.143]:4734 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751617Ab0BSSRd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Feb 2010 13:17:33 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

>From 146111514a8c126268e848e45b7dd967329b072f Mon Sep 17 00:00:00 2001
From: Tim Gardner <tim.gardner@canonical.com>
Date: Thu, 18 Feb 2010 20:33:00 -0700
Subject: [PATCH] xt_recent: Fix false match.

A rule with a zero hit_count will always match.

Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
Cc: stable@kernel.org
---
 net/netfilter/xt_recent.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/xt_recent.c b/net/netfilter/xt_recent.c
index 1bb0d6c..43e83a4 100644
--- a/net/netfilter/xt_recent.c
+++ b/net/netfilter/xt_recent.c
@@ -260,7 +260,7 @@ recent_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 		for (i = 0; i < e->nstamps; i++) {
 			if (info->seconds && time_after(time, e->stamps[i]))
 				continue;
-			if (++hits >= info->hit_count) {
+			if (info->hit_count && ++hits >= info->hit_count) {
 				ret = !ret;
 				break;
 			}
-- 
1.6.2.4

