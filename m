Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=151.80.46.58
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793291835;
	b=MnVTmPqYu64oaf7sjflBvmlSuseZDD8tsCC9NgzxKo6psWYLAiRDfWi3SB2+GwOTWxAd
	 rexQhSGsZHiBi8g2DtYm/naKMcfrPE0GfUdDXcO501strnosfqWGrRtvWHs2Rl9yknRhG
	 9913uHLnArnLteETS679QfyWE2xGNi2XPXN1tDOn8Myz6jdbZUjMq8FNEDAc/uHssaZhS
	 33u6nMPP0qN3F64AL0EFsy2ZgRYiu6otOJeaImEm07iuPYtY/1uwlFTZLHPPBVT8NWfpZ
	 AzVX/XTsS7p2vg3IeiPKL9etBTQMTxs3DEyldReb0nEBmv+7AU+XpPHl4hUZ55zYyow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793291835;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=OUKxnPA8gAUJ83LY6xEH7VP060heeBafKCaN092tKak=;
	b=lPk8+lUlzDmmfxabmnLIrQ72cmcK8bwIZJFwz/su/n9erWZEtBFmTMZRJdcTSkTjglYU
	 xlh7JqXnKPpd8MwbJwRSghR1jQ06vLE6Rr6X0VsRWktzWM7naTY8ZdSkxzbdls2A91G6E
	 Od/iprTq2alGhPQayuh7DRSJlSgxrhR2XhVpqdtjbVJk4vMwgNEQKlp9R4qjdd9EtVgSe
	 6qJruHPA2n7+gyE5oshpHqdZd4u6/DJlbyt7bdu/mQwnIMmcPeevVzwoIcrPIktRvksSX
	 o/nx1VQheAV3lFN1eeDuizbnLkLjjF+vDeWogaZvFzeuku7fZvFh08JowbRM2SLCT4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=nwl.cc;
	spf=pass smtp.mailfrom=nwl.cc;
	dkim=pass header.d=nwl.cc header.i=@nwl.cc header.a=rsa-sha256 header.s=mail2022 header.b=nuxl5i9R;
	arc=none smtp.remote-ip=151.80.46.58
Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4433606A31D
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Oct 2026 16:37:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B4433606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=nwl.cc header.i=@nwl.cc header.a=rsa-sha256 header.s=mail2022 header.b=nuxl5i9R
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=OUKxnPA8gAUJ83LY6xEH7VP060heeBafKCaN092tKak=; b=nuxl5i9Rt/VXYz/OsNZopUcZ4Z
	0I/IYTl3fHkz5d5N3yj1HrLlO0ctgyz8jgd1z+2e+SQuYnedCj1lz8tOtQ1gvaD+d/Bv3Ddq+Mh5A
	16ykrCDcb2q6lB9lYMJC3F4bWFhCSaAZ8o4VImKlwhh8mON+JJhP18OBdPurJlMCSrcsPUMfX2Noq
	77dYkTyOC9Vpp7UIEy+//IIg0bAP2HkzJKqs/uRgBK+oXVVToGPKTJdZs5YyzH84lWmSsKA6zqwQS
	IaX/MuCEle0OJzjUOnhUnZyBhbCTTltNHflzVyJPFSU056tEEuRl3a2z/wMMqMhLdHpgv8WBeFNv8
	D3X17c8A==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1xMT7o-000000001oG-00Vn
	for netfilter-devel@vger.kernel.org;
	Thu, 29 Oct 2026 17:37:12 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 2/2] tests: shell: Really stabilize packetpath/payload
Date: Thu, 29 Oct 2026 17:37:06 +0100
Message-ID: <20261029163706.3243948-2-phil@nwl.cc>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261029163706.3243948-1-phil@nwl.cc>
References: <20261029163706.3243948-1-phil@nwl.cc>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The test occasionally fails here with zero packets in output counters
when testing bridge family. While it's not entirely clear why it
happens, racing with bridge forward delay and IPv6 duplicate address
detection seem to be a good guess.

With both deactivated, the test passes reliably even with the 3s sleep
removed and TCP connect timeout minimized (all we need for the test is
one ping^Wsyn only).

Fixes: a1365628eaa73 ("tests: shell: stabilize packetpath/payload")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/shell/testcases/packetpath/payload | 38 +++++++++++-------------
 1 file changed, 18 insertions(+), 20 deletions(-)

diff --git a/tests/shell/testcases/packetpath/payload b/tests/shell/testcases/packetpath/payload
index 1e6b5a51969bb..7c1fd43b1a486 100755
--- a/tests/shell/testcases/packetpath/payload
+++ b/tests/shell/testcases/packetpath/payload
@@ -47,9 +47,11 @@ run_test()
 	if [ $1 -eq 6 ]; then
 		nsx1_addr="["$ns1_addr"]"
 		nsx2_addr="["$ns2_addr"]"
+		addropt="nodad"
 	else
 		nsx1_addr="$ns1_addr"
 		nsx2_addr="$ns2_addr"
+		addropt=
 	fi
 
 	ip netns add "$ns1" || exit 111
@@ -62,10 +64,8 @@ run_test()
 
 	ip -net "$ns1" link set veth0 up
 	ip -net "$ns2" link set veth0 up
-	ip -net "$ns1" addr add $ns1_addr/$cidr dev veth0
-	ip -net "$ns2" addr add $ns2_addr/$cidr dev veth0
-
-	sleep 3
+	ip -net "$ns1" addr add $ns1_addr/$cidr $addropt dev veth0
+	ip -net "$ns2" addr add $ns2_addr/$cidr $addropt dev veth0
 
 RULESET="table netdev payload_netdev {
        counter ingress {}
@@ -121,17 +121,17 @@ table inet payload_inet {
 
 	case $l4proto in
 	"tcp")
-		ip netns exec "$ns1" socat -u STDIN TCP:$nsx2_addr:8887,connect-timeout=4 < /dev/null > /dev/null
-		ip netns exec "$ns1" socat -u STDIN TCP:$nsx2_addr:8888,connect-timeout=4 < /dev/null > /dev/null
+		ip netns exec "$ns1" socat -u STDIN TCP:$nsx2_addr:8887,connect-timeout=0.1 < /dev/null > /dev/null
+		ip netns exec "$ns1" socat -u STDIN TCP:$nsx2_addr:8888,connect-timeout=0.1 < /dev/null > /dev/null
 
-		ip netns exec "$ns1" socat -u STDIN TCP:$nsx2_addr:8880,connect-timeout=4 < /dev/null > /dev/null
-		ip netns exec "$ns1" socat -u STDIN TCP:$nsx2_addr:8881,connect-timeout=4 < /dev/null > /dev/null
+		ip netns exec "$ns1" socat -u STDIN TCP:$nsx2_addr:8880,connect-timeout=0.1 < /dev/null > /dev/null
+		ip netns exec "$ns1" socat -u STDIN TCP:$nsx2_addr:8881,connect-timeout=0.1 < /dev/null > /dev/null
 
-		ip netns exec "$ns2" socat -u STDIN TCP:$nsx1_addr:7777,connect-timeout=4 < /dev/null > /dev/null
-		ip netns exec "$ns2" socat -u STDIN TCP:$nsx1_addr:7778,connect-timeout=4 < /dev/null > /dev/null
+		ip netns exec "$ns2" socat -u STDIN TCP:$nsx1_addr:7777,connect-timeout=0.1 < /dev/null > /dev/null
+		ip netns exec "$ns2" socat -u STDIN TCP:$nsx1_addr:7778,connect-timeout=0.1 < /dev/null > /dev/null
 
-		ip netns exec "$ns2" socat -u STDIN TCP:$nsx1_addr:7770,connect-timeout=4 < /dev/null > /dev/null
-		ip netns exec "$ns2" socat -u STDIN TCP:$nsx1_addr:7771,connect-timeout=4 < /dev/null > /dev/null
+		ip netns exec "$ns2" socat -u STDIN TCP:$nsx1_addr:7770,connect-timeout=0.1 < /dev/null > /dev/null
+		ip netns exec "$ns2" socat -u STDIN TCP:$nsx1_addr:7771,connect-timeout=0.1 < /dev/null > /dev/null
 		;;
 	"udp")
 		ip netns exec "$ns1" bash -c "echo 'AA' | socat -u STDIN UDP:$nsx2_addr:8887 > /dev/null"
@@ -176,13 +176,11 @@ table inet payload_inet {
 
 	ip -net "$ns1" addr del $ns1_addr/$cidr dev veth0
 
-	ip -net "$ns1" link add name br0 type bridge
+	ip -net "$ns1" link add name br0 type bridge forward_delay 0 stp_state 0
 	ip -net "$ns1" link set veth0 master br0
-	ip -net "$ns1" addr add $ns1_addr/$cidr dev br0
+	ip -net "$ns1" addr add $ns1_addr/$cidr $addropt dev br0
 	ip -net "$ns1" link set up dev br0
 
-	sleep 3
-
 RULESET="table bridge payload_bridge {
        counter input {}
        counter output {}
@@ -212,11 +210,11 @@ RULESET="table bridge payload_bridge {
 
 	case $l4proto in
 	"tcp")
-		ip netns exec "$ns1" socat -u STDIN TCP:$nsx2_addr:8880,connect-timeout=4 < /dev/null > /dev/null
-		ip netns exec "$ns1" socat -u STDIN TCP:$nsx2_addr:8881,connect-timeout=4 < /dev/null > /dev/null
+		ip netns exec "$ns1" socat -u STDIN TCP:$nsx2_addr:8880,connect-timeout=0.1 < /dev/null > /dev/null
+		ip netns exec "$ns1" socat -u STDIN TCP:$nsx2_addr:8881,connect-timeout=0.1 < /dev/null > /dev/null
 
-		ip netns exec "$ns2" socat -u STDIN TCP:$nsx1_addr:7770,connect-timeout=4 < /dev/null > /dev/null
-		ip netns exec "$ns2" socat -u STDIN TCP:$nsx1_addr:7771,connect-timeout=4 < /dev/null > /dev/null
+		ip netns exec "$ns2" socat -u STDIN TCP:$nsx1_addr:7770,connect-timeout=0.1 < /dev/null > /dev/null
+		ip netns exec "$ns2" socat -u STDIN TCP:$nsx1_addr:7771,connect-timeout=0.1 < /dev/null > /dev/null
 		;;
 	"udp")
 		ip netns exec "$ns1" bash -c "echo 'AA' | socat -u STDIN UDP:$nsx2_addr:8880 > /dev/null"
-- 
2.54.0

