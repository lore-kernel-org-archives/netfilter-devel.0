From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft PATCH] tests/shell: cleanup tempfile handling in
 testcases/sets/cache_handling_0
Date: Sat, 11 Jun 2016 12:25:59 +0200
Message-ID: <146564075890.10180.12129365273166621494.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:33494 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751559AbcFKK0F (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 11 Jun 2016 06:26:05 -0400
Received: from localhost (unknown [127.0.0.1])
	by smtp.cica.es (Postfix) with ESMTP id 26C8951F1F7
	for <netfilter-devel@vger.kernel.org>; Sat, 11 Jun 2016 10:26:02 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
	by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id N_oy5aNWs20y for <netfilter-devel@vger.kernel.org>;
	Sat, 11 Jun 2016 12:25:57 +0200 (CEST)
Received: from nfdev2.cica.es (nfdev2.cica.es [IPv6:2a00:9ac0:c1ca:31::221])
	(Authenticated sender: servers@cica.es)
	by smtp.cica.es (Postfix) with ESMTP id 40A1F51F1D3
	for <netfilter-devel@vger.kernel.org>; Sat, 11 Jun 2016 12:25:57 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It uses a bogus pattern which was cleaned up already in others testscases,
and this is a leftover.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 tests/shell/testcases/sets/cache_handling_0 |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/tests/shell/testcases/sets/cache_handling_0 b/tests/shell/testcases/sets/cache_handling_0
index c79e013..9a73769 100755
--- a/tests/shell/testcases/sets/cache_handling_0
+++ b/tests/shell/testcases/sets/cache_handling_0
@@ -1,12 +1,6 @@
 #!/bin/bash
 
-MKTEMP=$(which mktemp)
-if [ -x $MKTEMP ] ; then
-	tmpfile=$(${MKTEMP})
-else
-	tmpfile=$(/tmp/${RANDOM})
-fi
-
+tmpfile=$(mktemp)
 if [ ! -w $tmpfile ] ; then
 	echo "Failed to create tmp file" >&2
 	exit 0

