From: Harald Welte <laforge@netfilter.org>
Subject: Re: Patch with additional options for quota match
Date: Sun, 27 Apr 2003 14:40:55 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030427124055.GX990@sunbeam.de.gnumonks.org>
References: <3E9DCA15.40C99A6C@info-link.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qxpYSgLynlcP4boX"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	samj@samj.net
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Brad Fisher <brad@info-link.net>
Content-Disposition: inline
In-Reply-To: <3E9DCA15.40C99A6C@info-link.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--qxpYSgLynlcP4boX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 16, 2003 at 04:24:37PM -0500, Brad Fisher wrote:
> I have made up a small patch for the quota match by Sam Johnston to add
> a couple of options I find useful - negated matching and the option to
> count total packet size (data + headers) instead of just data size.

I don't want to include this without the orignal author's permission.
Please contact Sam Johnston about your changes and ask him if he agrees
with those changes.

Thanks.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--qxpYSgLynlcP4boX
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+q8/XXaXGVTD0i/8RArpcAJ9FnXcy23SoBCG97N3EwYOl+PAGRgCZAf5M
29td8VfPZ7D0t21MuCfj5WQ=
=XLbx
-----END PGP SIGNATURE-----

--qxpYSgLynlcP4boX--
