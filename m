From: Harald Welte <laforge@gnumonks.org>
Subject: Re: changes in 2.5/2.6 Kernels
Date: Mon, 4 Nov 2002 12:09:09 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021104120909.Q8635@sunbeam.de.gnumonks.org>
References: <3DC14A46.5010506@vt.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="H0flIYUxnzbhZUOY"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Brad Tilley <rtilley@vt.edu>
Content-Disposition: inline
In-Reply-To: <3DC14A46.5010506@vt.edu>; from rtilley@vt.edu on Thu, Oct 31, 2002 at 10:20:38AM -0500
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--H0flIYUxnzbhZUOY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 31, 2002 at 10:20:38AM -0500, Brad Tilley wrote:
> Hello and thanks for a great piece of software!!!

you're welcome :)

> I have been told that there are major changes in netfilter/iptables in=20
> the latest beta kernel 2.5 and that the changes will be made permanent=20
> in the next stable release 2.6

well, there was the planned pkttables change, but unfortunately it didn't
get finished before the kernel freeze.

> My question is, will the command syntax change again (like it did from=20
> ipchains to iptables)? I use iptables daily on routers and I'm very=20
> comfortable with its logic and syntax. If there is going to be a major=20
> change, I'd like to know so I can study the change and test it out.

it doesn't look like those changes will make it in before the next stable
release, so everything will stay the same for some time :(

> R. Bradley Tilley (Brad), System Administrator
--=20
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--H0flIYUxnzbhZUOY
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9xlVVXaXGVTD0i/8RAvN0AJ9dKK7HC8+XOp4uF8T6OUWiGcMGfwCfR+YZ
GHI54lZklifN6XD/Bl9ZQsM=
=2YQ7
-----END PGP SIGNATURE-----

--H0flIYUxnzbhZUOY--
