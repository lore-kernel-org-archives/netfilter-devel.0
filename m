Received: from oss.cyber.gouv.fr (oss.cyber.gouv.fr [51.159.188.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F33E547073;
	Mon,  5 Oct 2026 20:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=51.159.188.251
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791231378; cv=none; b=jEmJ+28ezySkiQKR8o0a2u1GALCdwMZbyQ75ef+s8S8dWTHJqmQd1Eak4jLN7Z86zU8X1clwEcvoLPQNEsv+A3XjsPG6RtIGXgokCDf9cQn3w8EXHRPka4X8z/H9J1DHFJCQTH0Pgmryzo0UH37XH/ZurwOMW/GVUSEA1f97xYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791231378; c=relaxed/simple;
	bh=/jtXsg7zg5YsVSpKktYmCl2HOLTmXcA3pq8mmylJWnQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=rwERS18StRioy8jk7U+DhAVfVIf6hmzWdOYgsQ3ejHHCfdQRXC3nVUN7zH302vsfkFnRN9WX/Bd//rNGPX2sAzJf+tLXcSeqEYyLsdmMQauwjnyjK7Pd3qCsAHQ1B0TS4J6B/nJGDimSQ1pGP+Bcn9z6sbExLtFOqPDLpw3ymuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.cyber.gouv.fr; spf=pass smtp.mailfrom=oss.cyber.gouv.fr; dkim=pass (2048-bit key) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.b=asEDHv88; arc=none smtp.client-ip=51.159.188.251
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.b="asEDHv88"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=oss.cyber.gouv.fr; s=default; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Reply-To:Sender:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:In-Reply-To:References;
	bh=/3KL0C/nw0xYEK9+GdpscS3wjuMLqlg3B/VsPRrgino=; b=asEDHv88pciBOR1xFCUufLW6gt
	kl8QeG1uJfbFDwZaT8pH49WRm6kM9NYNK/VLdxAnZh6d3pWot8WNiI05iHi/yWvX6CLfDYB1iZ+ne
	yrn0TDzoUULw1Q+vdEPk6dddRPd7l/gKQBNxWBFDQU5c8XCynwp5ch8Z12v/NoKzzJ35QVB7KqRZ/
	1vbBtLHcrnBty5SSmCmc8vunBDyMOgvU5DGYIUMdGtsLeX6ZQZtRNR/hxH3pDPvFyv/XFl5mOKj4Z
	OvpNsJa/gZw7g5ROvXjNI5uqFBU52pfd7TRyizX5mavqGV1URY5+PBfn+rIx4O8RH8oPAvJTh9Vwy
	E93KTpBw==;
Received: from [151.115.150.205] (port=35328 helo=gepetto..)
	by pf-012.whm.fr-par.scw.cloud with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.100.1)
	(envelope-from <Jeremy.Jean@oss.cyber.gouv.fr>)
	id 1xDp6c-0000000FI5a-2Kmn;
	Mon, 05 Oct 2026 22:16:14 +0200
From: =?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Cc: Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	stable@vger.kernel.org
Subject: [PATCH nf] netfilter: nft_set_rbtree: reject expired interval ends
Date: Mon,  5 Oct 2026 20:04:05 +0000
Message-ID: <20261005200404.3544062-2-Jeremy.Jean@oss.cyber.gouv.fr>
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

Consider two ranges in a netfilter verdict map:
* keys 10-19 accept packets, and
* keys 30-39 jump to chain 'victim'.
Now, delete the end marker at 20. The lookup array now uses element 30
as the first range's end, so an INTERVAL_END query for key 15 returns
element 30, including its jump verdict and chain pointer. This can make
KASAN reports a UAF after the GC releases reference chain for 30 that
has expired:

  BUG: KASAN: slab-use-after-free in nft_verdict_dump+0xdd/0x110
  Read of size 8 at addr ff110000009dfb58 by task repro/50
  ...
  Call Trace:
  ...
   nft_verdict_dump+0xdd/0x110
   nft_data_dump+0x4d/0x80
   nf_tables_fill_setelem+0x30b/0x8a0
   ? __asan_memcpy+0x3c/0x60
   nf_tables_fill_setelem_info+0x1b0/0x200
   nft_get_set_elem+0x3fd/0x4b0
  ...
  Freed by task 24:
  ...
   kfree+0x1a5/0x280
   nf_tables_trans_destroy_work+0x2cb/0x520

Reject expired endpoints in nft_rbtree_get() before returning them.

Fixes: 2aa34191f06f ("netfilter: nft_set_rbtree: use binary search array in get command")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
---
 net/netfilter/nft_set_rbtree.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 9894832..1fd9cbe 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -187,6 +187,8 @@ nft_rbtree_get(const struct net *net, const struct nft_set *set,
 	if (flags & NFT_SET_ELEM_INTERVAL_END) {
 		if (!interval->to)
 			return NULL;
+		if (nft_set_elem_expired(interval->to))
+			return ERR_PTR(-ENOENT);
 
 		rbe = container_of(interval->to, struct nft_rbtree_elem, ext);
 	} else {
-- 
2.47.3

