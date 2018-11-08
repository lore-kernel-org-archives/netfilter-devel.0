From: =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>
Subject: [PATCH net-next 3/9] net/core: use __vlan_hwaccel helpers
Date: Fri, 09 Nov 2018 00:18:02 +0100
Message-ID: <c27737b63ec762836a000e2bb4fc95419ab0f097.1541718583.git.mirq-linux@rere.qmqm.pl>
References: <cover.1541718583.git.mirq-linux@rere.qmqm.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ajit Khaparde <ajit.khaparde@broadcom.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        bridge@lists.linux-foundation.org, coreteam@netfilter.org,
        Florian Westphal <fw@strlen.de>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
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
In-Reply-To: <cover.1541718583.git.mirq-linux@rere.qmqm.pl>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This removes assumptions about VLAN_TAG_PRESENT bit.

Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
---
 net/core/dev.c       | 8 +++++---
 net/core/skbuff.c    | 2 +-
 net/sched/act_vlan.c | 2 +-
 3 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 0ffcbdd55fa9..bf7e0a471186 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4889,7 +4889,7 @@ static int __netif_receive_skb_core(struct sk_buff *skb, bool pfmemalloc,
 		 * and set skb->priority like in vlan_do_receive()
 		 * For the time being, just ignore Priority Code Point
 		 */
-		skb->vlan_tci = 0;
+		__vlan_hwaccel_clear_tag(skb);
 	}
 
 	type = skb->protocol;
@@ -5386,7 +5386,9 @@ static struct list_head *gro_list_prepare(struct napi_struct *napi,
 		}
 
 		diffs = (unsigned long)p->dev ^ (unsigned long)skb->dev;
-		diffs |= p->vlan_tci ^ skb->vlan_tci;
+		diffs |= skb_vlan_tag_present(p) ^ skb_vlan_tag_present(skb);
+		if (skb_vlan_tag_present(p))
+			diffs |= p->vlan_tci ^ skb->vlan_tci;
 		diffs |= skb_metadata_dst_cmp(p, skb);
 		diffs |= skb_metadata_differs(p, skb);
 		if (maclen == ETH_HLEN)
@@ -5652,7 +5654,7 @@ static void napi_reuse_skb(struct napi_struct *napi, struct sk_buff *skb)
 	__skb_pull(skb, skb_headlen(skb));
 	/* restore the reserve we had after netdev_alloc_skb_ip_align() */
 	skb_reserve(skb, NET_SKB_PAD + NET_IP_ALIGN - skb_headroom(skb));
-	skb->vlan_tci = 0;
+	__vlan_hwaccel_clear_tag(skb);
 	skb->dev = napi->dev;
 	skb->skb_iif = 0;
 	skb->encapsulation = 0;
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index b4ee5c8b928f..5bb5eb500605 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -5123,7 +5123,7 @@ int skb_vlan_pop(struct sk_buff *skb)
 	int err;
 
 	if (likely(skb_vlan_tag_present(skb))) {
-		skb->vlan_tci = 0;
+		__vlan_hwaccel_clear_tag(skb);
 	} else {
 		if (unlikely(!eth_type_vlan(skb->protocol)))
 			return 0;
diff --git a/net/sched/act_vlan.c b/net/sched/act_vlan.c
index ba677d54a7af..93fdaf707313 100644
--- a/net/sched/act_vlan.c
+++ b/net/sched/act_vlan.c
@@ -63,7 +63,7 @@ static int tcf_vlan_act(struct sk_buff *skb, const struct tc_action *a,
 		/* extract existing tag (and guarantee no hw-accel tag) */
 		if (skb_vlan_tag_present(skb)) {
 			tci = skb_vlan_tag_get(skb);
-			skb->vlan_tci = 0;
+			__vlan_hwaccel_clear_tag(skb);
 		} else {
 			/* in-payload vlan tag, pop it */
 			err = __skb_vlan_pop(skb, &tci);
-- 
2.19.1
