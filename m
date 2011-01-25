From: Simon Horman <horms@verge.net.au>
Subject: [PATCH] IPVS: Remove unused pr_fmt #define
Date: Tue, 25 Jan 2011 15:15:53 +1000
Message-ID: <1295932553-13854-1-git-send-email-horms@verge.net.au>
Cc: Simon Horman <horms@verge.net.au>, Joe Perches <joe@perches.com>
To: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
	lvs-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:44422 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257Ab1AYFQA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Jan 2011 00:16:00 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Cc: Joe Perches <joe@perches.com>
Signed-off-by: Simon Horman <horms@verge.net.au>
---
 net/netfilter/ipvs/ip_vs_app.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_app.c b/net/netfilter/ipvs/ip_vs_app.c
index 5c48ffb..e2a19d0 100644
--- a/net/netfilter/ipvs/ip_vs_app.c
+++ b/net/netfilter/ipvs/ip_vs_app.c
@@ -19,7 +19,6 @@
  */
 
 #define KMSG_COMPONENT "IPVS"
-#define pr_fmt(fmt) KMSG_COMPONENT ": " fmt
 
 #include <linux/module.h>
 #include <linux/kernel.h>
-- 
1.7.2.3

