From: Anatole Denis <anatole@rezel.net>
Subject: [PATCH nft 2/3] tests: Add regression test for malformed sets
Date: Mon, 28 Nov 2016 17:43:09 +0100
Message-ID: <3808d7e70955006aa8bebaab262110fdec391314.1480350941.git.anatole@rezel.net>
References: <b02aab6dfd61eff6e5fd9b2e517fd13f493e4887.1480350941.git.anatole@rezel.net>
Cc: Anatole Denis <anatole@rezel.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from inara.rezel.net ([212.129.30.46]:39570 "EHLO inara.rezel.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933062AbcK1Qna (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 28 Nov 2016 11:43:30 -0500
In-Reply-To: <b02aab6dfd61eff6e5fd9b2e517fd13f493e4887.1480350941.git.anatole@rezel.net>
In-Reply-To: <b02aab6dfd61eff6e5fd9b2e517fd13f493e4887.1480350941.git.anatole@rezel.net>
References: <b02aab6dfd61eff6e5fd9b2e517fd13f493e4887.1480350941.git.anatole@rezel.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

see: 5afa5a164ff1c066af1ec56d875b91562882bd50
When a malformed set is added, it was added before erroring out, causing a
segfault further down when used. This tests for this case, ensuring that
nftables doesn't segfault but errors correctly

Signed-off-by: Anatole Denis <anatole@rezel.net>
---
 This test is maybe not that useful, but I used it to test that I didn't
 reintroduce the bug. Maybe a different naming rule for regression tests could
 be used ?

 .../sets/0014malformed_set_is_not_defined_0        | 33 ++++++++++++++++++++++
 1 file changed, 33 insertions(+)
 create mode 100755 tests/shell/testcases/sets/0014malformed_set_is_not_defined_0

diff --git a/tests/shell/testcases/sets/0014malformed_set_is_not_defined_0 b/tests/shell/testcases/sets/0014malformed_set_is_not_defined_0
new file mode 100755
index 0000000..720ec49
--- /dev/null
+++ b/tests/shell/testcases/sets/0014malformed_set_is_not_defined_0
@@ -0,0 +1,33 @@
+#!/bin/bash
+
+# This tests for the bug corrected in commit 5afa5a164ff1c066af1ec56d875b91562882bd50.
+# Sets were added to the table before checking for errors, and not removed from
+# the table on error, leading to an uninitialized set in the table, causing a
+# segfault for rules that tried to use it.
+# In this case, nft should error out because the set doesn't exist instead of
+# segfaulting
+
+tmpfile=$(mktemp)
+if [ ! -w $tmpfile ] ; then
+	echo "Failed to create tmp file" >&2
+	exit 0
+fi
+
+trap "rm -rf $tmpfile" EXIT # cleanup if aborted
+
+echo "
+add table t
+add chain t c
+add set t s {type ipv4_addr\;}
+add rule t c ip saddr @s
+" >$tmpfile
+
+$NFT -f $tmpfile
+ret=$?
+
+trap - EXIT
+if [[ $ret -eq 1 ]]; then
+	exit 0
+else
+	exit 1
+fi
-- 
2.11.0.rc2

