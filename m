Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 349E5433BDB;
	Wed,  8 Jul 2026 14:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783519472; cv=none; b=Ji9pYkjoGWtbcl2iojs4j7jPqhD7TXsq79sBiZUJNmxOqqcjWHdOc/+0hGHf7y5fiuI9rXZUWQ+3YBzlj8ZauIhz/lLI1vMNx571nM3IZbvrCYXAPSp9TyxsYyjOnlGwXNcJmSCrtVJPIXNZ7l/T4F1nLPPl0dRzPQ4Sc2x78iQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783519472; c=relaxed/simple;
	bh=s3ebqMNnMXCUHEafdqNq86th0ochiDig3JoEuJIKfTo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dR3oZih/n1tRVU0DbHO37CR2pp3r40lg62AwXwUAlAzygWkQbrcFOO+ZEZJnQvTLeI7ePkINtbLKuS5WBxaPnbHwJKCMw1p5WnQxeC7AlLAVnMZF1QWS5y2petDW/CA3jIzo1UVmMSPZGaFUKPM+m+6xpbfpzRpWByehsth0s90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id A315A60EEF; Wed, 08 Jul 2026 16:04:27 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net 16/17] ipvs: use parsed transport offset in SCTP state lookup
Date: Wed,  8 Jul 2026 16:03:08 +0200
Message-ID: <20260708140309.19633-17-fw@strlen.de>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260708140309.19633-1-fw@strlen.de>
References: <20260708140309.19633-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>

set_sctp_state() reads the SCTP chunk header again in order to drive the
IPVS SCTP state table. For IPv6 it computes the offset with
sizeof(struct ipv6hdr), while the surrounding IPVS code uses iph.len from
ip_vs_fill_iph_skb(), where ipv6_find_hdr() has already skipped
extension headers and found the real transport header.

This makes the state machine read from the wrong offset for IPv6 SCTP
packets that carry extension headers. For example, an INIT packet with an
8-byte destination options header can be scheduled correctly by
sctp_conn_schedule(), but set_sctp_state() reads the first byte of the
SCTP verification tag as a DATA chunk type. The connection then moves
from NONE to ESTABLISHED instead of INIT1, gets the longer established
timeout, and updates the active/inactive destination counters
incorrectly. This happens even though the SCTP handshake has not
completed.

Use the parsed transport offset passed down from ip_vs_set_state() for
the SCTP chunk-header lookup. For IPv4 and IPv6 packets without
extension headers this preserves the existing offset.

Fixes: 2906f66a5682 ("ipvs: SCTP Trasport Loadbalancing Support")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/netdev/20260705123040.35755-1-zhaoyz24@mails.tsinghua.edu.cn/
Reported-by: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
Reported-by: Yuxiang Yang <yangyx22@mails.tsinghua.edu.cn>
Reported-by: Ao Wang <wangao@seu.edu.cn>
Reported-by: Xuewei Feng <fengxw06@126.com>
Reported-by: Qi Li <qli01@tsinghua.edu.cn>
Reported-by: Ke Xu <xuke@tsinghua.edu.cn>
Assisted-by: Claude Code:GLM-5.2
Signed-off-by: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
Acked-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/ipvs/ip_vs_proto_sctp.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_proto_sctp.c b/net/netfilter/ipvs/ip_vs_proto_sctp.c
index 394367b7b388..c67317be17df 100644
--- a/net/netfilter/ipvs/ip_vs_proto_sctp.c
+++ b/net/netfilter/ipvs/ip_vs_proto_sctp.c
@@ -372,20 +372,15 @@ static const char *sctp_state_name(int state)
 
 static inline void
 set_sctp_state(struct ip_vs_proto_data *pd, struct ip_vs_conn *cp,
-		int direction, const struct sk_buff *skb)
+		int direction, const struct sk_buff *skb,
+		unsigned int iph_len)
 {
 	struct sctp_chunkhdr _sctpch, *sch;
 	unsigned char chunk_type;
 	int event, next_state;
-	int ihl, cofs;
-
-#ifdef CONFIG_IP_VS_IPV6
-	ihl = cp->af == AF_INET ? ip_hdrlen(skb) : sizeof(struct ipv6hdr);
-#else
-	ihl = ip_hdrlen(skb);
-#endif
+	int cofs;
 
-	cofs = ihl + sizeof(struct sctphdr);
+	cofs = iph_len + sizeof(struct sctphdr);
 	sch = skb_header_pointer(skb, cofs, sizeof(_sctpch), &_sctpch);
 	if (sch == NULL)
 		return;
@@ -472,7 +467,7 @@ sctp_state_transition(struct ip_vs_conn *cp, int direction,
 		unsigned int iph_len)
 {
 	spin_lock_bh(&cp->lock);
-	set_sctp_state(pd, cp, direction, skb);
+	set_sctp_state(pd, cp, direction, skb, iph_len);
 	spin_unlock_bh(&cp->lock);
 }
 
-- 
2.54.0

