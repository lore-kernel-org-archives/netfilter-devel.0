From: Harald Welte <laforge@netfilter.org>
Subject: Re: NuFW port to libnfnetlink_queue
Date: Sun, 28 Aug 2005 13:46:57 +0200
Message-ID: <20050828114657.GD4244@rama.de.gnumonks.org>
References: <1123707250.4996.9.camel@porky>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sgneBHv3152wZ8jf"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Eric Leblond <eric@inl.fr>
Content-Disposition: inline
In-Reply-To: <1123707250.4996.9.camel@porky>
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


--sgneBHv3152wZ8jf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 10, 2005 at 10:54:10PM +0200, Eric Leblond wrote:
> Hi,
>=20
> I've just finished to port NuFW to NFQUEUE.
>=20
> For the moment, only svn is up-to-date but the daily export will soon
> contains this new feature.
> Svn access method is described at :
> 	http://www.nufw.org/-Downloads-.html
>=20
> It seems to work fine and I will soon do some more extensive tests to
> see how it works under some load.=20

Did you yet run those load tests?  Did everything work fine?=20

Also, if you have the time, I would be interested in performance
measurements, comparing ip_queue with nfnetlink_queue.

> I was able to use both nufw and the test program so it is now
> officially possible to have more than on programs using queueing to
> userspace at the same time.

great news!

> Thanks everyone for the good work !

Thank you for testing it :)
--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--sgneBHv3152wZ8jf
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFDEaQwXaXGVTD0i/8RAhHzAJ9Zro3dwuv0DYmHnopnFjhkAVAalwCdEivQ
d6qOG1J8qSOXVS1k3g3IvKs=
=699B
-----END PGP SIGNATURE-----

--sgneBHv3152wZ8jf--
