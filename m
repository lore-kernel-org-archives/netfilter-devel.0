From: Harald Welte <laforge@netfilter.org>
Subject: Re: Augmenting conntrack
Date: Wed, 15 Oct 2003 12:09:25 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031015100925.GA14198@obroa-skai.de.gnumonks.org>
References: <3F8350CA.6040904@vialink.com.br> <20031014115026.61399.qmail@web13905.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zhXaljGHf11kAtnf"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Scott MacKay <scottmackay@yahoo.com>
Content-Disposition: inline
In-Reply-To: <20031014115026.61399.qmail@web13905.mail.yahoo.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--zhXaljGHf11kAtnf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 14, 2003 at 04:50:26AM -0700, Scott MacKay wrote:
> The only things I can think of which might work would
> be to change the NF_IP_PRI_CONNTRACK value to be
> higher than MANGLE (ugly, doubt it would work), alter
> the conntrack module to de-mangle what it sees so it
> can establish connection tracking OK (also ugly and
> not sure where I would start), or maybe a conntrack
> helper module (saw amanda did this, was not sure if I
> could specify a fairly wide criterea). =20

or put your queue rule into PREROUTING of the 'raw' table (see
patch-o-matic).

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--zhXaljGHf11kAtnf
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/jRzVXaXGVTD0i/8RAku+AKCj0whfeYIExYrElRy7iaWEr4QlYgCcDAgz
/wJWCMc8HHxixdwf+6wqFDg=
=XD21
-----END PGP SIGNATURE-----

--zhXaljGHf11kAtnf--
