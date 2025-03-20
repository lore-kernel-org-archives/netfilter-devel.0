Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09DD3220683
	for <netfilter-devel@vger.kernel.org>; Thu, 20 Mar 2025 12:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742472670; cv=none; b=Mz5AdmP6IF6IPxmGtx+1DIV1Pk118XkIUwDRmtyDuIGFZ0mZQotDlN4nQ/8quPTBwjylTXKxSMTNPc8lHPUnZ8gwb3bZx+QtDcdD2gh7tuNAhDWttb/oBw/un/d+iVOkk2DAiTCvm2pmBap/YswVqx5X18KBZ/Y12t6omxXCLWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742472670; c=relaxed/simple;
	bh=E9y8vJ0ZkR6ipcxDJtFFuD4dCOU81/k6iGdQKmyOWUE=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cMyiYi02eLWZVONUTfQgc7HzzqjWuZlSRd06wuAd829PTjXZLbGLhiKYpf0qOCQZX0+DCnCr0WtWDGjKrSmvVvURn9t4b40zoru5Q/jeB4t27C3y/qgxCNFCrPH+0Yas7pZ53/BFs9UtVZU0YazOeySfE2NrbZ/PJuHdDgGbMZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Bd8zpzGz; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Bd8zpzGz; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Bd8zpzGz";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Bd8zpzGz"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 6F3D0605B5; Thu, 20 Mar 2025 13:11:06 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1742472666;
	bh=JegvqJg1LmxkFsoTdU6/PGB7t1BKEQ5iJewyx4RKn/o=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Bd8zpzGzf0/YftMXSSR3PANzpV1GYFedp0GUPDRbjMGpXT/MNIKnpmplp9j/bLJG6
	 vp2JA44Bn0jNPKn2XB54YwoM+CsA7Fe6Lb1Hm1WyBCydcqO+EA7ZQ4cSJg4T2G00a5
	 InT+1iuvt6cGthMeBQ1A3gpXIjRedKL37W+IsZoQXq9tJoKl4uz2zsSIBdSIuOR622
	 76mAlM6nhy02jzV1lvx7QOuawvHIv+Abw2B05SI8KB8oWFsR6Yy9Wj8MRUt4exdVyC
	 c1NL/WbU5M7AtkifcA8vBLxZ7mRwpCcLqTzi05N/8ytvuyTpHgI7z2AdNHraJpt4ci
	 +BO1oMdEg2iog==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 01CDC605A5
	for <netfilter-devel@vger.kernel.org>; Thu, 20 Mar 2025 13:11:05 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1742472666;
	bh=JegvqJg1LmxkFsoTdU6/PGB7t1BKEQ5iJewyx4RKn/o=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Bd8zpzGzf0/YftMXSSR3PANzpV1GYFedp0GUPDRbjMGpXT/MNIKnpmplp9j/bLJG6
	 vp2JA44Bn0jNPKn2XB54YwoM+CsA7Fe6Lb1Hm1WyBCydcqO+EA7ZQ4cSJg4T2G00a5
	 InT+1iuvt6cGthMeBQ1A3gpXIjRedKL37W+IsZoQXq9tJoKl4uz2zsSIBdSIuOR622
	 76mAlM6nhy02jzV1lvx7QOuawvHIv+Abw2B05SI8KB8oWFsR6Yy9Wj8MRUt4exdVyC
	 c1NL/WbU5M7AtkifcA8vBLxZ7mRwpCcLqTzi05N/8ytvuyTpHgI7z2AdNHraJpt4ci
	 +BO1oMdEg2iog==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 4/5] parser_bison: consolidate last grammar rule for set elements
Date: Thu, 20 Mar 2025 13:10:58 +0100
Message-Id: <20250320121059.328524-4-pablo@netfilter.org>
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

Define last_stmt_alloc and last_args to follow similar idiom that is
used for counters.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/parser_bison.y | 39 ++++++++++++++++++---------------------
 1 file changed, 18 insertions(+), 21 deletions(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 97b4ead58dbc..c26c99b05830 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -769,8 +769,8 @@ int nft_lex(void *, void *, void *);
 %destructor { stmt_free($$); }	stmt match_stmt verdict_stmt set_elem_stmt
 %type <stmt>			counter_stmt counter_stmt_alloc stateful_stmt last_stmt
 %destructor { stmt_free($$); }	counter_stmt counter_stmt_alloc stateful_stmt last_stmt
-%type <stmt>			limit_stmt_alloc quota_stmt_alloc
-%destructor { stmt_free($$); }	limit_stmt_alloc quota_stmt_alloc
+%type <stmt>			limit_stmt_alloc quota_stmt_alloc last_stmt_alloc
+%destructor { stmt_free($$); }	limit_stmt_alloc quota_stmt_alloc last_stmt_alloc
 %type <stmt>			objref_stmt objref_stmt_counter objref_stmt_limit objref_stmt_quota objref_stmt_ct objref_stmt_synproxy
 %destructor { stmt_free($$); }	objref_stmt objref_stmt_counter objref_stmt_limit objref_stmt_quota objref_stmt_ct objref_stmt_synproxy
 
@@ -3318,19 +3318,25 @@ counter_arg		:	PACKETS			NUM
 			}
 			;
 
-last_stmt		:	LAST
+last_stmt_alloc		:	LAST
 			{
 				$$ = last_stmt_alloc(&@$);
 			}
-			|	LAST USED	NEVER
-			{
-				$$ = last_stmt_alloc(&@$);
-			}
-			|	LAST USED	time_spec
+			;
+
+last_stmt		:	last_stmt_alloc
+			|	last_stmt_alloc 	last_args
+			;
+
+last_args		:	USED NEVER
+			|	USED time_spec
 			{
-				$$ = last_stmt_alloc(&@$);
-				$$->last.used = $3;
-				$$->last.set = true;
+				struct last_stmt *last;
+
+				assert($<stmt>0->type == STMT_LAST);
+				last = &$<stmt>0->last;
+				last->used = $2;
+				last->set = true;
 			}
 			;
 
@@ -4635,16 +4641,7 @@ set_elem_stmt		:	counter_stmt	close_scope_counter
 				$$->connlimit.flags = NFT_CONNLIMIT_F_INV;
 			}
 			|	quota_stmt	close_scope_quota
-			|	LAST USED	NEVER	close_scope_last
-			{
-				$$ = last_stmt_alloc(&@$);
-			}
-			|	LAST USED	time_spec	close_scope_last
-			{
-				$$ = last_stmt_alloc(&@$);
-				$$->last.used = $3;
-				$$->last.set = true;
-			}
+			|	last_stmt	close_scope_last
 			;
 
 set_elem_expr_option	:	TIMEOUT		set_elem_time_spec
-- 
2.30.2

