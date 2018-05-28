From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 0/9] Netfilter/IPVS fixes for net
Date: Tue, 29 May 2018 01:42:12 +0200
Message-ID: <20180528234221.31254-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi David,

The following patchset contains Netfilter/IPVS fixes for your net tree:

1) Null pointer dereference when dumping conntrack helper configuration,
   from Taehee Yoo.

2) Missing sanitization in ebtables extension name through compat,
   from Paolo Abeni.

3) Broken fetch of tracing value, from Taehee Yoo.

4) Incorrect arithmetics in packet ratelimiting.

5) Buffer overflow in IPVS sync daemon, from Julian Anastasov.

6) Wrong argument to nla_strlcpy() in nfnetlink_{acct,cthelper},
   from Eric Dumazet.

7) Fix splat in nft_update_chain_stats().

8) Null pointer dereference from object netlink dump path, from
   Taehee Yoo.

9) Missing static_branch_inc() when enabling counters in existing
   chain, from Taehee Yoo.

You can pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thanks.

----------------------------------------------------------------

The following changes since commit 7063efd33bb15abc0160347f89eb5aba6b7d000e:

  tuntap: fix use after free during release (2018-05-16 14:53:10 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to bbb8c61f97e3a2dd91b30d3e57b7964a67569d11:

  netfilter: nf_tables: increase nft_counters_enabled in nft_chain_stats_replace() (2018-05-29 00:15:12 +0200)

----------------------------------------------------------------
Eric Dumazet (1):
      netfilter: provide correct argument to nla_strlcpy()

Julian Anastasov (1):
      ipvs: fix buffer overflow with sync daemon and service

Pablo Neira Ayuso (2):
      netfilter: nft_limit: fix packet ratelimiting
      netfilter: nf_tables: disable preemption in nft_update_chain_stats()

Paolo Abeni (1):
      netfilter: ebtables: handle string from userspace with care

Taehee Yoo (4):
      netfilter: nf_tables: fix NULL pointer dereference on nft_ct_helper_obj_dump()
      netfilter: nft_meta: fix wrong value dereference in nft_meta_set_eval
      netfilter: nf_tables: fix NULL-ptr in nf_tables_dump_obj()
      netfilter: nf_tables: increase nft_counters_enabled in nft_chain_stats_replace()

 net/bridge/netfilter/ebtables.c    |  3 ++-
 net/netfilter/ipvs/ip_vs_ctl.c     | 21 +++++++++++++++------
 net/netfilter/nf_tables_api.c      |  8 +++++---
 net/netfilter/nf_tables_core.c     |  4 ++--
 net/netfilter/nfnetlink_acct.c     |  2 +-
 net/netfilter/nfnetlink_cthelper.c |  4 ++--
 net/netfilter/nft_ct.c             | 20 ++++++++++++--------
 net/netfilter/nft_limit.c          | 38 ++++++++++++++++++++++++--------------
 net/netfilter/nft_meta.c           | 14 ++++++++------
 9 files changed, 71 insertions(+), 43 deletions(-)
