From: Changli Gao <xiaosuo@gmail.com>
Subject: [PATCH] xtables-addon: Remove recursive function calls
Date: Mon,  7 Mar 2011 16:14:29 +0800
Message-ID: <1299485669-31288-1-git-send-email-xiaosuo@gmail.com>
Cc: netfilter-devel@vger.kernel.org, Changli Gao <xiaosuo@gmail.com>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:52444 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972Ab1CGIQP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Mar 2011 03:16:15 -0500
Received: by iwn34 with SMTP id 34so3718392iwn.19
        for <netfilter-devel@vger.kernel.org>; Mon, 07 Mar 2011 00:16:14 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The stack memory is very limited in Linux kernel.

Signed-off-by: Changli Gao <xiaosuo@gmail.com>
---
 extensions/xt_geoip.c |   46 +++++++++++++++++++++++++++-------------------
 1 file changed, 27 insertions(+), 19 deletions(-)
diff --git a/extensions/xt_geoip.c b/extensions/xt_geoip.c
index d644605..98f03e4 100644
--- a/extensions/xt_geoip.c
+++ b/extensions/xt_geoip.c
@@ -167,16 +167,20 @@ static bool geoip_bsearch6(const struct geoip_subnet6 *range,
 {
 	int mid;
 
-	if (hi <= lo)
-		return false;
-	mid = (lo + hi) / 2;
-	if (ipv6_cmp(&range[mid].begin, addr) <= 0 &&
-	    ipv6_cmp(addr, &range[mid].end) <= 0)
-		return true;
-	if (ipv6_cmp(&range[mid].begin, addr) > 0)
-		return geoip_bsearch6(range, addr, lo, mid);
-	else if (ipv6_cmp(&range[mid].end, addr) < 0)
-		return geoip_bsearch6(range, addr, mid + 1, hi);
+	while (1) {
+		if (hi <= lo)
+			return false;
+		mid = (lo + hi) / 2;
+		if (ipv6_cmp(&range[mid].begin, addr) <= 0 &&
+		    ipv6_cmp(addr, &range[mid].end) <= 0)
+			return true;
+		if (ipv6_cmp(&range[mid].begin, addr) > 0)
+			hi = mid;
+		else if (ipv6_cmp(&range[mid].end, addr) < 0)
+			lo = mid + 1;
+		else
+			break;
+	}
 
 	WARN_ON(true);
 	return false;
@@ -218,15 +222,19 @@ static bool geoip_bsearch4(const struct geoip_subnet4 *range,
 {
 	int mid;
 
-	if (hi <= lo)
-		return false;
-	mid = (lo + hi) / 2;
-	if (range[mid].begin <= addr && addr <= range[mid].end)
-		return true;
-	if (range[mid].begin > addr)
-		return geoip_bsearch4(range, addr, lo, mid);
-	else if (range[mid].end < addr)
-		return geoip_bsearch4(range, addr, mid + 1, hi);
+	while (1) {
+		if (hi <= lo)
+			return false;
+		mid = (lo + hi) / 2;
+		if (range[mid].begin <= addr && addr <= range[mid].end)
+			return true;
+		if (range[mid].begin > addr)
+			hi = mid;
+		else if (range[mid].end < addr)
+			lo = mid + 1;
+		else
+			break;
+	}
 
 	WARN_ON(true);
 	return false;
