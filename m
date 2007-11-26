From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: NF [PATCH 2/6] Constify include/net/dsfield.h
Date: Tue, 27 Nov 2007 00:42:40 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0711270042170.22369@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0711270041320.22369@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:49977 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755584AbXKZXml (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 26 Nov 2007 18:42:41 -0500
In-Reply-To: <Pine.LNX.4.64.0711270041320.22369@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


Constify include/net/dsfield.h

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

---
 include/net/dsfield.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6/include/net/dsfield.h
===================================================================
--- linux-2.6.orig/include/net/dsfield.h
+++ linux-2.6/include/net/dsfield.h
@@ -12,15 +12,15 @@
 #include <asm/byteorder.h>
 
 
-static inline __u8 ipv4_get_dsfield(struct iphdr *iph)
+static inline __u8 ipv4_get_dsfield(const struct iphdr *iph)
 {
 	return iph->tos;
 }
 
 
-static inline __u8 ipv6_get_dsfield(struct ipv6hdr *ipv6h)
+static inline __u8 ipv6_get_dsfield(const struct ipv6hdr *ipv6h)
 {
-	return ntohs(*(__be16 *) ipv6h) >> 4;
+	return ntohs(*(const __be16 *)ipv6h) >> 4;
 }
 
 
