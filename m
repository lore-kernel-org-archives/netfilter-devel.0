From: zhaojingmin@vivecode.com (Jing Min Zhao)
Subject: [PATCH 2/4] H.323: update get_h225_addr() for IPv6 address access
Date: Thu, 17 May 2007 15:17:56 -0400 (EDT)
Message-ID: <20070517191756.A7F5F3DA1F9@jzhao.vivecode.com>
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Update get_h225_addr() to meet the changes in ASN.1 types. It was using field ip6 to access IPv6 TransportAddress, it should be ip according the ASN.1 definition.

Signed-off-by: Jing Min Zhao <zhaojingmin@vivecode.com>
---
 net/netfilter/nf_conntrack_h323_main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/nf_conntrack_h323_main.c b/net/netfilter/nf_conntrack_h323_main.c
index b284db7..8bb99b3 100644
--- a/net/netfilter/nf_conntrack_h323_main.c
+++ b/net/netfilter/nf_conntrack_h323_main.c
@@ -640,7 +640,7 @@ int get_h225_addr(struct nf_conn *ct, unsigned char *data,
 	case eTransportAddress_ip6Address:
 		if (family != AF_INET6)
 			return 0;
-		p = data + taddr->ip6Address.ip6;
+		p = data + taddr->ip6Address.ip;
 		len = 16;
 		break;
 	default:
-- 
1.4.4.3
