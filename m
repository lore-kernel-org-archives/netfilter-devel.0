Return-Path: <SRS0=3cJm=SY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CC59C282E1
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Apr 2019 20:48:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6FD70206A3
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Apr 2019 20:48:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731014AbfDVUsW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 22 Apr 2019 16:48:22 -0400
Received: from mail.us.es ([193.147.175.20]:46726 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730721AbfDVUsN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Apr 2019 16:48:13 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7DEC7443821
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Apr 2019 22:48:11 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6AF83DA708
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Apr 2019 22:48:11 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 60AF5DA703; Mon, 22 Apr 2019 22:48:11 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3CC20DA706;
        Mon, 22 Apr 2019 22:48:09 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 22 Apr 2019 22:48:09 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 121A54265A32;
        Mon, 22 Apr 2019 22:48:09 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 07/10] netfilter: nat: fix icmp id randomization
Date:   Mon, 22 Apr 2019 22:47:58 +0200
Message-Id: <20190422204801.26321-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190422204801.26321-1-pablo@netfilter.org>
References: <20190422204801.26321-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

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
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_nat_core.c                  | 11 ++++++---
 tools/testing/selftests/netfilter/nft_nat.sh | 36 +++++++++++++++++++++-------
 2 files changed, 35 insertions(+), 12 deletions(-)

diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index af7dc6537758..000952719adf 100644
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
+			min = ntohs(range->min_proto.icmp.id);
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
2.11.0

