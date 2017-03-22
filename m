From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH 2/3] tests: shell: netns/0003many_0: Fix cleanup after error
Date: Wed, 22 Mar 2017 01:26:35 +0100
Message-ID: <20170322002636.14081-2-phil@nwl.cc>
References: <20170321131902.GA30047@salvia>
 <20170322002636.14081-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:53867 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758021AbdCVA1d (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Mar 2017 20:27:33 -0400
In-Reply-To: <20170322002636.14081-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If rule set applying failed, this would leave a stray netns in place.

Interestingly, this situation led to other, seemingly unrelated
testcases to fail with spurious errors, e.g. sets/0015rulesetflush_0:

| $ ./run-tests.sh testcases/sets/0015rulesetflush_0
| I: using nft binary ../../src/nft
|
| W: [FAILED]	testcases/sets/0015rulesetflush_0: expected 0 but got 1
| /tmp/tmp.BY7cuUYL8f:5:1-2: Error: Could not process rule: Operation not supported
| table inet filter {
| ^^
| /tmp/tmp.BY7cuUYL8f:9:1-2: Error: Could not process rule: No such file or directory
| add element inet filter blacklist_v4 {
| ^^
| /tmp/tmp.BY7cuUYL8f:5:1-2: Error: Could not process rule: Operation not supported
| table inet filter {
| ^^
| /tmp/tmp.BY7cuUYL8f:9:1-2: Error: Could not process rule: No such file or directory
| add element inet filter blacklist_v4 {
| ^^
|
| I: results: [OK] 0 [FAILED] 1 [TOTAL] 1
|
| $ ip netns list
| 1_0003many_0
| $ ip netns del 1_0003many_0
|
| $ ./run-tests.sh testcases/sets/0015rulesetflush_0
| I: using nft binary ../../src/nft
|
| I: [OK]		testcases/sets/0015rulesetflush_0
|
| I: results: [OK] 1 [FAILED] 0 [TOTAL] 1

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/shell/testcases/netns/0003many_0 | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tests/shell/testcases/netns/0003many_0 b/tests/shell/testcases/netns/0003many_0
index f8853ee5a98c2..17d7b93588f34 100755
--- a/tests/shell/testcases/netns/0003many_0
+++ b/tests/shell/testcases/netns/0003many_0
@@ -109,6 +109,7 @@ function test_netns()
 		echo "E: ruleset in netns $NETNS_NAME differs from the loaded" >&2
 	        DIFF="$(which diff)"
 	        [ -x $DIFF ] && $DIFF -u <(echo "$RULESET") <(echo "$KERNEL_RULESET")
+		$IP netns del $NETNS_NAME
 	        exit 1
 	fi
 
-- 
2.11.0

