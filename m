From: Kevin Locke <kevin@kevinlocke.name>
Subject: [xtables-addons][PATCH 2/2] Build ip_set_setlist.ko module
Date: Sat, 19 Dec 2009 13:50:47 -0700
Message-ID: <1261255847-16395-3-git-send-email-kevin@kevinlocke.name>
References: <1261255847-16395-1-git-send-email-kevin@kevinlocke.name>
Cc: Kevin Locke <kevin@kevinlocke.name>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cluster2.bresnan.net ([69.145.248.57]:40558 "EHLO
	blnmtdc2svavs.cluster1.bresnan.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753523AbZLSVGX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 19 Dec 2009 16:06:23 -0500
In-Reply-To: <1261255847-16395-1-git-send-email-kevin@kevinlocke.name>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Not sure if this was overlooked, or if it is not in a suitable state for
general use, but lets give it a shot and see how it works.

Signed-off-by: Kevin Locke <kevin@kevinlocke.name>
---
 extensions/ipset/Kbuild |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/extensions/ipset/Kbuild b/extensions/ipset/Kbuild
index 80ff927..c881b3a 100644
--- a/extensions/ipset/Kbuild
+++ b/extensions/ipset/Kbuild
@@ -3,4 +3,4 @@
 obj-m += ipt_set.o ipt_SET.o
 obj-m += ip_set.o ip_set_ipmap.o ip_set_portmap.o ip_set_macipmap.o
 obj-m += ip_set_iphash.o ip_set_nethash.o ip_set_ipporthash.o
-obj-m += ip_set_iptree.o ip_set_iptreemap.o
+obj-m += ip_set_iptree.o ip_set_iptreemap.o ip_set_setlist.o
-- 
1.6.5

