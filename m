Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D86B330FC19
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Sep 2025 08:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757491399; cv=none; b=oBDSu9XZqfMaehq5zA91YPTr5M9MLyG/FRNpqdvoGK/865yM6Jl8pLnvJJZM8wN4HlwZcSXtPnUplfxBDF7ffqEV07q1dmh079rRY90coDipcTq5eWSLGIijuvS4J6fPcpxyyuT63I9qJ5fmkR3LXTvLdNpC699yEtfwktNnHYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757491399; c=relaxed/simple;
	bh=3B1TVq+uvFiW+tyJbFkJweyVocyeuvuu3GKDNC93NYg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=c+ZM4o02OnYhaQtmSCFPVfpOp9df7T9fFrhxmBVhTxE2slqZTj8WhvpuW+s8Dct0HmO+y77LhHbthFcDn2snrPP0CZ/F367u4EyuleQnhRqeOrk2A/KOIzwQO3toUrt5o/QJ9JE/mesFTRV7DpgGbERzDxWYCncqS0fq522yIbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 96C636031F; Wed, 10 Sep 2025 10:03:09 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: s.hanreich@proxmox.com,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nf 0/5] netfilter: nf_tables: fix false negative lookups with ongoing transaction
Date: Wed, 10 Sep 2025 10:02:17 +0200
Message-ID: <20250910080227.11174-1-fw@strlen.de>
X-Mailer: git-send-email 2.49.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Stefan Hanreich reports spurious false negative results during set lookups
while another CPU is processing a transaction.
Quoting from the original bug report:

 It seems like we've found an issue with atomicity when reloading
 nftables rulesets. Sometimes there is a small window where rules
 containing sets do not seem to apply to incoming traffic, due to the set
 apparently being empty for a short amount of time when flushing / adding
 elements.

Exanple ruleset:
table ip filter {
  set match {
    type ipv4_addr
    flags interval
    elements = { 0.0.0.0-192.168.2.19, 192.168.2.21-255.255.255.255 }
  }

  chain pre {
    type filter hook prerouting priority filter; policy accept;
    ip saddr @match accept
    counter comment "must never match"
  }
}

Reproducer transaction:
while true:
nft -f -<<EOF
 flush set ip filter match
 create element ip filter match { \
    0.0.0.0-192.168.2.19, 192.168.2.21-255.255.255.255 }
EOF
done

Then create traffic. to/from e.g. 192.168.2.1 to 192.168.3.10.
Once in a while the counter will increment even though the
'ip saddr @match' rule should have accepted the packet.

This series resolves set inconsistencies that occur when a transaction
has entered the final commit phase.  See individual patches for details.

Thanks to Stefan Hanreich for an initial description and reproducer for
this bug and to Pablo Neira Ayuso for reviewing earlier iterations of
this patchset.

Florian Westphal (5):
  netfilter: nft_set_pipapo: don't check genbit from packetpath lookups
  netfilter: nft_set_rbtree: continue traversal if element is inactive
  netfilter: nf_tables: place base_seq in struct net
  netfilter: nf_tables: make nft_set_do_lookup available unconditionally
  netfilter: nf_tables: restart set lookup on base_seq change

 include/net/netfilter/nf_tables.h      |  1 -
 include/net/netfilter/nf_tables_core.h | 10 +---
 include/net/netns/nftables.h           |  1 +
 net/netfilter/nf_tables_api.c          | 66 +++++++++++++-------------
 net/netfilter/nft_lookup.c             | 46 ++++++++++++++++--
 net/netfilter/nft_set_pipapo.c         | 20 +++++++-
 net/netfilter/nft_set_pipapo_avx2.c    |  4 +-
 net/netfilter/nft_set_rbtree.c         |  6 +--
 8 files changed, 100 insertions(+), 54 deletions(-)

-- 
2.49.1
