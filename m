From: Paul Guo <ggang@tilera.com>
Subject: Re: [PATCH] possible unaligned packet header caused by ip_route_me_harder()->pskb_expand_head()
Date: Mon, 14 Nov 2011 19:00:54 +0800
Message-ID: <4EC0F4E6.50103@tilera.com>
References: <4EB9449D.8020701@tilera.com>  <1320771494.3444.8.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>  <4EBA48F3.8040906@tilera.com>  <1320832102.2315.10.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>  <4EBB7E3C.9030402@tilera.com> <20111113170233.GA16851@1984>  <4EC0D254.7060503@tilera.com> <1321264000.2272.0.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	<netfilter-devel@vger.kernel.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from usmamail.tilera.com ([206.83.70.75]:56941 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754448Ab1KNLBS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Nov 2011 06:01:18 -0500
In-Reply-To: <1321264000.2272.0.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> Le lundi 14 novembre 2011 =C3=A0 16:33 +0800, Paul Guo a =C3=A9crit :
>>> git://1984.lsi.us.es/net/.git
>>
>> OK. Here is the patch based on above git tree.
>>
>>
>> Signed-off-by: Paul Guo <ggang@tilera.com>
>> ---
>>  net/ipv4/netfilter.c |    3 ++-
>>  1 files changed, 2 insertions(+), 1 deletions(-)
>>
>> diff --git a/net/ipv4/netfilter.c b/net/ipv4/netfilter.c
>> index 929b27b..0dcb0fa 100644
>> --- a/net/ipv4/netfilter.c
>> +++ b/net/ipv4/netfilter.c
>> @@ -63,7 +63,8 @@ int ip_route_me_harder(struct sk_buff *skb, unsign=
ed addr_type)
>>  	/* Change in oif may mean change in hh_len. */
>>  	hh_len =3D skb_dst(skb)->dev->hard_header_len;
>>  	if (skb_headroom(skb) < hh_len &&
>> -	    pskb_expand_head(skb, hh_len - skb_headroom(skb), 0, GFP_ATOMI=
C))
>> +	    pskb_expand_head(skb, HH_DATA_ALIGN(hh_len - skb_headroom(skb)=
),
>> +	    		     0, GFP_ATOMIC))
>>  		return -1;
>> =20
>>  	return 0;
>=20
> OK, but could you please add a changelog as well ?
>=20
> Your initial message contained a lot of useful information that could
> help future bug hunting ;)

Sure.=20

This patch tries to fix the following issue in netfilter:
ip_route_me_harder()->pskb_expand_head() rellocates new header with
additional head room which can break the alignment of the original
packet header.

In one of my NAT test case, the NIC port for internal hosts is
configured with vlan and the port for external hosts is with
general configuration. If we ping an external "unknown" hosts from an
internal host, an icmp packet will be sent. We find that in
icmp_send()->...->ip_route_me_harder()->pskb_expand_head(), hh_len=3D18
and current headroom (skb_headroom(skb)) of the packet is 16. After
calling pskb_expand_head() the packet header becomes to be unaligned
and then our system (arch/tile) panics immediately.

Here is the patch:

Signed-off-by: Paul Guo <ggang@tilera.com>
---
 net/ipv4/netfilter.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/ipv4/netfilter.c b/net/ipv4/netfilter.c
index 929b27b..0dcb0fa 100644
--- a/net/ipv4/netfilter.c
+++ b/net/ipv4/netfilter.c
@@ -63,7 +63,8 @@ int ip_route_me_harder(struct sk_buff *skb, unsigned =
addr_type)
 	/* Change in oif may mean change in hh_len. */
 	hh_len =3D skb_dst(skb)->dev->hard_header_len;
 	if (skb_headroom(skb) < hh_len &&
-	    pskb_expand_head(skb, hh_len - skb_headroom(skb), 0, GFP_ATOMIC))
+	    pskb_expand_head(skb, HH_DATA_ALIGN(hh_len - skb_headroom(skb)),
+	    		     0, GFP_ATOMIC))
 		return -1;
=20
 	return 0;
--=20
1.6.5.2
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
