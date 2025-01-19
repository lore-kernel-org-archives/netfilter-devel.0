Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81ACC1DFDA5;
	Sun, 19 Jan 2025 17:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737307270; cv=none; b=iiBUGmTP7j+X5LMQv2eOMen+76jw7xJamehJekvFHjVVc+/fzhIBOKDsb+3Kxy2DF1O8d7nBxA0mC57XMdQriMG0uwePq0kwjLY9yk5z5TCKyg8FBpgjLMidtmySqBxrF782j02diU18T6yhADwim0bYVnn7MvJKML7XUZA9ey4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737307270; c=relaxed/simple;
	bh=bf4U92hBPyNGdkOqWr/Gm0rDjv1jB2B0iEc2B3V9aSI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Hwb9Ltu10I2jdkvVCHE3Dltcij6j3NdvenpQeqZz6sNg86Xp6hTyQTnumwZ1D96wxdrqI8++tM4zL6y75bigiCtb9P3ASFd5rJdBgWr14Al5TdiG3YZRDa3MW1s+99qKvqhBVamMhYREX40xqpVZEnqTX+c67P5/OnCTUP4uruc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de
Subject: [PATCH net-next 09/14] netfilter: nft_flow_offload: clear tcp MAXACK flag before moving to slowpath
Date: Sun, 19 Jan 2025 18:20:46 +0100
Message-Id: <20250119172051.8261-10-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250119172051.8261-1-pablo@netfilter.org>
References: <20250119172051.8261-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

This state reset is racy, no locks are held here.

Since commit
8437a6209f76 ("netfilter: nft_flow_offload: set liberal tracking mode for tcp"),
the window checks are disabled for normal data packets, but MAXACK flag
is checked when validating TCP resets.

Clear the flag so tcp reset validation checks are ignored.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_core.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index df72b0376970..bdde469bbbd1 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -161,10 +161,20 @@ void flow_offload_route_init(struct flow_offload *flow,
 }
 EXPORT_SYMBOL_GPL(flow_offload_route_init);
 
-static void flow_offload_fixup_tcp(struct ip_ct_tcp *tcp)
+static void flow_offload_fixup_tcp(struct nf_conn *ct)
 {
+	struct ip_ct_tcp *tcp = &ct->proto.tcp;
+
+	spin_lock_bh(&ct->lock);
+	/* Conntrack state is outdated due to offload bypass.
+	 * Clear IP_CT_TCP_FLAG_MAXACK_SET, otherwise conntracks
+	 * TCP reset validation will fail.
+	 */
 	tcp->seen[0].td_maxwin = 0;
+	tcp->seen[0].flags &= ~IP_CT_TCP_FLAG_MAXACK_SET;
 	tcp->seen[1].td_maxwin = 0;
+	tcp->seen[1].flags &= ~IP_CT_TCP_FLAG_MAXACK_SET;
+	spin_unlock_bh(&ct->lock);
 }
 
 static void flow_offload_fixup_ct(struct nf_conn *ct)
@@ -176,7 +186,7 @@ static void flow_offload_fixup_ct(struct nf_conn *ct)
 	if (l4num == IPPROTO_TCP) {
 		struct nf_tcp_net *tn = nf_tcp_pernet(net);
 
-		flow_offload_fixup_tcp(&ct->proto.tcp);
+		flow_offload_fixup_tcp(ct);
 
 		timeout = tn->timeouts[ct->proto.tcp.state];
 		timeout -= tn->offload_timeout;
-- 
2.30.2

