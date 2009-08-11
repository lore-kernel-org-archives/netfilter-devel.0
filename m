From: Jan Engelhardt <jengelh@medozas.de>
Subject: resend|stable: netfilter: xt_quota: fix wrong return value (error
 case)
Date: Tue, 11 Aug 2009 19:50:45 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0908111949130.1698@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:53838 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485AbZHKRuq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 11 Aug 2009 13:50:46 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

parent 244e5a09ed31c698654a7f9a2150b4c79efe46fd (v2.6.31-rc1-59-g244e5a0)
commit 8240c9c836726615e9fb164fb7637c0156560b2e
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Wed Jul 22 04:42:09 2009 +0200

netfilter: xt_quota: fix wrong return value (error case)

Success was indicated on a memory allocation failure, thereby causing
a crash due to a later NULL deref.
(Affects v2.6.30-rc1 up to here.)

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/netfilter/xt_quota.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/xt_quota.c b/net/netfilter/xt_quota.c
index ad0ed79..0de9fcf 100644
--- a/net/netfilter/xt_quota.c
+++ b/net/netfilter/xt_quota.c
@@ -52,7 +52,7 @@ static bool quota_mt_check(const struct xt_mtchk_param *par)
 
 	q->master = kmalloc(sizeof(*q->master), GFP_KERNEL);
 	if (q->master == NULL)
-		return -ENOMEM;
+		return false;
 
 	q->master->quota = q->quota;
 	return true;
-- 
# Created with git-export-patch
