From: =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>
Subject: [PATCH net-next 0/9] Use __vlan_hwaccel_*() helpers
Date: Fri, 09 Nov 2018 00:17:58 +0100
Message-ID: <cover.1541718583.git.mirq-linux@rere.qmqm.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: Ajit Khaparde <ajit.khaparde@broadcom.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        bridge@lists.linux-foundation.org,
        Cong Wang <xiyou.wangcong@gmail.com>, coreteam@netfilter.org,
        "David S. Miller" <davem@davemloft.net>,
        Florian Westphal <fw@strlen.de>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        linux-rdma@vger.kernel.org, Mirko Lindner <mlindner@marvell.com>,
        netfilter-devel@vger.kernel.org,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Sathya Perla <sathya.perla@broadcom.com>,
        Somnath Kotur <somnath.kotur@broadcom.com>,
        Sriharsha Basavapatna <srih
To: netdev@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This series removes from networking core and driver code an assumption
about how VLAN tag presence is stored in an skb. This will allow to free
up overloading of VLAN.CFI bit to incidate tag's presence.

Michał Mirosław (9):
  cxgb4: use __vlan_hwaccel helpers
  nfnetlink/queue: use __vlan_hwaccel helpers
  net/core: use __vlan_hwaccel helpers
  8021q: use __vlan_hwaccel helpers
  bridge: use __vlan_hwaccel helpers
  ipv4/tunnel: use __vlan_hwaccel helpers
  benet: use __vlan_hwaccel helpers
  mlx4: use __vlan_hwaccel helpers
  sky2: use __vlan_hwaccel helpers

 drivers/infiniband/hw/cxgb4/cm.c            |  2 +-
 drivers/net/ethernet/emulex/benet/be_main.c | 13 +++++++++----
 drivers/net/ethernet/marvell/sky2.c         |  6 ++----
 drivers/net/ethernet/mellanox/mlx4/en_rx.c  |  2 +-
 net/8021q/vlan_core.c                       |  2 +-
 net/bridge/br_netfilter_hooks.c             | 15 +++++++++------
 net/bridge/br_private.h                     |  2 +-
 net/bridge/br_vlan.c                        |  6 +++---
 net/core/dev.c                              |  8 +++++---
 net/core/skbuff.c                           |  2 +-
 net/ipv4/ip_tunnel_core.c                   |  2 +-
 net/netfilter/nfnetlink_queue.c             |  5 +++--
 net/sched/act_vlan.c                        |  2 +-
 13 files changed, 38 insertions(+), 29 deletions(-)

-- 
2.19.1
