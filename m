Received: from azazel.net (taras.nevrast.org [35.176.194.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E41E81465B9
	for <netfilter-devel@vger.kernel.org>; Wed,  3 Apr 2024 12:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.176.194.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712147399; cv=none; b=YDwMxPonfbjShgXPSRMVt9f6lOxDNA2EDl9M5aXddpfXUcOESSPDEJKyTQtb1b8anY5NCm0sUEQaP/xBGyZIsfNcAu0HpG4sdPK7Fj4K2wWgc0T9v5GCeC/mIm7MC0yns0VVQpmk1zdn65t8FGAzVXnc45kE0ohBhkRekcWNTi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712147399; c=relaxed/simple;
	bh=aCi4Na4ck4bx8W5akCYJ9jiW+WTZ+fRdbGwXMxnIcKY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GN9CXuVeONRsGdT+/qRAONEWjPoVKmRh5R2/EBBZfGPINj/Q+OBRyjGaeqAclKXLsJ1WjpvjsYWrtkb86sHo4L+lGepSY6egRjX/W34eN0bA1xBYh0PmEb4rstmLNecaH1SEJD3eF4/kl020IN4UlvBUETRAbh8thIR73QgoXUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net; spf=pass smtp.mailfrom=azazel.net; dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b=j0D3dr+0; arc=none smtp.client-ip=35.176.194.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=azazel.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="j0D3dr+0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=3pqArfhh3gJbAyCVjORpTvQXMLgwTCYMXyLLOV6TFpY=; b=j0D3dr+0XebPEH0nQr07p8g6gK
	XeKJFOACfEkLQIdGId8ykNgh8ZOEo/S8a33VhAqSDsijKliI35n4Eozeuxw1bpRKO+UyVIDZeBNFh
	4W/vha8TaQX8dc0MCEeKTewF8fi6Md0mJRFiGSoEiNXu2TAw9h6jX7cF9UmYRsgzM3OjCrGAzFKSf
	91CCA3lQJPyPvd6xhqzeBac9QBop+zz2sOq1qdxlqhPVj5k9eWnx/5lbna6zcuIeMMA/LlwCufLZx
	Pox29a5gWrJAhUcb0z5UTeIxgDf3n1jum9eBgKvEMocRVqf8ndk9kwexzzeT2ErUvaNjVkguwkwzJ
	FyL8uKVw==;
Received: from [2001:8b0:fb7d:d6d6:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
	by taras.nevrast.org with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <jeremy@azazel.net>)
	id 1rrzRD-00HR7h-0V
	for netfilter-devel@vger.kernel.org;
	Wed, 03 Apr 2024 13:09:55 +0100
From: Jeremy Sowden <jeremy@azazel.net>
To: Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nft v2 1/2] evaluate: handle invalid mapping expressions in stateful object statements gracefully.
Date: Wed,  3 Apr 2024 13:09:36 +0100
Message-ID: <20240403120937.4061434-2-jeremy@azazel.net>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240403120937.4061434-1-jeremy@azazel.net>
References: <20240403120937.4061434-1-jeremy@azazel.net>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d6:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false

Currently, they are reported as assertion failures:

  BUG: invalid mapping expression variable
  nft: src/evaluate.c:4618: stmt_evaluate_objref_map: Assertion `0' failed.
  Aborted

Instead, report them more informatively as errors:

  /space/azazel/tmp/ruleset.1067161.nft:15:29-38: Error: invalid mapping expression variable
      quota name ip saddr map $quota_map
                 ~~~~~~~~     ^^^^^^^^^^

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/evaluate.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 1682ba58989e..f28ef2aad8f4 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -4615,8 +4615,9 @@ static int stmt_evaluate_objref_map(struct eval_ctx *ctx, struct stmt *stmt)
 					  "Expression is not a map with objects");
 		break;
 	default:
-		BUG("invalid mapping expression %s\n",
-		    expr_name(map->mappings));
+		return expr_binary_error(ctx->msgs, map->mappings, map->map,
+					 "invalid mapping expression %s",
+					 expr_name(map->mappings));
 	}
 
 	if (!datatype_compatible(map->mappings->set->key->dtype, map->map->dtype))
-- 
2.43.0

