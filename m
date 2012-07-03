From: Kevin Locke <kevin@kevinlocke.name>
Subject: [PATCH] Include <net/ip6_checksum.h> for csum_ipv6_magic
Date: Tue, 3 Jul 2012 12:33:45 -0600
Message-ID: <20120703183345.GA14043@kevinzilla>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from praxis.kevinlocke.name ([205.185.125.39]:36911 "EHLO
	praxis.kevinlocke.name" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756229Ab2GCSkx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 Jul 2012 14:40:53 -0400
Received: from kevinzilla (host-184-166-128-97.bzm-mt.client.bresnan.net [184.166.128.97])
	(Authenticated sender: kevin@kevinlocke.name)
	by praxis.kevinlocke.name (Postfix) with ESMTPSA id 624CC160024E
	for <netfilter-devel@vger.kernel.org>; Tue,  3 Jul 2012 12:33:47 -0600 (MDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

xt_ECHO fails to build on PPC because csum_ipv6_magic is declared in
<net/ip6_checksum.h>, which is not implicitly included from other
headers on PPC causing build failures due to this function being
undefined.  So, include this header explicitly.

Note:  Same cause as <http://bugzilla.netfilter.org/show_bug.cgi?id=307>.

Signed-off-by: Kevin Locke <kevin@kevinlocke.name>
---
 extensions/xt_ECHO.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/extensions/xt_ECHO.c b/extensions/xt_ECHO.c
index efbceff..057d81a 100644
--- a/extensions/xt_ECHO.c
+++ b/extensions/xt_ECHO.c
@@ -18,6 +18,7 @@
 #	include <linux/netfilter_bridge.h>
 #endif
 #include <net/ip.h>
+#include <net/ip6_checksum.h>
 #include <net/ip6_route.h>
 #include <net/route.h>
 #include "compat_xtables.h"
-- 
1.7.10
