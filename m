From: Harald Welte <laforge@netfilter.org>
Subject: Re: Time match problem
Date: Tue, 24 Jun 2003 18:27:38 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030624162738.GU2645@sunbeam.de.gnumonks.org>
References: <20030619100134.5419.qmail@sina.com> <003d01c33654$13b6b680$0207a8c0@endromeda>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="o/BvujNCPFVhiGON"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Fabrice MARIE <fabrice@fma.homelinux.com>
Content-Disposition: inline
In-Reply-To: <003d01c33654$13b6b680$0207a8c0@endromeda>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--o/BvujNCPFVhiGON
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 19, 2003 at 07:15:23PM +0800, Fabrice MARIE wrote:
> Hello
>=20
> > Hi,
> > When I am using the time match ,I have the following command:
> >  iptables -A FORWARD -m time --timestart 08:00 --timestop 18:00  --days
> Mon -j ACCEPT
> > This works well,but when i delete the rule,I have the following command:
> >  iptables -D FORWARD -m time --timestart 08:00 --timestop 18:00  --days
> Mon -j ACCEPT
> > It does not work,and display:
>=20
> I'm aware of the problem for quite some time, it's just that I need a bit=
 of
> time to fix it...
> But I'll do it soon, I promise :)

Hi  Fabrice, could you please submit this to bugzilla so it doesn't get
lost (and people can discover that this is a known bug)?  Thanks.

> Cheers,
> Fabrice.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--o/BvujNCPFVhiGON
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE++Hv6XaXGVTD0i/8RAjZAAKCYDyG90K+8cpFIRI2984KoHvm3TQCcC3Y2
GYDG6qeNxuHGLmUbk/4PSgI=
=4gsb
-----END PGP SIGNATURE-----

--o/BvujNCPFVhiGON--
