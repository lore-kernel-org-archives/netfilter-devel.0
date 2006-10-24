From: Harald Welte <laforge@netfilter.org>
Subject: Daily svn snapshots now working again (was Re: patch-o-matic-ng
	stopped ?)
Date: Tue, 24 Oct 2006 13:35:51 +0200
Message-ID: <20061024113551.GN6045@sunbeam.de.gnumonks.org>
References: <1265.85.68.10.218.1161688632.squirrel@www.on-fire.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8jNwmpfkpox/fiJK"
Cc: Netfilter Mailinglist <netfilter@lists.netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	technique@on-fire.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Wilfried BARNAVON <wbarnavon@on-fire.net>
Content-Disposition: inline
In-Reply-To: <1265.85.68.10.218.1161688632.squirrel@www.on-fire.net>
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


--8jNwmpfkpox/fiJK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 24, 2006 at 01:17:12PM +0200, Wilfried BARNAVON wrote:
=20
> I was used to test new linux kernels with
> experimental patches for netfilter, and - oh surprise !- the last month
> patch-o-matic-ng archives are more and more little, and finally with a
> null content !

You can find the current patch-o-matic-ng repository at
http://svn.netfilter.org/cgi-bin/viewcvs.cgi/trunk/patch-o-matic-ng/

> What happens ? Is this the end of a centralized and structured
> iptables developpement ? Is there a break in the developpement team ?=20

patch-o-matic[-ng] alwayas was a collection of various contributions
=66rom people around the net, not a form of centralized and structured
development

> Is there a secret replacement of netfilter that justifies this
> carelessness ?=20

nobody is careless.  you just seem to be the first person to report that
problem to me.

> Just a bug in the patch-o-matic-ng "tar-gz" generator ?

Exactly.  It's fixed now, please use the=20
ftp://ftp.netfilter.org/pub/patch-o-matic-ng/snapshot/patch-o-matic-ng-2006=
1024.tar.bz2
snapshot that I just created.

Cheers,

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--8jNwmpfkpox/fiJK
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFFPfqXXaXGVTD0i/8RAsSCAJ9Zg+EkGFGQzm73SC88aG/wpoDX+gCdEO1C
1mjmbDwWKfFlsexot92GwxM=
=Itfn
-----END PGP SIGNATURE-----

--8jNwmpfkpox/fiJK--
