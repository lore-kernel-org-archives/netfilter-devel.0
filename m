From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 5/9] libxtables: fix memory scribble beyond end of array
Date: Sun, 27 Feb 2011 02:31:15 +0100
Message-ID: <1298770280-7652-6-git-send-email-jengelh@medozas.de>
References: <1298770280-7652-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:52521 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751227Ab1B0Bbc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 26 Feb 2011 20:31:32 -0500
In-Reply-To: <1298770280-7652-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When using -s "", the "n" variable in the code remains uninitialized
and usually scribbes beyond the end of the array.

Furthermore, "n" is just as big as entries in the last host lookup.
When specifying more than one item to -s, e.g. "-s host,host", "n" is
less than "count", and we are not masking the addresses at all
(leaving them at addr/32 resp. addr/128).

The issue goes back to the initial code from v1.4.5~21.

References: http://bugs.debian.org/611990
Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 xtables.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/xtables.c b/xtables.c
index 57d5d13..f66fb27 100644
--- a/xtables.c
+++ b/xtables.c
@@ -1272,7 +1272,7 @@ void xtables_ipparse_multiple(const char *name, struct in_addr **addrpp,
 		free(addrp);
 	}
 	*naddrs = count;
-	for (i = 0; i < n; ++i)
+	for (i = 0; i < count; ++i)
 		(*addrpp+i)->s_addr &= (*maskpp+i)->s_addr;
 }
 
@@ -1587,7 +1587,7 @@ xtables_ip6parse_multiple(const char *name, struct in6_addr **addrpp,
 		free(addrp);
 	}
 	*naddrs = count;
-	for (i = 0; i < n; ++i)
+	for (i = 0; i < count; ++i)
 		for (j = 0; j < 4; ++j)
 			(*addrpp+i)->s6_addr32[j] &= (*maskpp+i)->s6_addr32[j];
 }
-- 
1.7.1

