Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B804D221549
	for <netfilter-devel@vger.kernel.org>; Thu, 20 Mar 2025 12:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742472671; cv=none; b=XJHlUExz+y8c/mz5JxzOhWErxOXMYkc3opoD2uy9kQklXbiciSN/c2TfiyU1DuacRw/yLR1qi3NORGFQONzxZ2mGzJ3oqM5PjKfGz07v9GNRYi03ggb0PBUqLeFAvTPZx73bGiqQojeyKiFTyLrgi8/K8v/Y4mqbqzrbMsTTnIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742472671; c=relaxed/simple;
	bh=UZWXzzYYDdqRDMPt+KXoL7cuQmEWffR2xM5AOzMda3k=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NPqi4rMnJA2xInlCQoYtUEvTwhMdFwa5UT2d2jAUtVeTN5EBncx6LipSlXQ6bzPbmuj9rZ+huYYa6oRsHUMXu6WYz7R98AMETxblPpMc02tlDf2mWZh+QRLVQvLukJdut49LNAP0LPQwvPv2O2cwkc6pv7kqaD9V4z6fvP9AkXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=oGksHTBO; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=oGksHTBO; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="oGksHTBO";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="oGksHTBO"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 948C6605B7; Thu, 20 Mar 2025 13:11:07 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1742472667;
	bh=snAzgrISVqBz4rKhexRb9l9attokRRwdTjZBRd43Chk=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=oGksHTBO92ryjh8vGCLo6EEJZp6AcWYGOmRU4FuDY4Dujekw2B6Z9dGLTkK9eVdNi
	 OH1AeCxbVUMbVPj2G20A03MLxtEwFmSVEC9FGT0vtfodYiQec/suis1Vm3204hNXfT
	 BI61reWK5Pxwc8zeJ+clgOdXzfBSp1GpU8H0obO6t7YQYmbz32Bj6PSfbfCOsGjLEW
	 kxyTq0Wj2hU0S7zpAdsKnnaeRUEZeMxo9HyGbegAQidxax9N3Dbh+jHez2Nacyxmuz
	 5qeXgnHZgl8xAz+cz9oHr1SzcxjK3UKDZKX92bs7N5TPb4sfaVI5tlP5c3ttBhAhyS
	 orI8O/szAst4g==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 229B0605A5
	for <netfilter-devel@vger.kernel.org>; Thu, 20 Mar 2025 13:11:07 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1742472667;
	bh=snAzgrISVqBz4rKhexRb9l9attokRRwdTjZBRd43Chk=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=oGksHTBO92ryjh8vGCLo6EEJZp6AcWYGOmRU4FuDY4Dujekw2B6Z9dGLTkK9eVdNi
	 OH1AeCxbVUMbVPj2G20A03MLxtEwFmSVEC9FGT0vtfodYiQec/suis1Vm3204hNXfT
	 BI61reWK5Pxwc8zeJ+clgOdXzfBSp1GpU8H0obO6t7YQYmbz32Bj6PSfbfCOsGjLEW
	 kxyTq0Wj2hU0S7zpAdsKnnaeRUEZeMxo9HyGbegAQidxax9N3Dbh+jHez2Nacyxmuz
	 5qeXgnHZgl8xAz+cz9oHr1SzcxjK3UKDZKX92bs7N5TPb4sfaVI5tlP5c3ttBhAhyS
	 orI8O/szAst4g==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 5/5] parser_bison: consolidate connlimit grammar rule for set elements
Date: Thu, 20 Mar 2025 13:10:59 +0100
Message-Id: <20250320121059.328524-5-pablo@netfilter.org>
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

Define ct_limit_stmt_alloc and ct_limit_args to follow similar idiom
that is used for counters.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/parser_bison.y | 41 +++++++++++++++++++++--------------------
 1 file changed, 21 insertions(+), 20 deletions(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index c26c99b05830..25fa69fb6f86 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -769,8 +769,8 @@ int nft_lex(void *, void *, void *);
 %destructor { stmt_free($$); }	stmt match_stmt verdict_stmt set_elem_stmt
 %type <stmt>			counter_stmt counter_stmt_alloc stateful_stmt last_stmt
 %destructor { stmt_free($$); }	counter_stmt counter_stmt_alloc stateful_stmt last_stmt
-%type <stmt>			limit_stmt_alloc quota_stmt_alloc last_stmt_alloc
-%destructor { stmt_free($$); }	limit_stmt_alloc quota_stmt_alloc last_stmt_alloc
+%type <stmt>			limit_stmt_alloc quota_stmt_alloc last_stmt_alloc ct_limit_stmt_alloc
+%destructor { stmt_free($$); }	limit_stmt_alloc quota_stmt_alloc last_stmt_alloc ct_limit_stmt_alloc
 %type <stmt>			objref_stmt objref_stmt_counter objref_stmt_limit objref_stmt_quota objref_stmt_ct objref_stmt_synproxy
 %destructor { stmt_free($$); }	objref_stmt objref_stmt_counter objref_stmt_limit objref_stmt_quota objref_stmt_ct objref_stmt_synproxy
 
@@ -3181,7 +3181,7 @@ objref_stmt		:	objref_stmt_counter
 stateful_stmt		:	counter_stmt	close_scope_counter
 			|	limit_stmt	close_scope_limit
 			|	quota_stmt	close_scope_quota
-			|	connlimit_stmt
+			|	connlimit_stmt	close_scope_ct
 			|	last_stmt	close_scope_last
 			;
 
@@ -3277,16 +3277,27 @@ verdict_map_list_member_expr:	opt_newline	set_elem_expr	COLON	verdict_expr	opt_n
 			}
 			;
 
-connlimit_stmt		:	CT	COUNT	NUM	close_scope_ct
+ct_limit_stmt_alloc	:	CT	COUNT
 			{
 				$$ = connlimit_stmt_alloc(&@$);
-				$$->connlimit.count	= $3;
 			}
-			|	CT	COUNT	OVER	NUM	close_scope_ct
+			;
+
+connlimit_stmt		:	ct_limit_stmt_alloc	ct_limit_args
+			;
+
+ct_limit_args		:	NUM
 			{
-				$$ = connlimit_stmt_alloc(&@$);
-				$$->connlimit.count = $4;
-				$$->connlimit.flags = NFT_CONNLIMIT_F_INV;
+				assert($<stmt>0->type == STMT_CONNLIMIT);
+
+				$<stmt>0->connlimit.count	= $1;
+			}
+			|	OVER	NUM
+			{
+				assert($<stmt>0->type == STMT_CONNLIMIT);
+
+				$<stmt>0->connlimit.count = $2;
+				$<stmt>0->connlimit.flags = NFT_CONNLIMIT_F_INV;
 			}
 			;
 
@@ -4629,17 +4640,7 @@ set_elem_stmt_list	:	set_elem_stmt
 
 set_elem_stmt		:	counter_stmt	close_scope_counter
 			|	limit_stmt	close_scope_limit
-			|	CT	COUNT	NUM	close_scope_ct
-			{
-				$$ = connlimit_stmt_alloc(&@$);
-				$$->connlimit.count	= $3;
-			}
-			|	CT	COUNT	OVER	NUM	close_scope_ct
-			{
-				$$ = connlimit_stmt_alloc(&@$);
-				$$->connlimit.count = $4;
-				$$->connlimit.flags = NFT_CONNLIMIT_F_INV;
-			}
+			|	connlimit_stmt	close_scope_ct
 			|	quota_stmt	close_scope_quota
 			|	last_stmt	close_scope_last
 			;
-- 
2.30.2

