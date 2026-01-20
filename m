Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 922F8477E3A;
	Tue, 20 Jan 2026 19:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768936691; cv=none; b=tJ4rf7TmEPNEJmSyJkvWeBO69/Z6q/+Vpheu1ZGDdYo1ZmFL3obYxz1s73+JNOOkBxZO3AtlYTGROkAJctAeFuWHmf1ykTMHPJRgkwhgcZ0s0A1vb0hs98WEznmpcV9x10i1cBGKD5HYtugrKOSb8tJAM+kcbh6SAesCPN9+27s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768936691; c=relaxed/simple;
	bh=yFe+RDwHgYFendKzYSDvhlCgj2LUow7ykJ+nJUr85m4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Hb+kChEH1wjs9p5f6AIZ4KYLrlQ6F55ZS1q+ij30sM7qoBVQjaVSBWMIFE9IbAKgnCuRElc/w4IkbZCelVwevKUqEoOPkW7YT3ULVM8R2Dz4J6LeXf6S+LgvR1ztVibkp5KoHFSaA66IkLbHn2N77ktjoSfxma6KgS+ytEpc/uY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 50F24602AB; Tue, 20 Jan 2026 20:18:07 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net-next 00/10] Subject: netfilter: updates for net-next
Date: Tue, 20 Jan 2026 20:17:53 +0100
Message-ID: <20260120191803.22208-1-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

The following patchset contains Netfilter fixes for *net-next*:

1) Speed up nftables transactions after earlier transaction failed.
   Due to a (harmeless) bug we remained in slow paranoia mode until a
   successful transaction completes.

2) Allow generic tracker to resolve clashes, this avoids very rare
   packet drops.  From Yuto Hamaguchi.

3) Increase the cleanup budget to 64 entries in nf_conncount to reap
   more entries in one go, from Fernando Fernandez Mancera.

4) Allow icmp trackers to resolve clashes, this avoids very rare
   initial packet drop with test cases that have high-frequency pings.
   After this all trackers except tcp and sctp allow clash resolution.

5) Disentangle netfilter headers, don't include nftables/xtables headers
   in subsystems that are unrelated.

6) Don't rely on implicit includes coming from nf_conntrack_proto_gre.h.

7) Allow nfnetlink_queue nfq instance struct to get accounted via memcg,
   from Scott Mitchell.

8) Reject bogus xt target/match data upfront via netlink policiy in
   nft_compat interface rather than relying on x_tables API to do it.

9) Fix nf_conncount breakage when trying to limit loopback flows via
   prerouting rule, from Fernando Fernandez Mancera.
   This is a recent breakage but not seen as urgent enough to rush this
   via net tree at this late stage in development cycle.

10) Fix a possible off-by-one when parsing tcp option in xtables tcpmss
    match.  Also handled via -next due to late stage in development
    cycle.

0003-netfilter-nf_conncount-increase-the-connection-clean.patch fixes commit from v5.19-rc1~159^2~45^2~2
0008-netfilter-nft_compat-add-more-restrictions-on-netlin.patch fixes commit from v3.13-rc1~105^2~186^2~8
0009-netfilter-nf_conncount-fix-tracking-of-connections-f.patch fixes commit from nf-next-25-11-28~6


Please, pull these changes from:
The following changes since commit 77b9c4a438fc66e2ab004c411056b3fb71a54f2c:

  Merge branch 'netkit-support-for-io_uring-zero-copy-and-af_xdp' (2026-01-20 12:25:29 +0100)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git tags/nf-next-26-01-20

for you to fetch changes up to 735ee8582da3d239eb0c7a53adca61b79fb228b3:

  netfilter: xt_tcpmss: check remaining length before reading optlen (2026-01-20 16:23:38 +0100)

----------------------------------------------------------------
netfilter pull request nf-next-26-01-20

----------------------------------------------------------------
Fernando Fernandez Mancera (2):
  netfilter: nf_conncount: increase the connection clean up limit to 64
  netfilter: nf_conncount: fix tracking of connections from localhost

Florian Westphal (6):
  netfilter: nf_tables: reset table validation state on abort
  netfilter: nf_conntrack: enable icmp clash support
  netfilter: don't include xt and nftables.h in unrelated subsystems
  netfilter: nf_conntrack: don't rely on implicit includes
  netfilter: nft_compat: add more restrictions on netlink attributes
  netfilter: xt_tcpmss: check remaining length before reading optlen

Scott Mitchell (1):
  netfilter: nfnetlink_queue: nfqnl_instance GFP_ATOMIC -> GFP_KERNEL_ACCOUNT allocation

Yuto Hamaguchi (1):
  netfilter: nf_conntrack: Add allow_clash to generic protocol handler

 include/linux/audit.h                         |  1 -
 .../linux/netfilter/nf_conntrack_proto_gre.h  |  3 -
 include/net/netfilter/nf_conntrack.h          |  1 +
 include/net/netfilter/nf_conntrack_count.h    |  1 +
 include/net/netfilter/nf_conntrack_tuple.h    |  2 +-
 include/net/netfilter/nf_tables.h             |  1 -
 net/bridge/netfilter/nf_conntrack_bridge.c    |  3 +-
 net/netfilter/nf_conncount.c                  | 30 ++++++--
 net/netfilter/nf_conntrack_bpf.c              |  1 +
 net/netfilter/nf_conntrack_h323_main.c        |  1 +
 net/netfilter/nf_conntrack_netlink.c          |  1 +
 net/netfilter/nf_conntrack_proto_generic.c    |  1 +
 net/netfilter/nf_conntrack_proto_gre.c        |  2 +
 net/netfilter/nf_conntrack_proto_icmp.c       |  1 +
 net/netfilter/nf_conntrack_proto_icmpv6.c     |  1 +
 net/netfilter/nf_flow_table_ip.c              |  2 +
 net/netfilter/nf_flow_table_offload.c         |  1 +
 net/netfilter/nf_flow_table_path.c            |  1 +
 net/netfilter/nf_nat_ovs.c                    |  3 +
 net/netfilter/nf_nat_proto.c                  |  1 +
 net/netfilter/nf_synproxy_core.c              |  1 +
 net/netfilter/nf_tables_api.c                 |  8 ++
 net/netfilter/nfnetlink_queue.c               | 75 +++++++++----------
 net/netfilter/nft_compat.c                    | 13 +++-
 net/netfilter/nft_flow_offload.c              |  1 +
 net/netfilter/nft_synproxy.c                  |  1 +
 net/netfilter/xt_tcpmss.c                     |  2 +-
 net/sched/act_ct.c                            |  2 +
 net/sched/act_ctinfo.c                        |  1 +
 29 files changed, 102 insertions(+), 60 deletions(-)

-- 
2.52.0
