From: Harald Welte <laforge@netfilter.org>
Subject: Re: Converting patch-o-matic over to 2.6 kernel format - most of the work done.
Date: Mon, 17 Nov 2003 09:06:42 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031117080641.GA22919@sunbeam.de.gnumonks.org>
References: <Pine.LNX.4.44.0311161654000.22726-100000@sparrow>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lrZ03NoBR/3+SXJZ"
Cc: ML-netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: William Stearns <wstearns@pobox.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0311161654000.22726-100000@sparrow>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--lrZ03NoBR/3+SXJZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 16, 2003 at 05:01:55PM -0500, William Stearns wrote:
> 	I've written a converter that pulls in the lines from pom's
> .config.in and .configure.help files and creates a something.patch.Kconfig
> file, ready to be used on a 2.6 kernel.  The converter tool is at
> http://www.stearns.org/pom26convert .  I've included a sample output; the
> HL.patch.ipv6.config.in and HL.patch.ipv6.configure.help files were=20
> converted over to the HL.patch.ipv6.Kconfig .  The converter warned the=
=20
> user at run-time that it wasn't able to handle the if/fi lines in=20
> .config.in; the person running it will probably have to do some cleanup=
=20
> work on perhaps 20% of the files.

thanks a lot!

I am in the process of re-writing patch-o-matic in a more general way,
being able to deal with 2.4 and 2.6 kernels _and_ at the same time no
longer use diff -u as format for adding new files.   This has been
proven as PITA, since we don't really have source control for the
source, but rather for patches (or both, which is prone to become out of
sync.

I didn't make that code public yet, since is incomplete.

However, I see that it might be helpful for other people to contribute
to.  It is now available as 'patch-o-matic_ng' in CVS.

The code there is currently able to
	- parse the new 'info' file
	- resolve dependencies (although the version number compare
	  has not been implemented yet)
	- test if a patch is applied
	- copy the whole new files to the kernel dir
	- apply the remaining 'patch' file, if any

What is really missing is the lack for what in old pom was
=2Epatch.makefile, .patch.config.in, .patch.configure.help, etc.

However, my idea was to have a higher level language where one could say
"add the following member to struct foobar", or "create a new config
option FOO dependent on BAR" - independent of the kernel version.

If anybody likes to contribute to that part, it would be greatly
appreciated.

> 	Cheers,
> 	- Bill

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--lrZ03NoBR/3+SXJZ
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/uIGRXaXGVTD0i/8RAp3sAJ9fy3+sNL/YhmJ8uiKg9IhRFi7MUQCfYRA0
+Ba2eAsp1UNXSbqQrX35D0o=
=BbKa
-----END PGP SIGNATURE-----

--lrZ03NoBR/3+SXJZ--
