From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft PATCH] dist: include tests/ directory and files in tarball
Date: Thu, 28 Apr 2016 11:14:38 +0200
Message-ID: <146183487873.3430.10556920470037312368.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:32842 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753365AbcD1JOq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Apr 2016 05:14:46 -0400
Received: from localhost (unknown [127.0.0.1])
	by smtp.cica.es (Postfix) with ESMTP id BF79951F243
	for <netfilter-devel@vger.kernel.org>; Thu, 28 Apr 2016 09:14:44 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
	by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NIVLNDbM2s2I for <netfilter-devel@vger.kernel.org>;
	Thu, 28 Apr 2016 11:14:39 +0200 (CEST)
Received: from nfdev2.cica.es (nfdev2.cica.es [IPv6:2a00:9ac0:c1ca:31::221])
	by smtp.cica.es (Postfix) with ESMTP id AEAA451F0CE
	for <netfilter-devel@vger.kernel.org>; Thu, 28 Apr 2016 11:14:39 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If we include tests/ in the release tarball, downstream distributors
can run the testsuites themselves while developing the packages.

This way, tests can be run in a more integrated environment and they can
discover errors related to the integration with the given distribution itself.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 Makefile.am |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/Makefile.am b/Makefile.am
index 068009b..10aa40f 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -4,3 +4,5 @@ SUBDIRS = 	src	\
 		include	\
 		doc	\
 		files
+
+EXTRA_DIST =	tests

