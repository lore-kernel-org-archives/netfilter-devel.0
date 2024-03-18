Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8903E2C857
	for <netfilter-devel@vger.kernel.org>; Mon, 18 Mar 2024 09:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710755838; cv=none; b=jBpUBqKoW2V2Ih2ZjXHKFMoGCqMQjz9Bd8pFgrQCSOFOJ1U5TPrUTlFL2XiopP1zE/s83oBIbf7W2DBKCCasqBLm3cpz3qxVHrn0voht167O7lzr++2Dfj+7G+2U1/E6xfeX8wb2quuyegdkksj3fb62seCCHXbdHUU/pnL2/Yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710755838; c=relaxed/simple;
	bh=w8885NA/pbze+mdenV7cVzF04YKzDxSbi+WFcXxwDUo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=DaRHnFnZK7FPXMSFJAdoqJ+OUKvVi+SNfG+AZV8ZZ6svrCMKYKUyxUY9so66dl6t6iHDkVjCISNS/wN58e9JcdHaeqLy3roZXT1A9YMun5HN0HKnAAVdWotT9oc57uDkbHS4Wg3OtX5tLrRXNba3FoJSonaYJcaAPnvdmvXASYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: cratiu@nvidia.com,
	gal@nvidia.com,
	ozsh@nvidia.com,
	vladbu@nvidia.com,
	fw@strlen.de,
	sven.auhagen@voleatech.de
Subject: [PATCH nf 2/2] netfilter: flowtable: use UDP timeout after flow teardown
Date: Mon, 18 Mar 2024 10:57:10 +0100
Message-Id: <20240318095710.12756-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Do not subtract flow timeout from UDP timeout, simply use UDP timeout
instead. Users can tweak UDP conntrack timeouts leading to zero
conntrack timeout when handing over the flow back to classic conntrack
path.

Fixes: e5eaac2beb54 ("netfilter: flowtable: fix TCP flow teardown")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
Follow up patch after:
[nf] netfilter: flowtable: infer TCP state and timeout before flow teardown
which should have been 1/2.

 net/netfilter/nf_flow_table_core.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 481fe3d96bbc..21286775cb32 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -165,7 +165,7 @@ void flow_offload_route_init(struct flow_offload *flow,
 }
 EXPORT_SYMBOL_GPL(flow_offload_route_init);
 
-static s32 flow_offload_fixup_tcp(struct net *net, struct nf_conn *ct,
+static u32 flow_offload_fixup_tcp(struct net *net, struct nf_conn *ct,
 				  enum tcp_conntrack tcp_state)
 {
 	struct nf_tcp_net *tn = nf_tcp_pernet(net);
@@ -187,7 +187,7 @@ static void flow_offload_fixup_ct(struct nf_conn *ct)
 {
 	struct net *net = nf_ct_net(ct);
 	int l4num = nf_ct_protonum(ct);
-	s32 timeout;
+	u32 timeout;
 
 	if (l4num == IPPROTO_TCP) {
 		timeout = flow_offload_fixup_tcp(net, ct,
@@ -199,14 +199,10 @@ static void flow_offload_fixup_ct(struct nf_conn *ct)
 			UDP_CT_REPLIED : UDP_CT_UNREPLIED;
 
 		timeout = tn->timeouts[state];
-		timeout -= tn->offload_timeout;
 	} else {
 		return;
 	}
 
-	if (timeout < 0)
-		timeout = 0;
-
 	if (nf_flow_timeout_delta(READ_ONCE(ct->timeout)) > (__s32)timeout)
 		WRITE_ONCE(ct->timeout, nfct_time_stamp + timeout);
 }
-- 
2.30.2

