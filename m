From: Harald Welte <laforge@netfilter.org>
Subject: Re: [ANNOUNCE] ipset 2.2.2 released
Date: Sat, 23 Jul 2005 04:00:16 -0400
Message-ID: <20050723080016.GD4219@rama>
References: <Pine.LNX.4.58.0507201133540.25054@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Q0rSlbzrZN6k9QnT"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0507201133540.25054@blackhole.kfki.hu>
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


--Q0rSlbzrZN6k9QnT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 20, 2005 at 11:40:35AM +0200, Jozsef Kadlecsik wrote:
> Hi,
>=20
> I'm happy to announce the new version of ipset. The bugs fixed in this
> release are
>=20
> - Jiffies rollover bug in ip_set_iptree reported and fixed by Rob Nielsen
> - Compiler warning in the non-SMP case (Marcus Sundberg)
> - slab cache names shrunk in order to be compatible with 2.4.* (Marcus
>   Sundberg)
>=20
> New features such that negated set feature or new API elements for better
> external module support were postponed to the next release.

Keep up the good work, Jozsef!

Did you ever think about moving the configuration interface on top of
nfnetlink?=20

I was considering to push for a merge ipset at some close point in the
future, but then re-considered it and asked myself whether we should
really introduce any big new subsystems based on the {set,get}sockopt()
based kernel/usrerspace interface.

Yes, it's probably quite a significant amount of work.. but you get all
the benefits, especially regarding extensibility of the data format,
etc.

What's your thought on this?

Cheers,
	Harald

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--Q0rSlbzrZN6k9QnT
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFC4fkQXaXGVTD0i/8RAjRvAJ9pSPu8GacE3ztFxYvpo2gTd8sw+gCdF8jZ
gz1cFfVTAr9UAGFUIznBc/s=
=zyZC
-----END PGP SIGNATURE-----

--Q0rSlbzrZN6k9QnT--
