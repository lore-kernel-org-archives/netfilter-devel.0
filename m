From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH]   Condition match - error while parsing parameters
Date: Wed, 26 Mar 2003 15:39:52 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030326143952.GQ21953@sunbeam.de.gnumonks.org>
References: <3E734399.9050709@videotron.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eMP3JyRexyk9c0Bv"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Stephane Ouellette <ouellettes@videotron.ca>
Content-Disposition: inline
In-Reply-To: <3E734399.9050709@videotron.ca>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--eMP3JyRexyk9c0Bv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Mar 15, 2003 at 10:15:37AM -0500, Stephane Ouellette wrote:
> Folks,
>=20
>   here are two small patches that fix a parsing error.  The error made=20
> the condition match module think that multiple conditions were specified=
=20
> on the iptables command line.

Thanks for the fix, applied.
>=20
> Stephane Ouellette.
>=20

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--eMP3JyRexyk9c0Bv
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+gbu4XaXGVTD0i/8RAmLEAJ4lVw7mg8iTu3Sey3zOkI7l+QrAnwCff5wo
zD1YPYoA5ULzR8NiSLVNqSQ=
=K1s1
-----END PGP SIGNATURE-----

--eMP3JyRexyk9c0Bv--
