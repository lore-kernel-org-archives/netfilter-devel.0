Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FD28379990;
	Thu, 29 Jan 2026 10:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769684075; cv=none; b=VtJxqdP0dleFG/rhqY5HLX1XYPpDZFAmACgfcsOLC0//pnppVwLFNzVnuMJZuKHNTQKsD5BXwYuh+hpepo15iw50Fh09Ah/05ibV0hvdUoAHxxMcWxinD5QCLxKtMd1hGtWv4SqYiVEsuYBLLZbuKW1XsH2Kfoyh0/mXjdvfTd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769684075; c=relaxed/simple;
	bh=8bIoy2DpsnEDTLacvOMAZ+0ELxar2ieq7TYwNlyanAA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=W3UmiLFv42As6TQ7vddZS8L9gs/Strf2G6L/v6hw34SAX1BpCqIKOeYEm4ahDEZifXxR4e2a6GZ67EuoFtiO/f7kJD1MElM860taKu2NmuCjJruLpwNsXdQkVak2Ch188Zkr9BnsZzbS1Cnb0WcAJMFP1kRGtdZRkEnmyTMFXvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id C56C560516; Thu, 29 Jan 2026 11:54:31 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH v2 net-next 0/7] netfilter: updates for net-next
Date: Thu, 29 Jan 2026 11:54:20 +0100
Message-ID: <20260129105427.12494-1-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

v2: discard buggy nfqueue patch, no other changes.

The following patchset contains Netfilter updates for *net-next*:

Patches 1 to 4 add IP6IP6 tunneling acceleration to the flowtable
infrastructure.  Patch 5 extends test coverage for this.
From Lorenzo Bianconi.

Patch 6 removes a duplicated helper from xt_time extension, we can
use an existing helper for this, from Jinjie Ruan.

Patch 7 adds an rhashtable to nfnetink_queue to speed up out-of-order
verdict processing.  Before this list walk was required due to in-order
design assumption.

Please, pull these changes from:
The following changes since commit aba0138eb7d72fec755a985fae42a54b7ff147a8:

  net: ethernet: neterion: s2io: remove unused driver (2026-01-28 20:08:07 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git tags/nf-next-26-01-29

for you to fetch changes up to e19079adcd26a25d7d3e586b1837493361fdf8b6:

  netfilter: nfnetlink_queue: optimize verdict lookup with hash table (2026-01-29 09:52:07 +0100)

----------------------------------------------------------------
netfilter pull request nf-next-26-01-29

----------------------------------------------------------------
Jinjie Ruan (1):
  netfilter: xt_time: use is_leap_year() helper

Lorenzo Bianconi (5):
  netfilter: Add ctx pointer in nf_flow_skb_encap_protocol/nf_flow_ip4_tunnel_proto signature
  netfilter: Introduce tunnel metadata info in nf_flowtable_ctx struct
  netfilter: flowtable: Add IP6IP6 rx sw acceleration
  netfilter: flowtable: Add IP6IP6 tx sw acceleration
  selftests: netfilter: nft_flowtable.sh: Add IP6IP6 flowtable selftest

Scott Mitchell (1):
  netfilter: nfnetlink_queue: optimize verdict lookup with hash table

 include/net/netfilter/nf_queue.h              |   3 +
 net/ipv6/ip6_tunnel.c                         |  27 ++
 net/netfilter/nf_flow_table_ip.c              | 243 +++++++++++++++---
 net/netfilter/nfnetlink_queue.c               | 146 ++++++++---
 net/netfilter/xt_time.c                       |   8 +-
 .../selftests/net/netfilter/nft_flowtable.sh  |  62 ++++-
 6 files changed, 408 insertions(+), 81 deletions(-)
-- 
2.52.0
