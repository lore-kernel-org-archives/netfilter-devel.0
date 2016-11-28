From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft PATCH 1/2] tests: shell: add a testcase for many defines
Date: Mon, 28 Nov 2016 13:59:22 +0100
Message-ID: <148033796252.16068.18014556006915154561.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:36495 "EHLO smtp.cica.es"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753790AbcK1M7c (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 28 Nov 2016 07:59:32 -0500
Received: from localhost (unknown [127.0.0.1])
        by smtp.cica.es (Postfix) with ESMTP id BA7D951F357
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Nov 2016 12:59:28 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
        by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id b1kRewiAQPSw for <netfilter-devel@vger.kernel.org>;
        Mon, 28 Nov 2016 13:59:23 +0100 (CET)
Received: from nfdev2.cica.es (nfdev2.cica.es [IPv6:2a00:9ac0:c1ca:31::221])
        (Authenticated sender: servers@cica.es)
        by smtp.cica.es (Postfix) with ESMTP id E21A351F345
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Nov 2016 13:59:22 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Arturo Borrero Gonzalez <arturo@debian.org>

Use many defines in a single nft -f run.

Signed-off-by: Arturo Borrero Gonzalez <arturo@debian.org>
---
 tests/shell/testcases/nft-f/0011manydefines_0 |   37 +++++++++++++++++++++++++
 1 file changed, 37 insertions(+)
 create mode 100755 tests/shell/testcases/nft-f/0011manydefines_0

diff --git a/tests/shell/testcases/nft-f/0011manydefines_0 b/tests/shell/testcases/nft-f/0011manydefines_0
new file mode 100755
index 0000000..84664f4
--- /dev/null
+++ b/tests/shell/testcases/nft-f/0011manydefines_0
@@ -0,0 +1,37 @@
+#!/bin/bash
+
+# tests many defines in a single nft -f run
+
+HOWMANY=20000
+
+tmpfile=$(mktemp)
+if [ ! -w $tmpfile ] ; then
+	echo "Failed to create tmp file" >&2
+	exit 0
+fi
+
+trap "rm -rf $tmpfile" EXIT # cleanup if aborted
+
+generate1()
+{
+	for ((i=0; i<=HOWMANY; i++)) ; do
+		echo "define data_${i} = ${i}"
+	done
+}
+
+generate2()
+{
+	for ((i=0; i<=HOWMANY; i++)) ; do
+		echo "iifname \$data_${i}"
+	done
+}
+
+echo " $(generate1)
+table t {
+	chain c {
+		$(generate2)
+	}
+}" > $tmpfile
+
+set -e
+$NFT -f $tmpfile

