From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft PATCH 1/2] tests/shell/run-tests.sh: execute tests in sorted
 order
Date: Wed, 11 May 2016 14:39:33 +0200
Message-ID: <146297037318.18781.4519893770358950261.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:47122 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751769AbcEKMjm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 May 2016 08:39:42 -0400
Received: from localhost (unknown [127.0.0.1])
	by smtp.cica.es (Postfix) with ESMTP id 5A03951F20D
	for <netfilter-devel@vger.kernel.org>; Wed, 11 May 2016 12:39:39 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
	by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XvLbRuHsRome for <netfilter-devel@vger.kernel.org>;
	Wed, 11 May 2016 14:39:34 +0200 (CEST)
Received: from nfdev2.cica.es (nfdev2.cica.es [IPv6:2a00:9ac0:c1ca:31::221])
	(Authenticated sender: servers@cica.es)
	by smtp.cica.es (Postfix) with ESMTP id 7C5EB51F1FC
	for <netfilter-devel@vger.kernel.org>; Wed, 11 May 2016 14:39:34 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Let's sort tests files before iterating over them.

Put the find string in a separated function so it's more readable.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 tests/shell/run-tests.sh |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/tests/shell/run-tests.sh b/tests/shell/run-tests.sh
index 0bbb136..057f11e 100755
--- a/tests/shell/run-tests.sh
+++ b/tests/shell/run-tests.sh
@@ -61,10 +61,15 @@ kernel_cleanup() {
 	nf_tables_ipv4 nf_tables_ipv6 nf_tables
 }
 
+find_tests() {
+	${FIND} ${TESTDIR} -executable -regex \
+		.*${RETURNCODE_SEPARATOR}[0-9]+ | sort
+}
+
 echo ""
 ok=0
 failed=0
-for testfile in $(${FIND} ${TESTDIR} -executable -regex .*${RETURNCODE_SEPARATOR}[0-9]+)
+for testfile in $(find_tests)
 do
 	kernel_cleanup
 

