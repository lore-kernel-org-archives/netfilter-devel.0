Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2644188A13;
	Tue, 17 Sep 2024 20:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726604693; cv=none; b=YCqIu6dPIy55/ZyMc2PJ1FKikqbq/e3rOyTeCFvUPGcFr0jeFHJo9jUYhHQ9u+FPW8BNvqtZC+8I4OfvDIMmuubjdjltq6+EuYpgDtQ61ZVb2jqvCmZ7zvVktkkmfVJ92lRlUIwSMmvXzafWLysAMeBcz/4s9Ho6dNBELsps4jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726604693; c=relaxed/simple;
	bh=3M+8aIklOQNGwyITZt6S+i9tybtrWlA1vSjz4P5OxaA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=DiFCIeH8N/gzVRh3DqbEFpC4znezz8JGq0KuEoNnzXdT22sjkr7mzTzXEJn1X21s0SDvWaW9k+q3Rj4GeJPu25JhkiZasr7GgfBspR74RzgN2bzSFDUjEvBA5BbLK2K7Dm5yc30sh256I7NLGE1KcLHKnDn4kLkUA9TFyc61XZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: gregkh@linuxfoundation.org,
	sashal@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH -stable,6.6 0/2] Netfilter fixes for -stable
Date: Tue, 17 Sep 2024 22:24:42 +0200
Message-Id: <20240917202444.171526-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Greg, Sasha,

This batch contains a backport for fixes for 6.6-stable:

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

