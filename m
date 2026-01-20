Received: from relay.virtuozzo.com (relay.virtuozzo.com [130.117.225.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C96AF3EF0D0;
	Tue, 20 Jan 2026 23:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=130.117.225.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768950683; cv=none; b=pSqTAXeIW5e+Vo+AZbY6qdY+rnLnSV1WKS7ypGRLM7Ba5jPsDSJ4rHvZs1osFYVWQMxUMruo1p9bgxEo8p/+xbMPXE5bVamucNHnZixFU/5PwGRPRg6Jb3bcrcw3Kv37mjJsMuNZXcBsaXEGhmIQ5GgeaFllpatEOaHeTvfl9kE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768950683; c=relaxed/simple;
	bh=cgtH9BKj+ht5P1XU6Q1BCAw2oHVTMAEqUVOSjsV0FNM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PKzf1YGIOMUQxN8c9JRr5CGdyzUxI56Eh7ZmLbuDzzEjhMiUZF/3mhle9LC5DCuoFCtU53ysqM1BPhsZ2wWdKV+MPolA94vPV2wqk5rYY4ihJ3sREhLjORMBHr9Kd9phVeVwkQS53I3MSaXBqQUs8z0EWHECdE+6LvulzctVmTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=virtuozzo.com; spf=pass smtp.mailfrom=virtuozzo.com; dkim=pass (2048-bit key) header.d=virtuozzo.com header.i=@virtuozzo.com header.b=huK/tAp0; arc=none smtp.client-ip=130.117.225.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=virtuozzo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=virtuozzo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=virtuozzo.com header.i=@virtuozzo.com header.b="huK/tAp0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=virtuozzo.com; s=relay; h=MIME-Version:Message-ID:Date:Subject:From:
	Content-Type; bh=nHCMBHcJPcwO1W2pJM4Z+IRiDvR1n5I/VKzuBwNtPcs=; b=huK/tAp0q/8N
	BdqNh/AIkzxwvQcp4Y25JBPSieQ3pYo/e1axZrPZcWYX9zsAq5pbB+fQVPPLxNGVvUB40Od0v4fX8
	CsgQ58tHJPIvBUxHe4l3z4y31b8GrtxtTcUzKFQQR41cOw4Z+TKpK2vqLt9b6gvvS9VYZdjmk5rCJ
	8/sTKXWkgS5iyvJSA9ojLlA05wthzGK2FYDHHoW7DePLytwybHTdATKUfaqOnlV5zXqUuJfPG+pzi
	YJgnHz4B8LlOWlwID8Dy9LQ12B4Np8WTb/KRdG+/N5nhaNWOLDPxrK69Pe975xlvCgBaHWK9hDtFu
	G1c4ZG0wc2x79KCEIElM2A==;
Received: from [130.117.225.5] (helo=dev004.aci.vzint.dev)
	by relay.virtuozzo.com with esmtps  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <aleksey.oladko@virtuozzo.com>)
	id 1viKs1-00FwMH-0s;
	Wed, 21 Jan 2026 00:11:05 +0100
Received: from dev004.aci.vzint.dev (localhost [127.0.0.1])
	by dev004.aci.vzint.dev (8.16.1/8.16.1) with ESMTPS id 60KNBEbd328608
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 20 Jan 2026 23:11:14 GMT
Received: (from root@localhost)
	by dev004.aci.vzint.dev (8.16.1/8.16.1/Submit) id 60KNBDva328607;
	Tue, 20 Jan 2026 23:11:13 GMT
From: Aleksei Oladko <aleksey.oladko@virtuozzo.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>,
        Phil Sutter <phil@nwl.cc>, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
        Shuah Khan <shuah@kernel.org>
Cc: Aleksei Oladko <aleksey.oladko@virtuozzo.com>,
        Konstantin Khorenko <khorenko@virtuozzo.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] selftests: netfilter: avoid RULE_REPLACE error when zeroing rule counters
Date: Tue, 20 Jan 2026 23:11:06 +0000
Message-ID: <20260120231106.328585-1-aleksey.oladko@virtuozzo.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The rpath.sh test fails on certain iptables versions when
attempting to zero all table counters at once via 'iptables -Z'.
The operation returns

  RULE_REPLACE failed (Invalid argument): rule in chain PREROUTING

As a workaround, reset counters by iterating over rules and
zeroing them individually instead of using a single RULE_REPLACE
operation.

Signed-off-by: Aleksei Oladko <aleksey.oladko@virtuozzo.com>
Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>
---
 .../testing/selftests/net/netfilter/rpath.sh  | 20 +++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/netfilter/rpath.sh b/tools/testing/selftests/net/netfilter/rpath.sh
index 24ad41d526d9..90cc21233235 100755
--- a/tools/testing/selftests/net/netfilter/rpath.sh
+++ b/tools/testing/selftests/net/netfilter/rpath.sh
@@ -125,8 +125,24 @@ netns_ping() { # (netns, args...)
 }
 
 clear_counters() {
-	[ -n "$iptables" ] && ip netns exec "$ns2" "$iptables" -t raw -Z
-	[ -n "$ip6tables" ] && ip netns exec "$ns2" "$ip6tables" -t raw -Z
+	if [ -n "$iptables" ]; then
+		if ! ip netns exec "$ns2" "$iptables" -t raw -Z 2>/dev/null; then
+			ip netns exec "$ns2" "$iptables" -L PREROUTING -t raw -n --line-numbers | \
+			awk '$1+0>0 {print $1}' | \
+			while read rulenum; do
+				ip netns exec "$ns2" "$iptables" -t raw -Z PREROUTING "$rulenum" 2>/dev/null
+			done
+		fi
+	fi
+	if [ -n "$ip6tables" ]; then
+		if ! ip netns exec "$ns2" "$ip6tables" -t raw -Z 2>/dev/null; then
+			ip netns exec "$ns2" "$ip6tables" -L PREROUTING -t raw -n --line-numbers | \
+			awk '$1+0>0 {print $1}' | \
+			while read rulenum; do
+				ip netns exec "$ns2" "$ip6tables" -t raw -Z PREROUTING "$rulenum" 2>/dev/null
+			done
+		fi
+	fi
 	if [ -n "$nft" ]; then
 		(
 			echo "delete table inet t";
-- 
2.43.0

