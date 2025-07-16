Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA72D2F5303
	for <netfilter-devel@vger.kernel.org>; Wed, 16 Jul 2025 12:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752669629; cv=none; b=O0XICjAccl7fhIZK/wMx35U7BCtbjy3i5LlL0PdoQPsf+BeN9rzWDDB49v4zFvRxTBUZREtZrXhMtaJKms/eCY2zLfrxMjiQcCQauGv4DH6vW4U9X1XhSF4nRRO1XXa7zRkY/7m+SZY1CTTPipabZjLWmacrE/WNpaBtP38TcYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752669629; c=relaxed/simple;
	bh=76ZKN3zey4EhZHiXOWXXjZEj00uyfKBB9LgiHP3Zl/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZgSTNWPQKCHbAKelN5Zw5BbGTx+StQK8PeY4+l+4NnY3U+LSaY37ZYnvHjzASzAI+vjZd2uEX779/xiNLnnwcZ/dgKTn8KePaSc9YuEkmBKtpzbXAA9Uum2fDf/gmJVhBpsBW4uKgqAVYnjY2gip/elIvFP7VfUG5iPo8NDwj/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=FngaH4BI; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="FngaH4BI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=lAeEl9QCLWoWmhBHUc1zmsddRjswvtfDbBPPCetD6OM=; b=FngaH4BIlrgo8axJuZxUfWxdPZ
	O7pc+oIsUUdM7UIfrVnPl4+MheI1dHL6m5b84kk7LODJ2Y/dFfZuC+CcwNGbsgFl6yFBKradA31op
	e7HHtPDKavQ2T++SOkMHFWf4ILkCF6eqNLbjIu1GS76NDPR7LcAOwG/f8AxM7sVaHVeXUX7cYGZNp
	Fj+k+BQvvV0+fm5GpJGa1JIEHt2U5Z6xrj5DNi4cLeGiN9cPWoDHMRJBMUfYQnc5JNRsSm97ZKX39
	pZDBvVcyW0eM7yMR74F1E1jqYWwPVLNK8u/lzMLhpwcEOIhwf2xyjNPWLuEdfU6aHQnU5ED+feIG0
	tzDm+J9Q==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uc1Qv-0000000043y-3Kwp;
	Wed, 16 Jul 2025 14:40:25 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org
Subject: [nft PATCH v3 3/4] parser_bison: Accept ASTERISK_STRING in flowtable_expr_member
Date: Wed, 16 Jul 2025 14:40:19 +0200
Message-ID: <20250716124020.5447-4-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250716124020.5447-1-phil@nwl.cc>
References: <20250716124020.5447-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

All clauses are identical, so instead of adding a third one for
ASTERISK_STRING, use a single one for 'string' (which combines all three
variants).

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/parser_bison.y | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 5b84331f220d3..c31fd05ec09cd 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -2472,16 +2472,7 @@ flowtable_list_expr	:	flowtable_expr_member
 			|	flowtable_list_expr	COMMA	opt_newline
 			;
 
-flowtable_expr_member	:	QUOTED_STRING
-			{
-				struct expr *expr = ifname_expr_alloc(&@$, state->msgs, $1);
-
-				if (!expr)
-					YYERROR;
-
-				$$ = expr;
-			}
-			|	STRING
+flowtable_expr_member	:	string
 			{
 				struct expr *expr = ifname_expr_alloc(&@$, state->msgs, $1);
 
-- 
2.49.0

