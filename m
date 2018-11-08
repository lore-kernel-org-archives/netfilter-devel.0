From: =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>
Subject: [PATCH net-next 4/9] 8021q: use __vlan_hwaccel helpers
Date: Fri, 09 Nov 2018 00:18:03 +0100
Message-ID: <e016c369084d747bdd4b1cd5956f2272261ff678.1541718583.git.mirq-linux@rere.qmqm.pl>
References: <cover.1541718583.git.mirq-linux@rere.qmqm.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
        Ajit Khaparde <ajit.khaparde@broadcom.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        bridge@lists.linux-foundation.org,
        Cong Wang <xiyou.wangcong@gmail.com>, coreteam@netfilter.org,
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
In-Reply-To: <cover.1541718583.git.mirq-linux@rere.qmqm.pl>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
---
 net/8021q/vlan_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/8021q/vlan_core.c b/net/8021q/vlan_core.c
index 4f60e86f4b8d..dd39489c829a 100644
--- a/net/8021q/vlan_core.c
+++ b/net/8021q/vlan_core.c
@@ -57,7 +57,7 @@ bool vlan_do_receive(struct sk_buff **skbp)
 	}
 
 	skb->priority = vlan_get_ingress_priority(vlan_dev, skb->vlan_tci);
-	skb->vlan_tci = 0;
+	__vlan_hwaccel_clear_tag(skb);
 
 	rx_stats = this_cpu_ptr(vlan_dev_priv(vlan_dev)->vlan_pcpu_stats);
 
-- 
2.19.1
