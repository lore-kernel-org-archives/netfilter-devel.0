From: Harald Welte <laforge@gnumonks.org>
Subject: Re: can netfilter support sql*net?
Date: Mon, 10 Mar 2003 00:21:47 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030309232147.GP324@sunbeam.de.gnumonks.org>
References: <200303071025328.SM01032@zhengcb>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2vfFyZRy2guiefOI"
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: zhengchuanbo <zhengcb@netpower.com.cn>
Content-Disposition: inline
In-Reply-To: <200303071025328.SM01032@zhengcb>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--2vfFyZRy2guiefOI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 07, 2003 at 10:29:22AM +0800, zhengchuanbo wrote:
>=20
> we use oracle server, with sql*net dynamic port(not MTS). i tried to
> find a patch for sql*net,but failed. is there any solution for
> netfilter to support sql*net?

I am not very familiar with the technical details on protocol level of
oracle sql*net.  But if it uses a dynamic port, you would need a
conntrack/nat helper.

We are not aware of any development of such a helper for netfilter.

btw: the list address is no longer @lists.samba.org, but
     @lists.netfilter.org

> chuanbo zheng

--=20
- Harald Welte <laforge@gnumonks.org>               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
Programming is like sex: One mistake and you have to support it your lifeti=
me

--2vfFyZRy2guiefOI
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+a8yLXaXGVTD0i/8RAkHFAJ4uJi46qiC5peI4k7gtQPz5yLPhIQCffcUE
QPx+osDjieq4ctobhCAE7z8=
=SYCl
-----END PGP SIGNATURE-----

--2vfFyZRy2guiefOI--
