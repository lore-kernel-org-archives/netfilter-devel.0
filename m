From: fgao@ikuai8.com
Subject: [PATCH nf-next 1/4] netfilter: amanda: Correct the return value comparison of the func nf_nat_mangle_udp_packet
Date: Fri, 17 Mar 2017 14:47:19 +0800
Message-ID: <fdfd3853391d136ba390dfdc4dc6884f552e540e.1489726438.git.fgao@ikuai8.com>
References: <cover.1489726438.git.fgao@ikuai8.com>
Cc: Gao Feng <fgao@ikuai8.com>
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
        gfree.wind@gmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from SMTPBG181.QQ.COM ([119.147.193.88]:53436 "EHLO smtpbg181.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751126AbdCQGzT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 Mar 2017 02:55:19 -0400
In-Reply-To: <cover.1489726438.git.fgao@ikuai8.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Gao Feng <fgao@ikuai8.com>

The return value of nf_nat_mangle_udp_packet actually is 1 and 0 as
bool type. But the amanda codes compare it with NF_ACCEPT.

Signed-off-by: Gao Feng <fgao@ikuai8.com>
---
 net/netfilter/nf_nat_amanda.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_nat_amanda.c b/net/netfilter/nf_nat_amanda.c
index eb77238..e4d61a7 100644
--- a/net/netfilter/nf_nat_amanda.c
+++ b/net/netfilter/nf_nat_amanda.c
@@ -33,7 +33,6 @@ static unsigned int help(struct sk_buff *skb,
 {
 	char buffer[sizeof("65535")];
 	u_int16_t port;
-	unsigned int ret;
 
 	/* Connection comes from client. */
 	exp->saved_proto.tcp.port = exp->tuple.dst.u.tcp.port;
@@ -63,14 +62,14 @@ static unsigned int help(struct sk_buff *skb,
 	}
 
 	sprintf(buffer, "%u", port);
-	ret = nf_nat_mangle_udp_packet(skb, exp->master, ctinfo,
-				       protoff, matchoff, matchlen,
-				       buffer, strlen(buffer));
-	if (ret != NF_ACCEPT) {
+	if (!nf_nat_mangle_udp_packet(skb, exp->master, ctinfo,
+				      protoff, matchoff, matchlen,
+				      buffer, strlen(buffer))) {
 		nf_ct_helper_log(skb, exp->master, "cannot mangle packet");
 		nf_ct_unexpect_related(exp);
+		return NF_DROP;
 	}
-	return ret;
+	return NF_ACCEPT;
 }
 
 static void __exit nf_nat_amanda_fini(void)
-- 
1.9.1


