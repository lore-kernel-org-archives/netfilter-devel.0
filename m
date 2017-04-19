From: gfree.wind@foxmail.com
Subject: [PATCH nf-next] netfilter: tcp: Use TCP_MAX_WSCALE instead of literal 14
Date: Wed, 19 Apr 2017 09:23:42 +0800
Message-ID: <1492565022-110676-1-git-send-email-gfree.wind@foxmail.com>
Cc: Gao Feng <fgao@ikuai8.com>
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpbgbr2.qq.com ([54.207.22.56]:39947 "EHLO smtpbgbr2.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758886AbdDSBYP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Apr 2017 21:24:15 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Gao Feng <fgao@ikuai8.com>

The window scale may be enlarged from 14 to 15 according to the itef
draft https://tools.ietf.org/html/draft-nishida-tcpm-maxwin-03.

Use the macro TCP_MAX_WSCALE to support it easily with TCP stack in
the future.

Signed-off-by: Gao Feng <fgao@ikuai8.com>
---
 net/netfilter/nf_conntrack_proto_tcp.c | 7 +++----
 net/netfilter/nf_synproxy_core.c       | 4 ++--
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index b122e9d..741acdc 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -419,10 +419,9 @@ static void tcp_options(const struct sk_buff *skb,
 				 && opsize == TCPOLEN_WINDOW) {
 				state->td_scale = *(u_int8_t *)ptr;
 
-				if (state->td_scale > 14) {
-					/* See RFC1323 */
-					state->td_scale = 14;
-				}
+				if (state->td_scale > TCP_MAX_WSCALE)
+					state->td_scale = TCP_MAX_WSCALE;
+
 				state->flags |=
 					IP_CT_TCP_FLAG_WINDOW_SCALE;
 			}
diff --git a/net/netfilter/nf_synproxy_core.c b/net/netfilter/nf_synproxy_core.c
index abe03e8..a504e87 100644
--- a/net/netfilter/nf_synproxy_core.c
+++ b/net/netfilter/nf_synproxy_core.c
@@ -66,8 +66,8 @@
 			case TCPOPT_WINDOW:
 				if (opsize == TCPOLEN_WINDOW) {
 					opts->wscale = *ptr;
-					if (opts->wscale > 14)
-						opts->wscale = 14;
+					if (opts->wscale > TCP_MAX_WSCALE)
+						opts->wscale = TCP_MAX_WSCALE;
 					opts->options |= XT_SYNPROXY_OPT_WSCALE;
 				}
 				break;
-- 
1.9.1




