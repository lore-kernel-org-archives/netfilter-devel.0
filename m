Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793782968;
	b=lgqAWcMB0s9pCNhfXdDr6tEN5rF3Z1SuX+IKuCHvQtYo3fh9d9pzSAfkH/Y90+FDs5FQ
	 juvmMGgJ5UHYCzj6CBc1DURTy2+0RBwRE3sFPfBY+RIor83Rhl75Fzj/lWhi/bhqaVzUl
	 bPOpGgxdl2PyKTFu+Q3Nv/lr6PsKO7gOnxiY7mEVeHxD+dDMv1IUo8ZYf4WD9dXVD55HC
	 uQhnOdff7+NQPP3kKW64xJltZpFqqH6tuzY4aMPCsU009VqNomYTSAaeiXaosA3e2XsVG
	 7giYy6U/cmL9djM84cxz6/McN2BWZPEqzQma4jtwFh/6hz68YIlVNY+j0NuYHS9g4zg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793782968;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=FuJwpB61dP51oRlLlxUKS/oBV8WRen9wZFI8yNkRer0=;
	b=vkpBwKXsF0BnbNRQ97zN4mcckKYWA06+HE3iRUhfNlhUYnfjwXYDC2B4swbxP1d7+G+S
	 TFRYAogiRf/g8UDJpyGwXRuItJdr+KeiX+bJ1nZoVCYYb0IDATd3wXnS9aGp25Q7+VNw3
	 0XcMR7UpgmXXo/4BwJ8AHJTc2X68lRatertelX/tn4hDgayferiFovkxZs5EpLX/19EgI
	 vj3HX/EsjvoqhPTakQZzyTPOexXM4TZ+ue5kDa9duBqtnCeYhYlGlmVecJGq/76rAChPS
	 97EMfGzB1VdvhrYlcXaEJ/faSQKWYKLuRdGTNPWVKqIm4yJ/ngqzPRfq9MdUTSO3GNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=dabTDRjB;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6C39606D81F;
	Wed,  4 Nov 2026 09:02:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C6C39606D81F
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=dabTDRjB
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1793782966;
	bh=FuJwpB61dP51oRlLlxUKS/oBV8WRen9wZFI8yNkRer0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dabTDRjBK9iFxTLshFj42QBvFIhRE7HmwSJ+AdU3ZUCsWhvtY6FqIu+mLgA8PKvbS
	 5m4KzYOQs9gipBoIr8eJhY+qZkCeR4ejd6ghhFzto8sZ8ncdcby5srSYZdVLJB8YzR
	 AqtSh3jWCnMRMVr+gXrcMC50rVF3VtnRRLT0jBqwPjzohX6mpYOpLH4uz5I0VbPiqK
	 zyhOMlDOA/yh+E0LXrop5jy1eKUlTIbh2o7zokd80wT4GvrotyN6DSCI+1Fix0UTH2
	 8UXU3JgcvVgJLSUfZt73C+ItsZT3RgZgck5X6v1XUk9XTiCN5jBM/ITgZ6pU6wLKxc
	 wWtisTPvyaB8w==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 93B5360085;
	Wed,  4 Nov 2026 10:02:45 +0100 (CET)
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
Subject: [PATCH net 10/13] netfilter: nf_conntrack_sip: fix OOB read in ct_sip_parse_transport()
Date: Wed,  4 Nov 2026 10:02:21 +0100
Message-ID: <20261104090224.750548-11-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261104090224.750548-1-pablo@netfilter.org>
References: <20261104090224.750548-1-pablo@netfilter.org>
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

