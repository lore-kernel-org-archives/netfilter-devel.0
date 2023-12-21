Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4393F76909
	for <netfilter-devel@vger.kernel.org>; Thu, 21 Dec 2023 13:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="eNuc2suR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=7T7fG7neU7C3pUVfSO19kkUhkPdfbUoBqHId5y14gWI=; b=eNuc2suRzjBY6d/Sf3vQNQ9111
	5ZyCJVkStvLEodhze+l0MVKaUTJsRmRC+NHMJ2FhlijZ1q5Xxy8Zj21sF0MImLaD2F/0zuRgt7HSR
	bfTZ2BipD8X8Xk9whJ+JfQqayIlliuX2E+Bx28Z5gPfiS0z/k428NkGnMMScr9vSIj76CEMJ4o4qC
	qIJzpyJkJxrn6ASNQseOTDiuIyGpRK65XShuUtDVMfgKvH9/Ww+CeYhvzpAT0JJww7vdSHHy+9+71
	V0AUhSDeQ20rUJ4LSxLzdmrhZF/yCCUkeWSqcZqWrVGPnZkjofsh/mYBEyYGnRDikAWaR7Jh3QpLx
	au9jFmzQ==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.94.2)
	(envelope-from <phil@nwl.cc>)
	id 1rGJ9f-0004TY-6d; Thu, 21 Dec 2023 14:32:03 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>,
	Eric Garver <e@erig.me>
Subject: [nf-next PATCH v2 1/3] netfilter: uapi: Document NFT_TABLE_F_OWNER flag
Date: Thu, 21 Dec 2023 14:31:57 +0100
Message-ID: <20231221133159.31198-2-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231221133159.31198-1-phil@nwl.cc>
References: <20231221133159.31198-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add at least this one-liner describing the obvious.

Fixes: 6001a930ce03 ("netfilter: nftables: introduce table ownership")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/uapi/linux/netfilter/nf_tables.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index ca30232b7bc8..fbce238abdc1 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -179,6 +179,7 @@ enum nft_hook_attributes {
  * enum nft_table_flags - nf_tables table flags
  *
  * @NFT_TABLE_F_DORMANT: this table is not active
+ * @NFT_TABLE_F_OWNER:   this table is owned by a process
  */
 enum nft_table_flags {
 	NFT_TABLE_F_DORMANT	= 0x1,
-- 
2.43.0

