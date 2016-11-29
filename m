From: Phil Sutter <phil@nwl.cc>
Subject: [iptables PATCH] tcp_xlate: Enclose LH flag values in parentheses
Date: Tue, 29 Nov 2016 12:47:25 +0100
Message-ID: <20161129114725.12735-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:51380 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756519AbcK2Lrh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Nov 2016 06:47:37 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This fixes TCP flags matches:

| $ iptables-translate -A invalid -p tcp --tcp-flags SYN,FIN SYN,FIN -j DROP
| nft add rule ip filter invalid tcp flags & fin|syn == fin|syn counter drop

Although the generated rule is syntactically correct and accepted by
nft, it will be interpreted in a different way than expected since
binary AND takes precedence over OR.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libxt_tcp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/extensions/libxt_tcp.c b/extensions/libxt_tcp.c
index 7f68b81288725..58f3c0a0c3c28 100644
--- a/extensions/libxt_tcp.c
+++ b/extensions/libxt_tcp.c
@@ -435,9 +435,9 @@ static int tcp_xlate(struct xt_xlate *xl,
 		return 0;
 
 	if (tcpinfo->flg_mask || (tcpinfo->invflags & XT_TCP_INV_FLAGS)) {
-		xt_xlate_add(xl, "%stcp flags & ", space);
+		xt_xlate_add(xl, "%stcp flags & (", space);
 		print_tcp_xlate(xl, tcpinfo->flg_mask);
-		xt_xlate_add(xl, " %s ",
+		xt_xlate_add(xl, ") %s ",
 			   tcpinfo->invflags & XT_TCP_INV_FLAGS ? "!=": "==");
 		print_tcp_xlate(xl, tcpinfo->flg_cmp);
 	}
-- 
2.10.0

