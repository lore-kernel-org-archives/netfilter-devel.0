From: Vlad Dogaru <ddvlad@rosedu.org>
Subject: [PATCH] netfilter: remove duplicate include line
Date: Tue, 31 Aug 2010 15:50:30 +0300
Message-ID: <1283259030-7765-1-git-send-email-ddvlad@rosedu.org>
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	coreteam@netfilter.org, Vlad Dogaru <ddvlad@rosedu.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from swarm.cs.pub.ro ([141.85.37.41]:37672 "EHLO swarm.cs.pub.ro"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757335Ab0HaM6o (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 31 Aug 2010 08:58:44 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

net/netfilter/xt_ipvs.c contained a duplicate header inclusion.

Signed-off-by: Vlad Dogaru <ddvlad@rosedu.org>
---
 net/netfilter/xt_ipvs.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/xt_ipvs.c b/net/netfilter/xt_ipvs.c
index 7a4d66d..9127a3d 100644
--- a/net/netfilter/xt_ipvs.c
+++ b/net/netfilter/xt_ipvs.c
@@ -16,7 +16,6 @@
 #include <linux/ip_vs.h>
 #include <linux/types.h>
 #include <linux/netfilter/x_tables.h>
-#include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/xt_ipvs.h>
 #include <net/netfilter/nf_conntrack.h>
 
-- 
1.7.0.4

