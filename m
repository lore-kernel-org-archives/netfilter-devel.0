From: Harald Welte <laforge@gnumonks.org>
Subject: Re: [PATCH] 2.4.x new amanda conntrack + NAT support
Date: Mon, 31 Mar 2003 17:55:41 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030331155541.GD28962@sunbeam.de.gnumonks.org>
References: <20030330200750.GZ7718@sunbeam.de.gnumonks.org> <20030331.070910.52982765.davem@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NtwzykIc2mflq5ck"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	sfrost@snowman.net
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "David S. Miller" <davem@redhat.com>
Content-Disposition: inline
In-Reply-To: <20030331.070910.52982765.davem@redhat.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--NtwzykIc2mflq5ck
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 31, 2003 at 07:09:10AM -0800, David S. Miller wrote:
>=20
> Harald, what is the state of ipt_recent?  Will I see it soon?

The author (Stephen Frost) has just told me yesterday on IRC that he is
about to release his new version.=20

After he has released it, I will put it in iptables CVS and do some
review+testing.  My guess is that this will take one week.  After that,
I'll push it to you.

--=20
- Harald Welte <laforge@gnumonks.org>               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
Programming is like sex: One mistake and you have to support it your lifeti=
me

--NtwzykIc2mflq5ck
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+iGT9XaXGVTD0i/8RAjdGAJwOZA6cdiZBh/chY/qNv/ajdWNs+wCgkpQy
ar6cpLJwte0s8an9qDTdyJU=
=Qkef
-----END PGP SIGNATURE-----

--NtwzykIc2mflq5ck--
