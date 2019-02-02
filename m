From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 00/12 net-next,v7] add flow_rule infrastructure
Date: Sat,  2 Feb 2019 12:50:42 +0100
Message-ID: <20190202115054.4880-1-pablo@netfilter.org>
Cc: davem@davemloft.net, thomas.lendacky@amd.com, f.fainelli@gmail.com,
        ariel.elior@cavium.com, michael.chan@broadcom.com,
        santosh@chelsio.com, madalin.bucur@nxp.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jeffrey.t.kirsher@intel.com, tariqt@mellanox.com,
        saeedm@mellanox.com, jiri@mellanox.com, idosch@mellanox.com,
        jakub.kicinski@netronome.com, peppe.cavallaro@st.com,
        grygorii.strashko@ti.com, andrew@lunn.ch,
        vivien.didelot@savoirfairelinux.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, linux-net-drivers@solarflare.com,
        ganeshgr@chelsio.com, ogerlitz@mellanox.com,
        Manish.Chopra@cavium.com, marcelo.leitner@gmail.com,
        mkubecek@suse.cz, venkatkumar.duvvuru@broadcom.com,
        julia.lawall@lip6.fr, john.fastabend@gmail.com,
        netfilter-devel@vger.kernel.org, cphealy@gmail.co
To: netdev@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi,

This patchset, as is, allows us to reuse the driver codebase to
configure ACL hardware offloads for the ethtool_rxnfc and the TC flower
interfaces. A few clients for this infrastructure are presented, such as
the bcm_sf2 and the qede drivers, for reference. Moreover all of the
existing drivers in the tree are converted to use this infrastructure.

This patchset is re-using the existing flow dissector infrastructure
that was introduced by Jiri Pirko et al. so the amount of abstractions
that this patchset adds are minimal. Well, just a few wrapper structures
for the selector side of the rules. And, in order to express actions,
this patchset exposes an action API that is based on the existing TC
action infrastructure and what existing drivers already support on that
front.

v7: This patchset is a rebase on top of the net-next tree, after
    addressing questions and feedback from driver developers in the
    last batch.

Please, apply. Thanks!

P.S: I would like to thank driver developers for their fruitful
     cooperation and feedback, which has been very useful to shape
     the layout of this incremental work on top of the existing
     infrastructure. Thanks!

Pablo Neira Ayuso (12):
  flow_offload: add flow_rule and flow_match structures and use them
  net/mlx5e: support for two independent packet edit actions
  flow_offload: add flow action infrastructure
  cls_api: add translator to flow_action representation
  flow_offload: add statistics retrieval infrastructure and use it
  drivers: net: use flow action infrastructure
  cls_flower: don't expose TC actions to drivers anymore
  flow_offload: add wake-up-on-lan and queue to flow_action
  ethtool: add ethtool_rx_flow_spec to flow_rule structure translator
  dsa: bcm_sf2: use flow_rule infrastructure
  qede: place ethtool_rx_flow_spec after code after TC flower codebase
  qede: use ethtool_rx_flow_rule() to remove duplicated parser code

 drivers/net/dsa/bcm_sf2_cfp.c                      | 102 +--
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c       | 252 ++++----
 .../net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c   | 450 ++++++-------
 drivers/net/ethernet/intel/i40e/i40e_main.c        | 178 ++----
 drivers/net/ethernet/intel/iavf/iavf_main.c        | 195 +++---
 drivers/net/ethernet/intel/igb/igb_main.c          |  64 +-
 .../net/ethernet/mellanox/mlx5/core/en/tc_tun.c    |  68 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    | 698 ++++++++++-----------
 drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c |   2 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_flower.c  | 258 ++++----
 drivers/net/ethernet/netronome/nfp/flower/action.c | 198 +++---
 drivers/net/ethernet/netronome/nfp/flower/match.c  | 417 ++++++------
 .../net/ethernet/netronome/nfp/flower/offload.c    | 154 ++---
 drivers/net/ethernet/qlogic/qede/qede_filter.c     | 572 +++++++----------
 include/linux/ethtool.h                            |  15 +
 include/net/flow_offload.h                         | 203 ++++++
 include/net/pkt_cls.h                              |  16 +-
 net/core/Makefile                                  |   2 +-
 net/core/ethtool.c                                 | 241 +++++++
 net/core/flow_offload.c                            | 153 +++++
 net/sched/cls_api.c                                | 116 ++++
 net/sched/cls_flower.c                             |  71 ++-
 22 files changed, 2416 insertions(+), 2009 deletions(-)
 create mode 100644 include/net/flow_offload.h
 create mode 100644 net/core/flow_offload.c

-- 
2.11.0
