From: Harald Welte <laforge@netfilter.org>
Subject: Re: patch for conntrack expectations
Date: Wed, 18 Feb 2004 18:25:39 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040218172539.GX9464@sunbeam.de.gnumonks.org>
References: <403014C5.8080102@eurodev.net> <20040217213217.GF30968@obroa-skai.de.gnumonks.org> <4032F4DE.3050402@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cjVziHhGDpplWqiR"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
Content-Disposition: inline
In-Reply-To: <4032F4DE.3050402@eurodev.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--cjVziHhGDpplWqiR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 18, 2004 at 06:15:10AM +0100, Pablo Neira wrote:

> By other hand, in the current approach if the pattern is found, the=20
> function ip_conntrack_expect_related does a memcpy of a structure of 116=
=20
> bytes (expectation) from the stack to memory. This is not needed anymore=
=20
> since with the new approach the helper works with the future expectation=
=20
> already allocated in memory.

Ok, I missed that part.

> I also think that this will result in a cleaner API to manage the=20
> expectations. well, maybe you could also use this to allocate an=20
> expectation for the connection tracking replication (well... i just=20
> started talking so much).

Yes, ct_sync would also need an allocation function anyway.

> I had a look at almost all the helpers which are in patch-o-matic-ng=20
> (even the pptp helper). I have no problem about modifying them. BTW, the=
=20
> documentation should be updated as well if this change is applied.

Yes, indeed.

Would you be willing to submit a 2.6.x merge, together with updates to
the existing helpers?

Thanks.

> Pablo

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--cjVziHhGDpplWqiR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAM6ATXaXGVTD0i/8RAv+uAJ9SF2e1EJLpc3K95qOfpukG5icr3gCgl4hM
rPtHfw4I+WP6xZgiR/Iub48=
=Clwe
-----END PGP SIGNATURE-----

--cjVziHhGDpplWqiR--
