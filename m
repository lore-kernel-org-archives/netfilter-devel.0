From: Harald Welte <laforge@gnumonks.org>
Subject: Re: Fixed proken MARK target in POM.
Date: Fri, 10 Jan 2003 15:00:24 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030110140024.GU1353@sunbeam.de.gnumonks.org>
References: <3E1D7419.1060502@fugmann.dhs.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/CHBEyLWSSL2QXIQ"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Anders Fugmann <afu@fugmann.dhs.org>
Content-Disposition: inline
In-Reply-To: <3E1D7419.1060502@fugmann.dhs.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--/CHBEyLWSSL2QXIQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 09, 2003 at 02:07:37PM +0100, Anders Fugmann wrote:

> The patch maintains backward compability, and I request that this patch=
=20
> is applied to mainstream (and pushed to the Andrea for kernel=20
> inclusion),=20

1) Where is the compatibility?  I cannot see how this code change would
   ensure that
	a) old, unpatched kernel works with new, patched userspace
	b) new, patched kernel works with old, unpatched userspace
   Those two conditions need to be fulfilled, otherwise we cannot make a
   change during the stable kernel series.

2) Which Andrea are you talking about?  Therer is no Andrea involved in
   netfilter/iptabls updates.

> as I as a software developer of a firewall cannot ask users=20
> of the software to appliy patches to POM.

I regard this as critic to my recent patch-o-matic announcement, where I
was asking people to use patch-o-matic.  I was talking about
bugfixes/updates which are in 2.4.20 (or 2.4.21-preX)... but people are
still running older kernels than that... and they should indeed use
patch-o-matic for the netfilter fixes.

Apart from that, everything in patch-o-matic are new features or
extensions, which are either not fully stable or we strongly doubt that
they are useful for the big public.  And if somebody wants to test one
of those non-standard extensions, we can ask people to use patch-o-matic.

> Regards
> Anders Fugmann
--=20
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--/CHBEyLWSSL2QXIQ
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+HtH4XaXGVTD0i/8RApWkAJ9MX9zFvHpXFCXNJOw5qXZYfXsBkQCdFnhV
oogI0jwFObYfFjb+dGH4QMw=
=qQ8/
-----END PGP SIGNATURE-----

--/CHBEyLWSSL2QXIQ--
