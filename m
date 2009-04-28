From: Julius Volz <julius.volz@gmail.com>
Subject: Re: [bug] FWMARKs and persistence in IPVS: The Use of Unions
Date: Tue, 28 Apr 2009 13:59:22 +0200
Message-ID: <43ca39800904280459r7e63c2a4q9416d735a399233d@mail.gmail.com>
References: <20090428081509.GA746@verge.net.au>
	 <alpine.LSU.2.00.0904281103250.27149@fbirervta.pbzchgretzou.qr>
	 <20090428092351.GC8165@verge.net.au>
	 <20090428105941.GA20907@verge.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Engelhardt <jengelh@medozas.de>,
	netfilter-devel <netfilter-devel@vger.kernel.org>,
	lvs-devel@vger.kernel.org,
	=?ISO-8859-1?Q?Fabien_Duch=EAne?=
	<fabien.duchene@student.uclouvain.be>,
	Joseph Mack NA3T <jmack@wm7d.net>
To: Simon Horman <horms@verge.net.au>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:42831 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756093AbZD1L7Y convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 28 Apr 2009 07:59:24 -0400
In-Reply-To: <20090428105941.GA20907@verge.net.au>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Apr 28, 2009 at 12:59 PM, Simon Horman <horms@verge.net.au> wro=
te:
> On Tue, Apr 28, 2009 at 07:23:55PM +1000, Simon Horman wrote:
>> On Tue, Apr 28, 2009 at 11:07:40AM +0200, Jan Engelhardt wrote:
>> >
>> > On Tuesday 2009-04-28 10:15, Simon Horman wrote:
>> > >
>> > >It seems to me that it should be easy enough to fix by changing
>> > >fwmark in ip_vs_sched_persist() from:
>> > >
>> > >union nf_inet_addr fwmark =3D {
>> > > =A0 .all =3D { 0, 0, 0, htonl(svc->fwmark) }
>> > >};
>> > >
>> > >to:
>> > >
>> > >union nf_inet_addr fwmark =3D {
>> > > =A0 .all =3D { htonl(svc->fwmark), 0, 0, 0 }
>> > >};
>> > >
>> > >Assuming that this would result in fwmark->ip being set to
>> > >htonl(svc->fwmark), which is relevant if svc->af is AF_INET - tha=
t is,
>> > >for IPv4.[...]
>> > >An alternate idea would be to change the af value used for fwmark=
s,
>> > >but this seems to be even less clean than the current (slightly b=
roken)
>> > >technique of using nf_inet_addr for IPv4 or IPv6 addresses, or fw=
marks.
>> >
>> > If you use ->all, then using NFPROTO_UNSPEC as af
>> > seems to me like a good match.
>
> I am guessing that AF_UNSPEC is more appropriate than NFPROTO_UNSPEC.
> Please correct me if I am wrong.
>
>> That seems reasonable, though ip_vs_ct_in_get() would still
>> need to use the real af for the cp->af =3D=3D af and
>> ip_vs_addr_equal(af, s_addr, &cp->caddr) portinos of the check.
>
> It looks like checking for proto =3D=3D IPPROTO_IP can tell us if
> the destination is a fwmark. This is based on the assumption that
> iph.protocol can never be IPPROTO_IP in ip_vs_sched_persist().
>
> The following patch expresses these ideas as they crrently stand.
> Fabien, is it possible for you to test this?
>
> Index: net-next-2.6/net/netfilter/ipvs/ip_vs_conn.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- net-next-2.6.orig/net/netfilter/ipvs/ip_vs_conn.c =A0 2009-04-28 =
20:37:48.000000000 +1000
> +++ net-next-2.6/net/netfilter/ipvs/ip_vs_conn.c =A0 =A0 =A0 =A02009-=
04-28 20:37:51.000000000 +1000
> @@ -260,7 +260,10 @@ struct ip_vs_conn *ip_vs_ct_in_get
> =A0 =A0 =A0 =A0list_for_each_entry(cp, &ip_vs_conn_tab[hash], c_list)=
 {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (cp->af =3D=3D af &&
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ip_vs_addr_equal(af, s_addr, &=
cp->caddr) &&
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ip_vs_addr_equal(af, d_addr, &c=
p->vaddr) &&
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* protocol should only be IPPR=
OTO_IP if
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* d_addr is a fwmark */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ip_vs_addr_equal(protocol =3D=3D=
 IPPROTO_IP ? AF_UNSPEC : af,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0d_addr, &cp->vaddr) &&
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0s_port =3D=3D cp->cport && d_p=
ort =3D=3D cp->vport &&
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cp->flags & IP_VS_CONN_F_TEMPL=
ATE &&
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0protocol =3D=3D cp->protocol) =
{
> @@ -698,7 +701,9 @@ ip_vs_conn_new(int af, int proto, const
> =A0 =A0 =A0 =A0cp->cport =A0 =A0 =A0 =A0 =A0=3D cport;
> =A0 =A0 =A0 =A0ip_vs_addr_copy(af, &cp->vaddr, vaddr);
> =A0 =A0 =A0 =A0cp->vport =A0 =A0 =A0 =A0 =A0=3D vport;
> - =A0 =A0 =A0 ip_vs_addr_copy(af, &cp->daddr, daddr);
> + =A0 =A0 =A0 /* proto should only be IPPROTO_IP if d_addr is a fwmar=
k */
> + =A0 =A0 =A0 ip_vs_addr_copy(proto =3D=3D IPPROTO_IP ? AF_UNSPEC : a=
f,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &cp->daddr, daddr);
> =A0 =A0 =A0 =A0cp->dport =A0 =A0 =A0 =A0 =A0=3D dport;
> =A0 =A0 =A0 =A0cp->flags =A0 =A0 =A0 =A0 =A0=3D flags;
> =A0 =A0 =A0 =A0spin_lock_init(&cp->lock);
> Index: net-next-2.6/net/netfilter/ipvs/ip_vs_core.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- net-next-2.6.orig/net/netfilter/ipvs/ip_vs_core.c =A0 2009-04-28 =
20:37:48.000000000 +1000
> +++ net-next-2.6/net/netfilter/ipvs/ip_vs_core.c =A0 =A0 =A0 =A02009-=
04-28 20:37:51.000000000 +1000
> @@ -278,7 +278,7 @@ ip_vs_sched_persist(struct ip_vs_service
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (svc->fwmark) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0union nf_inet_addr fwm=
ark =3D {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 .all =3D=
 { 0, 0, 0, htonl(svc->fwmark) }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 .ip =3D=
 htonl(svc->fwmark)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0};
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ct =3D ip_vs_ct_in_get=
(svc->af, IPPROTO_IP, &snet, 0,
> @@ -306,7 +306,7 @@ ip_vs_sched_persist(struct ip_vs_service
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (svc->fwmark) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0union =
nf_inet_addr fwmark =3D {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 .all =3D { 0, 0, 0, htonl(svc->fwmark) }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 .ip =3D htonl(svc->fwmark)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0};
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ct =3D=
 ip_vs_conn_new(svc->af, IPPROTO_IP,

Looks good to me, without being able to test it now.

I earlier mentioned also changing __ip_vs_conn_in_get(), but now
realized that the problem exists only during connection template
lookup, not for regular connections.

Julius
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
