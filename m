From: Borislav Petkov <bp@alien8.de>
Subject: [PATCH] netfilter/ipvs: Fix unused variable warning
Date: Sat, 16 Feb 2019 23:33:58 +0100
Message-ID: <20190216223358.30711-1-bp@alien8.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: Andrea Claudi <aclaudi@redhat.com>, coreteam@netfilter.org,
        Florian Westphal <fw@strlen.de>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Julian Anastasov <ja@ssi.bg>, Li Shuang <shuali@redhat.com>,
        netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Simon Horman <horms@verge.net.au>
To: LKML <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Move the local variable 'ret' into the IP_VS_IPV6 ifdef so that the
unused variable warning doesn't fire for randconfig builds with
CONFIG_IP_VS_IPV6 disabled.

Fixes: 098e13f5b21d ("ipvs: fix dependency on nf_defrag_ipv6")
Cc: Andrea Claudi <aclaudi@redhat.com>
Cc: coreteam@netfilter.org
Cc: Florian Westphal <fw@strlen.de>
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Cc: Julian Anastasov <ja@ssi.bg>
Cc: Li Shuang <shuali@redhat.com>
Cc: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Simon Horman <horms@verge.net.au>
Signed-off-by: Borislav Petkov <bp@suse.de>
---
 net/netfilter/ipvs/ip_vs_ctl.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index 86afacb07e5f..ac8d848d7624 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -896,12 +896,13 @@ ip_vs_new_dest(struct ip_vs_service *svc, struct ip_vs_dest_user_kern *udest,
 {
 	struct ip_vs_dest *dest;
 	unsigned int atype, i;
-	int ret = 0;
 
 	EnterFunction(2);
 
 #ifdef CONFIG_IP_VS_IPV6
 	if (udest->af == AF_INET6) {
+		int ret;
+
 		atype = ipv6_addr_type(&udest->addr.in6);
 		if ((!(atype & IPV6_ADDR_UNICAST) ||
 			atype & IPV6_ADDR_LINKLOCAL) &&
-- 
2.19.1
