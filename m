Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71A703ACEF1;
	Thu,  2 Jul 2026 10:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782989417; cv=none; b=U5puApyLGZ7tzHIZMgrKbywBBMMwuWLaeGMl9TEsp++I6g6w+L02vSQ3yfusXpFzUvR8MRdKeUvMU8jU7jeKdu4agESO6fz3DiMjzAb8qhgKL3LrNxQ+2MFt9xm/bGLyersnXpPmf8ZfnXI+AJcUsBD+zOAtucCdKDIXZjVSCxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782989417; c=relaxed/simple;
	bh=z2fynKPfzpytLYeeusoaKS58c/9foK/UuWvZ2rFk2GQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XUgPs57MhGmm4BY9Cy4nIYhiRnq8MEDo2H7oBliMG+vf5ZDI7XYCP+rlx+vNGtPvs7cNi3mNNfLnYv/cN4SnVUFND9t+K90wk5xicvP5JNH/+JJJ/g7pw8EcJNTUUIiLnhV/xUS4bz9yaYOtiF2PcNlmYW9X4OKpdwhkqHs9ZVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id B3BDE601F0; Thu, 02 Jul 2026 12:50:12 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net-next 00/12] netfilter: updates for net-next
Date: Thu,  2 Jul 2026 12:49:51 +0200
Message-ID: <20260702105003.13550-1-fw@strlen.de>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

The following patchset contains Netfilter updates for *net-next*.

1) Update nfnetlink_hook to dump the individual NAT type chains
instead of the nat base chains to userspace. From Phil Sutter.

2) Replace strlcpy/strlcat() with snprintf() in x_tables, from Ian Bridges.

3) Start replacing u_int8_t and u_int16t with u8 and u16 in netfilter.
From Carlos Grillet.

4) Replace strcpy() with strscpy() in netfilter, from David Laight.

5) Remove redundant NULL check before kvfree().

6) Add parameter validation to xt_tcpmss. Ensure mss_min <= mss_max and
invert <= 1.  From Feng Wu.

7) Add checkentry for xt_dscp 'tos' match. Implement tos_mt_check() to reject
invalid invert values.  Also from Feng Wu.

8) Stop hashing nf_conntrack_helper by tuple. Switch to hashing by name and
L4 protocol.

9) Remove tuples from conntrack helper definitions and port usage from
broadcast helpers. Add netlink policy validation to prevent protocol
number truncation.

10) Remove obsolete netfilter conntrack module parameters.

11) Bound num_counters in ebtables: do_replace() by MAX_EBT_ENTRIES to prevent
oversized vmalloc_array() allocations.  From Jiayuan Chen.

12) Make expectations created via nft_ct rules work with NAT.

Please, pull these changes from:
The following changes since commit b8ea7da314c2efcb9c2f559ed65b7a36c869d68e:

  net: dsa: qca8k: fall back to ethernet-ports node name for LEDs (2026-07-02 11:48:25 +0200)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git tags/nf-next-26-07-02

for you to fetch changes up to d4beefc90a66672e43fdf82b43e4b3c0b1b18c5e:

  netfilter: nft_ct: support expectation creation for natted flows (2026-07-02 12:17:14 +0200)

----------------------------------------------------------------
netfilter pull request nf-next-26-07-02
----------------------------------------------------------------

Carlos Grillet (1):
  netfilter: replace u_int8_t and u_int16t with u8 and u16

David Laight (1):
  netfilter: avoid strcpy usage

Feng Wu (2):
  netfilter: xt_tcpmss: add checkentry for parameter validation
  netfilter: xt_dscp: add checkentry for tos match

Florian Westphal (4):
  netfilter: nf_conntrack_helper: do not hash by tuple
  netfilter: conntrack: get rid of tuple in helper definitions
  netfilter: conntrack: remove obsolete module parameters
  netfilter: nft_ct: support expectation creation for natted flows

Ian Bridges (1):
  netfilter: x_tables: replace strlcat() with snprintf()

Jiayuan Chen (1):
  netfilter: ebtables: bound num_counters like nentries in do_replace()

Phil Sutter (1):
  netfilter: nfnetlink_hook: Dump nat type chains

Subasri S (1):
  netfilter: remove redundant null check before kvfree()

 include/linux/netfilter.h                   |  7 ++
 include/linux/netfilter/nf_conntrack_h323.h |  2 -
 include/linux/netfilter/nf_conntrack_pptp.h |  2 -
 include/linux/netfilter/nf_conntrack_sane.h |  2 -
 include/linux/netfilter/nf_conntrack_tftp.h |  2 -
 include/net/ip_vs.h                         |  2 +-
 include/net/netfilter/nf_conntrack_helper.h | 10 ++-
 net/bridge/netfilter/ebtables.c             | 12 ++--
 net/ipv4/netfilter/nf_nat_snmp_basic_main.c |  2 +-
 net/netfilter/ipvs/ip_vs_nfct.c             |  2 +-
 net/netfilter/nf_conntrack_amanda.c         |  6 +-
 net/netfilter/nf_conntrack_broadcast.c      |  2 -
 net/netfilter/nf_conntrack_ftp.c            | 32 +++------
 net/netfilter/nf_conntrack_h323_main.c      | 12 ++--
 net/netfilter/nf_conntrack_helper.c         | 77 +++++++++------------
 net/netfilter/nf_conntrack_irc.c            | 27 +++-----
 net/netfilter/nf_conntrack_netbios_ns.c     |  2 -
 net/netfilter/nf_conntrack_ovs.c            |  6 +-
 net/netfilter/nf_conntrack_pptp.c           |  2 +-
 net/netfilter/nf_conntrack_sane.c           | 34 +++------
 net/netfilter/nf_conntrack_sip.c            | 45 ++++--------
 net/netfilter/nf_conntrack_snmp.c           |  4 +-
 net/netfilter/nf_conntrack_tftp.c           | 33 +++------
 net/netfilter/nf_nat_core.c                 |  6 --
 net/netfilter/nf_nat_proto.c                |  8 +++
 net/netfilter/nfnetlink_cthelper.c          | 21 +++---
 net/netfilter/nfnetlink_cttimeout.c         |  2 +-
 net/netfilter/nfnetlink_hook.c              | 37 ++++++++--
 net/netfilter/nft_ct.c                      | 35 ++++++++++
 net/netfilter/nft_set_rbtree.c              |  3 +-
 net/netfilter/x_tables.c                    | 30 +++-----
 net/netfilter/xt_TCPOPTSTRIP.c              |  8 +--
 net/netfilter/xt_dscp.c                     | 12 ++++
 net/netfilter/xt_recent.c                   |  2 +-
 net/netfilter/xt_tcpmss.c                   | 13 ++++
 net/sched/act_ct.c                          |  4 +-
 36 files changed, 246 insertions(+), 260 deletions(-)

-- 
2.54.0

