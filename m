From: Kapil Juneja <Kapil.Juneja@freescale.com>
Subject: [PATCH] nf_conntrack_core: Updated nf_conntrack to destroy/refresh conn irrespective of del_timer status
Date: Mon, 25 Feb 2008 10:49:20 +0530
Message-ID: <1203916760-12951-1-git-send-email-Kapil.Juneja@freescale.com>
Cc: Kapil Juneja <Kapil.Juneja@freescale.com>,
	Emil Medve <Emilian.Medve@freescale.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from de01egw02.freescale.net ([192.88.165.103]:36415 "EHLO
	de01egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097AbYBYFUc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Feb 2008 00:20:32 -0500
Received: from de01smr02.am.mot.com (de01smr02.freescale.net [10.208.0.151])
	by de01egw02.freescale.net (8.12.11/de01egw02) with ESMTP id m1P5KQbq003044
	for <netfilter-devel@vger.kernel.org>; Sun, 24 Feb 2008 22:20:26 -0700 (MST)
Received: from zin33exm20.fsl.freescale.net (zin33exm20.ap.freescale.net [10.232.192.5])
	by de01smr02.am.mot.com (8.13.1/8.13.0) with ESMTP id m1P5KNJf006333
	for <netfilter-devel@vger.kernel.org>; Sun, 24 Feb 2008 23:20:24 -0600 (CST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Currently NF_CONNTRACK assumes that a running timer is present before refreshing
the connection or destroying it. This may not be the case when, for example,
another forwarding engine hooks up to it to listen to new connections
but disables the NF_CONNTRACK timer in order to have more control.
In such a scenario, only control packets may be terminated to NF_CONNTRACK for
it to decode and update the connection status. It will not impact the present
scenario of kernel forwarding without the aid of any forwarding engine. 

Signed-off-by: Kapil Juneja <Kapil.Juneja@freescale.com>
Signed-off-by: Emil Medve <Emilian.Medve@freescale.com>
---
 net/netfilter/nf_conntrack_core.c |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index a4d5cde..2d1f83c 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -791,10 +791,14 @@ void __nf_ct_refresh_acct(struct nf_conn *ct,
 		/* Only update the timeout if the new timeout is at least
 		   HZ jiffies from the old timeout. Need del_timer for race
 		   avoidance (may already be dying). */
-		if (newtime - ct->timeout.expires >= HZ
-		    && del_timer(&ct->timeout)) {
-			ct->timeout.expires = newtime;
-			add_timer(&ct->timeout);
+		if (newtime - ct->timeout.expires >= HZ) {
+			/*
+			 * The timer could have already been deleted
+			 * while still alive (for example connection
+			 * offloaded to a forwarding module other than
+			 * the kernel stack).
+			 */
+			mod_timer(&ct->timeout, newtime);
 			event = IPCT_REFRESH;
 		}
 	}
@@ -928,8 +932,8 @@ nf_ct_iterate_cleanup(int (*iter)(struct nf_conn *i, void *data), void *data)
 
 	while ((ct = get_next_corpse(iter, data, &bucket)) != NULL) {
 		/* Time to push up daises... */
-		if (del_timer(&ct->timeout))
-			death_by_timeout((unsigned long)ct);
+		del_timer(&ct->timeout);
+		death_by_timeout((unsigned long)ct);
 		/* ... else the timer will get him soon. */
 
 		nf_ct_put(ct);
-- 
1.5.3.3

