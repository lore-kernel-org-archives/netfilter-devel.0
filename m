Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCF4120C038;
	Mon, 19 May 2025 23:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747697691; cv=none; b=otMv7Wrz33VS1PkQZoAvWFJBQxnBWbwMtXh605Dfaosmkspuzl3czbkQvOwjgpDWymqcc1/1/gcFGFGmGcuYrd94fqWeNbkkMPRyugwuiKbuF3S0VFjEYlbyU4Mqmoh2lLesw2iQHKubGff3VxW84ZnHAfC8D3a1JRBKq/MwCKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747697691; c=relaxed/simple;
	bh=/cJO7MDam9H/yJUU1hMnK+9SDqMOEjkaESrfpeQ2Mlg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=gifE+Rb1yvl4o2JKg5ti17FWFG4ceCcoutuJuGcSPKBM+nmmmZUPNKe3pIBH10Vz7RvRcqKIQVOz1bEfE/TgyicjW6Z3yeYgkiWN9BEVISqnKGrf2qtpohV88TKivEQXbDNFKRFxs8ZCYBzvDLdRVHWNwHu2/YmHWsvXwn+e3bU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=QmWvh8MT; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=npyS8tnd; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="QmWvh8MT";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="npyS8tnd"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 798746029B; Tue, 20 May 2025 01:34:44 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747697684;
	bh=YdlhzWlnL7+uzdwYZHxO5RGnTYT/KFQ7t62WkHuEFxk=;
	h=From:To:Cc:Subject:Date:From;
	b=QmWvh8MT3qlDdlI4djvljWJWhfgjH427OFrNy5dOKIFJH8slthon/R2+kl/aK9Ns+
	 PPz5n6EedolLA3MEyGut2ssccvpcktKEh/IfLmYQb3URymAKYI0h5uIFSDkDiXCw6l
	 d0fg7NNdu3aUbKYnq9/ykceg+fSZQckTbMyuW8LUDSuB+4jQinENnmMcko3VUiT9Gs
	 g9rAtMzp31maCX6RhincJS/OY9r3/sRpMj5xDk5VCnht4teBhXUXF3WUniEmO4BQNU
	 zZZ3yROyURuuVBFB3734r3O8FsEFEcPvmXKd1DcGmz1Y7ykq+S1iV0XjmiA2APR4Zy
	 CFbe4nXskGexw==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 9F8EC60296;
	Tue, 20 May 2025 01:34:43 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747697683;
	bh=YdlhzWlnL7+uzdwYZHxO5RGnTYT/KFQ7t62WkHuEFxk=;
	h=From:To:Cc:Subject:Date:From;
	b=npyS8tndompupIyaJx7obf85c7t48NLHLjVjW6CgiKG0v2GOJCDl7Qp7/m4CYnnxs
	 IDg3X7QtpRjax58EyaPG+r4MVGP5xtoGB9mjwDGnAFcmS6QPbOsaK7L1Q4WsIM6w2H
	 lJY7i0iyX/b0mQvG/iX0lVzyYX7UQBYm3VEePXGVo/ONGiiN1kerEuSu6sCe+Ftu8X
	 6nXFWIc+ofG3TFh0UmUB/waT2jQgMVikXPTMGs5fILZW6m5U/uwkA9qciQ934rtHBU
	 XbdX+t8ecaWY3IKEq1TC7PamOboeM5yt06GVGBWyzVnVUdZJ51oj0wKsL0uCKIAZmx
	 j02HxLjnUrSDw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: gregkh@linuxfoundation.org,
	sashal@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH -stable,6.1 0/3] Netfilter fixes for -stable
Date: Tue, 20 May 2025 01:34:35 +0200
Message-Id: <20250519233438.22640-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Greg, Sasha,

This batch contains backported fixes for 6.1 -stable.

The following list shows the backported patches, I am using original commit
IDs for reference:

1) 8965d42bcf54 ("netfilter: nf_tables: pass nft_chain to destroy function, not nft_ctx")

   This is a stable dependency for the next patch.

2) c03d278fdf35 ("netfilter: nf_tables: wait for rcu grace period on net_device removal")

3) b04df3da1b5c ("netfilter: nf_tables: do not defer rule destruction via call_rcu")

   This is a fix-for-fix for patch 2.

These three patches are required to fix the netdevice release path for
netdev family basechains.

Please, apply,
Thanks

Florian Westphal (2):
  netfilter: nf_tables: pass nft_chain to destroy function, not nft_ctx
  netfilter: nf_tables: do not defer rule destruction via call_rcu

Pablo Neira Ayuso (1):
  netfilter: nf_tables: wait for rcu grace period on net_device removal

 include/net/netfilter/nf_tables.h |  3 +-
 net/netfilter/nf_tables_api.c     | 54 ++++++++++++++++++++++---------
 net/netfilter/nft_immediate.c     |  2 +-
 3 files changed, 42 insertions(+), 17 deletions(-)

-- 
2.30.2

