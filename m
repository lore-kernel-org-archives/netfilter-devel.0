From: Harald Welte <laforge@gnumonks.org>
Subject: Re: iptables u32 match code for review/testing/...
Date: Tue, 7 Jan 2003 19:53:00 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030107185300.GN1353@sunbeam.de.gnumonks.org>
References: <200212271854.gBRIsf131987@isis.cs3-inc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jnYfR+Q8IWTs8BNa"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Don Cohen <don-nf@isis.cs3-inc.com>
Content-Disposition: inline
In-Reply-To: <200212271854.gBRIsf131987@isis.cs3-inc.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--jnYfR+Q8IWTs8BNa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 27, 2002 at 10:54:41AM -0800, Don Cohen wrote:

Ok, here the comments you requested

> /* *** What's this about?
>    Must fit inside union ipt_matchinfo: 16 bytes */

What do you mean by this?=20

> /* *** any way to allow for an arbitrary number of elements?
>    for now I settle for a limit of 10 of each */

no way. At least not with the current kernel/userspace interface :(

--=20
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--jnYfR+Q8IWTs8BNa
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+GyIMXaXGVTD0i/8RAhKhAJ9I6lc2oxc0v+vHT/ffSlRrcqoe+wCfQdMy
KufwMtlAGOZ0pQIZ+AHrqfQ=
=vy5d
-----END PGP SIGNATURE-----

--jnYfR+Q8IWTs8BNa--
