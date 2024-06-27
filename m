Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D53836B0D
	for <netfilter-devel@vger.kernel.org>; Thu, 27 Jun 2024 13:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719496702; cv=none; b=tNWkLrIvTfBotdnoOZLY3LNmKsqK8NxuBV1x17MH6y/TZ/PFelEeOYqK3TM1UheXHnrPJj2NqaaV7E86dQAxNg/cZJRonew14XJPUVfUKN3TS7sIaE3CmAkYILQcIYALwyHtgcGCNeJycUCjB1aM7cqQXeDVJtlwlS3CfeoVKUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719496702; c=relaxed/simple;
	bh=HMeRhFRlP9VxWPbjBhluIUk2KBis4348r2DjBor2AFg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=S3mgzR3uJy0XqCstEs76Fqw6jFtgpvX8Sy5wXWvWdrcSfHJABSWHnuwi6l/nVN6zTeqCVqt/is9F+1nB55bN/PcsFuanz6Ve7NcjX22qkdpLR1yZbBenLoJilhWtMHtaeALd+XpSHuD01Aebd5mlf3BGIVxju7sRV9mCIE9EUFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1sMpdc-0002A9-A3; Thu, 27 Jun 2024 15:58:12 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [RFC nf-next 0/4] nf_tables: remove explicit register zeroing
Date: Thu, 27 Jun 2024 15:53:20 +0200
Message-ID: <20240627135330.17039-1-fw@strlen.de>
X-Mailer: git-send-email 2.44.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

I'd like to propose this again.

First patch is preparation work.
Second patch is the actual change I'd like to get into nf-next.

The third patch partially un-does the second:
Instead of rejecting a rule that triggers uninitialised register
access detection, do explicit zeroing from blob generator.

Please see patch 3 for a rationale why I think that we should
just go with patch 1+2.

Patch 4 reverts the explicit zeroing.

Florian Westphal (4):
  netfilter: nf_tables: pass context structure to
    nft_parse_register_load
  netfilter: nf_tables: allow loads only when register is initialized
  netfilter: nf_tables: insert register zeroing instructions for dodgy
    chains
  netfilter: nf_tables: don't initialize registers in nft_do_chain()

 include/net/netfilter/nf_tables.h      |  14 ++-
 net/bridge/netfilter/nft_meta_bridge.c |   2 +-
 net/ipv4/netfilter/nft_dup_ipv4.c      |   4 +-
 net/ipv6/netfilter/nft_dup_ipv6.c      |   4 +-
 net/netfilter/nf_tables_api.c          | 119 +++++++++++++++++++++++--
 net/netfilter/nf_tables_core.c         |   2 +-
 net/netfilter/nft_bitwise.c            |   4 +-
 net/netfilter/nft_byteorder.c          |   2 +-
 net/netfilter/nft_cmp.c                |   6 +-
 net/netfilter/nft_ct.c                 |   2 +-
 net/netfilter/nft_dup_netdev.c         |   2 +-
 net/netfilter/nft_dynset.c             |   4 +-
 net/netfilter/nft_exthdr.c             |   2 +-
 net/netfilter/nft_fwd_netdev.c         |   6 +-
 net/netfilter/nft_hash.c               |   2 +-
 net/netfilter/nft_lookup.c             |   2 +-
 net/netfilter/nft_masq.c               |   4 +-
 net/netfilter/nft_meta.c               |   2 +-
 net/netfilter/nft_nat.c                |   8 +-
 net/netfilter/nft_objref.c             |   2 +-
 net/netfilter/nft_payload.c            |   2 +-
 net/netfilter/nft_queue.c              |   2 +-
 net/netfilter/nft_range.c              |   2 +-
 net/netfilter/nft_redir.c              |   4 +-
 net/netfilter/nft_tproxy.c             |   4 +-
 25 files changed, 159 insertions(+), 48 deletions(-)

-- 
2.44.2

