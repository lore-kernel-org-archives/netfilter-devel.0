Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B86415350B;
	Mon, 29 Jan 2024 15:31:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706542286; cv=none; b=J3s2yypdQIn/gKD2y0UrthnXykNVusesou4RSVrXZqyUVAMmhWDi79BRMf8gMvsvniogtkyE3rh0+xeBTizUgh3fGnTaxzR3+9xGBXS7rvUj0JOYpQ/junNNpvmR02g/X4sVFZEXyb8LQzyET3vIVi1UtHvcFDyCinfuhm/4agU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706542286; c=relaxed/simple;
	bh=KtHCazO5WCZP+EbAzh4CTZmajC4s+AwCkWZlEHJHXlE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WcsFAE4H/F8EWFAuXc0ogrYH62EcWeEfNg4oKUvdNNQKIj8YYXIq/3Z0/akbaQzF5vrZ7r45GbTRGL9a7lOotBuriVCnnnreAMLflQ7BYvfccRt1B7nHncKzHzCItXKADh77C4VHfjxAPJHfixupm84Yxvh9pOnrXK+nRHZoxbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rUTbN-0001zb-GZ; Mon, 29 Jan 2024 16:31:13 +0100
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next 0/9] netfilter updates for -next
Date: Mon, 29 Jan 2024 15:57:50 +0100
Message-ID: <20240129145807.8773-1-fw@strlen.de>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

This batch contains updates for your *next* tree.

First three changes, from Phil Sutter, allow userspace to define
a table that is exclusively owned by a daemon (via netlink socket
aliveness) without auto-removing this table when the userspace program
exits.  Such table gets marked as orphaned and a restarting management
daemon may re-attach/reassume ownership.

Next patch, from Pablo, passes already-validated flags variable around
rather than having called code re-fetch it from netlnik message.

Patches 5 and 6 update ipvs and nf_conncount to use the recently
introduced KMEM_CACHE() macro.

Last three patches, from myself, tweak kconfig logic a little to
permit a kernel configuration that can run iptables-over-nftables
but not classic (setsockopt) iptables.

Such builds lack the builtin-filter/mangle/raw/nat/security tables,
the set/getsockopt interface and the "old blob format"
interpreter/traverser.  For now, this is 'oldconfig friendly', users
need to manually deselect existing config options for this.

The following changes since commit 723de3ebef03bc14bd72531f00f9094337654009:

  net: free altname using an RCU callback (2024-01-29 14:40:38 +0000)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git tags/nf-next-24-01-29

for you to fetch changes up to 7ad269787b6615ca56bb161063331991fce51abf:

  netfilter: ebtables: allow xtables-nft only builds (2024-01-29 15:43:21 +0100)

----------------------------------------------------------------
nf-next pr 2024-01-29

----------------------------------------------------------------
Florian Westphal (3):
      netfilter: arptables: allow xtables-nft only builds
      netfilter: xtables: allow xtables-nft only builds
      netfilter: ebtables: allow xtables-nft only builds

Kunwu Chan (2):
      netfilter: nf_conncount: Use KMEM_CACHE instead of kmem_cache_create()
      ipvs: Simplify the allocation of ip_vs_conn slab caches

Pablo Neira Ayuso (1):
      netfilter: nf_tables: pass flags to set backend selection routine

Phil Sutter (3):
      netfilter: uapi: Document NFT_TABLE_F_OWNER flag
      netfilter: nf_tables: Introduce NFT_TABLE_F_PERSIST
      netfilter: nf_tables: Implement table adoption support

 include/net/netfilter/nf_tables.h        |  6 +++++
 include/uapi/linux/netfilter/nf_tables.h |  6 ++++-
 net/bridge/netfilter/Kconfig             |  7 ++++++
 net/bridge/netfilter/Makefile            |  2 +-
 net/ipv4/netfilter/Kconfig               | 43 +++++++++++++++++++-------------
 net/ipv4/netfilter/Makefile              |  2 +-
 net/ipv6/netfilter/Kconfig               | 20 ++++++++++-----
 net/ipv6/netfilter/Makefile              |  2 +-
 net/netfilter/Kconfig                    | 12 ++++-----
 net/netfilter/ipvs/ip_vs_conn.c          |  4 +--
 net/netfilter/nf_conncount.c             |  8 ++----
 net/netfilter/nf_tables_api.c            | 35 ++++++++++++++++++--------
 12 files changed, 94 insertions(+), 53 deletions(-)
