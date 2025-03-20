Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB91E2063C5
	for <netfilter-devel@vger.kernel.org>; Thu, 20 Mar 2025 12:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742472669; cv=none; b=hveUntHiLSkQ4NNRV8i7Xim/1qMedX+NXhEZAn0x/pSmMLk7A/7GBxp/3I4/t71V8PIVbOTITQrrnP84xBxzBYi0/G5zJPoOzG6fwC+7SzjPzrbKm6TSA0Vg4QE7xk0zWGOH8l/O5vfPHEblQOYQpiJlDRyhrtxuEjoIwUWihQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742472669; c=relaxed/simple;
	bh=ub9GuSF8v5Kw2FbbwBJ8tNbU06XxBoJLDo1iMgi8T6Q=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=CMM48LRqPBkgvvJA4vclw+7PmE9T2DIhYXPHzRWoB4jnE8rVerj7KY6f9IpDVXCo7Xlak9hL89KbqjINNtykSF9jfT7t9kyiFbb4OYG8cff5goExMlZdnoGQv07p57mbPHAu51qAdAc4RLWlkhfQZp17HphDsjgQap4oPaogRjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=CV2DyA7w; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=nIfcF6Dx; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="CV2DyA7w";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="nIfcF6Dx"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 0618E605B0; Thu, 20 Mar 2025 13:11:04 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1742472664;
	bh=CcZLGhP7qaNimQOzBWCNjHffyryWdpT1/h6MtTiq75M=;
	h=From:To:Subject:Date:From;
	b=CV2DyA7wCyIHUvEcAvlMMNLLXiH2Gx7vplbyrW7C6pMbXOMSirJPyQhcX9qRVZ7Th
	 Gg2mgZYkkzWJvLU7H0BeDLpwLZjA3GUQEQtLAbbQCq9TgikRr4D4S4vSupTKW8XhHL
	 vlxKIm1LLpB6b/scnPQemFkiUNqO/v3F0aESCxNvQFjcKkZQg1cAF6VTYG//3VUzjJ
	 uuv8YD5O+DGfSPjDxNPbHUq64Ib3tYNkIXohzrApYwJRGy5bXJnFY9RQMwGeZyvQWB
	 ahsVx8eBHIAYUvzI2mQElmXwbrXk26mXtApofHSG5D6o0KODPgvkCSjMhrAIESRjeX
	 sYwW+qDy/XyWA==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 9CF3E605A5
	for <netfilter-devel@vger.kernel.org>; Thu, 20 Mar 2025 13:11:03 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1742472663;
	bh=CcZLGhP7qaNimQOzBWCNjHffyryWdpT1/h6MtTiq75M=;
	h=From:To:Subject:Date:From;
	b=nIfcF6DxG/+n+9SL1OyUTubaNnMwyc8t3AZSsRx3MdxJgPSPiv4i2jUk2IwT+T0ZH
	 CfTybImv6A467EzjXqyFIf2ogRPpyVnPZ17WyA9Az1loCnUEf1AZ93lGpSSXWtwB7g
	 EOEpyiXz0pbHSG7LWILXO3mKhYdKrtaAOIBtKFkZ0+czH71u/Aa0lthMDuYA5ZBLnR
	 0+Ktxhxnl3b971BYiKDaaDTxKDIQUfEVJbkSEIuHivJMThxQiwyQ/fA5T3ZclXmUCh
	 Mrj2Jn/Eob52Z/B5y9/oJ/+NT+5zIg1+lESkzwfVk8jdnFzOvmv2CBWTQDS+1RcDM6
	 3Bg46SaOyWnPQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 1/5] parser_bison: consolidate counter grammar rule for set elements
Date: Thu, 20 Mar 2025 13:10:55 +0100
Message-Id: <20250320121059.328524-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use existing grammar rules to parse counters to simplify parser.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/parser_bison.y | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 4d4d39342bf7..0d37c920f00c 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -4590,16 +4590,7 @@ set_elem_stmt_list	:	set_elem_stmt
 			}
 			;
 
-set_elem_stmt		:	COUNTER	close_scope_counter
-			{
-				$$ = counter_stmt_alloc(&@$);
-			}
-			|	COUNTER	PACKETS	NUM	BYTES	NUM	close_scope_counter
-			{
-				$$ = counter_stmt_alloc(&@$);
-				$$->counter.packets = $3;
-				$$->counter.bytes = $5;
-			}
+set_elem_stmt		:	counter_stmt	close_scope_counter
 			|	LIMIT   RATE    limit_mode      limit_rate_pkts       limit_burst_pkts	close_scope_limit
 			{
 				if ($5 == 0) {
-- 
2.30.2

