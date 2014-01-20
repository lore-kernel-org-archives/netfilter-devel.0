From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [libnftnl PATCH] build: Ensure pkg-config file provides the right informations
Date: Mon, 20 Jan 2014 17:56:21 +0200
Message-ID: <1390233381-2284-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:55397 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751627AbaATP4e (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 20 Jan 2014 10:56:34 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It's not -lnftables anymore but -lnftnl (among other details)

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 libnftnl.pc.in | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/libnftnl.pc.in b/libnftnl.pc.in
index 0c6d57e..fd5cc6a 100644
--- a/libnftnl.pc.in
+++ b/libnftnl.pc.in
@@ -1,15 +1,15 @@
-# libnftables pkg-config file
+# libnftnl pkg-config file
 
 prefix=@prefix@
 exec_prefix=@exec_prefix@
 libdir=@libdir@
 includedir=@includedir@
 
-Name: libnftables
+Name: libnftnl
 Description: Netfilter nf_tables infrastructure library
-URL: http://netfilter.org/projects/libnftables/
+URL: http://netfilter.org/projects/libnftnl/
 Version: @VERSION@
 Requires:
 Conflicts:
-Libs: -L${libdir} -lnftables
+Libs: -L${libdir} -lnftnl
 Cflags: -I${includedir}
-- 
1.8.3.2

