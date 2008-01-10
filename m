From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 2.4]: ip6t_eui64: Fixes calculation of Universal/Local
 bit
Date: Thu, 10 Jan 2008 16:47:09 +0100
Message-ID: <47863DFD.4090903@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080708070402030109060004"
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: "David S. Miller" <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57638 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756024AbYAJPve (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Jan 2008 10:51:34 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080708070402030109060004
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit


--------------080708070402030109060004
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
commit b7be830f3cd1887102daff6291b98a12fbab610c
tree 2968b26348984dbfa1ad6ad0885c226789b99943
parent f8c88465924895f1fead9ef0602baf6e13f940ae
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Wed, 26 Dec 2007 16:05:44 +0900
committer Patrick McHardy <kaber@trash.net> Fri, 28 Dec 2007 16:37:40 +0100

 net/ipv6/netfilter/ip6t_eui64.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/ipv6/netfilter/ip6t_eui64.c b/net/ipv6/netfilter/ip6t_eui64.c
index 5f91a5b..32dee34 100644
--- a/net/ipv6/netfilter/ip6t_eui64.c
+++ b/net/ipv6/netfilter/ip6t_eui64.c
@@ -35,7 +35,7 @@ match(const struct sk_buff *skb,
          memcpy(eui64 + 5, skb->mac.ethernet->h_source + 3, 3);
 	 eui64[3]=0xff;
 	 eui64[4]=0xfe;
-	 eui64[0] |= 0x02;
+	 eui64[0] ^= 0x02;
 
 	 i=0;
 	 while ((skb->nh.ipv6h->saddr.in6_u.u6_addr8[8+i] ==

--------------080708070402030109060004--
