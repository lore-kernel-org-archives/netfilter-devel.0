Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98CDE18A93A
	for <netfilter-devel@vger.kernel.org>; Tue, 20 Aug 2024 10:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724148080; cv=none; b=VhQaUe6/O9k1Du1sU2xlzy9w3TWvTZXN2XIbsXSCdeVI9tVr92EJneJx6kri0yuEdNCpLjFZ4zBOCx+dCZglhonbhWylVJ/qIlnmKXtcPZwP5APLAeCCm14kp+Sofyozi6KNYqU7YTaB2MnlwMfW6MhSCqDYSIxhY7SpQgKViZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724148080; c=relaxed/simple;
	bh=El2Kyc4lGrVrwS6XDkG6S6YEzqxcTtxMWBg9Ip4TDlk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=F4neRLyY3fXMoslab2IxAgd7diVyeMoNvIYmLgndNaY5JFmZ1Ihse5weoAmILV+dtPR53DZX6lmghlgO5iYrIB6lt5ShbGtipXYUWkmUA/YQjhB4k+neGNK8JmW7H/sYH+N6DQQXmYTIYQh4GS3BfFxyEeLtw4oz6Vn6Rj+j8Lc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1sgLfw-0004Jt-Tw; Tue, 20 Aug 2024 12:01:16 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 0/3] netfilter: nf_tables: reject loads from
Date: Tue, 20 Aug 2024 11:56:11 +0200
Message-ID: <20240820095619.6273-1-fw@strlen.de>
X-Mailer: git-send-email 2.44.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Reject rules where a load occurs from a register that has not seen a store
early in the same rule.

At the moment this is allowed, interpreter has to memset() the registers
to avoid  leaking stack information to userspace.

Detect and reject this from transaction phase instead.

Florian Westphal (3):
  netfilter: nf_tables: pass context structure to
    nft_parse_register_load
  netfilter: nf_tables: allow loads only when register is initialized
  netfilter: nf_tables: don't initialize registers in nft_do_chain()

 include/net/netfilter/nf_tables.h      |  4 ++-
 net/bridge/netfilter/nft_meta_bridge.c |  2 +-
 net/ipv4/netfilter/nft_dup_ipv4.c      |  4 +--
 net/ipv6/netfilter/nft_dup_ipv6.c      |  4 +--
 net/netfilter/nf_tables_api.c          | 41 ++++++++++++++++++++++----
 net/netfilter/nf_tables_core.c         |  2 +-
 net/netfilter/nft_bitwise.c            |  4 +--
 net/netfilter/nft_byteorder.c          |  2 +-
 net/netfilter/nft_cmp.c                |  6 ++--
 net/netfilter/nft_ct.c                 |  2 +-
 net/netfilter/nft_dup_netdev.c         |  2 +-
 net/netfilter/nft_dynset.c             |  4 +--
 net/netfilter/nft_exthdr.c             |  2 +-
 net/netfilter/nft_fwd_netdev.c         |  6 ++--
 net/netfilter/nft_hash.c               |  2 +-
 net/netfilter/nft_lookup.c             |  2 +-
 net/netfilter/nft_masq.c               |  4 +--
 net/netfilter/nft_meta.c               |  2 +-
 net/netfilter/nft_nat.c                |  8 ++---
 net/netfilter/nft_objref.c             |  2 +-
 net/netfilter/nft_payload.c            |  2 +-
 net/netfilter/nft_queue.c              |  2 +-
 net/netfilter/nft_range.c              |  2 +-
 net/netfilter/nft_redir.c              |  4 +--
 net/netfilter/nft_tproxy.c             |  4 +--
 25 files changed, 76 insertions(+), 43 deletions(-)
