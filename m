Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FEA62E6CB8
	for <netfilter-devel@vger.kernel.org>; Wed, 26 Nov 2025 15:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764170046; cv=none; b=lwytikjWezYtuQ6+ylt9OGBtODetmHgyY6t3D2IEiygHwodu2YVvz76/N/ZV3kRp7HkXq+rUrus9SRWnietAfiMpIx7+7xsBGD/g8ALU/7RnJsy+4+EZklUHqvPwnlAusFIBH0dAu3PWApZeMsaV8PVouB/oky9RqOMBaY2pVvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764170046; c=relaxed/simple;
	bh=Er9Zfqw2wLnmEI2vyKdyckr1P7/GbAScH9uWXKEvx+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RD+YPTYjj7NS9l6zSWXoPVs7CASKqdENp0MY1JVHvHGPF8MrFpY9RCDB9cQTT4RFXa6IJzA1eKMCLEaBRuxBT5F6Hn533VsJYQl2G6MXUm8tNQRTiGnv8cboHjAsrNO9tFE/zIjmYCQVVmNCdre23f7d6QxSie5gNyG/OGLdi0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=CEoR06FF; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="CEoR06FF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=WJy4wDwAVgVhKtlG4fdGWipk30OFlufaHLNP1CnSY9w=; b=CEoR06FFwBI9CA7MtdCQ+89Mp/
	Xh9eSy8Gh6qzvKihJWoVqECtLlMV7Kv6nMS0fwVhrNzn2fjF7R6lNlpPDQYX/YRj68uQQ7zs2h0TX
	DXUChCsbC2o/pHJ3wV2Ieb/d1xAVTBrDaXrtVsyD7u7/6y3ZW3DMNt8ZhHv9MwH+gZBaBrM21X37b
	lXhvTTV1DYSAAmFC8oQMPN+HTd0pO9nZoLN//vNhpAufjh3p192poceJW1mPDkFTnfWoXIjmiSDPO
	U3l2N4/WFRZi8NeuNAZRdILN5huIJGvfSfenKQ5HfVTSOlD8hRMNPbjYUduyN3+E9sLLy7ddxU+oS
	Dl/Zunsg==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1vOHDP-000000001Ak-2fgB;
	Wed, 26 Nov 2025 16:13:55 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org
Subject: [nft PATCH RFC 3/6] parser_bison: Introduce tokens for osf ttl values
Date: Wed, 26 Nov 2025 16:13:43 +0100
Message-ID: <20251126151346.1132-4-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251126151346.1132-1-phil@nwl.cc>
References: <20251126151346.1132-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Eliminate the open-coded string parsing and error handling.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/parser_bison.y | 24 ++++++------------------
 src/scanner.l      |  6 ++++++
 2 files changed, 12 insertions(+), 18 deletions(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 767d5d7063c26..a190cbbbd6dee 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -719,6 +719,9 @@ int nft_lex(void *, void *, void *);
 %token NAT		"nat"
 %token ROUTE		"route"
 
+%token LOOSE		"loose"
+%token SKIP		"skip"
+
 %type <limit_rate>		limit_rate_pkts
 %type <limit_rate>		limit_rate_bytes
 
@@ -4485,24 +4488,9 @@ osf_expr		:	OSF	osf_ttl		HDRVERSION	close_scope_osf
 			}
 			;
 
-osf_ttl			:	/* empty */
-			{
-				$$ = NF_OSF_TTL_TRUE;
-			}
-			|	TTL	STRING
-			{
-				if (!strcmp($2, "loose"))
-					$$ = NF_OSF_TTL_LESS;
-				else if (!strcmp($2, "skip"))
-					$$ = NF_OSF_TTL_NOCHECK;
-				else {
-					erec_queue(error(&@2, "invalid ttl option"),
-						   state->msgs);
-					free_const($2);
-					YYERROR;
-				}
-				free_const($2);
-			}
+osf_ttl			:	/* empty */	{ $$ = NF_OSF_TTL_TRUE; }
+			|	TTL	LOOSE	{ $$ = NF_OSF_TTL_LESS; }
+			|	TTL	SKIP	{ $$ = NF_OSF_TTL_NOCHECK; }
 			;
 
 shift_expr		:	primary_expr
diff --git a/src/scanner.l b/src/scanner.l
index b397a147ef9bd..e0f0aabb683a3 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -533,6 +533,12 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 <SCANSTATE_EXPR_OSF,SCANSTATE_IP>{
 	"ttl"			{ return TTL; }
 }
+
+<SCANSTATE_EXPR_OSF>{
+	"loose"			{ return LOOSE; }
+	"skip"			{ return SKIP; }
+}
+
 <SCANSTATE_CT,SCANSTATE_IP,SCANSTATE_META,SCANSTATE_TYPE,SCANSTATE_GRE>"protocol"		{ return PROTOCOL; }
 <SCANSTATE_EXPR_MH,SCANSTATE_EXPR_UDP,SCANSTATE_EXPR_UDPLITE,SCANSTATE_ICMP,SCANSTATE_IGMP,SCANSTATE_IP,SCANSTATE_SCTP,SCANSTATE_TCP>{
 	"checksum"		{ return CHECKSUM; }
-- 
2.51.0

