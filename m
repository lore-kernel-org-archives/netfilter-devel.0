From: Harald Welte <laforge@netfilter.org>
Subject: Re: About ipt_dstlimit.c, 2.6.10
Date: Sat, 15 Jan 2005 23:38:19 +0100
Message-ID: <20050115223819.GK9070@sunbeam.de.gnumonks.org>
References: <20050115190719.GD20833@lunik.p0f.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ViWwB84N1zFtNiVD"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Grega Bremec <gregab@p0f.net>
Content-Disposition: inline
In-Reply-To: <20050115190719.GD20833@lunik.p0f.net>
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


--ViWwB84N1zFtNiVD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jan 15, 2005 at 08:07:19PM +0100, Grega Bremec wrote:
> Hello, Harald.

Hi Grega!

> I'm writing to you with regard to latest released pomng and the dstlimit
> match patch, which I was trying to build into the kernel.

dstlimit hast been superseded by hashlimit.  But your locking issue
would be the same with both ;)

> Somehow, it turns out you're using MUST_BE_LOCKED() on a spinlock_t, yet
> 2.6.10 (probably previous releases, maybe one of the patches I applied,
> but it doesn't seem so, after skimming over them) expects all arguments
> to MUST_BE_(READ_|WRITE_|)LOCKED() to be declared with DECLARE_RWLOCK(),
> which is impossible to add to struct, as it initializes as well.

mh. I see. It appears like I never tried to compile the code with
NETFILTER_DEBUG enabled.

The correct fix is to add some macros/functions to lockhelp.h that allow
you to use a spinlock or rwlock within a structure.  This would require
a macro or typedef for the lock itself, and some initialization function
that initializes at runtime, just like the DECLARE_foo_LOCK macros work.

> While my question may be related to any possible fixes to that, it is
> not my primary concern to have that happen irrespective of my actions.
> I was just wondering if you know any macros that can still operate on
> spinlock_t members in 2.6.10, so I can produce the (probably extremely
> tiny) patch myself and send it to you.

I doubt that this code ever compiled with NETFILTER_DEBUG enabled.

>     Grega Bremec

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--ViWwB84N1zFtNiVD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFB6ZtbXaXGVTD0i/8RAudJAJ9/jd1C+ufPW5/ofPur+rF0IjKJtwCgoq1H
e7N6pi890Iw9oIQ/0M2TkZc=
=SwjT
-----END PGP SIGNATURE-----

--ViWwB84N1zFtNiVD--
