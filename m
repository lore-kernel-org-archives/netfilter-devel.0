From: Krzysztof Oledzki <olenf@ans.pl>
Subject: Re: [PATCH] CTA_PROTO_NUM is u_int8_t not u_int16_t (was Re:
 CTA_PROTO_NUM u_int8_t or u_int16_t)
Date: Fri, 25 Nov 2005 00:24:07 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0511242307080.10778@bizon.gios.gov.pl>
References: <4381FDF8.6030508@trash.net> <43820874.2050708@eurodev.net>
	<4382A19D.9090201@trash.net> <43836BAF.2050501@eurodev.net>
	<Pine.LNX.4.64.0511222103050.9114@bizon.gios.gov.pl>
	<20051122220606.GC31478@sunbeam.de.gnumonks.org>
	<4383C2C9.8050109@eurodev.net> <43843ACE.4050808@trash.net>
	<Pine.LNX.4.64.0511231128510.9162@bizon.gios.gov.pl>
	<20051124200736.GW31478@sunbeam.de.gnumonks.org>
	<20051124202125.GX31478@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-304972283-1132874647=:10778"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Pablo Neira <pablo@eurodev.net>, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20051124202125.GX31478@sunbeam.de.gnumonks.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-304972283-1132874647=:10778
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Thu, 24 Nov 2005, Harald Welte wrote:

> Sorry, forget that other patch.
>
> The only way how we can thoroughly solve (and avoid) this problem, also
> for future cases, is to behave like 'real' TLV parsers (e.g. ASN1).
>
> That is, for any kind of numeric values, we don't make an assumption
> that the attribute has a certain fixed size.  Instead, we derive the
> (u8/u16/u32/u64) size from the length of the attribute, i.e.
> NFA_PAYLOAD() is 1/2/4/8 bytes long.
>
> This is a quick and dirty patch to demonstrate what I mean:
>
> =3D=3D=3D=3D=3D
>
> diff --git a/net/ipv4/netfilter/ip_conntrack_netlink.c b/net/ipv4/netfilt=
er/ip_conntrack_netlink.c
> --- a/net/ipv4/netfilter/ip_conntrack_netlink.c
> +++ b/net/ipv4/netfilter/ip_conntrack_netlink.c
> @@ -502,12 +502,13 @@ ctnetlink_parse_tuple_ip(struct nfattr *
> }
>
> static const size_t cta_min_proto[CTA_PROTO_MAX] =3D {
> -=09[CTA_PROTO_NUM-1]=09=3D sizeof(u_int16_t),
> +=09[CTA_PROTO_NUM-1]=09=3D sizeof(u_int8_t),
> =09[CTA_PROTO_SRC_PORT-1]=09=3D sizeof(u_int16_t),
> =09[CTA_PROTO_DST_PORT-1]=09=3D sizeof(u_int16_t),
> =09[CTA_PROTO_ICMP_TYPE-1]=09=3D sizeof(u_int8_t),
> =09[CTA_PROTO_ICMP_CODE-1]=09=3D sizeof(u_int8_t),
> =09[CTA_PROTO_ICMP_ID-1]=09=3D sizeof(u_int16_t),
> +=09[CTA_PROTO-1]=09=09=3D sizeof(u_int8_t),
> };

Why we need to add CTA_PROTO here?

> static inline int
> @@ -527,7 +528,18 @@ ctnetlink_parse_tuple_proto(struct nfatt
>
> =09if (!tb[CTA_PROTO_NUM-1])
> =09=09return -EINVAL;
> -=09tuple->dst.protonum =3D *(u_int16_t *)NFA_DATA(tb[CTA_PROTO_NUM-1]);
> +
> +=09switch (NFA_PAYLOAD(tb[CTA_PROTO_NUM-1]))
> +=09case sizeof(u_int8_t):
> +=09=09tuple->dst.protonum =3D
> +=09=09=09=09*(u_int8_t *)NFA_DATA(tb[CTA_PROTO_NUM-1]);
> +=09=09break;
> +=09case sizeof(u_int16_t):
> +=09=09tuple->dst.protonum =3D
> +=09=09=09=09*(u_int16_t *)NFA_DATA(tb[CTA_PROTO_NUM-1]);
> +=09default:
> +=09=09return -EINVAL;
> +=09}

Nice, nice... ;)

> Obviously, this needs to be moved into a nfnetlink core funciton,
> something like a function nfattr_parse_number() that would then be
> called from all places that parse a number.
>
> Userspace parsers (libnetfilter_conntrack) would have to introduce the
> same semantics.

Old userspace applications always send u_int16_t. New applications still=20
need to send CTA_PROTO_NUM as u_int16_t for 2.6.14 but u_int8_t for=20
2.6.15+ kernels. I'm not sure if we can provide that without checking=20
current kernel version. Hopefully, when reading messages from kernel,=20
userspace expects CTA_PROTO_NUM to be u_int8_t and this is what kernel=20
sends currently.

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-304972283-1132874647=:10778--
