From: Harald Welte <laforge@netfilter.org>
Subject: Re: iptables icmp protocol match bug.
Date: Sat, 2 Aug 2003 18:05:51 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030802160551.GB21637@naboo>
References: <54265908055.20030731224710@lf.lv> <3F298F80.2000304@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MfFXiAuoTsnnDAfZ"
Cc: Peteris Krumins <newsgroups@lf.lv>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <3F298F80.2000304@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--MfFXiAuoTsnnDAfZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 31, 2003 at 11:52:00PM +0200, Patrick McHardy wrote:
=20
> This is deliberate. There is no valid icmp-type 255, it is used as a
> wildcard to match every possible type. See icmp_type_code_match()
> in ip_tables.c. Perhaps the userspace tool should warn about invalid
> types ?

yes, please make this a bugzilla entry so we don't forget about that.

> Patrick

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--MfFXiAuoTsnnDAfZ
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/K+FfXaXGVTD0i/8RAtciAKCC0irTpjTltk7AT+8MEiDz0/Wt4wCfXphg
AGrSE5JjXKt/VPt8uonP0h8=
=gZDc
-----END PGP SIGNATURE-----

--MfFXiAuoTsnnDAfZ--
