From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER try 2]: ip6t_eui64: Fixes calculation of Universal/Local
 bit
Date: Thu, 10 Jan 2008 17:34:23 +0100
Message-ID: <4786490F.5090001@trash.net>
References: <47863DA1.8090907@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090001000009090603030802"
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: "David S. Miller" <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58772 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757682AbYAJQis (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Jan 2008 11:38:48 -0500
In-Reply-To: <47863DA1.8090907@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090001000009090603030802
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit



--------------090001000009090603030802
Content-Type: text/x-patch;
 name="01.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="01.diff"

[NETFILTER]: ip6t_eui64: Fixes calculation of Universal/Local bit

RFC2464 says that the next to lowerst order bit of the first octet
of the Interface Identifier is formed by complementing
the Universal/Local bit of the EUI-64. But ip6t_eui64 uses OR not XOR.

Thanks Peter Ivancik for reporing this bug and posting a patch
for it.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 7bd5c38839308e24911fffa749b3e53391c7de14
tree ad132f231a7a65312af368dc608714b5e595bc22
parent fd0b45dfd1858c6b49d06355a460bcf36d654c06
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Wed, 26 Dec 2007 15:57:39 +0900
committer Patrick McHardy <kaber@trash.net> Thu, 10 Jan 2008 16:44:14 +0100

 net/ipv6/netfilter/ip6t_eui64.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/ipv6/netfilter/ip6t_eui64.c b/net/ipv6/netfilter/ip6t_eui64.c
index 34ba150..41df9a5 100644
--- a/net/ipv6/netfilter/ip6t_eui64.c
+++ b/net/ipv6/netfilter/ip6t_eui64.c
@@ -47,7 +47,7 @@ match(const struct sk_buff *skb,
 			memcpy(eui64 + 5, eth_hdr(skb)->h_source + 3, 3);
 			eui64[3] = 0xff;
 			eui64[4] = 0xfe;
-			eui64[0] |= 0x02;
+			eui64[0] ^= 0x02;
 
 			i = 0;
 			while (ipv6_hdr(skb)->saddr.s6_addr[8 + i] == eui64[i]

--------------090001000009090603030802--
