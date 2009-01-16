From: Jan Engelhardt <jengelh@medozas.de>
Subject: netfilter: src: remove unneeded goto
Date: Sat, 17 Jan 2009 00:52:46 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0901170051560.18810@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:55862 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761763AbZAPXws (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 16 Jan 2009 18:52:48 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>



Still valid for 2.6.29-rc2.

---8<---
parent 8825f047f639abd185399969c8e3b863b6af0a28 (v2.6.28-rc2-661-g8825f04)
commit ccdb1cf1a4417b7282c6b49723eef3ffe8758130
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Sun Nov 30 16:35:34 2008 +0100

netfilter: src: remove unneeded goto

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/netfilter/core.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index a90ac83..5bb3473 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -174,7 +174,6 @@ next_hook:
 			     outdev, &elem, okfn, hook_thresh);
 	if (verdict == NF_ACCEPT || verdict == NF_STOP) {
 		ret = 1;
-		goto unlock;
 	} else if (verdict == NF_DROP) {
 		kfree_skb(skb);
 		ret = -EPERM;
@@ -183,7 +182,6 @@ next_hook:
 			      verdict >> NF_VERDICT_BITS))
 			goto next_hook;
 	}
-unlock:
 	rcu_read_unlock();
 	return ret;
 }
-- 
# Created with git-export-patch

