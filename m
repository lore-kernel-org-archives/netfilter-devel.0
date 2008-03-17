From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER -stable 01/03]: xt_time: fix failure to match on Sundays
Date: Mon, 17 Mar 2008 15:41:44 +0100 (MET)
Message-ID: <20080317143312.20525.93415.sendpatchset@localhost.localdomain>
References: <20080317143311.20525.87504.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org,
	davem@davemloft.net
To: stable@kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:53630 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753860AbYCQOlq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Mar 2008 10:41:46 -0400
In-Reply-To: <20080317143311.20525.87504.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: xt_time: fix failure to match on Sundays

Upstream commit 4f4c9430:

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
commit 2cfc500a853497da88ca6b097873bcb0de65e764
tree 65082cc5f1544db80e472f779e7a57c92663c09c
parent 927684b414dae48568ab82939ea2f55a10188e94
author Jan Engelhardt <jengelh@computergmbh.de> Mon, 17 Mar 2008 15:30:12 +0100
committer Patrick McHardy <kaber@trash.net> Mon, 17 Mar 2008 15:30:12 +0100

 net/netfilter/xt_time.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/xt_time.c b/net/netfilter/xt_time.c
index f9c55dc..5222a97 100644
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
