From: Harald Welte <laforge@netfilter.org>
Subject: Re: libiptc - frustrating
Date: Sat, 4 Oct 2003 15:12:57 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031004131257.GT5758@sunbeam.de.gnumonks.org>
References: <3F7C4919.8060800@hhb.bonn.de> <20031002201344.GF5758@sunbeam.de.gnumonks.org> <3F7E872F.5070304@hhb.bonn.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="H3Q1KZ3uZ2WB2VZA"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Karsten =?iso-8859-1?Q?R=F6mke?= <Biermann-Roemke@t-online.de>
Content-Disposition: inline
In-Reply-To: <3F7E872F.5070304@hhb.bonn.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--H3Q1KZ3uZ2WB2VZA
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Oct 04, 2003 at 10:39:11AM +0200, Karsten R=F6mke wrote:

> Is there some memory allocated which is used by the kernel (or somebody=
=20
> else, maybe rustys hamster)? I hope this question isn't to stupid -
> hmm probably it is. If iptables allocates some memory and is
> terminated then the memory should be free'd again by the kernel?

no. There is nothing 'special' about iptables, it's an ordinary
userspace program, adhering to all 'normal' rules.  So there are still
leaks, obviously.  Patches welcome :)

> Slightly off-topic: does somebody know what happens with the memory, if=
=20
> I do a system call like system("iptables ....")? If some memory is
> allocated from iptables and not deallocated again - does the linux
> kernel cares about deallocating this memory.

the iptables process terminates, and all memory is free'd by the kernel.
also just like normal processes.

> Karsten

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--H3Q1KZ3uZ2WB2VZA
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/fsdZXaXGVTD0i/8RAhssAKCDp4PrYHgz5gRFa2vHm3C+kdZI8gCgmjuQ
TsWe0DO42XsRRXF4spnmrrY=
=3aOB
-----END PGP SIGNATURE-----

--H3Q1KZ3uZ2WB2VZA--
