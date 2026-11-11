Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=94.136.29.106
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794395606;
	b=JQqVMm1YLw693d90buxjPdpOf+PDOZDDNcmP417XBcdo9n2vXz2FhFlju/xE4ORDjsiG
	 OQlWchmF7/jXCKBFY+8djhk1JbZBHYvxf3cwFrVVyudb0ShDH+vHrPxHSJ13kBhEzZCLd
	 cyYJ4VElbYakW0ZlM66zE0+X83f+nMSRH3w5xPIVGLh2UDlzo0aLC9WPVg5hnNPJAfj/+
	 zSh/SRsPorbAdwOieb8WV2h9iCuXoOlmK6ml7gzEy2MHPnnr1qurdunficxhgbjXoJ1ts
	 enEOdgnSks6HBqiK24KsYgyVkAn+7uC1k1Gh7jJWSS8HJ/N0jmlUaRnSi6Qj9+HWz4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794395606;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:
	 X-Bm-Milter-Handled:X-Bm-Transport-Timestamp;
	bh=hkRVs1TToHlxgPZ9XG4nPjq+9GQLyOyEfRZ1Z//KgSw=;
	b=nZ1M8ojQVaUjj5lgkAhy+yBD3y0sXVv4/fys23HKp2sbe4HxLT49/Lw5P0JnX/lfkR/L
	 rAVND4xpmPjeoykR7v3m7g6difaozrD/ScH3WFQ8hv0nlPN1KmUIQ/RS4LfwgElhd/ct8
	 6JEOz0zMQuz4mUxy84cr7UcUqt5CxPEBRNLb/dLZYmYdDDA93xLWcPmjCpX5owhNEcMpN
	 /nfN8PGc10K3CfHtLZTdYGTi+nbKLqpwdBXgwxEHTiA9xYeLDXZuAR55MNsvME9gfdEXO
	 30/3916vsPAKlCVwNIqOKdFwBeZZmN8MErAwIFY2qwAcKDMGEkRP0voMeUmi85G+Trg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=proxmox.com;
	spf=pass smtp.mailfrom=proxmox.com;
	arc=none smtp.remote-ip=94.136.29.106
Received: from proxmox-new.maurer-it.com (proxmox-new.maurer-it.com [94.136.29.106])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1B20606A327
	for <netfilter-devel@vger.kernel.org>; Wed, 11 Nov 2026 11:13:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A1B20606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=proxmox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proxmox.com
Received: from proxmox-new.maurer-it.com (localhost.localdomain [127.0.0.1])
	by proxmox-new.maurer-it.com (Proxmox) with ESMTP id C1F10481F8;
	Wed, 11 Nov 2026 12:13:16 +0100 (CET)
From: Stefan Hanreich <s.hanreich@proxmox.com>
To: netfilter-devel@vger.kernel.org
Cc: Stefan Hanreich <s.hanreich@proxmox.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>
Subject: [PATCH nf-next 2/3] netfilter: nf_tables: stop bind walk at anonymous set creation
Date: Wed, 11 Nov 2026 12:12:45 +0100
Message-ID: <20261111111250.226432-3-s.hanreich@proxmox.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261111111250.226432-1-s.hanreich@proxmox.com>
References: <20261111111250.226432-1-s.hanreich@proxmox.com>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Bm-Milter-Handled: 55990f41-d878-4baa-be0a-ee34c49e34d2
X-Bm-Transport-Timestamp: 1794395595918

When an anonymous set is bound to a rule, __nft_set_trans_bind() marks
the NEWSET and NEWSETELEM transactions of that set as bound. It walks
the whole commit list to do so, so a batch adding N rules that each use
an anonymous set takes time quadratic in N.

The walk was introduced in commit f6ac85858976 ("netfilter: nf_tables:
unbind set in rule from commit path") to stop at the NEWSET transaction
of the set, which is likely close to the tail of the list.

Commit 6a0a8d10a366 ("netfilter: nf_tables: use-after-free in failing
rule with bound set") turned the condition into a switch statement to
also mark NEWSETELEM transactions, so the break statement only leaves
the switch and the loop runs to the head of the list.

Stopping at the NEWSET transaction is still sufficient. Anonymous sets
cannot be updated, so there is only one NEWSET transaction per set, and
elements can only be added after the set was created. Since the list is
walked starting from the newest transaction, all transactions referring
to the set have been seen once its NEWSET transaction is found.

Signed-off-by: Stefan Hanreich <s.hanreich@proxmox.com>
---
 net/netfilter/nf_tables_api.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 9fe234e329df..c9b0070846b7 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -248,8 +248,10 @@ static void __nft_set_trans_bind(const struct nft_ctx *ctx, struct nft_set *set,
 	list_for_each_entry_reverse(trans, &nft_net->commit_list, list) {
 		switch (trans->msg_type) {
 		case NFT_MSG_NEWSET:
-			if (nft_trans_set(trans) == set)
+			if (nft_trans_set(trans) == set) {
 				nft_trans_set_bound(trans) = bind;
+				return;
+			}
 			break;
 		case NFT_MSG_NEWSETELEM:
 			if (nft_trans_elem_set(trans) == set)
-- 
2.47.3


