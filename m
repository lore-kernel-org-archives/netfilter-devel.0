From: Laura Garcia <nevola@gmail.com>
Subject: Re: [PATCH v2] extensions: libxt_multiport: Add translation to nft
Date: Tue, 31 May 2016 09:22:41 +0200
Message-ID: <20160531072239.GA26590@sonyv>
References: <20160530194748.GA25328@sonyv>
 <CAOkSjBgKZyr-GJLWwASNoLOftJbQu5boiTpMOfNsj7YCktYGxw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:33776 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316AbcEaHWq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 31 May 2016 03:22:46 -0400
Received: by mail-wm0-f66.google.com with SMTP id a136so29744272wme.0
        for <netfilter-devel@vger.kernel.org>; Tue, 31 May 2016 00:22:45 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <CAOkSjBgKZyr-GJLWwASNoLOftJbQu5boiTpMOfNsj7YCktYGxw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, May 31, 2016 at 12:08:57AM +0200, Arturo Borrero Gonzalez wrote=
:
> On 30 May 2016 at 21:47, Laura Garcia Liebana <nevola@gmail.com> wrot=
e:
> > Add translation for multiport to nftables, which it's supported nat=
ively.
> >
> > Examples:
> >
> > $ sudo iptables-translate -t filter -A INPUT -p tcp -m multiport --=
dports 80,81 -j ACCEPT
> > nft add rule ip filter INPUT ip protocol tcp tcp dport { 80,81} cou=
nter accept
> >
> > $ sudo iptables-translate -t filter -A INPUT -p tcp -m multiport --=
dports 80:88 -j ACCEPT
> > nft add rule ip filter INPUT ip protocol tcp tcp dport { 80-88} cou=
nter accept
> >
> > $ sudo iptables-translate -t filter -A INPUT -p tcp -m multiport ! =
--dports 80:88 -j ACCEPT
> > nft add rule ip filter INPUT ip protocol tcp tcp dport !=3D 80-88 c=
ounter accept
> >
>=20
> Lets clarify the syntax, this is valid:
>=20
> tcp dport 8000-8100
> tcp dport { 8000-8100}
> tcp dport { 8000-8100, 9000-9100}
>=20
> but they mean different things. It seems we should avoid the braces {=
}
> for the range case, otherwise we would be using a set with a single
> element.
>=20

Yes, you're right. I'll change it in order to allow port ranges without=
 {}.

> However,
>=20
> tcp dport {8000,8100} <-- valid
> tcp dport 8000,8100 <-- invalid
>=20
> So we should always use braces {} in the non-range case.
>=20
> Same seems to apply in the case of inversion.
>=20
> so we end with this combinations:
>=20
> tcp dport {x,x}
> tcp dport !=3D {x,x}

This is not supported.

> tcp dport x-x
> tcp dport !=3D x-x
>=20
> BTW, related to this, there seems to be a bug in nftables:
>=20
> % nft add rule t c tcp dport !=3D {80, 81}
> BUG: invalid expression type set
> nft: evaluate.c:1463: expr_evaluate_relational: Assertion `0' failed.
> Aborted
>=20
>=20
> > Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
> > ---
> > Changes in v2:
> >         - Add curley brackets to lists and range of ports.
> >
> >  extensions/libxt_multiport.c | 116 +++++++++++++++++++++++++++++++=
++++++++++++
> >  1 file changed, 116 insertions(+)
> >
> > diff --git a/extensions/libxt_multiport.c b/extensions/libxt_multip=
ort.c
> > index 03af5a9..25b5589 100644
> > --- a/extensions/libxt_multiport.c
> > +++ b/extensions/libxt_multiport.c
> > @@ -468,6 +468,118 @@ static void multiport_save6_v1(const void *ip=
_void,
> >         __multiport_save_v1(match, ip->proto);
> >  }
> >
> > +static int __multiport_xlate(const void *ip, const struct xt_entry=
_match *match,
> > +                            struct xt_xlate *xl, int numeric)
> > +{
> > +       const struct xt_multiport *multiinfo
> > +               =3D (const struct xt_multiport *)match->data;
> > +       unsigned int i;
> > +
> > +       switch (multiinfo->flags) {
> > +       case XT_MULTIPORT_SOURCE:
> > +               xt_xlate_add(xl, "sport ");
> > +               break;
> > +       case XT_MULTIPORT_DESTINATION:
> > +               xt_xlate_add(xl, "dport ");
> > +               break;
> > +       case XT_MULTIPORT_EITHER:
> > +               return 0;
> > +       }
>=20
> this case XT_MULTIPORT_EITHER seems unsupported in nftables.
>=20
> Is there anything established to do in case we find an impossible
> translation? print a warning or something? I don't know right now.
> I guess we should avoid printing an invalid nftables rule as if the
> translation was 100% ok (which is not true in this case).
>=20

It was agreed to return 0 if the translation is not supported for
nftables. Currently, it does.

> Just wondering, I should check myself because I don't know this right=
 now.
>=20
>=20
> > +
> > +       if (multiinfo->count > 1)
> > +               xt_xlate_add(xl, "{ ");
> > +
> > +       for (i =3D 0; i < multiinfo->count; i++)
> > +               xt_xlate_add(xl, "%s%u", i ? "," : "", multiinfo->p=
orts[i]);
> > +
> > +       if (multiinfo->count > 1)
> > +               xt_xlate_add(xl, "}");
> > +
> > +       xt_xlate_add(xl, " ");
> > +
> > +       return 1;
> > +}
> > +
> > +static int multiport_xlate(const void *ip, const struct xt_entry_m=
atch *match,
> > +                          struct xt_xlate *xl, int numeric)
> > +{
> > +       uint8_t proto =3D ((const struct ipt_ip *)ip)->proto;
> > +
> > +       xt_xlate_add(xl, "%s ", proto_to_name(proto));
> > +       return __multiport_xlate(ip, match, xl, numeric);
> > +}
> > +
> > +static int multiport_xlate6(const void *ip, const struct xt_entry_=
match *match,
> > +                           struct xt_xlate *xl, int numeric)
> > +{
> > +       uint8_t proto =3D ((const struct ip6t_ip6 *)ip)->proto;
> > +
> > +       xt_xlate_add(xl, "%s ", proto_to_name(proto));
> > +       return __multiport_xlate(ip, match, xl, numeric);
> > +}
> > +
> > +static int __multiport_xlate_v1(const void *ip,
> > +                               const struct xt_entry_match *match,
> > +                               struct xt_xlate *xl, int numeric)
> > +{
> > +       const struct xt_multiport_v1 *multiinfo
> > +               =3D (const struct xt_multiport_v1 *)match->data;
> > +       unsigned int i;
> > +
> > +       switch (multiinfo->flags) {
> > +       case XT_MULTIPORT_SOURCE:
> > +               xt_xlate_add(xl, "sport ");
> > +               break;
> > +       case XT_MULTIPORT_DESTINATION:
> > +               xt_xlate_add(xl, "dport ");
> > +               break;
> > +       case XT_MULTIPORT_EITHER:
> > +               return 0;
> > +       }
>=20
> same XT_MULTIPORT_EITHER here.
>=20

Same as before.

> > +
> > +       if (multiinfo->invert) {
> > +               xt_xlate_add(xl, "!=3D ");
> > +       } else {
> > +               if (multiinfo->count > 1)
> > +                       xt_xlate_add(xl, "{ ");
> > +       }
>=20
> This if/else seems bogus. We only allow port sets if not inverting?
>=20

This should be now changed as we've to accept port ranges without {}.

> > +
> > +       for (i =3D 0; i < multiinfo->count; i++) {
> > +               xt_xlate_add(xl, "%s%u", i ? "," : "", multiinfo->p=
orts[i]);
> > +               if (i && multiinfo->invert)
> > +                       return 0;
>=20
> This return here could mean that we build an incomplete nftables rule
> (ie, missing '}')
>=20

Such condition cares that there is no translation in nftables for:

tcp dport !=3D { 80,88 }

So the closed } doesn't even matter.


> > +               if (multiinfo->pflags[i])
> > +                       xt_xlate_add(xl, "-%u", multiinfo->ports[++=
i]);
> > +       }
> > +

If the rule needs such closed } , then it's controlled here:

> > +       if (multiinfo->count > 1 && !multiinfo->invert)
> > +               xt_xlate_add(xl, "}");
> > +
> > +       xt_xlate_add(xl, " ");
> > +
> > +       return 1;
> > +}
>=20
>=20
> --=20
> Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
