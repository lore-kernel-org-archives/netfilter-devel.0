From: zhong jiang <zhongjiang@huawei.com>
Subject: [PATCH] netfilter: conntrack: get rid of double sizeof
Date: Wed, 19 Sep 2018 20:21:11 +0800
Message-ID: <1537359671-53720-1-git-send-email-zhongjiang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <kadlec@blackhole.kfki.hu>, <pablo@netfilter.org>, <fw@strlen.de>,
        <netfilter-devel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
To: <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

sizeof(sizeof()) is quite strange and does not seem to be what
is wanted here.

The issue is detected with the help of Coccinelle.

Signed-off-by: zhong jiang <zhongjiang@huawei.com>
---
 net/netfilter/nf_conntrack_proto_tcp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index b4bdf9e..247b897 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -1213,8 +1213,8 @@ static int tcp_to_nlattr(struct sk_buff *skb, struct nlattr *nla,
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
1.7.12.4
