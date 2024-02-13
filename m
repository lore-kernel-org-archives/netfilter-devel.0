Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CDBD1E501
	for <netfilter-devel@vger.kernel.org>; Tue, 13 Feb 2024 16:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707841196; cv=none; b=EttqmXgPLtTtOKvnJW+ryzw4OIWpEJLxQ//TfZ5UQnNuZqQ+dboHodMyw93plRaArI9+BVD3FvP1F0v7kpNMKBzVWpqRzDTq3HKdSyXP/aKy7NYTlQRVf/cWTr3wiQ2zrbwXOkVEMiAqxMB2uris4UiPA6MvGuNPfTxmb15dKRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707841196; c=relaxed/simple;
	bh=Bg5BqqGR+dsunqUTKSeVCF1R1utULfslf8q/MuEA3Is=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=BrnX9lkqZP+vpznMG4SNBkAg5366ODJnhenHwGX5Pl2eBPSmzIzGctus5EkQkTLsDObUCWsiQVbENkV9MqgRVdo3bzkoO7OpZaDnE92dyZrC+3IYh47yHPGMPejVb4otl3h6wF0zsMPUnksGTdTlWzB+bYxfny6S9wZRmlqvlyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft] expression: missing line in describe command with invalid expression
Date: Tue, 13 Feb 2024 17:19:39 +0100
Message-Id: <20240213161939.11944-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Before:

 duh@testbed:~# nft describe blah
 symbol expression, datatype invalid (invalid)duh@testbed:#

After:

 duh@testbed:~# nft describe blah
 symbol expression, datatype invalid (invalid)
 duh@testbed:#

Fixes: 48aca2de80a7 ("iptopt: fix crash with invalid field/type combo")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/expression.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/src/expression.c b/src/expression.c
index dde48b6aa002..cb2573fec457 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -140,8 +140,10 @@ void expr_describe(const struct expr *expr, struct output_ctx *octx)
 		nft_print(octx, "%s expression, datatype %s (%s)",
 			  expr_name(expr), dtype->name, dtype->desc);
 
-		if (dtype == &invalid_type)
+		if (dtype == &invalid_type) {
+			nft_print(octx, "\n");
 			return;
+		}
 	}
 
 	if (dtype->basetype != NULL) {
-- 
2.30.2

