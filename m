Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=151.80.46.58
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793900253;
	b=ouy1d6MqPnwuxTxT4oIXPbZ57kN3FxZlj2TU2EJSkpuSAjE2VvMyjo1s6VwO2kB5Alb6
	 f9xbu7//forh30qC2a69bV3He8rlxOq8Tfj1Fg/00OkkBsaRZjWH+rE+asbY+7sT6SBzu
	 FuwFmwePmHDSy+fILWRFD220wxPh5T6d2dc9nVP3Ssi43VRN5rNRJYzr8J1CXT/SWRZDH
	 UUiaF8kmLM1RTN/WuLLG07yZx8Cc3BL96ayoyxv2Ig4nIDKTErQ6PDfVHuo363nilTV4f
	 9orMB6MT2b9GPATxRv9oYKthinhhD9+NeAd1UcjDQ6ffw9vHHWjLuoEg0Q2zT2MlqWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793900253;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=i7U58xXymVbrSTMB2xBShIhXH0hps6UMux+IfQ0/NEc=;
	b=SYLGU039X4+o3mUzwHBiOzW5YBLfm6gJWXZ+sBnDtvYqFXsmSN5D1J5BP0m/Z/D89bct
	 sUXQu9r7mLPwDuGKL/pum+vvxYDFqq5CGNLlwEZqeaA2Xhhwwl3X9CzOTCvhPscXuK/0x
	 IcDHakX7CtvSCHpeInINXt7CRliHu7huI3IgmS62G7jDlnoY9g8QDUng3vapCQcg1ZlVj
	 0yaaX73ONuy0RHagrTfgyDObKNomZVfGdSwYS7TTa9crvJgkDdd5bGaeK1qArLh5bywCM
	 DfRHskyijdjEe9hSRURmJl482x575BXDMX5ojLnr7cVy4UZSRJr1KNtTEBKoFZDmb9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=nwl.cc;
	spf=pass smtp.mailfrom=nwl.cc;
	arc=none smtp.remote-ip=151.80.46.58
Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D258D606A33E
	for <netfilter-devel@vger.kernel.org>; Thu,  5 Nov 2026 17:37:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D258D606A33E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=i7U58xXymVbrSTMB2xBShIhXH0hps6UMux+IfQ0/NEc=; b=YrP7UKDFVxWZqL49Q/zmHGJUgb
	VElEaXtEvqxlANBDogSIGNLiEkSkpxGSKVVnTKbJ94b+R2FNAXrlwGLG3uyfdsQGaxoOUpUzXLVLI
	OvSx2g1ap/BZIGSZZ8p41EpWrfyqDrSD4Y5jLNR24ymq3Jr/IExTZwXC2gS6st3K9MXeG/nzI9pmH
	9ziaJho6tRVo6G1G72nX8qmEqFQ8ux//LZ/0uUnavDq/yYzGGxH3Co4T2WRaIGOzaog+qnp3m5XHy
	Abk5PU/kpRfTYPpZ9eOdMdgyfrV2pTP3kOvLRr+Bt3p8x8PuUk3oU2nZfGuz+Y1uUblQFz7+2BmwH
	4xZMCT6Q==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=tia)
	by orbyte.nwl.cc with esmtp (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1xP1Oo-000000005lR-3azo;
	Thu, 05 Nov 2026 18:37:18 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>,
	xelra <xelra@protonmail.com>
Subject: [nft PATCH 3/3] scanner: Add start condition debugging
Date: Thu,  5 Nov 2026 18:37:13 +0100
Message-ID: <20261105173713.72238-4-phil@nwl.cc>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261105173713.72238-1-phil@nwl.cc>
References: <20261105173713.72238-1-phil@nwl.cc>
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

Report start condition push/pop actions when called with
--debug=scanner.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/scanner.l | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/src/scanner.l b/src/scanner.l
index aa83d8590f5e1..a4f9a16c5523a 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -1383,10 +1383,13 @@ void scanner_destroy(struct nft_ctx *nft)
 	yylex_destroy(nft->scanner);
 }
 
+#define sc_dbg(...) if (nft_get_debug(scanner)) fprintf(stderr, __VA_ARGS__)
+
 static void scanner_push_start_cond(void *scanner, enum startcond_type type)
 {
 	struct parser_state *state = yyget_extra(scanner);
 
+	sc_dbg("--pushing start condition %d\n", type);
 	state->startcond_type = type;
 	state->startcond_active[type]++;
 
@@ -1401,14 +1404,19 @@ void scanner_pop_start_cond(void *scanner, enum startcond_type t)
 
 	if (state->startcond_type != t) {
 		state->flex_state_pop++;
+		sc_dbg("--delay popping start condition %d\n", t);
 		return; /* Can't pop just yet! */
 	}
 
+	sc_dbg("--popping start condition %d\n", state->startcond_type);
+
 	t = state->startcond_type = yy_top_state(scanner);
 	yy_pop_state(scanner);
 
 	while (state->flex_state_pop && !state->startcond_active[t]) {
 		state->flex_state_pop--;
+		sc_dbg("--popping delayed start condition %d\n",
+		       state->startcond_type);
 		state->startcond_type = yy_top_state(scanner);
 		yy_pop_state(scanner);
 
-- 
2.54.0

