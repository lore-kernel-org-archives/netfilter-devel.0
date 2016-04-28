From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [conntrack-tools PATCH] dist: include tests/ directory and files in
 tarball
Date: Thu, 28 Apr 2016 11:14:30 +0200
Message-ID: <146183487005.3278.11126686560647444846.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:32837 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752831AbcD1JOj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Apr 2016 05:14:39 -0400
Received: from localhost (unknown [127.0.0.1])
	by smtp.cica.es (Postfix) with ESMTP id A1BC551F244
	for <netfilter-devel@vger.kernel.org>; Thu, 28 Apr 2016 09:14:36 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
	by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1001n6qplAT8 for <netfilter-devel@vger.kernel.org>;
	Thu, 28 Apr 2016 11:14:31 +0200 (CEST)
Received: from nfdev2.cica.es (nfdev2.cica.es [IPv6:2a00:9ac0:c1ca:31::221])
	by smtp.cica.es (Postfix) with ESMTP id 2AFA351F0CE
	for <netfilter-devel@vger.kernel.org>; Thu, 28 Apr 2016 11:14:31 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If we include tests/ in the release tarball, downstream distributors
can run the testsuites themselves while developing the packages.

This way, tests can be run in a more integrated environment and they can
discover errors related to the integration with the given distribution itself.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 Makefile.am |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile.am b/Makefile.am
index b453af0..f64d604 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -3,7 +3,7 @@ include Make_global.am
 ACLOCAL_AMFLAGS  = -I m4
 
 man_MANS = conntrack.8 conntrackd.8 nfct.8 conntrackd.conf.5
-EXTRA_DIST = $(man_MANS) Make_global.am doc m4
+EXTRA_DIST = $(man_MANS) Make_global.am doc m4 tests
 
 SUBDIRS   = extensions src
 DIST_SUBDIRS = include src extensions

