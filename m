From: Harald Welte <laforge@netfilter.org>
Subject: Re: Netfilter: Ensuring serial packet delivery to the hooks ?
Date: Mon, 3 Nov 2003 08:45:51 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031103074551.GM1536@sunbeam.de.gnumonks.org>
References: <Pine.SOL.4.56.0310301455410.18298@fiesta>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DV2QSXXe90Wp/UR6"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Michael Jung <michaj@cs.tu-berlin.de>
Content-Disposition: inline
In-Reply-To: <Pine.SOL.4.56.0310301455410.18298@fiesta>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--DV2QSXXe90Wp/UR6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 30, 2003 at 03:10:32PM +0100, Michael Jung wrote:
> So, can I set a global flag when a packet passes PREROUTING or
> LOCALOUT, and then use this flag on hook FORWARD ?
> May be, that at the time between the hooks PREROUTING (or LOCALOUT)
> and FORWARD another packet could come from the network (or process).
> This second packet will be handled regularly by my check routine on
> PREROUTING (or LOCALOUT). This would change the global flag and I
> will loose my first result related to the first packet, which will
> pass FORWARD soon.

no, you would need to associate your flag with the packet (skb).

> My direct question:  Does Netfilter ensure that each packet passes
> all hooks for which it is directed, before the next packet enters
> the hook chain ?

no, luckily it doesn't.  Imagine how scalability and SMP performance
would suck if we did.  You can have any number of packets even
traversing the hooks simultaneously on a SMP system.

> Mic

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--DV2QSXXe90Wp/UR6
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/pgevXaXGVTD0i/8RAiXfAJ9nI5yRzmFNNI89Ku5YwTyj0FMZhACeOXvg
qZVoit5nbyC//Sc2A+Pyvj8=
=hSOf
-----END PGP SIGNATURE-----

--DV2QSXXe90Wp/UR6--
