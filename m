From: Eric Leblond <eric@regit.org>
Subject: [Ulogd2 PATCH 4/4] Prepare release number to 2.0.2
Date: Fri, 22 Feb 2013 11:25:58 +0100
Message-ID: <1361528758-16674-5-git-send-email-eric@regit.org>
References: <1361528758-16674-1-git-send-email-eric@regit.org>
Cc: eric@regit.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:39923 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754101Ab3BVK0e (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 22 Feb 2013 05:26:34 -0500
In-Reply-To: <1361528758-16674-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Update release number and fill Changes file.

Signed-off-by: Eric Leblond <eric@regit.org>
---
 Changes      |    9 +++++++++
 configure.ac |    2 +-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/Changes b/Changes
index e59322c..3552b11 100644
--- a/Changes
+++ b/Changes
@@ -1,3 +1,12 @@
+Version 2.0.2 (2013-02-21)
+ - Add Graphite output module
+ - Update postgresql schema
+ - Add nfct filtering capabilities
+ - Add -v option to display message on sdtout
+ - Add -l option to specify verbosity on command line
+ - Build system improvements
+ - Fix parsing of ipv6 flowlabel and tc fields
+
 Version 2.00alpha (2004-Oct-03)
 - Total re-work.  ulogd2 is almost unrelated to the ULOG netfilter target.
   Instead, it has become a generic logging framework for anything from
diff --git a/configure.ac b/configure.ac
index df0e9d3..c94704b 100644
--- a/configure.ac
+++ b/configure.ac
@@ -1,5 +1,5 @@
 dnl Process this file with autoconf to produce a configure script.
-AC_INIT([ulogd], [2.0.1])
+AC_INIT([ulogd], [2.0.2])
 AC_PREREQ([2.50])
 AC_CONFIG_AUX_DIR([build-aux])
 AM_INIT_AUTOMAKE([-Wall foreign tar-pax no-dist-gzip dist-bzip2 1.10b])
-- 
1.7.10.4

