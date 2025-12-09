Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6EBE3002A0
	for <netfilter-devel@vger.kernel.org>; Tue,  9 Dec 2025 16:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765298751; cv=none; b=gDYSSinuvLpICrwCdtyVlVAj2Z7BXoYZhpTu/k3knqY6vX1nA6gPRTvsjpmatMKFhkMjwdjQST1XHqxudsTxxKxuPISEr4TZ9tnHszorws5ipgjcY7P6yZW44qisMBZkX7TnnBrn8getDkbH7Y3P9jnhdA3So5gVZqdNum46KzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765298751; c=relaxed/simple;
	bh=p2DiFMn0pi2xYYDklHXmV3s7TJ7tOX0K7dWWz+Wsfhg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gfOSiS9K+FKIkEltW1zLWuHv2/gwkSvpN2DGaS5eEcelimv5maqiHB6wpq50m1QwRmPr5OeQIQ7KzrcRDpBWAq9zuPSWECi7X9f5dTr1egoCc1qJZCpaI7zAw8NVjRPpNEtQY1JSF8CAUyZVz35K3I6mvmhyfAujuVL5AT6UwhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=U65K3EeI; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="U65K3EeI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=hvL43COqY1775QbIjDN0QhhFaZTqr7F08jA3IdkiSj0=; b=U65K3EeICf6cidsi0cMyAct9j+
	TtLZYBx3Pg11rTPjEBKIKIZcl13li3+mQ3VN5UwxcQDi6BJw4Y6CdwvRpxilZaxJBqLLmwPLA3ER2
	3Gl/kQ5k3V+EOWCc91DvxjMeOeFHGTx1St9JqVFiR2aACP6RNBd3k77TCnCNj3NLJrAOKAeTL9Hey
	hlimlzzozPIXdsd6vJjtXn7/MRqdpCpP9TjFCAI1px/PRkxdloP2ujNanG2yZuOI3ZYSWfEZBHDKY
	Y70L56UJwiNx05O95UzWwi00JQfMq8wyCXswq/GAkrKivv3Zi9i8V8XD3Apu1mBQxsceYCL1unsJJ
	pT/NHerg==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1vT0qR-000000007tb-3YAJ;
	Tue, 09 Dec 2025 17:45:47 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>
Subject: [nft PATCH 3/6] parser_bison: Introduce tokens for osf ttl values
Date: Tue,  9 Dec 2025 17:45:38 +0100
Message-ID: <20251209164541.13425-4-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251209164541.13425-1-phil@nwl.cc>
References: <20251209164541.13425-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Eliminate the open-coded string parsing and error handling.

Signed-off-by: Phil Sutter <phil@nwl.cc>
Reviewed-by: Florian Westphal <fw@strlen.de>
---
 src/parser_bison.y | 24 ++++++------------------
 src/scanner.l      |  6 ++++++
 2 files changed, 12 insertions(+), 18 deletions(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 405fe8f2690ca..ba485a8c25b50 100644
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

