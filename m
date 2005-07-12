From: Harald Welte <laforge@netfilter.org>
Subject: Re: [OT] Re: rp_filtering
Date: Tue, 12 Jul 2005 11:18:52 +0200
Message-ID: <20050712091852.GZ16728@sunbeam.de.gnumonks.org>
References: <Pine.LNX.4.61.0507111946560.32325@yvahk01.tjqt.qr>
	<1121105149.5236.5.camel@anduril.intranet.cartel-securite.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1aa3fXZUP8Xb8QnO"
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Cedric Blancher <blancher@cartel-securite.fr>
Content-Disposition: inline
In-Reply-To: <1121105149.5236.5.camel@anduril.intranet.cartel-securite.net>
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


--1aa3fXZUP8Xb8QnO
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 11, 2005 at 08:05:49PM +0200, Cedric Blancher wrote:
> Le lundi 11 juillet 2005 =E0 19:50 +0200, Jan Engelhardt a =E9crit :
> > rp_filter is said to be a route path verification (etc.)
> >   ippp0  217.245.127.134
> >   eth0   192.168.222.1
> > However, I've just done a ping 217.245.127.134 from a windows client in=
side=20
> > the eth0 network, took a peek at iptraf and saw that echo requests and =
replies=20
> > were directly going from/to eth0/192.168.222.34(windows).
>=20
> It's normal Linux behaviour. You can join any Linux box IP on any of its
> interfaces.

yes, but you can disable it via some sysctl's.  It's all documented in
ip-sysctl.txt in Documentation/networking/

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--1aa3fXZUP8Xb8QnO
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFC04r8XaXGVTD0i/8RAiqnAKCR/JC8fGEVoFq3ocWOD10EtLE9xwCgsj/A
jDxcUdzQbta3d7PS5R0n18s=
=fNQi
-----END PGP SIGNATURE-----

--1aa3fXZUP8Xb8QnO--
