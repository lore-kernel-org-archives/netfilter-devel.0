From: Wei Yongjun <weiyongjun1@huawei.com>
Subject: [PATCH net-next] netfilter: nf_flow_table: remove duplicated include from nf_flow_table_ipv6.c
Date: Wed, 10 Jan 2018 13:07:06 +0000
Message-ID: <1515589626-72041-1-git-send-email-weiyongjun1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Wei Yongjun <weiyongjun1@huawei.com>,
        <netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>,
        <netdev@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Remove duplicated include.

Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 net/ipv6/netfilter/nf_flow_table_ipv6.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/ipv6/netfilter/nf_flow_table_ipv6.c b/net/ipv6/netfilter/nf_flow_table_ipv6.c
index 0c3b9d3..fff2160 100644
--- a/net/ipv6/netfilter/nf_flow_table_ipv6.c
+++ b/net/ipv6/netfilter/nf_flow_table_ipv6.c
@@ -5,7 +5,6 @@
 #include <linux/rhashtable.h>
 #include <linux/ipv6.h>
 #include <linux/netdevice.h>
-#include <linux/ipv6.h>
 #include <net/ipv6.h>
 #include <net/ip6_route.h>
 #include <net/neighbour.h>
