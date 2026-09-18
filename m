Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86E9F51DB0C;
	Fri, 18 Sep 2026 18:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789756275; cv=none; b=WQRtrjalyCaiR3kHCWVGubOeUYHp0STy5e8xohkLPiJURymdBWPabpgtEsNHOWjIUSI9pUAFmqob6/R/D5diGz9zOK9x/4Mr7cZtIdS1IHPaa754+cFuL+sN8fe1Srg9Yo6iqxBwCOL5/9XMhOw9Hpjh5yVhu5Abalnzh7eiIQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789756275; c=relaxed/simple;
	bh=4zEZMHh4DDkzBHZJnZViZeAC2JUpS8h+LtAC4/c1iYc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AFy5dVsD8of0zzmBvwj5QikDEvdxzJDXkfG6WbqtDgOrjhqpiH+euAthvMlmM5hy00zxkBv/Hy1l/30eyXxifUvisvIOqqgcj7GcjC5+Z5yBHzfOjJOdjWjSSzS0Koz2zR72FNvkPf+Tqhkr3ZHeW6AipzpTStCMyXAM5Dnuze4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IAubqxBX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IAubqxBX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5D511F000FF;
	Fri, 18 Sep 2026 18:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789756274;
	bh=wpmIF6yy9SlhPeMU8vS+NXZkJWjaMaqH1VZ6cxj8qUo=;
	h=From:To:Cc:Subject:Date;
	b=IAubqxBXkF8yRkT/Z0gVRC+Q5xFYjiMns7vBrktrVtpfj5XC5XLjh04G1N7RftaIj
	 02MVjEKQOsF1zbS+1onSU8oeBfnxjxLEdznysQF2AkaQSXZCBps6TAkj9VINcxGSoY
	 7yX3Bfh/eNpjpA90ns3wWvX7CWtmmIuazS5m0NEGMqiwWDLq1VjMQYc22MBq8PXaJK
	 8bfl9/040zOpwGMhFpb4uF5E+nV3cRUOh5JCbmA9DPFS5gaoBe0pTkYV1x+xdH1/MK
	 J1oxGoi1Ek/fgDb9RtXAe6hW5QlYD+Nz776AG2anPexI8I1c6fbQwnzIxYyKj1c8v6
	 zAZ28CXtkLM6A==
From: Jakub Kicinski <kuba@kernel.org>
To: pablo@netfilter.org,
	fw@strlen.de
Cc: netdev@vger.kernel.org,
	Jakub Kicinski <kuba@kernel.org>,
	phil@nwl.cc,
	shuah@kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH nf-next] selftests: netfilter: nft_queue.sh: only queue icmp echo request/reply
Date: Fri, 18 Sep 2026 11:31:09 -0700
Message-ID: <20260918183109.3918131-1-kuba@kernel.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
---
The difference between v4 and v6 has been there from day one,
which makes it seem intentional, but I don't understand nft
well enough to come up with any theories why..

CC: pablo@netfilter.org
CC: fw@strlen.de
CC: phil@nwl.cc
CC: shuah@kernel.org
CC: netfilter-devel@vger.kernel.org
CC: coreteam@netfilter.org
CC: linux-kselftest@vger.kernel.org
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
2.55.0

