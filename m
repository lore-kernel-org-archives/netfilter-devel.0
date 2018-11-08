From: =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>
Subject: [PATCH net-next 5/9] bridge: use __vlan_hwaccel helpers
Date: Fri, 09 Nov 2018 00:18:03 +0100
Message-ID: <e3a2983a43e3e31bc123f0129d08d4b9df267136.1541718583.git.mirq-linux@rere.qmqm.pl>
References: <cover.1541718583.git.mirq-linux@rere.qmqm.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        bridge@lists.linux-foundation.org,
        Ajit Khaparde <ajit.khaparde@broadcom.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>, linux-rdma@vger.kernel.org,
        Mirko Lindner <mlindner@marvell.com>,
        Sathya Perla <sathya.perla@broadcom.com>,
        Somnath Kotur <somnath.kotur@broadcom.com>,
        Sriharsha Basavapatna <srih
To: netdev@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <cover.1541718583.git.mirq-linux@rere.qmqm.pl>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This removes assumption than vlan_tci != 0 when tag is present.

Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
---
 net/bridge/br_netfilter_hooks.c | 15 +++++++++------
 net/bridge/br_private.h         |  2 +-
 net/bridge/br_vlan.c            |  6 +++---
 3 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
index b1b5e8516724..c9383c470a83 100644
--- a/net/bridge/br_netfilter_hooks.c
+++ b/net/bridge/br_netfilter_hooks.c
@@ -671,10 +671,8 @@ static int br_nf_push_frag_xmit(struct net *net, struct sock *sk, struct sk_buff
 		return 0;
 	}
 
-	if (data->vlan_tci) {
-		skb->vlan_tci = data->vlan_tci;
-		skb->vlan_proto = data->vlan_proto;
-	}
+	if (data->vlan_proto)
+		__vlan_hwaccel_put_tag(skb, data->vlan_proto, data->vlan_tci);
 
 	skb_copy_to_linear_data_offset(skb, -data->size, data->mac, data->size);
 	__skb_push(skb, data->encap_size);
@@ -740,8 +738,13 @@ static int br_nf_dev_queue_xmit(struct net *net, struct sock *sk, struct sk_buff
 
 		data = this_cpu_ptr(&brnf_frag_data_storage);
 
-		data->vlan_tci = skb->vlan_tci;
-		data->vlan_proto = skb->vlan_proto;
+		if (skb_vlan_tag_present(skb)) {
+			data->vlan_tci = skb->vlan_tci;
+			data->vlan_proto = skb->vlan_proto;
+		} else {
+			data->vlan_proto = 0;
+		}
+
 		data->encap_size = nf_bridge_encap_header_len(skb);
 		data->size = ETH_HLEN + data->encap_size;
 
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 2920e06a5403..67105c66584a 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -905,7 +905,7 @@ static inline int br_vlan_get_tag(const struct sk_buff *skb, u16 *vid)
 	int err = 0;
 
 	if (skb_vlan_tag_present(skb)) {
-		*vid = skb_vlan_tag_get(skb) & VLAN_VID_MASK;
+		*vid = skb_vlan_tag_get_id(skb);
 	} else {
 		*vid = 0;
 		err = -EINVAL;
diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index 8c9297a01947..a7e869da21bf 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -420,7 +420,7 @@ struct sk_buff *br_handle_vlan(struct net_bridge *br,
 	}
 
 	if (v->flags & BRIDGE_VLAN_INFO_UNTAGGED)
-		skb->vlan_tci = 0;
+		__vlan_hwaccel_clear_tag(skb);
 
 	if (p && (p->flags & BR_VLAN_TUNNEL) &&
 	    br_handle_egress_vlan_tunnel(skb, v)) {
@@ -493,8 +493,8 @@ static bool __allowed_ingress(const struct net_bridge *br,
 			__vlan_hwaccel_put_tag(skb, br->vlan_proto, pvid);
 		else
 			/* Priority-tagged Frame.
-			 * At this point, We know that skb->vlan_tci had
-			 * VLAN_TAG_PRESENT bit and its VID field was 0x000.
+			 * At this point, we know that skb->vlan_tci VID
+			 * field was 0.
 			 * We update only VID field and preserve PCP field.
 			 */
 			skb->vlan_tci |= pvid;
-- 
2.19.1
