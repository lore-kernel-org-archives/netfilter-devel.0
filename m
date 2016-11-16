From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft PATCH 2/3] tests: shell: testcase for deleting many set
 elements
Date: Wed, 16 Nov 2016 13:53:21 +0100
Message-ID: <147930080094.12388.10265108417605964462.stgit@nfdev2.cica.es>
References: <147930079529.12388.6423464302439175817.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:60523 "EHLO smtp.cica.es"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750998AbcKPMx2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 16 Nov 2016 07:53:28 -0500
Received: from localhost (unknown [127.0.0.1])
        by smtp.cica.es (Postfix) with ESMTP id EC8AB51F2E5
        for <netfilter-devel@vger.kernel.org>; Wed, 16 Nov 2016 12:53:26 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
        by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Gny_HAwpXLZ6 for <netfilter-devel@vger.kernel.org>;
        Wed, 16 Nov 2016 13:53:21 +0100 (CET)
Received: from nfdev2.cica.es (nfdev2.cica.es [IPv6:2a00:9ac0:c1ca:31::221])
        (Authenticated sender: servers@cica.es)
        by smtp.cica.es (Postfix) with ESMTP id 52E9E51F310
        for <netfilter-devel@vger.kernel.org>; Wed, 16 Nov 2016 13:53:21 +0100 (CET)
In-Reply-To: <147930079529.12388.6423464302439175817.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Arturo Borrero Gonzalez <arturo@debian.org>

This testcase adds and deletes many elements in a set.

We add and delete 65.536 elements in a same batch of netlink messages,
(single nft -f run).

Signed-off-by: Arturo Borrero Gonzalez <arturo@debian.org>
---
 .../testcases/sets/0012add_delete_many_elements_0  |   46 ++++++++++++++++++++
 1 file changed, 46 insertions(+)
 create mode 100755 tests/shell/testcases/sets/0012add_delete_many_elements_0

diff --git a/tests/shell/testcases/sets/0012add_delete_many_elements_0 b/tests/shell/testcases/sets/0012add_delete_many_elements_0
new file mode 100755
index 0000000..7a5f8c6
--- /dev/null
+++ b/tests/shell/testcases/sets/0012add_delete_many_elements_0
@@ -0,0 +1,46 @@
+#!/bin/bash
+
+# test adding and deleting many sets elements
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
+add element x y $(generate)
+delete element x y $(generate)" > $tmpfile
+
+set -e
+$NFT -f $tmpfile
+
+EXPECTED="table ip x {
+	set y {
+		type ipv4_addr
+	}
+}"
+GET=$($NFT list ruleset)
+if [ "$EXPECTED" != "$GET" ] ; then
+	DIFF="$(which diff)"
+	[ -x $DIFF ] && $DIFF -u <(echo "$EXPECTED") <(echo "$GET")
+	exit 1
+fi
+

