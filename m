From: Harald Welte <laforge@gnumonks.org>
Subject: Re: use of a state machine compiler in netfilter?
Date: Wed, 30 Oct 2002 09:53:36 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021030095336.T8635@sunbeam.de.gnumonks.org>
References: <Pine.LNX.4.44.0210261452140.16251-100000@ice.ragel.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pw8vfKuzsXn95o6p"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Adrian Thurston <adriant@ragel.ca>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0210261452140.16251-100000@ice.ragel.ca>; from adriant@ragel.ca on Sat, Oct 26, 2002 at 03:11:19PM -0400
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--pw8vfKuzsXn95o6p
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Oct 26, 2002 at 03:11:19PM -0400, Adrian Thurston wrote:
>   I am the author of the Ragel State Machine Compiler
>   (http://www.essemage.com/ragel/). State machines are very useful for
>   matching a large number of diverse patterns very efficiently.
>=20
> This leads me to my question. Would the netfilter project benefit from
> code that built state machines from high-level descriptions of packets
> that would recognise and ultimately route many different types of packets
> on one pass?

Well it is definitely interesting to have something like this.  We currently
have already multiple classification mechanisms:  There is the tc/u32 style=
=20
classifier, there is iptables, the upcoming pkttables, the nf-hipac stuff,.=
..

So (from an academic/educational point of view) it would be great to have
yet another classification mechanism.

However, I cannot promise that any of those will go mainline anytime soon.

> Perhaps you have something like this implemented already?

no, not that I am aware of.

> -Adrian

--=20
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--pw8vfKuzsXn95o6p
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9v54PXaXGVTD0i/8RAi51AKCzeDOKmuIoB9cqhf7/DDFJJUGV3wCdEpXM
G5Fpi3Dyywc+Ks5bfnWVU8U=
=dFbT
-----END PGP SIGNATURE-----

--pw8vfKuzsXn95o6p--
