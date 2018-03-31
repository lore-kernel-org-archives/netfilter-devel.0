From: Joe Perches <joe@perches.com>
Subject: [PATCH 00/12] Ethernet: Add and use ether_<type>_addr globals
Date: Sat, 31 Mar 2018 00:05:15 -0700
Message-ID: <cover.1522479607.git.joe@perches.com>
Cc: linux-kernel@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com
To: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        b43-dev@lists.infradead.org, bridge@lists.linux-foundation.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

There are many local static and non-static arrays that are used for
Ethernet broadcast address output or comparison.

Centralize the array into a single separate file and remove the local
arrays.

Joe Perches (12):
  ethernet: Add generic ether_<foo>_addr addresses
  treewide/net: Rename eth_stp_addr to ether_stp_addr
  net: mac80211: Use global ether_broadcast_addr
  bridge: netfilter: Use the new global ether_<foo>_addr arrays
  net: atm: Use ether_broadcast_addr
  wireless: Convert simple uses of a static const Ethernet broadcast address
  brcmfmac: Convert ALLFFMAC to ether_broadcast_addr
  iwlegacy: Remove EXPORT_SYMBOL(il_bcast_addr) and use ether_broadcast_addr
  iwlwifi: Remove local iwl_bcast_addr and use ether_broadcast_addr
  mvpp2: Use ether_broadcast_addr instead of a local array
  qlogic: Convert local bcast_addr to global ether_broadcast_addr
  ethernet: Use ether_zero_addr instead of local statics

 drivers/net/dsa/lan9303-core.c                        |  4 ++--
 drivers/net/ethernet/broadcom/b44.c                   |  5 ++---
 drivers/net/ethernet/freescale/gianfar.c              |  3 +--
 drivers/net/ethernet/marvell/mvpp2.c                  |  4 +---
 drivers/net/ethernet/qlogic/netxen/netxen_nic_hw.c    |  5 +----
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c        |  6 ++----
 .../net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c  |  6 ++----
 drivers/net/wireless/admtek/adm8211.c                 |  3 +--
 drivers/net/wireless/ath/carl9170/mac.c               |  4 +---
 drivers/net/wireless/broadcom/b43/main.c              |  3 +--
 .../net/wireless/broadcom/brcm80211/brcmfmac/common.c |  2 --
 .../net/wireless/broadcom/brcm80211/brcmfmac/common.h |  2 --
 .../wireless/broadcom/brcm80211/brcmfmac/flowring.c   |  8 ++++----
 drivers/net/wireless/intel/iwlegacy/3945-mac.c        |  2 +-
 drivers/net/wireless/intel/iwlegacy/4965-mac.c        |  2 +-
 drivers/net/wireless/intel/iwlegacy/common.c          |  3 ---
 drivers/net/wireless/intel/iwlegacy/common.h          |  1 -
 drivers/net/wireless/intel/iwlwifi/dvm/dev.h          |  1 -
 drivers/net/wireless/intel/iwlwifi/dvm/scan.c         |  2 +-
 drivers/net/wireless/intel/iwlwifi/dvm/sta.c          |  4 +---
 drivers/net/wireless/marvell/mwifiex/cfg80211.c       |  3 +--
 drivers/net/wireless/realtek/rtlwifi/core.c           |  5 ++---
 drivers/net/wireless/rndis_wlan.c                     |  6 +-----
 drivers/net/wireless/ti/wl1251/main.c                 |  5 +----
 drivers/net/wireless/ti/wlcore/main.c                 |  5 +----
 include/linux/etherdevice.h                           | 13 +++++++++----
 net/atm/lec.c                                         | 12 +++++-------
 net/bridge/br_device.c                                |  4 ++--
 net/bridge/netfilter/ebt_stp.c                        |  6 ++----
 net/ethernet/Makefile                                 |  2 +-
 net/ethernet/ether_addrs.c                            | 19 +++++++++++++++++++
 net/mac80211/iface.c                                  |  5 +----
 net/mac80211/key.c                                    |  6 ++----
 net/mac80211/mesh_hwmp.c                              | 19 ++++++++++---------
 net/mac80211/mesh_pathtbl.c                           |  8 ++++----
 35 files changed, 83 insertions(+), 105 deletions(-)
 create mode 100644 net/ethernet/ether_addrs.c

-- 
2.15.0
