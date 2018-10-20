From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 00/10] Netfilter updates for net-next
Date: Sat, 20 Oct 2018 11:43:07 +0200
Message-ID: <20181020094317.16011-1-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi David,

The following patchset contains Netfilter updates for your net-next tree:

1) Use lockdep_is_held() in ipset_dereference_protected(), from Lance Roy.

2) Remove unused variable in cttimeout, from YueHaibing.

3) Add ttl option for nft_osf, from Fernando Fernandez Mancera.

4) Use xfrm family to deal with IPv6-in-IPv4 packets from nft_xfrm,
   from Florian Westphal.

5) Simplify xt_osf_match_packet().

6) Missing ct helper alias definition in snmp_trap helper, from Taehee Yoo.

7) Remove unnecessary parameter in nf_flow_table_cleanup(), from Taehee Yoo.

8) Remove unused variable definitions in nft_{dup,fwd}, from Weongyo Jeong.

9) Remove empty net/netfilter/nfnetlink_log.h file, from Taehee Yoo.

10) Revert xt_quota updates remain option due to problems in the listing
    path for 32-bit arches, from Maze.

You can pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git

Thanks.

----------------------------------------------------------------

The following changes since commit b187191577629b5358acf4e234809ee8d441ceb4:

  cxgb4: Add thermal zone support (2018-10-09 11:16:28 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git HEAD

for you to fetch changes up to af510ebd8913bee016492832f532ed919b51c09c:

  Revert "netfilter: xt_quota: fix the behavior of xt_quota module" (2018-10-19 14:00:34 +0200)

----------------------------------------------------------------
Fernando Fernandez Mancera (1):
      netfilter: nft_osf: Add ttl option support

Florian Westphal (1):
      netfilter: nft_xfrm: use state family, not hook one

Lance Roy (1):
      netfilter: Replace spin_is_locked() with lockdep

Pablo Neira Ayuso (2):
      netfilter: xt_osf: simplify xt_osf_match_packet()
      Revert "netfilter: xt_quota: fix the behavior of xt_quota module"

Taehee Yoo (3):
      netfilter: nf_nat_snmp_basic: add missing helper alias name
      netfilter: nf_flow_table: remove unnecessary parameter of nf_flow_table_cleanup()
      netfilter: nfnetlink_log: remove empty nfnetlink_log.h header file

Weongyo Jeong (1):
      netfilter: remove two unused variables.

YueHaibing (1):
      netfilter: cttimeout: remove set but not used variable 'l3num'

 include/linux/netfilter/nfnetlink_osf.h     |  3 +-
 include/net/netfilter/nf_flow_table.h       |  2 +-
 include/net/netfilter/nfnetlink_log.h       |  1 -
 include/uapi/linux/netfilter/nf_tables.h    |  7 ++++
 include/uapi/linux/netfilter/xt_quota.h     |  8 ++---
 net/ipv4/netfilter/nf_nat_snmp_basic_main.c |  1 +
 net/netfilter/ipset/ip_set_hash_gen.h       |  2 +-
 net/netfilter/nf_flow_table_core.c          |  2 +-
 net/netfilter/nfnetlink_cttimeout.c         |  2 --
 net/netfilter/nfnetlink_osf.c               | 46 +++++++++++-------------
 net/netfilter/nft_dup_netdev.c              |  2 --
 net/netfilter/nft_flow_offload.c            |  2 +-
 net/netfilter/nft_fwd_netdev.c              |  4 ---
 net/netfilter/nft_osf.c                     | 15 +++++++-
 net/netfilter/nft_xfrm.c                    | 11 +++---
 net/netfilter/xt_osf.c                      |  8 +----
 net/netfilter/xt_quota.c                    | 55 +++++++++++++++++------------
 17 files changed, 92 insertions(+), 79 deletions(-)
 delete mode 100644 include/net/netfilter/nfnetlink_log.h
