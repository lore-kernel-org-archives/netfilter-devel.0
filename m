From: Harald Welte <laforge@netfilter.org>
Subject: Re: {PATCH]: fix expectation eviction order
Date: Tue, 30 Sep 2003 21:54:27 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030930195427.GC734@obroa-skai.de.gnumonks.org>
References: <3F775469.6070107@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uXxzq0nDebZQVNAZ"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <3F775469.6070107@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--uXxzq0nDebZQVNAZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 28, 2003 at 11:36:41PM +0200, Patrick McHardy wrote:
> Hi Harald,
> this patch fixes the order in which expectations are evicted when a helper
> specifies IP_CT_HELPER_F_REUSE_EXPECT. Currently each new expectation
> is added at the beginning of the masters sibling list and when max_expect=
ed
> is reached the first non-established one on the list is reused (which giv=
es
> LIFO behaviour).

Committed to CVS now.
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--uXxzq0nDebZQVNAZ
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/ed9zXaXGVTD0i/8RAvV3AJ9LagKJPuAAwdn3qAVQmTPCtw3PEQCeLsmQ
RXPVQHFdJnXVmSo+4RYnBh4=
=Aut7
-----END PGP SIGNATURE-----

--uXxzq0nDebZQVNAZ--
