Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B91BE400E0D;
	Sun, 11 Oct 2026 22:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791756017; cv=none; b=WxeU3MMOwV/kVfM5KphabwZeU7AzwaGjWpQ5sqtzJX4XhI6Fp6jrbzo83wXYay4QdbV3FisQwRaaxnIu4ou8RLXNBp/0eyHSGBwssyGo3rP+q1ezanhDUY6OIp27Fbh3rwMqSPd7VBxUvE9btKzlmqSeqiKZcAqtA8qLb9pL/Cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791756017; c=relaxed/simple;
	bh=3roayg8buVEjdLKPYmZ6HsCIOKDQqHYgVaqusQGO+Rk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mbsnJVU19UeLVwOi6D5umNkDqlpHEYs7X6e1xou51GHI4xAsg0/KGIXkcYQIMFr+CqdoyP3IFjqFGtHFlBI0wi3ES6xDdhM7cLRne80twL4CTDq5hBgkifQYO3tQoGITwhtejW82Pzsj0mO78SwxvwcpkAM0tyiA6aIoT5r40qY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=TlScgAyF; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="TlScgAyF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1791756013;
	bh=uvUyegn7cLkpVngqqoa3IGbBqZM7eb5HFYXevNcnm50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TlScgAyFEmwE+L79TkB3/KoEybwGq9K4kirHkXF+FdIOADpx6bi46pSfnaWotER9s
	 kBfPpIJOm1Z6wfvDamFi71CfbUGUKwro3CliMzwpFSezaG+v4fAakSkPEeE1Hsw8AG
	 hry/vP6dfFkjmJG3MCFjAutCN/A51U/ZFKhTXhQrFcFyk3CuG1FzSgPXGFIKTa8Wpg
	 9cZqAWuRwEi4ZzzxYYntUndTZdKFLXn7FWcO/o44BhznVqkq50z2M29Z6PRvxiV4I3
	 hlKYdl1ssl9b4JUxYuGIf0tP6GXunUKN/lRUBJDQK6gqwYzTbxV1ZstM7Mj4H+OY0z
	 LHULtdzJhufNw==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id E449560074;
	Mon, 12 Oct 2026 00:00:12 +0200 (CEST)
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
Subject: [PATCH net-next 08/15] selftests: netfilter: nft_queue.sh: only queue icmp echo request/reply
Date: Sun, 11 Oct 2026 23:59:46 +0200
Message-ID: <20261011215953.1334630-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261011215953.1334630-1-pablo@netfilter.org>
References: <20261011215953.1334630-1-pablo@netfilter.org>
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

