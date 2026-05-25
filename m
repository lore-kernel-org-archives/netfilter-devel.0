Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 411EF188CC9;
	Mon, 25 May 2026 18:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779733771; cv=none; b=BhvjbG52w8ZhFJilEM52qr5+KG6QeYEl6sJB4qyfwwzfbrmrxzPWjt1wefqPwxtHPpEgV2zW5SZftcN4YzBc59AewYF+0v4NNDJcvLChdMbYUwnBR5ETbrJal6at9nAnV2MJXLjtLic8sYzxmVGQb0beQRF+SDQ5ZFPMj8plctk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779733771; c=relaxed/simple;
	bh=OKRECrVQ6sNYcI83uYmXZ0MC5zKe7JVUWl31EL5NK9U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ATqfE5oFcNOIdumT9EJ8e2uqP2DOne4Bdg8wBlGqtyGcUWEE3aJouhUzwj8vluYCRSf0urcyohD6q18jKAxYSJHdu3CH+a+/mvWGQCn1Po6J6JiymxGpd2vxkqWuT6DPEOwQ2KbQhVnjoCUAfy5y9uKO5acEwWgmS2u5X3l6k8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 6EB0B60595; Mon, 25 May 2026 20:29:28 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net-next 00/11] netfilter: updates for net-next
Date: Mon, 25 May 2026 20:29:13 +0200
Message-ID: <20260525182924.28456-1-fw@strlen.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

The following patchset contains Netfilter fixes and small enhancements
for *net-next*:

1) Disable 32-bit x_tables compatibility (32bit binaries on 64bit
   kernel) interface in user namespaces.  This is 'last warning' before
   this is removed for good.

2) Add a configuration toggle for netfilter GCOV profiling. Provide dedicated
   toggles for ipset and ipvs.

3) Remove modular support for nfnetlink and restrict it to built-in only.
   From Pablo Neira Ayuso.

4) Use per-rule hash initval in nf_conncount. This avoids unecessary lock
   contention with short keys (e.g. conntrack zones) in different
   namespaces.

5) Use nf_ct_exp_net() in ctnetlink expectation dumps.
   From Pratham Gupta.

6) Remove a dead conditional in nft_set_rbtree.

7) Fix conntrack helper policy updates to apply per-class values correctly.
   From David Carlier.

8) Fix an off-by-one OOB read in nf_conntrack_irc:parse_dcc(). Use strict
   less-than comparison in the newline search loop to respect the
   exclusive-end pointer convention.  From Muhammad Bilal.

9) Fix typos in nf_conntrack_proto_tcp comments.  From Avinash Duduskar.

10) Restore performance optimization in nft_set_pipapo_avx2 by passing
    the next map index. Refactor lookup logic for clarity and add a
    DEBUG_NET check to document this.

11) Avoid (harmless) u16 overflow in nf_conntrack_ftp when parsing FTP PORT
    and EPRT commands.  Ignore commands where single octet exceeds 255.
    From Giuseppe Caruso.

Patch 12, which removes incorrect (and obviously unused) code from
nft_byteorder was kept back to avoid a net -> net-next merge conflict.

Please, pull these changes from:
The following changes since commit c0aa5f13826dcb035bec3d6b252e6b2020fa5f88:

  Merge branch 'net-dsa-microchip-remove-unnecessary-ksz_dev_ops-callbacks' (2026-05-22 18:40:51 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git nf-next-26-05-25

for you to fetch changes up to 2b413fc689ba890348db13a4daa5adf42846ebca:

  netfilter: nf_conntrack_ftp: avoid u16 overflows (2026-05-25 20:00:04 +0200)

----------------------------------------------------------------
netfilter pull request nf-next-26-05-25

----------------------------------------------------------------
Avinash Duduskar (1):
  netfilter: nf_conntrack_proto_tcp: fix typos in comments

David Carlier (1):
  netfilter: nfnl_cthelper: apply per-class values when updating policies

Florian Westphal (5):
  netfilter: x_tables: disable 32bit compat interface in user namespaces
  netfilter: add option for GCOV profiling
  netfilter: nf_conncount: use per-rule hash initval
  netfilter: nft_set_rbtree: remove dead conditional
  netfilter: nft_set_pipapo_avx2: restore performance optimization

Giuseppe Caruso (1):
  netfilter: nf_conntrack_ftp: avoid u16 overflows

Muhammad Bilal (1):
  netfilter: nf_conntrack_irc: fix parse_dcc() off-by-one OOB read

Pablo Neira Ayuso (1):
  netfilter: allow nfnetlink built-in only

Pratham Gupta (1):
  netfilter: ctnetlink: use nf_ct_exp_net() in expectation dump

 include/linux/netfilter/x_tables.h     | 17 +++++++++++++
 net/bridge/Makefile                    |  6 +++++
 net/bridge/netfilter/Makefile          |  4 +++
 net/bridge/netfilter/ebtables.c        |  4 +++
 net/ipv4/Makefile                      |  4 +++
 net/ipv4/netfilter/Makefile            |  4 +++
 net/ipv4/netfilter/arp_tables.c        |  4 +++
 net/ipv4/netfilter/ip_tables.c         |  4 +++
 net/ipv6/Makefile                      |  4 +++
 net/ipv6/netfilter/Makefile            |  4 +++
 net/ipv6/netfilter/ip6_tables.c        |  4 +++
 net/netfilter/Kconfig                  | 10 +++++++-
 net/netfilter/Makefile                 |  6 ++++-
 net/netfilter/ipset/Kconfig            |  9 +++++++
 net/netfilter/ipset/Makefile           |  3 +++
 net/netfilter/ipvs/Kconfig             |  9 +++++++
 net/netfilter/ipvs/Makefile            |  3 +++
 net/netfilter/nf_conncount.c           |  7 +++---
 net/netfilter/nf_conntrack_ftp.c       | 11 +++++---
 net/netfilter/nf_conntrack_irc.c       |  6 ++---
 net/netfilter/nf_conntrack_netlink.c   |  2 +-
 net/netfilter/nf_conntrack_proto_tcp.c |  8 +++---
 net/netfilter/nfnetlink_cthelper.c     |  4 +--
 net/netfilter/nft_set_pipapo_avx2.c    | 35 +++++++++++---------------
 net/netfilter/nft_set_rbtree.c         |  3 ---
 25 files changed, 131 insertions(+), 44 deletions(-)

-- 
2.53.0
