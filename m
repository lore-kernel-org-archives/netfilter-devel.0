Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793714616;
	b=E8G+KNlIrjQ5fDdMqa1Q87pkySEs6ggB1T9E90CEqvAqck2lIOgUK7pRuxaVUxWVadNB
	 8yuBnorGnEAzZU/10YJgapaZFV7qlZvvgzQbABlrhSoqK5pnah20D6i+iiTWROf19USVv
	 DfNXSK8t2kplZBFy45lHkEdlXOsErjn9PFAHN3QXJoZgXjNMiDCs5n92SgDTiBnnWrfaz
	 T3aAnmLPZ8ACXRky+PzTzfxHfY4UEkYemrwx5HnDaT0elqFNpwnRHS72F9GwmI5u3WolL
	 CG5znMe5Rk0XDG1HTp+gsUZGPgLnLEuK0y1YrRxd7uuCSojfkWGQPHEEnYq2N6B7rNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793714616;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=FuJwpB61dP51oRlLlxUKS/oBV8WRen9wZFI8yNkRer0=;
	b=terIMczls87ucNRwU7p31BeZWqIqAg8w91bXcgSGkCc+bpO7A7FjpAtlu5jWuqQ9OxEt
	 egDiFtm74acOHCBRKRfC0SDGGZXBAFRApFyc1nSYruw6a7S9eHtQXaSdHT1sj+sKgSG+f
	 La5kgK+0KlHN0DWdIjdL2KNsb//4dw0D/jDdNnKo0VggYT24dsXF3PqtshHvbHUo8TOs8
	 EVD9zWJCgOmHQjcJm3MybLLZnkK+arpm+JrAmVh+lc+1w2Duw1KzgGMqdeAC8ova+siZn
	 G/cikMa42pvCQsPf8m4lSA72yO/thKXN0jpoxk2rZqkAHH1hv5UzASW85iFaTU0i6Dg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=gLu+qAdQ;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A837C608509D;
	Tue,  3 Nov 2026 14:03:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A837C608509D
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=gLu+qAdQ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1793714613;
	bh=FuJwpB61dP51oRlLlxUKS/oBV8WRen9wZFI8yNkRer0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gLu+qAdQQNjfDZkyizCFLZdqAanMpoFyRJb3Zs6pCsT93YlKtRjxd1X0Jn6WcEYSH
	 tjgNQiqdxyj/yDMApbhhLHelpX9UFPvJReRN7FxRFKWyyJlCFrWjr9hJT8YrYR+NGS
	 Afb95jPosnj4NLlLccBMP4QQrlbMx0lmdMpQxITeC9DUTfyDH7aacETCQ3HPBTLJUw
	 HfOZ0v3X+MjTK9MzAG3+OvG0LS+nfFsnRU9jBuqSW3EYghJxVSDFqxcJ328uzq4kxg
	 Geq4wXSmDfUHBhmYBKQt4nhE7dZplklH/j8U6yleNEIpjZgS+g1cn9JeCN4DyhFTGn
	 PNfLG5LjiVAYg==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 3230460090;
	Tue,  3 Nov 2026 15:03:33 +0100 (CET)
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
Subject: [PATCH net 12/15] netfilter: nf_conntrack_sip: fix OOB read in ct_sip_parse_transport()
Date: Tue,  3 Nov 2026 15:03:05 +0100
Message-ID: <20261103140308.591690-14-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261103140308.591690-1-pablo@netfilter.org>
References: <20261103140308.591690-1-pablo@netfilter.org>
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

From: Joas Antonio dos Santos <joasantonio108@gmail.com>

ct_sip_parse_transport() compares the value of the "transport=" header
parameter against "TCP"/"UDP" with strncasecmp(..., 3), but it never
checks that the parsed value is at least 3 bytes long.

ct_sip_parse_param() returns matchlen = end - start, where end is the
next ';' or, when there is no ';', the end of the payload buffer
(limit = dptr + datalen).  If the "transport=" value is only 1 or 2
bytes long and runs exactly to the end of the payload (e.g. a REGISTER
request whose Contact header ends in ";transport=T" with no trailing
CRLF), matchlen is less than 3 while strncasecmp() still reads up to 3
bytes, reading 1-2 bytes past the end of the linearized skb data.

Add a matchlen check before the comparison, mirroring the
sdp_media_type() pattern a few lines below, so short values cannot reach
strncasecmp().

The bug was found by LLM-assisted manual review of the SIP helper's
parsers and confirmed with a userspace ASan harness built from the
verbatim parser functions, which reports a heap-buffer-overflow read of
size 2 in strncasecmp() called from ct_sip_parse_transport().

Fixes: ea45f12a2766d ("[NETFILTER]: nf_conntrack_sip: parse SIP headers properly")
Link: https://patch.msgid.link/20260815133104.50369-1-joasantonio108@gmail.com/
Signed-off-by: Joas Antonio dos Santos <joasantonio108@gmail.com>
Assisted-by: Claude:claude-opus-5-5
Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_sip.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index 64bc440b1181..b05dc8858d09 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -701,9 +701,9 @@ static int ct_sip_parse_transport(struct nf_conn *ct, const char *dptr,
 
 	if (ct_sip_parse_param(ct, dptr, dataoff, datalen, "transport=",
 			       &matchoff, &matchlen)) {
-		if (!strncasecmp(dptr + matchoff, "TCP", strlen("TCP")))
+		if (matchlen >= 3 && !strncasecmp(dptr + matchoff, "TCP", 3))
 			*proto = IPPROTO_TCP;
-		else if (!strncasecmp(dptr + matchoff, "UDP", strlen("UDP")))
+		else if (matchlen >= 3 && !strncasecmp(dptr + matchoff, "UDP", 3))
 			*proto = IPPROTO_UDP;
 		else
 			return 0;
-- 
2.47.3

