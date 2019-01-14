From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 0/7] Netfilter fixes for net
Date: Mon, 14 Jan 2019 22:29:33 +0100
Message-ID: <20190114212940.5704-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi David,

This is the first batch of Netfilter fixes for your net tree:

1) Fix endless loop in nf_tables rules netlink dump, from Phil Sutter.

2) Reference counter leak in object from the error path, from Taehee Yoo.

3) Selective rule dump requires table and chain.

4) Fix DNAT with nft_flow_offload reverse route lookup, from wenxu.

5) Use GFP_KERNEL_ACCOUNT in vmalloc allocation from ebtables, from
   Shakeel Butt.

6) Set ifindex from route to fix interaction with VRF slave device,
   also from wenxu.

7) Use nfct_help() to check for conntrack helper, IPS_HELPER status
   flag is only set from explicit helpers via -j CT, from Henry Yen.

You can pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thanks!

----------------------------------------------------------------

The following changes since commit a0071840d2040ea1b27e5a008182b09b88defc15:

  lan743x: Remove phy_read from link status change function (2019-01-08 16:26:12 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to 2314e879747e82896f51cce4488f6a00f3e1af7b:

  netfilter: nft_flow_offload: fix checking method of conntrack helper (2019-01-14 12:50:59 +0100)

----------------------------------------------------------------
Henry Yen (1):
      netfilter: nft_flow_offload: fix checking method of conntrack helper

Pablo Neira Ayuso (1):
      netfilter: nf_tables: selective rule dump needs table to be specified

Phil Sutter (1):
      netfilter: nf_tables: Fix for endless loop when dumping ruleset

Shakeel Butt (1):
      netfilter: ebtables: account ebt_table_info to kmemcg

Taehee Yoo (1):
      netfilter: nf_tables: fix leaking object reference count

wenxu (2):
      netfilter: nft_flow_offload: Fix reverse route lookup
      netfilter: nft_flow_offload: fix interaction with vrf slave device

 include/net/netfilter/nf_flow_table.h |  1 -
 net/bridge/netfilter/ebtables.c       |  6 ++++--
 net/netfilter/nf_flow_table_core.c    |  5 +++--
 net/netfilter/nf_tables_api.c         | 14 +++++++-------
 net/netfilter/nft_flow_offload.c      | 13 ++++++++-----
 5 files changed, 22 insertions(+), 17 deletions(-)
