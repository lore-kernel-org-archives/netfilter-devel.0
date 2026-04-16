Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C17A91F09A8;
	Thu, 16 Apr 2026 13:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776345309; cv=none; b=OQLRxwOKwfYvNjPLFtNwhtAmEogD/uYom0GfjqkufMsc+0omtRnBOxtXZKVMoTV4gxoJuBJZf9YcCR4IW91gwqRO4hpsVdtMXu4Qv35/TI/jSM85yPUNlVftvchZljO8qhx7tYroLhYxFZBv4L/Jz0nIFoe8YyA9N3myeWQbcmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776345309; c=relaxed/simple;
	bh=la5PxyZ6zfqAlWe7ze7U2BoSo9vipP6VepoVDS9ueko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uCn6D9FUeYJ4iQhmVfMkA4JuIapY3PuuLej6MDRQ6XCBGIzV4uqj/MEHjkX/w1EBZhaA5Ixh5kDdqItgDzHCjdi0QwyKqTYWYJqsW0YlXM7vDj45JUitVn0yaQEx/pTBOz8LqN83zM7h5V5XdrY5wja7gLWbCMWGpR8gEgqgvug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Nk0O2Psr; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Nk0O2Psr"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 90C7C60177;
	Thu, 16 Apr 2026 15:15:05 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1776345306;
	bh=LeFaSGjPCTTf+pALMTZtcj2GKEbk7aP/xGJb/KuJWaQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nk0O2PsrdVnySBCQMs4/YoTmCfv5PAFdPRdG6IZfu5OhgLzhEzuKwiBTjS1bZ9L/j
	 G3DquQZWeB4VS6OUvHAonjI2/oDccMmKAh28yUaAeTnUDcpupeEWHctF1PK4yRrqeR
	 5BmU72n6wC3UMXKwxPqScBmiExAb4iYvNKKqzi13YDEQ1Rt2mHf6qRgAn3+8ve9Ean
	 G9TS2lZxkMJLDqZwPJtmcRiFVbCvy5yl8L0syZKsmlcMU7JTYorIXHJruszIgw0hsC
	 BP9pAEhQewVMLC+m8vD377OlAmSUteUEIQ9yxupixT7//8UcS7qIYxBI4dEY51Ea2K
	 2oH2nR8jLixyA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 04/11] netfilter: nfnetlink_osf: fix null-ptr-deref in nf_osf_ttl
Date: Thu, 16 Apr 2026 15:14:46 +0200
Message-ID: <20260416131453.308611-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260416131453.308611-1-pablo@netfilter.org>
References: <20260416131453.308611-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Kito Xu (veritas501)" <hxzene@gmail.com>

nf_osf_ttl() calls __in_dev_get_rcu(skb->dev) and passes the result
to in_dev_for_each_ifa_rcu() without checking for NULL. When the
receiving device has no IPv4 configuration (ip_ptr is NULL),
__in_dev_get_rcu() returns NULL and in_dev_for_each_ifa_rcu()
dereferences it unconditionally, causing a kernel crash.

This can happen when a packet arrives on a device that has had its
IPv4 configuration removed (e.g., MTU set below IPV4_MIN_MTU causing
inetdev_destroy) or on a device that was never assigned an IPv4
address, while an xt_osf or nft_osf rule with TTL_LESS mode is
active and the packet TTL exceeds the fingerprint TTL.

Add a NULL check for in_dev before using it. When in_dev is NULL,
return 0 (no match) since source-address locality cannot be
determined without IPv4 addresses on the device.

KASAN: null-ptr-deref in range [0x0000000000000010-0x0000000000000017]
RIP: 0010:nf_osf_match_one+0x204/0xa70
Call Trace:
 <IRQ>
 nf_osf_match+0x2f8/0x780
 xt_osf_match_packet+0x11c/0x1f0
 ipt_do_table+0x7fe/0x12b0
 nf_hook_slow+0xac/0x1e0
 ip_rcv+0x123/0x370
 __netif_receive_skb_one_core+0x166/0x1b0
 process_backlog+0x197/0x590
 __napi_poll+0xa1/0x540
 net_rx_action+0x401/0xd80
 handle_softirqs+0x19f/0x610
 </IRQ>

Fixes: a218dc82f0b5 ("netfilter: nft_osf: Add ttl option support")
Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Kito Xu (veritas501) <hxzene@gmail.com>
Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nfnetlink_osf.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nfnetlink_osf.c b/net/netfilter/nfnetlink_osf.c
index 70172ca07858..4bbe64288b90 100644
--- a/net/netfilter/nfnetlink_osf.c
+++ b/net/netfilter/nfnetlink_osf.c
@@ -36,6 +36,9 @@ static inline int nf_osf_ttl(const struct sk_buff *skb,
 	const struct in_ifaddr *ifa;
 	int ret = 0;
 
+	if (!in_dev)
+		return 0;
+
 	if (ttl_check == NF_OSF_TTL_TRUE)
 		return ip->ttl == f_ttl;
 	if (ttl_check == NF_OSF_TTL_NOCHECK)
-- 
2.47.3

