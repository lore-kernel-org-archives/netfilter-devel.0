From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4/7] ipvs: Fix signed integer overflow when setsockopt timeout
Date: Mon, 28 Jan 2019 15:04:02 +0100
Message-ID: <20190128140405.15020-5-pablo@netfilter.org>
References: <20190128140405.15020-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190128140405.15020-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: ZhangXiaoxu <zhangxiaoxu5@huawei.com>

There is a UBSAN bug report as below:
UBSAN: Undefined behaviour in net/netfilter/ipvs/ip_vs_ctl.c:2227:21
signed integer overflow:
-2147483647 * 1000 cannot be represented in type 'int'

Reproduce program:
	#include <stdio.h>
	#include <sys/types.h>
	#include <sys/socket.h>

	#define IPPROTO_IP 0
	#define IPPROTO_RAW 255

	#define IP_VS_BASE_CTL		(64+1024+64)
	#define IP_VS_SO_SET_TIMEOUT	(IP_VS_BASE_CTL+10)

	/* The argument to IP_VS_SO_GET_TIMEOUT */
	struct ipvs_timeout_t {
		int tcp_timeout;
		int tcp_fin_timeout;
		int udp_timeout;
	};

	int main() {
		int ret = -1;
		int sockfd = -1;
		struct ipvs_timeout_t to;

		sockfd = socket(AF_INET, SOCK_RAW, IPPROTO_RAW);
		if (sockfd == -1) {
			printf("socket init error\n");
			return -1;
		}

		to.tcp_timeout = -2147483647;
		to.tcp_fin_timeout = -2147483647;
		to.udp_timeout = -2147483647;

		ret = setsockopt(sockfd,
				 IPPROTO_IP,
				 IP_VS_SO_SET_TIMEOUT,
				 (char *)(&to),
				 sizeof(to));

		printf("setsockopt return %d\n", ret);
		return ret;
	}

Return -EINVAL if the timeout value is negative or max than 'INT_MAX / HZ'.

Signed-off-by: ZhangXiaoxu <zhangxiaoxu5@huawei.com>
Acked-by: Simon Horman <horms@verge.net.au>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipvs/ip_vs_ctl.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index 432141f04af3..7d6318664eb2 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -2221,6 +2221,18 @@ static int ip_vs_set_timeout(struct netns_ipvs *ipvs, struct ip_vs_timeout_user
 		  u->udp_timeout);
 
 #ifdef CONFIG_IP_VS_PROTO_TCP
+	if (u->tcp_timeout < 0 || u->tcp_timeout > (INT_MAX / HZ) ||
+	    u->tcp_fin_timeout < 0 || u->tcp_fin_timeout > (INT_MAX / HZ)) {
+		return -EINVAL;
+	}
+#endif
+
+#ifdef CONFIG_IP_VS_PROTO_UDP
+	if (u->udp_timeout < 0 || u->udp_timeout > (INT_MAX / HZ))
+		return -EINVAL;
+#endif
+
+#ifdef CONFIG_IP_VS_PROTO_TCP
 	if (u->tcp_timeout) {
 		pd = ip_vs_proto_data_get(ipvs, IPPROTO_TCP);
 		pd->timeout_table[IP_VS_TCP_S_ESTABLISHED]
-- 
2.11.0
