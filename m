From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft PATCH 1/3] tests: shell: testcase for adding many set elements
Date: Wed, 16 Nov 2016 13:53:15 +0100
Message-ID: <147930079529.12388.6423464302439175817.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:60517 "EHLO smtp.cica.es"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750998AbcKPMxY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 16 Nov 2016 07:53:24 -0500
Received: from localhost (unknown [127.0.0.1])
        by smtp.cica.es (Postfix) with ESMTP id 6C7E351F328
        for <netfilter-devel@vger.kernel.org>; Wed, 16 Nov 2016 12:53:22 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
        by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id pagnNMS_ifKj for <netfilter-devel@vger.kernel.org>;
        Wed, 16 Nov 2016 13:53:16 +0100 (CET)
Received: from nfdev2.cica.es (nfdev2.cica.es [IPv6:2a00:9ac0:c1ca:31::221])
        (Authenticated sender: servers@cica.es)
        by smtp.cica.es (Postfix) with ESMTP id 2445E51F2AA
        for <netfilter-devel@vger.kernel.org>; Wed, 16 Nov 2016 13:53:16 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Arturo Borrero Gonzalez <arturo@debian.org>

This testcase adds many elements in a set.
We add 65.356 elements.

Signed-off-by: Arturo Borrero Gonzalez <arturo@debian.org>
---
 tests/shell/testcases/sets/0011add_many_elements_0 |   32 ++++++++++++++++++++
 1 file changed, 32 insertions(+)
 create mode 100755 tests/shell/testcases/sets/0011add_many_elements_0

diff --git a/tests/shell/testcases/sets/0011add_many_elements_0 b/tests/shell/testcases/sets/0011add_many_elements_0
new file mode 100755
index 0000000..ba23f90
--- /dev/null
+++ b/tests/shell/testcases/sets/0011add_many_elements_0
@@ -0,0 +1,32 @@
+#!/bin/bash
+
+# test adding many sets elements
+
+HOWMANY=255
+
+tmpfile=$(mktemp)
+if [ ! -w $tmpfile ] ; then
+	echo "Failed to create tmp file" >&2
+	exit 0
+fi
+
+trap "rm -rf $tmpfile" EXIT # cleanup if aborted
+
+generate() {
+	echo -n "{"
+	for ((i=1; i<=HOWMANY; i++)) ; do
+		for ((j=1; j<=HOWMANY; j++)) ; do
+			echo -n "10.0.${i}.${j}"
+			[ "$i" == "$HOWMANY" ] && [ "$j" == "$HOWMANY" ] && break
+			echo -n ", "
+		done
+	done
+	echo -n "}"
+}
+
+echo "add table x
+add set x y { type ipv4_addr; }
+add element x y $(generate)" > $tmpfile
+
+set -e
+$NFT -f $tmpfile

