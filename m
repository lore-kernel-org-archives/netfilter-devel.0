From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 03/03: xt_hashlimit: fix race between htable_destroy and htable_gc
Date: Thu, 31 Jul 2008 08:33:16 +0200 (MEST)
Message-ID: <20080731063316.18150.32852.sendpatchset@localhost.localdomain>
References: <20080731063312.18150.49494.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:34606 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522AbYGaGdR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 31 Jul 2008 02:33:17 -0400
In-Reply-To: <20080731063312.18150.49494.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

netfilter: xt_hashlimit: fix race between htable_destroy and htable_gc

Deleting a timer with del_timer doesn't guarantee, that the
timer function is not running at the moment of deletion. Thus
in the xt_hashlimit case we can get into a ticklish situation
when the htable_gc rearms the timer back and we'll actually
delete an entry with a pending timer.

Fix it with using del_timer_sync().

AFAIK del_timer_sync checks for the timer to be pending by
itself, so I remove the check.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit d97740075c062dc888ecb4d710e6aafd2a253383
tree d20ba6ebf2b48f7c45014c9d4f6bf8eb208f18d5
parent 728845f8c11ec11be4a3725a70389a3013cd4e48
author Pavel Emelyanov <xemul@openvz.org> Wed, 30 Jul 2008 12:53:30 +0200
committer Patrick McHardy <kaber@trash.net> Wed, 30 Jul 2008 12:53:30 +0200

 net/netfilter/xt_hashlimit.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
index 6809af5..d9418a2 100644
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -367,9 +367,7 @@ static void htable_gc(unsigned long htlong)
 
 static void htable_destroy(struct xt_hashlimit_htable *hinfo)
 {
-	/* remove timer, if it is pending */
-	if (timer_pending(&hinfo->timer))
-		del_timer(&hinfo->timer);
+	del_timer_sync(&hinfo->timer);
 
 	/* remove proc entry */
 	remove_proc_entry(hinfo->pde->name,
