From: Jan Engelhardt <jengelh@medozas.de>
Subject: netfilter: xt_quota: fix incomplete initialization
Date: Thu, 18 Jun 2009 06:54:20 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0906180652290.12643@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:56721 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbZFREyT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Jun 2009 00:54:19 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Affects mainline and 2.6.30.

parent 167b2cd72bca6ca1cb3cf6a05d212cf11d65e08d (v2.6.30-rc6-1344-g167b2cd)
commit 93739b7ba1bbfdb010417a89fd72e08ae29890cc
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Thu Jun 18 06:47:44 2009 +0200

netfilter: xt_quota: fix incomplete initialization

Commit v2.6.29-rc5-872-gacc738f ("xtables: avoid pointer to self")
forgot to copy the initial quota value supplied by iptables into the
private structure, thus counting from whatever was in the memory
kmalloc returned.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/netfilter/xt_quota.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/netfilter/xt_quota.c b/net/netfilter/xt_quota.c
index 01dd07b..98fc190 100644
--- a/net/netfilter/xt_quota.c
+++ b/net/netfilter/xt_quota.c
@@ -54,6 +54,7 @@ static bool quota_mt_check(const struct xt_mtchk_param *par)
 	if (q->master == NULL)
 		return -ENOMEM;
 
+	q->master->quota = q->quota;
 	return true;
 }
 
-- 
# Created with git-export-patch

