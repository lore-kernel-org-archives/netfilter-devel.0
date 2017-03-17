From: fgao@ikuai8.com
Subject: [PATCH nf-next 4/4] netfilter: sip: Use NF_DROP and NF_ACCEPT instead of 0 and 1
Date: Fri, 17 Mar 2017 14:49:50 +0800
Message-ID: <5b6ed9bdf11a28a4c514cb94ca042f741d9d688b.1489726438.git.fgao@ikuai8.com>
References: <cover.1489726438.git.fgao@ikuai8.com>
Cc: Gao Feng <fgao@ikuai8.com>
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
        gfree.wind@gmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from SMTPBG252.QQ.COM ([183.60.52.105]:56372 "EHLO smtpbg252.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751107AbdCQGzT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 Mar 2017 02:55:19 -0400
In-Reply-To: <cover.1489726438.git.fgao@ikuai8.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Gao Feng <fgao@ikuai8.com>

The current sip codes should use NF_DROP and NF_ACCEPT instead of
the literal number 0 and 1.

Signed-off-by: Gao Feng <fgao@ikuai8.com>
---
 net/netfilter/nf_nat_sip.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_nat_sip.c b/net/netfilter/nf_nat_sip.c
index 791fac4..a093979 100644
--- a/net/netfilter/nf_nat_sip.c
+++ b/net/netfilter/nf_nat_sip.c
@@ -48,7 +48,7 @@ static unsigned int mangle_packet(struct sk_buff *skb, unsigned int protoff,
 		if (!__nf_nat_mangle_tcp_packet(skb, ct, ctinfo,
 						protoff, matchoff, matchlen,
 						buffer, buflen, false))
-			return 0;
+			return NF_DROP;
 	} else {
 		baseoff = protoff + sizeof(struct udphdr);
 		matchoff += dataoff - baseoff;
@@ -56,13 +56,13 @@ static unsigned int mangle_packet(struct sk_buff *skb, unsigned int protoff,
 		if (!nf_nat_mangle_udp_packet(skb, ct, ctinfo,
 					      protoff, matchoff, matchlen,
 					      buffer, buflen))
-			return 0;
+			return NF_DROP;
 	}
 
 	/* Reload data pointer and adjust datalen value */
 	*dptr = skb->data + dataoff;
 	*datalen += buflen - matchlen;
-	return 1;
+	return NF_ACCEPT;
 }
 
 static int sip_sprintf_addr(const struct nf_conn *ct, char *buffer,
-- 
1.9.1


