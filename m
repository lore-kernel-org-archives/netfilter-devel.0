Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47500358373;
	Fri, 19 Jun 2026 11:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781870109; cv=none; b=T9tCs/poKnPTW8PD0AZb26PfVYLavcPtUOk6oRg0/EJR4xPkvYAx2rAGWnWYCjL68rR3ZH/2BYM2thIhq4PJQ4XJ+0zEwpXxDmpfXj8Ex7DqsoyzYYVUBLLdH5wUiW5dnAlWdLcpDXro4hUXqjvAOOxdne1aEePHfN1yqMcupsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781870109; c=relaxed/simple;
	bh=Cctvo3ka08rA2RgqUCoipHjqp+aCGXZHtlh/rMOzF88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h3A2vO2Lfp7uQkXNq05VhZ1JISz7JeJobOTDEVrXZfvTAGEjIh1lKtUQs4t9WH0geJBiESV/K1JemCu7RW8PULhBj6TaoqMEhSQEigRg+LqmLqTEY94JYGlvDryoS4JpJ8Wx1Mz3MmNo3gsCkU4gSlMZw7Qed/HMgHNSymqNklg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=qRvWqpHq; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="qRvWqpHq"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id E471D601A6;
	Fri, 19 Jun 2026 13:54:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1781870100;
	bh=rRCknTVPe8kEOXE8SHhKPUK4i1g1mN85/ghVx+xSnpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qRvWqpHqkQcHTSvBwXl82VPfyi3pL0y3sfXOToxf6lr/vIj9xpfG1EPiYoYJNCpj8
	 Kp+DVlqT5yA9z4plywu/hrLnWQ46ncHxwpCxlQyS29U6oEMNR8lFgvwxMIMTOsGtdw
	 WmdIX0Psv2kFHR+6Usg+JXHckd/NiuESykCuFIq7K5+ZOV/chxNI3AZjuaCjUavpud
	 eUXRugJfpOlWqqCPC3mJxpzY1eATP7AtuhY69d6X9KcsvNhth8gIsc9a+T0h/apH8D
	 NNzs+Gog0ZOmspDX07H2Pt4QldHhCcfbcqV/Tm9tgh/RzMm1RxT9xpZldjAH7ElLGd
	 IViImcLSX4fmA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 01/16] netfilter: flowtable: fix offloaded ct timeout never being extended
Date: Fri, 19 Jun 2026 13:54:36 +0200
Message-ID: <20260619115452.93949-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260619115452.93949-1-pablo@netfilter.org>
References: <20260619115452.93949-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Adrian Bente <adibente@gmail.com>

OpenWrt has recently migrated many platforms to kernel 6.18. On the
MediaTek platform, which supports hardware network offloading, WiFi
connections accelerated via the WED path were observed to drop after
roughly 300 seconds.

After several debugging sessions, assisted by the Claude LLM, the
problem was narrowed down as follows:

nf_flow_table_extend_ct_timeout() extends ct->timeout for offloaded
flows using:

	cmpxchg(&ct->timeout, expires, new_timeout);

'expires' comes from nf_ct_expires(ct) and is a relative value, while
ct->timeout holds an absolute timestamp. The two are never equal, so
the cmpxchg always fails and the timeout is never extended.

This goes unnoticed for most flows, but a long-lived hardware (WED)
offloaded flow on MediaTek MT7986 eventually has ct->timeout decay to
zero, the conntrack entry is reaped and the connection breaks.

Open-code the relative value from a single READ_ONCE(ct->timeout)
snapshot and compare against that same absolute snapshot in the
cmpxchg, so the timeout extension actually takes effect while the
datapath remains authoritative if it updates ct->timeout concurrently.

Fixes: 03428ca5cee9 ("netfilter: conntrack: rework offload nf_conn timeout extension logic")
Cc: stable@vger.kernel.org
Suggested-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Adrian Bente <adibente@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_core.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 785d8c244a77..99c5b9d671a0 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -505,8 +505,13 @@ static u32 nf_flow_table_tcp_timeout(const struct nf_conn *ct)
  */
 static void nf_flow_table_extend_ct_timeout(struct nf_conn *ct)
 {
-	static const u32 min_timeout = 5 * 60 * HZ;
-	u32 expires = nf_ct_expires(ct);
+	static const s32 min_timeout = 5 * 60 * HZ;
+	u32 ct_timeout = READ_ONCE(ct->timeout);
+	s32 expires;
+
+	expires = ct_timeout - nfct_time_stamp;
+	if (expires <= 0) /* already expired */
+		return;
 
 	/* normal case: large enough timeout, nothing to do. */
 	if (likely(expires >= min_timeout))
@@ -524,7 +529,7 @@ static void nf_flow_table_extend_ct_timeout(struct nf_conn *ct)
 	if (nf_ct_is_confirmed(ct) &&
 	    test_bit(IPS_OFFLOAD_BIT, &ct->status)) {
 		u8 l4proto = nf_ct_protonum(ct);
-		u32 new_timeout = true;
+		u32 new_timeout = 1;
 
 		switch (l4proto) {
 		case IPPROTO_UDP:
@@ -549,7 +554,7 @@ static void nf_flow_table_extend_ct_timeout(struct nf_conn *ct)
 		 */
 		if (new_timeout) {
 			new_timeout += nfct_time_stamp;
-			cmpxchg(&ct->timeout, expires, new_timeout);
+			cmpxchg(&ct->timeout, ct_timeout, new_timeout);
 		}
 	}
 
-- 
2.47.3

