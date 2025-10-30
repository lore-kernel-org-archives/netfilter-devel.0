Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EAFF86347;
	Thu, 30 Oct 2025 12:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761826803; cv=none; b=PRKvpSA2bW7YtANJi2V43Gb9wZzDe5s3rjB7y7PW6jG6AkCqx7YIR8rAcOqlJFl1T2BfTdDe8SRRCTTI9E5lu+M17ckpVmT4BU+ZiED6/So30cgifbwOvRr9MksEwbOQdSbXfr892TY6nsKRSuWJSaPp97oK7xIoHO629rBUcQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761826803; c=relaxed/simple;
	bh=Sr7rU12Ibv7w9EHPDOj5/788g4r2tBgn2zxLcSepF8I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uOzS/8QXbqt7aV9h/EBd6g1lUiFVk4ApWflX9GECt+w5YaCtdvTFWtKWH+JO7r2KxaDYfItL0Kj5svw+oBhhiqCeFQ176sIjCjAnbaP/AMkgY4rfK5QIFCYinAHGVnLOVTV9Ju1txzpghA4oYNvwFkw0P2YO9/bghhk3J2FQtN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 49DB76020C; Thu, 30 Oct 2025 13:19:59 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net-next 0/3] netfilter: updates for net-next
Date: Thu, 30 Oct 2025 13:19:51 +0100
Message-ID: <20251030121954.29175-1-fw@strlen.de>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

The following patchset contains Netfilter fixes for *net-next*:

1) Convert nf_tables 'nft_set_iter' usage to use C99 struct
   initialization, from Fernando Fernandez Mancera.
2) Disallow nf_conntrack_max=0.  This was an (undocumented)
   historic inheritance from ip_conntrack (ipv4 only nf_conntrack
   predecessor).  Doing so will simplify future changes to make this
   pernet-tuneable.
3) Fix a typo in conntrack.h comment, from Weibiao Tu.

Please, pull these changes from:
The following changes since commit ea7d0d60ebc9bddf3ad768557dfa1495bc032bf6:

  Merge branch 'add-cn20k-nix-and-npa-contexts' (2025-10-30 10:44:12 +0100)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git tags/nf-next-25-10-30

for you to fetch changes up to 57347d58a4011551e7d0e030f2f12e4d1a28feb6:

  netfilter: fix typo in nf_conntrack_l4proto.h comment (2025-10-30 12:52:45 +0100)

----------------------------------------------------------------
netfilter pull request nf-next-25-10-30

----------------------------------------------------------------
Fernando Fernandez Mancera (1):
      netfilter: nf_tables: use C99 struct initializer for nft_set_iter

Florian Westphal (1):
      netfilter: conntrack: disable 0 value for conntrack_max setting

caivive (Weibiao Tu) (1):
      netfilter: fix typo in nf_conntrack_l4proto.h comment

 include/net/netfilter/nf_conntrack_l4proto.h |  2 +-
 net/netfilter/nf_conntrack_core.c            |  2 +-
 net/netfilter/nf_conntrack_standalone.c      |  4 ++--
 net/netfilter/nf_tables_api.c                | 34 +++++++++++++---------------
 net/netfilter/nft_lookup.c                   | 13 ++++-------
 5 files changed, 25 insertions(+), 30 deletions(-)
# WARNING: skip 0001-netfilter-nf_tables-use-C99-struct-initializer-for-n.patch, no "Fixes" tag!
# WARNING: skip 0002-netfilter-conntrack-disable-0-value-for-conntrack_ma.patch, no "Fixes" tag!
# WARNING: skip 0003-netfilter-fix-typo-in-nf_conntrack_l4proto.h-comment.patch, no "Fixes" tag!
