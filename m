From: Harald Welte <laforge@netfilter.org>
Subject: Re: I write a oracle9 conntrack/nat module
Date: Fri, 26 Dec 2003 08:32:57 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031226073257.GA9391@obroa-skai.de.gnumonks.org>
References: <E8AD17E6-3682-11D8-B808-000A95B170F8@mail.goldenhope.com.cn>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+HP7ph2BbKc20aGI"
Cc: netfilter dev <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: zhongyu <xxx@mail.goldenhope.com.cn>
Content-Disposition: inline
In-Reply-To: <E8AD17E6-3682-11D8-B808-000A95B170F8@mail.goldenhope.com.cn>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--+HP7ph2BbKc20aGI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 25, 2003 at 10:34:48AM +0800, zhongyu wrote:
> it worked for me :-)
> anyone can download it from
> http://www.goldenhope.com.cn/source/050_conntrack_nat_oracle.patch

Thank you very much.  I would really like to integrate that module into
netfilter's patch-o-matic repository.  However, apart from the
'MODULE_LICENSE' statement, the code does not clearly indicate that it
is subiject to the GNU GPL license.

If you could add a small header (like the one you can find on top of
ip_nat_irc.c) to all .c files, that would be great.

Also, may I ask how you learned about the details of the Oracle
protocol?  Is there any documentation about that protocol online, (or
available under an NDA?) - or did you have to reverse engineer the
protocol format?

> happy christmas everyone.

Thank you, too.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--+HP7ph2BbKc20aGI
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/6+QpXaXGVTD0i/8RAjLDAKCFVY2kRaX2D2ZyiVixTc2Ey4cYIACfbxaZ
+sc5nrf7WqCfSjqqWhQdAY4=
=r5m3
-----END PGP SIGNATURE-----

--+HP7ph2BbKc20aGI--
