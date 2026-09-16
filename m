Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC5374CDA22;
	Wed, 16 Sep 2026 23:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789600624; cv=none; b=FsgXpTXTxfNPpivp8tke85aTOZN7YmXF8IgJyWZ02C/BL1A47SI3MjJMS7bycnSe2BZ8iGZ9pemrr7UsDYWfjJ/QhxOSN3YrJiYU5C+EO668u/qp4FSraWfQdfzxszf206afrQ7sZNYpfAudeqJzwVIzwl+qAk4RHsj0KStQX+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789600624; c=relaxed/simple;
	bh=Me8xftH3rOGBjQhK+kMtrkecExm6eS0RQgg9t8Stnjc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J0JcfZNAw6ZEBmtuo8Q7BP0pCeXPg5GRoJMoo4DwOdqoCnQLHiDhB4KCGohmwFJ7Q9a0ZfAV9VIN3WJnh/VEF7lwsYwkTif8UfJNJAvlPHT0Jl2DrqLNWmJBTljTrPkFedgiPje2mT8y9OO27hDdwGevu4SeDDh4015DGtqsOgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=IJWh4bAv; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="IJWh4bAv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1789600620;
	bh=08cxZCjDbFNhxjzhJ9tap9ER4pgFbk5CK7pyqmcuhAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IJWh4bAvlKdwjVrjlPmHrbZxnz75iw1ieoaI9Ww2OiBwLn4zTWDx44Zsndq9hnc5S
	 sCSIZXWLErFdZiHC2gjKiFkgpEfNknfBb8bpAqlCG3lKCZGwR5w/b5l1gXbzmEOLoI
	 eXoB4IfVoFnx/kk5eCvGT058/vID8jK+WyNTvaXd8JFZLoL0b0Yy8oP797LtXJ05oJ
	 NoONbHv0nCIMONBbt7VyR/aQXOTCzSL/vooiGzzgMj54g9TfxCjsdXODhzr1gi9Zny
	 LCHakH9PcBej3AsDqxCXv29lP3jrJEXi1ul4t6qBpSa4YcHw3Q4ALo/KsjmkZDbAIB
	 0vL9G6UXdwfhg==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 51E556008F;
	Thu, 17 Sep 2026 01:17:00 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net 03/10] netfilter: ip6t_rpfilter: reject routes without inet6_dev
Date: Thu, 17 Sep 2026 01:16:44 +0200
Message-ID: <20260916231652.127456-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260916231652.127456-1-pablo@netfilter.org>
References: <20260916231652.127456-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Weiming Shi <bestswngs@gmail.com>

ip6_route_lookup() can return an error-free route whose rt6i_idev is
NULL. Lowering an external nexthop device's MTU below IPV6_MIN_MTU tears
down its inet6_dev while fib6_ifdown() leaves routes using nexthop objects
in the FIB. An unprivileged user can construct this state with rtnetlink
in a private user and network namespace, then trigger a NULL dereference
through an IPv6 rpfilter lookup:

  Oops: general protection fault, probably for non-canonical address
  0xdffffc0000000000
  KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
  RIP: rpfilter_mt (net/ipv6/netfilter/ip6t_rpfilter.c:75)
  Call Trace:
  ip6t_do_table (net/ipv6/netfilter/ip6_tables.c:316)
  nf_hook_slow (net/netfilter/core.c:619)
  ipv6_rcv (net/ipv6/ip6_input.c:351)
  __netif_receive_skb_one_core (net/core/dev.c:6216)
  process_backlog (net/core/dev.c:6680)
  __napi_poll (net/core/dev.c:7739)
  net_rx_action (net/core/dev.c:7959)
  handle_softirqs (kernel/softirq.c:622)
  do_softirq.part.0 (kernel/softirq.c:523)
  __local_bh_enable_ip (kernel/softirq.c:450)
  __dev_queue_xmit (net/core/dev.c:4913)
  packet_sendmsg (net/packet/af_packet.c:3139)
  __sys_sendto (net/socket.c:2252)
  __x64_sys_sendto (net/socket.c:2259)
  do_syscall_64 (arch/x86/entry/syscall_64.c:94)
  entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)
  Kernel panic - not syncing: Fatal exception in interrupt

Reject routes without an inet6_dev immediately after lookup. Such routes
are not eligible for reverse-path filtering, and the check protects all
later rt6i_idev dereferences.

Fixes: e26f9a480fb6 ("netfilter: add ipv6 reverse path filter match")
Reported-by: co+459f67f4d8af8ce6@bugs.sh
Closes: https://lore.kernel.org/all/VtWUkE8QzJt5CroTj2V2v3ZQ0gwbXZ7nq7I3@bugs.sh/
Suggested-by: Florian Westphal <fw@strlen.de>
Assisted-by: Claude:gpt-5
Cc: stable@vger.kernel.org
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv6/netfilter/ip6t_rpfilter.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/netfilter/ip6t_rpfilter.c b/net/ipv6/netfilter/ip6t_rpfilter.c
index 67c87a88cde4..b5def30c3127 100644
--- a/net/ipv6/netfilter/ip6t_rpfilter.c
+++ b/net/ipv6/netfilter/ip6t_rpfilter.c
@@ -61,7 +61,7 @@ static bool rpfilter_lookup_reverse6(struct net *net, const struct sk_buff *skb,
 		fl6.flowi6_oif = dev->ifindex;
 
 	rt = (void *)ip6_route_lookup(net, &fl6, skb, lookup_flags);
-	if (rt->dst.error)
+	if (rt->dst.error || !rt->rt6i_idev)
 		goto out;
 
 	if (rt->rt6i_flags & (RTF_REJECT|RTF_ANYCAST))
-- 
2.47.3

