From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH]   Dead code elimination in ip_conntrack_core.c
Date: Wed, 26 Mar 2003 15:48:46 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030326144846.GS21953@sunbeam.de.gnumonks.org>
References: <3E73631C.1060102@videotron.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FX+Db2fp7WJhXKrW"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Stephane Ouellette <ouellettes@videotron.ca>
Content-Disposition: inline
In-Reply-To: <3E73631C.1060102@videotron.ca>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--FX+Db2fp7WJhXKrW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Mar 15, 2003 at 12:30:04PM -0500, Stephane Ouellette wrote:
> List members,
>=20
>    the following cosmetic patch removes dead code in=20
> ip_conntrack_init() if CONFIG_SYSCTL is not defined.
> The patch applies against a plain 2.4.21-pre5-ac3 kernel.

thanks, I'm including your patch into 'pending'

> Regards,
> Stephane Ouellette
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--FX+Db2fp7WJhXKrW
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+gb3OXaXGVTD0i/8RAugfAJ4+aBcmqp4CBeGWqot+hxYahZzP/gCfWNtJ
QAmb7/5EcepADAGp+hfhRC4=
=1Rqv
-----END PGP SIGNATURE-----

--FX+Db2fp7WJhXKrW--
