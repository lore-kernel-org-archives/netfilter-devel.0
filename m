From: =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>
Subject: [PATCH net-next 7/9] benet: use __vlan_hwaccel helpers
Date: Fri, 09 Nov 2018 00:18:04 +0100
Message-ID: <d379d69c6b5a1079b13ff69c1efb17599dbdac94.1541718583.git.mirq-linux@rere.qmqm.pl>
References: <cover.1541718583.git.mirq-linux@rere.qmqm.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: Sathya Perla <sathya.perla@broadcom.com>,
        Ajit Khaparde <ajit.khaparde@broadcom.com>,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
        Somnath Kotur <somnath.kotur@broadcom.com>,
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
        Roopa Pra
To: netdev@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <cover.1541718583.git.mirq-linux@rere.qmqm.pl>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
---
 drivers/net/ethernet/emulex/benet/be_main.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/emulex/benet/be_main.c b/drivers/net/ethernet/emulex/benet/be_main.c
index c5ad7a4f4d83..80b2bd3747ce 100644
--- a/drivers/net/ethernet/emulex/benet/be_main.c
+++ b/drivers/net/ethernet/emulex/benet/be_main.c
@@ -1049,30 +1049,35 @@ static struct sk_buff *be_insert_vlan_in_pkt(struct be_adapter *adapter,
 					     struct be_wrb_params
 					     *wrb_params)
 {
+	bool insert_vlan = false;
 	u16 vlan_tag = 0;
 
 	skb = skb_share_check(skb, GFP_ATOMIC);
 	if (unlikely(!skb))
 		return skb;
 
-	if (skb_vlan_tag_present(skb))
+	if (skb_vlan_tag_present(skb)) {
 		vlan_tag = be_get_tx_vlan_tag(adapter, skb);
+		insert_vlan = true;
+	}
 
 	if (qnq_async_evt_rcvd(adapter) && adapter->pvid) {
-		if (!vlan_tag)
+		if (!insert_vlan) {
 			vlan_tag = adapter->pvid;
+			insert_vlan = true;
+		}
 		/* f/w workaround to set skip_hw_vlan = 1, informs the F/W to
 		 * skip VLAN insertion
 		 */
 		BE_WRB_F_SET(wrb_params->features, VLAN_SKIP_HW, 1);
 	}
 
-	if (vlan_tag) {
+	if (insert_vlan) {
 		skb = vlan_insert_tag_set_proto(skb, htons(ETH_P_8021Q),
 						vlan_tag);
 		if (unlikely(!skb))
 			return skb;
-		skb->vlan_tci = 0;
+		__vlan_hwaccel_clear_tag(skb);
 	}
 
 	/* Insert the outer VLAN, if any */
-- 
2.19.1
