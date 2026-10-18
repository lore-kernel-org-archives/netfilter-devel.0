Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74D9E2DF719;
	Sun, 18 Oct 2026 00:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792285012; cv=none; b=kGINoLWMshQjOZzWFK+xCncO06KfM/NRVOsRwJJwpZg6J+/tiukarcgehYlrdb5Z7Xq0XocBfhdKgy990zUQQ0dtbieoYw8ePZ9wgFfXojwjfID9TsXHEPFP0wDJ8Pr7MevaLnnPdG3Hux76RPdhQ5IOA3lMhGwVTFFG3smMo9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792285012; c=relaxed/simple;
	bh=3roayg8buVEjdLKPYmZ6HsCIOKDQqHYgVaqusQGO+Rk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UBHNGZolz+LWmZWPHhAP48xGkO1Zt9e27OmNIfsi4sgGBcSPK9e8j3lD4jRvbxaYCNH/nIJAcd0BFKil/MJTROwBGaDg4ixMgoPTFL4dAJ+KyP5tqPSp7VI/XG7EPJa/TYJg8n+U+weRpXD3oEECe2bqBGbD4lwrAWd+TGl+QXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Qeln+D/R; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Qeln+D/R"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1792285009;
	bh=uvUyegn7cLkpVngqqoa3IGbBqZM7eb5HFYXevNcnm50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qeln+D/RYFMfXDpowOocy7Xb5KR629NRZBOPKwguKdXKNtFRfDDButxYO0OaLbzE1
	 TcNZpE7j6Vj0siExQ/ndEyAVLp5ZgkHG4w+FZkUxic0DfHvwJf3L5WHH+Cmc7qaEbT
	 WyLTix59zp5EH/ZErHMV2O7KsGsBrc8kZhOJpiYU+vMK47WpG5pCDPHkHH/qA094V1
	 m5BuPK0gMtGY3jZL5pVspYXQhdZA46NfjMfWOJSIpd1dNkPlKBuu0wPW9Nz9u8bcId
	 BbKlCEy9q7iFFWCITJc6IiZkp9sZgJjfqEg6SwKtS1Igzn87tT8OF2EGBpH8stofHw
	 hRzNam+xVylbQ==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 1993E60060;
	Sun, 18 Oct 2026 02:56:49 +0200 (CEST)
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
Subject: [PATCH net-next 02/15] selftests: netfilter: nft_queue.sh: only queue icmp echo request/reply
Date: Sun, 18 Oct 2026 02:56:25 +0200
Message-ID: <20261018005638.1776148-3-pablo@netfilter.org>
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

From: Jakub Kicinski <kuba@kernel.org>

The bridge test flakes on debug kernels:

  FAIL: Expected 10 packets total, but got 24 packets total
  hook 3 packets 00000008
  hook 4 packets 00000010

The surplus are icmp fragment reassembly timeouts.  The udp flood in the
stress test leaves incomplete datagrams behind in ns2 and ns3, 30 seconds
later their reassembly queues expire and both namespaces send icmp time
exceeded to ns1's pre-bridge address.  ns3 is not reconfigured when the
router is turned into a bridge, so its messages arrive via veth2 and are
then forwarded out of br0. Such packets are locally originated from the
bridge point of view and are queued from the bridge output and
postrouting hooks, which is why only those two counters are off.

Restrict the ipv4 rule to echo request/reply, the icmpv6 rule already
does this.

We used to see 1 flake a day in NIPA before locally queuing this change,
zero flakes since (over 9 days)

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tools/testing/selftests/net/netfilter/nft_queue.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/netfilter/nft_queue.sh b/tools/testing/selftests/net/netfilter/nft_queue.sh
index 7c857a2e0f34..c8d1f2eb4133 100755
--- a/tools/testing/selftests/net/netfilter/nft_queue.sh
+++ b/tools/testing/selftests/net/netfilter/nft_queue.sh
@@ -92,7 +92,7 @@ load_ruleset() {
 ip netns exec "$nsrouter" nft -f /dev/stdin <<EOF
 table $family $name {
 	chain nfq {
-		ip protocol icmp queue bypass
+		icmp type { "echo-request", "echo-reply" } queue bypass
 		icmpv6 type { "echo-request", "echo-reply" } queue num 1 bypass
 	}
 	chain pre {
-- 
2.47.3

