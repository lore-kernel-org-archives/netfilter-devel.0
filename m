From: Harald Welte <laforge@netfilter.org>
Subject: Re: max ftp conntrack problem
Date: Wed, 5 Nov 2003 09:21:27 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031105082127.GG31614@sunbeam.de.gnumonks.org>
References: <200311051131625.SM00864@zhengcb>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gTtJ75FAzB1T2CN6"
Cc: "netfilter-devel@lists.netfilter.org" <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: zhengchuanbo <zhengcb@netpower.com.cn>
Content-Disposition: inline
In-Reply-To: <200311051131625.SM00864@zhengcb>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--gTtJ75FAzB1T2CN6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 05, 2003 at 11:41:30AM +0800, zhengchuanbo wrote:
>=20
> When we use leapftp to download from ftp server,the connection often=20
> broke for a while in case of large rate. the rate was about 500k.
> When I checked the log on the netfilter gateway, I got the following=20
> message,
>=20
> max number of expected connections 1 of ftp reached for
> 130.18.90.155->159.226.61.190, reusing
>  =20
> I search for the answer,and got the answer that when the server changes
> from active mode to passive mode, this would happen.
> But how to solve the problem?  We tried several ftp tools such as flashfl=
x,
> and it is always the same problem.

This is not an error message.  It is just a notification, that the
previous (PORT) expectation has been replaced by the new (PASV)
expectation.  Nothing to worry about.

> Thanks.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--gTtJ75FAzB1T2CN6
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/qLMHXaXGVTD0i/8RAlb2AJ4+XmteANHwz0oKveLme15j7WdkywCeMkzC
i0jl2M9U2n08Zb12VIOjZqY=
=GNcu
-----END PGP SIGNATURE-----

--gTtJ75FAzB1T2CN6--
