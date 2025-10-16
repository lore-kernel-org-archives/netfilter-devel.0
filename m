Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A4BC342CA0
	for <netfilter-devel@vger.kernel.org>; Thu, 16 Oct 2025 15:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760626818; cv=none; b=mciyEY2bJW1WuVaT40AH+VX+bMsHH4UGV4jtTfSP6RqI2+Aend68siZ0aQSXGjJpIEpGoc6xBunsegl34qHvW0zdiLIEpePD4iJl6bqioTaESiOihmVej/56YqVtu6k914RiRxAhyurbR891LzVouS30nrfPIqlbxJ8FhMtJhIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760626818; c=relaxed/simple;
	bh=druO0CAxq+a0WtJjGTCZ1t1+jmTCwzVlnP72ep5bA6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f6C4hPv4QRNsG4Dn9fOysL0pIp7JjAc6uwgE/LnKLDbByTfJwSRmRYJJa0eVQDhtnU44fzRmMIY8m8XkXmnPLFJ+lWvG0DPzl5Jd4Gx8kfq0YSnTPVF8YYI5OmJW/nKGWI4fNoIvYUBdpvRpEl/0OZYlLKJ/DdkMfzk2+uLbbMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id B213D6109E; Thu, 16 Oct 2025 17:00:14 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 3/4] src: parser_bison: prevent multiple ip daddr/saddr definitions
Date: Thu, 16 Oct 2025 16:59:35 +0200
Message-ID: <20251016145955.7785-4-fw@strlen.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251016145955.7785-1-fw@strlen.de>
References: <20251016145955.7785-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

minor change to the bogon makes it assert because symbolic expression
will have wrong refcount (2) at scope teardown.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/parser_bison.y                              | 17 +++++++++++++++++
 .../bogons/nft-f/tunnel_with_anon_set_assert    |  1 +
 2 files changed, 18 insertions(+)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index b63c7df18a35..4e028d31c165 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -5070,21 +5070,38 @@ tunnel_config		:	ID	NUM
 			}
 			|	IP	SADDR	symbol_expr	close_scope_ip
 			{
+				if (already_set($<obj>0->tunnel.src, &@3, state)) {
+					expr_free($3);
+					YYERROR;
+				}
+
 				$<obj>0->tunnel.src = $3;
 				datatype_set($3, &ipaddr_type);
 			}
 			|	IP	DADDR	symbol_expr	close_scope_ip
 			{
+				if (already_set($<obj>0->tunnel.dst, &@3, state)) {
+					expr_free($3);
+					YYERROR;
+				}
 				$<obj>0->tunnel.dst = $3;
 				datatype_set($3, &ipaddr_type);
 			}
 			|	IP6	SADDR	symbol_expr	close_scope_ip6
 			{
+				if (already_set($<obj>0->tunnel.src, &@3, state)) {
+					expr_free($3);
+					YYERROR;
+				}
 				$<obj>0->tunnel.src = $3;
 				datatype_set($3, &ip6addr_type);
 			}
 			|	IP6	DADDR	symbol_expr	close_scope_ip6
 			{
+				if (already_set($<obj>0->tunnel.dst, &@3, state)) {
+					expr_free($3);
+					YYERROR;
+				}
 				$<obj>0->tunnel.dst = $3;
 				datatype_set($3, &ip6addr_type);
 			}
diff --git a/tests/shell/testcases/bogons/nft-f/tunnel_with_anon_set_assert b/tests/shell/testcases/bogons/nft-f/tunnel_with_anon_set_assert
index 6f7b212aefef..d02568944301 100644
--- a/tests/shell/testcases/bogons/nft-f/tunnel_with_anon_set_assert
+++ b/tests/shell/testcases/bogons/nft-f/tunnel_with_anon_set_assert
@@ -3,6 +3,7 @@ define s = { 1.2.3.4, 5.6.7.8 }
 table netdev x {
 	tunnel t {
 		ip saddr $s
+		ip saddr $s
 	}
 	}
 
-- 
2.51.0

