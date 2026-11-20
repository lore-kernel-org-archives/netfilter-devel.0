Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=151.80.46.58
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795206288;
	b=B70xGMXyRHfYzKDlmxLslhKKS5OexaB+mKtPRsTK2StBFwRELYWdwPZr6lUOO2dEIMm/
	 OdVnOuXpQKEWanqYkwK0nD482MAgPHOTgAr3ngGQ3t9kvJVqsXha8yIXNMUnMXuv8p2ky
	 MFfv57/6fD1XVUgwC7TLlCYnoAYdJWp5Rs37NQT1idSghL0npq4QdDnRyX7B2snYm9IZl
	 zGYNRl50Pw9EHYXWKHfUNBZJJ3PrfUCA0QlRmVfd+zMKNY1OBN9CUtgsq7s+g1Hlbkvm1
	 TAcgUvsu2P9t/q5tyPtRMLQm5iThTKGsh2/vpAK3p+wJ7Fiqcj4weNZZoTgJYy3m37Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795206288;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=8pAQlwJ+4lIgmRyKaN7x+yCnTkxYkAqDPCpo/PEx3UM=;
	b=at/IINOehnkdAhDmgTsO8NB1Fhkmi9RWceD1cKph9MJrJj44loUDuLqAh0y0jBMHvZmX
	 bHvd7W04QdsXYbV0/djUpj6W4atTXEQ2lHOV0HGqP28n1zyfKMBV0RECFjsYK4YplKUh9
	 Jg7WDsJS5Z/p+NIjMcuDnSmv8CUJM8B5VA/8wo5+iCKoZAfHfRL2x4HqZjS+KZdmIDo0d
	 UiS+cfgbfNyd/LhIMtjRo51SQrWQ+nVym2QFG+3vdRaMr4acRYGEYu9N+Mxaf1uLaM+Ps
	 /cs2j/VPOnBkWEn1jVYxntgACn8MSjsF3CSXNaJQ2YnUBeqRHlrBlgvD4AFyv/DdppQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=nwl.cc;
	spf=pass smtp.mailfrom=nwl.cc;
	dkim=pass header.d=nwl.cc header.i=@nwl.cc header.a=rsa-sha256 header.s=mail2022 header.b=NLJO6kUk;
	arc=none smtp.remote-ip=151.80.46.58
Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4F0D606A6E7
	for <netfilter-devel@vger.kernel.org>; Fri, 20 Nov 2026 20:24:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D4F0D606A6E7
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=nwl.cc header.i=@nwl.cc header.a=rsa-sha256 header.s=mail2022 header.b=NLJO6kUk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=8pAQlwJ+4lIgmRyKaN7x+yCnTkxYkAqDPCpo/PEx3UM=; b=NLJO6kUkRz22pLvnkpLvgOrt0W
	uLYBi0jTLMIgWOq8t1yFEqU0CJ4b8ACyFLrK3DU4VcZaB1re0xkHZCfn1/FLUzpyn1UwtGio7icO0
	a2/eWXW7K1SUhVVS8dwGPW3uw5T/Ue5pjs7OvNhwdKSLwk3X2URhdax/3Se9odXOBT2EB6zLHYFzI
	cmbM4lgJJyKpNhCU3VGfkOm2vkfVfgV8hfW2UZ+AmPFdOKf+Z0JwVBA7o8TNxCPAQnV0HT4xUFNdn
	Rw1NQ2Qxqiw3kQBQT+GAGf4Hdjh7bngUBJoPJ5sBPjVa6O9QLtVwLcSHHWvHnfqx0PBO2WRkzZGqu
	b21bKmqA==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=tia)
	by orbyte.nwl.cc with esmtp (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1xUV9z-000000005tZ-25D2;
	Fri, 20 Nov 2026 21:24:39 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nf-next PATCH 2/2] selftests: netfilter: Add minimal VLAN test case to br_netfilter.sh
Date: Fri, 20 Nov 2026 21:24:34 +0100
Message-ID: <20261120202434.1084006-2-phil@nwl.cc>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261120202434.1084006-1-phil@nwl.cc>
References: <20261120202434.1084006-1-phil@nwl.cc>
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

Cover at least the bridge's ability to tag/untag packets and assert
oversize packets are fragmented again after being defragmented for
conntrack.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 .../selftests/net/netfilter/br_netfilter.sh   | 23 +++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/netfilter/br_netfilter.sh b/tools/testing/selftests/net/netfilter/br_netfilter.sh
index 011de8763094..e1c258b23998 100755
--- a/tools/testing/selftests/net/netfilter/br_netfilter.sh
+++ b/tools/testing/selftests/net/netfilter/br_netfilter.sh
@@ -33,9 +33,10 @@ do_ping()
 {
 	fromns="$1"
 	dstip="$2"
+	shift 2
 
-	if ! ip netns exec "$fromns" ping -c 1 -q "$dstip" > /dev/null; then
-		echo "ERROR: ping from $fromns to $dstip"
+	if ! ip netns exec "$fromns" ping -c 1 -q "$@" "$dstip" > /dev/null; then
+		echo "ERROR: ping${@:+ $@} from $fromns to $dstip"
 		ip netns exec "$ns0" nft list ruleset
 		ret=1
 	fi
@@ -163,6 +164,24 @@ bcast_ping "$ns3" 10.23.0.255
 # same, this time via veth4:macvlan4.
 bcast_ping "$ns4" 10.23.0.255
 
+# test vlan filtering
+# veth1 -> trunk
+# veth2 -> pvid 2
+checktool "bridge -Version" "run test without bridge tool"
+ip -net "$ns0" link set br0 type bridge vlan_filtering 1
+ip netns exec "$ns0" bridge vlan add dev veth1 vid 2
+ip netns exec "$ns0" bridge vlan del dev veth2 vid 1
+ip netns exec "$ns0" bridge vlan add dev veth2 vid 2 pvid untagged
+ip -net "$ns1" link add link eth0 name eth0.2 type vlan id 2
+ip -net "$ns1" link set eth0.2 up
+ip -net "$ns1" addr del 10.0.0.11/24 dev eth0
+ip -net "$ns1" addr add 10.0.0.11/24 dev eth0.2
+do_ping "$ns2" 10.0.0.11
+do_ping "$ns1" 10.0.0.12
+# make sure defrag'n'refrag work
+do_ping "$ns2" 10.0.0.11 -s 1477 -M dont
+do_ping "$ns1" 10.0.0.12 -s 1477 -M dont
+
 read t < /proc/sys/kernel/tainted
 if [ "$t" -eq 0 ];then
 	echo PASS: kernel not tainted
-- 
2.54.0

