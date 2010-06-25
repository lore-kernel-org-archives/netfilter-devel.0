From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 2/2] libxt_conntrack: do print netmask
Date: Fri, 25 Jun 2010 14:45:41 +0200
Message-ID: <1277469942-26270-3-git-send-email-jengelh@medozas.de>
References: <1277469942-26270-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:58083 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752095Ab0FYMpr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 25 Jun 2010 08:45:47 -0400
In-Reply-To: <1277469942-26270-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

References: http://bugzilla.netfilter.org/show_bug.cgi?id=659
Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_conntrack.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/extensions/libxt_conntrack.c b/extensions/libxt_conntrack.c
index e8225e6..5557d3e 100644
--- a/extensions/libxt_conntrack.c
+++ b/extensions/libxt_conntrack.c
@@ -842,9 +842,13 @@ conntrack_dump_addr(const union nf_inet_addr *addr,
 			return;
 		}
 		if (numeric)
-			printf("%s ", xtables_ipaddr_to_numeric(&addr->in));
+			printf("%s%s ",
+			       xtables_ipaddr_to_numeric(&addr->in),
+			       xtables_ipmask_to_numeric(&mask->in));
 		else
-			printf("%s ", xtables_ipaddr_to_anyname(&addr->in));
+			printf("%s%s ",
+			       xtables_ipaddr_to_anyname(&addr->in),
+			       xtables_ipmask_to_numeric(&mask->in));
 	} else if (family == NFPROTO_IPV6) {
 		if (!numeric && addr->ip6[0] == 0 && addr->ip6[1] == 0 &&
 		    addr->ip6[2] == 0 && addr->ip6[3] == 0) {
@@ -852,9 +856,13 @@ conntrack_dump_addr(const union nf_inet_addr *addr,
 			return;
 		}
 		if (numeric)
-			printf("%s ", xtables_ip6addr_to_numeric(&addr->in6));
+			printf("%s%s ",
+			       xtables_ip6addr_to_numeric(&addr->in6),
+			       xtables_ip6mask_to_numeric(&mask->in6));
 		else
-			printf("%s ", xtables_ip6addr_to_anyname(&addr->in6));
+			printf("%s%s ",
+			       xtables_ip6addr_to_anyname(&addr->in6),
+			       xtables_ip6mask_to_numeric(&mask->in6));
 	}
 }
 
-- 
1.7.1

