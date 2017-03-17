From: fgao@ikuai8.com
Subject: [PATCH nf-next 2/4] netfilter: irc: Correct the return value comparison of the func nf_nat_mangle_tcp_packet
Date: Fri, 17 Mar 2017 14:47:54 +0800
Message-ID: <bb4505ef9199fee74666920308609607ca69d5ba.1489726438.git.fgao@ikuai8.com>
References: <cover.1489726438.git.fgao@ikuai8.com>
Cc: Gao Feng <fgao@ikuai8.com>
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
        gfree.wind@gmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpbg292.qq.com ([113.108.11.231]:39502 "EHLO smtpbg292.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750982AbdCQGsb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 Mar 2017 02:48:31 -0400
In-Reply-To: <cover.1489726438.git.fgao@ikuai8.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Gao Feng <fgao@ikuai8.com>

The return value of nf_nat_mangle_tcp_packet actually is 1 and 0 as
bool type. But the irc codes compare it with NF_ACCEPT.

Signed-off-by: Gao Feng <fgao@ikuai8.com>
---
 net/netfilter/nf_nat_irc.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nf_nat_irc.c b/net/netfilter/nf_nat_irc.c
index 1fb2258..0648cb0 100644
--- a/net/netfilter/nf_nat_irc.c
+++ b/net/netfilter/nf_nat_irc.c
@@ -37,7 +37,6 @@ static unsigned int help(struct sk_buff *skb,
 	struct nf_conn *ct = exp->master;
 	union nf_inet_addr newaddr;
 	u_int16_t port;
-	unsigned int ret;
 
 	/* Reply comes from server. */
 	newaddr = ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.u3;
@@ -83,14 +82,14 @@ static unsigned int help(struct sk_buff *skb,
 	pr_debug("nf_nat_irc: inserting '%s' == %pI4, port %u\n",
 		 buffer, &newaddr.ip, port);
 
-	ret = nf_nat_mangle_tcp_packet(skb, ct, ctinfo, protoff, matchoff,
-				       matchlen, buffer, strlen(buffer));
-	if (ret != NF_ACCEPT) {
+	if (!nf_nat_mangle_tcp_packet(skb, ct, ctinfo, protoff, matchoff,
+				      matchlen, buffer, strlen(buffer))) {
 		nf_ct_helper_log(skb, ct, "cannot mangle packet");
 		nf_ct_unexpect_related(exp);
+		return NF_DROP;
 	}
 
-	return ret;
+	return NF_ACCEPT;
 }
 
 static void __exit nf_nat_irc_fini(void)
-- 
1.9.1


