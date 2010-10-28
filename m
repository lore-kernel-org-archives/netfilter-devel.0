From: David Miller <davem@davemloft.net>
Subject: Re: tproxy: added IPv6 support to the socket match
Date: Thu, 28 Oct 2010 13:00:25 -0700 (PDT)
Message-ID: <20101028.130025.102564000.davem@davemloft.net>
References: <201010231923.o9NJNK9U013494@hera.kernel.org>
	<AANLkTi=KRAcoonwFHKNaptap2LQHDswRCGpect82aHzx@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: bazsi@balabit.hu, hidden@balabit.hu, kaber@trash.net,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	netfilter-devel@vger.kernel.org
To: geert@linux-m68k.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37658
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760948Ab0J1UAC convert rfc822-to-8bit
	(ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Oct 2010 16:00:02 -0400
In-Reply-To: <AANLkTi=KRAcoonwFHKNaptap2LQHDswRCGpect82aHzx@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Thu, 28 Oct 2010 20:51:43 +0200

>> + =A0 =A0 =A0 u8 tproto;
>=20
> tproto is unsigned...
>=20
>> + =A0 =A0 =A0 const struct xt_socket_mtinfo1 *info =3D (struct xt_so=
cket_mtinfo1 *) par->matchinfo;
>> +
>> + =A0 =A0 =A0 tproto =3D ipv6_find_hdr(skb, &thoff, -1, NULL);
>=20
> but ipv6_find_hdr() returns int, and negative values for errors...

Thanks Geert, I'll fix it like so:

--------------------
netfilter: xt_socket: Make tproto signed in socket_mt6_v1().

Otherwise error indications from ipv6_find_hdr() won't be noticed.

This required making the protocol argument to extract_icmp6_fields()
signed too.

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 net/netfilter/xt_socket.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/xt_socket.c b/net/netfilter/xt_socket.c
index d94a858..00d6ae8 100644
--- a/net/netfilter/xt_socket.c
+++ b/net/netfilter/xt_socket.c
@@ -195,7 +195,7 @@ socket_mt4_v1(const struct sk_buff *skb, struct xt_=
action_param *par)
 static int
 extract_icmp6_fields(const struct sk_buff *skb,
 		     unsigned int outside_hdrlen,
-		     u8 *protocol,
+		     int *protocol,
 		     struct in6_addr **raddr,
 		     struct in6_addr **laddr,
 		     __be16 *rport,
@@ -252,8 +252,7 @@ socket_mt6_v1(const struct sk_buff *skb, struct xt_=
action_param *par)
 	struct sock *sk;
 	struct in6_addr *daddr, *saddr;
 	__be16 dport, sport;
-	int thoff;
-	u8 tproto;
+	int thoff, tproto;
 	const struct xt_socket_mtinfo1 *info =3D (struct xt_socket_mtinfo1 *)=
 par->matchinfo;
=20
 	tproto =3D ipv6_find_hdr(skb, &thoff, -1, NULL);
@@ -305,7 +304,7 @@ socket_mt6_v1(const struct sk_buff *skb, struct xt_=
action_param *par)
 			sk =3D NULL;
 	}
=20
-	pr_debug("proto %hhu %pI6:%hu -> %pI6:%hu "
+	pr_debug("proto %hhd %pI6:%hu -> %pI6:%hu "
 		 "(orig %pI6:%hu) sock %p\n",
 		 tproto, saddr, ntohs(sport),
 		 daddr, ntohs(dport),
--=20
1.7.3.2

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
