From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft PATCH] tests: shell: allow to execute a single testcase
Date: Wed, 16 Nov 2016 13:51:52 +0100
Message-ID: <147930071248.11586.102674356702325099.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:39451 "EHLO smtp.cica.es"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752704AbcKPMwB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 16 Nov 2016 07:52:01 -0500
Received: from localhost (unknown [127.0.0.1])
        by smtp.cica.es (Postfix) with ESMTP id 1908E51F2F7
        for <netfilter-devel@vger.kernel.org>; Wed, 16 Nov 2016 12:51:58 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
        by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id pIgQt5u22285 for <netfilter-devel@vger.kernel.org>;
        Wed, 16 Nov 2016 13:51:53 +0100 (CET)
Received: from nfdev2.cica.es (nfdev2.cica.es [IPv6:2a00:9ac0:c1ca:31::221])
        (Authenticated sender: servers@cica.es)
        by smtp.cica.es (Postfix) with ESMTP id 16FEA51F2AA
        for <netfilter-devel@vger.kernel.org>; Wed, 16 Nov 2016 13:51:52 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Arturo Borrero Gonzalez <arturo@debian.org>

Using, for example:
 % sudo ./run-tests.sh testcase/mytest_0

Will result in an execution of this single testcase rather than
the complete suite.

This is useful while working with a concrete testcase.

Signed-off-by: Arturo Borrero Gonzalez <arturo@debian.org>
---
 tests/shell/run-tests.sh |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/tests/shell/run-tests.sh b/tests/shell/run-tests.sh
index d9c44c8..4e41893 100755
--- a/tests/shell/run-tests.sh
+++ b/tests/shell/run-tests.sh
@@ -43,6 +43,13 @@ if [ ! -x "$MODPROBE" ] ; then
 	msg_error "no modprobe binary found"
 fi
 
+if [ -x "$1" ] ; then
+	if grep ^.*${RETURNCODE_SEPARATOR}[0-9]\\+$ <<< $1 >/dev/null ; then
+		SINGLE=$1
+		VERBOSE=y
+	fi
+fi
+
 if [ "$1" == "-v" ] ; then
 	VERBOSE=y
 fi
@@ -65,6 +72,10 @@ kernel_cleanup() {
 }
 
 find_tests() {
+	if [ ! -z "$SINGLE" ] ; then
+		echo $SINGLE
+		return
+	fi
 	${FIND} ${TESTDIR} -executable -regex \
 		.*${RETURNCODE_SEPARATOR}[0-9]+ | sort
 }

