From: Patrick McHardy <kaber@trash.net>
Subject: [LIBNL 09/09]: Install netfilter headers
Date: Fri, 18 Jan 2008 17:56:00 +0100 (MET)
Message-ID: <20080118165527.13385.72029.sendpatchset@localhost.localdomain>
References: <20080118165514.13385.44695.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org,
	philipc@snapgear.com
To: tgraf@suug.ch
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:42995 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762659AbYARQ4B (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 18 Jan 2008 11:56:01 -0500
In-Reply-To: <20080118165514.13385.44695.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 8c4229982c96650d5369fa33c40749de0ac29bb2
Author: Patrick McHardy <kaber@trash.net>
Date:   Fri Jan 18 17:53:14 2008 +0100

    [LIBNL]: Install netfilter headers
    
    libnl currently forgets to install the netfilter headers.
    Fix that.
    
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/include/Makefile b/include/Makefile
index a2b23e0..968ebe5 100644
--- a/include/Makefile
+++ b/include/Makefile
@@ -29,10 +29,12 @@ install:
 	mkdir -p $(DESTDIR)$(includedir)/netlink/route/cls/
 	mkdir -p $(DESTDIR)$(includedir)/netlink/genl/
 	mkdir -p $(DESTDIR)$(includedir)/netlink/fib_lookup/
+	mkdir -p $(DESTDIR)$(includedir)/netlink/netfilter
 	install -m 0644 netlink/*.h $(DESTDIR)$(includedir)/netlink/
 	install -m 0644 netlink/route/*.h $(DESTDIR)$(includedir)/netlink/route/
 	install -m 0644 netlink/route/sch/*.h $(DESTDIR)$(includedir)/netlink/route/sch/
 	install -m 0644 netlink/route/cls/*.h $(DESTDIR)$(includedir)/netlink/route/cls/
 	install -m 0644 netlink/genl/*.h $(DESTDIR)$(includedir)/netlink/genl/
 	install -m 0644 netlink/fib_lookup/*.h $(DESTDIR)$(includedir)/netlink/fib_lookup/
+	install -m 0644 netlink/netfilter/*.h $(DESTDIR)$(includedir)/netlink/netfilter/
 
