From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: (usagi-core 34062) fix for eui64 match
Date: Wed, 26 Dec 2007 17:28:50 +0900 (JST)
Message-ID: <200712260828.lBQ8SpsL021477@toshiba.co.jp>
References: <20071218120129.GA24999@gympos.sk>
	<20071218.210758.109634807.yoshfuji@linux-ipv6.org>
	<20071218132607.GA20613@gympos.sk>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
 boundary="--Next_Part(Wed_Dec_26_17_28_50_2007_282)--"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Peter.Ivancik@gympos.sk, kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from imx9.toshiba.co.jp ([202.33.96.51]:55957 "EHLO
	imx9.toshiba.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353AbXLZI66 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Dec 2007 03:58:58 -0500
Received: from inet-tsb5.toshiba.co.jp (inet-tsb5 [202.33.96.24])
	by imx9.toshiba.co.jp  with ESMTP id lBQ8wuIo016219
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <netfilter-devel@vger.kernel.org>; Wed, 26 Dec 2007 17:58:56 +0900 (JST)
Received: from arc1.toshiba.co.jp ([133.199.194.235])
	by inet-tsb5.toshiba.co.jp  with ESMTP id lBQ8SvGX027343
	for <netfilter-devel@vger.kernel.org>; Wed, 26 Dec 2007 17:28:57 +0900 (JST)
Received: (from root@localhost)
	by arc1.toshiba.co.jp  id lBQ8SvMC025761
	for netfilter-devel@vger.kernel.org; Wed, 26 Dec 2007 17:28:57 +0900 (JST)
Received: from mx2.toshiba.co.jp (localhost [127.0.0.1])
	by ovp2.toshiba.co.jp  with ESMTP id lBQ8Sujg022512
	for <netfilter-devel@vger.kernel.org>; Wed, 26 Dec 2007 17:28:56 +0900 (JST)
In-Reply-To: <20071218132607.GA20613@gympos.sk>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

----Next_Part(Wed_Dec_26_17_28_50_2007_282)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


# Sorry, I forgot replacing list address, so I resend

Hi,

Thanks for a patch. But the patch could not be applied because all tabs are
replaced with spaces. I've fixed them for 2.6 and 2.4 tree.

Patrick, please apply the attached patches (the first for linux-2.6 tree
at a few hours ago, the later is for 2.4).

BTW, Peter, netfilter-devel list was moved to
	netfilter-devel@vger.kernel.org

Please subscribe and send messages to it next time.

Regards,

-- Yasuyuki Kozakai

From: Peter Ivancik <Peter.Ivancik@gympos.sk>
Date: Tue, 18 Dec 2007 14:26:07 +0100

> Sorry, my stupid mistake. Here's correct version:
> 
> ####################################################################################
> diff -u net/ipv6/netfilter/ip6t_eui64.c.orig net/ipv6/netfilter/ip6t_eui64.c
> --- net/ipv6/netfilter/ip6t_eui64.c.orig        2007-12-18 12:47:00.000000000 +0100
> +++ net/ipv6/netfilter/ip6t_eui64.c     2007-12-18 10:38:23.000000000 +0100
> @@ -47,7 +47,7 @@
>                         memcpy(eui64 + 5, eth_hdr(skb)->h_source + 3, 3);
>                         eui64[3] = 0xff;
>                         eui64[4] = 0xfe;
> -                       eui64[0] |= 0x02;
> +                       eui64[0] ^= 0x02;
> 
>                         i = 0;
>                         while (ipv6_hdr(skb)->saddr.s6_addr[8 + i] == eui64[i]
> ####################################################################################
> 
> 	Peter
>
> On Tue, Dec 18, 2007 at 09:07:58PM +0900, YOSHIFUJI Hideaki / ?$B5HF#1QL@ wrote:
> > In article <20071218120129.GA24999@gympos.sk> (at Tue, 18 Dec 2007 13:01:29 +0100), Peter Ivancik <Peter.Ivancik@gympos.sk> says:
> > 
> > > I send you (after 3 years:) another report&fix for eui64 ip6tables module in
> > > linux kernel. There's mistake while testing complement
> > > of second least bit in firt byte. There must be
> > > XOR operation (RFC 2464 - paragraph 4.). So, now in code is line 
> > > "eui64[0] |= 0x02;" 
> > > and correct is 
> > > "eui64[0] ^= 0x02;"
> > > of linux/net/ipv6/netfilter/ip6t_eui64.c source file.
> > > 
> > > I hope it's correct. If yes, fix this problem in
> > > the next patch please.
> > 
> > Yup.
> > 
> > > --
> > > diff -u net/ipv6/netfilter/ip6t_eui64.c net/ipv6/netfilter/ip6t_eui64.c.orig
> > > 
> > > --- net/ipv6/netfilter/ip6t_eui64.c     2007-12-18 10:38:23.000000000 +0100
> > > +++ net/ipv6/netfilter/ip6t_eui64.c.orig 2007-12-18 12:47:00.000000000 +0100
> > 
> > > 			eui64[4] = 0xfe;
> > > -                       eui64[0] ^= 0x02;
> > > +			eui64[0] |= 0x02;
> > > 
> > 
> > Please send us forward patch (not reverse patch).
> > Please do not convert tabs into spaces.
> > 
> > Regards,
> > 
> > --yoshfuji

----Next_Part(Wed_Dec_26_17_28_50_2007_282)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="0001-v2.6-NETFILTER-ip6t_eui64-Fixes-calculation-of-Univer.patch"

>From 9a58ccbfd268f509d56b201fb2b5f7f9c4a9040d Mon Sep 17 00:00:00 2001
From: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Date: Wed, 26 Dec 2007 15:57:39 +0900
Subject: [NETFILTER]: ip6t_eui64: Fixes calculation of Universal/Local bit

RFC2464 says that the next to lowerst order bit of the first octet
of the Interface Identifier is formed by complementing
the Universal/Local bit of the EUI-64. But ip6t_eui64 uses OR not XOR.

Thanks Peter Ivancik for reporing this bug and posting a patch
for it.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
---
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
-- 
1.5.3.6


----Next_Part(Wed_Dec_26_17_28_50_2007_282)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="0001-v2.4-NETFILTER-ip6t_eui64-Fixes-calculation-of-Univer.patch"

>From acb6e566b07c8f8494ca2f66c1d56d92ed6876bc Mon Sep 17 00:00:00 2001
From: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Date: Wed, 26 Dec 2007 16:05:44 +0900
Subject: [NETFILTER]: ip6t_eui64: Fixes calculation of Universal/Local bit

RFC2464 says that the next to lowerst order bit of the first octet
of the Interface Identifier is formed by complementing
the Universal/Local bit of the EUI-64. But ip6t_eui64 uses OR not XOR.

Thanks Peter Ivancik for reporing this bug and posting a patch
for it.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
---
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
-- 
1.5.3.6


----Next_Part(Wed_Dec_26_17_28_50_2007_282)----
