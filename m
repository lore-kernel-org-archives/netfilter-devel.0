From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH xt-addons] xt_geoip: fix possible out-of-bounds access
Date: Sat, 12 Jun 2010 10:59:51 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1006121037230.29158@obet.zrqbmnf.qr>
References: <1275382302-8857-1-git-send-email-fwestphal@astaro.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fwestphal@astaro.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:47312 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753261Ab0FLI7w (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 12 Jun 2010 04:59:52 -0400
In-Reply-To: <1275382302-8857-1-git-send-email-fwestphal@astaro.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2010-06-01 10:51, Florian Westphal wrote:

>It is possible for geoip_bsearch() to pick mid == sizeof(subnets).
>
>Consider a set with a single entry and a "address to test"
>higher than the range:
>
>1st call: lo = 0, hi = 1 -> mid will be 0
>2nd call: lo = 1, hi = 1 -> mid will be 1
>
>On the 2nd call, we'll examine random data.

Isn't this simpler?

diff --git a/extensions/xt_geoip.c b/extensions/xt_geoip.c
index 4c6b29f..44e489d 100644
--- a/extensions/xt_geoip.c
+++ b/extensions/xt_geoip.c
@@ -126,13 +126,13 @@ static bool geoip_bsearch(const struct geoip_subnet *range,
 {
 	int mid;
 
-	if (hi < lo)
+	if (hi <= lo)
 		return false;
 	mid = (lo + hi) / 2;
 	if (range[mid].begin <= addr && addr <= range[mid].end)
 		return true;
 	if (range[mid].begin > addr)
-		return geoip_bsearch(range, addr, lo, mid - 1);
+		return geoip_bsearch(range, addr, lo, mid);
 	else if (range[mid].end < addr)
 		return geoip_bsearch(range, addr, mid + 1, hi);
 


Seems to work on paper.

bsearch(lo=0, hi=1)
	inspects mid=0
	bsearch(lo=0, hi=0) stops
	bsearch(lo=1, hi=1) stops

bsearch(lo=0, hi=2)
	inspects mid=1
	bsearch(lo=0, hi=1) as above
	bsearch(lo=2, hi=2) stops

bsearch(lo=0, hi=3)
	inspects mid=1
	bsearch(lo=0, hi=1) as above
	bsearch(lo=2, hi=3)
		inspects mid=2
		bsearch(lo=2, hi=2) stops
		bsearch(lo=3, hi=3) stops

bsearch(lo=0, hi=4)
	inspects mid=2
	bsearch(lo=0, hi=2) as above
	bsearch(lo=3, hi=4)
		inspects mid=3
		bsearch(lo=3, hi=3) stops
		bsearch(lo=4, hi=4) stops
