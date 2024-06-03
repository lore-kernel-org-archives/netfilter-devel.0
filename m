Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6E6F7C6D5
	for <netfilter-devel@vger.kernel.org>; Mon,  3 Jun 2024 18:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717438636; cv=none; b=HLwDCS9ME7xjS5KLZfQqaIyYYrvOM7odj8I9HBFcgijvniT6nIFGju4EZysCM+ZJNfM77gvAgv//2XnbzrbaJI7dqx6R/qsD+dQ8qY/WmMGzlphH/GUUMaAnT5Xa4CXg2MuRrEm55z7eioK8TDIXavdx4rdPyBCi7sK8+YlH0a4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717438636; c=relaxed/simple;
	bh=VEmy2Sb11J421niCprY6n2cZZ1hR1n+GO+j9Aie0zVk=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=MhWwIx+EoC8SdJ3qyyT+9EQR+5jxtxS6om/fT+C46BCA8XW3eP7CFfGN1THKrfb+erzX5PQSIRFCzyIQdFDc005SyLlTJ4h6MNmfbcRgSN5Tv+8W6GKO0uzx0xvq4+464toLMgBo02n8mt6ebHYxt43CrqOFXYNz3BdOy7nRqh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next] netfilter: nf_tables: rise cap on SELinux secmark context
Date: Mon,  3 Jun 2024 20:16:59 +0200
Message-Id: <20240603181659.5998-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
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

