From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 13/23] netfilter: nf_ct_h323: Out Of Bound Read in Netfilter Conntrack
Date: Tue,  7 Nov 2017 01:52:03 +0100
Message-ID: <20171107005213.22618-14-pablo@netfilter.org>
References: <20171107005213.22618-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20171107005213.22618-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Eric Sesterhenn <eric.sesterhenn@x41-dsec.de>

Add missing counter decrement to prevent out of bounds memory read.

Signed-off-by: Eric Sesterhenn <eric.sesterhenn@x41-dsec.de>
Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_h323_asn1.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nf_conntrack_h323_asn1.c b/net/netfilter/nf_conntrack_h323_asn1.c
index 7831aa1effc9..cf1bf2605c10 100644
--- a/net/netfilter/nf_conntrack_h323_asn1.c
+++ b/net/netfilter/nf_conntrack_h323_asn1.c
@@ -877,6 +877,7 @@ int DecodeQ931(unsigned char *buf, size_t sz, Q931 *q931)
 		if (sz < 1)
 			break;
 		len = *p++;
+		sz--;
 		if (sz < len)
 			break;
 		p += len;
-- 
2.11.0
