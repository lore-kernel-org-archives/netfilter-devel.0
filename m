From: Harald Welte <laforge@netfilter.org>
Subject: Re: ip_conntrack_proto_sctp INIT_ACK messages droppedg
Date: Tue, 15 Feb 2005 00:20:45 +0100
Message-ID: <20050214232045.GJ3829@sunbeam.de.gnumonks.org>
References: <001d01c50dda$f317c4e0$320aa8c0@blueslicemtl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Tu8ztk+XgTAiG9Id"
Cc: netfilter-devel@lists.netfilter.org, kaber@trash.net
To: Ariel Rosenblatt <ariel@blueslice.com>
Content-Disposition: inline
In-Reply-To: <001d01c50dda$f317c4e0$320aa8c0@blueslicemtl>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--Tu8ztk+XgTAiG9Id
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 08, 2005 at 07:37:22AM -0500, Ariel Rosenblatt wrote:
> The following patch seems to solve the problem, the INIT "init_tag" is now
> saved properly for an ESTABLISHED sctp association. The "init_tag" (of an
> INIT message) wasn't being saved in the proper direction, causing the
> INIT_ACK to be dropped while verifying the tag ("vtag") at the beginning =
of
> sctp_packet().

Thanks for your patch.  Patrick, would you please include the patch with
your next patches to davem?

> Cheers,
> - Ariel

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--Tu8ztk+XgTAiG9Id
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFCETJNXaXGVTD0i/8RAm81AJ9eDIkEmdFmO9UEIt+mRFqQH7hulQCcDCJP
YiLQ9OU8rr/n53VB7xoj+Ak=
=YN3u
-----END PGP SIGNATURE-----

--Tu8ztk+XgTAiG9Id--
