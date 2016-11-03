From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft PATCH 3/3] tests: shell: add a new testcase for ruleset
 loading bug
Date: Thu, 03 Nov 2016 13:04:47 +0100
Message-ID: <147817468786.6881.1016366778593835308.stgit@nfdev2.cica.es>
References: <147817467643.6881.13545899574878544844.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:35062 "EHLO smtp.cica.es"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751136AbcKCMEn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 3 Nov 2016 08:04:43 -0400
Received: from localhost (unknown [127.0.0.1])
        by smtp.cica.es (Postfix) with ESMTP id 8F91F51F310
        for <netfilter-devel@vger.kernel.org>; Thu,  3 Nov 2016 12:04:41 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
        by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 7hLH58oe7KeF for <netfilter-devel@vger.kernel.org>;
        Thu,  3 Nov 2016 13:04:36 +0100 (CET)
Received: from nfdev2.cica.es (nfdev2.cica.es [IPv6:2a00:9ac0:c1ca:31::221])
        (Authenticated sender: servers@cica.es)
        by smtp.cica.es (Postfix) with ESMTP id A27A351F2A7
        for <netfilter-devel@vger.kernel.org>; Thu,  3 Nov 2016 13:04:36 +0100 (CET)
In-Reply-To: <147817467643.6881.13545899574878544844.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Arturo Borrero Gonzalez <arturo@debian.org>

There seems to be a bug that prevent loading a ruleset twice in a row
if the ruleset contains sets with intervals. This seems related to the
nft cache.

By the time of this commit, the bug is not fixed yet.

Signed-off-by: Arturo Borrero Gonzalez <arturo@debian.org>
---
 tests/shell/testcases/cache/0002_interval_0 |   27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)
 create mode 100755 tests/shell/testcases/cache/0002_interval_0

diff --git a/tests/shell/testcases/cache/0002_interval_0 b/tests/shell/testcases/cache/0002_interval_0
new file mode 100755
index 0000000..f500911
--- /dev/null
+++ b/tests/shell/testcases/cache/0002_interval_0
@@ -0,0 +1,27 @@
+#!/bin/bash
+
+# This testcase checks that we can load a ruleset twice in a row.
+# bug --> Error: interval overlaps with an existing one
+
+set -e
+
+tmpfile=$(mktemp)
+if [ ! -w $tmpfile ] ; then
+        echo "Failed to create tmp file" >&2
+        exit 0
+fi
+
+trap "rm -rf $tmpfile" EXIT # cleanup if aborted
+
+RULESET="flush ruleset
+table inet t {
+	set s { type ipv4_addr; flags interval; }
+}
+
+add element inet t s {
+	192.168.0.1/24,
+}"
+
+echo "$RULESET" > $tmpfile
+$NFT -f $tmpfile
+$NFT -f $tmpfile

