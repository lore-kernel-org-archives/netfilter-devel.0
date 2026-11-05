Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793882746;
	b=AeF3cfucrEMS2HaSxkLKFyAlHh6FTMTIz9EaVGdCagH4Gwz0A5vQxQQIcp6mfL5iQHyW
	 Tk5cycRSK2N+r7hyRqU539gMD4W69m6VtqyqHTmUwsAyOrp/NPliSAEo8gssAMIrtsSA6
	 AWdeUmL5YYiEKauxlZECkFFOCmyVdGUZ7y0hF1AWp1V3u/WzroV9DfjTJ90EY3HVCblUt
	 QtHalZaliQPhbpT6qfDhTg4IoCYN56PhasQ7LnayBifGRxUM27y47WM0kedLo4+Lxl8dt
	 Mj1GJF+iKbmvx5ZLwcEOxmH+nm+D8py3pjrLCiNBADxAr92kOxV+9HMXV9/g8Q9gL8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793882746;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=ACw4Crf3hJuHvBnGGimGcJkB6r441MIl6lESNzI1wQ8=;
	b=IzZbkgoepD0XSgNmqqteCY2Kc3YJM15UiYjsqebv5fF7qM/4h1/ngqcLkknRkj0p5v+g
	 d4+VFl/FQdR1jq0e01amH9pJh+LMVkbidREw3pQqiD2nVeRXauAZSUZgX0gIAG8xHntrU
	 m+vZdiXnKhNWODBZYyyZWB48SH8OfjLXbgwGydGyM+6phAjbeD/T+ZGTOwVTbqJ6oMjJ6
	 2hDMeqzNtfDdDxbFJ6LZGuotnqS9+SXF15V+V6CrhNyyiJs7BYQMgcPu3VhNMqfdhzZn9
	 MRuIPxZlTd82+MqFfnyrxS3MGSBYxjpoRx28QBdpVSMTgIHRJ0KtdaEvsCvFXIC4l8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=vtKnT0Of;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46753606A32C;
	Thu,  5 Nov 2026 12:45:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 46753606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=vtKnT0Of
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1793882744;
	bh=ACw4Crf3hJuHvBnGGimGcJkB6r441MIl6lESNzI1wQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vtKnT0OffbbQB+UdkwWfOi5+dQWip8oHsnLW1OabTFgzSclERkHzi+o/LHMq+5Jnx
	 ZvdUglDnRlqd+INNUWGUlm5bCfbuAUg3+EIqmogluHAhkZN01TuVi8VzUU8zbP6sXk
	 oDUjZx8TlnwNXONmcwTNVsu32qfO6Gqg0fISfF32ixDDjGd4V596/9rTwKRxKuXp8w
	 z6gUnjKBbxjGpdb6ke7IxG2uocDn5ye+g8tyxa/eAKFZTWvp/ui/0Ih1NY8LqRpcRB
	 Ab3cRY33exfgErRZkCjr7UUPD+o92mmBgAE0rVHn48kibRiIfxdl4K5Mi2EX/G1X9C
	 +A76RmUKdhc+Q==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 08A9E60082;
	Thu,  5 Nov 2026 13:45:43 +0100 (CET)
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
Subject: [PATCH net 03/12] ipvs: fix protocol data lifetime during namespace teardown
Date: Thu,  5 Nov 2026 13:45:27 +0100
Message-ID: <20261105124536.1009301-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261105124536.1009301-1-pablo@netfilter.org>
References: <20261105124536.1009301-1-pablo@netfilter.org>
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

