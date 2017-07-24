From: Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH net-next 0/6] network related warning fixes
Date: Mon, 24 Jul 2017 10:25:17 -0700
Message-ID: <20170724172523.13135-1-sthemmin@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: netdev@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        Stephen Hemminger <sthemmin@microsoft.com>
To: marcel@holtmann.org, gustavo@padovan.org, johan.hedberg@gmail.com,
        davem@davemloft.net, pablo@netfilter.org, kadlec@blackhole.kfki.hu,
        fw@strlen.de
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Various fixes for warnings in network code and drivers.

Stephen Hemminger (6):
  bnxt: fix unsigned comparsion with 0
  bnxt: fix unused variable warnings
  benet: fix set but not used warning
  netfilter: remove unused variable
  socket: fix set not used warning
  6lowpan: fix set not used warning

 drivers/net/ethernet/broadcom/bnxt/bnxt.c         | 4 ----
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 2 +-
 drivers/net/ethernet/emulex/benet/be_roce.c       | 3 ---
 net/bluetooth/6lowpan.c                           | 3 ---
 net/netfilter/xt_recent.c                         | 2 +-
 net/socket.c                                      | 6 ++----
 6 files changed, 4 insertions(+), 16 deletions(-)

-- 
2.11.0
