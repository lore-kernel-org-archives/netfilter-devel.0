From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] fuzzy.patch and fuzzy6.patch.ipv6
Date: Thu, 1 May 2003 13:18:17 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030501111817.GA26924@sunbeam.de.gnumonks.org>
References: <20030430203937.18286.qmail@mail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VbJkn9YxBvnuCH5J"
Cc: cieciwa@alpha.zarz.agh.edu.pl, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Hime Junior <hime@engineer.com>
Content-Disposition: inline
In-Reply-To: <20030430203937.18286.qmail@mail.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 30, 2003 at 03:39:37PM -0500, Hime Junior wrote:
>     I=B4m curious about what "unresolved symbols" are those and why,=20
>  by changing the VALUE of a symbolic constant,the problem vanishes...

Although I do all my development on PowerPC, I have to admit that I
never tested the fuzzy patch.

I suppose the unreslved symbols are with regard to floating point
functions that are not provided by the kernel.

>  OK . The floating point instructions are eliminated by
>  applying this patch .

exactly.  I am not even sure that it was valid to use floating point
instructions at all.  IIRC, the kernel doesn't save the FPU registers,
so if we interrupt an userspace process that uses FPU, we will corrupt
it.  Not sure whether this is still true, and/or this is only valid
within syscall context.

>  The only problem is relative to truncation errors...
> I don=B4t have a PPC to do exaustive tests , but in the simulations that
> I have made , no discrepancies were detected when computing the final
> acceptance rates .

well, the algorithm is going to produce the same results on any
architecture, independent of PPC or not.
>  My opinion is that the primary reason for the change is very weird -
>  "unresolved symbols" - and the solution is even more strange.=20
>  Anyway , I suggest additional investigation about this issue .

I can easily run a test here on my development machine, it's just the
lack of time...

>   Thank you very much .

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--VbJkn9YxBvnuCH5J
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+sQJ5XaXGVTD0i/8RArsPAKCCDbLGHrUTck31a+/pVuw8ial2YACfR9tB
U2679pmaJ2aesbHPrKLUEts=
=4Zq1
-----END PGP SIGNATURE-----

--VbJkn9YxBvnuCH5J--
