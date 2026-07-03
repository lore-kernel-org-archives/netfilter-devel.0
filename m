Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35CA43D565F;
	Fri,  3 Jul 2026 12:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783083467; cv=none; b=BAxWT9HShbqyriOh3n1HjJrCrSFqHmQqZtd4JAfNmiV7HIOzt08iFYEltD0NCe/cC8U5GhxYWAP7e6GHv4U+wbFBQmMnw9kYauPW00QnLz+Ldm8KlpQeemq4Ip1j/663VavEaqFN6UnjHRSz+BN0Va7+pQEo8I3x1bUGLzhBgVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783083467; c=relaxed/simple;
	bh=Kb4ALTYf/Y/FAGkyAUjv28OX9CCgO8l7KlnuD2ffyrU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ezs9dAptll2Q+Ocmf/ZsL5/PkP1lUt0gctJhgEuMEQ/t1u5wyfdFXteSozeXz4cvWe0h18eZ682TKj28a6Ov15Xxb+Cwjg9VJfv2GjRY6dcrP7mp8+Qh/crqL3pLxifg5qSLT5oRi6WovzdlVAzeSihJ+X47Tnrd7G/+IHbq0C4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 3911560687; Fri, 03 Jul 2026 14:57:44 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net 7/9] ipvs: fix PMTU for GUE/GRE tunnel ICMP errors
Date: Fri,  3 Jul 2026 14:57:07 +0200
Message-ID: <20260703125709.16493-8-fw@strlen.de>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260703125709.16493-1-fw@strlen.de>
References: <20260703125709.16493-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>

When an ICMP Fragmentation Needed error is received for a tunneled IPVS
connection, ip_vs_in_icmp() recomputes the MTU that the original packet
can use by subtracting the tunnel overhead from the reported next-hop
MTU.

The current code always subtracts sizeof(struct iphdr), which is only
the IPIP overhead. For GUE and GRE tunnels, ipvs_udp_decap() and
ipvs_gre_decap() already compute the additional tunnel header length,
but that value is scoped to the decapsulation block and is lost before
the ICMP_FRAG_NEEDED handling. As a result, the ICMP error sent back to
the client advertises an MTU that is too large, so PMTUD can fail to
converge for GUE/GRE-tunneled real servers.

With a reported next-hop MTU of 1400, a GUE tunnel currently returns
1380 to the client. The correct value is 1368:

  1400 - sizeof(struct iphdr) - sizeof(struct udphdr) -
  sizeof(struct guehdr)

Hoist the tunnel header length into the main ip_vs_in_icmp() scope and
subtract sizeof(struct iphdr) + ulen in the Fragmentation Needed path.
The IPIP path keeps ulen as 0, so its existing 1400 - 20 = 1380 result
is unchanged.

Fixes: 508f744c0de3 ("ipvs: strip udp tunnel headers from icmp errors")
Cc: stable@vger.kernel.org
Reported-by: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
Reported-by: Yuxiang Yang <yangyx22@mails.tsinghua.edu.cn>
Reported-by: Ao Wang <wangao@seu.edu.cn>
Reported-by: Xuewei Feng <fengxw06@126.com>
Reported-by: Qi Li <qli01@tsinghua.edu.cn>
Reported-by: Ke Xu <xuke@tsinghua.edu.cn>
Assisted-by: Claude-Code:GLM-5.2
Signed-off-by: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
Acked-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/ipvs/ip_vs_core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index d40b404c1bf6..906f2c361676 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -1767,6 +1767,7 @@ ip_vs_in_icmp(struct netns_ipvs *ipvs, struct sk_buff *skb, int *related,
 	bool tunnel, new_cp = false;
 	union nf_inet_addr *raddr;
 	char *outer_proto = "IPIP";
+	int ulen = 0;
 
 	*related = 1;
 
@@ -1831,7 +1832,6 @@ ip_vs_in_icmp(struct netns_ipvs *ipvs, struct sk_buff *skb, int *related,
 		   /* Error for our tunnel must arrive at LOCAL_IN */
 		   (skb_rtable(skb)->rt_flags & RTCF_LOCAL)) {
 		__u8 iproto;
-		int ulen;
 
 		/* Non-first fragment has no UDP/GRE header */
 		if (unlikely(cih->frag_off & htons(IP_OFFSET)))
@@ -1936,8 +1936,8 @@ ip_vs_in_icmp(struct netns_ipvs *ipvs, struct sk_buff *skb, int *related,
 				if (dest_dst)
 					mtu = dst_mtu(dest_dst->dst_cache);
 			}
-			if (mtu > 68 + sizeof(struct iphdr))
-				mtu -= sizeof(struct iphdr);
+			if (mtu > 68 + sizeof(struct iphdr) + ulen)
+				mtu -= sizeof(struct iphdr) + ulen;
 			info = htonl(mtu);
 		}
 		/* Strip outer IP, ICMP and IPIP/UDP/GRE, go to IP header of
-- 
2.54.0

