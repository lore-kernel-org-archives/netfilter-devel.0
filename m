From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: iptables-1.4.1: ip6tables -L prints network mask instead of
 prefix length
Date: Tue, 10 Jun 2008 14:06:08 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0806101405300.20733@fbirervta.pbzchgretzou.qr>
References: <slrng4sqhq.6hn.petr.pisar@album.ics.muni.cz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Petr Pisar <petr.pisar@atlas.cz>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:49839 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376AbYFJMGK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Jun 2008 08:06:10 -0400
In-Reply-To: <slrng4sqhq.6hn.petr.pisar@album.ics.muni.cz>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2008-06-10 13:49, Petr Pisar wrote:
>Hello,
>
>I found regression between iptables 1.4.0 and 1.4.1-rc1 (also in
>1.4.1). The "ip6tables -nL" prints source and destination addresses in
>NETWORK/NETMASK instead of NETWORK/PREFIXLEN as used in iptables 1.4.0.
>
>This doesn't happen if the PREFIXLEN is 0 (i.e. ::/0).

(It does not happen if PREFIXLEN is a multiple of 32.)
Fix below.

commit f52d74a1a83c4fa30fcab8b318d325bb3c9b5535
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Tue Jun 10 14:05:21 2008 +0200

ip6tables: fix printing of ipv6 network masks
    
Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 xtables.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/xtables.c b/xtables.c
index 8241687..a97bdaa 100644
--- a/xtables.c
+++ b/xtables.c
@@ -1011,10 +1011,10 @@ static int ip6addr_prefix_length(const struct in6_addr *k)
 	unsigned int bits = 0;
 	uint32_t a, b, c, d;
 
-	a = k->s6_addr32[0];
-	b = k->s6_addr32[1];
-	c = k->s6_addr32[2];
-	d = k->s6_addr32[3];
+	a = ntohl(k->s6_addr32[0]);
+	b = ntohl(k->s6_addr32[1]);
+	c = ntohl(k->s6_addr32[2]);
+	d = ntohl(k->s6_addr32[3]);
 	while (a & 0x80000000U) {
 		++bits;
 		a <<= 1;
