Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C67D7449981
	for <netfilter-devel@vger.kernel.org>; Thu,  9 Jul 2026 20:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783627455; cv=none; b=SX0C4M42YpepmxR8bqnXvyk2bIzXIpumTzUw7KuzIbAm2i9pGSeoSwfdWY+DNxSog1jo2fd7DQWTppP2ZDz7jBCCCo9RFc65aRJfrkLXVtjYbnOhh6pqY8rEaApCfJIweOTidrfZDONNl8vArDGf3ixS6u1uQlXSQYTvcsXBJVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783627455; c=relaxed/simple;
	bh=O8ihTVAWjr3bUrxy+nx0npZ5FbUZaOVT6gKBUtnJdQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ti2LeF8BXCyJl2XN/cv3MF3x4P4OFG2kOAZ9CxaSX2raVHF/9jO6PrnpehHSJ9/hpOBW6RmgmjjoNNjCzSyYT6FuFQDraxuoCGTbD14d185AJO2WF9tqGrlT8tgwITBQ5XyWqkJrbayQ6KofB5uh9uaZd4AngVfF2ZRKP8tq080=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 058736032C; Thu, 09 Jul 2026 22:04:09 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: kadlec@netfilter.org,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH ipset 1/7] tests: make runtest.sh work with readonly-cwd
Date: Thu,  9 Jul 2026 22:03:52 +0200
Message-ID: <20260709200358.15504-2-fw@strlen.de>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260709200358.15504-1-fw@strlen.de>
References: <20260709200358.15504-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

My local test setup spawns qemu instances via virtme-ng.
The host file system is a readonly export, only /tmp is
writeable.

Make runtest.sh create a temporary dir, then export
IPSET_TMPDIR to all other scripts and use that location
to load/store temporary data.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/big_sort.sh           |  8 ++++----
 tests/bitmap:ip.t           | 28 ++++++++++++++--------------
 tests/check_klog.sh         |  4 ++--
 tests/comment.t             | 32 ++++++++++++++++----------------
 tests/hash:ip,mark.t        |  8 ++++----
 tests/hash:ip,port,ip.t     |  8 ++++----
 tests/hash:ip,port,net.t    |  4 ++--
 tests/hash:ip,port.t        | 32 ++++++++++++++++----------------
 tests/hash:ip.t             | 28 ++++++++++++++--------------
 tests/hash:ip6,mark.t       |  8 ++++----
 tests/hash:ip6,port,ip6.t   |  8 ++++----
 tests/hash:ip6,port,net6.t  |  4 ++--
 tests/hash:ip6,port.t       |  8 ++++----
 tests/hash:ip6.t            | 32 ++++++++++++++++----------------
 tests/hash:mac.t            | 16 ++++++++--------
 tests/hash:net,iface.t      | 12 ++++++------
 tests/hash:net,net.t        | 32 ++++++++++++++++----------------
 tests/hash:net,port,net.t   |  4 ++--
 tests/hash:net,port.t       |  8 ++++----
 tests/hash:net.t            | 16 ++++++++--------
 tests/hash:net6,net6.t      |  8 ++++----
 tests/hash:net6,port,net6.t |  4 ++--
 tests/hash:net6,port.t      | 16 ++++++++--------
 tests/hash:net6.t           |  8 ++++----
 tests/ignore.sh             |  2 +-
 tests/iphash.t              | 20 ++++++++++----------
 tests/ipmap.t               | 28 ++++++++++++++--------------
 tests/ipmarkhash.t          |  8 ++++----
 tests/ipporthash.t          |  8 ++++----
 tests/ipportiphash.t        |  8 ++++----
 tests/ipportnethash.t       |  8 ++++----
 tests/iptables.sh           |  8 ++++----
 tests/iptree.t              |  4 ++--
 tests/iptreemap.t           |  4 ++--
 tests/macipmap.t            | 16 ++++++++--------
 tests/match_target.t        |  2 +-
 tests/nethash.t             |  4 ++--
 tests/portmap.t             | 16 ++++++++--------
 tests/restore.t             |  2 +-
 tests/runtest.sh            | 14 +++++++++++---
 tests/sendip.sh             |  2 +-
 tests/setlist.t             | 26 +++++++++++++-------------
 tests/sort.sh               |  6 +++---
 43 files changed, 265 insertions(+), 257 deletions(-)

diff --git a/tests/big_sort.sh b/tests/big_sort.sh
index 05eced805dff..033198d81815 100755
--- a/tests/big_sort.sh
+++ b/tests/big_sort.sh
@@ -7,8 +7,8 @@ for x in `seq 0 255`; do
         echo "a test 10.10.$x.$y"
     done
 done | ipset r
-ipset -t list > .foo
-diff .foo big_sort.terse
-ipset -s save > .foo
-diff .foo big_sort.saved
+ipset -t list > "$IPSET_TMP/.foo"
+diff "$IPSET_TMP/.foo" big_sort.terse
+ipset -s save > "$IPSET_TMP/.foo"
+diff "$IPSET_TMP/.foo" big_sort.saved
 ipset x test
diff --git a/tests/bitmap:ip.t b/tests/bitmap:ip.t
index a0ca22f92c36..53034bbbae89 100644
--- a/tests/bitmap:ip.t
+++ b/tests/bitmap:ip.t
@@ -35,15 +35,15 @@
 # Range: Add a range of elements
 0 ipset -A test 2.0.0.128-2.0.0.131 timeout 4
 # Range: List set
-0 ipset list test > .foo
+0 ipset list test > "$IPSET_TMP/.foo"
 # Range: Check listing
-0 ./diff.sh .foo bitmap:ip.t.list4
+0 ./diff.sh "$IPSET_TMP/.foo" bitmap:ip.t.list4
 # Sleep 5s so that entries can time out
 0 sleep 5s
 # Range: List set after timeout
-0 ipset list test > .foo
+0 ipset list test > "$IPSET_TMP/.foo"
 # Range: Check listing
-0 ./diff.sh .foo bitmap:ip.t.list0
+0 ./diff.sh "$IPSET_TMP/.foo" bitmap:ip.t.list0
 # Range: Flush test set
 0 ipset flush test
 # Range: Delete test set
@@ -77,15 +77,15 @@
 # Network: Delete the same element
 0 ipset -D test 2.0.0.128
 # Network: List set
-0 ipset list test > .foo
+0 ipset list test > "$IPSET_TMP/.foo"
 # Network: Check listing
-0 ./diff.sh .foo bitmap:ip.t.list5
+0 ./diff.sh "$IPSET_TMP/.foo" bitmap:ip.t.list5
 # Sleep 5s so that entries can time out
 0 sleep 5s
 # Network: List set
-0 ipset list test > .foo
+0 ipset list test > "$IPSET_TMP/.foo"
 # Network: Check listing
-0 ./diff.sh .foo bitmap:ip.t.list1
+0 ./diff.sh "$IPSET_TMP/.foo" bitmap:ip.t.list1
 # Network: Flush test set
 0 ipset flush test
 # Network: Delete test set
@@ -119,15 +119,15 @@
 # Subnets: Add a subnet of subnets
 0 ipset -A test 10.8.0.0/16 timeout 4
 # Subnets: List set
-0 ipset list test > .foo
+0 ipset list test > "$IPSET_TMP/.foo"
 # Subnets: Check listing
-0 ./diff.sh .foo bitmap:ip.t.list6
+0 ./diff.sh "$IPSET_TMP/.foo" bitmap:ip.t.list6
 # Sleep 5s so that entries can time out
 0 sleep 5s
 # Subnets: List set
-0 ipset list test > .foo
+0 ipset list test > "$IPSET_TMP/.foo"
 # Subnets: Check listing
-0 ./diff.sh .foo bitmap:ip.t.list2
+0 ./diff.sh "$IPSET_TMP/.foo" bitmap:ip.t.list2
 # Subnets: Flush test set
 0 ipset flush test
 # Subnets: Delete test set
@@ -145,9 +145,9 @@
 # Full: Test element not added to the set
 1 ipset test test 0.1.0.0
 # Full: List set
-0 ipset list test > .foo
+0 ipset list test > "$IPSET_TMP/.foo"
 # Full: Check listing
-0 ./diff.sh .foo bitmap:ip.t.list3
+0 ./diff.sh "$IPSET_TMP/.foo" bitmap:ip.t.list3
 # Full: flush set
 0 ipset flush test
 # Full: add element with 1s timeout
diff --git a/tests/check_klog.sh b/tests/check_klog.sh
index 9af5f66f28eb..8ecad3eb987e 100755
--- a/tests/check_klog.sh
+++ b/tests/check_klog.sh
@@ -5,8 +5,8 @@ set -e
 
 # arguments: ipaddr proto port setname ...
 
-test -f .loglines || exit 1
-loglines=$(<.loglines)
+test -f "$IPSET_TMP/.loglines" || exit 1
+loglines=$(<"$IPSET_TMP/.loglines")
 if [ $loglines -ne 0 ]; then
     loglines=$((loglines - 1))
 fi
diff --git a/tests/comment.t b/tests/comment.t
index 8f579198ea13..e5b664b9229b 100644
--- a/tests/comment.t
+++ b/tests/comment.t
@@ -9,9 +9,9 @@
 # Bitmap comment: Test element with comment
 0 ipset test test 2.0.0.1
 # Bitmap comment: List set
-0 ipset list test > .foo
+0 ipset list test > "$IPSET_TMP/.foo"
 # Bitmap comment: Check listing
-0 ./diff.sh .foo comment.t.list0
+0 ./diff.sh "$IPSET_TMP/.foo" comment.t.list0
 # Bitmap comment: Delete element with comment
 0 ipset del test 2.0.0.1
 # Bitmap comment: Test deleted element
@@ -31,9 +31,9 @@
 # Bitmap comment: Add multiple elements with comment
 0 for x in `seq 1 255`; do echo "add test 2.0.0.$x comment \\\"text message $x\\\""; done | ipset restore
 # Bitmap comment: List set
-0 ipset list test > .foo
+0 ipset list test > "$IPSET_TMP/.foo"
 # Bitmap comment: Check listing
-0 ./diff.sh .foo comment.t.list1
+0 ./diff.sh "$IPSET_TMP/.foo" comment.t.list1
 # Bitmap comment: Delete test set
 0 ipset destroy test
 # Bitmap comment: create set with timeout
@@ -43,15 +43,15 @@
 # Bitmap comment: Add multiple elements with zero timeout
 0 for x in `seq 1 255`; do echo "add test 2.0.1.$x timeout 0 comment \\\"text message $x\\\""; done | ipset restore
 # Bitmap comment: List set
-0 ipset list test > .foo
+0 ipset list test > "$IPSET_TMP/.foo"
 # Bitmap comment: Check listing
-0 ./diff.sh .foo comment.t.list11
+0 ./diff.sh "$IPSET_TMP/.foo" comment.t.list11
 # Sleep 5s so that entries can time out
 0 sleep 5s
 # Bitmap comment: List set
-0 ipset list test > .foo
+0 ipset list test > "$IPSET_TMP/.foo"
 # Bitmap comment: Check listing
-0 ./diff.sh .foo comment.t.list12
+0 ./diff.sh "$IPSET_TMP/.foo" comment.t.list12
 # Bitmap comment: Flush set
 0 ipset flush test
 # Bitmap comment: Delete test set
@@ -87,9 +87,9 @@
 # Hash comment: Try to add IP address
 0 ipset add test 2.0.0.1,2.0.0.2 
 # Hash comment: List set
-0 ipset list test > .foo0 && ./sort.sh .foo0
+0 ipset list test > "$IPSET_TMP/.foo0" && ./sort.sh "$IPSET_TMP/.foo0"
 # Hash comment: Check listing
-0 ./diff.sh .foo comment.t.list2
+0 ./diff.sh "$IPSET_TMP/.foo" comment.t.list2
 # Hash comment: Update element with comment
 0 ipset -! add test 2.0.0.1,2.0.0.2 comment "text 2.0.0.1,2.0.0.2"
 # Hash comment: Check updated element
@@ -123,15 +123,15 @@
 # Hash comment: Add multiple elements with zero timeout
 0 for x in `seq 0 255`; do echo "add test 2.0.1.$x timeout 0 comment \\\"text message $x\\\""; done | ipset restore
 # Hash comment: List set
-0 ipset list test > .foo0 && ./sort.sh .foo0
+0 ipset list test > "$IPSET_TMP/.foo0" && ./sort.sh "$IPSET_TMP/.foo0"
 # Hash comment: Check listing
-0 ./diff.sh .foo comment.t.list21
+0 ./diff.sh "$IPSET_TMP/.foo" comment.t.list21
 # Sleep 5s so that entries can time out
 0 sleep 5s
 # Hash comment: List set
-0 ipset list test > .foo0 && ./sort.sh .foo0
+0 ipset list test > "$IPSET_TMP/.foo0" && ./sort.sh "$IPSET_TMP/.foo0"
 # Hash comment: Check listing
-0 ./diff.sh .foo comment.t.list22
+0 ./diff.sh "$IPSET_TMP/.foo" comment.t.list22
 # Hash comment: Flush set
 0 ipset flush test
 # Hash comment: Delete test set
@@ -147,9 +147,9 @@
 # List comment: Add b set with comment
 0 ipset a test b after a comment "b set comment"
 # List comment: List sets
-0 ipset list > .foo
+0 ipset list > "$IPSET_TMP/.foo"
 # List comment: Check listing
-0 ./diff.sh .foo comment.t.list3
+0 ./diff.sh "$IPSET_TMP/.foo" comment.t.list3
 # Flush sets
 0 ipset f
 # Destroy sets
diff --git a/tests/hash:ip,mark.t b/tests/hash:ip,mark.t
index ce94efc49f7f..8141f69341b9 100644
--- a/tests/hash:ip,mark.t
+++ b/tests/hash:ip,mark.t
@@ -27,15 +27,15 @@
 # Try to add value after second random value
 0 ipset add test 2.1.0.1,0x80
 # List set
-0 ipset list test > .foo0 && ./sort.sh .foo0
+0 ipset list test > "$IPSET_TMP/.foo0" && ./sort.sh "$IPSET_TMP/.foo0"
 # Check listing
-0 ./diff.sh .foo hash:ip,mark.t.list0
+0 ./diff.sh "$IPSET_TMP/.foo" hash:ip,mark.t.list0
 # Sleep 5s so that elements can time out
 0 sleep 5
 # List set
-0 ipset list test > .foo0 && ./sort.sh .foo0
+0 ipset list test > "$IPSET_TMP/.foo0" && ./sort.sh "$IPSET_TMP/.foo0"
 # Check listing
-0 ./diff.sh .foo hash:ip,mark.t.list1
+0 ./diff.sh "$IPSET_TMP/.foo" hash:ip,mark.t.list1
 # Flush test set
 0 ipset flush test
 # Add multiple elements in one step
diff --git a/tests/hash:ip,port,ip.t b/tests/hash:ip,port,ip.t
index fcd6985a2391..254a1a1855e1 100644
--- a/tests/hash:ip,port,ip.t
+++ b/tests/hash:ip,port,ip.t
@@ -35,15 +35,15 @@
 # Try to add value after second random value
 0 ipset add test 2.1.0.1,128,2.2.2.2
 # List set
-0 ipset list test > .foo0 && ./sort.sh .foo0
+0 ipset list test > "$IPSET_TMP/.foo0" && ./sort.sh "$IPSET_TMP/.foo0"
 # Check listing
-0 ./diff.sh .foo hash:ip,port,ip.t.list0
+0 ./diff.sh "$IPSET_TMP/.foo" hash:ip,port,ip.t.list0
 # Sleep 5s so that elements can time out
 0 sleep 5
 # List set
-0 ipset list test > .foo0 && ./sort.sh .foo0
+0 ipset list test > "$IPSET_TMP/.foo0" && ./sort.sh "$IPSET_TMP/.foo0"
 # Check listing
-0 ./diff.sh .foo hash:ip,port,ip.t.list1
+0 ./diff.sh "$IPSET_TMP/.foo" hash:ip,port,ip.t.list1
 # Flush test set
 0 ipset flush test
 # Add multiple elements in one step
diff --git a/tests/hash:ip,port,net.t b/tests/hash:ip,port,net.t
index 67d20b04ed56..4fb8df6cdb80 100644
--- a/tests/hash:ip,port,net.t
+++ b/tests/hash:ip,port,net.t
@@ -27,9 +27,9 @@
 # Try to add value after second random value
 0 ipset add test 2.1.0.1,128,10.0.0.0/17
 # List set
-0 ipset list test > .foo0 && ./sort.sh .foo0
+0 ipset list test > "$IPSET_TMP/.foo0" && ./sort.sh "$IPSET_TMP/.foo0"
 # Check listing
-0 ./diff.sh .foo hash:ip,port,net.t.list0
+0 ./diff.sh "$IPSET_TMP/.foo" hash:ip,port,net.t.list0
 # Sleep 5s so that elements can time out
 0 sleep 5
 # List set
diff --git a/tests/hash:ip,port.t b/tests/hash:ip,port.t
index f65fb5911682..3e5011b7ffc1 100644
--- a/tests/hash:ip,port.t
+++ b/tests/hash:ip,port.t
@@ -31,15 +31,15 @@
 # Delete port by number
 0 ipset del test 2.1.0.3,25
 # List set
-0 ipset list test > .foo0 && ./sort.sh .foo0
+0 ipset list test > "$IPSET_TMP/.foo0" && ./sort.sh "$IPSET_TMP/.foo0"
 # Check listing
-0 ./diff.sh .foo hash:ip,port.t.list0
+0 ./diff.sh "$IPSET_TMP/.foo" hash:ip,port.t.list0
 # Sleep 5s so that elements can time out
 0 sleep 5
 # List set
-0 ipset list test > .foo0 && ./sort.sh .foo0
+0 ipset list test > "$IPSET_TMP/.foo0" && ./sort.sh "$IPSET_TMP/.foo0"
 # Check listing
-0 ./diff.sh .foo hash:ip,port.t.list1
+0 ./diff.sh "$IPSET_TMP/.foo" hash:ip,port.t.list1
 # Flush test set
 0 ipset flush test
 # Add multiple elements in one step
@@ -73,9 +73,9 @@
 # Delete element with sctp
 0 ipset del test 2.0.0.1,sctp:80
 # List set
-0 ipset list test > .foo0 && ./sort.sh .foo0
+0 ipset list test > "$IPSET_TMP/.foo0" && ./sort.sh "$IPSET_TMP/.foo0"
 # Check listing
-0 ./diff.sh .foo hash:ip,port.t.list2
+0 ./diff.sh "$IPSET_TMP/.foo" hash:ip,port.t.list2
 # Delete set
 0 ipset destroy test
 # Create set to add a range
@@ -195,15 +195,15 @@
 # Network: Delete the same network
 0 ipset -D test 200.100.0.12,22
 # Network: List set
-0 ipset -L test > .foo0 && ./sort.sh .foo0
+0 ipset -L test > "$IPSET_TMP/.foo0" && ./sort.sh "$IPSET_TMP/.foo0"
 # Network: Check listing
-0 ./diff.sh .foo hash:ip,port.t.list3
+0 ./diff.sh "$IPSET_TMP/.foo" hash:ip,port.t.list3
 # Sleep 5s so that elements can time out
 0 sleep 5
 # Network: List set
-0 ipset -L test > .foo
+0 ipset -L test > "$IPSET_TMP/.foo"
 # Network: Check listing
-0 ./diff.sh .foo hash:ip,port.t.list4
+0 ./diff.sh "$IPSET_TMP/.foo" hash:ip,port.t.list4
 # Network: Flush test set
 0 ipset -F test
 # Network: add element with 1s timeout
@@ -241,15 +241,15 @@
 # Network: Delete the same network
 0 ipset -D test 200.100.0.12,22
 # Network: List set
-0 ipset -L test > .foo0 && ./sort.sh .foo0
+0 ipset -L test > "$IPSET_TMP/.foo0" && ./sort.sh "$IPSET_TMP/.foo0"
 # Network: Check listing
-0 ./diff.sh .foo hash:ip,port.t.list5
+0 ./diff.sh "$IPSET_TMP/.foo" hash:ip,port.t.list5
 # Sleep 5s so that elements can time out
 0 sleep 5
 # Network: List set
-0 ipset -L test > .foo
+0 ipset -L test > "$IPSET_TMP/.foo"
 # Network: Check listing
-0 ./diff.sh .foo hash:ip,port.t.list6
+0 ./diff.sh "$IPSET_TMP/.foo" hash:ip,port.t.list6
 # Network: Flush test set
 0 ipset -F test
 # Network: add element with 1s timeout
@@ -283,9 +283,9 @@
 # Network: Test delete value
 0 ipset -D test 1.168.0.124,22
 # Network: List set
-0 ipset -L test > .foo
+0 ipset -L test > "$IPSET_TMP/.foo"
 # Network: Check listing
-0 ./diff.sh .foo hash:ip,port.t.list7
+0 ./diff.sh "$IPSET_TMP/.foo" hash:ip,port.t.list7
 # Network: Delete test set
 0 ipset -X test
 # eof
diff --git a/tests/hash:ip.t b/tests/hash:ip.t
index 3771437dd267..529e6b815069 100644
--- a/tests/hash:ip.t
+++ b/tests/hash:ip.t
@@ -19,15 +19,15 @@
 # IP: Delete the same value
 0 ipset -D test 200.100.0.12
 # IP: List set
-0 ipset -L test > .foo0 && ./sort.sh .foo0
+0 ipset -L test > "$IPSET_TMP/.foo0" && ./sort.sh "$IPSET_TMP/.foo0"
 # IP: Check listing
-0 ./diff.sh .foo hash:ip.t.list2
+0 ./diff.sh "$IPSET_TMP/.foo" hash:ip.t.list2
 # Sleep 5s so that element can time out
 0 sleep 5
 # IP: List set
-0 ipset -L test > .foo0 && ./sort.sh .foo0
+0 ipset -L test > "$IPSET_TMP/.foo0" && ./sort.sh "$IPSET_TMP/.foo0"
 # IP: Check listing
-0 ./diff.sh .foo hash:ip.t.list0
+0 ./diff.sh "$IPSET_TMP/.foo" hash:ip.t.list0
 # IP: Flush test set
 0 ipset -F test
 # IP: Add multiple elements in one step
@@ -97,15 +97,15 @@
 # Network: Delete the same network
 0 ipset -D test 200.100.0.12
 # Network: List set
-0 ipset -L test > .foo0 && ./sort.sh .foo0
+0 ipset -L test > "$IPSET_TMP/.foo0" && ./sort.sh "$IPSET_TMP/.foo0"
 # Network: Check listing
-0 ./diff.sh .foo hash:ip.t.list3
+0 ./diff.sh "$IPSET_TMP/.foo" hash:ip.t.list3
 # Sleep 5s so that elements can time out
 0 sleep 5
 # Network: List set
-0 ipset -L test > .foo
+0 ipset -L test > "$IPSET_TMP/.foo"
 # Network: Check listing
-0 ./diff.sh .foo hash:ip.t.list1
+0 ./diff.sh "$IPSET_TMP/.foo" hash:ip.t.list1
 # Network: Flush test set
 0 ipset -F test
 # Network: add element with 1s timeout
@@ -241,15 +241,15 @@ skip which sendip
 # Network: Delete the same network
 0 ipset -D test 200.100.0.12
 # Network: List set
-0 ipset -L test > .foo0 && ./sort.sh .foo0
+0 ipset -L test > "$IPSET_TMP/.foo0" && ./sort.sh "$IPSET_TMP/.foo0"
 # Network: Check listing
-0 ./diff.sh .foo hash:ip.t.list4
+0 ./diff.sh "$IPSET_TMP/.foo" hash:ip.t.list4
 # Sleep 5s so that elements can time out
 0 sleep 5
 # Network: List set
-0 ipset -L test > .foo
+0 ipset -L test > "$IPSET_TMP/.foo"
 # Network: Check listing
-0 ./diff.sh .foo hash:ip.t.list5
+0 ./diff.sh "$IPSET_TMP/.foo" hash:ip.t.list5
 # Network: Flush test set
 0 ipset -F test
 # Network: add element with 1s timeout
@@ -285,9 +285,9 @@ skip which sendip
 # Network: Test delete value
 0 ipset -D test 1.2.0.5
 # Network: List set
-0 ipset -L test > .foo
+0 ipset -L test > "$IPSET_TMP/.foo"
 # Network: Check listing
-0 ./diff.sh .foo hash:ip.t.list6
+0 ./diff.sh "$IPSET_TMP/.foo" hash:ip.t.list6
 # Network: Delete test set
 0 ipset -X test
 # eof
diff --git a/tests/hash:ip6,mark.t b/tests/hash:ip6,mark.t
index af46d97ee4da..222afe55bff5 100644
--- a/tests/hash:ip6,mark.t
+++ b/tests/hash:ip6,mark.t
@@ -27,15 +27,15 @@
 # Try to add value after second random value
 0 ipset add test 2:1:0::1,0x80
 # List set
-0 ipset list test > .foo0 && ./sort.sh .foo0
+0 ipset list test > "$IPSET_TMP/.foo0" && ./sort.sh "$IPSET_TMP/.foo0"
 # Check listing
-0 ./diff.sh .foo hash:ip6,mark.t.list0
+0 ./diff.sh "$IPSET_TMP/.foo" hash:ip6,mark.t.list0
 # Sleep 5s so that elements can time out
 0 sleep 5
 # List set
-0 ipset list test > .foo0 && ./sort.sh .foo0
+0 ipset list test > "$IPSET_TMP/.foo0" && ./sort.sh "$IPSET_TMP/.foo0"
 # Check listing
-0 ./diff.sh .foo hash:ip6,mark.t.list1
+0 ./diff.sh "$IPSET_TMP/.foo" hash:ip6,mark.t.list1
 # Delete test set
 0 ipset destroy test
 # Create set to add a range
diff --git a/tests/hash:ip6,port,ip6.t b/tests/hash:ip6,port,ip6.t
index aaf6530a1fe4..c76889871c4f 100644
--- a/tests/hash:ip6,port,ip6.t
+++ b/tests/hash:ip6,port,ip6.t
@@ -35,15 +35,15 @@
 # Try to add value after second random value
 0 ipset add test 2:1:0::1,128,2:2:2::2
 # List set
-0 ipset list test > .foo0 && ./sort.sh .foo0
+0 ipset list test > "$IPSET_TMP/.foo0" && ./sort.sh "$IPSET_TMP/.foo0"
 # Check listing
-0 ./diff.sh .foo hash:ip6,port,ip6.t.list0
+0 ./diff.sh "$IPSET_TMP/.foo" hash:ip6,port,ip6.t.list0
 # Sleep 5s so that elements can time out
 0 sleep 5
 # List set
-0 ipset list test > .foo0 && ./sort.sh .foo0
+0 ipset list test > "$IPSET_TMP/.foo0" && ./sort.sh "$IPSET_TMP/.foo0"
 # Check listing
-0 ./diff.sh .foo hash:ip6,port,ip6.t.list1
+0 ./diff.sh "$IPSET_TMP/.foo" hash:ip6,port,ip6.t.list1
 # Flush test set
 0 ipset flush test
 # Add multiple elements in one step
diff --git a/tests/hash:ip6,port,net6.t b/tests/hash:ip6,port,net6.t
index 71dfa6193764..f04ca0973b8b 100644
--- a/tests/hash:ip6,port,net6.t
+++ b/tests/hash:ip6,port,net6.t
@@ -35,9 +35,9 @@
 # Range: Try to add value after second random value
 0 ipset -A test 2:1:0::1,128,2:2:2::2/12
 # Range: List set
-0 ipset -L test > .foo0 && ./sort.sh .foo0
+0 ipset -L test > "$IPSET_TMP/.foo0" && ./sort.sh "$IPSET_TMP/.foo0"
 # Range: Check listing
-0 ./diff.sh .foo hash:ip6,port,net6.t.list0
+0 ./diff.sh "$IPSET_TMP/.foo" hash:ip6,port,net6.t.list0
 # Range: Flush test set
 0 ipset -F test
 # Range: Delete test set
diff --git a/tests/hash:ip6,port.t b/tests/hash:ip6,port.t
index e56e39c55121..5ff2e9111b01 100644
--- a/tests/hash:ip6,port.t
+++ b/tests/hash:ip6,port.t
@@ -27,15 +27,15 @@
 # Try to add value after second random value
 0 ipset add test 2:1:0::1,128
 # List set
-0 ipset list test > .foo0 && ./sort.sh .foo0
+0 ipset list test > "$IPSET_TMP/.foo0" && ./sort.sh "$IPSET_TMP/.foo0"
 # Check listing
-0 ./diff.sh .foo hash:ip6,port.t.list0
+0 ./diff.sh "$IPSET_TMP/.foo" hash:ip6,port.t.list0
 # Sleep 5s so that elements can time out
 0 sleep 5
 # List set
-0 ipset list test > .foo0 && ./sort.sh .foo0
+0 ipset list test > "$IPSET_TMP/.foo0" && ./sort.sh "$IPSET_TMP/.foo0"
 # Check listing
-0 ./diff.sh .foo hash:ip6,port.t.list1
+0 ./diff.sh "$IPSET_TMP/.foo" hash:ip6,port.t.list1
 # Flush test set
 0 ipset flush test
 # Add multiple elements in one step
diff --git a/tests/hash:ip6.t b/tests/hash:ip6.t
index 52175a5a2938..17b51094dd9b 100644
--- a/tests/hash:ip6.t
+++ b/tests/hash:ip6.t
@@ -21,25 +21,25 @@
 # IP: Delete the same value
 0 ipset -D test 200:100:0::12
 # IP: List set
-0 ipset -L test > .foo0 && ./sort.sh .foo0
+0 ipset -L test > "$IPSET_TMP/.foo0" && ./sort.sh "$IPSET_TMP/.foo0"
 # IP: Check listing
-0 ./diff.sh .foo hash:ip6.t.list2
+0 ./diff.sh "$IPSET_TMP/.foo" hash:ip6.t.list2
 # IP: Save set
-0 ipset save test > hash:ip6.t.restore
+0 ipset save test > "$IPSET_TMP/hash:ip6.t.restore"
 # Sleep 5s so that element can time out
 0 sleep 5
 # IP: List set
-0 ipset -L test > .foo0 && ./sort.sh .foo0
+0 ipset -L test > "$IPSET_TMP/.foo0" && ./sort.sh "$IPSET_TMP/.foo0"
 # IP: Check listing
-0 ./diff.sh .foo hash:ip6.t.list0
+0 ./diff.sh "$IPSET_TMP/.foo" hash:ip6.t.list0
 # IP: Destroy set
 0 ipset x test
 # IP: Restore saved set
-0 ipset restore < hash:ip6.t.restore && rm hash:ip6.t.restore
+0 ipset restore < "$IPSET_TMP/hash:ip6.t.restore" && rm "$IPSET_TMP/hash:ip6.t.restore"
 # IP: List set
-0 ipset -L test > .foo0 && ./sort.sh .foo0
+0 ipset -L test > "$IPSET_TMP/.foo0" && ./sort.sh "$IPSET_TMP/.foo0"
 # IP: Check listing
-0 ./diff.sh .foo hash:ip6.t.list2
+0 ./diff.sh "$IPSET_TMP/.foo" hash:ip6.t.list2
 # IP: Flush test set
 0 ipset -F test
 # IP: Try to add multiple elements in one step
@@ -73,15 +73,15 @@
 # Network: Test the deleted network
 1 ipset -T test 200:101:0::12
 # Network: List set
-0 ipset -L test > .foo0 && ./sort.sh .foo0
+0 ipset -L test > "$IPSET_TMP/.foo0" && ./sort.sh "$IPSET_TMP/.foo0"
 # Network: Check listing
-0 ./diff.sh .foo hash:ip6.t.list3
+0 ./diff.sh "$IPSET_TMP/.foo" hash:ip6.t.list3
 # Sleep 5s so that elements can time out
 0 sleep 5
 # Network: List set
-0 ipset -L test > .foo
+0 ipset -L test > "$IPSET_TMP/.foo"
 # Network: Check listing
-0 ./diff.sh .foo hash:ip6.t.list1
+0 ./diff.sh "$IPSET_TMP/.foo" hash:ip6.t.list1
 # Network: Flush test set
 0 ipset -F test
 # Network: Delete test set
@@ -89,13 +89,13 @@
 # Check more complex restore commands
 0 ipset restore < restore.t.restore
 # List restored set a
-0 ipset l a > .foo0 && ./sort.sh .foo0
+0 ipset l a > "$IPSET_TMP/.foo0" && ./sort.sh "$IPSET_TMP/.foo0"
 # Check listing of set a
-0 ./diff.sh .foo restore.t.list0
+0 ./diff.sh "$IPSET_TMP/.foo" restore.t.list0
 # List restored set b
-0 ipset l b > .foo0 && ./sort.sh .foo0
+0 ipset l b > "$IPSET_TMP/.foo0" && ./sort.sh "$IPSET_TMP/.foo0"
 # Check listing of set b
-0 ./diff.sh .foo restore.t.list1
+0 ./diff.sh "$IPSET_TMP/.foo" restore.t.list1
 # Destroy by restore
 0 ipset restore < restore.t.destroy
 # Timeout: Check that resizing keeps timeout values
diff --git a/tests/hash:mac.t b/tests/hash:mac.t
index 9192af06f10a..ed0cb3d953d7 100644
--- a/tests/hash:mac.t
+++ b/tests/hash:mac.t
@@ -19,15 +19,15 @@
 # MAC: Delete the same value
 0 ipset -D test 1:2:3:4:a:b
 # MAC: List set
-0 ipset -L test > .foo0 && ./sort.sh .foo0
+0 ipset -L test > "$IPSET_TMP/.foo0" && ./sort.sh "$IPSET_TMP/.foo0"
 # MAC: Check listing
-0 ./diff.sh .foo hash:mac.t.list2
+0 ./diff.sh "$IPSET_TMP/.foo" hash:mac.t.list2
 # Sleep 5s so that element can time out
 0 sleep 5
 # MAC: List set
-0 ipset -L test > .foo0 && ./sort.sh .foo0
+0 ipset -L test > "$IPSET_TMP/.foo0" && ./sort.sh "$IPSET_TMP/.foo0"
 # MAC: Check listing
-0 ./diff.sh .foo hash:mac.t.list0
+0 ./diff.sh "$IPSET_TMP/.foo" hash:mac.t.list0
 # MAC: Destroy test set
 0 ipset -X test
 # MAC: Create a set with skbinfo extension
@@ -45,9 +45,9 @@
 # MAC: Add element with mark, skbprio and skbqueue
 0 ipset a test 1:2:3:4:5:11 skbmark 0x11223344/0xffff0000 skbprio 2:1 skbqueue 8 
 # MAC: List set
-0 ipset -L test > .foo0 && ./sort.sh .foo0
+0 ipset -L test > "$IPSET_TMP/.foo0" && ./sort.sh "$IPSET_TMP/.foo0"
 # MAC: Check listing
-0 ./diff.sh .foo hash:mac.t.list1
+0 ./diff.sh "$IPSET_TMP/.foo" hash:mac.t.list1
 # MAC: Destroy test set
 0 ipset -X test
 # MAC: Create a set with small maxelem parameter
@@ -63,9 +63,9 @@
 # MAC: Add second element with another extension value
 0 ipset -! a test 1:2:3:4:5:7 skbprio 1:12 skbqueue 8
 # MAC: List set
-0 ipset -L test > .foo0 && ./sort.sh .foo0
+0 ipset -L test > "$IPSET_TMP/.foo0" && ./sort.sh "$IPSET_TMP/.foo0"
 # MAC: Check listing
-0 ./diff.sh .foo hash:mac.t.list3
+0 ./diff.sh "$IPSET_TMP/.foo" hash:mac.t.list3
 # MAC: Destroy test set
 0 ipset x test
 # eof
diff --git a/tests/hash:net,iface.t b/tests/hash:net,iface.t
index 444f230a77f3..bcd0ba451c62 100644
--- a/tests/hash:net,iface.t
+++ b/tests/hash:net,iface.t
@@ -41,9 +41,9 @@
 # Try to add IP address
 0 ipset add test 2.0.0.1,eth0
 # List set
-0 ipset list test > .foo0 && ./sort.sh .foo0
+0 ipset list test > "$IPSET_TMP/.foo0" && ./sort.sh "$IPSET_TMP/.foo0"
 # Check listing
-0 ./diff.sh .foo hash:net,iface.t.list0
+0 ./diff.sh "$IPSET_TMP/.foo" hash:net,iface.t.list0
 # Flush test set
 0 ipset flush test
 # Delete test set
@@ -53,9 +53,9 @@
 # Add networks in range notation
 0 ipset add test 10.2.0.0-10.2.1.12,eth0
 # List set
-0 ipset -L test > .foo0 && ./sort.sh .foo0
+0 ipset -L test > "$IPSET_TMP/.foo0" && ./sort.sh "$IPSET_TMP/.foo0"
 # Check listing
-0 ./diff.sh .foo hash:net,iface.t.list2
+0 ./diff.sh "$IPSET_TMP/.foo" hash:net,iface.t.list2
 # Flush test set
 0 ipset flush test
 # Add 0/0,eth0
@@ -117,9 +117,9 @@
 # Add overlapping networks from /4 to /30
 0 (set -e; for x in `seq 4 30`; do ipset add test 192.0.0.0/$x,eth$x; done)
 # List test set
-0 ipset -L test > .foo0 && ./sort.sh .foo0
+0 ipset -L test > "$IPSET_TMP/.foo0" && ./sort.sh "$IPSET_TMP/.foo0"
 # Check listing
-0 ./diff.sh .foo hash:net,iface.t.list1
+0 ./diff.sh "$IPSET_TMP/.foo" hash:net,iface.t.list1
 # Test matching elements in all added networks from /30 to /24
 0 (set -e; y=2; for x in `seq 24 30 | tac`; do ipset test test 192.0.0.$y,eth$x; y=$((y*2)); done)
 # Test non-matching elements in all added networks from /30 to /24
diff --git a/tests/hash:net,net.t b/tests/hash:net,net.t
index 41189b708015..dcfdcc7f3c71 100644
--- a/tests/hash:net,net.t
+++ b/tests/hash:net,net.t
@@ -33,15 +33,15 @@
 # Try to add IP address
 0 ipset add test 2.0.0.1,2.0.0.2
 # List set
-0 ipset list test > .foo0 && ./sort.sh .foo0
+0 ipset list test > "$IPSET_TMP/.foo0" && ./sort.sh "$IPSET_TMP/.foo0"
 # Check listing
-0 ./diff.sh .foo hash:net,net.t.list0
+0 ./diff.sh "$IPSET_TMP/.foo" hash:net,net.t.list0
 # Sleep 5s so that element can time out
 0 sleep 5
 # List set
-0 ipset -L test > .foo0 && ./sort.sh .foo0
+0 ipset -L test > "$IPSET_TMP/.foo0" && ./sort.sh "$IPSET_TMP/.foo0"
 # Check listing
-0 ./diff.sh .foo hash:net,net.t.list1
+0 ./diff.sh "$IPSET_TMP/.foo" hash:net,net.t.list1
 # Flush test set
 0 ipset flush test
 # Delete test set
@@ -51,9 +51,9 @@
 # Add networks in range notation
 0 ipset add test 10.2.0.0-10.2.1.12,10.3.0.0-10.3.1.12
 # List set
-0 ipset -L test > .foo0 && ./sort.sh .foo0
+0 ipset -L test > "$IPSET_TMP/.foo0" && ./sort.sh "$IPSET_TMP/.foo0"
 # Check listing
-0 ./diff.sh .foo hash:net,net.t.list2
+0 ./diff.sh "$IPSET_TMP/.foo" hash:net,net.t.list2
 # Delete test set
 0 ipset destroy test
 # Stress test with range notation
@@ -185,15 +185,15 @@
 # Network: Delete the same network
 0 ipset -D test 200.100.0.12,200.100.0.13
 # Network: List set
-0 ipset -L test > .foo0 && ./sort.sh .foo0
+0 ipset -L test > "$IPSET_TMP/.foo0" && ./sort.sh "$IPSET_TMP/.foo0"
 # Network: Check listing
-0 ./diff.sh .foo hash:net,net.t.list3
+0 ./diff.sh "$IPSET_TMP/.foo" hash:net,net.t.list3
 # Sleep 5s so that elements can time out
 0 sleep 5
 # Network: List set
-0 ipset -L test > .foo
+0 ipset -L test > "$IPSET_TMP/.foo"
 # Network: Check listing
-0 ./diff.sh .foo hash:net,net.t.list4
+0 ./diff.sh "$IPSET_TMP/.foo" hash:net,net.t.list4
 # Network: Flush test set
 0 ipset -F test
 # Network: add element with 1s timeout
@@ -225,15 +225,15 @@
 # Network: Delete the same network
 0 ipset -D test 200.100.0.12,200.100.0.13
 # Network: List set
-0 ipset -L test > .foo0 && ./sort.sh .foo0
+0 ipset -L test > "$IPSET_TMP/.foo0" && ./sort.sh "$IPSET_TMP/.foo0"
 # Network: Check listing
-0 ./diff.sh .foo hash:net,net.t.list5
+0 ./diff.sh "$IPSET_TMP/.foo" hash:net,net.t.list5
 # Sleep 5s so that elements can time out
 0 sleep 5
 # Network: List set
-0 ipset -L test > .foo
+0 ipset -L test > "$IPSET_TMP/.foo"
 # Network: Check listing
-0 ./diff.sh .foo hash:net,net.t.list6
+0 ./diff.sh "$IPSET_TMP/.foo" hash:net,net.t.list6
 # Network: Flush test set
 0 ipset -F test
 # Network: add element with 1s timeout
@@ -267,9 +267,9 @@
 # Network: Test delete value
 0 ipset -D test 1.168.12.124,122.23.0.50
 # Network: List set
-0 ipset -L test > .foo
+0 ipset -L test > "$IPSET_TMP/.foo"
 # Network: Check listing
-0 ./diff.sh .foo hash:net,net.t.list7
+0 ./diff.sh "$IPSET_TMP/.foo" hash:net,net.t.list7
 # Network: Delete test set
 0 ipset -X test
 # eof
diff --git a/tests/hash:net,port,net.t b/tests/hash:net,port,net.t
index 2c9516be4e27..470d91282b9d 100644
--- a/tests/hash:net,port,net.t
+++ b/tests/hash:net,port,net.t
@@ -27,9 +27,9 @@
 # Try to add value after second random value
 0 ipset add test 2.1.0.1,128,10.0.0.0/17
 # List set
-0 ipset list test > .foo0 && ./sort.sh .foo0
+0 ipset list test > "$IPSET_TMP/.foo0" && ./sort.sh "$IPSET_TMP/.foo0"
 # Check listing
-0 ./diff.sh .foo hash:net,port,net.t.list0
+0 ./diff.sh "$IPSET_TMP/.foo" hash:net,port,net.t.list0
 # Sleep 5s so that elements can time out
 0 sleep 5
 # List set
diff --git a/tests/hash:net,port.t b/tests/hash:net,port.t
index 5a850e6394dd..aea4fdf04a4c 100644
--- a/tests/hash:net,port.t
+++ b/tests/hash:net,port.t
@@ -41,15 +41,15 @@
 # Test ICMP by name
 0 ipset test test 2.0.0.255,icmp:host-prohibited
 # List set
-0 ipset list test > .foo0 && ./sort.sh .foo0
+0 ipset list test > "$IPSET_TMP/.foo0" && ./sort.sh "$IPSET_TMP/.foo0"
 # Check listing
-0 ./diff.sh .foo hash:net,port.t.list0
+0 ./diff.sh "$IPSET_TMP/.foo" hash:net,port.t.list0
 # Sleep 5s so that element can time out
 0 sleep 5
 # IP: List set
-0 ipset -L test > .foo0 && ./sort.sh .foo0
+0 ipset -L test > "$IPSET_TMP/.foo0" && ./sort.sh "$IPSET_TMP/.foo0"
 # IP: Check listing
-0 ./diff.sh .foo hash:net,port.t.list1
+0 ./diff.sh "$IPSET_TMP/.foo" hash:net,port.t.list1
 # Flush test set
 0 ipset flush test
 # Add multiple elements in one step
diff --git a/tests/hash:net.t b/tests/hash:net.t
index c74ace1e99e3..e621701c734f 100644
--- a/tests/hash:net.t
+++ b/tests/hash:net.t
@@ -33,15 +33,15 @@
 # Try to add IP address
 0 ipset add test 2.0.0.1
 # List set
-0 ipset list test > .foo0 && ./sort.sh .foo0
+0 ipset list test > "$IPSET_TMP/.foo0" && ./sort.sh "$IPSET_TMP/.foo0"
 # Check listing
-0 ./diff.sh .foo hash:net.t.list0
+0 ./diff.sh "$IPSET_TMP/.foo" hash:net.t.list0
 # Sleep 5s so that element can time out
 0 sleep 5
 # List set
-0 ipset -L test > .foo0 && ./sort.sh .foo0
+0 ipset -L test > "$IPSET_TMP/.foo0" && ./sort.sh "$IPSET_TMP/.foo0"
 # Check listing
-0 ./diff.sh .foo hash:net.t.list1
+0 ./diff.sh "$IPSET_TMP/.foo" hash:net.t.list1
 # Flush test set
 0 ipset flush test
 # Delete test set
@@ -51,9 +51,9 @@
 # Add networks in range notation
 0 ipset add test 10.2.0.0-10.2.1.12
 # List set
-0 ipset -L test > .foo0 && ./sort.sh .foo0
+0 ipset -L test > "$IPSET_TMP/.foo0" && ./sort.sh "$IPSET_TMP/.foo0"
 # Check listing
-0 ./diff.sh .foo hash:net.t.list2
+0 ./diff.sh "$IPSET_TMP/.foo" hash:net.t.list2
 # Delete test set
 0 ipset destroy test
 # Stress test with range notation
@@ -127,9 +127,9 @@
 # Add more than 2^31 elements in a range
 0 ipset a test 0.0.0.0-128.0.0.1
 # List set
-0 ipset -L test > .foo0 && ./sort.sh .foo0
+0 ipset -L test > "$IPSET_TMP/.foo0" && ./sort.sh "$IPSET_TMP/.foo0"
 # Check listing
-0 ./diff.sh .foo hash:net.t.list3
+0 ./diff.sh "$IPSET_TMP/.foo" hash:net.t.list3
 # Delete test set
 0 ipset destroy test
 # Counters: create set
diff --git a/tests/hash:net6,net6.t b/tests/hash:net6,net6.t
index 257d142d83c1..4dcf90bc0707 100644
--- a/tests/hash:net6,net6.t
+++ b/tests/hash:net6,net6.t
@@ -33,15 +33,15 @@
 # Try to add IP address
 0 ipset add test 3:0:0::1,8:0:0::1
 # List set
-0 ipset list test > .foo0 && ./sort.sh .foo0
+0 ipset list test > "$IPSET_TMP/.foo0" && ./sort.sh "$IPSET_TMP/.foo0"
 # Check listing
-0 ./diff.sh .foo hash:net6,net6.t.list0
+0 ./diff.sh "$IPSET_TMP/.foo" hash:net6,net6.t.list0
 # Sleep 5s so that element can time out
 0 sleep 5
 # IP: List set
-0 ipset -L test > .foo0 && ./sort.sh .foo0
+0 ipset -L test > "$IPSET_TMP/.foo0" && ./sort.sh "$IPSET_TMP/.foo0"
 # IP: Check listing
-0 ./diff.sh .foo hash:net6,net6.t.list1
+0 ./diff.sh "$IPSET_TMP/.foo" hash:net6,net6.t.list1
 # Flush test set
 0 ipset flush test
 # Add matching IP address entry
diff --git a/tests/hash:net6,port,net6.t b/tests/hash:net6,port,net6.t
index 7ec737ec3833..c3164cb438c4 100644
--- a/tests/hash:net6,port,net6.t
+++ b/tests/hash:net6,port,net6.t
@@ -41,9 +41,9 @@
 # Range: Try to add value after second random value
 0 ipset -A test 2:1:0::1,128,2:2:2::2/12
 # Range: List set
-0 ipset -L test > .foo0 && ./sort.sh .foo0
+0 ipset -L test > "$IPSET_TMP/.foo0" && ./sort.sh "$IPSET_TMP/.foo0"
 # Range: Check listing
-0 ./diff.sh .foo hash:net6,port,net6.t.list0
+0 ./diff.sh "$IPSET_TMP/.foo" hash:net6,port,net6.t.list0
 # Range: Flush test set
 0 ipset -F test
 # Range: Delete test set
diff --git a/tests/hash:net6,port.t b/tests/hash:net6,port.t
index a9a0f907fefb..be800452ef35 100644
--- a/tests/hash:net6,port.t
+++ b/tests/hash:net6,port.t
@@ -41,25 +41,25 @@
 # Test ICMPv6 by name
 0 ipset test test 192:168:68::95,icmpv6:port-unreachable
 # List set
-0 ipset list test > .foo0 && ./sort.sh .foo0
+0 ipset list test > "$IPSET_TMP/.foo0" && ./sort.sh "$IPSET_TMP/.foo0"
 # Save set
-0 ipset save test > hash:net6,port.t.restore
+0 ipset save test > "$IPSET_TMP/hash:net6,port.t.restore"
 # Check listing
-0 ./diff.sh .foo hash:net6,port.t.list0
+0 ./diff.sh "$IPSET_TMP/.foo" hash:net6,port.t.list0
 # Sleep 5s so that element can time out
 0 sleep 5
 # IP: List set
-0 ipset -L test > .foo0 && ./sort.sh .foo0
+0 ipset -L test > "$IPSET_TMP/.foo0" && ./sort.sh "$IPSET_TMP/.foo0"
 # IP: Check listing
-0 ./diff.sh .foo hash:net6,port.t.list1
+0 ./diff.sh "$IPSET_TMP/.foo" hash:net6,port.t.list1
 # Destroy set
 0 ipset x test
 # Restore set
-0 ipset restore < hash:net6,port.t.restore && rm hash:net6,port.t.restore
+0 ipset restore < "$IPSET_TMP/hash:net6,port.t.restore" && rm "$IPSET_TMP/hash:net6,port.t.restore"
 # List set
-0 ipset list test > .foo0 && ./sort.sh .foo0
+0 ipset list test > "$IPSET_TMP/.foo0" && ./sort.sh "$IPSET_TMP/.foo0"
 # Check listing
-0 ./diff.sh .foo hash:net6,port.t.list0
+0 ./diff.sh "$IPSET_TMP/.foo" hash:net6,port.t.list0
 # Flush test set
 0 ipset flush test
 # Add multiple elements in one step
diff --git a/tests/hash:net6.t b/tests/hash:net6.t
index 67ef33e24e06..e48a85446ec7 100644
--- a/tests/hash:net6.t
+++ b/tests/hash:net6.t
@@ -33,15 +33,15 @@
 # Try to add IP address
 0 ipset add test 3:0:0::1
 # List set
-0 ipset list test > .foo0 && ./sort.sh .foo0
+0 ipset list test > "$IPSET_TMP/.foo0" && ./sort.sh "$IPSET_TMP/.foo0"
 # Check listing
-0 ./diff.sh .foo hash:net6.t.list0
+0 ./diff.sh "$IPSET_TMP/.foo" hash:net6.t.list0
 # Sleep 5s so that element can time out
 0 sleep 5
 # IP: List set
-0 ipset -L test > .foo0 && ./sort.sh .foo0
+0 ipset -L test > "$IPSET_TMP/.foo0" && ./sort.sh "$IPSET_TMP/.foo0"
 # IP: Check listing
-0 ./diff.sh .foo hash:net6.t.list1
+0 ./diff.sh "$IPSET_TMP/.foo" hash:net6.t.list1
 # Flush test set
 0 ipset flush test
 # Delete test set
diff --git a/tests/ignore.sh b/tests/ignore.sh
index 9d458e302bda..db617f3c7701 100755
--- a/tests/ignore.sh
+++ b/tests/ignore.sh
@@ -1,4 +1,4 @@
 #!/bin/sh
 
-grep -v Revision: $1 | sed 's/initval 0x[0-9a-fA-F]\{8\}/initval 0x00000000/' > .foo
+grep -v Revision: $1 | sed 's/initval 0x[0-9a-fA-F]\{8\}/initval 0x00000000/' > "$IPSET_TMP/.foo"
 rm $1
diff --git a/tests/iphash.t b/tests/iphash.t
index 4d651139eb95..c7c0b081e34a 100644
--- a/tests/iphash.t
+++ b/tests/iphash.t
@@ -23,9 +23,9 @@
 # IP: Delete element not added to the set, ignoring error
 0 ipset -! -D test 200.100.0.12
 # IP: List set
-0 ipset -L test > .foo0 && ./sort.sh .foo0
+0 ipset -L test > "$IPSET_TMP/.foo0" && ./sort.sh "$IPSET_TMP/.foo0"
 # IP: Check listing
-0 ./diff.sh .foo iphash.t.list0
+0 ./diff.sh "$IPSET_TMP/.foo" iphash.t.list0
 # IP: Flush test set
 0 ipset -F test
 # IP: Delete test set
@@ -33,13 +33,13 @@
 # IP: Restore values so that rehashing is triggered, old format
 0 ipset -R < iphash.t.restore.old
 # IP: Check that all values are restored
-0 (grep add iphash.t.restore | sort > .foo.1) && (ipset -S test | grep add | sort > .foo.2) && cmp .foo.1 .foo.2
+0 (grep add iphash.t.restore | sort > "$IPSET_TMP/.foo.1") && (ipset -S test | grep add | sort > "$IPSET_TMP/.foo.2") && cmp "$IPSET_TMP/"{.foo.1,.foo.2}
 # IP: Delete test set
 0 ipset -X test
 # IP: Restore values so that rehashing is triggered
 0 ipset -R < iphash.t.restore
 # IP: Check that all values are restored
-0 (grep add iphash.t.restore | sort > .foo.1) && (ipset -S test | grep add | sort > .foo.2) && cmp .foo.1 .foo.2
+0 (grep add iphash.t.restore | sort > "$IPSET_TMP/.foo.1") && (ipset -S test | grep add | sort > "$IPSET_TMP/.foo.2") && cmp "$IPSET_TMP/"{.foo.1,.foo.2}
 # IP: Flush test set
 0 ipset -F test
 # IP: Delete test set
@@ -53,9 +53,9 @@
 # IP: Add more entries to the second set
 0 tail -n +2 iphash.t.restore | sed -e 's/test/test2/' -e 's/ 10/ 30/' | ipset r
 # IP: Save sets
-0 ipset -s -f .foo0 save && ./ignore.sh .foo0
+0 ipset -s -f "$IPSET_TMP/.foo0" save && ./ignore.sh "$IPSET_TMP/.foo0"
 # IP: Compare sorted save and restore
-0 cmp .foo iphash.t.restore.sorted
+0 cmp "$IPSET_TMP/.foo" iphash.t.restore.sorted
 # IP: Delete test set
 0 ipset x test
 # IP: Delete test2 set
@@ -63,9 +63,9 @@
 # IP: Restore, which requires multiple messages
 0 ipset restore < iphash.t.large
 # IP: Save the restored set
-0 (ipset save test | sort > .foo.1) && ./ignore.sh .foo.1
+0 (ipset save test | sort > "$IPSET_TMP/.foo.1") && ./ignore.sh "$IPSET_TMP/.foo.1"
 # IP: Compare save and restore
-0 (sort iphash.t.large > .foo.2) && (cmp .foo .foo.2)
+0 (sort iphash.t.large > "$IPSET_TMP/.foo.2") && (cmp "$IPSET_TMP/.foo" "$IPSET_TMP/.foo.2")
 # IP: Delete all elements, one by one
 0 ipset list test | sed '1,/Members/d' | xargs -n1 ipset del test
 # IP: Delete test set
@@ -95,9 +95,9 @@
 # Network: Delete element not added to the set
 1 ipset -D test 200.100.0.12
 # Network: List set
-0 ipset -L test > .foo0 && ./sort.sh .foo0
+0 ipset -L test > "$IPSET_TMP/.foo0" && ./sort.sh "$IPSET_TMP/.foo0"
 # Network: Check listing
-0 ./diff.sh .foo iphash.t.list1
+0 ./diff.sh "$IPSET_TMP/.foo" iphash.t.list1
 # Network: Flush test set
 0 ipset -F test
 # Network: Delete test set
diff --git a/tests/ipmap.t b/tests/ipmap.t
index 8e90dc2d1082..e5b613466ec6 100644
--- a/tests/ipmap.t
+++ b/tests/ipmap.t
@@ -37,27 +37,27 @@
 # Range: Add a range of elements
 0 ipset -A test 2.0.0.128-2.0.0.131
 # Range: Save set
-0 ipset -S test > ipmap.t.restore
+0 ipset -S test > "$IPSET_TMP/ipmap.t.restore"
 # Range: Destroy set
 0 ipset -X test
 # Range: Restore set and catch error
-1 sed 's/2.0.0.131/222.0.0.131/' < ipmap.t.restore | ipset -R
+1 sed 's/2.0.0.131/222.0.0.131/' < "$IPSET_TMP/ipmap.t.restore" | ipset -R
 # Range: Check returned error line number
-0 num=`grep 'in line' < .foo.err | sed 's/.* in line //' | cut -d : -f 1` && test $num -eq 6
+0 num=`grep 'in line' < "$IPSET_TMP/.foo.err" | sed 's/.* in line //' | cut -d : -f 1` && test $num -eq 6
 # Range: Destroy set
 0 ipset -X test
 # Range: Restore set
-0 ipset -R < ipmap.t.restore && rm ipmap.t.restore
+0 ipset -R < "$IPSET_TMP/ipmap.t.restore" && rm "$IPSET_TMP/ipmap.t.restore"
 # Range: List set
-0 ipset -L test > .foo
+0 ipset -L test > "$IPSET_TMP/.foo"
 # Range: Check listing
-0 ./diff.sh .foo ipmap.t.list0
+0 ./diff.sh "$IPSET_TMP/.foo" ipmap.t.list0
 # Range: Delete a range of elements
 0 ipset -! -D test 2.0.0.128-2.0.0.132
 # Range: List set
-0 ipset -L test > .foo
+0 ipset -L test > "$IPSET_TMP/.foo"
 # Range: Check listing
-0 ./diff.sh .foo ipmap.t.list1
+0 ./diff.sh "$IPSET_TMP/.foo" ipmap.t.list1
 # Range: Flush test set
 0 ipset -F test
 # Range: Delete test set
@@ -91,9 +91,9 @@
 # Network: Delete the same element
 0 ipset -D test 2.0.0.128
 # Network: List set
-0 ipset -L test > .foo
+0 ipset -L test > "$IPSET_TMP/.foo"
 # Network: Check listing
-0 ./diff.sh .foo ipmap.t.list2
+0 ./diff.sh "$IPSET_TMP/.foo" ipmap.t.list2
 # Network: Flush test set
 0 ipset -F test
 # Network: Delete test set
@@ -127,9 +127,9 @@
 # Subnets: Add a subnet of subnets
 0 ipset -A test 10.8.0.0/16
 # Subnets: List set
-0 ipset -L test > .foo
+0 ipset -L test > "$IPSET_TMP/.foo"
 # Subnets: Check listing
-0 ./diff.sh .foo ipmap.t.list3
+0 ./diff.sh "$IPSET_TMP/.foo" ipmap.t.list3
 # Subnets: FLush test set
 0 ipset -F test
 # Subnets: Delete test set
@@ -153,9 +153,9 @@
 # Full: Delete same element
 0 ipset -D test 0.1.0.0
 # Full: List set
-0 ipset -L test > .foo
+0 ipset -L test > "$IPSET_TMP/.foo"
 # Full: Check listing
-0 ./diff.sh .foo ipmap.t.list4
+0 ./diff.sh "$IPSET_TMP/.foo" ipmap.t.list4
 # Full: Delete test set
 0 ipset -X test
 # eof
diff --git a/tests/ipmarkhash.t b/tests/ipmarkhash.t
index 1276f7252434..276178da0bc0 100644
--- a/tests/ipmarkhash.t
+++ b/tests/ipmarkhash.t
@@ -31,9 +31,9 @@
 # Try to add value after second random value
 0 ipset -A test 2.1.0.1,0x80
 # List set
-0 ipset -L test > .foo0 && ./sort.sh .foo0
+0 ipset -L test > "$IPSET_TMP/.foo0" && ./sort.sh "$IPSET_TMP/.foo0"
 # Check listing
-0 ./diff.sh .foo ipmarkhash.t.list0
+0 ./diff.sh "$IPSET_TMP/.foo" ipmarkhash.t.list0
 # Flush test set
 0 ipset -F test
 # Delete test set
@@ -61,9 +61,9 @@
 # Try to add value after second random value
 0 ipset -A test 2.1.0.0,0x80
 # List set
-0 ipset -L test > .foo0 && ./sort.sh .foo0
+0 ipset -L test > "$IPSET_TMP/.foo0" && ./sort.sh "$IPSET_TMP/.foo0"
 # Check listing
-0 ./diff.sh .foo ipmarkhash.t.list1
+0 ./diff.sh "$IPSET_TMP/.foo" ipmarkhash.t.list1
 # Flush test set
 0 ipset -F test
 # Delete test set
diff --git a/tests/ipporthash.t b/tests/ipporthash.t
index b8f36063ddb5..21da79235394 100644
--- a/tests/ipporthash.t
+++ b/tests/ipporthash.t
@@ -31,9 +31,9 @@
 # Try to add value after second random value
 0 ipset -A test 2.1.0.1,128
 # List set
-0 ipset -L test > .foo0 && ./sort.sh .foo0
+0 ipset -L test > "$IPSET_TMP/.foo0" && ./sort.sh "$IPSET_TMP/.foo0"
 # Check listing
-0 ./diff.sh .foo ipporthash.t.list0
+0 ./diff.sh "$IPSET_TMP/.foo" ipporthash.t.list0
 # Flush test set
 0 ipset -F test
 # Delete test set
@@ -61,9 +61,9 @@
 # Try to add value after second random value
 0 ipset -A test 2.1.0.0,128
 # List set
-0 ipset -L test > .foo0 && ./sort.sh .foo0
+0 ipset -L test > "$IPSET_TMP/.foo0" && ./sort.sh "$IPSET_TMP/.foo0"
 # Check listing
-0 ./diff.sh .foo ipporthash.t.list1
+0 ./diff.sh "$IPSET_TMP/.foo" ipporthash.t.list1
 # Flush test set
 0 ipset -F test
 # Delete test set
diff --git a/tests/ipportiphash.t b/tests/ipportiphash.t
index 32f22d116366..8256f682f830 100644
--- a/tests/ipportiphash.t
+++ b/tests/ipportiphash.t
@@ -39,9 +39,9 @@
 # Try to add value after second random value
 0 ipset -A test 2.1.0.1,128,2.2.2.2
 # List set
-0 ipset -L test > .foo0 && ./sort.sh .foo0
+0 ipset -L test > "$IPSET_TMP/.foo0" && ./sort.sh "$IPSET_TMP/.foo0"
 # Check listing
-0 ./diff.sh .foo ipportiphash.t.list0
+0 ./diff.sh "$IPSET_TMP/.foo" ipportiphash.t.list0
 # Flush test set
 0 ipset -F test
 # Delete test set
@@ -71,9 +71,9 @@
 # Try to del value before first random value
 0 ipset -D test 1.255.255.255,5,1.1.1.1
 # List set
-0 ipset -L test > .foo0 && ./sort.sh .foo0
+0 ipset -L test > "$IPSET_TMP/.foo0" && ./sort.sh "$IPSET_TMP/.foo0"
 # Check listing
-0 ./diff.sh .foo ipportiphash.t.list1
+0 ./diff.sh "$IPSET_TMP/.foo" ipportiphash.t.list1
 # Flush test set
 0 ipset -F test
 # Delete test set
diff --git a/tests/ipportnethash.t b/tests/ipportnethash.t
index b34d46d88ccd..9b422d08cc62 100644
--- a/tests/ipportnethash.t
+++ b/tests/ipportnethash.t
@@ -35,9 +35,9 @@
 # Range: Try to add value after second random value
 0 ipset -A test 2.1.0.1,128,2.2.2.2/12
 # Range: List set
-0 ipset -L test | grep -v Revision: > .foo0 && ./sort.sh .foo0
+0 ipset -L test | grep -v Revision: > "$IPSET_TMP/.foo0" && ./sort.sh "$IPSET_TMP/.foo0"
 # Range: Check listing
-0 diff -u -I 'Size in memory.*' .foo ipportnethash.t.list0
+0 diff -u -I 'Size in memory.*' "$IPSET_TMP/.foo" ipportnethash.t.list0
 # Range: Flush test set
 0 ipset -F test
 # Range: Delete test set
@@ -65,9 +65,9 @@
 # Network: Try to add value after second random value
 0 ipset -A test 2.1.0.0,128,2.2.2.2/12
 # Network: List set
-0 ipset -L test | grep -v Revision: > .foo0 && ./sort.sh .foo0
+0 ipset -L test | grep -v Revision: > "$IPSET_TMP/.foo0" && ./sort.sh "$IPSET_TMP/.foo0"
 # Network: Check listing
-0 diff -u -I 'Size in memory.*' .foo ipportnethash.t.list1
+0 diff -u -I 'Size in memory.*' "$IPSET_TMP/.foo" ipportnethash.t.list1
 # Network: Flush test set
 0 ipset -F test
 # Add a non-matching IP address entry
diff --git a/tests/iptables.sh b/tests/iptables.sh
index f101ab45767c..119241cdd83a 100755
--- a/tests/iptables.sh
+++ b/tests/iptables.sh
@@ -58,8 +58,8 @@ start)
 		      -j LOG --log-prefix "in set ipport: "
 	$cmd -A INPUT -m set --match-set list src,src \
 		      -j LOG --log-prefix "in set list: "
-	$cmd -A OUTPUT -d $NET -j DROP
-	cat /dev/null > .foo.err
+#	$cmd -A OUTPUT -d $NET -j DROP
+	cat /dev/null > "$IPSET_TMP/.foo.err"
 	cat /dev/null > /var/log/kern.log
 	;;
 start_flags)
@@ -73,7 +73,7 @@ start_flags)
 	$cmd -A INPUT -m set --match-set test src --return-nomatch \
 		      -j LOG --log-prefix "in set test-nomatch: "
 	$cmd -A INPUT -s 10.0.0.0/16 -j DROP
-	cat /dev/null > .foo.err
+	cat /dev/null > "$IPSET_TMP/.foo.err"
 	cat /dev/null > /var/log/kern.log
 	;;
 start_flags_reversed)
@@ -87,7 +87,7 @@ start_flags_reversed)
 	$cmd -A INPUT -m set --match-set test src \
 		      -j LOG --log-prefix "in set test: "
 	$cmd -A INPUT -s 10.0.0.0/16 -j DROP
-	cat /dev/null > .foo.err
+	cat /dev/null > "$IPSET_TMP/.foo.err"
 	cat /dev/null > /var/log/kern.log
 	;;
 del)
diff --git a/tests/iptree.t b/tests/iptree.t
index 1e5f7ade7811..af3ce91aabfe 100644
--- a/tests/iptree.t
+++ b/tests/iptree.t
@@ -13,9 +13,9 @@
 # Static: Test value not added to the set
 1 ipset -T test 192.168.68.70
 # Static: List set
-0 ipset -L test | grep -v Revision: > .foo0 && ./sort.sh .foo0
+0 ipset -L test | grep -v Revision: > "$IPSET_TMP/.foo0" && ./sort.sh "$IPSET_TMP/.foo0"
 # Static: Check listing
-0 diff -u -I 'Size in memory.*' .foo iptree.t.list0
+0 diff -u -I 'Size in memory.*' "$IPSET_TMP/.foo" iptree.t.list0
 # Static: Flush test set
 0 ipset -F test
 # Static: Delete test set
diff --git a/tests/iptreemap.t b/tests/iptreemap.t
index 8061b4fcd7d5..65979d72c36c 100644
--- a/tests/iptreemap.t
+++ b/tests/iptreemap.t
@@ -49,9 +49,9 @@
 # Test element after upper bound of deleted network
 0 ipset -T test 192.168.68.72
 # List set
-0 ipset -L test | grep -v Revision: > .foo0 && ./sort.sh .foo0
+0 ipset -L test | grep -v Revision: > "$IPSET_TMP/.foo0" && ./sort.sh "$IPSET_TMP/.foo0"
 # Check listing
-0 diff -u -I 'Size in memory.*' .foo iptreemap.t.list0
+0 diff -u -I 'Size in memory.*' "$IPSET_TMP/.foo" iptreemap.t.list0
 # Flush test set
 0 ipset -F test
 # Delete test set
diff --git a/tests/macipmap.t b/tests/macipmap.t
index 074e067443b8..c2708aef0b25 100644
--- a/tests/macipmap.t
+++ b/tests/macipmap.t
@@ -39,9 +39,9 @@
 # Range: Delete the same element
 0 ipset -D test 2.0.200.214
 # Range: List set
-0 ipset -L test > .foo
+0 ipset -L test > "$IPSET_TMP/.foo"
 # Range: Check listing
-0 ./diff.sh .foo macipmap.t.list0
+0 ./diff.sh "$IPSET_TMP/.foo" macipmap.t.list0
 # Range: Flush test set
 0 ipset -F test
 # Range: Catch invalid (too long) MAC
@@ -87,9 +87,9 @@
 # Network: Add MAC to already added element
 0 ipset -A test 2.0.255.255,00:11:22:33:44:56
 # Network: List set
-0 ipset -L test > .foo
+0 ipset -L test > "$IPSET_TMP/.foo"
 # Network: Check listing
-0 ./diff.sh .foo macipmap.t.list1
+0 ./diff.sh "$IPSET_TMP/.foo" macipmap.t.list1
 # Network: Flush test set
 0 ipset -F test
 # Network: Delete test set
@@ -127,15 +127,15 @@
 # Range: Delete the same element
 0 ipset -D test 2.0.200.214
 # Range: List set
-0 ipset -L test > .foo
+0 ipset -L test > "$IPSET_TMP/.foo"
 # Range: Check listing
-0 ./diff.sh .foo macipmap.t.list3
+0 ./diff.sh "$IPSET_TMP/.foo" macipmap.t.list3
 # Range: sleep 5s so that elements can timeout
 0 sleep 5
 # Range: List set
-0 ipset -L test > .foo
+0 ipset -L test > "$IPSET_TMP/.foo"
 # Range: Check listing
-0 ./diff.sh .foo macipmap.t.list2
+0 ./diff.sh "$IPSET_TMP/.foo" macipmap.t.list2
 # Range: Flush test set
 0 ipset -F test
 # Range: add element with 1s timeout
diff --git a/tests/match_target.t b/tests/match_target.t
index 4141ce6bddde..c3ead171dd00 100644
--- a/tests/match_target.t
+++ b/tests/match_target.t
@@ -107,7 +107,7 @@
 # Create set and rules for 0.0.0.0/0 check in hash:net,iface
 0 ./iptables.sh inet netiface
 # Send probe packet
-0 ./sendip.sh -p ipv4 -id 10.255.255.254 -is 10.255.255.64 -p udp -ud 80 -us 1025 10.255.255.254 >/dev/null 2>&1
+0 ./sendip.sh -p ipv4 -id 10.255.255.254 -is 10.255.255.64 -p udp -ud 80 -us 1025 10.255.255.254
 # Check kernel log that the packet matched the set
 0 ./check_klog.sh 10.255.255.64 udp 1025 netiface
 # Destroy sets and rules
diff --git a/tests/nethash.t b/tests/nethash.t
index 8f98ffa6888e..c4f47704414e 100644
--- a/tests/nethash.t
+++ b/tests/nethash.t
@@ -33,9 +33,9 @@
 # Try to add IP address
 0 ipset -A test 2.0.0.1
 # List set
-0 ipset -L test > .foo0 && ./sort.sh .foo0
+0 ipset -L test > "$IPSET_TMP/.foo0" && ./sort.sh "$IPSET_TMP/.foo0"
 # Check listing
-0 ./diff.sh .foo nethash.t.list0
+0 ./diff.sh "$IPSET_TMP/.foo" nethash.t.list0
 # Flush test set
 0 ipset -F test
 # Add a non-matching IP address entry
diff --git a/tests/portmap.t b/tests/portmap.t
index 819a59bc072e..1b4a82fd81b4 100644
--- a/tests/portmap.t
+++ b/tests/portmap.t
@@ -25,9 +25,9 @@
 # Range: Delete the same element
 0 ipset -D test 567
 # Range: List set
-0 ipset -L test > .foo
+0 ipset -L test > "$IPSET_TMP/.foo"
 # Range: Check listing
-0 ./diff.sh .foo portmap.t.list0
+0 ./diff.sh "$IPSET_TMP/.foo" portmap.t.list0
 # Range: Flush test set
 0 ipset -F test
 # Range: Delete test set
@@ -45,9 +45,9 @@
 # Full: Test value not added to the set
 1 ipset -T test 1
 # Full: List set
-0 ipset -L test > .foo
+0 ipset -L test > "$IPSET_TMP/.foo"
 # Full: Check listing
-0 ./diff.sh .foo portmap.t.list1
+0 ./diff.sh "$IPSET_TMP/.foo" portmap.t.list1
 # Full: Flush test set
 0 ipset -F test
 # Full: Delete test set
@@ -69,15 +69,15 @@
 # Full: Delete the same element
 0 ipset -D test 567
 # Full: List set
-0 ipset -L test > .foo
+0 ipset -L test > "$IPSET_TMP/.foo"
 # Full: Check listing
-0 ./diff.sh .foo portmap.t.list3
+0 ./diff.sh "$IPSET_TMP/.foo" portmap.t.list3
 # Full: sleep 5s so that elements can timeout
 0 sleep 5
 # Full: List set
-0 ipset -L test > .foo
+0 ipset -L test > "$IPSET_TMP/.foo"
 # Full: Check listing
-# 0 ./diff.sh .foo portmap.t.list2
+# 0 ./diff.sh "$IPSET_TMP/.foo" portmap.t.list2
 # Full: Flush test set
 0 ipset -F test
 # Full: add element with 1s timeout
diff --git a/tests/restore.t b/tests/restore.t
index dda143f8412b..02da4465af94 100644
--- a/tests/restore.t
+++ b/tests/restore.t
@@ -1,7 +1,7 @@
 # Check multi-set restore
 0 ipset restore < restore.t.multi
 # Save sets and compare
-0 ipset save > .foo && diff restore.t.multi.saved .foo
+0 ipset save > "$IPSET_TMP/.foo" && diff restore.t.multi.saved "$IPSET_TMP/.foo"
 # Delete all sets
 0 ipset x
 # Check auto-increasing maximal number of sets
diff --git a/tests/runtest.sh b/tests/runtest.sh
index fc4fd3c13dc6..d102305fff5f 100755
--- a/tests/runtest.sh
+++ b/tests/runtest.sh
@@ -3,6 +3,7 @@
 # set -x
 
 ipset=${IPSET_BIN:-../src/ipset}
+tmpdir=""
 
 tests="init"
 tests="$tests ipmap bitmap:ip"
@@ -17,10 +18,18 @@ tests="$tests hash:net,port,net hash:net6,port,net6"
 tests="$tests hash:net,iface.t hash:mac.t"
 tests="$tests comment setlist restore"
 # tests="$tests iptree iptreemap"
+cleanup() {
+	rm -f "$tmpdir"/.foo*
+	rm -f "$tmpdir/.loglines"
+	rmdir "$tmpdir"
+}
+trap cleanup EXIT
+tmpdir=$(mktemp -t -d ipset-XXXXXXXX)
 
 # For correct sorting:
 LC_ALL=C
 export LC_ALL
+export IPSET_TMP="$tmpdir"
 
 add_tests() {
 	# inet|inet6 network
@@ -105,7 +114,7 @@ for types in $tests; do
 		;;
 	esac
 	echo -ne "$types: $what: "
-	cmd=`echo $cmd | sed "s|ipset|$ipset 2>.foo.err|"`
+	cmd=`echo $cmd | sed "s|ipset|$ipset 2>"$tmpdir"/.foo.err|"`
 	# For the case: ipset list | ... | xargs -n1 ipset
 	cmd=`echo $cmd | sed "s|ipset|$ipset|2g"`
 	eval $cmd
@@ -116,7 +125,7 @@ for types in $tests; do
 	else
 		echo "FAILED"
 		echo "Failed test: $cmd"
-		cat .foo.err
+		cat "$tmpdir"/.foo.err
 		let "failcount++"
 		break
 	fi
@@ -137,7 +146,6 @@ for x in $tests; do
 	esac
 done
 rmmod ip_set >/dev/null 2>&1
-rm -f .foo*
 if [ "$failcount" -eq 0 ]; then
 	echo "All tests are passed"
 else
diff --git a/tests/sendip.sh b/tests/sendip.sh
index 3a951f58c7ad..f80b24ab49b8 100755
--- a/tests/sendip.sh
+++ b/tests/sendip.sh
@@ -1,6 +1,6 @@
 #!/bin/bash
 
 # Save lineno for checking
-wc -l /var/log/kern.log | cut -d ' ' -f 1 > .loglines
+wc -l /var/log/kern.log | cut -d ' ' -f 1 > "$IPSET_TMP/.loglines"
 sendip "$@"
 
diff --git a/tests/setlist.t b/tests/setlist.t
index a2780d7aa825..c1f1d3b44816 100644
--- a/tests/setlist.t
+++ b/tests/setlist.t
@@ -29,7 +29,7 @@
 # Test foo,after,bar
 1 ipset -T test foo,after,bar
 # Save sets
-0 ipset -S > setlist.t.r
+0 ipset -S > "$IPSET_TMP/setlist.t.r"
 # Delete bar,before,foo
 1 ipset -D test bar,before,foo
 # Delete foo,after,bar
@@ -43,15 +43,15 @@
 # Delete all sets
 0 ipset -X
 # Restore saved sets
-0 ipset -R < setlist.t.r
+0 ipset -R < "$IPSET_TMP/setlist.t.r"
 # List set
-0 ipset -L test > .foo
+0 ipset -L test > "$IPSET_TMP/.foo"
 # Check listing
-0 ./diff.sh .foo setlist.t.list0
+0 ./diff.sh "$IPSET_TMP/.foo" setlist.t.list0
 # Flush all sets
 0 ipset -F
 # Delete all sets
-0 ipset -X && rm setlist.t.r
+0 ipset -X && rm "$IPSET_TMP/setlist.t.r"
 # Create sets a, b, c to check before/after in all combinations
 0 ipset restore < setlist.t.before
 # Add set b to test set
@@ -61,9 +61,9 @@
 # Add set a before b
 0 ipset add test a before b
 # List test set
-0 ipset list test > .foo
+0 ipset list test > "$IPSET_TMP/.foo"
 # Check listing
-0 ./diff.sh .foo setlist.t.list1
+0 ./diff.sh "$IPSET_TMP/.foo" setlist.t.list1
 # Test a set before b
 0 ipset test test a before b
 # Test c set after b
@@ -71,19 +71,19 @@
 # Delete b set before c
 0 ipset del test b before c
 # List test set
-0 ipset list test > .foo
+0 ipset list test > "$IPSET_TMP/.foo"
 # Check listing
-0 ./diff.sh .foo setlist.t.list2
+0 ./diff.sh "$IPSET_TMP/.foo" setlist.t.list2
 # Delete c set after a
 0 ipset del test c after a
 # List test set
-0 ipset list test > .foo
+0 ipset list test > "$IPSET_TMP/.foo"
 # Check listing
-0 ./diff.sh .foo setlist.t.list3
+0 ./diff.sh "$IPSET_TMP/.foo" setlist.t.list3
 # List all sets
-0 sleep .1s; ipset list > .foo
+0 sleep .1s; ipset list > "$IPSET_TMP/.foo"
 # Check listing
-0 ./diff.sh .foo setlist.t.list4
+0 ./diff.sh "$IPSET_TMP/.foo" setlist.t.list4
 # Flush sets
 0 ipset flush
 # Destroy sets
diff --git a/tests/sort.sh b/tests/sort.sh
index 904b21682706..56893ac36e1f 100755
--- a/tests/sort.sh
+++ b/tests/sort.sh
@@ -1,5 +1,5 @@
 #!/bin/sh
 
-sed '/Members:/q' $1 > .foo
-awk '/Members:/,EOF' $1 | grep -v 'Members:' | sort >> .foo
-rm -f $1
+sed '/Members:/q' "$1" > "$IPSET_TMP/.foo"
+awk '/Members:/,EOF' "$1" | grep -v 'Members:' | sort >> "$IPSET_TMP/.foo"
+rm -f "$1"
-- 
2.54.0

