Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B74BB248871
	for <netfilter-devel@vger.kernel.org>; Wed, 26 Mar 2025 21:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743023121; cv=none; b=dhk3waNeE1Edh24sI9N1ZnsuvNH12kKiVDqg8Mmh1R0yMzX7iExDGYngQKF82ebXXTVCypxDbb2S7vODjdTab9IYahnGxfOpez+4FmJQQVNzGrraDOM+kUO1ReDCYFVAcF34ztu8r4CcNju3Wz8B6+TBA3PuqX5RtTAhntXAdts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743023121; c=relaxed/simple;
	bh=WMv88awGxhywiCZ8OK1V2H3FrE5aBQX5uwcQzgJDx6E=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=nWITLK5xhcZaDxIz2O8WdnlPSiDVzT6j4Vymhxrb14IKCpbdvP9gtVT6b96E2JGOWKevPXjF+XIQjuwLyK5EJ8K6U2WwcmBrj1vBN5ez4yktXLn6tleOHvlDkbP5TzmATinWpNnIOypSG3KopAuoRcQrpGAox5mm8KEKAeviAGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=GLT8oxW0; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=fpJr8OQd; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="GLT8oxW0";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="fpJr8OQd"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 4E7CA605B8; Wed, 26 Mar 2025 22:05:16 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1743023116;
	bh=Y63ZrXZdktcaxzWj05e+Lh6OwubsLWwK4RpYN1YIc9E=;
	h=From:To:Cc:Subject:Date:From;
	b=GLT8oxW0HEYwsuSBabRPaC22ctxoAwYytGvY1w3mOqmF/wwxt0VID8SORsfHljUya
	 fabRw8BT/9z3Gdt26RRAv3Fwg4YSxr6P4ajmUvx8SSPncb1k3g3f+EWcly7z/P2at1
	 O1HGYb9cGU2wEsWkmhIcChEsLdmFHtLTFTk6gmRStLxxAlg4hLXIEbwQEAIOydmKrs
	 IPKNmyCauZeWldsn29G3fPsFmYkTAJz6BS2I2obWu4iMXerjVQirRP5KnQGSjzDXiE
	 EWNanTik7X0hPHKXfFl375ulA2kPdkP8QOTfHk/iA1oGRbb4KpaXk68fg0pkgcqrbN
	 +lVmwMO0HFmUQ==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id A1FCD605B8;
	Wed, 26 Mar 2025 22:05:15 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1743023115;
	bh=Y63ZrXZdktcaxzWj05e+Lh6OwubsLWwK4RpYN1YIc9E=;
	h=From:To:Cc:Subject:Date:From;
	b=fpJr8OQdXkerhlEqHSsPcX9VXYrD1L6Dz8yS2z5RxgB5xjmrGlrfbWm+UL/aBsOsj
	 Z6G/g+hlcYHLeOrd2EyVmCXOr1WODSRhsJY8ZCICLnO6AS5M8JNlARZsx/WHrLRzF5
	 tsh238duPtIbF+eMg9VYiCApO+DLMFcKbx49BxmZYbKKWYqUIUVCa5YqPeKJehXHxe
	 GSzICX6g8PYGL9F0WabwSdLOpsgdwxE5vAnUBi0UEKn4gRt6f93aIAXge88X8MC0ua
	 Myd1xeOoQuRg6xdbPJJSrEd5ju4Bt0mff8mAJafxZ4+q/4PDMd1hRoE5IBKmoLUNhf
	 Xl7fHPejr+5mQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: [PATCH nft] expression: update EXPR_MAX to EXPR_RANGE_SYMBOL
Date: Wed, 26 Mar 2025 22:05:11 +0100
Message-Id: <20250326210511.188767-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

EXPR_MAX was never updated to the newest expression.

Fixes: 347039f64509 ("src: add symbol range expression to further compact intervals")
Reported-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
This patch goes before this series:

	src: remove flagcmp expression
	src: transform flag match expression to binop expression from parser
	optimize: compact bitmask matching in set/map
	optimize: incorrect comparison for reject statement

 include/expression.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/expression.h b/include/expression.h
index 8472748621ef..d3f2bab11957 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -85,7 +85,7 @@ enum expr_types {
 	EXPR_RANGE_VALUE,
 	EXPR_RANGE_SYMBOL,
 
-	EXPR_MAX = EXPR_FLAGCMP
+	EXPR_MAX = EXPR_RANGE_SYMBOL
 };
 
 enum ops {
-- 
2.30.2

