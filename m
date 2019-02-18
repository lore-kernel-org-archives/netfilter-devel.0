From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/2] ipvs: fix warning on unused variable
Date: Tue, 19 Feb 2019 00:08:23 +0100
Message-ID: <20190218230823.8114-3-pablo@netfilter.org>
References: <20190218230823.8114-1-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190218230823.8114-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Andrea Claudi <aclaudi@redhat.com>

When CONFIG_IP_VS_IPV6 is not defined, build produced this warning:

net/netfilter/ipvs/ip_vs_ctl.c:899:6: warning: unused variable ‘ret’ [-Wunused-variable]
  int ret = 0;
      ^~~

Fix this by moving the declaration of 'ret' in the CONFIG_IP_VS_IPV6
section in the same function.

While at it, drop its unneeded initialisation.

Fixes: 098e13f5b21d ("ipvs: fix dependency on nf_defrag_ipv6")
Reported-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
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
2.11.0
