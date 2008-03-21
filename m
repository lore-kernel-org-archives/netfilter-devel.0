From: Chris Wright <chrisw@sous-sol.org>
Subject: [patch 66/76] NETFILTER: xt_time: fix failure to match on Sundays
Date: Fri, 21 Mar 2008 15:43:56 -0700
Message-ID: <20080321224447.336344887@sous-sol.org>
References: <20080321224250.144333319@sous-sol.org>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
	Zwane Mwaikambo <zwane@arm.linux.org.uk>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Dave Jones <davej@redhat.com>,
	Chuck Wolber <chuckw@quantumlinux.com>,
	Chris Wedgwood <reviews@ml.cw.f00f.org>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Chuck Ebbert <cebbert@redhat.com>,
	Domenico Andreoli <cavokz@gmail.com>,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	alan@lxorguk.ukuu.org.uk, Patrick McHardy <kaber@trash.net>,
	netfilter-devel@vger.kernel.org, davem@davemloft.net,
	Jan Engelhardt <jengelh@computergmbh.de>,
	Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:41336 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932199AbYCUWw1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 21 Mar 2008 18:52:27 -0400
Content-Disposition: inline; filename=netfilter-xt_time-fix-failure-to-match-on-sundays.patch
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Jan Engelhardt <jengelh@computergmbh.de>

Upstream commit 4f4c9430:

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
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---

 net/netfilter/xt_time.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/net/netfilter/xt_time.c
+++ b/net/netfilter/xt_time.c
@@ -95,8 +95,11 @@ static inline void localtime_2(struct xt
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

-- 
