Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5671B425862;
	Fri, 24 Jul 2026 10:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784890188; cv=none; b=CWUVzqP64yPCl9pMGtM84TWBwvayzghkO1fRydUgd2tpVFBGjGmD6ieY0G27fTEz2nWUbW2jCG+Ggr430cXevNEAVilF72citqaWDzTi7amAjpw6XYTretB59rT0akDBDFLBXmglG13SG9i0RPnJOL5t9fvxPFyoC6EVFOVXuWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784890188; c=relaxed/simple;
	bh=RplB1erNEucwupimED87J+PI4HjKBVGM6i7toleyqUs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OJSHnuRdGIwD1R/Ok0m7kKpSJcb86Mk24P7MMBtmJp3z1dZo6tdEF9b9qexYccg5Nd1Om27BMEQmLU+hU16XtaZfBTyUbhyj+nlYVtpe9QBM70/GLbFN1Z9X/5EqqHZnBDup8pemlEGcnJkE1iT8NDJOih7V3RMFRA/1lGmuhR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=blRyZClo; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="blRyZClo"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 230E3601A2;
	Fri, 24 Jul 2026 12:49:45 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1784890185;
	bh=32qL1dGYbSc3spmxsxPnzqNoWahOdezdLylMTE83INk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=blRyZClojJ4Z0tWcHji/cwwxinQ3OnN1NqdN1Gr+o2yg8EJ8HJE8NjsEQLZEiZ9IE
	 koELX/FXHf+vnydsR69Y9fU4kK5ryqwttkrQN0TVuFwPLUwaiDe4qfq4lXhV811IDL
	 vIlYsMdclzLRaZhkovih7xD6xMk41aEH/jeUuiS71myk2LRhXmzif6iy8JjqwqfVAO
	 NyImjvwz4yZeLf7csopqAGakAaY8M/vGCqfcfHHcgYETu6fB0Q8yjMLQqswK02OMEB
	 N/8RFw2MRwfM1EJ/FpIk3KQEjMdmUva1ivraG1SNqq964NQhZ75vzPsTlG+WO6ugGN
	 hW6cEVZR8aaWg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 3/7] netfilter: nf_nat_sip: rewind offset when NAT shrinks the packet
Date: Fri, 24 Jul 2026 12:49:28 +0200
Message-ID: <20260724104932.437729-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260724104932.437729-1-pablo@netfilter.org>
References: <20260724104932.437729-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

sashiko says:
 If map_addr() changes the packet length, such as when the public NAT IP
 string is shorter or longer than the internal IP, coff will still point to
 the offset relative to the pre-mangled packet.
 If the packet shrinks, coff could overshoot the correct position,
 potentially causing the next ct_sip_parse_header_uri() call to silently
 skip bytes and miss subsequent Contact headers. Could this lead to a
 failure to NAT those subsequent headers and leak internal network details?

Fixes: c978cd3a9371 ("[NETFILTER]: nf_nat_sip: translate all Contact headers")
Assisted-by: Claude:claude-sonnet-4-6
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_nat_sip.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/netfilter/nf_nat_sip.c b/net/netfilter/nf_nat_sip.c
index aea02f6aff09..762d7e7bb7c7 100644
--- a/net/netfilter/nf_nat_sip.c
+++ b/net/netfilter/nf_nat_sip.c
@@ -273,12 +273,17 @@ static unsigned int nf_nat_sip(struct sk_buff *skb, unsigned int protoff,
 				       SIP_HDR_CONTACT, &in_header,
 				       &matchoff, &matchlen,
 				       &addr, &port) > 0) {
+		int old_len = skb->len, delta;
+
 		if (!map_addr(skb, protoff, dataoff, dptr, datalen,
 			      matchoff, matchlen,
 			      &addr, port)) {
 			nf_ct_helper_log(skb, ct, "cannot mangle contact");
 			return NF_DROP;
 		}
+
+		delta = (int)skb->len - old_len;
+		coff += delta;
 	}
 
 	if (!map_sip_addr(skb, protoff, dataoff, dptr, datalen, SIP_HDR_FROM) ||
-- 
2.47.3

