From: Harald Welte <laforge@gnumonks.org>
Subject: Re: ECN target bug report
Date: Thu, 2 Jan 2003 10:03:26 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030102090326.GM9467@sunbeam.de.gnumonks.org>
References: <3DF1F442.806@istitutocolli.org> <3DF508CA.6000107@istitutocolli.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="e5bfZ/T2xnjpUIbw"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Andrea Rossato <mailing_list@istitutocolli.org>
Content-Disposition: inline
In-Reply-To: <3DF508CA.6000107@istitutocolli.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--e5bfZ/T2xnjpUIbw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 09, 2002 at 10:19:06PM +0100, Andrea Rossato wrote:
> attached you will find 3 patches. the first one is an attempt to prove=20
> the existence of the problem.=20

> the second is just a hack that provides a temporary solution it's just
> a workaround: packets with ec e cwr bits set and good checksum will be
> stripped and checksum recalculated from scratch.

I agree that this is not=20

> The problem, as far as I can see it, could be located in csum_partial=20
> (arch/i386/lib/checksum.S, meaning a platform dependent problem): i'm=20
> not a kernel hacker (i'm a lawyer, a legal scholar actually), but i do=20

hey, usually people say IANAL, but you could say IANAP ;)

> not see any mistake in the way partial checksum is carried out in=20
> tcp_etc_set. anyway checksum after partial or total recalculation=20
> differ. That's a fact. Evidence of the fact  can be gained with the=20
> second patch: in this case the kernel will log the checksum after=20
> partial recalculation and after total recalculation (that means that two=
=20
> calculations will take place). The two values differ!

It's most certainly not a bug in csum_partial(), since this function is
used all over the place, including other targets like TTL and even the
NAT core itself.

I think there is an error in the way I used the function to recalculate
the TCP checksum.  I'll have a look.

> Thanks for your attention.

Thanks for helping us!

> andrea

--=20
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--e5bfZ/T2xnjpUIbw
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+FABeXaXGVTD0i/8RAi7YAJ9eDGrNoKVwYZb9dOKSoo7xhoveYgCglcDQ
suEHClxJIHJMGhfsIcCCmQw=
=1Tjf
-----END PGP SIGNATURE-----

--e5bfZ/T2xnjpUIbw--
