From: Harald Welte <laforge@netfilter.org>
Subject: Re: [L7-filter-developers] Re: I found what I was looking for l7-filter.sf.net.
Date: Wed, 18 Feb 2004 09:12:04 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040218081204.GK9464@sunbeam.de.gnumonks.org>
References: <20040209224943.27665.qmail@web11906.mail.yahoo.com> <20040215155502.GN15567@sunbeam.de.gnumonks.org> <Pine.LNX.4.60.0402171156160.3450@dsl093-017-216.msp1.dsl.speakeasy.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hl1kWnBARzJiTscN"
Cc: netfilter-devel@lists.netfilter.org,
	l7-filter-developers@lists.sourceforge.net
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Matthew Strait <quadong@users.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.60.0402171156160.3450@dsl093-017-216.msp1.dsl.speakeasy.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--hl1kWnBARzJiTscN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 17, 2004 at 01:44:23PM -0600, Matthew Strait wrote:
> > - I can't see any locking in your code, and I don't think it's SMP safe
>=20
> A question on this.  I've just read through Rusty's Unreliable Guide To
> Locking:
>=20
> http://www.kernel.org/pub/linux/kernel/people/rusty/kernel-locking/
>=20
> I mostly understand, but I'm not quite sure what kind of code the match()
> function is.  I think it's a softirq, which means (by the "Softirq A vs.
> Softirq A" entry in the table in 5.1) that the appropriate spinlock to use
> is spin_lock(), right?  But the only type of spin lock currently used in
> net/ipv4/netfilter/*.c currently is spin_lock_bh(), so I'm not at all sure
> what to do.

Yes, it is softirq context.  The locks you use are either spinlock_t or
rwlock_t's.  netfilter mostly uses rwlocks by it's own macros
(DECLARE_RWLOCK, READ_LOCK/WRITE_LOCK, ...)

> -matthew
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--hl1kWnBARzJiTscN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAMx5UXaXGVTD0i/8RAhllAKCVTGVJPcRopRae8p0VZAHgQ5I+tQCZAenu
0v9Onk2/HPuworOwhCDTPmI=
=TOwJ
-----END PGP SIGNATURE-----

--hl1kWnBARzJiTscN--
