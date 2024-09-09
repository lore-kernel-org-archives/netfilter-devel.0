Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F9541B6555
	for <netfilter-devel@vger.kernel.org>; Mon,  9 Sep 2024 13:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725887634; cv=none; b=BnyDUP62BwOcUoCtsZAccnZ2MIHrWwhTDYSjgnShAlgDziGLn+gYv0c7P31/HKfUN7DGc1l3y0YZ7Z7dz4GxXoVPr7MmEdqUXOS8/5KFIMbhaRaJ0KucFJ75CLU9MXvyeoCjPiFFVobZ5ox3v4nPcGFPkk22dv68sNrwVz+f3xI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725887634; c=relaxed/simple;
	bh=vOG3ZenCQ6dUCuzRbTHPGMKYTtzqzlsNUnq95j0I3c4=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ELI2y6njQQlxbsvwSdOIuroY30Mn5Oa/CABWLXIHYF1Ye407NR+vHVINlr5Ig81OSKd7J5VjPlD6MksZwVjQJDRUmjmv9tOAdH181QaLj43nRRCrehiWCjHZB9px2FHEBabx67MtKz0AYmupVn3Xypnah29Ri+wL5MvgS8+rZ6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 2/2] proto: use NFT_PAYLOAD_L4CSUM_PSEUDOHDR flag to mangle UDP checksum
Date: Mon,  9 Sep 2024 15:13:39 +0200
Message-Id: <20240909131339.290879-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240909131339.290879-1-pablo@netfilter.org>
References: <20240909131339.290879-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There are two mechanisms to update the UDP checksum field:

 1) _CSUM_TYPE and _CSUM_OFFSET, which specifies the type of checksum
    (e.g. inet) and offset where it is located.
 2) use NFT_PAYLOAD_L4CSUM_PSEUDOHDR flag to use layer 4 kernel
    protocol parser.

The problem with 1) is that it is inconditional, that is, csum_type and
csum_offset cannot deal with zero UDP checksum.

Use NFT_PAYLOAD_L4CSUM_PSEUDOHDR flag instead relies on the layer 4
kernel parser which skips updating zero UDP checksum.

Extend test coverage for the UDP mangling with and without zero
checksum.

Fixes: e6c9174e13b2 ("proto: add checksum key information to struct proto_desc")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/netlink_linearize.c                  |   2 +
 src/proto.c                              |   2 -
 tests/shell/testcases/packetpath/payload | 129 +++++++++++++++++------
 3 files changed, 99 insertions(+), 34 deletions(-)

diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index abda903bc59c..77bc51493293 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -1117,6 +1117,8 @@ static void netlink_gen_payload_stmt(struct netlink_linearize_ctx *ctx,
 	}
 	if ((expr->payload.base == PROTO_BASE_NETWORK_HDR && desc &&
 	     payload_needs_l4csum_update_pseudohdr(expr, desc)) ||
+	    (expr->payload.base == PROTO_BASE_TRANSPORT_HDR && desc &&
+	     desc == &proto_udp) ||
 	    expr->payload.base == PROTO_BASE_INNER_HDR)
 		nftnl_expr_set_u32(nle, NFTNL_EXPR_PAYLOAD_FLAGS,
 				   NFT_PAYLOAD_L4CSUM_PSEUDOHDR);
diff --git a/src/proto.c b/src/proto.c
index 553b6a447a7e..05ddb070662b 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -535,8 +535,6 @@ const struct proto_desc proto_udp = {
 	.name		= "udp",
 	.id		= PROTO_DESC_UDP,
 	.base		= PROTO_BASE_TRANSPORT_HDR,
-	.checksum_key	= UDPHDR_CHECKSUM,
-	.checksum_type  = NFT_PAYLOAD_CSUM_INET,
 	.templates	= {
 		[UDPHDR_SPORT]		= INET_SERVICE("sport", struct udphdr, source),
 		[UDPHDR_DPORT]		= INET_SERVICE("dport", struct udphdr, dest),
diff --git a/tests/shell/testcases/packetpath/payload b/tests/shell/testcases/packetpath/payload
index 1fb86aa94b17..83e0b7fc647a 100755
--- a/tests/shell/testcases/packetpath/payload
+++ b/tests/shell/testcases/packetpath/payload
@@ -19,6 +19,28 @@ run_test()
 	ns1_addr=$2
 	ns2_addr=$3
 	cidr=$4
+	mode=$5
+
+	case $mode in
+	"udp")
+		l4proto="udp"
+		udp_checksum="udp checksum != 0"
+		udp_zero_checksum=""
+		;;
+	"udp-zero-checksum")
+		l4proto="udp"
+		udp_checksum="udp checksum 0"
+		udp_zero_checksum="udp checksum set 0"
+		;;
+	"tcp")
+		l4proto="tcp"
+		udp_checksum=""
+		udp_zero_checksum=""
+		;;
+	*)
+		echo "unexpected, incorrect mode"
+		exit 0
+	esac
 
 	# socat needs square brackets, ie. [abcd::2]
 	if [ $1 -eq 6 ]; then
@@ -54,16 +76,18 @@ RULESET="table netdev payload_netdev {
 
        chain ingress {
                type filter hook ingress device veth0 priority 0;
-               tcp dport 7777 counter name ingress
-               tcp dport 7778 tcp dport set 7779 counter name mangle_ingress
-               tcp dport 7779 counter name mangle_ingress_match
+               $udp_zero_checksum
+               $l4proto dport 7777 counter name ingress
+               $l4proto dport 7778 $l4proto dport set 7779 $udp_checksum counter name mangle_ingress
+               $l4proto dport 7779 counter name mangle_ingress_match
        }
 
        chain egress {
                type filter hook egress device veth0 priority 0;
-               tcp dport 8887 counter name egress
-               tcp dport 8888 tcp dport set 8889 counter name mangle_egress
-               tcp dport 8889 counter name mangle_egress_match
+               $udp_zero_checksum
+               $l4proto dport 8887 counter name egress
+               $l4proto dport 8888 $l4proto dport set 8889 $udp_checksum counter name mangle_egress
+               $l4proto dport 8889 counter name mangle_egress_match
        }
 }
 
@@ -77,32 +101,51 @@ table inet payload_inet {
 
        chain in {
                type filter hook input priority 0;
-               tcp dport 7770 counter name input
-               tcp dport 7771 tcp dport set 7772 counter name mangle_input
-               tcp dport 7772 counter name mangle_input_match
+               $udp_zero_checksum
+               $l4proto dport 7770 counter name input
+               $l4proto dport 7771 $l4proto dport set 7772 $udp_checksum counter name mangle_input
+               $l4proto dport 7772 counter name mangle_input_match
        }
 
        chain out {
                type filter hook output priority 0;
-               tcp dport 8880 counter name output
-               tcp dport 8881 tcp dport set 8882 counter name mangle_output
-               tcp dport 8882 counter name mangle_output_match
+               $udp_zero_checksum
+               $l4proto dport 8880 counter name output
+               $l4proto dport 8881 $l4proto dport set 8882 $udp_checksum counter name mangle_output
+               $l4proto dport 8882 counter name mangle_output_match
         }
 }"
 
 	ip netns exec "$ns1" $NFT -f - <<< "$RULESET" || exit 1
 
-	ip netns exec "$ns1" socat -u STDIN TCP:$nsx2_addr:8887,connect-timeout=4 < /dev/null > /dev/null
-	ip netns exec "$ns1" socat -u STDIN TCP:$nsx2_addr:8888,connect-timeout=4 < /dev/null > /dev/null
+	case $l4proto in
+	"tcp")
+		ip netns exec "$ns1" socat -u STDIN TCP:$nsx2_addr:8887,connect-timeout=4 < /dev/null > /dev/null
+		ip netns exec "$ns1" socat -u STDIN TCP:$nsx2_addr:8888,connect-timeout=4 < /dev/null > /dev/null
 
-	ip netns exec "$ns1" socat -u STDIN TCP:$nsx2_addr:8880,connect-timeout=4 < /dev/null > /dev/null
-	ip netns exec "$ns1" socat -u STDIN TCP:$nsx2_addr:8881,connect-timeout=4 < /dev/null > /dev/null
+		ip netns exec "$ns1" socat -u STDIN TCP:$nsx2_addr:8880,connect-timeout=4 < /dev/null > /dev/null
+		ip netns exec "$ns1" socat -u STDIN TCP:$nsx2_addr:8881,connect-timeout=4 < /dev/null > /dev/null
 
-	ip netns exec "$ns2" socat -u STDIN TCP:$nsx1_addr:7777,connect-timeout=4 < /dev/null > /dev/null
-	ip netns exec "$ns2" socat -u STDIN TCP:$nsx1_addr:7778,connect-timeout=4 < /dev/null > /dev/null
+		ip netns exec "$ns2" socat -u STDIN TCP:$nsx1_addr:7777,connect-timeout=4 < /dev/null > /dev/null
+		ip netns exec "$ns2" socat -u STDIN TCP:$nsx1_addr:7778,connect-timeout=4 < /dev/null > /dev/null
 
-	ip netns exec "$ns2" socat -u STDIN TCP:$nsx1_addr:7770,connect-timeout=4 < /dev/null > /dev/null
-	ip netns exec "$ns2" socat -u STDIN TCP:$nsx1_addr:7771,connect-timeout=4 < /dev/null > /dev/null
+		ip netns exec "$ns2" socat -u STDIN TCP:$nsx1_addr:7770,connect-timeout=4 < /dev/null > /dev/null
+		ip netns exec "$ns2" socat -u STDIN TCP:$nsx1_addr:7771,connect-timeout=4 < /dev/null > /dev/null
+		;;
+	"udp")
+		ip netns exec "$ns1" bash -c "echo 'AA' | socat -u STDIN UDP:$nsx2_addr:8887 > /dev/null"
+		ip netns exec "$ns1" bash -c "echo 'AA' | socat -u STDIN UDP:$nsx2_addr:8888 > /dev/null"
+
+		ip netns exec "$ns1" bash -c "echo 'AA' | socat -u STDIN UDP:$nsx2_addr:8880 > /dev/null"
+		ip netns exec "$ns1" bash -c "echo 'AA' | socat -u STDIN UDP:$nsx2_addr:8881 > /dev/null"
+
+		ip netns exec "$ns2" bash -c "echo 'AA' | socat -u STDIN UDP:$nsx1_addr:7777 > /dev/null"
+		ip netns exec "$ns2" bash -c "echo 'AA' | socat -u STDIN UDP:$nsx1_addr:7778 > /dev/null"
+
+		ip netns exec "$ns2" bash -c "echo 'AA' | socat -u STDIN UDP:$nsx1_addr:7770 > /dev/null"
+		ip netns exec "$ns2" bash -c "echo 'AA' | socat -u STDIN UDP:$nsx1_addr:7771 > /dev/null"
+		;;
+	esac
 
 	ip netns exec "$ns1" $NFT list ruleset
 
@@ -149,26 +192,39 @@ RULESET="table bridge payload_bridge {
 
        chain in {
                type filter hook input priority 0;
-               tcp dport 7770 counter name input
-               tcp dport 7771 tcp dport set 7772 counter name mangle_input
-               tcp dport 7772 counter name mangle_input_match
+               $udp_zero_checksum
+               $l4proto dport 7770 counter name input
+               $l4proto dport 7771 $l4proto dport set 7772 $udp_checksum counter name mangle_input
+               $l4proto dport 7772 counter name mangle_input_match
        }
 
        chain out {
                type filter hook output priority 0;
-               tcp dport 8880 counter name output
-               tcp dport 8881 tcp dport set 8882 counter name mangle_output
-               tcp dport 8882 counter name mangle_output_match
+               $udp_zero_checksum
+               $l4proto dport 8880 counter name output
+               $l4proto dport 8881 $l4proto dport set 8882 $udp_checksum counter name mangle_output
+               $l4proto dport 8882 counter name mangle_output_match
         }
 }"
 
 	ip netns exec "$ns1" $NFT -f - <<< "$RULESET" || exit 1
 
-	ip netns exec "$ns1" socat -u STDIN TCP:$nsx2_addr:8880,connect-timeout=4 < /dev/null > /dev/null
-	ip netns exec "$ns1" socat -u STDIN TCP:$nsx2_addr:8881,connect-timeout=4 < /dev/null > /dev/null
+	case $l4proto in
+	"tcp")
+		ip netns exec "$ns1" socat -u STDIN TCP:$nsx2_addr:8880,connect-timeout=4 < /dev/null > /dev/null
+		ip netns exec "$ns1" socat -u STDIN TCP:$nsx2_addr:8881,connect-timeout=4 < /dev/null > /dev/null
+
+		ip netns exec "$ns2" socat -u STDIN TCP:$nsx1_addr:7770,connect-timeout=4 < /dev/null > /dev/null
+		ip netns exec "$ns2" socat -u STDIN TCP:$nsx1_addr:7771,connect-timeout=4 < /dev/null > /dev/null
+		;;
+	"udp")
+		ip netns exec "$ns1" bash -c "echo 'AA' | socat -u STDIN UDP:$nsx2_addr:8880 > /dev/null"
+		ip netns exec "$ns1" bash -c "echo 'AA' | socat -u STDIN UDP:$nsx2_addr:8881 > /dev/null"
 
-	ip netns exec "$ns2" socat -u STDIN TCP:$nsx1_addr:7770,connect-timeout=4 < /dev/null > /dev/null
-	ip netns exec "$ns2" socat -u STDIN TCP:$nsx1_addr:7771,connect-timeout=4 < /dev/null > /dev/null
+		ip netns exec "$ns2" bash -c "echo 'AA' | socat -u STDIN UDP:$nsx1_addr:7770 > /dev/null"
+		ip netns exec "$ns2" bash -c "echo 'AA' | socat -u STDIN UDP:$nsx1_addr:7771 > /dev/null"
+		;;
+	esac
 
 	ip netns exec "$ns1" $NFT list ruleset
 
@@ -180,7 +236,16 @@ RULESET="table bridge payload_bridge {
 	ip netns exec "$ns1" $NFT list counter bridge payload_bridge mangle_output_match | grep -q "packets 0" && exit 1
 }
 
-run_test "4" "10.141.10.2" "10.141.10.3" "24"
+run_test "4" "10.141.10.2" "10.141.10.3" "24" "tcp"
+cleanup
+run_test 6 "abcd::2" "abcd::3" "64" "tcp"
+cleanup
+run_test "4" "10.141.10.2" "10.141.10.3" "24" "udp"
+cleanup
+run_test 6 "abcd::2" "abcd::3" "64" "udp"
+cleanup
+run_test "4" "10.141.10.2" "10.141.10.3" "24" "udp-zero-checksum"
 cleanup
-run_test 6 "abcd::2" "abcd::3" "64"
+run_test 6 "abcd::2" "abcd::3" "64" "udp-zero-checksum"
 # trap calls cleanup
+exit 0
-- 
2.30.2

