From: Wes Campaigne <westacular@gmail.com>
Subject: [PATCH 3/4] xtables: fix the broken detection/removal of redundant addresses
Date: Mon, 21 Feb 2011 19:10:12 -0500
Message-ID: <1298333413-14253-4-git-send-email-westacular@gmail.com>
References: <1298333413-14253-1-git-send-email-westacular@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:65058 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881Ab1BVAKo (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Feb 2011 19:10:44 -0500
Received: by mail-iw0-f174.google.com with SMTP id 34so21597iwn.19
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Feb 2011 16:10:44 -0800 (PST)
In-Reply-To: <1298333413-14253-1-git-send-email-westacular@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This same block of code, apparently to detect if addresses are
identical after applying the mask, and to skip the duplicates and
the ones made redundant by the mask, has been present and unchanged
from as far back as I could find (circa iptables 1.2).

By inspection, it was wrong, and always has been: once the code
finds a duplicate, it will drop the rest of the array one by one as
it re-detects the same duplicate over and over. When the addresses
came from a single hostname lookup, and their order was random,
then this created unpredictable behaviour by iptables, which seem
to ignore some of those addresses at random times.

I suspect the original idea also involved a swap between the
duplicate and the address from the (current) end of the array, but
a line of code to do that seems to have never existed. I've finally
added it. (Well, as much as is needed: there doesn't need to be a
full swap, because we're just going to ignore the duplicate,
pretend the array is one shorter, and never look at the contents of
the end again. So, we can get away with just copying from the end.)

Signed-off-by: Wes Campaigne <westacular@gmail.com>
---
 xtables.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/xtables.c b/xtables.c
index 9a51e81..c96efa0 100644
--- a/xtables.c
+++ b/xtables.c
@@ -1306,13 +1306,14 @@ void xtables_ipparse_any(const char *name, struct in_addr **addrpp,
 		strcpy(buf, "0.0.0.0");
 
 	addrp = *addrpp = ipparse_hostnetwork(buf, naddrs);
+	/* Shuffle from end of array to remove redundant addresses */
 	n = *naddrs;
 	for (i = 0, j = 0; i < n; ++i) {
 		addrp[j++].s_addr &= maskp->s_addr;
 		for (k = 0; k < j - 1; ++k)
 			if (addrp[k].s_addr == addrp[j-1].s_addr) {
-				--*naddrs;
-				--j;
+				memcpy(&addrp[--j], &addrp[--*naddrs],
+				       sizeof(struct in_addr));
 				break;
 			}
 	}
@@ -1608,6 +1609,7 @@ void xtables_ip6parse_any(const char *name, struct in6_addr **addrpp,
 		strcpy(buf, "::");
 
 	addrp = *addrpp = ip6parse_hostnetwork(buf, naddrs);
+	/* Shuffle from end of array to remove redundant addresses */
 	n = *naddrs;
 	for (i = 0, j = 0; i < n; ++i) {
 		for (k = 0; k < 4; ++k)
@@ -1615,8 +1617,8 @@ void xtables_ip6parse_any(const char *name, struct in6_addr **addrpp,
 		++j;
 		for (k = 0; k < j - 1; ++k)
 			if (IN6_ARE_ADDR_EQUAL(&addrp[k], &addrp[j - 1])) {
-				--*naddrs;
-				--j;
+				memcpy(&addrp[--j], &addrp[--*naddrs],
+				       sizeof(struct in_addr));
 				break;
 			}
 	}
-- 
1.7.1

