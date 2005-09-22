From: "Heyman, Michael" <Michael.Heyman@sparta.com>
Subject: RE: (no subject)
Date: Thu, 22 Sep 2005 10:05:21 -0400
Message-ID: <87CDEF0BA329934CB1B2A156A90BBF1205BEA2@coyote.columbia.ads.sparta.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-class: urn:content-classes:message
To: <netfilter-devel@lists.netfilter.org>
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

> From: Henrik Nordstrom [mailto:hno@marasystems.com]=20
> Sent: Thursday, September 22, 2005 4:01 AM
>=20
> > I found what apears to be a bug in the=20
> > "net/ipv4/netfilter/ip_tables.c" code. The issue=20
> > arose when I had a mangle table target that could=20
> > return NF_STOLEN. The ipt_do_table() routine uses=20
> > the contents of the sk_buff to calculate "datalen"=20
> > even though the sk_buff, upon return from the=20
> > "target()" call with NF_STOLEN, should be assumed=20
> > invalid (in my case, I had set the returned=20
> > sk_buff to NULL).
> >
> > --- foo.c	2005-09-21 07:00:35.000000000 -0400
> > +++ net/ipv4/netfilter/ip_tables.c	2005-06-17 15:48:29.000000000
> > -0400
> > @@ -378,15 +378,16 @@
> > 				((struct ipt_entry
> > *)table_base)->comefrom
> > 					=3D 0x57acc001;
> > #endif
> > -				/* Target might have changed stuff. */
> > -				ip =3D (*pskb)->nh.iph;
> > -				datalen =3D (*pskb)->len - ip->ihl * 4;
> > -
> > 				if (verdict =3D=3D IPT_CONTINUE)
> > 					e =3D (void *)e + e->next_offset;
> > 				else
> > 					/* Verdict */
> > 					break;
> > +
> > +				/* Target might have changed stuff. */
> > +				ip =3D (*pskb)->nh.iph;
> > +				datalen =3D (*pskb)->len - ip->ihl * 4;
> > +
>=20
>=20
> This patch on the other hand fails in the perhaps more common=20
> situation where a target mangles the payload and returns NF_ACCEPT.
>=20
Again, I haven't tested it but I also didn't see where "ip" or "datalen"
were used in the case where the target did not return IPT_CONTINUE.

-Michael Heyman
