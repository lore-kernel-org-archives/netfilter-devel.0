Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793782970;
	b=TWWhDAjNXTZsXPcWhKJQ+LEaX2azSPec6jrjuJ+hSCBvXLGJqVSQ9jDt3qgke4LACE+w
	 2Pr2gBLypKpPWr27Ji+mJ5ivGdH61Jek4K9xNvJMld62WMLsogOOStE+t2KLOP/AJ+Q4M
	 VIJWdGw5HjVgEjme6GKZ8IaTY+8wA1rcbuVfYdzxB4CftgFsAA3evnV57DOiBeatnN/oh
	 hqkYSwPrk0aA771TrrtQShCLi+F8FTEpcWaUPwZ7Ll5+47qih4upZnH55oNF9MP5PF6sc
	 7jkRnFpr4m4d+CVSrtwTkwUF5qdwTj8h44qnXiewQ6gX9Q06wqXFZzwxuzGNxwfTrVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793782970;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=ACw4Crf3hJuHvBnGGimGcJkB6r441MIl6lESNzI1wQ8=;
	b=uzEjkvZ0haf+KDJx9GekIG6sNh5smh1H81uAmcosiUMjGv6MRYnF6yEkITuYc+ra8BKg
	 +cLnK/Tmgd+do/4I4VFfA6mISGn9cKCaaZ9isgSzObQqxxk1pUn6Q51RoywIS+SvrtUtQ
	 5jWcB7RAIJR9Rf9zDCYpBP41+9ptzVqCC8ZzDR4jsX096mdHi23bv6BxFKyq2gtT5Upq0
	 eLAsK72zgxrqW6Yfn4nMYrXq2mWpwuyysr39wZvs8QuPZIpID+ll1PQRwiIQHT0Yl4nAG
	 jNcrWtNaMckFTeCMian3/YWqaOdL5ZsTDtBddy3z8n2kDeZAW87YkfXaueAuqNiA/Kw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b="Wb4yHY/m";
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D77F6606A33B;
	Wed,  4 Nov 2026 09:02:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D77F6606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=Wb4yHY/m
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1793782957;
	bh=ACw4Crf3hJuHvBnGGimGcJkB6r441MIl6lESNzI1wQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wb4yHY/m0X+AwkYMtxGKmL+drCpxCKwv9WsTWhPsKHjrSmbJecYeQbFiHFZHX79Fy
	 wJk+0hJYEPxEIgiMghf/bR54dJCr/Lx9rqIM2nZwN53wB9AUBYkTPXyUhhZaWJlomI
	 IeQy4xVNPK+ijvC0cYRDJiPEMzauaSFXd/d5cHLxo5Gqlx4ryfLQzaV7zmD85OER2B
	 e1s3RPuHCsKjXbgqVt85wYZMo1VPlwGvdikq8w0Bju2q95aeDdwwLOmo4ToRHYbwBy
	 ozi9vHXd07LaK0VoKM/39Utj3k+817S06WHjjp2jHXhC2wsaJuSmEn5uLMLpdFBD+s
	 XDB1bQHoikrkA==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id E10D360088;
	Wed,  4 Nov 2026 10:02:36 +0100 (CET)
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
Subject: [PATCH net 03/13] ipvs: fix protocol data lifetime during namespace teardown
Date: Wed,  4 Nov 2026 10:02:14 +0100
Message-ID: <20261104090224.750548-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261104090224.750548-1-pablo@netfilter.org>
References: <20261104090224.750548-1-pablo@netfilter.org>
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

From: Chengfeng Ye <nicoyip.dev@gmail.com>

IPVS frees its per-net protocol data before control cleanup cancels
defense work and unregisters the sysctl table. A defense worker can load
a protocol data pointer, then namespace cleanup can unlink and free that
object before the worker dereferences pd->pp or pd->next. The worker's
securetcp_lock does not serialize with protocol cleanup. A concurrent
defense-mode sysctl write can reach the same timeout update path.

KASAN reported:

  BUG: KASAN: slab-use-after-free in ip_vs_protocol_timeout_change
  Workqueue: events_long defense_work_handler
  Call Trace:
   ip_vs_protocol_timeout_change+0x1b4/0x1e0
   update_defense_level+0x63e/0xd80
   defense_work_handler+0x1e/0xc0
  Allocated by task 125:
   ip_vs_protocol_net_init+0xda/0x2f0
   __ip_vs_init+0x16b/0x240
   setup_net+0xfc/0x310
  Freed by task 12:
   ip_vs_protocol_net_cleanup+0x1d6/0x2e0
   __ip_vs_cleanup_batch+0x7d/0x100
   cleanup_net+0x38c/0x770

Run control cleanup before protocol cleanup so that defense work and
active sysctl handlers have finished before their protocol data is freed.
Initialize protocols before exposing the control interface, and unwind
in reverse order, to enforce the same lifetime on initialization failure.
Protocol initialization and exit do not depend on control state.

Fixes: 9330419d9aa4 ("IPVS: netns, use ip_vs_proto_data as param.")
Cc: stable@vger.kernel.org
Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>
Acked-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipvs/ip_vs_core.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index fd503f0efb57..8a3c880fdb26 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -2502,12 +2502,12 @@ static int __net_init __ip_vs_init(struct net *net)
 	if (ip_vs_estimator_net_init(ipvs) < 0)
 		goto estimator_fail;
 
-	if (ip_vs_control_net_init(ipvs) < 0)
-		goto control_fail;
-
 	if (ip_vs_protocol_net_init(ipvs) < 0)
 		goto protocol_fail;
 
+	if (ip_vs_control_net_init(ipvs) < 0)
+		goto control_fail;
+
 	if (ip_vs_app_net_init(ipvs) < 0)
 		goto app_fail;
 
@@ -2527,10 +2527,10 @@ static int __net_init __ip_vs_init(struct net *net)
 conn_fail:
 	ip_vs_app_net_cleanup(ipvs);
 app_fail:
-	ip_vs_protocol_net_cleanup(ipvs);
-protocol_fail:
 	ip_vs_control_net_cleanup(ipvs);
 control_fail:
+	ip_vs_protocol_net_cleanup(ipvs);
+protocol_fail:
 	ip_vs_estimator_net_cleanup(ipvs);
 estimator_fail:
 	net->ipvs = NULL;
@@ -2547,8 +2547,8 @@ static void __net_exit __ip_vs_cleanup_batch(struct list_head *net_list)
 		ipvs = net_ipvs(net);
 		ip_vs_conn_net_cleanup(ipvs);
 		ip_vs_app_net_cleanup(ipvs);
-		ip_vs_protocol_net_cleanup(ipvs);
 		ip_vs_control_net_cleanup(ipvs);
+		ip_vs_protocol_net_cleanup(ipvs);
 		ip_vs_estimator_net_cleanup(ipvs);
 		IP_VS_DBG(2, "ipvs netns %d released\n", ipvs->gen);
 		net->ipvs = NULL;
-- 
2.47.3

