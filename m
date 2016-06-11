From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft PATCH] tests/shell: delete unused variable in run-tests.sh
Date: Sat, 11 Jun 2016 12:19:17 +0200
Message-ID: <146564035699.7164.17539179584212489576.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:39864 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751137AbcFKKTX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 11 Jun 2016 06:19:23 -0400
Received: from localhost (unknown [127.0.0.1])
	by smtp.cica.es (Postfix) with ESMTP id 5578E51F1D3
	for <netfilter-devel@vger.kernel.org>; Sat, 11 Jun 2016 10:19:20 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
	by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id S0JF_VFZRUec for <netfilter-devel@vger.kernel.org>;
	Sat, 11 Jun 2016 12:19:15 +0200 (CEST)
Received: from nfdev2.cica.es (nfdev2.cica.es [IPv6:2a00:9ac0:c1ca:31::221])
	(Authenticated sender: servers@cica.es)
	by smtp.cica.es (Postfix) with ESMTP id 7247251F188
	for <netfilter-devel@vger.kernel.org>; Sat, 11 Jun 2016 12:19:15 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This ${TESTS_OUTPUT} variable is empty. Delete it.

It was probably an idea about dinamically redirecting testscases output.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 tests/shell/run-tests.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/shell/run-tests.sh b/tests/shell/run-tests.sh
index 921080f..b10445d 100755
--- a/tests/shell/run-tests.sh
+++ b/tests/shell/run-tests.sh
@@ -76,7 +76,7 @@ do
 	rc_spec=$(awk -F${RETURNCODE_SEPARATOR} '{print $NF}' <<< $testfile)
 
 	msg_info "[EXECUTING]	$testfile"
-	test_output=$(NFT=$NFT ${testfile} ${TESTS_OUTPUT} 2>&1)
+	test_output=$(NFT=$NFT ${testfile} 2>&1)
 	rc_got=$?
 	echo -en "\033[1A\033[K" # clean the [EXECUTING] foobar line
 

