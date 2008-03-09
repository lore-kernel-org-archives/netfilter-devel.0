From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [NETFILTER]: xt_time: fix failure to match on Sundays
Date: Sun, 9 Mar 2008 15:38:45 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0803061516300.7660@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:43606 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428AbYCIOiq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 9 Mar 2008 10:38:46 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Should go in for 2.6.25, and 2.6.24-stable.

===
commit 4a0883a28ade0ce4837aa6f3f692f8180ad3a264
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Thu Mar 6 15:10:54 2008 +0100

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
---
 net/netfilter/xt_time.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/xt_time.c b/net/netfilter/xt_time.c
index 065d567..1d08183 100644
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

