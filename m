From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [11/13] [NETFILTER]: xt_iprange: fix subtraction-based comparison
Date: Fri, 1 Feb 2008 00:21:33 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0802010021240.4864@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801312315120.4864@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:56871 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755984AbYAaXVe (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 31 Jan 2008 18:21:34 -0500
In-Reply-To: <Pine.LNX.4.64.0801312315120.4864@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 88da1439625fdc5214ced15df282ed7388acb601
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Thu Jan 31 23:12:07 2008 +0100

    [NETFILTER]: xt_iprange: fix subtraction-based comparison
    
    The host address parts need to be converted to host-endian first
    before arithmetic makes any sense on them.
    
    Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
---
 net/netfilter/xt_iprange.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/xt_iprange.c b/net/netfilter/xt_iprange.c
index 01035fc..624eeda 100644
--- a/net/netfilter/xt_iprange.c
+++ b/net/netfilter/xt_iprange.c
@@ -101,7 +101,7 @@ iprange_ipv6_sub(const struct in6_addr *a, const struct in6_addr *b)
 	int r;
 
 	for (i = 0; i < 4; ++i) {
-		r = (__force u32)a->s6_addr32[i] - (__force u32)b->s6_addr32[i];
+		r = ntohl(a->s6_addr32[i]) - ntohl(b->s6_addr32[i]);
 		if (r != 0)
 			return r;
 	}
