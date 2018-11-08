From: =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>
Subject: [PATCH net-next 1/9] cxgb4: use __vlan_hwaccel helpers
Date: Fri, 09 Nov 2018 00:18:01 +0100
Message-ID: <e579b65f04995118e86f7042ef4d436bc1f09e86.1541718583.git.mirq-linux@rere.qmqm.pl>
References: <cover.1541718583.git.mirq-linux@rere.qmqm.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: Steve Wise <swise@chelsio.com>, linux-rdma@vger.kernel.org,
        Ajit Khaparde <ajit.khaparde@broadcom.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        bridge@lists.linux-foundation.org,
        Cong Wang <xiyou.wangcong@gmail.com>, coreteam@netfilter.org,
        "David S. Miller" <davem@davemloft.net>,
        Florian Westphal <fw@strlen.de>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Mirko Lindner <mlindner@marvell.com>,
        netfilter-devel@vger.kernel.org,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Sathya Perla <sathya.perla@broadcom.com>,
        Somnath Kotur <somnath.kotur@broadcom.c
To: netdev@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <cover.1541718583.git.mirq-linux@rere.qmqm.pl>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Use __vlan_hwaccel_put_tag() to set vlan tag and proto fields.

Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
---
 drivers/infiniband/hw/cxgb4/cm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index 615413bd3e8d..8ed01e07c463 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -3944,7 +3944,7 @@ static int rx_pkt(struct c4iw_dev *dev, struct sk_buff *skb)
 	} else {
 		vlan_eh = (struct vlan_ethhdr *)(req + 1);
 		iph = (struct iphdr *)(vlan_eh + 1);
-		skb->vlan_tci = ntohs(cpl->vlan);
+		__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q), ntohs(cpl->vlan));
 	}
 
 	if (iph->version != 0x4)
-- 
2.19.1
