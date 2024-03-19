Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A37E1BF53
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Mar 2024 17:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710868355; cv=none; b=rw2MQtxGLHHMxr7D0wmf3QaXmxk040OxqhXehvhyl40W0P0uSZwdiryUVDElTGp8FcYlCeXpjEYrUPS0WciXjHIWFSBDso/NE8wvXIy4gkEAONxlRIAGlCpMD/qkZsnitKshlKQiH7IVzBLsU3qE4s/KTEl87MiAWzSZb0lMAAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710868355; c=relaxed/simple;
	bh=catDSOm95uXib8tbLA7nwqSgFX7O0HIHv23KRF4g8wc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iRLKJ3U7QjFiKGq30kfMaAqAq+ELFukwJzGLn8zX6jSddhsrDEV6xXpRrZK6TzyT9ZmCU+aHW/xChMD1nUkUXyLnw1DUFpe30+RpndLGmMWvWJ4jLMVhhXAmaWbjmTAPhWDUs3sWu9HbdsQGavYYAuqk7flUKdf8aysVAdjJucg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=GSJZ+Y8f; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="GSJZ+Y8f"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=rKct6jsbQDrFrfKk+N+Pn6H5ADV4E49SXwAWWzmsoaE=; b=GSJZ+Y8fEB8PW1cwz7Pt7WYmME
	XFD6VxKCT28fYMJiVUMorarBOzYSKxxSUto95XJIX6OF9T6Z2CdA5aG1TGF9M9CYLl7nF9dfAmBT8
	3Za1zm1ki+P1DNSuq5K7DRle61jWWhRomPHTd3PmmlTOsP2aSYf60iwGT5hfXjeIN5LxviAGnrJrz
	Em9WwcQEfvjiF0A/X2G75AmxsPMEkwE/Ba1lxRPTWuIoPE4Zv4uRbl+7IpQ0S5DD7CIKJXERdBXDG
	W+8oA09FKdKjQePhD18chApkuJbxQ2Tag/XHaZk5G7EoPpuUFIqYXFgO+5EWMd7Pm4l3RHTLR/oSg
	rpyWFonA==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1rmd0q-000000007g3-2ifZ;
	Tue, 19 Mar 2024 18:12:32 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [libnftnl PATCH 02/17] table: Validate NFTNL_TABLE_USE, too
Date: Tue, 19 Mar 2024 18:12:09 +0100
Message-ID: <20240319171224.18064-3-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240319171224.18064-1-phil@nwl.cc>
References: <20240319171224.18064-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fixes: 53c0ff324598c ("src: add nft_*_attr_{set|get}_data interface")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/table.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/table.c b/src/table.c
index 59e7053ac3c0d..4a439ff5ab996 100644
--- a/src/table.c
+++ b/src/table.c
@@ -88,6 +88,7 @@ static uint32_t nftnl_table_validate[NFTNL_TABLE_MAX + 1] = {
 	[NFTNL_TABLE_FLAGS]	= sizeof(uint32_t),
 	[NFTNL_TABLE_FAMILY]	= sizeof(uint32_t),
 	[NFTNL_TABLE_HANDLE]	= sizeof(uint64_t),
+	[NFTNL_TABLE_USE]	= sizeof(uint32_t),
 };
 
 EXPORT_SYMBOL(nftnl_table_set_data);
-- 
2.43.0

