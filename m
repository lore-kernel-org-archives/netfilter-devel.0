From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 04/09]: xt_time: fix failure to match on Sundays
Date: Mon, 10 Mar 2008 19:26:18 +0100 (MET)
Message-ID: <20080310182620.20404.70884.sendpatchset@localhost.localdomain>
References: <20080310182615.20404.67685.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:34263 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242AbYCJS0T (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Mar 2008 14:26:19 -0400
In-Reply-To: <20080310182615.20404.67685.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: xt_time: fix failure to match on Sundays

From: Andrew Schulman <andrex@alumni.utexas.net>

xt_time_match() in net/netfilter/xt_time.c in kernel 2.6.24 never
matches on Sundays. On my host I have a rule like

    iptables -A OUTPUT -m time --weekdays Sun -j REJECT

and it never matches. The problem is in localtime_2(), which uses

    r->weekday = (4 + r->dse) % 7;

to map the epoch day onto a weekday in {0,...,6}. In particular this
gives 0 for Sundays. But 0 has to be wrong; a weekday of 0 can never
match. xt_time_match() has

    if (!(info->weekdays_match & (1 << current_time.weekday)))
        return false;

and when current_time.weekday = 0, the result of the & is always
zero, even when info->weekdays_match = XT_TIME_ALL_WEEKDAYS = 0xFE.

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 342661f5a04f90772e0d33302634e010ab3649ed
tree 3dc6d36f9d245b9f2990ab503735904c1d8187d1
parent b306ccc2129dfc062653b3436df714fc758f3c45
author Andrew Schulman <andrex@alumni.utexas.net> Mon, 10 Mar 2008 17:50:42 +0100
committer Patrick McHardy <kaber@trash.net> Mon, 10 Mar 2008 17:50:42 +0100

 net/netfilter/xt_time.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/xt_time.c b/net/netfilter/xt_time.c
index e9a8794..9fa2e08 100644
--- a/net/netfilter/xt_time.c
+++ b/net/netfilter/xt_time.c
@@ -95,8 +95,11 @@ static inline void localtime_2(struct xtm *r, time_t time)
 	 */
 	r->dse = time / 86400;
 
-	/* 1970-01-01 (w=0) was a Thursday (4). */
-	r->weekday = (4 + r->dse) % 7;
+	/*
+	 * 1970-01-01 (w=0) was a Thursday (4).
+	 * -1 and +1 map Sunday properly onto 7.
+	 */
+	r->weekday = (4 + r->dse - 1) % 7 + 1;
 }
 
 static void localtime_3(struct xtm *r, time_t time)
