Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3F053A1CEA;
	Fri,  1 May 2026 12:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777638176; cv=none; b=IDSbFo1FjunjCsSuLvNdiULjdGD3ec/34fEPpetQtZmG2PyyUjHvutLwj6wSUm62PBQjeR+USYw2QduWK+8C4fTt5FmiVLgPZo3KtiP5dKjNlmZcK8uXnlZowejhFkpWIat56uJplqE/FXFodfJJ5JEMGYFk0SHTQSttrkGlo4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777638176; c=relaxed/simple;
	bh=iGCgKKAZjuVFe8NtGypebr2FL+6Q+sjCRSubmoZeE3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FhftahwUmP3yrBQjfISxvDewPcSLfJFqAEyHlWwSxoRjt5DNadJJCd0WPJW8jyRn+wx8j2VggoaznIddIlOCYx9Gxs9Kx5ltUcwe9YHSR9g9ejND28YBfDsu+XZKzS/azQbbCySDmC9a+ml01aVHOOvcRUSKHcXtAX/1joaVag0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=wKqt8mZ+; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="wKqt8mZ+"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id B54E060253;
	Fri,  1 May 2026 14:22:52 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1777638173;
	bh=6S4r3Pu5p6LNj+T8frNczIDvTk2FQ6ZslXgCCio8jsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wKqt8mZ++gkA62ec7xICkI7komtSl5D3tbV3w6ggzEDDeVYSqfqc4j3giEBhTOlio
	 Z68583Lrs221Rr1bNRzEje5gh7ipCVdZ7IkxIPP9b1XBVNtEtk853GJGJC36b020EU
	 Mqfmqt0d8+24PL24oNYnV5GiIT6piZECZ/1b+WBq/6Po7HcN4FcsI+t3/hIdV27+SB
	 rlqlCWw706DRCVVfQIXdVMH8v+2+KMgbxRpP3SB+EVnAqs+FsMF55ZotD2K71H4uHj
	 u/+lrWWfYb1hi/LqUFcWZ7bCaSE+0316BdntwwmNgjE1x/e3faw0useQ/GBWUMhj3N
	 7JxWyssZvUA2Q==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 08/14] netfilter: nf_socket: skip socket lookup for non-first fragments
Date: Fri,  1 May 2026 14:22:31 +0200
Message-ID: <20260501122237.296262-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260501122237.296262-1-pablo@netfilter.org>
References: <20260501122237.296262-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Fernando Fernandez Mancera <fmancera@suse.de>

Both nft_socket and xt_socket relies on L4 headers to perform socket
lookup in the slow path. For fragmented packets, while the IP protocol
remains constant across all fragments, only the first fragment contains
the actual L4 header.

As the expression/match could be attached to a chain with a priority
lower than -400, it could bypass defragmentation.

Add a check for fragmentation in the lookup functions directly so the
problem is handled for both nft_socket and xt_socket at the same time.
In addition, future users of the functions would not need to care about
this.

Fixes: 902d6a4c2a4f ("netfilter: nf_defrag: Skip defrag if NOTRACK is set")
Fixes: 554ced0a6e29 ("netfilter: nf_tables: add support for native socket matching")
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter/nf_socket_ipv4.c | 3 +++
 net/ipv6/netfilter/nf_socket_ipv6.c | 5 +++--
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/nf_socket_ipv4.c b/net/ipv4/netfilter/nf_socket_ipv4.c
index 5080fa5fbf6a..f9c6755f5ec5 100644
--- a/net/ipv4/netfilter/nf_socket_ipv4.c
+++ b/net/ipv4/netfilter/nf_socket_ipv4.c
@@ -94,6 +94,9 @@ struct sock *nf_sk_lookup_slow_v4(struct net *net, const struct sk_buff *skb,
 #endif
 	int doff = 0;
 
+	if (ntohs(iph->frag_off) & IP_OFFSET)
+		return NULL;
+
 	if (iph->protocol == IPPROTO_UDP || iph->protocol == IPPROTO_TCP) {
 		struct tcphdr _hdr;
 		struct udphdr *hp;
diff --git a/net/ipv6/netfilter/nf_socket_ipv6.c b/net/ipv6/netfilter/nf_socket_ipv6.c
index ced8bd44828e..893f2aeb4711 100644
--- a/net/ipv6/netfilter/nf_socket_ipv6.c
+++ b/net/ipv6/netfilter/nf_socket_ipv6.c
@@ -100,6 +100,7 @@ struct sock *nf_sk_lookup_slow_v6(struct net *net, const struct sk_buff *skb,
 	const struct in6_addr *daddr = NULL, *saddr = NULL;
 	struct ipv6hdr *iph = ipv6_hdr(skb), ipv6_var;
 	struct sk_buff *data_skb = NULL;
+	unsigned short fragoff = 0;
 	int doff = 0;
 	int thoff = 0, tproto;
 #if IS_ENABLED(CONFIG_NF_CONNTRACK)
@@ -107,8 +108,8 @@ struct sock *nf_sk_lookup_slow_v6(struct net *net, const struct sk_buff *skb,
 	struct nf_conn const *ct;
 #endif
 
-	tproto = ipv6_find_hdr(skb, &thoff, -1, NULL, NULL);
-	if (tproto < 0) {
+	tproto = ipv6_find_hdr(skb, &thoff, -1, &fragoff, NULL);
+	if (tproto < 0 || fragoff) {
 		pr_debug("unable to find transport header in IPv6 packet, dropping\n");
 		return NULL;
 	}
-- 
2.47.3

