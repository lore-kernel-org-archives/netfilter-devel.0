From: Harald Welte <laforge@gnumonks.org>
Subject: Re: MARK bit operations patch #2
Date: Wed, 15 Jan 2003 00:53:11 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030114235311.GO18686@sunbeam.de.gnumonks.org>
References: <3E240801.8080801@fugmann.dhs.org> <20030114211436.GL18686@sunbeam.de.gnumonks.org> <3E24811C.7000604@fugmann.dhs.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sMkrXc3gAYLRVOjR"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Anders Fugmann <afu@fugmann.dhs.org>
Content-Disposition: inline
In-Reply-To: <3E24811C.7000604@fugmann.dhs.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--sMkrXc3gAYLRVOjR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 14, 2003 at 10:29:00PM +0100, Anders Fugmann wrote:
> My bad, should have said:
> new kernel - new userspace: OK
> old kernel - new userspace: OK

> new kernel - old userspace: OK(*)
> * - Only if the new userspace is compiled against the old kernel.

sorry if I am a PITA, but where does the (*) case have new userspace and
old kernel?  Either the first or the second line are wrong.

> >You are assuming that=20
> >
> >IPT_ALIGN(sizeof(struct ipt_mark_target_info))=20
> >	!=3D IPT_ALIGN(sizeof(struct ipt_mark_bitops_target_info))
> >
> >while this may be true on x86, I assume it is different on 64bit
> >plaforms. Do you have access to any ia64/sparc64/ppc64/mips64 machine
> >with linux?

> Unfortunatly not. But why could this introduce an problem on a non x86
> platform? Also do you know where to look for more information on this?

let's assume IPT_ALIGN aligns to 32bit boundaries on a 32bit platform,
and 64bit on 64bit platforms.

now we have an old structure containing a 32bit integer IPT_ALIGN()ed to
32bit.  Then there is a new structure, aligned to 2*32bit =3D=3D 64bit.

on the 64bit platform, the old 32bit structure is already aligned to
64bit.  And the new structure is aligned to 64bit as well.

Resulting in IPT_ALIGN(sizeof(struct ipt_mark_target_info)) bein exactly
the same as IPT_ALIGN(sizeof(struct ipt_mark_bitops_target_info)).

I'm not saying that it really happens right now (I would need to test
it) - but theoretically it is possible.

I'd say you make your final patch and I test it on my sparc64 box.=20

If there are any problems, we have two options

1) assure that IPT_ALIGN(sizeof(struct ipt_mark_bitops_target_info)) is
   way larger than the older structure (resulting in 128bit)

2) find some other way not depending on the size of the structure (which
   would be preferred - but how?)

> I also forgot the manpage update. It will come in the next batch.
> Thanks for the positive feedback.

Thanks for working on this issue.

> Anders Fugmann

--=20
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--sMkrXc3gAYLRVOjR
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+JKLnXaXGVTD0i/8RAtBpAJ9VyInlmMC1uvIvWv2vOHfXH5qCZgCggdp/
29xciNSB93XZ7MiP53zXMcs=
=UjWR
-----END PGP SIGNATURE-----

--sMkrXc3gAYLRVOjR--
