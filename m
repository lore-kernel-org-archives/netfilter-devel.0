From: Max Kellermann <max@duempel.org>
Subject: [PATCH 1/4] check nfct_get_attr()!=NULL
Date: Mon, 21 Jan 2008 09:29:58 +0100
Message-ID: <20080121082958.27612.50164.stgit@rabbit.intern.cm-ag>
References: <20080121082752.27612.82519.stgit@rabbit.intern.cm-ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from duempel.org ([78.31.71.42]:36432 "HELO duempel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758677AbYAUMDd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Jan 2008 07:03:33 -0500
In-Reply-To: <20080121082752.27612.82519.stgit@rabbit.intern.cm-ag>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

from time to time, conntrackd segfaults in cache.c, function hash(),
because it does not check the return value of nfct_get_attr().  For
some reason (which I have not investigated), there is no
ATTR_ORIG_IPV4_SRC.  A gdb dump of *ct after the segfault says the
following:

(gdb) p *ct
$3 =3D {tuple =3D {{src =3D {v4 =3D 4161143072, v6 =3D {in6_u =3D {u6_a=
ddr8 =3D " \001\006=C3=B8\023\205\000\001\000\000\000\000\000\000\000\0=
02",
            u6_addr16 =3D {288, 63494, 34067, 256, 0, 0, 0, 512}, u6_ad=
dr32 =3D {4161143072, 16811283, 0, 33554432}}}}, dst =3D {
        v4 =3D 4161143072, v6 =3D {in6_u =3D {u6_addr8 =3D " \001\006=C3=
=B8\023\205=C3=BF=C3=BF=C3=BF=C3=BF=C3=BF=C3=BF=C3=BF=C3=BF\000\002", u=
6_addr16 =3D {288, 63494, 34067, 65535,
              65535, 65535, 65535, 512}, u6_addr32 =3D {4161143072, 429=
4935827, 4294967295, 33619967}}}}, l3protonum =3D 10 '\n',
      protonum =3D 6 '\006', l4src =3D {all =3D 64727, tcp =3D {port =3D=
 64727}, udp =3D {port =3D 64727}, icmp =3D {type =3D 215 '=C3=97',
          code =3D 252 '=C3=BC', id =3D 0}, sctp =3D {port =3D 64727}},=
 l4dst =3D {all =3D 53767, tcp =3D {port =3D 53767}, udp =3D {port =3D =
53767},
        icmp =3D {type =3D 7 '\a', code =3D 210 '=C3=92', id =3D 0}, sc=
tp =3D {port =3D 53767}}}, {src =3D {v4 =3D 4161143072, v6 =3D {in6_u =3D=
 {
            u6_addr8 =3D " \001\006=C3=B8\023\205=C3=BF=C3=BF=C3=BF=C3=BF=
=C3=BF=C3=BF=C3=BF=C3=BF\000\002", u6_addr16 =3D {288, 63494, 34067, 65=
535, 65535, 65535, 65535, 512},
            u6_addr32 =3D {4161143072, 4294935827, 4294967295, 33619967=
}}}}, dst =3D {v4 =3D 4161143072, v6 =3D {in6_u =3D {
            u6_addr8 =3D " \001\006=C3=B8\023\205\000\001\000\000\000\0=
00\000\000\000\002", u6_addr16 =3D {288, 63494, 34067, 256, 0, 0,
              0, 512}, u6_addr32 =3D {4161143072, 16811283, 0, 33554432=
}}}}, l3protonum =3D 10 '\n', protonum =3D 6 '\006', l4src =3D {
        all =3D 53767, tcp =3D {port =3D 53767}, udp =3D {port =3D 5376=
7}, icmp =3D {type =3D 7 '\a', code =3D 210 '=C3=92', id =3D 0}, sctp =3D=
 {
          port =3D 53767}}, l4dst =3D {all =3D 64727, tcp =3D {port =3D=
 64727}, udp =3D {port =3D 64727}, icmp =3D {type =3D 215 '=C3=97',
          code =3D 252 '=C3=BC', id =3D 0}, sctp =3D {port =3D 64727}}}=
, {src =3D {v4 =3D 0, v6 =3D {in6_u =3D {u6_addr8 =3D '\0' <repeats 15 =
times>,
            u6_addr16 =3D {0, 0, 0, 0, 0, 0, 0, 0}, u6_addr32 =3D {0, 0=
, 0, 0}}}}, dst =3D {v4 =3D 0, v6 =3D {in6_u =3D {
            u6_addr8 =3D '\0' <repeats 15 times>, u6_addr16 =3D {0, 0, =
0, 0, 0, 0, 0, 0}, u6_addr32 =3D {0, 0, 0, 0}}}},
      l3protonum =3D 0 '\0', protonum =3D 0 '\0', l4src =3D {all =3D 0,=
 tcp =3D {port =3D 0}, udp =3D {port =3D 0}, icmp =3D {type =3D 0 '\0',
          code =3D 0 '\0', id =3D 0}, sctp =3D {port =3D 0}}, l4dst =3D=
 {all =3D 0, tcp =3D {port =3D 0}, udp =3D {port =3D 0}, icmp =3D {
          type =3D 0 '\0', code =3D 0 '\0', id =3D 0}, sctp =3D {port =3D=
 0}}}}, timeout =3D 120, mark =3D 0, secmark =3D 0, status =3D 8, use =3D=
 0,
  id =3D 0, protoinfo =3D {tcp =3D {state =3D 1 '\001', flags =3D {{val=
ue =3D 3 '\003', mask =3D 0 '\0'}, {value =3D 0 '\0', mask =3D 0 '\0'},=
 {
          value =3D 0 '\0', mask =3D 0 '\0'}}}}, counters =3D {{packets=
 =3D 0, bytes =3D 0}, {packets =3D 0, bytes =3D 0}, {packets =3D 0,
      bytes =3D 0}}, snat =3D {min_ip =3D 0, max_ip =3D 0, l4min =3D {a=
ll =3D 0, tcp =3D {port =3D 0}, udp =3D {port =3D 0}, icmp =3D {type =3D=
 0 '\0',
        code =3D 0 '\0', id =3D 0}, sctp =3D {port =3D 0}}, l4max =3D {=
all =3D 0, tcp =3D {port =3D 0}, udp =3D {port =3D 0}, icmp =3D {type =3D=
 0 '\0',
        code =3D 0 '\0', id =3D 0}, sctp =3D {port =3D 0}}}, dnat =3D {=
min_ip =3D 0, max_ip =3D 0, l4min =3D {all =3D 0, tcp =3D {port =3D 0},=
 udp =3D {
        port =3D 0}, icmp =3D {type =3D 0 '\0', code =3D 0 '\0', id =3D=
 0}, sctp =3D {port =3D 0}}, l4max =3D {all =3D 0, tcp =3D {port =3D 0}=
, udp =3D {
        port =3D 0}, icmp =3D {type =3D 0 '\0', code =3D 0 '\0', id =3D=
 0}, sctp =3D {port =3D 0}}}, set =3D {1019888, 31}}
---

 src/cache.c |   46 ++++++++++++++++++++++++++++++++--------------
 1 files changed, 32 insertions(+), 14 deletions(-)


diff --git a/src/cache.c b/src/cache.c
index 2f0e57a..d0fb210 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -29,17 +29,26 @@
=20
 static uint32_t hash(const void *data, struct hashtable *table)
 {
+	const void *p;
 	unsigned int a, b;
 	const struct us_conntrack *u =3D data;
 	struct nf_conntrack *ct =3D u->ct;
=20
-	a =3D jhash(nfct_get_attr(ct, ATTR_ORIG_IPV4_SRC), sizeof(uint32_t),
-		  ((nfct_get_attr_u8(ct, ATTR_ORIG_L3PROTO) << 16) |
-		   (nfct_get_attr_u8(ct, ATTR_ORIG_L4PROTO))));
-
-	b =3D jhash(nfct_get_attr(ct, ATTR_ORIG_IPV4_DST), sizeof(uint32_t),
-		  ((nfct_get_attr_u16(ct, ATTR_ORIG_PORT_SRC) << 16) |
-		   (nfct_get_attr_u16(ct, ATTR_ORIG_PORT_DST))));
+	p =3D nfct_get_attr(ct, ATTR_ORIG_IPV4_SRC);
+	if (p =3D=3D NULL)
+		a =3D 0;
+	else
+		a =3D jhash(p, sizeof(uint32_t),
+			  ((nfct_get_attr_u8(ct, ATTR_ORIG_L3PROTO) << 16) |
+			   (nfct_get_attr_u8(ct, ATTR_ORIG_L4PROTO))));
+
+	p =3D nfct_get_attr(ct, ATTR_ORIG_IPV4_DST);
+	if (p =3D=3D NULL)
+		b =3D 0;
+	else
+		b =3D jhash(p, sizeof(uint32_t),
+			  ((nfct_get_attr_u16(ct, ATTR_ORIG_PORT_SRC) << 16) |
+			   (nfct_get_attr_u16(ct, ATTR_ORIG_PORT_DST))));
=20
 	/*
 	 * Instead of returning hash % table->hashsize (implying a divide)
@@ -53,17 +62,26 @@ static uint32_t hash(const void *data, struct hasht=
able *table)
=20
 static uint32_t hash6(const void *data, struct hashtable *table)
 {
+	const void *p;
 	unsigned int a, b;
 	const struct us_conntrack *u =3D data;
 	struct nf_conntrack *ct =3D u->ct;
=20
-	a =3D jhash(nfct_get_attr(ct, ATTR_ORIG_IPV6_SRC), sizeof(uint32_t)*4=
,
-		  ((nfct_get_attr_u8(ct, ATTR_ORIG_L3PROTO) << 16) |
-		   (nfct_get_attr_u8(ct, ATTR_ORIG_L4PROTO))));
-
-	b =3D jhash(nfct_get_attr(ct, ATTR_ORIG_IPV6_DST), sizeof(uint32_t)*4=
,
-		  ((nfct_get_attr_u16(ct, ATTR_ORIG_PORT_SRC) << 16) |
-		   (nfct_get_attr_u16(ct, ATTR_ORIG_PORT_DST))));
+	p =3D nfct_get_attr(ct, ATTR_ORIG_IPV6_SRC);
+	if (p =3D=3D NULL)
+		a =3D 0;
+	else
+		a =3D jhash(p, sizeof(uint32_t)*4,
+			  ((nfct_get_attr_u8(ct, ATTR_ORIG_L3PROTO) << 16) |
+			   (nfct_get_attr_u8(ct, ATTR_ORIG_L4PROTO))));
+
+	p =3D nfct_get_attr(ct, ATTR_ORIG_IPV6_DST);
+	if (p =3D=3D NULL)
+		b =3D 0;
+	else
+		b =3D jhash(nfct_get_attr(ct, ATTR_ORIG_IPV6_DST), sizeof(uint32_t)*=
4,
+			  ((nfct_get_attr_u16(ct, ATTR_ORIG_PORT_SRC) << 16) |
+			   (nfct_get_attr_u16(ct, ATTR_ORIG_PORT_DST))));
=20
 	return ((uint64_t)jhash_2words(a, b, 0) * table->hashsize) >> 32;
 }


-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
