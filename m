Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793882754;
	b=zXe/IcZ2z2Dj4FSKlEXm+iO2R2Y/KyC1Pjadyt/W7a3wMreajshftOuBzxx8E99FkLIn
	 GoO/5Y98DDWuw4V9GV2rvXNxbC5Qt71uSKa+aW83X4W2zzMy5tvD8GdwJ/PYuLAUw5qEa
	 QQ4vz+exrykWfAz6KZNk0LcmC7VbMCM0l3hhBh1WoKmvzmzRhGJv8E0m3RldqkIBeJc8W
	 gBjTJ4pJLOFSppL71WLPod4nFOcEmv/cZnNyzz6GXsJzfLb9/gQezCINOIDZwNTIjr+uk
	 l42IWL0fNYXbgjAQ7NZfE+uqZXGNp2h2dhfKv0HPFmfFJzKIRhH2JJwsCzZXBXe7HqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793882754;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=FuJwpB61dP51oRlLlxUKS/oBV8WRen9wZFI8yNkRer0=;
	b=KIAyI0Qs/8Ykh0fVTeu4lXEt8hegZ42q4En48EJnqZLNCnCUUGm4Ibkj8oxX3hXPzDqD
	 3tOvShyswZT+vF8BPnm5aUlL9wNoRW4dpUvsLK36/+EfBHwnSvcNljyY0WqKbdrk51F7N
	 GDlTOmL+9TLdcgID/59WhzeYHIye2O4ELl0UJQA8+9+iDPqwe54wRalbpV/mnD2rtO+M+
	 nT381wnJxlDDRf6UFFvYK7lo4VZYrc9pIrL8F6hLuFFJFQZwRsbPHew9ChjxrDl0Tljtz
	 AgnlQaSOgWjsqMcFV4Bz3Cv1P3XJ70Jp9+HAE+7uSFxCPar0skEhZHpqnoMfJVD9twg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=MYMpoK8X;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F11B606EE98;
	Thu,  5 Nov 2026 12:45:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9F11B606EE98
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=MYMpoK8X
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1793882751;
	bh=FuJwpB61dP51oRlLlxUKS/oBV8WRen9wZFI8yNkRer0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MYMpoK8XKhCz860LU83Wgk1jxan6Sp/VBiuazIkhrNMzsq8vDaw9SRisAipMF1Xhx
	 cPZJf5+SRGc0aTAfMznG+OZHACkl0yNJqsGGG9waYQjnKbZnfC9OKOxXTpUd6fJO2t
	 xsFP7bf/TTFFWc3ql7qqmbH7VZr5pq5OEhr0x2yBlNfed6bCz50k16fKhJvbSM7YxB
	 +BmHA+PAFWDMCebLBC/yo4ZIZ35vEnbZ2I0Vib+nnYmm2sPa91Q5gDm8bl+hLB9QmQ
	 ICN5WLOnfKfI9kF/ftECs0vV9sILcLs2FliABTQFBTjurKQfjkI80sVT0lzPtVeiox
	 Hgf1W6XKF5qqw==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 4E1AB60082;
	Thu,  5 Nov 2026 13:45:51 +0100 (CET)
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
Subject: [PATCH net 09/12] netfilter: nf_conntrack_sip: fix OOB read in ct_sip_parse_transport()
Date: Thu,  5 Nov 2026 13:45:33 +0100
Message-ID: <20261105124536.1009301-10-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261105124536.1009301-1-pablo@netfilter.org>
References: <20261105124536.1009301-1-pablo@netfilter.org>
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

