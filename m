Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 635D5170A0B;
	Tue, 17 Sep 2024 20:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726604709; cv=none; b=Ld7o9Wx/kCthLlC89o/2a7lzz2jNXu75u6xUXpKZ7moMRugbIxgqnkKyjU1k/1B72VWbhWOBoOczWUvFCTWJ4Uy8UBECY4iLKpveAXyXKOvbhS8U3Nv0gJ7b7rYpaMCP4K3p2RgDq8v9PSSFvM45eC/QkSElha5wQq6RP3Tefv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726604709; c=relaxed/simple;
	bh=7pGompbavtdwes03X4rM1m9/Qostxqbu8lGvpuFgJMo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Vt0ggtQgNFPf+zepCdysTmlA7ZH9GCVol8zNvbLKJL/1DzZvV0T2pjD33g2b4H3EG7GKup41A1eavo2zdi8pyRemNK4tKVK2VSvCHzm6Du++ljhKHXBeF+40sN9EHW1Q7m6rT7C6lHHBK/YNy5e28t8TEeywevm3keQpnBSf46M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: gregkh@linuxfoundation.org,
	sashal@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH -stable,6.1 0/2] Netfilter fixes for -stable
Date: Tue, 17 Sep 2024 22:25:02 +0200
Message-Id: <20240917202504.176664-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Greg, Sasha,

This batch contains a backport for fixes for 6.1-stable:

The following list shows the backported patches, I am using original commit
IDs for reference:

1) 29b359cf6d95 ("netfilter: nft_set_pipapo: walk over current view on netlink dump")

2) efefd4f00c96 ("netfilter: nf_tables: missing iterator type in lookup walk")

Please, apply,
Thanks

Pablo Neira Ayuso (2):
  netfilter: nft_set_pipapo: walk over current view on netlink dump
  netfilter: nf_tables: missing iterator type in lookup walk

 include/net/netfilter/nf_tables.h | 13 +++++++++++++
 net/netfilter/nf_tables_api.c     |  5 +++++
 net/netfilter/nft_lookup.c        |  1 +
 net/netfilter/nft_set_pipapo.c    |  6 ++++--
 4 files changed, 23 insertions(+), 2 deletions(-)

-- 
2.30.2

