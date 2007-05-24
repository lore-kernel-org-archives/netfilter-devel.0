From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 04/07]: nf_conntrack_h323: fix get_h225_addr() for IPv6
	address access
Date: Fri, 25 May 2007 00:02:11 +0200 (MEST)
Message-ID: <20070524215839.14308.34047.sendpatchset@localhost.localdomain>
References: <20070524215833.14308.60841.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070524215833.14308.60841.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_conntrack_h323: fix get_h225_addr() for IPv6 address access

Update get_h225_addr() to meet the changes in ASN.1 types. It was using
field ip6 to access IPv6 TransportAddress, it should be ip according the
ASN.1 definition.

Signed-off-by: Jing Min Zhao <zhaojingmin@vivecode.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit e71d7c2a5a69f20bd077b91bcc240f7bada53e48
tree 32a4cdeaa054fe66448d43d0255337e8f330d61b
parent bd086e2d746d2c730c5701b09a1198bf6d335287
author Jing Min Zhao <zhaojingmin@vivecode.com> Thu, 24 May 2007 23:49:58 +0200
committer Patrick McHardy <kaber@trash.net> Thu, 24 May 2007 23:49:58 +0200

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
