Return-Path: <SRS0=+t1+=4B=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE0DEC2BA83
	for <netfilter-devel@archiver.kernel.org>; Thu, 13 Feb 2020 12:06:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BAFDA2168B
	for <netfilter-devel@archiver.kernel.org>; Thu, 13 Feb 2020 12:06:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729531AbgBMMGC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 13 Feb 2020 07:06:02 -0500
Received: from correo.us.es ([193.147.175.20]:35918 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727059AbgBMMGC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 13 Feb 2020 07:06:02 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id EC983100788
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Feb 2020 13:05:59 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DD6F0DA78C
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Feb 2020 13:05:59 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D2A12DA781; Thu, 13 Feb 2020 13:05:59 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 88199DA710
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Feb 2020 13:05:57 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 13 Feb 2020 13:05:57 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 693AC42EE38E
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Feb 2020 13:05:57 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] tests: shell: validate error reporting with include and glob
Date:   Thu, 13 Feb 2020 13:05:53 +0100
Message-Id: <20200213120553.574947-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/shell/testcases/include/0018include_error_0 | 34 ++++++++++++
 tests/shell/testcases/include/0019include_error_0 | 63 +++++++++++++++++++++++
 2 files changed, 97 insertions(+)
 create mode 100755 tests/shell/testcases/include/0018include_error_0
 create mode 100755 tests/shell/testcases/include/0019include_error_0

diff --git a/tests/shell/testcases/include/0018include_error_0 b/tests/shell/testcases/include/0018include_error_0
new file mode 100755
index 000000000000..ae2dba3cfbe8
--- /dev/null
+++ b/tests/shell/testcases/include/0018include_error_0
@@ -0,0 +1,34 @@
+#!/bin/bash
+
+tmpfile1=$(mktemp)
+if [ ! -w $tmpfile1 ] ; then
+        echo "Failed to create tmp file" >&2
+        exit 1
+fi
+
+touch $tmpfile1
+
+RULESET="include \"$tmpfile1\"
+)
+"
+
+tmpfile2=$(mktemp)
+if [ ! -w $tmpfile2 ] ; then
+        echo "Failed to create tmp file" >&2
+        exit 1
+fi
+
+tmpfile3=$(mktemp)
+if [ ! -w $tmpfile3 ] ; then
+        echo "Failed to create tmp file" >&2
+        exit 1
+fi
+
+echo "/dev/stdin:2:1-1: Error: syntax error, unexpected ')'
+)
+^" > $tmpfile3
+
+$NFT -I/tmp/ -f - <<< "$RULESET" 2> $tmpfile2
+$DIFF -u $tmpfile2 $tmpfile3
+
+rm $tmpfile1 $tmpfile2 $tmpfile3
diff --git a/tests/shell/testcases/include/0019include_error_0 b/tests/shell/testcases/include/0019include_error_0
new file mode 100755
index 000000000000..4b84a578c16f
--- /dev/null
+++ b/tests/shell/testcases/include/0019include_error_0
@@ -0,0 +1,63 @@
+#!/bin/bash
+
+tmpfile1=$(mktemp)
+if [ ! -w $tmpfile1 ] ; then
+        echo "Failed to create tmp file" >&2
+        exit 1
+fi
+
+tmpfile2=$(mktemp)
+if [ ! -w $tmpfile2 ] ; then
+        echo "Failed to create tmp file" >&2
+        exit 1
+fi
+
+echo "(" >> $tmpfile2
+
+tmpdir=$(mktemp -d)
+
+echo "include \"$tmpfile2\"
+include \"$tmpdir/*.nft\"
+x" > $tmpfile1
+
+echo "=" > $tmpdir/1.nft
+echo ")" > $tmpdir/2.nft
+echo "-" > $tmpdir/3.nft
+
+tmpfile3=$(mktemp)
+if [ ! -w $tmpfile3 ] ; then
+        echo "Failed to create tmp file" >&2
+        exit 1
+fi
+
+echo "In file included from $tmpfile1:1:1-30:
+$tmpfile2:1:1-1: Error: syntax error, unexpected '('
+(
+^
+In file included from $tmpfile1:2:1-36:
+$tmpdir/1.nft:1:1-1: Error: syntax error, unexpected '='
+=
+^
+In file included from $tmpfile1:2:1-36:
+$tmpdir/2.nft:1:1-1: Error: syntax error, unexpected ')'
+)
+^
+In file included from $tmpfile1:2:1-36:
+$tmpdir/3.nft:1:1-1: Error: syntax error, unexpected -
+-
+^
+$tmpfile1:3:2-2: Error: syntax error, unexpected newline, expecting string
+x
+ ^" > $tmpfile3
+
+tmpfile4=$(mktemp)
+if [ ! -w $tmpfile4 ] ; then
+        echo "Failed to create tmp file" >&2
+        exit 1
+fi
+
+$NFT -I/tmp/ -f $tmpfile1 2> $tmpfile4
+$DIFF -u $tmpfile3 $tmpfile4
+
+rm $tmpfile1 $tmpfile2 $tmpfile3 $tmpfile4
+rm -r $tmpdir
-- 
2.11.0

