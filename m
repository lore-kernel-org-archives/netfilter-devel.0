From: Bryce Lelbach <blelbach@cct.lsu.edu>
Subject: Re: [llvmlinux] [PATCH V2 2/3] Remove VLAIS usage from gadget code
Date: Wed, 5 Dec 2012 17:48:24 -0600
Message-ID: <20121205234822.GB1887@pyxis.br.cox.net>
References: <1351631937-21455-1-git-send-email-behanw@converseincode.com>
 <1351631937-21455-3-git-send-email-behanw@converseincode.com>
 <20121031132838.GQ10998@arwen.pp.htv.fi>
 <509144C0.8000601@converseincode.com>
 <20121101072116.GA32013@arwen.pp.htv.fi>
 <20121203115706.GA4760@breakpoint.cc>
 <50BCF61D.5000707@converseincode.com>
 <20121204222438.GA7624@breakpoint.cc>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mojUlQ0s9EVzWg2t"
Cc: Behan Webster <behanw@converseincode.com>,
	linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
	Felipe Balbi <balbi@ti.com>, netfilter-devel@vger.kernel.org,
	davem@davemloft.net
To: Compiling the Linux Kernel with Clang/LLVM
	<llvmlinux@lists.linuxfoundation.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from newmail.cct.lsu.edu ([130.39.21.13]:52067 "EHLO
	envelope.cct.lsu.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753788Ab2LFARE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 5 Dec 2012 19:17:04 -0500
Content-Disposition: inline
In-Reply-To: <20121204222438.GA7624@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--mojUlQ0s9EVzWg2t
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2012.12.04 23.24, Sebastian Andrzej Siewior wrote:
> > VLAIS is not something they are willing to accept (for various
> > reasons). There are other patches to LLVM that are still working
> Is this not described in C99 6.7.2.1p16?

No, this is not the case - flexible array members are a very different beas=
t,
which are in-and-of-themselves of debatable merit. C99 6.7.2.1p8 explicitly
states that VLAIS are illegal. The same language is present in C11 (same
section):

	A member of a structure or union may have any object type other than a var=
iably
	modified type.

In C99 6.7.5.1p3, the definition of a variably modified type is given:

	.. [snip] ... If the nested sequence of declarators in a full declarator
	contains a variable length array type, the type specified by the full
	declarator is said to be variably modified.

It would require incredible, earth-moving acts for VLAIS to become a part o=
f the
ISO/IEC standard for the C programming language.

P.S. As a general note, while I do agree that it is preferable to rewrite c=
ode
using VLAIS instead of utilizing a macro, I would ask that some reconsidera=
tion
be given, unless there are Linux kernel developers who are willing and able
to implement the necessary rewrites. The LLVMLinux project does not wish to
decrease the code quality of the Linux kernel, and certainly we do not inte=
nd to
cause any GCC breakage.

However, I think that rewrites to all the relevant VLAIS code would be quite
time consuming for the LLVMLinux team, and the proposed macro does not appe=
ar
to me to present any particular evil, other than by nature of being a macro.

If faced between the choice of either accepting this VLAIS patch, or not be=
ing
able to compile the Linux kernel with standard-compliant, largely GCC-compa=
tible
compilers such as Clang and icc, I would think that accepting the VLAIS pat=
ch
would be preferable.

(note also that I have only come in on the end of this thread, and I may ha=
ve
missed part of the context).

--=20
Bryce Adelstein-Lelbach aka wash
STE||AR Group, Center for Computation and Technology, LSU
--
860-808-7497 - Cell
225-578-6182 - Work (no voicemail)
--
stellar.cct.lsu.edu
boost-spirit.com
llvm.linuxfoundation.org
--

--mojUlQ0s9EVzWg2t
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAEBAgAGBQJQv91GAAoJEBLaNmtPI4b80aQH/jhT2LSCzvdFIxdcwwjdiu12
422Izl4TxLIVy/7DOB0NEWcL4rugdURLmhAZy+W7oIKj3fa9JS/crNt2gdLvIO/V
MIJz2mo2bCzSY/ukwTTxCLt3FDNJsQSxS4IjMC0qc47e+mO8Fj26cJ5ninatMzZZ
IMVtjID1qwhopErMvI6sxpOtHH8Okh4YDy5VO1McaSt7sESuu1HXTK8EG137KPT/
oFqGeMxpy7EoKWXthS8/JyHUDRRIvHIXjBHi8OQ5G1qbvInP0hCzoNtI9aglyBtH
XX4ncHM3BZOXF4//hsBdKmX2ZulvX11l0fXlJqqoDNOQFVQaelImnsvpwymngjU=
=UNVU
-----END PGP SIGNATURE-----

--mojUlQ0s9EVzWg2t--
