Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=84.16.66.170
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793992752;
	b=u+X6pR4flil0gHEIMIB5P+/l6FkrSzHD+zusOPZtChdeCiCTa75rpvlThxFXdeNHQ9Pu
	 PoQXx9gbPLryK/Np9ym83YawsPlXs8aHPv0hv1n5ryME3gQ7N+8CAdOw9Pzw/kv1QWHL5
	 PftNsvQJSnIJaZg8RGO0m2FeMLWgyQSv3NdWQ45C8NCVvLsggRZnfdebsl89RGH9uIbOq
	 lC+VwMdlW9ZHQy651hILFsUZ2bQsOYnTCPaF+GIIDCdtOEeNW3SI9MoiKG+WANR3gWAnf
	 nxMHxxD8NJeuOngMosjkjnpctb1hSrR7GbgaP/aGlBwO6zWSiQZ3KN9oyh1Uqn1YJYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793992752;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Infomaniak-Routing;
	bh=S8RDEJ4TxBGmmJllv14T6tnzjzSZc/tCNc7Y2LSWOLk=;
	b=yn8APMTQmxjYJjRDhgE68oJIQ3hZTflwESF+r5neUs5YfK6rfbEVwXphSvpTgVJALGIF
	 wZ5OMgr7dCsKSgSJbCQ7Pqv1lA9zjXhR+f463ZZquCAit1Pv/NvtBdipz1DY0DDM03eMs
	 811ZoVdtWzRVi89EWKCFwdYm6dje7dCdvd/d2388BeuNZ+sNRqMHO07kmJ9mZ2AWqBagE
	 Rgql9atbDXLnVnGGE3a3qcFvNp1bDQAoV60f0bBN1mSZMliaH6xbELRnTPq4IHtbIYQiI
	 LgBFsgTWhcnq5ta5938yOgzltnqdaoXI3TfUpBIicN+wt3U12WvEaORdurSF/5Yy/hQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=harvester.fr;
	spf=pass smtp.mailfrom=harvester.fr;
	dkim=pass header.d=harvester.fr header.i=@harvester.fr header.a=rsa-sha256 header.s=20260519 header.b=C0nVmfoc;
	arc=none smtp.remote-ip=84.16.66.170
Received: from smtp-42aa.mail.infomaniak.ch (smtp-42aa.mail.infomaniak.ch [84.16.66.170])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1E41606A326
	for <netfilter-devel@vger.kernel.org>; Fri,  6 Nov 2026 19:19:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C1E41606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=harvester.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=harvester.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=harvester.fr header.i=@harvester.fr header.a=rsa-sha256 header.s=20260519 header.b=C0nVmfoc
Received: from smtp-4-0000.mail.infomaniak.ch (unknown [IPv6:2001:1600:7:10::a6b])
	by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4jLprR4mkDzZ1g;
	Fri,  6 Nov 2026 20:19:03 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=harvester.fr;
	s=20260519; t=1793992743;
	bh=S8RDEJ4TxBGmmJllv14T6tnzjzSZc/tCNc7Y2LSWOLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C0nVmfoc+gaA1em1eDzvJn1da56smVQVt8760GhcUlvSX6vacOSchy5vUoyg/jTms
	 ZAVpevUpn4Hg4rRUeBNorp4sMf388u3hYy3+N67rbrIT/E4DotplXhkYUs3ntunBhk
	 r2u5KJAQ8x9w8sVxp6SQdXRPvy4xVCP+jlcYpYWjc4CB4v+K0sjR7Nt8fz5G6x8t3O
	 iOqgSDhpsbz098dPZNeny9BkGkMeVlvMf9dssYRw+kfGlWliS+Nx0kwrR3nnRwrvct
	 wpvHuVkBlYmSNCveGHEbTYgaMxF7oZzi7qRPJk528ZM1OutPHzkeAn/Ij7qsGWgtxq
	 f6+Ev7gtLVgEQ==
Received: from unknown by smtp-4-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4jLprR07SwzQ9l;
	Fri,  6 Nov 2026 20:19:02 +0100 (CET)
From: Florian Stosse <florian.stosse@harvester.fr>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Stosse <florian.stosse@harvester.fr>
Subject: [PATCH libmnl 1/5] nlmsg: fix overlapping copy in mnl_nlmsg_batch_reset()
Date: Fri,  6 Nov 2026 20:18:36 +0100
Message-ID: <20261106191841.1645-2-florian.stosse@harvester.fr>
X-Mailer: git-send-email 2.56.0.windows.4
In-Reply-To: <20261106191841.1645-1-florian.stosse@harvester.fr>
References: <20261106191841.1645-1-florian.stosse@harvester.fr>
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
X-Infomaniak-Routing: alpha

When the message that overflowed the batch is longer than the messages
already batched, the source (b->cur = b->buf + b->buflen) and destination
(b->buf) of the copy overlap, which is undefined for memcpy(). Moreover,
nlmsg_len is read again from the old location after the copy has
overwritten it, so b->buflen and b->cur are set from message payload bytes
and the next mnl_nlmsg_batch_next() dereferences a wild pointer.

Read the length before moving the message and use memmove().

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>
Signed-off-by: Florian Stosse <florian.stosse@harvester.fr>
---
 src/nlmsg.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/src/nlmsg.c b/src/nlmsg.c
index 30a7e63..f8eed79 100644
--- a/src/nlmsg.c
+++ b/src/nlmsg.c
@@ -531,8 +531,10 @@ EXPORT_SYMBOL void mnl_nlmsg_batch_reset(struct mnl_nlmsg_batch *b)
 {
 	if (b->overflow) {
 		struct nlmsghdr *nlh = b->cur;
-		memcpy(b->buf, b->cur, nlh->nlmsg_len);
-		b->buflen = nlh->nlmsg_len;
+		size_t len = nlh->nlmsg_len;
+
+		memmove(b->buf, b->cur, len);
+		b->buflen = len;
 		b->cur = b->buf + b->buflen;
 		b->overflow = false;
 	} else {
-- 
2.56.0.windows.4

