Received: from mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE16C4D90DE
	for <netfilter-devel@vger.kernel.org>; Thu, 15 Oct 2026 08:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792054580; cv=none; b=hX38FU03VfyfsJ3reBGKtOKXcJm+gA/1nEdT0iYQTtfESdnZXs93LFFwHN0O47ynGaz0/2NEXcrFXzzW6AW5KCp0rOU2R4CgWkGnwNeMV8CXTuPNx95VsPF/Mzr11+8XmRmh4lVoX6S7QUmtQKJoEdc8TK9Datj9yGf75uefAVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792054580; c=relaxed/simple;
	bh=bUr05XVeGddQjujnjNuFewb+iUPWllxq2K3a7xSu2+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XdToL9h6sH2znb7L7wAehe7Fi0QYrCB93u4PZxkZ4HZBuufaxJUcIbF9CWvX2ol1XQc7MM13A2ssTgWuIwek6GMY2DB4wxM8TCrCzrGFWISndsC2MjUPaIMr3gN4YQXzt3eSiretoj+1EQZwGk+ydSGmfK684mOgq4ptq8H7MjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Ev0W2+Xf; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Ev0W2+Xf"
X-Envelope-To: netfilter-devel@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=bUr05XVeGddQjujnjNuFewb+iUPWllxq2K3a7xSu2+Q=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792054576; v=1; x=1792659376;
 b=Ev0W2+XfECUhGUdQNkOTaqE8Xv9TXe7Ndtk2tuloTRkGZ6ZAVa+50UbH6v4/O1ercIeU3mDv
 bT3RpDCVIzf7bpyhne/1ZsdFx3KlfU8ccXXi3UnrcNroXNBzQ/JPw43518yHOFayXxoPlwFtak6
 e6d1Zo3uE4DHMLUy6AWHs0Z0=
X-Envelope-To: netfilter-devel@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 0fad598284d665b2;
	Thu, 15 Oct 2026 08:56:16 +0000
X-Mizu-Trace-ID: 0fad598284d665b2
X-Migadu-Flow: FLOW_OUT
From: Qingfang Deng <qingfang.deng@linux.dev>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Felix Fietkau <nbd@nbd.name>,
	Qingfang Deng <qingfang.deng@linux.dev>
Subject: [PATCH nf-next 2/2] netfilter: flowtable: avoid unnecessary linearization for PPPoE
Date: Thu, 15 Oct 2026 16:56:02 +0800
Message-ID: <20261015085603.1170-2-qingfang.deng@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261015085603.1170-1-qingfang.deng@linux.dev>
References: <20261015085603.1170-1-qingfang.deng@linux.dev>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Passing no features to skb_gso_segment() forces nonlinear skb to be
linearized, even when the output device can transmit them directly.

Allow scatter-gather and frag_list payloads during segmentation to avoid
the linearization. dev_queue_xmit() subsequently validates each segment
against the output device's features and linearizes it if necessary.

Signed-off-by: Qingfang Deng <qingfang.deng@linux.dev>
---
 net/netfilter/nf_flow_table_ip.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index ce69f4e741e2..aeef1fb27d70 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -756,7 +756,7 @@ static unsigned int nf_flow_encap_gso_xmit(struct net *net, struct sk_buff *skb,
 {
 	struct sk_buff *segs, *nskb;
 
-	segs = skb_gso_segment(skb, 0);
+	segs = skb_gso_segment(skb, NETIF_F_SG | NETIF_F_FRAGLIST);
 	if (IS_ERR(segs))
 		return NF_DROP;
 
-- 
2.43.0

