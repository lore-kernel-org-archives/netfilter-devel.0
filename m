From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 8/9] xtables: fix the broken detection/removal of redundant addresses
Date: Sun, 27 Feb 2011 02:31:18 +0100
Message-ID: <1298770280-7652-9-git-send-email-jengelh@medozas.de>
References: <1298770280-7652-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:52527 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751250Ab1B0Bbf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 26 Feb 2011 20:31:35 -0500
In-Reply-To: <1298770280-7652-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Wes Campaigne <westacular@gmail.com>

	[To observe this issue, populate a hostname (DNS or local db)
	with multiple adresses across multiple subnets (cf. prefixlen
	below)

	# e.g. /etc/hosts
	127.0.0.2       lo-x
	127.0.0.3       lo-x
	127.0.1.4       lo-x
	127.0.1.5       lo-x
	127.0.2.6       lo-x

	Then invoke xtables_ipparse_any by e.g. `-m conntrack
	--ctorigsrc lo-x/24`. -j.eng]

This same block of code, apparently to detect if addresses are
identical after applying the mask, and to skip the duplicates and the
ones made redundant by the mask, has been present and unchanged from
as far back as I could find (circa iptables 1.2).

By inspection, it was wrong, and always has been: once the code finds
a duplicate, it will drop the rest of the array one by one as it
re-detects the same duplicate over and over. When the addresses came
from a single hostname lookup, and their order was random, then this
created unpredictable behaviour by iptables, which seem to ignore some
of those addresses at random times.

I suspect the original idea also involved a swap between the duplicate
and the address from the (current) end of the array, but a line of
code to do that seems to have never existed. I have finally added it.
(Well, as much as is needed: there does not need to be a full swap,
because we are just going to ignore the duplicate, pretend the array
is one shorter, and never look at the contents of the end again. So,
we can get away with just copying from the end.)

[Reword comment about shuffle: replace by mentioning tail copy to
replace dup. -j.eng]

Signed-off-by: Wes Campaigne <westacular@gmail.com>
---
 xtables.c |   18 ++++++++++++++----
 1 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/xtables.c b/xtables.c
index b45bf92..660fbd0 100644
--- a/xtables.c
+++ b/xtables.c
@@ -1311,8 +1311,13 @@ void xtables_ipparse_any(const char *name, struct in_addr **addrpp,
 		addrp[j++].s_addr &= maskp->s_addr;
 		for (k = 0; k < j - 1; ++k)
 			if (addrp[k].s_addr == addrp[j-1].s_addr) {
-				--*naddrs;
-				--j;
+				/*
+				 * Nuke the dup by copying an address from the
+				 * tail here, and check the current position
+				 * again (--j).
+				 */
+				memcpy(&addrp[--j], &addrp[--*naddrs],
+				       sizeof(struct in_addr));
 				break;
 			}
 	}
@@ -1620,8 +1625,13 @@ void xtables_ip6parse_any(const char *name, struct in6_addr **addrpp,
 		++j;
 		for (k = 0; k < j - 1; ++k)
 			if (IN6_ARE_ADDR_EQUAL(&addrp[k], &addrp[j - 1])) {
-				--*naddrs;
-				--j;
+				/*
+				 * Nuke the dup by copying an address from the
+				 * tail here, and check the current position
+				 * again (--j).
+				 */
+				memcpy(&addrp[--j], &addrp[--*naddrs],
+				       sizeof(struct in_addr));
 				break;
 			}
 	}
-- 
1.7.1

