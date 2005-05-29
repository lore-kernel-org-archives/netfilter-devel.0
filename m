From: Harald Welte <laforge@netfilter.org>
Subject: Re: changing packet length?
Date: Sun, 29 May 2005 21:01:28 +0200
Message-ID: <20050529190128.GV13114@sunbeam.de.gnumonks.org>
References: <20050503213406.GE13894@tigris.renesys.com>
	<20050506111410.GG30482@sunbeam.de.gnumonks.org>
	<20050506141159.GA17261@tigris.renesys.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tx6GZeiIEnV4GwE1"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: BJ Premore <bj-netfilter@renesys.com>
Content-Disposition: inline
In-Reply-To: <20050506141159.GA17261@tigris.renesys.com>
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


--tx6GZeiIEnV4GwE1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 06, 2005 at 10:11:59AM -0400, BJ Premore wrote:
> Hi Harald,
>=20
> On Fri, May 06, 2005 at 01:14:10PM +0200, Harald Welte wrote:
> > On Tue, May 03, 2005 at 05:34:06PM -0400, BJ Premore wrote:
> > > So my hopefully simple question is, can packet sizes be
> > > changed and then reinjected using ipq_set_verdict? =20
> >=20
> > Of course. you just reinject the packet with a different
> > data_len.
>=20
> That's what I thought too, but I get the problems described
> in my original post (subsequent packets start looking
> mangled, basically).  Have you, or has anyone, gotten this
> to work?  I've been scouring the net for examples but in no
> case has any code that I've found actually changed the
> length of the packets before reinjecting them.

another thought:  could you double-check (using strace) that the packets
you reinject are exactly like they are supposed to be?
--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--tx6GZeiIEnV4GwE1
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFCmhGIXaXGVTD0i/8RAsXiAKCeKHJMOfaK8JLbVLwtbsUV0C1lDACeIUHY
qaJXWTrIcOF/krWgtPxTAXc=
=PGPu
-----END PGP SIGNATURE-----

--tx6GZeiIEnV4GwE1--
