From: Harald Welte <laforge@gnumonks.org>
Subject: Re: iptables match kernel module
Date: Mon, 4 Nov 2002 12:07:18 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021104120718.P8635@sunbeam.de.gnumonks.org>
References: <20021102221052.52974370.ury@bofh.homeunix.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oRLcDnkiRZ3/kSWh"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Ury N. Stankevich <ury@bofh.homeunix.org>
Content-Disposition: inline
In-Reply-To: <20021102221052.52974370.ury@bofh.homeunix.org>; from ury@bofh.homeunix.org on Sat, Nov 02, 2002 at 10:10:52PM +0200
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--oRLcDnkiRZ3/kSWh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 02, 2002 at 10:10:52PM +0200, Ury N. Stankevich wrote:
> hello,
> i m trying to create iptables module to match loadavg.
> while create kernel module so easy, but how can i take access to
> 'avenrun' kernel variable?
>=20
> (module failed to load with ipt_load.o: unresolved symbol avenrun)

The 'avenrun' variable is not exported by whoever has created it. You will
need to use the EXPORT_SYMBOL() macro in the respective source file where
avenrun is defined - unless there is another [public] API to get information
about the load average.

BTW: What are you trying to achieve?  Ovrall system load is not important
for packet filtering.  Way more important would be the CPU utilization,
the packets-per-second rate, ...

> __Ury

--=20
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--oRLcDnkiRZ3/kSWh
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9xlTlXaXGVTD0i/8RAjvfAJwL2OrnNrKdb0YOXXFUjUx1cX9CDgCfaqHm
/nTx0qEVGowiLWGGc55TnHw=
=qqDQ
-----END PGP SIGNATURE-----

--oRLcDnkiRZ3/kSWh--
