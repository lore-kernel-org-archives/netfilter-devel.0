From: Harald Welte <laforge@netfilter.org>
Subject: Re: ICMP unreachable (DF) does not report the NATed IP
Date: Tue, 29 Apr 2003 16:50:46 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030429145046.GF684@naboo.intranet.astaro.de>
References: <4F9AFAF72B246745B6847C7EECD8FF6901D17A81@EXCHANGE1.charite.de> <1051552224.5946.239.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="p8PhoBjPxaQXD0vg"
Cc: "Hillmann, Oliver" <Oliver.Hillmann@charite.de>,
	Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
Content-Disposition: inline
In-Reply-To: <1051552224.5946.239.camel@tux.rsn.bth.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--p8PhoBjPxaQXD0vg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 28, 2003 at 07:50:24PM +0200, Martin Josefsson wrote:
> On Mon, 2003-04-28 at 17:57, Hillmann, Oliver wrote:
>=20
> > I have been subcribed to netfilter-devel, but first wanted to send it t=
o a more general list before bothering the developers with this...
> >=20
> > As soon as I find some time, I will be looking into this and try to com=
e up with a NAT helper module... Any comments and suggestions are welcome!
>=20
> That's the wrong way to do it, fix the cause of the problem. It's the
> code in icmp_reply_translation() in ip_nat_core.c

please don't tell me there is still an unhandled ICMP reply translation
problem.  If yes, I think I need a new brain.

> I've havn't given it much thought yet.
>=20
> Also look at the submitted/11_inner-icmp-translation-fix.patch patch in
> patch-o-matic as it modifies this function.

This patch was supposed to handle all the remaining cases we had with
fixing ICMP translation.  The case Oliver Hillmann was talking about
sounds exactly like one of them.

> /Martin

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--p8PhoBjPxaQXD0vg
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+rpFGXaXGVTD0i/8RAsQFAJoC0INTbkB5puKIGmoEwbNONLPDvwCcCNc2
5eU/dyw+VArtjhML7i4QwIE=
=8V1/
-----END PGP SIGNATURE-----

--p8PhoBjPxaQXD0vg--
