From: Kevin Darbyshire-Bryant <kevin@darbyshire-bryant.me.uk>
Subject: Re: [Cake] [PATCH net-next v15 4/7] sch_cake: Add NAT awareness to
        packet classifier
Date: Thu, 24 May 2018 04:52:16 +0000
Message-ID: <F5E3D9FC-F7FC-42AB-8F39-717C3E040402@darbyshire-bryant.me.uk>
References: <87in7exg3d.fsf@toke.dk>
 <20180523.164152.387997944739062215.davem@davemloft.net>
 <87bmd6xeur.fsf@toke.dk>
 <20180523.172008.1067759293733489715.davem@davemloft.net>
 <878t8axafk.fsf@toke.dk>
Mime-Version: 1.0
Content-Type: multipart/signed;
        boundary="Apple-Mail=_570C0C0C-3875-4DD0-B6DB-444EB597E6E2";
        protocol="application/pgp-signature";
        micalg=pgp-sha256
Cc: David Miller <davem@davemloft.net>,
        Cake List <cake@lists.bufferbloat.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: =?utf-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <878t8axafk.fsf@toke.dk>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

--Apple-Mail=_570C0C0C-3875-4DD0-B6DB-444EB597E6E2
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8



> On 23 May 2018, at 23:40, Toke H=C3=B8iland-J=C3=B8rgensen =
<toke@toke.dk> wrote:
>=20
<snip>
>=20
> Hmm, and we still have an issue with ingress filtering (where cake is
> running on an ifb interface). That runs pre-NAT in the conntrack case,
> and we can't do the RX trick. Here we do the lookup manually in
> conntrack (and this part is actually what brings in most of the
> dependencies). Any neat tricks up your sleeve for this case? :)

I wonder here if our terminology with =E2=80=98ingress=E2=80=99 is =
causing confusion.  For avoidance of doubt:

Typical use case of cake on LAN/WAN router requires two instances.  One =
instance (the egress) is on the WAN interface itself.  It is post =
conntrack and hence uses skb->nfct to work out the real pre-nat source =
address of the LAN hosts.

Since we cannot apply this qdisc to the ingress of our WAN interface we =
use an IFB to mirror the ingress packets, and then use a cake instance =
on the ifb interface on its egress path to in essence control the =
ingress traffic.

Cake has two modes, the normal =E2=80=98egress=E2=80=99 mode which is =
designed to be used when controlling egress traffic output, and shapes =
post any dropped packets.  =E2=80=98ingress=E2=80=99 mode is designed to =
be used on the egress of our ingress IFB, where the shaper counts all =
packets used (well they got here!) even if we decide to drop them a bit =
later.

The ifb positioned cake has the additional fun factor that the conntrack =
field hasn=E2=80=99t yet been filled in, so the qdisc has to go looking =
in the conntrack tables itself to see if any NATting has taken place and =
balance LAN host fairness based on that.

As far as I understand it, the flow dissector doesn=E2=80=99t obviously =
help with working out the pre-NAT addressing as the flow has already =
been mangled in the egress case, and is awaiting mangling on the ingress =
case.


Kevin

--Apple-Mail=_570C0C0C-3875-4DD0-B6DB-444EB597E6E2
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----

iQIyBAEBCAAdFiEEASyssijGxT6XdZEjs6I4m53iM0oFAlsGRP8ACgkQs6I4m53i
M0rhLw/4vKMmRf9T/SCQgBTHHieZ1pUW+4MHAgfMstS4htyDwvC5Qicc1paqKpx+
oJgwBsxGx2boMJ2XdAy2Y8Lgs3FUMBoA5V0cizEMtE8ACUGrf0sDTF8FzdiDRUDE
7dSSsy/ryePGisLS7273SrGBxwBxsP4DbY0mPf8/6CgKXOFDSKZA7Rh83bCTKfTn
y44dL/1ZJ6yf1mK7kXHgQBTLWcZzeN31JJ5lZo3k5Gs1TyrJ3qp4F/ZycrcLyqHb
slEj6/l6loCI3lSscfIGu/enzpYH3tV3LBxSaSoBS3XEmEKxHA4wgkaB6OJFx5PY
schAjBsMhKOwet367V+WaVX5ggiE/zA9ggXkQDIclrolFkRIHcKx8XN/JVYSFxQt
wk3uSkRaJYzbOUgqrFBjrzU/juTuhNcgR4NBPQgJX8+fNNryqAiT7qJXCPSquQc7
ypxFks9fCfhsWiZt4qsU/Mb1eGsf5AQJv/ZqYj/yBtJ2657hNW/aw2EfrNyt1BkC
zGjheoLvwgLv++Ge5SuSQxntQBqixbVLMswYHT4osDD0rxEzuMWi0tSq/4q/p83h
rCgoJoIbScf9hKNhS+ZgxJsKr0iqOYxlbYbzGBpqw19jsNeVBEOzYW2lgYiO/IH5
78TCvTshiRTi21O2zfQyk3qChA8sJkZKmKCBzy3EgMy6Qi+T9Q==
=DDwx
-----END PGP SIGNATURE-----

--Apple-Mail=_570C0C0C-3875-4DD0-B6DB-444EB597E6E2--
