Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7DF619F110
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Oct 2024 14:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729606224; cv=none; b=kcz2a5ncue81JuUVvRCQ+gytUCwR0W7V/yD38Ju5/o9480jgE42PdpxMxT+ufniXZgAVKHItF4ZPu9ktVtp3tFapjF0uvY+dSQFRu72vErh1gi303yi7XJlAYzt/sVRNSfnAHiU/zVw8EhmanNYmt9ZUi6WqF19j/Kc7Zpn8eAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729606224; c=relaxed/simple;
	bh=X9NDigsxaj27yBH0XbVlegzlCgfZ4QYNbuCCsPSvcqE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=F+9/atP/ou0Re9UiBHxLGQ5KwOzRZaxSOrxU/u6/SWMWHqjMMj1QRanHedSnqly9RnHWbOHw2d2bpnd+aSo6goxIgb1A93BPFuXG8Ge38hXx18CD+x2MGtLXTX2qdYDGm2nCeSrg8doC5Am30npFVGBOf54NLWeyVY4kv0dSCRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1t3FaQ-00012a-0p; Tue, 22 Oct 2024 16:10:14 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] tests: shell: don't rely on writable test directory
Date: Tue, 22 Oct 2024 16:09:54 +0200
Message-ID: <20241022140956.8160-1-fw@strlen.de>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Running shell tests from a virtme-ng instance with ro mapped test dir
hangs due to runaway 'awk' reading from stdin instead of the intended
$tmpfile (variable is empty).

Some tests want to check relative includes and try to create temporary
files in the current directory.

[ -w ! $foo ... doesn't catch the error due to missing "".
Add quotes and return the skip retval so those tests get flagged as
skipped.

It would be better to resolve this by creating all temporary
files in /tmp, but this is more intrusive change.

0013input_descriptors_included_files_0 and 0020include_chain_0 are
switched to normal tmpfiles, there is nothing in the test that needs
relative includes.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/shell/testcases/include/0002relative_0  | 13 ++++----
 .../0013input_descriptors_included_files_0    | 30 +++++++++----------
 .../testcases/include/0020include_chain_0     |  9 +++---
 3 files changed, 25 insertions(+), 27 deletions(-)

diff --git a/tests/shell/testcases/include/0002relative_0 b/tests/shell/testcases/include/0002relative_0
index a91cd8f00047..30f4bbdbff79 100755
--- a/tests/shell/testcases/include/0002relative_0
+++ b/tests/shell/testcases/include/0002relative_0
@@ -1,21 +1,20 @@
 #!/bin/bash
 
-set -e
-
 tmpfile1=$(mktemp -p .)
-if [ ! -w $tmpfile1 ] ; then
+if [ ! -w "$tmpfile1" ] ; then
         echo "Failed to create tmp file" >&2
-        exit 0
+        exit 77
 fi
 
+trap "rm -rf $tmpfile1 $tmpfile2" EXIT # cleanup if aborted
+set -e
+
 tmpfile2=$(mktemp -p .)
-if [ ! -w $tmpfile2 ] ; then
+if [ ! -w "$tmpfile2" ] ; then
         echo "Failed to create tmp file" >&2
         exit 0
 fi
 
-trap "rm -rf $tmpfile1 $tmpfile2" EXIT # cleanup if aborted
-
 RULESET1="add table x"
 RULESET2="include \"$tmpfile1\""
 
diff --git a/tests/shell/testcases/include/0013input_descriptors_included_files_0 b/tests/shell/testcases/include/0013input_descriptors_included_files_0
index 03de50b3c499..9dc6615dd332 100755
--- a/tests/shell/testcases/include/0013input_descriptors_included_files_0
+++ b/tests/shell/testcases/include/0013input_descriptors_included_files_0
@@ -7,32 +7,32 @@
 # instead of return value of nft.
 
 
-tmpfile1=$(mktemp -p .)
-if [ ! -w $tmpfile1 ] ; then
+tmpfile1=$(mktemp)
+if [ ! -w "$tmpfile1" ] ; then
         echo "Failed to create tmp file" >&2
-        exit 0
+        exit 77
 fi
 
-tmpfile2=$(mktemp -p .)
-if [ ! -w $tmpfile2 ] ; then
+trap "rm -rf $tmpfile1 $tmpfile2 $tmpfile3 $tmpfile4" EXIT # cleanup if aborted
+
+tmpfile2=$(mktemp)
+if [ ! -w "$tmpfile2" ] ; then
         echo "Failed to create tmp file" >&2
-        exit 0
+        exit 77
 fi
 
-tmpfile3=$(mktemp -p .)
-if [ ! -w $tmpfile3 ] ; then
+tmpfile3=$(mktemp)
+if [ ! -w "$tmpfile3" ] ; then
         echo "Failed to create tmp file" >&2
-        exit 0
+        exit 77
 fi
 
-tmpfile4=$(mktemp -p .)
-if [ ! -w $tmpfile4 ]; then
+tmpfile4=$(mktemp)
+if [ ! -w "$tmpfile4" ]; then
         echo "Failed to create tmp file" >&2
-        exit 0
+        exit 77
 fi
 
-trap "rm -rf $tmpfile1 $tmpfile2 $tmpfile3 $tmpfile4" EXIT # cleanup if aborted
-
 RULESET1="include \"$tmpfile2\""
 RULESET2="include \"$tmpfile3\""
 RULESET3="add rule x y anything everything"			# wrong nft syntax
@@ -44,7 +44,7 @@ echo "$RULESET3" > $tmpfile2
 
 $NFT -f $tmpfile1 2> $tmpfile4
 
-var=$(awk -F: '$4==" Error"{print $1;exit;}' $tmpfile4)
+var=$(awk -F: '$4==" Error"{print $1;exit;}' "$tmpfile4")
 
 if [ $var == "$tmpfile3" ]; then
 	echo "E: Test failed" >&2
diff --git a/tests/shell/testcases/include/0020include_chain_0 b/tests/shell/testcases/include/0020include_chain_0
index 49b6f76c6a8d..a09511974e29 100755
--- a/tests/shell/testcases/include/0020include_chain_0
+++ b/tests/shell/testcases/include/0020include_chain_0
@@ -1,13 +1,12 @@
 #!/bin/bash
 
-set -e
-
-tmpfile1=$(mktemp -p .)
-if [ ! -w $tmpfile1 ] ; then
+tmpfile1=$(mktemp)
+if [ ! -w "$tmpfile1" ] ; then
 	echo "Failed to create tmp file" >&2
-	exit 0
+	exit 77
 fi
 
+set -e
 trap "rm -rf $tmpfile1" EXIT # cleanup if aborted
 
 RULESET="table inet filter { }
-- 
2.45.2

