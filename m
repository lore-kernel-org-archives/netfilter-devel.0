From: Harald Welte <laforge@gnumonks.org>
Subject: Re: Executing NAT and iptables on SUMSUNG S3C4510B
Date: Fri, 10 Jan 2003 14:10:56 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030110131056.GQ1353@sunbeam.de.gnumonks.org>
References: <3E1D44E7.4040205@msa.hinet.net> <3E1D4A17.5040309@wiscore.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kPJUzav3owWaKxsz"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Cheng,Yu-Chin" <jenny@wiscore.com>
Content-Disposition: inline
In-Reply-To: <3E1D4A17.5040309@wiscore.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--kPJUzav3owWaKxsz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 09, 2003 at 06:08:23PM +0800, Cheng,Yu-Chin wrote:
> Jenny Cheng wrote:
>=20
> >
> >Dear all:
> >
> >  I have some problems in executing kernel 2.4.19 image with NAT and=20
> >iptables supported on  SAMSUNG S3C4510b.
> >
> >  Please see the following information  and give me some ideas.
> >  Kernel  about NETWORK configure options and system message.
> >

It seems like you are using ARP tables.  They are experimental and
written by David Miller (davem@redhat.com).

We have never used them and don't even know the userspace configuration
ultilities exist...

> >*Best Regards
> >Jenny
=20

--=20
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--kPJUzav3owWaKxsz
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+HsZgXaXGVTD0i/8RAkEaAKCV4pW0ekgjOpcTmB/5vsoPPYonowCgpRqe
sW1ydroUh/NRdhTfvN2KkGs=
=VVOw
-----END PGP SIGNATURE-----

--kPJUzav3owWaKxsz--
