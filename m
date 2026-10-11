Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D38C84052A2;
	Sun, 11 Oct 2026 22:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791756030; cv=none; b=GoUQUrwLytNgT7T91lxinI6v3WEhSR1IqydtNDc+tbnVDEexSckY3sf8s1bBWko2rnK+aF9NQfCl+uOhVwDaH9Db3pHQ16Cy6zEGzcnYCaRksd0EsEnbPrMjE2zInSi5zuAO6pgiw9svlcw7u05c0w2HBfVyCEBQKoXhmu+82Rc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791756030; c=relaxed/simple;
	bh=z1KvmLDOIDdSwfXviF5qSAaGc2XNRuleRb8XhWM/eBo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HjYEHwWWupFGr3MlaMDAp7f+tNDnvB6vpt02d1U4MGLYM7kREl3HOVx0fTOS5EhQocTogmzZ8vaSk1xxMZzOwDKYhJSbsqsItoMbQ5KN3Cod6OhZH3OgrVaZeOg+FYkxZWz1d+lB0WnrIcSI/zx9isGjrJDqogOQZnEx85oOd/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=awYMVpoy; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="awYMVpoy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1791756024;
	bh=Sy2M0QI554MDVbivdO9EjRACH6DW3sC2H69veOZRhrw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=awYMVpoybAQTtnknMIyTUU3lHtX8ekDDPH2vMOuN22di15GV/xsfRO/7czF+c+oxM
	 FGjmSajC5dEBz6rZwiGzoi6JY89O43ZMrK1XbPgKxb0icc4GFuWbslPCiSpwHbTgRw
	 hoXqUbByPcQ0DxlUTDstl3324jUrVXn/QZPfUhSHXzuijxaxetJFWhcBPpf0zStUnn
	 pRjusWChsRc/JCg/FqAJn8ZDkyXIFRVpW+dZECdTQYdjSe4qeqY7insQEUqqV7dEvH
	 H6jv6QKdI1hdDxMCtgCIrzg6epC0RCivU6344ZH203r3FGiLoDPwQMfJXdhmvzPk3c
	 XxEqgd2jWkW6A==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 70A7760060;
	Mon, 12 Oct 2026 00:00:24 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@kernel.org,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net-next 15/15] netfilter: nft_exthdr: avoid 60 bytes stack buffer in TCP option mangling
Date: Sun, 11 Oct 2026 23:59:53 +0200
Message-ID: <20261011215953.1334630-16-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261011215953.1334630-1-pablo@netfilter.org>
References: <20261011215953.1334630-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Fernando Fernandez Mancera <fmancera@suse.de>

nft_exthdr_tcp_set_eval() and nft_exthdr_tcp_strip_eval() fetched the
TCP header and options through nft_tcp_header_pointer(), which calls
skb_header_pointer() a second time for the full tcphdr_len into a 60
bytes stack buffer. Since commit 28427f368f0e ("netfilter: nft_exthdr:
Fix non-linear header modification") both functions then call
skb_ensure_writable() and re-read the header from skb->data, so the
buffer was never used.

Only the 20 bytes fixed header is needed to learn tcphdr_len, so fetch
just that, validate the length as before, and let skb_ensure_writable()
pull the rest. This also drops the 60 bytes stack buffer from both
functions.

Comparison of performance in mpps:

  op       linear/non-linear     before    after    delta
==================================================================
   set,         non-linear       4.193     4.348    +3.7% mpps
   strip,       non-linear       4.184     4.434    +6.0% mpps
   set,         linear           5.302     5.427    +2.4% mpps
   strip,       linear           5.452     5.527    +1.4% mpss

Comparison of performance in ns/expression:

  op       linear/non-linear     before    after    delta
==================================================================
   set,         non-linear       34.6      25.3     -9.4  ns
   strip,       non-linear       35.2      20.8     -14.3 ns
   set,         linear           23.6      19.7     -3.9  ns
   strip,       linear           22.9      19.8     -3.1  ns

./scripts/bloat-o-meter exthdr_before.o exthdr_after.o
add/remove: 0/1 grow/shrink: 3/0 up/down: 233/-207 (26)
Function                                     old     new   delta
nft_exthdr_tcp_eval                          792     946    +154
nft_exthdr_tcp_strip_eval                    825     891     +66
nft_exthdr_tcp_set_eval                      602     615     +13
nft_tcp_header_pointer.part.constprop        207       -    -207
Total: Before=6527, After=6553, chg +0.40%

This also allow the compiler to inline nft_tcp_header_pointer inside
nft_exthdr_tcp_eval() which could yield some minimal performance gain.

Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_exthdr.c | 26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
index 3492426dccf7..861bab93f435 100644
--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -233,16 +233,23 @@ static void nft_exthdr_tcp_set_eval(const struct nft_expr *expr,
 				    struct nft_regs *regs,
 				    const struct nft_pktinfo *pkt)
 {
-	u8 buff[sizeof(struct tcphdr) + MAX_TCP_OPTION_SPACE];
 	struct nft_exthdr *priv = nft_expr_priv(expr);
 	unsigned int i, optl, tcphdr_len, offset;
-	struct tcphdr *tcph;
+	struct tcphdr *tcph, _tcph;
 	u8 *opt;
 
-	tcph = nft_tcp_header_pointer(pkt, sizeof(buff), buff, &tcphdr_len);
+	if (pkt->tprot != IPPROTO_TCP || pkt->fragoff)
+		goto err;
+
+	tcph = skb_header_pointer(pkt->skb, nft_thoff(pkt), sizeof(_tcph), &_tcph);
 	if (!tcph)
 		goto err;
 
+	tcphdr_len = __tcp_hdrlen(tcph);
+	if (tcphdr_len < sizeof(*tcph) ||
+	    tcphdr_len > sizeof(*tcph) + MAX_TCP_OPTION_SPACE)
+		goto err;
+
 	if (skb_ensure_writable(pkt->skb, nft_thoff(pkt) + tcphdr_len))
 		goto err;
 
@@ -313,16 +320,23 @@ static void nft_exthdr_tcp_strip_eval(const struct nft_expr *expr,
 				      struct nft_regs *regs,
 				      const struct nft_pktinfo *pkt)
 {
-	u8 buff[sizeof(struct tcphdr) + MAX_TCP_OPTION_SPACE];
 	struct nft_exthdr *priv = nft_expr_priv(expr);
 	unsigned int i, tcphdr_len, optl;
-	struct tcphdr *tcph;
+	struct tcphdr *tcph, _tcph;
 	u8 *opt;
 
-	tcph = nft_tcp_header_pointer(pkt, sizeof(buff), buff, &tcphdr_len);
+	if (pkt->tprot != IPPROTO_TCP || pkt->fragoff)
+		goto err;
+
+	tcph = skb_header_pointer(pkt->skb, nft_thoff(pkt), sizeof(_tcph), &_tcph);
 	if (!tcph)
 		goto err;
 
+	tcphdr_len = __tcp_hdrlen(tcph);
+	if (tcphdr_len < sizeof(*tcph) ||
+	    tcphdr_len > sizeof(*tcph) + MAX_TCP_OPTION_SPACE)
+		goto err;
+
 	if (skb_ensure_writable(pkt->skb, nft_thoff(pkt) + tcphdr_len))
 		goto drop;
 
-- 
2.47.3

