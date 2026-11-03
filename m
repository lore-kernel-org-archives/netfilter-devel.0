Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793714604;
	b=D7yJa1TBk3Dbj+/ANyyNwzlVOj5dxZtHqYna6SKpeTAJSNRMIbN9Bh7x+g8ezM5mePYg
	 Hg0VMFKhfVSb7+92GVwaqy5LYGyPubkrf2eoySkIjHxYubFSL/EA7K3Edk5eU1SC5y+Ya
	 iqAvk9fXQ0AyJT/4VlwE2vzCAUqBdBLeszAf5s2pRrNWHYppQX2JMZ2CMunpv653n1n0Z
	 SYZQrWg6Ql4vOS3W85mjGFQ9O66W6G27J0L6pYfyTOSy4ZBOewlzH1J6AFXTGRhQ7fens
	 gtMPx+oafyRXK6Wxm/zoy+jbVHU3y5z43JzA/8M3G1wSKF4mYV5fZAP4RfLXAYQORcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793714604;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=ACw4Crf3hJuHvBnGGimGcJkB6r441MIl6lESNzI1wQ8=;
	b=H4c4/PyEcFYHgYcnV+35u/aAqxsd4/UeJ4eh+nQ4jlVRfHiSjX0v6MHfO/4Ip7UWc426
	 s/0fCQmXc0qqmCn7cOrEiQs5d9+5MbQwjfl6SaO1A9iJmccsW/c6RN3Kxn37C/x4MLzF6
	 1EIKtY+zUGWdDSy/f4MN2eyckbKKMUug3UOiRGxo3XaxHw6DvBiXTpirKeFfVmbvCVj9I
	 6B7BwvBfEF52pfxvx1bhngIt5Uvj+EuS5lLT81zyBh6ihV5kKlBQff57VUHKBEeEEgmkA
	 kagH3CYoSZKMNaJ2XFyG5InPnKPNkvx07Tl6Kzk74SdIDaIOAIdWE6aJvuRe4Y2RJmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=Gcpfx7nP;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDB696082BE3;
	Tue,  3 Nov 2026 14:03:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CDB696082BE3
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=Gcpfx7nP
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1793714602;
	bh=ACw4Crf3hJuHvBnGGimGcJkB6r441MIl6lESNzI1wQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gcpfx7nP6TZP+NyWdwK57dG3j34BQqbJN+8Szxu/SkMt7bNfrGVwgi1btC6aj8Tpp
	 89zuGUolUJFApv0I1JMlUWHDW7GpJCQyoBQMMJgisB1Udk/DwfqnOqEqI3pSu2cyFd
	 U8+1P/GIr74DdVw+xQ6aqadtqXNm0l0GPXVolZqu2f8KKiIQFCuiIAHTqD2Q0zbHZU
	 GuSVDsuwAebNw/uV8CxQIkQ5WecGU6V6Zwta37enLFjvQaxOhuUc3GQ/O4OmiJX8cd
	 OzyEXDEOpKPQ8JspxHmSupTpHHmq8NrFqKh2q3lLwDRI5gn+mYR7IIADLec0TnFhVP
	 oHteXoi+uLDWg==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 59DA660092;
	Tue,  3 Nov 2026 15:03:21 +0100 (CET)
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
Subject: [PATCH net 04/15] ipvs: fix protocol data lifetime during namespace teardown
Date: Tue,  3 Nov 2026 15:02:57 +0100
Message-ID: <20261103140308.591690-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261103140308.591690-1-pablo@netfilter.org>
References: <20261103140308.591690-1-pablo@netfilter.org>
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

