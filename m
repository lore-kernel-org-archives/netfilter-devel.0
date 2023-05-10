Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20244C7EE25
	for <netfilter-devel@archiver.kernel.org>; Wed, 10 May 2023 08:41:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236264AbjEJIle (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 10 May 2023 04:41:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235606AbjEJIl2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 10 May 2023 04:41:28 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A2A471701;
        Wed, 10 May 2023 01:41:21 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 7/7] selftests: nft_flowtable.sh: check ingress/egress chain too
Date:   Wed, 10 May 2023 10:33:13 +0200
Message-Id: <20230510083313.152961-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230510083313.152961-1-pablo@netfilter.org>
References: <20230510083313.152961-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Make sure flowtable interacts correctly with ingress and egress
chains, i.e. those get handled before and after flow table respectively.

Adds three more tests:
1. repeat flowtable test, but with 'ip dscp set cs3' done in
   inet forward chain.

Expect that some packets have been mangled (before flowtable offload
became effective) while some pass without mangling (after offload
succeeds).

2. repeat flowtable test, but with 'ip dscp set cs3' done in
   veth0:ingress.

Expect that all packets pass with cs3 dscp field.

3. same as 2, but use veth1:egress.  Expect the same outcome.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 .../selftests/netfilter/nft_flowtable.sh      | 124 ++++++++++++++++++
 1 file changed, 124 insertions(+)

diff --git a/tools/testing/selftests/netfilter/nft_flowtable.sh b/tools/testing/selftests/netfilter/nft_flowtable.sh
index 51f986f19fee..a32f490f7539 100755
--- a/tools/testing/selftests/netfilter/nft_flowtable.sh
+++ b/tools/testing/selftests/netfilter/nft_flowtable.sh
@@ -188,6 +188,26 @@ if [ $? -ne 0 ]; then
 	exit $ksft_skip
 fi
 
+ip netns exec $ns2 nft -f - <<EOF
+table inet filter {
+   counter ip4dscp0 { }
+   counter ip4dscp3 { }
+
+   chain input {
+      type filter hook input priority 0; policy accept;
+      meta l4proto tcp goto {
+	      ip dscp cs3 counter name ip4dscp3 accept
+	      ip dscp 0 counter name ip4dscp0 accept
+      }
+   }
+}
+EOF
+
+if [ $? -ne 0 ]; then
+	echo "SKIP: Could not load nft ruleset"
+	exit $ksft_skip
+fi
+
 # test basic connectivity
 if ! ip netns exec $ns1 ping -c 1 -q 10.0.2.99 > /dev/null; then
   echo "ERROR: $ns1 cannot reach ns2" 1>&2
@@ -255,6 +275,60 @@ check_counters()
 	fi
 }
 
+check_dscp()
+{
+	local what=$1
+	local ok=1
+
+	local counter=$(ip netns exec $ns2 nft reset counter inet filter ip4dscp3 | grep packets)
+
+	local pc4=${counter%*bytes*}
+	local pc4=${pc4#*packets}
+
+	local counter=$(ip netns exec $ns2 nft reset counter inet filter ip4dscp0 | grep packets)
+	local pc4z=${counter%*bytes*}
+	local pc4z=${pc4z#*packets}
+
+	case "$what" in
+	"dscp_none")
+		if [ $pc4 -gt 0 ] || [ $pc4z -eq 0 ]; then
+			echo "FAIL: dscp counters do not match, expected dscp3 == 0, dscp0 > 0, but got $pc4,$pc4z" 1>&2
+			ret=1
+			ok=0
+		fi
+		;;
+	"dscp_fwd")
+		if [ $pc4 -eq 0 ] || [ $pc4z -eq 0 ]; then
+			echo "FAIL: dscp counters do not match, expected dscp3 and dscp0 > 0 but got $pc4,$pc4z" 1>&2
+			ret=1
+			ok=0
+		fi
+		;;
+	"dscp_ingress")
+		if [ $pc4 -eq 0 ] || [ $pc4z -gt 0 ]; then
+			echo "FAIL: dscp counters do not match, expected dscp3 > 0, dscp0 == 0 but got $pc4,$pc4z" 1>&2
+			ret=1
+			ok=0
+		fi
+		;;
+	"dscp_egress")
+		if [ $pc4 -eq 0 ] || [ $pc4z -gt 0 ]; then
+			echo "FAIL: dscp counters do not match, expected dscp3 > 0, dscp0 == 0 but got $pc4,$pc4z" 1>&2
+			ret=1
+			ok=0
+		fi
+		;;
+	*)
+		echo "FAIL: Unknown DSCP check" 1>&2
+		ret=1
+		ok=0
+	esac
+
+	if [ $ok -eq 1 ] ;then
+		echo "PASS: $what: dscp packet counters match"
+	fi
+}
+
 check_transfer()
 {
 	in=$1
@@ -325,6 +399,51 @@ test_tcp_forwarding()
 	return $?
 }
 
+test_tcp_forwarding_set_dscp()
+{
+	check_dscp "dscp_none"
+
+ip netns exec $nsr1 nft -f - <<EOF
+table netdev dscpmangle {
+   chain setdscp0 {
+      type filter hook ingress device "veth0" priority 0; policy accept
+	ip dscp set cs3
+  }
+}
+EOF
+if [ $? -eq 0 ]; then
+	test_tcp_forwarding_ip "$1" "$2"  10.0.2.99 12345
+	check_dscp "dscp_ingress"
+
+	ip netns exec $nsr1 nft delete table netdev dscpmangle
+else
+	echo "SKIP: Could not load netdev:ingress for veth0"
+fi
+
+ip netns exec $nsr1 nft -f - <<EOF
+table netdev dscpmangle {
+   chain setdscp0 {
+      type filter hook egress device "veth1" priority 0; policy accept
+      ip dscp set cs3
+  }
+}
+EOF
+if [ $? -eq 0 ]; then
+	test_tcp_forwarding_ip "$1" "$2"  10.0.2.99 12345
+	check_dscp "dscp_egress"
+
+	ip netns exec $nsr1 nft flush table netdev dscpmangle
+else
+	echo "SKIP: Could not load netdev:egress for veth1"
+fi
+
+	# partial.  If flowtable really works, then both dscp-is-0 and dscp-is-cs3
+	# counters should have seen packets (before and after ft offload kicks in).
+	ip netns exec $nsr1 nft -a insert rule inet filter forward ip dscp set cs3
+	test_tcp_forwarding_ip "$1" "$2"  10.0.2.99 12345
+	check_dscp "dscp_fwd"
+}
+
 test_tcp_forwarding_nat()
 {
 	local lret
@@ -394,6 +513,11 @@ table ip nat {
 }
 EOF
 
+if ! test_tcp_forwarding_set_dscp $ns1 $ns2 0 ""; then
+	echo "FAIL: flow offload for ns1/ns2 with dscp update" 1>&2
+	exit 0
+fi
+
 if ! test_tcp_forwarding_nat $ns1 $ns2 0 ""; then
 	echo "FAIL: flow offload for ns1/ns2 with NAT" 1>&2
 	ip netns exec $nsr1 nft list ruleset
-- 
2.30.2

