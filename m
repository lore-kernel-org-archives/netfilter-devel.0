From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 3/6] netfilter: conntrack: get rid of double sizeof
Date: Tue,  2 Oct 2018 00:37:42 +0200
Message-ID: <20181001223745.29010-4-pablo@netfilter.org>
References: <20181001223745.29010-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181001223745.29010-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: zhong jiang <zhongjiang@huawei.com>

sizeof(sizeof()) is quite strange and does not seem to be what
is wanted here.

The issue is detected with the help of Coccinelle.

Fixes: 39215846740a ("netfilter: conntrack: remove nlattr_size pointer from l4proto trackers")
Signed-off-by: zhong jiang <zhongjiang@huawei.com>
Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_proto_tcp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index b4bdf9eda7b7..247b89784a6f 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -1213,8 +1213,8 @@ static const struct nla_policy tcp_nla_policy[CTA_PROTOINFO_TCP_MAX+1] = {
 #define TCP_NLATTR_SIZE	( \
 	NLA_ALIGN(NLA_HDRLEN + 1) + \
 	NLA_ALIGN(NLA_HDRLEN + 1) + \
-	NLA_ALIGN(NLA_HDRLEN + sizeof(sizeof(struct nf_ct_tcp_flags))) + \
-	NLA_ALIGN(NLA_HDRLEN + sizeof(sizeof(struct nf_ct_tcp_flags))))
+	NLA_ALIGN(NLA_HDRLEN + sizeof(struct nf_ct_tcp_flags)) + \
+	NLA_ALIGN(NLA_HDRLEN + sizeof(struct nf_ct_tcp_flags)))
 
 static int nlattr_to_tcp(struct nlattr *cda[], struct nf_conn *ct)
 {
-- 
2.11.0
