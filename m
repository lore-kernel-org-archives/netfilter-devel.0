Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22D741487FA
	for <netfilter-devel@vger.kernel.org>; Sat, 22 Mar 2025 20:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742676222; cv=none; b=gJc1QYPh3jT6DyjasWvPIgt5UQaErPnKdcm+YYKYdc6/J5UWakpVCdcFFC1vpX1lCcKttZvfKGA1geXfVEjUJjaPEfVa2JB8WCCUVbk14NoTXvM7bUDz4LH066Jrv7afX9EzZBE/fmELJ1IICqPFuScPvwZ9pLIz0kalehhdkyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742676222; c=relaxed/simple;
	bh=W32Ka0Y4ogUMy/s/QrHGU19vL2h95WomHyaQVizSHBA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=sARAL1FSJbPLCP4pP9cTNC9JJleL3u0dONbMw/8chqESFkhIp/EzmKtaspycJdNpPMziPKVdu2CgdFm8W9O/+FAUffRe3mnXJTiG8bxDQl6oKXb4HEI6/VEcj5BF0EjJO1+N81nw7Kf1cNLqVvPRDhnrSdybg6XIM2KSDnM9Vyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=CUd9yFQA; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=CUd9yFQA; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="CUd9yFQA";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="CUd9yFQA"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 6AA6560368; Sat, 22 Mar 2025 21:43:30 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1742676210;
	bh=sM4hOjd7ayw7O35j8tNzzbgj//MVKBPVhmBRApDgnnc=;
	h=From:To:Cc:Subject:Date:From;
	b=CUd9yFQAB34qJyMMt2bkWbbKPfUp3ORLeocq7s6bG4xfi9IAQLmhhgfoulB+3cMva
	 JPaCBtzNtVBoV4XICGnnbC6CnoXdIhcKS993Sgkv2pFBk7m+46gKNoJL/Tnsqu0dUE
	 aXPH9Gp+qodVlca9EkYaFJXB2IhZVFYVuab6siOXQ49o7+5c0qh5gdi1B7vVty+Egw
	 ImV7eK+9jY45+2EWCm6KpwJPFuD5Eqo8sVfdziLqrsHwrptpMRG1Gzzn337QHC+nbY
	 OFToF/RjWj0a0XaHOepjglBTDje1RbGq3XwwVwzyhsawyFTn1fK2i6pNeoVQwfber5
	 Alwoqjdo2x6ZA==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id D566760368;
	Sat, 22 Mar 2025 21:43:29 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1742676210;
	bh=sM4hOjd7ayw7O35j8tNzzbgj//MVKBPVhmBRApDgnnc=;
	h=From:To:Cc:Subject:Date:From;
	b=CUd9yFQAB34qJyMMt2bkWbbKPfUp3ORLeocq7s6bG4xfi9IAQLmhhgfoulB+3cMva
	 JPaCBtzNtVBoV4XICGnnbC6CnoXdIhcKS993Sgkv2pFBk7m+46gKNoJL/Tnsqu0dUE
	 aXPH9Gp+qodVlca9EkYaFJXB2IhZVFYVuab6siOXQ49o7+5c0qh5gdi1B7vVty+Egw
	 ImV7eK+9jY45+2EWCm6KpwJPFuD5Eqo8sVfdziLqrsHwrptpMRG1Gzzn337QHC+nbY
	 OFToF/RjWj0a0XaHOepjglBTDje1RbGq3XwwVwzyhsawyFTn1fK2i6pNeoVQwfber5
	 Alwoqjdo2x6ZA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: [PATCH nft] tests: shell: missing ct count elements in new set_stmt test
Date: Sat, 22 Mar 2025 21:43:26 +0100
Message-Id: <20250322204326.2631-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add missing entries to dump file.

Reported-by: Florian Westphal <fw@strlen.de>
Fixes: 1f3d0b9cf9cc ("tests: shell: extend coverage for set element statements")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/shell/testcases/sets/dumps/set_stmt.nft | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tests/shell/testcases/sets/dumps/set_stmt.nft b/tests/shell/testcases/sets/dumps/set_stmt.nft
index f8cf08a1cb7b..71ba7996329a 100644
--- a/tests/shell/testcases/sets/dumps/set_stmt.nft
+++ b/tests/shell/testcases/sets/dumps/set_stmt.nft
@@ -20,6 +20,10 @@ table ip x {
 	set y2 {
 		type ipv4_addr
 		ct count over 2
+		elements = { 2.2.2.2 ct count over 5,
+			     3.3.3.2 ct count over 2,
+			     5.5.5.2 ct count over 2,
+			     6.6.6.2 ct count over 5 }
 	}
 
 	set y3 {
-- 
2.30.2

