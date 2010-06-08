From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: Redundant calls to nf_ct_tuplehash_to_ctrack
Date: Tue, 08 Jun 2010 19:00:45 +0200
Message-ID: <1276016445.2486.460.camel@edumazet-laptop>
References: <AANLkTikuYXpQrc3MECpkj_h8E19D5ZM07Li_CpqRYc7k@mail.gmail.com>
	 <1276010168.2486.227.camel@edumazet-laptop>
	 <AANLkTinRGGEyg0b2RzYgM3CIHrtnIn-Lim3F-awFRRaH@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Anand Raj Manickam <anandrm@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50559 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753430Ab0FHRAt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Jun 2010 13:00:49 -0400
Received: by fxm8 with SMTP id 8so3067350fxm.19
        for <netfilter-devel@vger.kernel.org>; Tue, 08 Jun 2010 10:00:47 -0700 (PDT)
In-Reply-To: <AANLkTinRGGEyg0b2RzYgM3CIHrtnIn-Lim3F-awFRRaH@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le mardi 08 juin 2010 =C3=A0 21:26 +0530, Anand Raj Manickam a =C3=A9cr=
it :
> On Tue, Jun 8, 2010 at 8:46 PM, Eric Dumazet <eric.dumazet@gmail.com>=
 wrote:
> > Le mardi 08 juin 2010 =C3=A0 19:48 +0530, Anand Raj Manickam a =C3=A9=
crit :
> >> This my observation ..
> >>
> >> There is a redundant call to nf_ct_tuplehash_to_ctrack() after eve=
ry
> >> nf_conntrack_find_get() call .
> >>
> >> Why is ct not returned from nf_conntrack_find_get() , since in all=
 the
> >> occurances of nf_conntrack_find_get() there is immediate call to
> >> nf_ct_tuplehash_to_ctrack() . Although  nf_ct_tuplehash_to_ctrack(=
) is
> >> invoked to check the ct after we get a valid hash .
> >>
> >
> > One random sample :
> >
> > net/ipv4/netfilter/nf_conntrack_proto_icmp.c
> >
> >        h =3D nf_conntrack_find_get(net, zone, &innertuple);
> >        if (!h) {
> >                pr_debug("icmp_error_message: no match\n");
> >                return -NF_ACCEPT;
> >        }
> >
> >        if (NF_CT_DIRECTION(h) =3D=3D IP_CT_DIR_REPLY)
> >                *ctinfo +=3D IP_CT_IS_REPLY;
> >
> >
> > As you can see, we need 'h' here (to get NF_CT_DIRECTION(h)), not '=
ct'
>=20
> I did think about it,
> Can we derive the direction from conntrack  mabbe we replace
> NF_CT_DIRECTION with the following  .
>=20
> /* If we're the first tuple, it's the original dir. */
>  #define NF_CT_DIRECTION(h)      ((enum ip_conntrack_dir)(h)->tuple.d=
st.dir)
>=20
> if (ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.dir =3D=3D IP_CT_DIR_=
REPLY)

Well, that would be a big problem, if you find a ct where this test is
true ;)

By definition :

ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.dir =3D=3D IP_CT_DIR_ORIGIN=
AL

I dont know why you care, since nf_ct_tuplehash_to_ctrack() is _very_
cheap, its a few addition/subtraction.



--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
