From: Harald Welte <laforge@gnumonks.org>
Subject: Re: Questions about your dual Opteron packetfiltering tests
Date: Fri, 16 Jul 2004 06:18:29 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040716131829.GC2214@obroa-skai.de.gnumonks.org>
References: <20040716015152.GA29337@soohrt.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oTHb8nViIGeoXxdp"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Karsten Desler <kdesler@soohrt.org>
Content-Disposition: inline
In-Reply-To: <20040716015152.GA29337@soohrt.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--oTHb8nViIGeoXxdp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 16, 2004 at 03:51:52AM +0200, Karsten Desler wrote:

> I've got a couple of questions about the "Doing lots of benchmarks /
> tuning / profiling lately" post on your weblog and I'd really appreciate
> any pointers to more precise results and developments, or ballpark
> figures to help me decide on hardware for an upcoming project.

unfortunately I still didn't have the time to put the information into
some presentable/publishable format.  (Even though I'm now allowed to
publish the numbers).  I'll try to do this soon.

> What impact do any of the following statements of you have on the
> overall performance of the router (rough estimates)?
> - i386 kernels give you higher PPS than x86_64 (because sk_buff is
>   smaller)

about 5% performance increase=20

> - e1000 are way faster than tg3 boards (could be hardware or driver
>   issue)

it's actually a hardware issue, I've just been talking about this to
David Miller yesterday.  Apparently the tg3 receive path needs to do two
read operations in the receive path, as opposed to one read; this
increases latency.

I would say about 15% to 20%.

> - Intel PRO/1000MT Quad e1000 boards suck (apparently problems with the
>   onboard PCI-X bridge)

About 25% to 30% less pps with 64byte packets on tg3 versus e1000.

> And do the dual Intel Pro/1000 PCIX card suffer the same fate?

no, not at all.  they don't have a PCI-X bridge on the board but attach
the two chips directly [electrically] to the pci slot of the mainboard.

> Thanks in advance,
>  Karsten

You might be interested into the various numbers published by Robert Olsson
on robur.slu.se.

--=20
- Harald Welte <laforge@gnumonks.org>               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
Programming is like sex: One mistake and you have to support it your lifeti=
me

--oTHb8nViIGeoXxdp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFA99WlXaXGVTD0i/8RAkkeAJ90yH6R+p9x9dGFzf85Pzhn4Ui5AwCfekbq
jd7XykRq9pXfmqrbk0tpPO0=
=NXsa
-----END PGP SIGNATURE-----

--oTHb8nViIGeoXxdp--
