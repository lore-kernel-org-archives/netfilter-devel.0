From: Harald Welte <laforge@netfilter.org>
Subject: Re: [netfilter-core] [PATCH] ipv4 netfilter MODULE_PARM conversion
Date: Fri, 23 Jul 2004 19:48:36 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040723234836.GD2848@obroa-skai.de.gnumonks.org>
References: <20040723131836.2f5c3bbd@dell_ss3.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8vCeF2GUdMpe9ZbK"
Cc: coreteam@netfilter.org, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Stephen Hemminger <shemminger@osdl.org>
Content-Disposition: inline
In-Reply-To: <20040723131836.2f5c3bbd@dell_ss3.pdx.osdl.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--8vCeF2GUdMpe9ZbK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 23, 2004 at 01:18:36PM -0700, Stephen Hemminger wrote:
> This converts all the netfilter ipv4 modules to use the new module_param
> rather than the soon to be deprecated MODULE_PARM

Stephen, I have a very similar patch sitting in my queue for davem ;)
Sorry you had to duplicate the effort :(

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--8vCeF2GUdMpe9ZbK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFBAaPUXaXGVTD0i/8RAkOhAJ46SiKZOUT/NxT8X/IPqJ64rNFTSgCfcEMI
SeBrc7uWbE4A7mvRx0VlRvw=
=oGHX
-----END PGP SIGNATURE-----

--8vCeF2GUdMpe9ZbK--
