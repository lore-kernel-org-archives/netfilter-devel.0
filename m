From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 02/11] netfilter: xtables: fix incorrect return code
Date: Mon,  3 May 2010 11:51:27 +0200
Message-ID: <1272880297-11198-3-git-send-email-jengelh@medozas.de>
References: <1272880297-11198-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:59474 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752495Ab0ECJvx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 3 May 2010 05:51:53 -0400
In-Reply-To: <1272880297-11198-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/netfilter/xt_multiport.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/xt_multiport.c b/net/netfilter/xt_multiport.c
index 83b77ce..b21f904 100644
--- a/net/netfilter/xt_multiport.c
+++ b/net/netfilter/xt_multiport.c
@@ -117,7 +117,7 @@ static int multiport_mt_check(const struct xt_mtchk_param *par)
 	const struct xt_multiport_v1 *multiinfo = par->matchinfo;
 
 	return check(ip->proto, ip->invflags, multiinfo->flags,
-		     multiinfo->count);
+		     multiinfo->count) ? 0 : -EINVAL;
 }
 
 static int multiport_mt6_check(const struct xt_mtchk_param *par)
@@ -126,7 +126,7 @@ static int multiport_mt6_check(const struct xt_mtchk_param *par)
 	const struct xt_multiport_v1 *multiinfo = par->matchinfo;
 
 	return check(ip->proto, ip->invflags, multiinfo->flags,
-		     multiinfo->count);
+		     multiinfo->count) ? 0 : -EINVAL;
 }
 
 static struct xt_match multiport_mt_reg[] __read_mostly = {
-- 
1.7.0.5

