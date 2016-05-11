From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft PATCH 2/2] tests/shell/run-tests.sh: print hint about testcase
 being executed
Date: Wed, 11 May 2016 14:39:38 +0200
Message-ID: <146297037849.18781.5589442408869588727.stgit@nfdev2.cica.es>
References: <146297037318.18781.4519893770358950261.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:47128 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751769AbcEKMjv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 May 2016 08:39:51 -0400
Received: from localhost (unknown [127.0.0.1])
	by smtp.cica.es (Postfix) with ESMTP id 5283D51F20D
	for <netfilter-devel@vger.kernel.org>; Wed, 11 May 2016 12:39:49 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
	by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id d7vHVpOL4bsr for <netfilter-devel@vger.kernel.org>;
	Wed, 11 May 2016 14:39:39 +0200 (CEST)
Received: from nfdev2.cica.es (nfdev2.cica.es [IPv6:2a00:9ac0:c1ca:31::221])
	(Authenticated sender: servers@cica.es)
	by smtp.cica.es (Postfix) with ESMTP id AAA7051F1FC
	for <netfilter-devel@vger.kernel.org>; Wed, 11 May 2016 14:39:39 +0200 (CEST)
In-Reply-To: <146297037318.18781.4519893770358950261.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Print a line with the name of the testcase being executed, and then delete it
with the result.

There are tests which may take a long time and its good to know what is doing
the testsuite.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 tests/shell/run-tests.sh |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tests/shell/run-tests.sh b/tests/shell/run-tests.sh
index 057f11e..921080f 100755
--- a/tests/shell/run-tests.sh
+++ b/tests/shell/run-tests.sh
@@ -74,8 +74,12 @@ do
 	kernel_cleanup
 
 	rc_spec=$(awk -F${RETURNCODE_SEPARATOR} '{print $NF}' <<< $testfile)
+
+	msg_info "[EXECUTING]	$testfile"
 	test_output=$(NFT=$NFT ${testfile} ${TESTS_OUTPUT} 2>&1)
 	rc_got=$?
+	echo -en "\033[1A\033[K" # clean the [EXECUTING] foobar line
+
 	if [ "$rc_got" == "$rc_spec" ] ; then
 		msg_info "[OK]		$testfile"
 		[ "$VERBOSE" == "y" ] && [ ! -z "$test_output" ] && echo "$test_output"

