From: Harald Welte <laforge@gnumonks.org>
Subject: Re: [feature request] packet replication for easier NAT
Date: Mon, 14 Oct 2002 13:13:55 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021014131355.K13233@sunbeam.de.gnumonks.org>
References: <20021010173619.65782c29.haferfrost@web.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="O1+DDjaLRatPxzPT"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Matthias Benkmann <haferfrost@web.de>
Content-Disposition: inline
In-Reply-To: <20021010173619.65782c29.haferfrost@web.de>; from haferfrost@web.de on Thu, Oct 10, 2002 at 05:36:19PM +0200
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--O1+DDjaLRatPxzPT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 10, 2002 at 05:36:19PM +0200, Matthias Benkmann wrote:
> This feature (if it can be implemented, I don't know enough about TCP/IP
> and NAT to say for sure) would make NAT a lot more transparent. It would
> lose the firewall aspects but that's no worse than a direct connection.=
=20

It would compromise the little bit of security you have. What happens if
somebody makes one machine listen on all ports? he gets all connections
for everybody. great.

And: every connection attempt would flood your network.  Every syn packet
coming in on the NAT gateway would need to be replicated N times, where N
is the number of machines on the internal network.

> It would fail sometimes (2 programs on different computers picking the
> same port for listening) but in a small home LAN that can be coordinated
> easily.=20

No, it cannot. =20

> On the bright side, this feature should make it possible to use a
> lot of services from behind a NAT router without any additional
> configuration effort.

It is a horrible hack fro administrators who are too lazy to do even the
smallest task.

> MSB

--=20
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--O1+DDjaLRatPxzPT
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9qqbzXaXGVTD0i/8RAi9ZAJ42J7dW/tQKljBHFdCR/bVrTnVG5ACfSIdW
vxKVRpa+sKz8Rdz2kqDp7Bc=
=HhB8
-----END PGP SIGNATURE-----

--O1+DDjaLRatPxzPT--
