From: Harald Welte <laforge@netfilter.org>
Subject: Re: Fw: segmentation fault with proc cleanup + CLUSTERIP
Date: Sun, 10 Jul 2005 16:14:43 +0200
Message-ID: <20050710141443.GI20465@sunbeam.de.gnumonks.org>
References: <0e9e01c5850a$1f7b5230$5001010a@bluereef.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gd+outVunBU67ahz"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Andrew Hall <temp02@bluereef.com.au>
Content-Disposition: inline
In-Reply-To: <0e9e01c5850a$1f7b5230$5001010a@bluereef.local>
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


--gd+outVunBU67ahz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jul 10, 2005 at 02:44:57PM +1000, Andrew Hall wrote:
> This is happening now quite a lot. It's a bit hit and miss but seems
> to happen whenever the cluster entry is removed. My guess this that
> the data the proc entry is referrencing is being read at the time that
> it is being removed. Do we need a lock here?

So what kind of userspace application are you using?  How frequently is
that entry read?

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--gd+outVunBU67ahz
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFC0S1TXaXGVTD0i/8RAkgrAKCo0Vm+pmNvJK9903WwSQMIolB+gQCfes/t
vz20Gb+Kv8dTTG4Ykdob8+Y=
=HThG
-----END PGP SIGNATURE-----

--gd+outVunBU67ahz--
