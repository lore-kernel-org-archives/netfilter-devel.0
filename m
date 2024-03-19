Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2C6222EE8
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Mar 2024 17:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710868358; cv=none; b=n7J4PbM3cdR6mPHIN/3xEiOrhEG4gj4qS9USsL/o394PM7u+k3xgolFcq7Dh7zWRgQ0jJGYT6U6yPKMgwyYWzYwdYt1MAbJ0VO4tHwZXUvwnt5VgnQu3BJMp7zKulfMabIU2aMVophMbbemBYKsU2TH/Qlm+hy8Zn/lAyxgnyS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710868358; c=relaxed/simple;
	bh=gUv0r1OFuauc0u4+YpEoJstglotVIhs36zwVaB10zyg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HSYA4mqOYEPGVC+gYTj+w68GIdRd9WZ7qPtuUIsTKWtgXUb9Bx8FD0kQyFxwLM6BApJd0BKgsthfS1DgVr7XM5yhlEDJ79UonHCJ/5kdXWaTghiqTMT6YAbrDo5yL9ncOtZOSX7xp2qv1o1RP8OnDNaJatuN6IcuYDSNJFoW4Ec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=YSzdZ8NG; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="YSzdZ8NG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=rWjb4CC4VO9M+ZQNTx1uJ+o7GMdEzSMngeVqZehSaMY=; b=YSzdZ8NGBNxMhLDzAyA6FX6b1Z
	EemhFRDL/9kcuBGdFzl4ymQc68FbtcKNKGSTq2nD3MGSoIp8sny7lpm8w4lKAPFzrNfiBw4GZqYtn
	xd7Rco3E1vnrZ9xJSww1zP70HSzIPnzilPIMOZuDusrcsm4AzDkuRV73L9tiqGJpKxhhhNY04Q/3d
	BJF0w5p0PkB3wTtHexnGH9/aZJs7YVkFtInRaLh3ph6kR9+ZZaVTlAvn+qH64VTYX6MXLiCPzsZK3
	Y8BIC7cLiZ1qiTQpkukoYe0fJAya9soIlz19m0jDy78ufFxUAwGy2hVzNpgjjFQpeUj9D3MiVXURE
	gwNfExuQ==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1rmd0t-000000007gT-1ADr;
	Tue, 19 Mar 2024 18:12:35 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [libnftnl PATCH 01/17] chain: Validate NFTNL_CHAIN_USE, too
Date: Tue, 19 Mar 2024 18:12:08 +0100
Message-ID: <20240319171224.18064-2-phil@nwl.cc>
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
 src/chain.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/chain.c b/src/chain.c
index dcfcd0456734b..e0b1eaf6d73bc 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -196,6 +196,7 @@ static uint32_t nftnl_chain_validate[NFTNL_CHAIN_MAX + 1] = {
 	[NFTNL_CHAIN_HOOKNUM]	= sizeof(uint32_t),
 	[NFTNL_CHAIN_PRIO]		= sizeof(int32_t),
 	[NFTNL_CHAIN_POLICY]		= sizeof(uint32_t),
+	[NFTNL_CHAIN_USE]		= sizeof(uint32_t),
 	[NFTNL_CHAIN_BYTES]		= sizeof(uint64_t),
 	[NFTNL_CHAIN_PACKETS]	= sizeof(uint64_t),
 	[NFTNL_CHAIN_HANDLE]		= sizeof(uint64_t),
-- 
2.43.0

