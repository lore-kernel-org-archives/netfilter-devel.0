From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH]    Less printf() calls for libip6t_esp.c
Date: Sat, 23 Aug 2003 20:42:13 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030823184213.GC10603@obroa-skai.de.gnumonks.org>
References: <3F392D0C.7080104@videotron.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eRtJSFbw+EEWtPj3"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Stephane Ouellette <ouellettes@videotron.ca>
Content-Disposition: inline
In-Reply-To: <3F392D0C.7080104@videotron.ca>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--eRtJSFbw+EEWtPj3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 12, 2003 at 02:08:12PM -0400, Stephane Ouellette wrote:
> Harald,
>=20
>    this attached patch contains C99 initializers and printf()=20
> simplifications fo libip6t_esp.c.

Thanks!

Sorry for the late reply, but first was the netfilter developer summit
in Budapest, and then our project's server was down - so I didn't really
have the time to take care of your patches. Please don't misunderstand
this as lack of interest in your contributions.

They are now all applied.

>    Please apply.
> Stephane

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--eRtJSFbw+EEWtPj3
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/R7WEXaXGVTD0i/8RAj/IAKCj3psDWyTc5sGyxjE2kVwml7WcoACfdrwd
3vYbadPFMUZclK0j4/Ww08w=
=q0tH
-----END PGP SIGNATURE-----

--eRtJSFbw+EEWtPj3--
