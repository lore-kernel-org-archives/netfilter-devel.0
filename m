Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793581045;
	b=ve+u2TCy6swd/i3MWGkwAvDLTmUEl4YGAmsffLJetHK3F9UINUGRP2SIPSK9LoCg5fp0
	 9PavKpobaraIDv326zIVTm4jQA0RmnQoVW9HwngvbvFa2VDomaUhWWCBKqPWWiq0PdrzY
	 3MWJZL0P8Y+MKVBZEUoB8daQnz4SD+T5+WONCR3P5xhqSx2OCwri8bOWvUqmNMnIyx6rM
	 m5YAzkixYQpWjoXC+H2q2DVlh5hYigVif/Lhy//8uGlN67KLjPZFsIX17+11xk3vosi5n
	 ctqj4e+MbqYCReipKcGwzMr4WBTABr/h1bUD18sDJjnoDXbqfjjkl4IGSbpnE1nR27g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793581045;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=FuJwpB61dP51oRlLlxUKS/oBV8WRen9wZFI8yNkRer0=;
	b=ccjU4rMOcR3p9IqDDZRXQr/tQZ4/DW69o51HX665PnARbMw2yOmltrQq2ABx8T9tW9GR
	 eFiAcEI1jM1T+iSfH3meUBlrdCBeREZoi6GOMhW/MLufvvcZtWWenTQ8ct9maB7XrwzQ0
	 bVge3vCD2bkgAYQdpm8r/C5gCZM2ecj/97iPbrzEsh9J6A263jUSNe04vQmNEz0wdXRyi
	 N1+qQBQ5Vqe5fGc0ti3YNbDvtxc9m9QVVhLkKhoksZzEtgElfz5t9oyc/KniXhSyb2blE
	 k1DrsE4DRUcjfxMtxFsgD1Ltkbhn7IrvdpiBT+WAC2twHaYvrABekoOOHXwyzBnD9hQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=rkIzKMpX;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48374606A33B;
	Mon,  2 Nov 2026 00:57:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 48374606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=rkIzKMpX
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1793581043;
	bh=FuJwpB61dP51oRlLlxUKS/oBV8WRen9wZFI8yNkRer0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rkIzKMpXuUMNBP/NN1M+wd+45tYg3NOSsCkNnaBcdVzciBCwIBgwZuqksLCuibkHx
	 ZmEVWv+y1w1YhKDe6yeJWSxUuKP+0SXeAOzpZFKYG9MxraZ4Tb9HomrHMV9LKNnzTf
	 tYGJ+o6JLue9f4/46i/x7U2TPitrwd+HGyrd+nBoNszjFJuHJ1+n0qi9dAKemtVdAp
	 zY2E80XVXqJJqy5pievTZ4EZymtr5pXOaOz942mLg8zdqAhB0x55XhI58NMpPv9GYw
	 AL1PUBpcOxEBgT1fFZA3bEHRISrsMmajD9NqhdYqwY2oQ9Z06CazepzOKGZ1DRbKIy
	 l6vIB8FYZDUYg==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id B80916007C;
	Mon,  2 Nov 2026 01:57:22 +0100 (CET)
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
Date: Mon,  2 Nov 2026 01:56:51 +0100
Message-ID: <20261102005654.532438-13-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261102005654.532438-1-pablo@netfilter.org>
References: <20261102005654.532438-1-pablo@netfilter.org>
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

