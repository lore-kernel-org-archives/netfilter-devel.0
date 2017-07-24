From: Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH net-next 3/6] benet: fix set but not used warning
Date: Mon, 24 Jul 2017 10:25:20 -0700
Message-ID: <20170724172523.13135-4-sthemmin@microsoft.com>
References: <20170724172523.13135-1-sthemmin@microsoft.com>
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
In-Reply-To: <20170724172523.13135-1-sthemmin@microsoft.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

warning: variable ‘netdev’ set but not used

Signed-off-by: Stephen Hemminger <sthemmin@microsoft.com>
---
 drivers/net/ethernet/emulex/benet/be_roce.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/emulex/benet/be_roce.c b/drivers/net/ethernet/emulex/benet/be_roce.c
index 2b62841c4c63..05989aafaf32 100644
--- a/drivers/net/ethernet/emulex/benet/be_roce.c
+++ b/drivers/net/ethernet/emulex/benet/be_roce.c
@@ -139,10 +139,7 @@ int be_roce_register_driver(struct ocrdma_driver *drv)
 	}
 	ocrdma_drv = drv;
 	list_for_each_entry(dev, &be_adapter_list, entry) {
-		struct net_device *netdev;
-
 		_be_roce_dev_add(dev);
-		netdev = dev->netdev;
 	}
 	mutex_unlock(&be_adapter_list_lock);
 	return 0;
-- 
2.11.0
