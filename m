From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6/7] netfilter: nfnetlink_osf: add missing fmatch check
Date: Mon, 28 Jan 2019 15:04:04 +0100
Message-ID: <20190128140405.15020-7-pablo@netfilter.org>
References: <20190128140405.15020-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190128140405.15020-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Fernando Fernandez Mancera <ffmancera@riseup.net>

When we check the tcp options of a packet and it doesn't match the current
fingerprint, the tcp packet option pointer must be restored to its initial
value in order to do the proper tcp options check for the next fingerprint.

Here we can see an example.
Assumming the following fingerprint base with two lines:

S10:64:1:60:M*,S,T,N,W6:      Linux:3.0::Linux 3.0
S20:64:1:60:M*,S,T,N,W7:      Linux:4.19:arch:Linux 4.1

Where TCP options are the last field in the OS signature, all of them overlap
except by the last one, ie. 'W6' versus 'W7'.

In case a packet for Linux 4.19 kicks in, the osf finds no matching because the
TCP options pointer is updated after checking for the TCP options in the first
line.

Therefore, reset pointer back to where it should be.

Fixes: 11eeef41d5f6 ("netfilter: passive OS fingerprint xtables match")
Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nfnetlink_osf.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/netfilter/nfnetlink_osf.c b/net/netfilter/nfnetlink_osf.c
index 6f41dd74729d..1f1d90c1716b 100644
--- a/net/netfilter/nfnetlink_osf.c
+++ b/net/netfilter/nfnetlink_osf.c
@@ -66,6 +66,7 @@ static bool nf_osf_match_one(const struct sk_buff *skb,
 			     int ttl_check,
 			     struct nf_osf_hdr_ctx *ctx)
 {
+	const __u8 *optpinit = ctx->optp;
 	unsigned int check_WSS = 0;
 	int fmatch = FMATCH_WRONG;
 	int foptsize, optnum;
@@ -155,6 +156,9 @@ static bool nf_osf_match_one(const struct sk_buff *skb,
 		}
 	}
 
+	if (fmatch != FMATCH_OK)
+		ctx->optp = optpinit;
+
 	return fmatch == FMATCH_OK;
 }
 
-- 
2.11.0
