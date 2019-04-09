Return-Path: <SRS0=jECH=SL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBD69C10F0E
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Apr 2019 12:47:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C0D5C20855
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Apr 2019 12:47:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726486AbfDIMrM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 9 Apr 2019 08:47:12 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:53016 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726352AbfDIMrM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Apr 2019 08:47:12 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1hDq9d-0001WK-EN; Tue, 09 Apr 2019 14:47:09 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Sven Auhagen <sven.auhagen@voleatech.de>
Subject: [PATCH nf] netfilter: nat: fix icmp id randomization
Date:   Tue,  9 Apr 2019 14:45:20 +0200
Message-Id: <20190409124520.10301-1-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Sven Auhagen reported that a 2nd ping request will fail if 'fully-random'
mode is used.

Reason is that if no proto information is given, min/max are both 0,
so we set the icmp id to 0 instead of chosing a random value between
0 and 65535.

Update test case as well to catch this, without fix this yields:
[..]
ERROR: cannot ping ns1 from ns2 with ip masquerade fully-random (attempt 2)
ERROR: cannot ping ns1 from ns2 with ipv6 masquerade fully-random (attempt 2)

... becaus 2nd ping clashes with existing 'id 0' icmp conntrack and gets
dropped.

Fixes: 203f2e78200c27e ("netfilter: nat: remove l4proto->unique_tuple")
Reported-by: Sven Auhagen <sven.auhagen@voleatech.de>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_nat_core.c                  | 11 ++++--
 tools/testing/selftests/netfilter/nft_nat.sh | 36 +++++++++++++++-----
 2 files changed, 35 insertions(+), 12 deletions(-)

diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index af7dc6537758..f79f77d6850b 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -415,9 +415,14 @@ static void nf_nat_l4proto_unique_tuple(struct nf_conntrack_tuple *tuple,
 	case IPPROTO_ICMPV6:
 		/* id is same for either direction... */
 		keyptr = &tuple->src.u.icmp.id;
-		min = range->min_proto.icmp.id;
-		range_size = ntohs(range->max_proto.icmp.id) -
-			     ntohs(range->min_proto.icmp.id) + 1;
+		if (!(range->flags & NF_NAT_RANGE_PROTO_SPECIFIED)) {
+			min = 0;
+			range_size = 65536;
+		} else {
+			min = range->min_proto.icmp.id;
+			range_size = ntohs(range->max_proto.icmp.id) -
+				     ntohs(range->min_proto.icmp.id) + 1;
+		}
 		goto find_free_id;
 #if IS_ENABLED(CONFIG_NF_CT_PROTO_GRE)
 	case IPPROTO_GRE:
diff --git a/tools/testing/selftests/netfilter/nft_nat.sh b/tools/testing/selftests/netfilter/nft_nat.sh
index 8ec76681605c..3194007cf8d1 100755
--- a/tools/testing/selftests/netfilter/nft_nat.sh
+++ b/tools/testing/selftests/netfilter/nft_nat.sh
@@ -321,6 +321,7 @@ EOF
 
 test_masquerade6()
 {
+	local natflags=$1
 	local lret=0
 
 	ip netns exec ns0 sysctl net.ipv6.conf.all.forwarding=1 > /dev/null
@@ -354,13 +355,13 @@ ip netns exec ns0 nft -f - <<EOF
 table ip6 nat {
 	chain postrouting {
 		type nat hook postrouting priority 0; policy accept;
-		meta oif veth0 masquerade
+		meta oif veth0 masquerade $natflags
 	}
 }
 EOF
 	ip netns exec ns2 ping -q -c 1 dead:1::99 > /dev/null # ping ns2->ns1
 	if [ $? -ne 0 ] ; then
-		echo "ERROR: cannot ping ns1 from ns2 with active ipv6 masquerading"
+		echo "ERROR: cannot ping ns1 from ns2 with active ipv6 masquerade $natflags"
 		lret=1
 	fi
 
@@ -397,19 +398,26 @@ EOF
 		fi
 	done
 
+	ip netns exec ns2 ping -q -c 1 dead:1::99 > /dev/null # ping ns2->ns1
+	if [ $? -ne 0 ] ; then
+		echo "ERROR: cannot ping ns1 from ns2 with active ipv6 masquerade $natflags (attempt 2)"
+		lret=1
+	fi
+
 	ip netns exec ns0 nft flush chain ip6 nat postrouting
 	if [ $? -ne 0 ]; then
 		echo "ERROR: Could not flush ip6 nat postrouting" 1>&2
 		lret=1
 	fi
 
-	test $lret -eq 0 && echo "PASS: IPv6 masquerade for ns2"
+	test $lret -eq 0 && echo "PASS: IPv6 masquerade $natflags for ns2"
 
 	return $lret
 }
 
 test_masquerade()
 {
+	local natflags=$1
 	local lret=0
 
 	ip netns exec ns0 sysctl net.ipv4.conf.veth0.forwarding=1 > /dev/null
@@ -417,7 +425,7 @@ test_masquerade()
 
 	ip netns exec ns2 ping -q -c 1 10.0.1.99 > /dev/null # ping ns2->ns1
 	if [ $? -ne 0 ] ; then
-		echo "ERROR: canot ping ns1 from ns2"
+		echo "ERROR: cannot ping ns1 from ns2 $natflags"
 		lret=1
 	fi
 
@@ -443,13 +451,13 @@ ip netns exec ns0 nft -f - <<EOF
 table ip nat {
 	chain postrouting {
 		type nat hook postrouting priority 0; policy accept;
-		meta oif veth0 masquerade
+		meta oif veth0 masquerade $natflags
 	}
 }
 EOF
 	ip netns exec ns2 ping -q -c 1 10.0.1.99 > /dev/null # ping ns2->ns1
 	if [ $? -ne 0 ] ; then
-		echo "ERROR: cannot ping ns1 from ns2 with active ip masquerading"
+		echo "ERROR: cannot ping ns1 from ns2 with active ip masquere $natflags"
 		lret=1
 	fi
 
@@ -485,13 +493,19 @@ EOF
 		fi
 	done
 
+	ip netns exec ns2 ping -q -c 1 10.0.1.99 > /dev/null # ping ns2->ns1
+	if [ $? -ne 0 ] ; then
+		echo "ERROR: cannot ping ns1 from ns2 with active ip masquerade $natflags (attempt 2)"
+		lret=1
+	fi
+
 	ip netns exec ns0 nft flush chain ip nat postrouting
 	if [ $? -ne 0 ]; then
 		echo "ERROR: Could not flush nat postrouting" 1>&2
 		lret=1
 	fi
 
-	test $lret -eq 0 && echo "PASS: IP masquerade for ns2"
+	test $lret -eq 0 && echo "PASS: IP masquerade $natflags for ns2"
 
 	return $lret
 }
@@ -750,8 +764,12 @@ test_local_dnat
 test_local_dnat6
 
 reset_counters
-test_masquerade
-test_masquerade6
+test_masquerade ""
+test_masquerade6 ""
+
+reset_counters
+test_masquerade "fully-random"
+test_masquerade6 "fully-random"
 
 reset_counters
 test_redirect
-- 
2.21.0

