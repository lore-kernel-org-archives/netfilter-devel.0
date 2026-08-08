Received: from oss.cyber.gouv.fr (oss.cyber.gouv.fr [51.159.188.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1563540B0F7
	for <netfilter-devel@vger.kernel.org>; Sat,  8 Aug 2026 12:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=51.159.188.251
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786192862; cv=none; b=RzJxB4vlbv4kVOUBCL+A1Hx+0UwvwLA1ZGrxXEOzK34effFgJZFE0dq8MjxKLTCRshy39MftUG8X3H0czjmL4OIICgODp4ME4R7mbbaVTGBuntLj4EUtDBKhyUwM6UUP/RCBZoYdpyBrrEdhpZNGtxO1oRHvaW5sOMtawKJjWi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786192862; c=relaxed/simple;
	bh=z8EPAHu7s+07FuEHuv2oGkdPeWvtvESGS+PKzEskRmo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=U7ZR5BPoqBPo0a76/VqPmgYBiUBw18Mf1Mz3+XDUCf23Slzc/kpnFmJ8U0ns+rly5WIPPEshQV0w4VO75Qqd7Rqcnwaus9kkfJoxSzqXPPJCMYJM6dsf4pnBQBSrT45w3/9KeJ8cVe8Sz7fgSCt4JmJ+bSGJsJDR5AGS+FQLZl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.cyber.gouv.fr; spf=pass smtp.mailfrom=oss.cyber.gouv.fr; dkim=pass (2048-bit key) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.b=VJoPxHw/; arc=none smtp.client-ip=51.159.188.251
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.b="VJoPxHw/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=oss.cyber.gouv.fr; s=default; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=EEWYSG0jXWAWcdqKp70gX2oviInbQMAEiFJOOGp+4Ws=; b=VJoPxHw/PijNOI7axGgaVYaUqF
	snTIMEYljjONvI0ZZJhrjTZoj/VC1/m3KYaZd6tjlX4pnyoEab8bseRfPoZHeSgaY9EF8AhHoukw1
	rWqleO5qD7zVqz0yDnWwT6P+ZTTb60EyxM/R/FIiFjiED1k0tSS8EOi+RZzzFj1eiQD/tVXJlkKU1
	3GvS2lq3qp6aoNiW3a+w5fY+568okVpNHHGSCMHjUTVUqVS6njPvXhWcrsWWaxoRbhUuIT7emRse8
	2Aw5S5Vnhsu4LtH2MX3It0Nth8pnEeCIa1U6BPeYwh/MPaVjmiuKNBwRp5to0hlCZQe1+uUyvvJFg
	wRUH1PsQ==;
Received: from [151.115.150.205] (port=39726 helo=gepetto..)
	by pf-012.whm.fr-par.scw.cloud with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <Jeremy.Jean@oss.cyber.gouv.fr>)
	id 1wsgM1-0000000331E-0xTJ;
	Sat, 08 Aug 2026 14:40:44 +0200
From: =?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>
Subject: [PATCH] netfilter: flowtable: publish GC-visible tuple last
Date: Sat,  8 Aug 2026 12:40:02 +0000
Message-ID: <20260808124019.636990-1-Jeremy.Jean@oss.cyber.gouv.fr>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - pf-012.whm.fr-par.scw.cloud
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - oss.cyber.gouv.fr
X-Get-Message-Sender-Via: pf-012.whm.fr-par.scw.cloud: authenticated_id: jeremy.jean@oss.cyber.gouv.fr
X-Authenticated-Sender: pf-012.whm.fr-par.scw.cloud: jeremy.jean@oss.cyber.gouv.fr
X-Source: 
X-Source-Args: 
X-Source-Dir: 

nf_flow_table_iterate() only treats original-direction tuple nodes as
owning entries. Publishing the original node first lets GC observe and
free a flow while flow_offload_add() is still inserting the reply node.
Publish the reply node first and the original node last so GC never
sees a partially installed flow.

KASAN can trigger slab-use-after-free read and write reports in the
flowtable/rhashtable path (rht_deferred_worker, jhash, flow_offload_del,
flow_offload_lookup, etc.).

Fixes: ac2a66665e23 ("netfilter: add generic flow table infrastructure")
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Assisted-by: Codex:gpt-5
---
 net/netfilter/nf_flow_table_core.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index b66e65439341..8b1165f2b5a4 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -332,17 +332,18 @@ int flow_offload_add(struct nf_flowtable *flow_table, struct flow_offload *flow)
 	flow->timeout = nf_flowtable_time_stamp + flow_offload_get_timeout(flow);
 
 	err = rhashtable_insert_fast(&flow_table->rhashtable,
-				     &flow->tuplehash[0].node,
+				     &flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].node,
 				     nf_flow_offload_rhash_params);
 	if (err < 0)
 		return err;
 
+	/* GC only iterates original-direction entries; publish original last. */
 	err = rhashtable_insert_fast(&flow_table->rhashtable,
-				     &flow->tuplehash[1].node,
+				     &flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].node,
 				     nf_flow_offload_rhash_params);
 	if (err < 0) {
 		rhashtable_remove_fast(&flow_table->rhashtable,
-				       &flow->tuplehash[0].node,
+				       &flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].node,
 				       nf_flow_offload_rhash_params);
 		return err;
 	}
-- 
2.47.3

