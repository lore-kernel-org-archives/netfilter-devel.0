From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] Re: hashsize available through /proc was RAM and conntrack performance: first draft of the document is online
Date: Thu, 27 Nov 2003 12:14:04 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031127111404.GD3373@obroa-skai.de.gnumonks.org>
References: <20031028151032.GD726@eychenne.org> <20031103081240.GQ1536@sunbeam.de.gnumonks.org> <20031125153543.GD1082@eychenne.org> <20031125205723.GE2971@obroa-skai.de.gnumonks.org> <20031126034231.GA1044@eychenne.org> <20031126113645.GF3121@obroa-skai.de.gnumonks.org> <20031127041452.GD1084@eychenne.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1LKvkjL3sHcu1TtY"
Cc: Netfilter Development <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Herve Eychenne <rv@wallfire.org>
Content-Disposition: inline
In-Reply-To: <20031127041452.GD1084@eychenne.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--1LKvkjL3sHcu1TtY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 27, 2003 at 05:14:52AM +0100, Herve Eychenne wrote:
> I had a quick look at the existing code in ip_conntrack_core.c.
>=20
> First I would have been happy to write a small patch, but I'm not really a
> kernel guy and register_sysctl_table API seems _completely crappy_ to
> me.

;)

>=20
> So I took the risk to ridiculize myself in public and wrote something, th=
ough,
> the ctl_table... I took NET_IP_CONNTRACK_MAX + 1 =3D 2090 because I could=
 find
> no occurence of 2090 user for sysctl in the whole kernel tree... but it
> seems crappy and hazardous. Who the hell is in charge of ensuring the
> unicity of each sysctl binary entry? Where's the list?

the list is in include/linux/sysctl.h  And sysctl-by-numbers has been
deprecated anyways, nobody should safely assume that sysctl via number
is safe anymore...

> So I didn't even took time to compile the attached patch, but with the he=
lp of
> gods if will hopefully work.

I've written up a patch that ensures it is exported only read-only,
please have a look at
http://cvs.netfilter.org/netfilter/patch-o-matic/pending/76_conntrack_bucke=
t_sysctl.patch

>  Herve

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--1LKvkjL3sHcu1TtY
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/xdx8XaXGVTD0i/8RAhTwAKCzxRlojerv2yWCLiQ6aAtxckAONACgmMrB
Kxp7EovI12RowBSul1keEaA=
=R6y8
-----END PGP SIGNATURE-----

--1LKvkjL3sHcu1TtY--
