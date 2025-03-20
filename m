Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF2DB21CFE0
	for <netfilter-devel@vger.kernel.org>; Thu, 20 Mar 2025 12:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742472670; cv=none; b=bPhD0R6GbluPeTeODyNqCtxbCVmxx/yiGSI/vRjWt9eaMgKv03XbT1fWLNHgTq0/rPwC6NC6WpouPYEILF4VOh9oLotBBeRYJeRzWsWBknJ3jqMQtumESJpGiirMN+n57+AhsDgzd0b+DZwJygs+kzL9Lshn9CnBlILMmq2wxQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742472670; c=relaxed/simple;
	bh=9w+1TnOxIZWKzlQBEiATmFYRpqtiQB98BV+yBKz4pEw=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=g3plNo+ERiMWrMDraNBqDBcLwAPF31RPuTCHLh64AVBS7CYBNTn1iSmAw8w84eAxiIReOc0BDXa4aV2eNqiSmstVMRFxebm2iF4f6YZXvBtHzJziN1+6bp80P3GKQpjbyN6ca6bUPxozM2EMBWCd7Mgp3atFiksOpPtFONlfWTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=V0eNWDIM; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=OZQOjFQQ; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="V0eNWDIM";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="OZQOjFQQ"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 35CC9605B2; Thu, 20 Mar 2025 13:11:05 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1742472665;
	bh=unq7hlVX+3Sddum2tXr24UvqX6+8797RTfXTfCwEFAk=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=V0eNWDIMSg/kv/4B90txjlnlsYfhR0q15cx04L88LOyTLBSrLDSPmUEdYOC5E+TqV
	 jX5X1RnewbsK16KQXRT6gMR2SAcXlWcGycD9EVeytFcxvxn7t4kYmrSiadWhaLZ69/
	 gqJdsMjojJX7EMZHPlRBMMTsuaBjth8X4m9zS7ab9AMzzTgnZ4T9Q2qkI9dBkOExK9
	 VZVGDHs1ZPEIRdJmX8sXpTVQCaR6k8wrK3cqV70BezFDtk7KNePqS8DjrsQYGIq/fu
	 3lsQP1NMTgg5SJ1ua+gDzlDGPs5Bxf9ih2vFlEkawr7lj73wNyQya6sJmBThJStnBC
	 aT9U1Leq0XmFQ==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id A911E605A5
	for <netfilter-devel@vger.kernel.org>; Thu, 20 Mar 2025 13:11:04 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1742472664;
	bh=unq7hlVX+3Sddum2tXr24UvqX6+8797RTfXTfCwEFAk=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=OZQOjFQQVM5msECKYUuKfFJI9y4I9QJdvjTQkRnOBMIy8fPcLhcgHWBmWXRseYJLv
	 4/2Hcs++fcKvi1znGxNpsDkf8vBh2X1Ucgob4cUYGMjg4oSMo86mrQI6NGhHANyk5f
	 UOQk9hv13Cqau9ZayATlHUm8hfOiYN0iZxTl1mxSJkZ/WPuhQcEoQIIcDaJdmS6wSU
	 w0MisGS3u5fjh87NkJDckpc/FkmvjRUdJXTCXztDhcT7l+WaA3MUHhLEYZ1oXf0yyt
	 IB/dXxKDaVrqErEPUBEWPjMDPtk0ldp8sfkBN293/Ljhy4fQyZXW6Uabkb0QzQ4c3a
	 ejrnYLshm75mg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 2/5] parser_bison: consolidate limit grammar rule for set elements
Date: Thu, 20 Mar 2025 13:10:56 +0100
Message-Id: <20250320121059.328524-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250320121059.328524-1-pablo@netfilter.org>
References: <20250320121059.328524-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Define limit_stmt_alloc and limit_args to follow similar idiom that is
used for counters.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/parser_bison.y | 77 ++++++++++++++++++++++------------------------
 1 file changed, 37 insertions(+), 40 deletions(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 0d37c920f00c..1605c26df843 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -769,6 +769,8 @@ int nft_lex(void *, void *, void *);
 %destructor { stmt_free($$); }	stmt match_stmt verdict_stmt set_elem_stmt
 %type <stmt>			counter_stmt counter_stmt_alloc stateful_stmt last_stmt
 %destructor { stmt_free($$); }	counter_stmt counter_stmt_alloc stateful_stmt last_stmt
+%type <stmt>			limit_stmt_alloc
+%destructor { stmt_free($$); }	limit_stmt_alloc
 %type <stmt>			objref_stmt objref_stmt_counter objref_stmt_limit objref_stmt_quota objref_stmt_ct objref_stmt_synproxy
 %destructor { stmt_free($$); }	objref_stmt objref_stmt_counter objref_stmt_limit objref_stmt_quota objref_stmt_ct objref_stmt_synproxy
 
@@ -3177,7 +3179,7 @@ objref_stmt		:	objref_stmt_counter
 			;
 
 stateful_stmt		:	counter_stmt	close_scope_counter
-			|	limit_stmt
+			|	limit_stmt	close_scope_limit
 			|	quota_stmt
 			|	connlimit_stmt
 			|	last_stmt	close_scope_last
@@ -3461,28 +3463,45 @@ log_flag_tcp		:	SEQUENCE
 			}
 			;
 
-limit_stmt		:	LIMIT	RATE	limit_mode	limit_rate_pkts	limit_burst_pkts	close_scope_limit
+limit_stmt_alloc	:	LIMIT	RATE
+			{
+				$$ = limit_stmt_alloc(&@$);
+			}
+			;
+
+limit_stmt		:	limit_stmt_alloc limit_args
+			;
+
+limit_args		:	limit_mode	limit_rate_pkts	limit_burst_pkts
 	    		{
-				if ($5 == 0) {
-					erec_queue(error(&@5, "packet limit burst must be > 0"),
+				struct limit_stmt *limit;
+
+				assert($<stmt>0->type == STMT_LIMIT);
+
+				if ($3 == 0) {
+					erec_queue(error(&@3, "packet limit burst must be > 0"),
 						   state->msgs);
 					YYERROR;
 				}
-				$$ = limit_stmt_alloc(&@$);
-				$$->limit.rate	= $4.rate;
-				$$->limit.unit	= $4.unit;
-				$$->limit.burst	= $5;
-				$$->limit.type	= NFT_LIMIT_PKTS;
-				$$->limit.flags = $3;
+				limit = &$<stmt>0->limit;
+				limit->rate = $2.rate;
+				limit->unit = $2.unit;
+				limit->burst = $3;
+				limit->type = NFT_LIMIT_PKTS;
+				limit->flags = $1;
 			}
-			|	LIMIT	RATE	limit_mode	limit_rate_bytes	limit_burst_bytes	close_scope_limit
+			|	limit_mode	limit_rate_bytes	limit_burst_bytes
 			{
-				$$ = limit_stmt_alloc(&@$);
-				$$->limit.rate	= $4.rate;
-				$$->limit.unit	= $4.unit;
-				$$->limit.burst	= $5;
-				$$->limit.type	= NFT_LIMIT_PKT_BYTES;
-				$$->limit.flags = $3;
+				struct limit_stmt *limit;
+
+				assert($<stmt>0->type == STMT_LIMIT);
+
+				limit = &$<stmt>0->limit;
+				limit->rate = $2.rate;
+				limit->unit = $2.unit;
+				limit->burst = $3;
+				limit->type = NFT_LIMIT_PKT_BYTES;
+				limit->flags = $1;
 			}
 			;
 
@@ -4591,29 +4610,7 @@ set_elem_stmt_list	:	set_elem_stmt
 			;
 
 set_elem_stmt		:	counter_stmt	close_scope_counter
-			|	LIMIT   RATE    limit_mode      limit_rate_pkts       limit_burst_pkts	close_scope_limit
-			{
-				if ($5 == 0) {
-					erec_queue(error(&@5, "limit burst must be > 0"),
-						   state->msgs);
-					YYERROR;
-				}
-				$$ = limit_stmt_alloc(&@$);
-				$$->limit.rate  = $4.rate;
-				$$->limit.unit  = $4.unit;
-				$$->limit.burst = $5;
-				$$->limit.type  = NFT_LIMIT_PKTS;
-				$$->limit.flags = $3;
-			}
-			|       LIMIT   RATE    limit_mode      limit_rate_bytes  limit_burst_bytes	close_scope_limit
-			{
-				$$ = limit_stmt_alloc(&@$);
-				$$->limit.rate  = $4.rate;
-				$$->limit.unit  = $4.unit;
-				$$->limit.burst = $5;
-				$$->limit.type  = NFT_LIMIT_PKT_BYTES;
-				$$->limit.flags = $3;
-			}
+			|	limit_stmt	close_scope_limit
 			|	CT	COUNT	NUM	close_scope_ct
 			{
 				$$ = connlimit_stmt_alloc(&@$);
-- 
2.30.2

