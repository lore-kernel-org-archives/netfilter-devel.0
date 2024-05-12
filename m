Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7427C4595D;
	Sun, 12 May 2024 16:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715530492; cv=none; b=pq3xWz8boLQh8ho5jXEfyAHL07uU0CJduoIzgEe4TxqVTLN4QPrPGIKOYA7mY+8ID8AX7MfOGBoxkGjEWzk3BH134+aIdYk+QcMGTen3nukCzlUjMyXkmcambQYRhiIyvfIpw+mASaW8zFx3dedBPY+Xb8jjNNilv1FnWPeEl0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715530492; c=relaxed/simple;
	bh=WXfcRZ0OmvnIg7MIRxsaSVCHJ0p6POgQcKFE3DPYhlU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ay8uafSEGlpO+ru/kkA6QI4jvl9YJcE/wS769D3iW8bTw2f5bFY67lyLWP6iaLled7q4/TmOlM2bWF2sdcH7gVF4HmlLZKQf/OOhdxoak37gwUIG+nW78ZcouS5FZ+BxJTp51rAk9Asfa9Zu+ubvg04EUoIbYzTOL6462M+QCF8=
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
Subject: [PATCH net-next 04/17] netfilter: conntrack: dccp: try not to drop skb in conntrack
Date: Sun, 12 May 2024 18:14:23 +0200
Message-Id: <20240512161436.168973-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240512161436.168973-1-pablo@netfilter.org>
References: <20240512161436.168973-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jason Xing <kernelxing@tencent.com>

It would be better not to drop skb in conntrack unless we have good
alternatives. So we can treat the result of testing skb's header
pointer as nf_conntrack_tcp_packet() does.

Signed-off-by: Jason Xing <kernelxing@tencent.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_proto_dccp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_dccp.c b/net/netfilter/nf_conntrack_proto_dccp.c
index e2db1f4ec2df..ebc4f733bb2e 100644
--- a/net/netfilter/nf_conntrack_proto_dccp.c
+++ b/net/netfilter/nf_conntrack_proto_dccp.c
@@ -525,7 +525,7 @@ int nf_conntrack_dccp_packet(struct nf_conn *ct, struct sk_buff *skb,
 
 	dh = skb_header_pointer(skb, dataoff, sizeof(*dh), &_dh.dh);
 	if (!dh)
-		return NF_DROP;
+		return -NF_ACCEPT;
 
 	if (dccp_error(dh, skb, dataoff, state))
 		return -NF_ACCEPT;
@@ -533,7 +533,7 @@ int nf_conntrack_dccp_packet(struct nf_conn *ct, struct sk_buff *skb,
 	/* pull again, including possible 48 bit sequences and subtype header */
 	dh = dccp_header_pointer(skb, dataoff, dh, &_dh);
 	if (!dh)
-		return NF_DROP;
+		return -NF_ACCEPT;
 
 	type = dh->dccph_type;
 	if (!nf_ct_is_confirmed(ct) && !dccp_new(ct, skb, dh, state))
-- 
2.30.2

