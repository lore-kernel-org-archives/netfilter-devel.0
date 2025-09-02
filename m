Received: from localhost.localdomain (203.red-83-63-38.staticip.rima-tde.net [83.63.38.203])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B98D2765C0
	for <netfilter-devel@vger.kernel.org>; Tue,  2 Sep 2025 11:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.63.38.203
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756812750; cv=none; b=Ia2MK16fSVnLsQa3ZKdo2Qu872pcVsNy8jW6nTY4IPR56gu1JoYKV3qTUzx+w9xmK5/MCsFoo0Lr9dSpw1/jDNi2hJ34SIvFEzaXEk7Z+Cz0WAtYd5X1A4jrKvjWxThze2t/2gnVY+6F4bpGBLleou4xUxgRfPOZUwA5UpEIBYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756812750; c=relaxed/simple;
	bh=Du7Dai51aq825VsOVPhygFZzaO4C9dDbNgnMLh/KKVc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=csjJWtv+LDe+vGQ/7cENnVDMq5ZuvDh40b22c7aShFl/x5DlnQK1Sm+CmaN5IAioPTDf8rR4xl21vfG+a83ln0mPo3oxwvbJaM+IBFZTLPnZXuKPYXl1h+Ik/LlyT1PIBLK5M/2TNF+aEGgl4h51Pqi/ENxQXB2FAV4IVGrRCsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=suse.de; spf=none smtp.mailfrom=localhost.localdomain; arc=none smtp.client-ip=83.63.38.203
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=localhost.localdomain
Received: by localhost.localdomain (Postfix, from userid 1000)
	id 0B35324DA0B4; Tue,  2 Sep 2025 13:32:28 +0200 (CEST)
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH libnftnl] expr: meta: introduce ibrhwdr meta expression
Date: Tue,  2 Sep 2025 13:32:16 +0200
Message-ID: <20250902113216.5275-1-fmancera@suse.de>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
---
 include/linux/netfilter/nf_tables.h | 2 ++
 src/expr/meta.c                     | 3 ++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 2beb30b..a0d9daa 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -959,6 +959,7 @@ enum nft_exthdr_attributes {
  * @NFT_META_SDIF: slave device interface index
  * @NFT_META_SDIFNAME: slave device interface name
  * @NFT_META_BRI_BROUTE: packet br_netfilter_broute bit
+ * @NFT_META_BRI_IIFHWADDR: packet input bridge interface ethernet address
  */
 enum nft_meta_keys {
 	NFT_META_LEN,
@@ -999,6 +1000,7 @@ enum nft_meta_keys {
 	NFT_META_SDIFNAME,
 	NFT_META_BRI_BROUTE,
 	__NFT_META_IIFTYPE,
+	NFT_META_BRI_IIFHWADDR,
 };
 
 /**
diff --git a/src/expr/meta.c b/src/expr/meta.c
index d1ff6c4..cbb9f92 100644
--- a/src/expr/meta.c
+++ b/src/expr/meta.c
@@ -18,7 +18,7 @@
 #include <libnftnl/rule.h>
 
 #ifndef NFT_META_MAX
-#define NFT_META_MAX (NFT_META_BRI_BROUTE + 1)
+#define NFT_META_MAX (NFT_META_BRI_IIFHWADDR + 1)
 #endif
 
 struct nftnl_expr_meta {
@@ -163,6 +163,7 @@ static const char *meta_key2str_array[NFT_META_MAX] = {
 	[NFT_META_SDIF]		= "sdif",
 	[NFT_META_SDIFNAME]	= "sdifname",
 	[NFT_META_BRI_BROUTE]	= "broute",
+	[NFT_META_BRI_IIFHWADDR] = "ibrhwdr",
 };
 
 static const char *meta_key2str(uint8_t key)
-- 
2.51.0

