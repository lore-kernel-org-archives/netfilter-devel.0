Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 016C51C8FCB;
	Fri, 28 Jun 2024 16:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719590730; cv=none; b=BokPFWT140MTVj08oIhzI3Q413UmwRzc4cws85POPtp+6//BIVvSbB48hD2lNZ7ylGWi0gLAsTAnqkAjEj7WFv4fyjKrdPRNJIudZ6RyjmYV0iNUP0A9otifrHSgzZnVV1Q8RNLzE0kSam0MKC51hCFQabAocXbydHHiIGWtPg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719590730; c=relaxed/simple;
	bh=VEmy2Sb11J421niCprY6n2cZZ1hR1n+GO+j9Aie0zVk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RqVjEn7G2Va3kf2ZZr9qrUeSnYTiBK8RDEV4U7AZa8VAzyVRKLTg+/uvLdnaSoKiB8cU2NfyjrkSpc8Os09ArdvR9UXhX0AVSyXdhE7yuoXP4hiAx2FP2aFYFUvXTCDwy6/BczV+oV5PcF7X/0T0qdWHjoiqFNl14d4b0sIACso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de
Subject: [PATCH net-next 15/17] netfilter: nf_tables: rise cap on SELinux secmark context
Date: Fri, 28 Jun 2024 18:05:03 +0200
Message-Id: <20240628160505.161283-16-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240628160505.161283-1-pablo@netfilter.org>
References: <20240628160505.161283-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

secmark context is artificially limited 256 bytes, rise it to 4Kbytes.

Fixes: fb961945457f ("netfilter: nf_tables: add SECMARK support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/nf_tables.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index aa4094ca2444..639894ed1b97 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -1376,7 +1376,7 @@ enum nft_secmark_attributes {
 #define NFTA_SECMARK_MAX	(__NFTA_SECMARK_MAX - 1)
 
 /* Max security context length */
-#define NFT_SECMARK_CTX_MAXLEN		256
+#define NFT_SECMARK_CTX_MAXLEN		4096
 
 /**
  * enum nft_reject_types - nf_tables reject expression reject types
-- 
2.30.2

