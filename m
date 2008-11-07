From: Jan Engelhardt <jengelh@medozas.de>
Subject: libxt_conntrack: respect -n option during ruledump
Date: Fri, 7 Nov 2008 04:12:41 +0100 (CET)
Message-ID: <alpine.LNX.1.10.0811070411280.27330@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:49934 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698AbYKGDMn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 6 Nov 2008 22:12:43 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit a25e1ace7aac161fe8f61882b10dfb65551f8239
Author: Bernhard Miklautz <miklautz@inqnet.at>
Date:   Fri Oct 17 18:49:53 2008 +0200

libxt_conntrack: respect -n option during ruledump

Reference: http://bugs.debian.org/502548

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_conntrack.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/extensions/libxt_conntrack.c b/extensions/libxt_conntrack.c
index 79ed3b8..987e1af 100644
--- a/extensions/libxt_conntrack.c
+++ b/extensions/libxt_conntrack.c
@@ -758,14 +758,20 @@ conntrack_dump_addr(const union nf_inet_addr *addr,
 			printf("anywhere ");
 			return;
 		}
-		printf("%s ", ipaddr_to_anyname(&addr->in));
+		if (numeric)
+			printf("%s ", ipaddr_to_numeric(&addr->in));
+		else
+			printf("%s ", ipaddr_to_anyname(&addr->in));
 	} else if (family == AF_INET6) {
 		if (!numeric && addr->ip6[0] == 0 && addr->ip6[1] == 0 &&
 		    addr->ip6[2] == 0 && addr->ip6[3] == 0) {
 			printf("anywhere ");
 			return;
 		}
-		printf("%s ", ip6addr_to_anyname(&addr->in6));
+		if (numeric)
+			printf("%s ", ip6addr_to_numeric(&addr->in6));
+		else
+			printf("%s ", ip6addr_to_anyname(&addr->in6));
 	}
 }
 

