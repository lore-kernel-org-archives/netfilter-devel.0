From: Harald Welte <laforge@netfilter.org>
Subject: Re: Building on case-insensitive filesystems
Date: Mon, 18 Oct 2004 15:42:55 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20041018134255.GG21927@sunbeam.de.gnumonks.org>
References: <4171780F.1070909@kegel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TU+u6i6jrDPzmlWF"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Dan Kegel <dank@kegel.com>
Content-Disposition: inline
In-Reply-To: <4171780F.1070909@kegel.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--TU+u6i6jrDPzmlWF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dan :)

On Sat, Oct 16, 2004 at 12:35:43PM -0700, Dan Kegel wrote:
> Seems like ipt_mark_target.h might be a better name for
> that latter file.  That would let developers who have
> MacOSX or Windows laptops successfully unpack the
> Linux source tree on their computers' case-insensitive filesystems.

This has been discussed on the list before, the general result was IIRC
that we don't really care, sorry.

Next time somebody comes along and says well, your more-than-8.3chars
long filenames won't work on my DOS system. =20

iptables fundamentally relies on the destinction:

lowercase =3D=3D match module
uppercase =3D=3D target module

You can't just fix this by renaming kernel source files.

If I read your patch correctly, the resulting modules will have
different names.  This will break auto-loading of match and target
extensions, and it will break userspace compatibility with the userspace
iptables program.

Also, the userspace iptables program has the same assumption, so without
changing the whole chain
	- kernel file names
	- module autoloading
	- userspace filenames
	- userspace plugin autoloading
it will not work.

Also, imagine what happens if someone tries to run an old userspace
program and a new kernel or vice versa.  If we ever adopt a renaming
scheme, it would have to work both forward and backwards compatible, we
can't just change this within a stable kernel series.

> Here's the patch I've been using to do a rename and fix Makefiles to matc=
h:
=20
> This is part of a larger effort to make life easier for
> embedded Linux developers who are stuck developing on Windows
> or Mac systems; see discussion at

You should actually start an opposite effort:  Make it harder for them,
so it is enough pain to switch to a linux development system.  Please
note, this is my personal opinion - not to be conflicted with the
technical reasons given above.

> - Dan

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--TU+u6i6jrDPzmlWF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFBc8hfXaXGVTD0i/8RAjcFAJ9WBze/ceB0xBR5q6jRqQYPToNNeQCeLKeX
bYf3u3r0hFICPw9b5GAQb3Q=
=nYf1
-----END PGP SIGNATURE-----

--TU+u6i6jrDPzmlWF--
