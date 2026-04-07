Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D45403B8950;
	Tue,  7 Apr 2026 14:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775571357; cv=none; b=ZnziCmLlrPOuRR5iJaB3DPKnFqR1BnYBWKBGTiLP9789RMWoPcsemPcQgej31ZMA2cHvGcQ4dtwm7vEiIeE/XTqQRnYuLQRx60DoesPaYCYyCvigCsf0mlCTE2Sb+Xmg522VkPEYCynJW1T/T03AF+ULerhk8OA0ErkTBwU3VeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775571357; c=relaxed/simple;
	bh=AsCQxqV4NsERfy622sleC6imp1YRQ8OLbVvEAOjx9+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u/dpZubqauN53T0ynZKyAr/qCyaNM6SyUdsKXlQImDtbWirNekV+uAJH09ylvJcttvWCz49wEs1gHkqGgrGcUZfo3TA+XS++XDuJZZy9u3POI+0nhEEABEJMmgJWZ7uo3MUno10r0Agk+ddJ99PDgckY0iSItJqwxVunxmurw/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id ABA5460670; Tue, 07 Apr 2026 16:15:53 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net-next 02/13] netfilter: nf_tables: Fix typo in enum description
Date: Tue,  7 Apr 2026 16:15:29 +0200
Message-ID: <20260407141540.11549-3-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260407141540.11549-1-fw@strlen.de>
References: <20260407141540.11549-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jelle van der Waa <jelle@vdwaa.nl>

Fix the spelling of "options".

Signed-off-by: Jelle van der Waa <jelle@vdwaa.nl>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/uapi/linux/netfilter/nf_tables.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 45c71f7d21c2..dca9e72b0558 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -884,7 +884,7 @@ enum nft_exthdr_flags {
  * @NFT_EXTHDR_OP_TCPOPT: match against tcp options
  * @NFT_EXTHDR_OP_IPV4: match against ipv4 options
  * @NFT_EXTHDR_OP_SCTP: match against sctp chunks
- * @NFT_EXTHDR_OP_DCCP: match against dccp otions
+ * @NFT_EXTHDR_OP_DCCP: match against dccp options
  */
 enum nft_exthdr_op {
 	NFT_EXTHDR_OP_IPV6,
-- 
2.52.0

