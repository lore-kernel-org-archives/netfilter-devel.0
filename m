Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26A3CC433FE
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 Apr 2022 18:35:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237001AbiD2Si7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 29 Apr 2022 14:38:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231183AbiD2Si6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 29 Apr 2022 14:38:58 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 460398BE0F
        for <netfilter-devel@vger.kernel.org>; Fri, 29 Apr 2022 11:35:39 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1nkVSr-0001tg-Q8; Fri, 29 Apr 2022 20:35:37 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 3/3] sets_with_ifnames: add test case for concatenated range
Date:   Fri, 29 Apr 2022 20:32:39 +0200
Message-Id: <20220429183239.5569-4-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220429183239.5569-1-fw@strlen.de>
References: <20220429183239.5569-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Refactor existing test case for simple interace name ranges
(without concatenations) to also cover "addr . ifname".

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../sets/dumps/sets_with_ifnames.nft          | 25 ++++-
 tests/shell/testcases/sets/sets_with_ifnames  | 93 ++++++++++++++-----
 2 files changed, 94 insertions(+), 24 deletions(-)

diff --git a/tests/shell/testcases/sets/dumps/sets_with_ifnames.nft b/tests/shell/testcases/sets/dumps/sets_with_ifnames.nft
index 12c1aa960a66..6b073ae2d090 100644
--- a/tests/shell/testcases/sets/dumps/sets_with_ifnames.nft
+++ b/tests/shell/testcases/sets/dumps/sets_with_ifnames.nft
@@ -14,6 +14,21 @@ table inet testifsets {
 			     "ppp0" }
 	}
 
+	set concat {
+		type ipv4_addr . ifname
+		elements = { 10.1.2.2 . "abcdef0",
+			     10.1.2.2 . "abcdef1" }
+	}
+
+	set concat_wild {
+		type ipv4_addr . ifname
+		flags interval
+		elements = { 10.1.2.2 . "abcdef*",
+			     10.1.2.1 . "bar",
+			     1.1.2.0/24 . "abcdef0",
+			     12.2.2.0/24 . "abcdef*" }
+	}
+
 	chain v4icmp {
 		iifname @simple counter packets 0 bytes 0
 		iifname @simple_wild counter packets 0 bytes 0
@@ -21,8 +36,16 @@ table inet testifsets {
 		iifname { "abcdef*", "eth0" } counter packets 0 bytes 0
 	}
 
+	chain v4icmpc {
+		ip saddr . iifname @concat counter packets 0 bytes 0
+		ip saddr . iifname @concat_wild counter packets 0 bytes 0
+		ip saddr . iifname { 10.1.2.2 . "abcdef0" } counter packets 0 bytes 0
+		ip saddr . iifname { 10.1.2.2 . "abcdef*" } counter packets 0 bytes 0
+	}
+
 	chain input {
 		type filter hook input priority filter; policy accept;
-		ip protocol icmp goto v4icmp
+		ip protocol icmp jump v4icmp
+		ip protocol icmp goto v4icmpc
 	}
 }
diff --git a/tests/shell/testcases/sets/sets_with_ifnames b/tests/shell/testcases/sets/sets_with_ifnames
index 10e6c331bdca..f4ef4db59f51 100755
--- a/tests/shell/testcases/sets/sets_with_ifnames
+++ b/tests/shell/testcases/sets/sets_with_ifnames
@@ -17,28 +17,58 @@ cleanup()
 
 trap cleanup EXIT
 
-check_elem()
+# check a given element is (not) present in the set.
+lookup_elem()
 {
-	setname=$1
-	ifname=$2
-	fail=$3
-	result=$4
+	local setname=$1
+	local value=$2
+	local fail=$3
+	local expect_result=$4
+	local msg=$5
+
+	result=$(ip netns exec "$ns1" $NFT get element inet testifsets $setname { "$value" } 2>/dev/null | grep "$expect_result" )
 
-	if [ -z "$result" ]; then
-		result=$ifname
+	if [ -z "$result" ] && [ $fail -ne 1 ] ; then
+		echo "empty result, expected $expect_result $msg"
+		ip netns exec "$ns1" $NFT get element inet testifsets $setname { "$value" }
+		exit 1
 	fi
+}
 
-	if [ $fail -eq 1 ]; then
-		ip netns exec "$ns1" $NFT get element inet testifsets $setname { "$ifname" } && exit 2
-	else
-		result=$(ip netns exec "$ns1" $NFT get element inet testifsets $setname { "$ifname" } | grep "$result" )
+check_elem_get()
+{
+	local setname=$1
+	local value=$2
+	local fail=$3
+	local expect_result=$4
+
+	# when query is 'abcde', and set has 'abc*', result is
+	# 'abc*', not 'abcde', so returned element can be different.
+	if [ -z "$expect_result" ]; then
+		expect_result=$ifname
+	fi
 
-		if [ -z "$result" ] ; then
-			echo "empty result, expected $ifname"
-			ip netns exec "$ns1" $NFT get element inet testifsets $setname { "$ifname" }
-			exit 1
-		fi
+	lookup_elem "$setname" "$value" "$fail" "$expect_result" ""
+}
+
+# same, but also delete and re-add the element.
+check_elem()
+{
+	local setname=$1
+	local value=$2
+
+	lookup_elem "$setname" "$value" "0" "$value" "initial check"
+
+	ip netns exec "$ns1" $NFT delete element inet testifsets $setname { "$value" }
+	if [ $? -ne 0 ]; then
+		ip netns exec "$ns1" $NFT list ruleset
+		echo "delete element $setname { $value } failed"
+		exit 1
 	fi
+
+	ip netns exec "$ns1" $NFT add element inet testifsets $setname { "$value" }
+
+	lookup_elem "$setname" "$value" "0" "$value" "check after add/del"
 }
 
 # send pings, check all rules with sets that contain abcdef1 match.
@@ -56,8 +86,18 @@ check_matching_icmp_ppp()
 	want=3
 
 	if [ "$matches" -ne $want ] ;then
-		echo "Excpected $matches matching rules, got $want, packets $pkt"
 		ip netns exec "$ns1" $NFT list ruleset
+		echo "Expected $want matching rules, got $matches, packets $pkt in v4icmp"
+		exit 1
+	fi
+
+	# same, for concat set type.
+
+	matches=$(ip netns exec "$ns1" $NFT list chain inet testifsets v4icmpc | grep "counter packets $pkt " | wc -l)
+
+	if [ "$matches" -ne $want ] ;then
+		ip netns exec "$ns1" $NFT list ruleset
+		echo "Expected $want matching rules, got $matches, packets $pkt in v4icmpc"
 		exit 1
 	fi
 }
@@ -67,18 +107,25 @@ ip netns add "$ns2" || exit 111
 ip netns exec "$ns1" $NFT -f "$dumpfile" || exit 3
 
 for n in abcdef0 abcdef1 othername;do
-	check_elem simple $n 0
+	check_elem simple $n
 done
 
-check_elem simple foo 1
+check_elem_get simple foo 1
 
 for n in ppp0 othername;do
-	check_elem simple_wild $n 0
+	check_elem simple_wild $n
 done
 
-check_elem simple_wild enoent 1
-check_elem simple_wild ppp0 0
-check_elem simple_wild abcdefghijk 0 'abcdef\*'
+check_elem_get simple_wild enoent 1
+check_elem simple_wild ppp0
+check_elem_get simple_wild abcdefghijk 0 'abcdef\*'
+
+check_elem_get concat '1.2.3.4 . "enoent"' 1
+check_elem_get concat '10.1.2.2 . "abcdef"' 1
+check_elem_get concat '10.1.2.1 . "abcdef1"' 1
+
+check_elem concat '10.1.2.2 . "abcdef0"'
+check_elem concat '10.1.2.2 . "abcdef1"'
 
 set -e
 ip -net "$ns1" link set lo up
-- 
2.35.1

