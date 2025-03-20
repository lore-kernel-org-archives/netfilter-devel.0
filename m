Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF7AD21E0A2
	for <netfilter-devel@vger.kernel.org>; Thu, 20 Mar 2025 12:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742472670; cv=none; b=jj8k7P1TzWcrwCYVcK5xkb5LsuH1vlUPhHzWBCHTlwNf3OsO2WrFCelg3eLYVvE6HzrvUIeTnypUhcidIPaNdyXHKz7W25ZjaKLk9gscj+/WCNlazD7JkuVUHxGTDXQwOOEu58jGXFOnPBTvNkNu+0yJA7bet/xBlq8olgeroAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742472670; c=relaxed/simple;
	bh=mhuXINhK57Qe6QNrMINoNNhcOpqqijIPexH5MRA9JGs=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=S/QC9z8WcU51n1IMYP36PtCR98Xje7saogZ/wE9pMs9NM6IzLcK1iI3DhNjVFy5NqixCYdNDV9uKEcPNwcBfL0MuEUPSQ7bQFZirMSWeCP6Ft2oS0NgDWv4NG3Ux5y33RTVixFe45zmHZKqSmsY/Vht1I0v3nfY9LlUQbtk+A14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=qXMV5HSy; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=qXMV5HSy; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="qXMV5HSy";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="qXMV5HSy"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id D2E07605B3; Thu, 20 Mar 2025 13:11:05 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1742472665;
	bh=6HrUz/jBUvidM7XUNq9gHJMUqRy1fX2wnsiFB+zRmMw=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=qXMV5HSy8fgbgqo0aKdeBODdRnGvHMYkgEuOyXdfRHQ3+PK2dFRGJY7Sw4uSY151+
	 Ockj0bH4Wg8EqcRa/elpsCOFNcbdkdFfzYgNLEJ0cxcqYRrLz9kOpaboqgrivX7HY2
	 ToJOk7MAdr38QNK8IV1CtG4bRUCdTZVM5pGUhDAbKbZP2Gxb5qwPcY0tMp++eTcXaC
	 L1tgtmnaveZIVhJxc4up3woSZKH6mUNkWO0gkTqrvYUI+h5jzZ4ZWIvkSwiG3+0bfc
	 12TbmmpX4Am5TsCyFgIQG4qxLlHEPGiPVFDhWl76n4V3BWHidYnCkvsUx/i7ngEmJW
	 JgiGWT06rZ0sQ==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 6A8F2605A5
	for <netfilter-devel@vger.kernel.org>; Thu, 20 Mar 2025 13:11:05 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1742472665;
	bh=6HrUz/jBUvidM7XUNq9gHJMUqRy1fX2wnsiFB+zRmMw=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=qXMV5HSy8fgbgqo0aKdeBODdRnGvHMYkgEuOyXdfRHQ3+PK2dFRGJY7Sw4uSY151+
	 Ockj0bH4Wg8EqcRa/elpsCOFNcbdkdFfzYgNLEJ0cxcqYRrLz9kOpaboqgrivX7HY2
	 ToJOk7MAdr38QNK8IV1CtG4bRUCdTZVM5pGUhDAbKbZP2Gxb5qwPcY0tMp++eTcXaC
	 L1tgtmnaveZIVhJxc4up3woSZKH6mUNkWO0gkTqrvYUI+h5jzZ4ZWIvkSwiG3+0bfc
	 12TbmmpX4Am5TsCyFgIQG4qxLlHEPGiPVFDhWl76n4V3BWHidYnCkvsUx/i7ngEmJW
	 JgiGWT06rZ0sQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 3/5] parser_bison: consolidate quota grammar rule for set elements
Date: Thu, 20 Mar 2025 13:10:57 +0100
Message-Id: <20250320121059.328524-3-pablo@netfilter.org>
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

Define quota_stmt_alloc and quota_args to follow similar idiom that is
used for counters.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/parser_bison.y | 49 ++++++++++++++++++++++------------------------
 1 file changed, 23 insertions(+), 26 deletions(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 1605c26df843..97b4ead58dbc 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -769,8 +769,8 @@ int nft_lex(void *, void *, void *);
 %destructor { stmt_free($$); }	stmt match_stmt verdict_stmt set_elem_stmt
 %type <stmt>			counter_stmt counter_stmt_alloc stateful_stmt last_stmt
 %destructor { stmt_free($$); }	counter_stmt counter_stmt_alloc stateful_stmt last_stmt
-%type <stmt>			limit_stmt_alloc
-%destructor { stmt_free($$); }	limit_stmt_alloc
+%type <stmt>			limit_stmt_alloc quota_stmt_alloc
+%destructor { stmt_free($$); }	limit_stmt_alloc quota_stmt_alloc
 %type <stmt>			objref_stmt objref_stmt_counter objref_stmt_limit objref_stmt_quota objref_stmt_ct objref_stmt_synproxy
 %destructor { stmt_free($$); }	objref_stmt objref_stmt_counter objref_stmt_limit objref_stmt_quota objref_stmt_ct objref_stmt_synproxy
 
@@ -3180,7 +3180,7 @@ objref_stmt		:	objref_stmt_counter
 
 stateful_stmt		:	counter_stmt	close_scope_counter
 			|	limit_stmt	close_scope_limit
-			|	quota_stmt
+			|	quota_stmt	close_scope_quota
 			|	connlimit_stmt
 			|	last_stmt	close_scope_last
 			;
@@ -3530,21 +3530,33 @@ quota_used		:	/* empty */	{ $$ = 0; }
 			}
 			;
 
-quota_stmt		:	QUOTA	quota_mode NUM quota_unit quota_used	close_scope_quota
+quota_stmt_alloc	:	QUOTA
+			{
+				$$ = quota_stmt_alloc(&@$);
+			}
+			;
+
+quota_stmt		:	quota_stmt_alloc quota_args
+			;
+
+quota_args		:	quota_mode NUM quota_unit quota_used
 			{
 				struct error_record *erec;
+				struct quota_stmt *quota;
 				uint64_t rate;
 
-				erec = data_unit_parse(&@$, $4, &rate);
-				free_const($4);
+				assert($<stmt>0->type == STMT_QUOTA);
+
+				erec = data_unit_parse(&@$, $3, &rate);
+				free_const($3);
 				if (erec != NULL) {
 					erec_queue(erec, state->msgs);
 					YYERROR;
 				}
-				$$ = quota_stmt_alloc(&@$);
-				$$->quota.bytes	= $3 * rate;
-				$$->quota.used = $5;
-				$$->quota.flags	= $2;
+				quota = &$<stmt>0->quota;
+				quota->bytes = $2 * rate;
+				quota->used = $4;
+				quota->flags = $1;
 			}
 			;
 
@@ -4622,22 +4634,7 @@ set_elem_stmt		:	counter_stmt	close_scope_counter
 				$$->connlimit.count = $4;
 				$$->connlimit.flags = NFT_CONNLIMIT_F_INV;
 			}
-			|	QUOTA	quota_mode NUM quota_unit quota_used	close_scope_quota
-			{
-				struct error_record *erec;
-				uint64_t rate;
-
-				erec = data_unit_parse(&@$, $4, &rate);
-				free_const($4);
-				if (erec != NULL) {
-					erec_queue(erec, state->msgs);
-					YYERROR;
-				}
-				$$ = quota_stmt_alloc(&@$);
-				$$->quota.bytes	= $3 * rate;
-				$$->quota.used = $5;
-				$$->quota.flags	= $2;
-			}
+			|	quota_stmt	close_scope_quota
 			|	LAST USED	NEVER	close_scope_last
 			{
 				$$ = last_stmt_alloc(&@$);
-- 
2.30.2

