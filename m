From: Harald Welte <laforge@netfilter.org>
Subject: Re: libiptc memory leak - PATCH
Date: Sun, 27 Apr 2003 14:51:04 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030427125104.GC990@sunbeam.de.gnumonks.org>
References: <3EA46FDE.6040806@i.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YV7D9JCVdz8QpFLW"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: =?iso-8859-1?B?VG9t4T8=?= Lejdar <tomas.lejdar@i.cz>
Content-Disposition: inline
In-Reply-To: <3EA46FDE.6040806@i.cz>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--YV7D9JCVdz8QpFLW
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 22, 2003 at 12:25:34AM +0200, Tom=E1? Lejdar wrote:
> Hi,
> I've used libiptc for some utils and found a little
> problem with memory allocation, discused in January and
> may be earlier. Here is a small patch (r.1.2.8):

thanks!

please send unified diffs (diff -u) in the future.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--YV7D9JCVdz8QpFLW
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+q9I4XaXGVTD0i/8RAoFaAJ0Ydk1bEi9l2mfCIAN9CQdhXhnw+QCfSW9L
kG7Xz5GOOr6cV+e3T4fp7gE=
=fPEM
-----END PGP SIGNATURE-----

--YV7D9JCVdz8QpFLW--
