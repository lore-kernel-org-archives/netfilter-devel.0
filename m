From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] dead code elimination in ip6_queue.c
Date: Thu, 27 Mar 2003 14:08:52 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030327130852.GE25471@sunbeam.de.gnumonks.org>
References: <3E8201B7.8050309@videotron.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cmJC7u66zC7hs+87"
Cc: netfilter-devel@lists.netfilter.org, jmorris@intercode.com.au
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Stephane Ouellette <ouellettes@videotron.ca>
Content-Disposition: inline
In-Reply-To: <3E8201B7.8050309@videotron.ca>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--cmJC7u66zC7hs+87
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 26, 2003 at 02:38:31PM -0500, Stephane Ouellette wrote:
> Harald,
>=20
>     I have been notified by James Morris that my patch is incorrect=20
> because of a macro named NLMSG_PUT() which uses the code I have removed=
=20
> in my patch.  There is a goto statement inside this macro.

Yes, I've read that mail a couple of minutes later.  Please ignore my
response.

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

--cmJC7u66zC7hs+87
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+gvfkXaXGVTD0i/8RAkn8AJ9ayjjwufFTYZEx0vgfprpd9T5IfQCdGDdW
3Z396DDIbpwvj/mkrrc9lDM=
=qzOn
-----END PGP SIGNATURE-----

--cmJC7u66zC7hs+87--
