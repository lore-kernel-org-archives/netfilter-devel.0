From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] ipt_recent 0.3.1 Released
Date: Mon, 14 Apr 2003 15:32:48 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030414133248.GB6866@sunbeam.de.gnumonks.org>
References: <20030331213757.GU18434@ns.snowman.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="17pEHd4RhPHOinZp"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Developers <netfilter-devel@lists.netfilter.org>,
	ipt_recent Users <ipt_recent@snowman.net>
Content-Disposition: inline
In-Reply-To: <20030331213757.GU18434@ns.snowman.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--17pEHd4RhPHOinZp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 31, 2003 at 04:37:57PM -0500, Stephen Frost wrote:
> Hey all,
>=20
>   I've released ipt_recent version 0.3.1.  CVS has the tag for it and
>   there are tarballs up on the website.  Attached is a patch against the
>   latest netfilter CVS to bring it up to date with version 0.3.1.  The
>   high-level changelog is not much different from what I posted to the
>   ipt_recent list previously:

thanks, applied.

May I assume that there is no incompatibility of using 0.3.0 userspace
(which is what made it into iptables-1.2.8) and the 0.3.1 kernel part?

I will send it to DaveM for kernel inclusion soon.

> 	Thanks,
> 		Stephen
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--17pEHd4RhPHOinZp
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+mriAXaXGVTD0i/8RAp2XAJ4gYMbxX5zSwxFGUpJju8TwYuXH/gCfV/L/
377iMPkI+62mEpemUBHMiT4=
=N9VB
-----END PGP SIGNATURE-----

--17pEHd4RhPHOinZp--
