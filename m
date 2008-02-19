From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 06/07]: xt_iprange: fix subtraction-based comparison
Date: Tue, 19 Feb 2008 17:25:52 +0100 (MET)
Message-ID: <20080219162540.13631.41530.sendpatchset@localhost.localdomain>
References: <20080219162532.13631.71318.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:50476 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753116AbYBSQZx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Feb 2008 11:25:53 -0500
In-Reply-To: <20080219162532.13631.71318.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: xt_iprange: fix subtraction-based comparison

The host address parts need to be converted to host-endian first
before arithmetic makes any sense on them.

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 5a090319a35aac1052102d97c431230d3140daf1
tree 72fb9bcb9ebf94fad277a3461288d23841f50662
parent 4e2e7aba6471fcd945a3f8fdc40d5cf11e7039b3
author Jan Engelhardt <jengelh@computergmbh.de> Tue, 19 Feb 2008 17:15:29 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 19 Feb 2008 17:15:29 +0100

 net/netfilter/xt_iprange.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/xt_iprange.c b/net/netfilter/xt_iprange.c
index 4f984dc..500528d 100644
--- a/net/netfilter/xt_iprange.c
+++ b/net/netfilter/xt_iprange.c
@@ -102,7 +102,7 @@ iprange_ipv6_sub(const struct in6_addr *a, const struct in6_addr *b)
 	int r;
 
 	for (i = 0; i < 4; ++i) {
-		r = (__force u32)a->s6_addr32[i] - (__force u32)b->s6_addr32[i];
+		r = ntohl(a->s6_addr32[i]) - ntohl(b->s6_addr32[i]);
 		if (r != 0)
 			return r;
 	}
