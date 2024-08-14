Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61B571494D6;
	Wed, 14 Aug 2024 22:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723674055; cv=none; b=evoF5AAoyIhJWQ0u6hmQokCTp/1Jf8Nn+SGK0k5d11J/8RIyKAGaCFrHBI8RUpxKaDpshrEdvGlDuST8lMOvcqSM2hCBIlJH3SfIbK+iRf269UbnxmwRHhgf3La4/Bjw1MwhBOpnEs6AuNPUbh5OlxFMiM8zIL+5nkAjGGb2p8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723674055; c=relaxed/simple;
	bh=FNLLVejBIWpvClxKSF4+IrpX1L+lQ9397HafDXBit1o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YVneXMuITkJ2Qe04+NSJz+3G+eDOiWDXOB36mImHZbE/UPALAZqFeIGMUYo7FWbHFgSg3MfgwVGCGjjwulvMLp0Xq5UCpmLaez5FG6Agkr1Z6KqHP6arTcXtRxNIdAmPOoV4OeklpBhRjmuuUtt5FlDyzzWPBGLO3pq2wAiVTRI=
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
Subject: [PATCH net 1/8] netfilter: allow ipv6 fragments to arrive on different devices
Date: Thu, 15 Aug 2024 00:20:35 +0200
Message-Id: <20240814222042.150590-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240814222042.150590-1-pablo@netfilter.org>
References: <20240814222042.150590-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Tom Hughes <tom@compton.nu>

Commit 264640fc2c5f4 ("ipv6: distinguish frag queues by device
for multicast and link-local packets") modified the ipv6 fragment
reassembly logic to distinguish frag queues by device for multicast
and link-local packets but in fact only the main reassembly code
limits the use of the device to those address types and the netfilter
reassembly code uses the device for all packets.

This means that if fragments of a packet arrive on different interfaces
then netfilter will fail to reassemble them and the fragments will be
expired without going any further through the filters.

Fixes: 648700f76b03 ("inet: frags: use rhashtables for reassembly units")
Signed-off-by: Tom Hughes <tom@compton.nu>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv6/netfilter/nf_conntrack_reasm.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index 6f0844c9315d..4120e67a8ce6 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -154,6 +154,10 @@ static struct frag_queue *fq_find(struct net *net, __be32 id, u32 user,
 	};
 	struct inet_frag_queue *q;
 
+	if (!(ipv6_addr_type(&hdr->daddr) & (IPV6_ADDR_MULTICAST |
+					    IPV6_ADDR_LINKLOCAL)))
+		key.iif = 0;
+
 	q = inet_frag_find(nf_frag->fqdir, &key);
 	if (!q)
 		return NULL;
-- 
2.30.2

