Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D65571D049B
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Oct 2024 16:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727884937; cv=none; b=AAH5lnLwPdGrk9+p3GX6OZxd2tjLtiZwlZNKjiMfMuWJ7QPjVUMqyYgWf9GKnIJoT9WSuz7pgdeX0yJsPlX76EvRg8MITLulHjMizpzwLpWbdvb09nR1I/vgx6u5i8Qauc2pISAYOsP+b8oeQScxPBSMh38DKnQTu2l2vpq/yJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727884937; c=relaxed/simple;
	bh=w5SiXzMDOR7XPK9zwtBJxwzriWOBwccPQDErnW95UsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hC8HeNcm5AK3x+uU2EQsmbf/vz/Z8alLunFgxHho9xxe9c8kOJTKmzb/whI9C+NfAEwNuigBQ7Yz1TqaKbxlEj8EN8XXMnCLZIrd2QQ09R8l/jRqtULFC6/bbzcHER4vYSQNdjuh2F5C16xVfPrI4xMyVywsi1N2Mrex9KEfsVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1sw1no-0003Ye-Kt; Wed, 02 Oct 2024 18:02:12 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 0/4] netfilter: use skb_drop_reason in more places
Date: Wed,  2 Oct 2024 17:55:38 +0200
Message-ID: <20241002155550.15016-1-fw@strlen.de>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Provide more precise drop information rather than doing the freeing
from core.c:nf_hook_slow().

First patch is a small preparation patch, rest coverts NF_DROP
locations of NF_DROP_REASON().

Florian Westphal (4):
  netfilter: xt_nat: compact nf_nat_setup_info calls
  netfilter: xt_nat: drop packet earlier
  netfilter: nf_nat: use skb_drop_reason
  netfilter: nf_tables: use skb_drop_reason

 include/linux/netfilter.h                 |  5 +-
 net/bridge/netfilter/nft_reject_bridge.c  |  2 +-
 net/ipv4/netfilter/nft_reject_ipv4.c      |  2 +-
 net/ipv6/netfilter/nf_defrag_ipv6_hooks.c |  5 +-
 net/netfilter/nf_nat_masquerade.c         | 23 +++++--
 net/netfilter/nf_nat_proto.c              | 18 +++---
 net/netfilter/nf_nat_redirect.c           |  4 +-
 net/netfilter/nf_synproxy_core.c          | 16 ++---
 net/netfilter/nft_chain_filter.c          |  4 +-
 net/netfilter/nft_compat.c                |  8 +--
 net/netfilter/nft_connlimit.c             |  4 +-
 net/netfilter/nft_ct.c                    | 14 ++--
 net/netfilter/nft_exthdr.c                |  2 +-
 net/netfilter/nft_fib_inet.c              |  2 +-
 net/netfilter/nft_fwd_netdev.c            |  4 +-
 net/netfilter/nft_nat.c                   |  8 ++-
 net/netfilter/nft_reject_inet.c           |  2 +-
 net/netfilter/nft_reject_netdev.c         |  2 +-
 net/netfilter/nft_synproxy.c              | 10 +--
 net/netfilter/xt_nat.c                    | 78 ++++++++++-------------
 20 files changed, 112 insertions(+), 101 deletions(-)

-- 
2.45.2

