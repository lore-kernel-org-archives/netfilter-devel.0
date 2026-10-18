Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55E1322E3F0;
	Sun, 18 Oct 2026 00:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792285025; cv=none; b=ksQAzD1naqXxPEBsN8YG/m11535ZYToPzQ6BzbZ0f6gbEapUjcSVPUlp0igjPDNvF8Zm9/87nphmSl6JLnuDYs7Nv74zkaOlAoWMXhpuuB6lQA2LYM2pgGaPyX89VPp+b/toz5dIx/as9IQwsGlXqBGPj4sLjFwu+e0CrKIuUbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792285025; c=relaxed/simple;
	bh=vHfG6ek6mmDWQMA7fvWDOb2KANKCq0g3xL0RWRaZcUY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mCXn2KODvlzKLy3PI9ZAycuCqPfnXcFfgTp/O+ra8r6Y6qjwiRNYwLMu19qYMn//Ezh01klz3vMXF9mC11kKtKkVtQdxdNjniLWLg3qPbgoJo8TNrYELZlVVdbelh542LPTiRKVs91SZm783dtZBIboxzbuVvJmgcRMROJ8tUBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=T/hWyl4S; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="T/hWyl4S"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1792285020;
	bh=UoQnxMcgyfhOtRq5FX6exxduFWSTRKmypUdpnnBwlC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T/hWyl4SUHD2YF3f42Djesm7qI5lyFHSLKXfssAMesOhHO3Kn2uS7Oqz3Edkfq4OC
	 /3HseTbi0uy8EGyqfEDj74qmvyf5HfsHNAPxm5AthG1+mY4qzw4+V9yQlvAQh+O2+r
	 89ecxsAFv54zrFrPrsa8nrUlGHJzYVQMxWKRc06BO6n3GqsE81z48xVVGBpQiF31kH
	 MQl1Len0ou770cWppWU2Ec5Tf67whAJl0GTLvvDuRMRgiGDUCjsUPkleeU6j1gvP9B
	 fwnuFmIWI0HQeKBQLSQo8DROoHUFdT8jLWaATkpsJ1XNN5ryuLA/DOVbhvxD4LUKN+
	 xr5Z9Rxwdkz0A==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 2554160077;
	Sun, 18 Oct 2026 02:57:00 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@kernel.org,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net-next 10/15] selftests: netfilter: fix return value in zone subtest
Date: Sun, 18 Oct 2026 02:56:33 +0200
Message-ID: <20261018005638.1776148-11-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261018005638.1776148-1-pablo@netfilter.org>
References: <20261018005638.1776148-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

zone subtest prints FAIL, but did not set 'ret=1', so kselftest
framework reports success.

While at it, also fail when "nft -f" returns an error.

Noticed thanks to a (broken) local patch that should have caused this
selftest (resp. the kselftest framework) to report a failure.

Fixes: 33b8aad21ac1 ("selftests: netfilter: add a vrf+conntrack testcase")
Signed-off-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 .../selftests/net/netfilter/conntrack_vrf.sh  | 25 ++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/net/netfilter/conntrack_vrf.sh b/tools/testing/selftests/net/netfilter/conntrack_vrf.sh
index 207b79932d91..2dbfabaadf4b 100755
--- a/tools/testing/selftests/net/netfilter/conntrack_vrf.sh
+++ b/tools/testing/selftests/net/netfilter/conntrack_vrf.sh
@@ -84,7 +84,7 @@ busywait $BUSYWAIT_TIMEOUT listener_ready "$ns1"
 # as decided by the first iteration of the ruleset.
 test_ct_zone_in()
 {
-ip netns exec "$ns0" nft -f - <<EOF
+if ! ip netns exec "$ns0" nft -f - <<EOF
 table testct {
 	chain rawpre {
 		type filter hook prerouting priority raw;
@@ -105,6 +105,12 @@ table testct {
 	}
 }
 EOF
+	then
+		echo "FAIL: cannot load testct nft ruleset"
+		ret=1
+		return
+	fi
+
 	ip netns exec "$ns1" ping -W 1 -c 1 -I veth0 "$IP0" > /dev/null
 
 	# should be in zone 1, not zone 2
@@ -113,6 +119,7 @@ EOF
 		echo "PASS: entry found in conntrack zone 1"
 	else
 		echo "FAIL: entry not found in conntrack zone 1"
+		ret=1
 		count=$(ip netns exec "$ns0" conntrack -L -s $IP1 -d $IP0 -p icmp --zone 2 2> /dev/null | wc -l)
 		if [ "$count" -eq 1 ]; then
 			echo "FAIL: entry found in zone 2 instead"
@@ -137,7 +144,7 @@ test_masquerade_vrf()
 
 	ip netns exec "$ns0" conntrack -F 2>/dev/null
 
-ip netns exec "$ns0" nft -f - <<EOF
+if ! ip netns exec "$ns0" nft -f - <<EOF
 flush ruleset
 table ip nat {
 	chain rawout {
@@ -158,6 +165,12 @@ table ip nat {
 	}
 }
 EOF
+	then
+		echo "FAIL: cannot load ip nat nft ruleset"
+		ret=1
+		return
+	fi
+
 	if ! ip netns exec "$ns0" ip vrf exec tvrf socat -u -4 STDIN TCP:"$IP1":55555 < /dev/null > /dev/null;then
 		echo "FAIL: connect failure with masquerade + sport rewrite on vrf device"
 		ret=1
@@ -184,7 +197,7 @@ EOF
 test_masquerade_veth()
 {
 	ip netns exec "$ns0" conntrack -F 2>/dev/null
-ip netns exec "$ns0" nft -f - <<EOF
+if ! ip netns exec "$ns0" nft -f - <<EOF
 flush ruleset
 table ip nat {
 	chain postrouting {
@@ -193,6 +206,12 @@ table ip nat {
 	}
 }
 EOF
+	then
+		echo "FAIL: cannot load ip nat postrouting ruleset"
+		ret=1
+		return
+	fi
+
 	if ! ip netns exec "$ns0" ip vrf exec tvrf socat -u -4 STDIN TCP:"$IP1":55555 < /dev/null > /dev/null;then
 		echo "FAIL: connect failure with masquerade + sport rewrite on veth device"
 		ret=1
-- 
2.47.3

