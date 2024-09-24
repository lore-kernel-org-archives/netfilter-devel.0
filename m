Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F11D4A3E
	for <netfilter-devel@vger.kernel.org>; Tue, 24 Sep 2024 19:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727207147; cv=none; b=tkbnYbGTFDxKy6jYwjU3RvRbsT2+IT5xxrMC4HR6iX98vCy6hkZbrpELMNd5U0YYxJfH8p11r+n3en6ec8jZrx4z2YWd5VOHWSEfSprD6yHpL8Q2HGU/a5jlFOC7twUOXCi4szqCH0wCxBrX9nHny+jzup46IkhqjLoljrTfQiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727207147; c=relaxed/simple;
	bh=0SWGtm8bcI2oGw6w4u3ecbRC23Zym7HEB/pss95ggqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T55Cb5HWkh59Orp3bLDQrLtKXaMSgfNKpG0djvavkZgfgKh7nBaYzYQd3pZj4G/5N+NPnfFF+B9CNfxaf34x1me3DjUnGcBS7a5uZajBwEw/rjCn/e7Ss0YUVL3XAkBBxKQd3YH2OTKj87QRnEaQUZ41vRJmOi6wkZSYmjqaTv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1stBTj-0004nT-EV; Tue, 24 Sep 2024 21:45:43 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: cmi@nvidia.com,
	nbd@nbd.name,
	sven.auhagen@voleatech.de,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 1/7] netfilter: nft_flow_offload: clear tcp MAXACK flag before moving to slowpath
Date: Tue, 24 Sep 2024 21:44:09 +0200
Message-ID: <20240924194419.29936-2-fw@strlen.de>
X-Mailer: git-send-email 2.44.2
In-Reply-To: <20240924194419.29936-1-fw@strlen.de>
References: <20240924194419.29936-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This state reset is racy, no locks are held here.

Since commit
8437a6209f76 ("netfilter: nft_flow_offload: set liberal tracking mode for tcp"),
the window checks are disabled for normal data packets, but MAXACK flag
is checked when validating TCP resets.

Clear the flag so tcp reset validation checks are ignored.

Signed-off-by: Florian Westphal <fw@strlen.de>
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
2.44.2

