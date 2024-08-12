Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7CE133C7;
	Mon, 12 Aug 2024 10:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723458211; cv=none; b=JNsUnK0Anelvsy46zMV5rtwqMUQ/9eznmfO33aDJciceCegBtaSASXyR0F5o8WYGjM/bGk9fJ8SVFYj5S7eeRlrobysXJh2crIvM5Yx79Gp3X48Tv0mWaUc5MQtWLCSx1EVSfYrKEb3cphdxhIJc0zivGDuC0IPfSLNOdO/xrTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723458211; c=relaxed/simple;
	bh=sS+vTrpGdf0AvaZa1f6k9mClxZ1Q2o+sA6AqYegxzwQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=BoVrtvq6ka+ygIYzXsDdtuCE5PZlkYTBjwSYsGOWzYF2m84fM8rRQ0SMBZFoHRmiGDTLOY1m71xq312ql20Ma9VOch1uOdu8HZkY3BY2Pa8MGAaa9SRs5HvTijRP328Rh7exzIs3V7P2Mp9mJy0Eord52utyIiuDnot567EkUBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: gregkh@linuxfoundation.org,
	sashal@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH -stable,6.1.x 0/3] Netfilter fixes for -stable
Date: Mon, 12 Aug 2024 12:23:17 +0200
Message-Id: <20240812102320.359247-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Greg, Sasha,

This batch contains a backport for recent fixes already upstream for 6.1.x.

The following list shows the backported patches, I am using original commit
IDs for reference:

1) 3c13725f43dc ("netfilter: nf_tables: bail out if stateful expression provides no .clone")

2) fa23e0d4b756 ("netfilter: nf_tables: allow clone callbacks to sleep")

3) cff3bd012a95 ("netfilter: nf_tables: prefer nft_chain_validate")

Please, apply,
Thanks

Florian Westphal (2):
  netfilter: nf_tables: allow clone callbacks to sleep
  netfilter: nf_tables: prefer nft_chain_validate

Pablo Neira Ayuso (1):
  netfilter: nf_tables: bail out if stateful expression provides no .clone

 include/net/netfilter/nf_tables.h |   4 +-
 net/netfilter/nf_tables_api.c     | 172 ++++--------------------------
 net/netfilter/nft_connlimit.c     |   4 +-
 net/netfilter/nft_counter.c       |   4 +-
 net/netfilter/nft_dynset.c        |   2 +-
 net/netfilter/nft_last.c          |   4 +-
 net/netfilter/nft_limit.c         |  14 +--
 net/netfilter/nft_quota.c         |   4 +-
 8 files changed, 42 insertions(+), 166 deletions(-)

-- 
2.30.2

