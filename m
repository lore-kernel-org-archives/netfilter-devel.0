Return-Path: <SRS0=34lc=R6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDA45C43381
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Mar 2019 08:20:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 867452075D
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Mar 2019 08:20:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732485AbfC0IUw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Mar 2019 04:20:52 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:38848 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725827AbfC0IUw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Mar 2019 04:20:52 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1h93nk-0002by-QD; Wed, 27 Mar 2019 09:20:48 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 6/6] kselftests: extend nft_nat with inet family based nat hooks
Date:   Wed, 27 Mar 2019 09:22:29 +0100
Message-Id: <20190327082229.29399-7-fw@strlen.de>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190327082229.29399-1-fw@strlen.de>
References: <20190327082229.29399-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

With older nft versions, this will cause:
[..]
PASS: ipv6 ping to ns1 was ip6 NATted to ns2
/dev/stdin:4:30-31: Error: syntax error, unexpected to, expecting newline or semicolon
                ip daddr 10.0.1.99 dnat ip to 10.0.2.99
                                           ^^
SKIP: inet nat tests
PASS: ip IP masquerade for ns2
[..]

as there is currently no way to detect if nft will be able to parse
the inet format.

redirect and masquerade tests need to be skipped in this case for inet
too because nft userspace has overzealous family check and rejects their
use in the inet family.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tools/testing/selftests/netfilter/nft_nat.sh | 130 ++++++++++++++-----
 1 file changed, 94 insertions(+), 36 deletions(-)

diff --git a/tools/testing/selftests/netfilter/nft_nat.sh b/tools/testing/selftests/netfilter/nft_nat.sh
index 8ec76681605c..248905130d5d 100755
--- a/tools/testing/selftests/netfilter/nft_nat.sh
+++ b/tools/testing/selftests/netfilter/nft_nat.sh
@@ -6,6 +6,7 @@
 # Kselftest framework requirement - SKIP code is 4.
 ksft_skip=4
 ret=0
+test_inet_nat=true
 
 nft --version > /dev/null 2>&1
 if [ $? -ne 0 ];then
@@ -141,17 +142,24 @@ reset_counters()
 
 test_local_dnat6()
 {
+	local family=$1
 	local lret=0
+	local IPF=""
+
+	if [ $family = "inet" ];then
+		IPF="ip6"
+	fi
+
 ip netns exec ns0 nft -f - <<EOF
-table ip6 nat {
+table $family nat {
 	chain output {
 		type nat hook output priority 0; policy accept;
-		ip6 daddr dead:1::99 dnat to dead:2::99
+		ip6 daddr dead:1::99 dnat $IPF to dead:2::99
 	}
 }
 EOF
 	if [ $? -ne 0 ]; then
-		echo "SKIP: Could not add add ip6 dnat hook"
+		echo "SKIP: Could not add add $family dnat hook"
 		return $ksft_skip
 	fi
 
@@ -201,7 +209,7 @@ EOF
 		fi
 	done
 
-	test $lret -eq 0 && echo "PASS: ipv6 ping to ns1 was NATted to ns2"
+	test $lret -eq 0 && echo "PASS: ipv6 ping to ns1 was $family NATted to ns2"
 	ip netns exec ns0 nft flush chain ip6 nat output
 
 	return $lret
@@ -209,15 +217,32 @@ EOF
 
 test_local_dnat()
 {
+	local family=$1
 	local lret=0
-ip netns exec ns0 nft -f - <<EOF
-table ip nat {
+	local IPF=""
+
+	if [ $family = "inet" ];then
+		IPF="ip"
+	fi
+
+ip netns exec ns0 nft -f - <<EOF 2>/dev/null
+table $family nat {
 	chain output {
 		type nat hook output priority 0; policy accept;
-		ip daddr 10.0.1.99 dnat to 10.0.2.99
+		ip daddr 10.0.1.99 dnat $IPF to 10.0.2.99
 	}
 }
 EOF
+	if [ $? -ne 0 ]; then
+		if [ $family = "inet" ];then
+			echo "SKIP: inet nat tests"
+			test_inet_nat=false
+			return $ksft_skip
+		fi
+		echo "SKIP: Could not add add $family dnat hook"
+		return $ksft_skip
+	fi
+
 	# ping netns1, expect rewrite to netns2
 	ip netns exec ns0 ping -q -c 1 10.0.1.99 > /dev/null
 	if [ $? -ne 0 ]; then
@@ -264,9 +289,9 @@ EOF
 		fi
 	done
 
-	test $lret -eq 0 && echo "PASS: ping to ns1 was NATted to ns2"
+	test $lret -eq 0 && echo "PASS: ping to ns1 was $family NATted to ns2"
 
-	ip netns exec ns0 nft flush chain ip nat output
+	ip netns exec ns0 nft flush chain $family nat output
 
 	reset_counters
 	ip netns exec ns0 ping -q -c 1 10.0.1.99 > /dev/null
@@ -313,7 +338,7 @@ EOF
 		fi
 	done
 
-	test $lret -eq 0 && echo "PASS: ping to ns1 OK after nat output chain flush"
+	test $lret -eq 0 && echo "PASS: ping to ns1 OK after $family nat output chain flush"
 
 	return $lret
 }
@@ -321,6 +346,7 @@ EOF
 
 test_masquerade6()
 {
+	local family=$1
 	local lret=0
 
 	ip netns exec ns0 sysctl net.ipv6.conf.all.forwarding=1 > /dev/null
@@ -351,16 +377,21 @@ test_masquerade6()
 
 # add masquerading rule
 ip netns exec ns0 nft -f - <<EOF
-table ip6 nat {
+table $family nat {
 	chain postrouting {
 		type nat hook postrouting priority 0; policy accept;
 		meta oif veth0 masquerade
 	}
 }
 EOF
+	if [ $? -ne 0 ]; then
+		echo "SKIP: Could not add add $family masquerade hook"
+		return $ksft_skip
+	fi
+
 	ip netns exec ns2 ping -q -c 1 dead:1::99 > /dev/null # ping ns2->ns1
 	if [ $? -ne 0 ] ; then
-		echo "ERROR: cannot ping ns1 from ns2 with active ipv6 masquerading"
+		echo "ERROR: cannot ping ns1 from ns2 with active $family masquerading"
 		lret=1
 	fi
 
@@ -397,19 +428,20 @@ EOF
 		fi
 	done
 
-	ip netns exec ns0 nft flush chain ip6 nat postrouting
+	ip netns exec ns0 nft flush chain $family nat postrouting
 	if [ $? -ne 0 ]; then
-		echo "ERROR: Could not flush ip6 nat postrouting" 1>&2
+		echo "ERROR: Could not flush $family nat postrouting" 1>&2
 		lret=1
 	fi
 
-	test $lret -eq 0 && echo "PASS: IPv6 masquerade for ns2"
+	test $lret -eq 0 && echo "PASS: $family IPv6 masquerade for ns2"
 
 	return $lret
 }
 
 test_masquerade()
 {
+	local family=$1
 	local lret=0
 
 	ip netns exec ns0 sysctl net.ipv4.conf.veth0.forwarding=1 > /dev/null
@@ -440,16 +472,21 @@ test_masquerade()
 
 # add masquerading rule
 ip netns exec ns0 nft -f - <<EOF
-table ip nat {
+table $family nat {
 	chain postrouting {
 		type nat hook postrouting priority 0; policy accept;
 		meta oif veth0 masquerade
 	}
 }
 EOF
+	if [ $? -ne 0 ]; then
+		echo "SKIP: Could not add add $family masquerade hook"
+		return $ksft_skip
+	fi
+
 	ip netns exec ns2 ping -q -c 1 10.0.1.99 > /dev/null # ping ns2->ns1
 	if [ $? -ne 0 ] ; then
-		echo "ERROR: cannot ping ns1 from ns2 with active ip masquerading"
+		echo "ERROR: cannot ping ns1 from ns2 with active $family masquerading"
 		lret=1
 	fi
 
@@ -485,19 +522,20 @@ EOF
 		fi
 	done
 
-	ip netns exec ns0 nft flush chain ip nat postrouting
+	ip netns exec ns0 nft flush chain $family nat postrouting
 	if [ $? -ne 0 ]; then
-		echo "ERROR: Could not flush nat postrouting" 1>&2
+		echo "ERROR: Could not flush $family nat postrouting" 1>&2
 		lret=1
 	fi
 
-	test $lret -eq 0 && echo "PASS: IP masquerade for ns2"
+	test $lret -eq 0 && echo "PASS: $family IP masquerade for ns2"
 
 	return $lret
 }
 
 test_redirect6()
 {
+	local family=$1
 	local lret=0
 
 	ip netns exec ns0 sysctl net.ipv6.conf.all.forwarding=1 > /dev/null
@@ -527,16 +565,21 @@ test_redirect6()
 
 # add redirect rule
 ip netns exec ns0 nft -f - <<EOF
-table ip6 nat {
+table $family nat {
 	chain prerouting {
 		type nat hook prerouting priority 0; policy accept;
 		meta iif veth1 meta l4proto icmpv6 ip6 saddr dead:2::99 ip6 daddr dead:1::99 redirect
 	}
 }
 EOF
+	if [ $? -ne 0 ]; then
+		echo "SKIP: Could not add add $family redirect hook"
+		return $ksft_skip
+	fi
+
 	ip netns exec ns2 ping -q -c 1 dead:1::99 > /dev/null # ping ns2->ns1
 	if [ $? -ne 0 ] ; then
-		echo "ERROR: cannot ping ns1 from ns2 with active ip6 redirect"
+		echo "ERROR: cannot ping ns1 from ns2 via ipv6 with active $family redirect"
 		lret=1
 	fi
 
@@ -560,19 +603,20 @@ EOF
 		fi
 	done
 
-	ip netns exec ns0 nft delete table ip6 nat
+	ip netns exec ns0 nft delete table $family nat
 	if [ $? -ne 0 ]; then
-		echo "ERROR: Could not delete ip6 nat table" 1>&2
+		echo "ERROR: Could not delete $family nat table" 1>&2
 		lret=1
 	fi
 
-	test $lret -eq 0 && echo "PASS: IPv6 redirection for ns2"
+	test $lret -eq 0 && echo "PASS: $family IPv6 redirection for ns2"
 
 	return $lret
 }
 
 test_redirect()
 {
+	local family=$1
 	local lret=0
 
 	ip netns exec ns0 sysctl net.ipv4.conf.veth0.forwarding=1 > /dev/null
@@ -603,16 +647,21 @@ test_redirect()
 
 # add redirect rule
 ip netns exec ns0 nft -f - <<EOF
-table ip nat {
+table $family nat {
 	chain prerouting {
 		type nat hook prerouting priority 0; policy accept;
 		meta iif veth1 ip protocol icmp ip saddr 10.0.2.99 ip daddr 10.0.1.99 redirect
 	}
 }
 EOF
+	if [ $? -ne 0 ]; then
+		echo "SKIP: Could not add add $family redirect hook"
+		return $ksft_skip
+	fi
+
 	ip netns exec ns2 ping -q -c 1 10.0.1.99 > /dev/null # ping ns2->ns1
 	if [ $? -ne 0 ] ; then
-		echo "ERROR: cannot ping ns1 from ns2 with active ip redirect"
+		echo "ERROR: cannot ping ns1 from ns2 with active $family ip redirect"
 		lret=1
 	fi
 
@@ -637,13 +686,13 @@ EOF
 		fi
 	done
 
-	ip netns exec ns0 nft delete table ip nat
+	ip netns exec ns0 nft delete table $family nat
 	if [ $? -ne 0 ]; then
-		echo "ERROR: Could not delete nat table" 1>&2
+		echo "ERROR: Could not delete $family nat table" 1>&2
 		lret=1
 	fi
 
-	test $lret -eq 0 && echo "PASS: IP redirection for ns2"
+	test $lret -eq 0 && echo "PASS: $family IP redirection for ns2"
 
 	return $lret
 }
@@ -746,16 +795,25 @@ if [ $ret -eq 0 ];then
 fi
 
 reset_counters
-test_local_dnat
-test_local_dnat6
+test_local_dnat ip
+test_local_dnat6 ip6
+reset_counters
+$test_inet_nat && test_local_dnat inet
+$test_inet_nat && test_local_dnat6 inet
 
 reset_counters
-test_masquerade
-test_masquerade6
+test_masquerade ip
+test_masquerade6 ip6
+reset_counters
+$test_inet_nat && test_masquerade inet
+$test_inet_nat && test_masquerade6 inet
 
 reset_counters
-test_redirect
-test_redirect6
+test_redirect ip
+test_redirect6 ip6
+reset_counters
+$test_inet_nat && test_redirect inet
+$test_inet_nat && test_redirect6 inet
 
 for i in 0 1 2; do ip netns del ns$i;done
 
-- 
2.19.2

