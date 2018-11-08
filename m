From: =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>
Subject: [PATCH net-next 2/9] nfnetlink/queue: use __vlan_hwaccel helpers
Date: Fri, 09 Nov 2018 00:18:02 +0100
Message-ID: <af0443419646b8e53d794c7565c47f8dc9ef5d1a.1541718583.git.mirq-linux@rere.qmqm.pl>
References: <cover.1541718583.git.mirq-linux@rere.qmqm.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        Ajit Khaparde <ajit.khaparde@broadcom.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        bridge@lists.linux-foundation.org,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>, linux-rdma@vger.kernel.org,
        Mirko Lindner <mlindner@marvell.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
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
 net/netfilter/nfnetlink_queue.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 43041f087eb3..1ce30efe6854 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -1148,8 +1148,9 @@ static int nfqa_parse_bridge(struct nf_queue_entry *entry,
 		if (!tb[NFQA_VLAN_TCI] || !tb[NFQA_VLAN_PROTO])
 			return -EINVAL;
 
-		entry->skb->vlan_tci = ntohs(nla_get_be16(tb[NFQA_VLAN_TCI]));
-		entry->skb->vlan_proto = nla_get_be16(tb[NFQA_VLAN_PROTO]);
+		__vlan_hwaccel_put_tag(entry->skb,
+			nla_get_be16(tb[NFQA_VLAN_PROTO]),
+			ntohs(nla_get_be16(tb[NFQA_VLAN_TCI])));
 	}
 
 	if (nfqa[NFQA_L2HDR]) {
-- 
2.19.1
