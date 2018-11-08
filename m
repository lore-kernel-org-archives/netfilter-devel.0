From: =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>
Subject: [PATCH net-next 6/9] ipv4/tunnel: use __vlan_hwaccel helpers
Date: Fri, 09 Nov 2018 00:18:04 +0100
Message-ID: <53209e7c5fd949ac69087902ad42b1831eec0727.1541718583.git.mirq-linux@rere.qmqm.pl>
References: <cover.1541718583.git.mirq-linux@rere.qmqm.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Ajit Khaparde <ajit.khaparde@broadcom.com>,
        bridge@lists.linux-foundation.org,
        Cong Wang <xiyou.wangcong@gmail.com>, coreteam@netfilter.org,
        Florian Westphal <fw@strlen.de>,
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
 net/ipv4/ip_tunnel_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/ip_tunnel_core.c b/net/ipv4/ip_tunnel_core.c
index dde671e97829..f45b96d715f0 100644
--- a/net/ipv4/ip_tunnel_core.c
+++ b/net/ipv4/ip_tunnel_core.c
@@ -120,7 +120,7 @@ int __iptunnel_pull_header(struct sk_buff *skb, int hdr_len,
 	}
 
 	skb_clear_hash_if_not_l4(skb);
-	skb->vlan_tci = 0;
+	__vlan_hwaccel_clear_tag(skb);
 	skb_set_queue_mapping(skb, 0);
 	skb_scrub_packet(skb, xnet);
 
-- 
2.19.1
