From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: Redundant calls to nf_ct_tuplehash_to_ctrack
Date: Tue, 08 Jun 2010 17:16:08 +0200
Message-ID: <1276010168.2486.227.camel@edumazet-laptop>
References: <AANLkTikuYXpQrc3MECpkj_h8E19D5ZM07Li_CpqRYc7k@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Anand Raj Manickam <anandrm@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:59948 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248Ab0FHPQU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Jun 2010 11:16:20 -0400
Received: by pwj5 with SMTP id 5so1351428pwj.19
        for <netfilter-devel@vger.kernel.org>; Tue, 08 Jun 2010 08:16:19 -0700 (PDT)
In-Reply-To: <AANLkTikuYXpQrc3MECpkj_h8E19D5ZM07Li_CpqRYc7k@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le mardi 08 juin 2010 =C3=A0 19:48 +0530, Anand Raj Manickam a =C3=A9cr=
it :
> This my observation ..
>=20
> There is a redundant call to nf_ct_tuplehash_to_ctrack() after every
> nf_conntrack_find_get() call .
>=20
> Why is ct not returned from nf_conntrack_find_get() , since in all th=
e
> occurances of nf_conntrack_find_get() there is immediate call to
> nf_ct_tuplehash_to_ctrack() . Although  nf_ct_tuplehash_to_ctrack() i=
s
> invoked to check the ct after we get a valid hash .
>=20

One random sample :

net/ipv4/netfilter/nf_conntrack_proto_icmp.c

        h =3D nf_conntrack_find_get(net, zone, &innertuple);
        if (!h) {
                pr_debug("icmp_error_message: no match\n");
                return -NF_ACCEPT;
        }

        if (NF_CT_DIRECTION(h) =3D=3D IP_CT_DIR_REPLY)
                *ctinfo +=3D IP_CT_IS_REPLY;


As you can see, we need 'h' here (to get NF_CT_DIRECTION(h)), not 'ct'



--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
