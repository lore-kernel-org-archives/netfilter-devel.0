From: Harald Welte <laforge@gnumonks.org>
Subject: Re: pptp-conntrack-nat and PPTP server behind firewall
Date: Wed, 15 Oct 2003 09:32:20 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031015073220.GB9880@obroa-skai.de.gnumonks.org>
References: <1066175519.8813.92.camel@johnh>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CUfgB8w4ZwR/yMy5"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Netfilter Mailinglist <netfilter@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: John Hardin <johnh@aproposretail.com>
Content-Disposition: inline
In-Reply-To: <1066175519.8813.92.camel@johnh>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--CUfgB8w4ZwR/yMy5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 14, 2003 at 04:51:59PM -0700, John Hardin wrote:
> Harald:
>=20
> In the .help file you state:
>=20
> 	can only NAT connections from PNS to PAC
>=20
> It's been a while since I've worked with the PPTP model, and I've
> forgotten what the acronyms mean. Does this comment mean that the
> current pptp-conntrack-nat code can or cannot be used for a PPTP server
> behind a masq/nat firewall serving clients out on the Internet?

no, it can be used for both ways.  It just assumes that (like every
known implementation I've seen so far) the TCP connection is established
between 'client' and 'server'.  The protocol spec also allow a 'server'
to connect the 'client'.

Please ask questions like this on the mailing lists, this way you might
get a quick answer and the question is documented in the list archive

> Thanks.
> I may have to get back into this... :)
--=20
- Harald Welte <laforge@gnumonks.org>               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
Programming is like sex: One mistake and you have to support it your lifeti=
me

--CUfgB8w4ZwR/yMy5
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/jPgDXaXGVTD0i/8RAmrsAKCc1JvTsgV5aGc/Mbc/ityXUJPlwwCdHRS7
YghwEPwpeadBgA+a0HhThKE=
=IjIQ
-----END PGP SIGNATURE-----

--CUfgB8w4ZwR/yMy5--
