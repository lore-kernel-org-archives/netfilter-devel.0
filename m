From: Harald Welte <laforge@gnumonks.org>
Subject: Re: [PATCH] Small SMP-race found in ip_conntrack_proto_tcp.c
Date: Wed, 30 Oct 2002 09:48:37 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021030094837.Q8635@sunbeam.de.gnumonks.org>
References: <1035472754.722.129.camel@tux>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eL7EO+gwLE2vJ/xx"
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
Content-Disposition: inline
In-Reply-To: <1035472754.722.129.camel@tux>; from gandalf@wlug.westbo.se on Thu, Oct 24, 2002 at 05:19:14PM +0200
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--eL7EO+gwLE2vJ/xx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 24, 2002 at 05:19:14PM +0200, Martin Josefsson wrote:
> Patch to move the unlock further down is attached, I unlock before
> calling ip_ct_refresh as it is unfriendly to hold the lock longer than
> neccessary.

I can't see a patch :)

> /Martin
--=20
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--eL7EO+gwLE2vJ/xx
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9v5zlXaXGVTD0i/8RAjn2AJwIbymCM9XfR7pwi8pGbORVRyv79wCfYaSf
Ad4aJf75gft5Q2itIwG/r3U=
=ibGB
-----END PGP SIGNATURE-----

--eL7EO+gwLE2vJ/xx--
