Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8254148CCC;
	Sun, 12 May 2024 16:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715530494; cv=none; b=SdoXtpipzHwy7w40ifJip8C6zhvj1lSXTRovGdAzd4MxotgFxhF8es3N/+EhT2uaEvTRJNzhvSS453W1a9Qm2dLIEsyVIqAT0cTYIXJnv4S2guFnBxBZ1i5+CS5LsuPhNMqp/I5Kw/m1lJ14osMfkEdRT66+FonfW/z/N2SvbD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715530494; c=relaxed/simple;
	bh=1NnJ2nQkUXKA/t8DXQMNFLk9evxmHmqJL6Lr4Dd4T7c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=AOOpSMtxW+XrONIX7gBEw6blaanOZsB+hEJFOK+fTjVOtqa2NK0NAu2Pzfi+Bgix6y6qBVvZnz5mQWlsZCepuoiTcOkcjzz8H9ndcjjLT3mjN1qglYKAlezILeaeAzrPq/o6TLOETKJ67CPYpPSHfOkXsQCScAm+WAVYGdigSt4=
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
Subject: [PATCH net-next 05/17] netfilter: use NF_DROP instead of -NF_DROP
Date: Sun, 12 May 2024 18:14:24 +0200
Message-Id: <20240512161436.168973-6-pablo@netfilter.org>
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

At the beginning in 2009 one patch [1] introduced collecting drop
counter in nf_conntrack_in() by returning -NF_DROP. Later, another
patch [2] changed the return value of tcp_packet() which now is
renamed to nf_conntrack_tcp_packet() from -NF_DROP to NF_DROP. As
we can see, that -NF_DROP should be corrected.

Similarly, there are other two points where the -NF_DROP is used.

Well, as NF_DROP is equal to 0, inverting NF_DROP makes no sense
as patch [2] said many years ago.

[1]
commit 7d1e04598e5e ("netfilter: nf_conntrack: account packets drop by tcp_packet()")
[2]
commit ec8d540969da ("netfilter: conntrack: fix dropping packet after l4proto->packet()")

Signed-off-by: Jason Xing <kernelxing@tencent.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter/iptable_filter.c  | 2 +-
 net/ipv6/netfilter/ip6table_filter.c | 2 +-
 net/netfilter/nf_conntrack_core.c    | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/netfilter/iptable_filter.c b/net/ipv4/netfilter/iptable_filter.c
index b9062f4552ac..3ab908b74795 100644
--- a/net/ipv4/netfilter/iptable_filter.c
+++ b/net/ipv4/netfilter/iptable_filter.c
@@ -44,7 +44,7 @@ static int iptable_filter_table_init(struct net *net)
 		return -ENOMEM;
 	/* Entry 1 is the FORWARD hook */
 	((struct ipt_standard *)repl->entries)[1].target.verdict =
-		forward ? -NF_ACCEPT - 1 : -NF_DROP - 1;
+		forward ? -NF_ACCEPT - 1 : NF_DROP - 1;
 
 	err = ipt_register_table(net, &packet_filter, repl, filter_ops);
 	kfree(repl);
diff --git a/net/ipv6/netfilter/ip6table_filter.c b/net/ipv6/netfilter/ip6table_filter.c
index df785ebda0ca..e8992693e14a 100644
--- a/net/ipv6/netfilter/ip6table_filter.c
+++ b/net/ipv6/netfilter/ip6table_filter.c
@@ -43,7 +43,7 @@ static int ip6table_filter_table_init(struct net *net)
 		return -ENOMEM;
 	/* Entry 1 is the FORWARD hook */
 	((struct ip6t_standard *)repl->entries)[1].target.verdict =
-		forward ? -NF_ACCEPT - 1 : -NF_DROP - 1;
+		forward ? -NF_ACCEPT - 1 : NF_DROP - 1;
 
 	err = ip6t_register_table(net, &packet_filter, repl, filter_ops);
 	kfree(repl);
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index c63868666bd9..6102dc09cdd3 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -2024,7 +2024,7 @@ nf_conntrack_in(struct sk_buff *skb, const struct nf_hook_state *state)
 			goto repeat;
 
 		NF_CT_STAT_INC_ATOMIC(state->net, invalid);
-		if (ret == -NF_DROP)
+		if (ret == NF_DROP)
 			NF_CT_STAT_INC_ATOMIC(state->net, drop);
 
 		ret = -ret;
-- 
2.30.2

