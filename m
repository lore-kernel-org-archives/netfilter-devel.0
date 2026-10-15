Received: from mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EDD54A4EE3
	for <netfilter-devel@vger.kernel.org>; Thu, 15 Oct 2026 08:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792054576; cv=none; b=n/tWGXm4/klr/c1xIZLwuWkiTbOMMPdTuP9PlMNtlp2S9dBFO9IjvUkPbsdh4n8gsq3YwOopeyx/j0vTt8uQDqJLhnGiW6Bt7BfGInRYEImEoFtswFM0p1d2xHhwEeIBbML3v2EshL/tOrn7Q3ivvlllPKlEyGfp1TkGp8c9Y00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792054576; c=relaxed/simple;
	bh=tB2BgHLFyl6D2g/JIU2o35GL7Ibd5QUxFkroC66zz7U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=boYyWaPT8zzwLdIowc2s2QyE/TH1jhp5EP6NDU8l5DJJoND4BjqJuFj+57HaHw2WeCubWE/LVoAqN+LYMD+qzGKvbFrfQHBcOwQKKPLR9nWeUEGAiuILt5MZvFJTyB2QozmaaKZgJo1teZvhc0Bo5jtQd15viv1hIQ9DVSO9ys0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=PAOmTlW2; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="PAOmTlW2"
X-Envelope-To: netfilter-devel@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=tB2BgHLFyl6D2g/JIU2o35GL7Ibd5QUxFkroC66zz7U=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792054571; v=1; x=1792659371;
 b=PAOmTlW2ajxAOFiN4lLtgm+S9Y5wNKrSzvbYltUtAiDaBuk4ubm7V1EnQK59a0QmZbb5x61N
 gc/mCNI+NDTaOSsTFAIRCaLk4ygaiAkHbn80olh1xCKES6qmNPZTRAkK2WK43nRiU0AVhZuZAJo
 NB5/wMEHi+CP+6NuNdi8gv6c=
X-Envelope-To: netfilter-devel@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id e755357549c3f6a4;
	Thu, 15 Oct 2026 08:56:11 +0000
X-Mizu-Trace-ID: e755357549c3f6a4
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
Subject: [PATCH nf-next 1/2] netfilter: flowtable: use PPPoE GSO handler
Date: Thu, 15 Oct 2026 16:56:01 +0800
Message-ID: <20261015085603.1170-1-qingfang.deng@linux.dev>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Flowtable currently segments GSO packets before adding encapsulation
headers, calling nf_flow_encap_push() separately for each segment.

Since commit 55a5d8fca836 ("net: pppoe: implement GRO/GSO support"), the
PPPoE GSO handler can segment encapsulated packets and update the PPPoE
payload length in each resulting segment.

Push the encapsulation headers before segmentation and let the PPPoE GSO
handler update them. This removes the per-segment encapsulation step
from nf_flow_encap_gso_xmit() while keeping the software segmentation.

Signed-off-by: Qingfang Deng <qingfang.deng@linux.dev>
---
 net/netfilter/nf_flow_table_ip.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index c8c29a9a1684..ce69f4e741e2 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -767,12 +767,6 @@ static unsigned int nf_flow_encap_gso_xmit(struct net *net, struct sk_buff *skb,
 
 	skb_list_walk_safe(segs, segs, nskb) {
 		skb_mark_not_on_list(segs);
-
-		if (nf_flow_encap_push(segs, xmit->tuple, xmit->outdev) < 0) {
-			kfree_skb(segs);
-			kfree_skb_list(nskb);
-			return NF_STOLEN;
-		}
 		__nf_flow_queue_xmit(net, segs, xmit);
 	}
 
@@ -783,11 +777,12 @@ static unsigned int nf_flow_queue_xmit(struct net *net, struct sk_buff *skb,
 				       struct nf_flow_xmit *xmit)
 {
 	if (xmit->tuple->encap_num) {
+		if (nf_flow_encap_push(skb, xmit->tuple, xmit->outdev) < 0)
+			return NF_DROP;
+
 		if (skb_is_gso(skb) && xmit->needs_gso_segment)
 			return nf_flow_encap_gso_xmit(net, skb, xmit);
 
-		if (nf_flow_encap_push(skb, xmit->tuple, xmit->outdev) < 0)
-			return NF_DROP;
 	}
 
 	__nf_flow_queue_xmit(net, skb, xmit);
-- 
2.43.0

