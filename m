From: Harald Welte <laforge@netfilter.org>
Subject: Re: Question about nf_hookfn
Date: Fri, 10 Oct 2003 22:23:36 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031010202336.GH13456@sunbeam.de.gnumonks.org>
References: <1065798842.17392.38.camel@rade7.s.cs.auc.dk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3ecMC0kzqsE2ddMN"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Emmanuel Fleury <fleury@cs.auc.dk>
Content-Disposition: inline
In-Reply-To: <1065798842.17392.38.camel@rade7.s.cs.auc.dk>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--3ecMC0kzqsE2ddMN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 10, 2003 at 05:14:05PM +0200, Emmanuel Fleury wrote:
> typedef unsigned int nf_hookfn(unsigned int hooknum,
>                                struct sk_buff **skb,
>                                const struct net_device *in,
>                                const struct net_device *out,
>                                int (*okfn)(struct sk_buff *));
>=20
> I got all the other arguments but the last one...
>=20
> What is it for ???

it is the function that gets called if the packet is to continue (i.e. when=
 the
registered function returns NF_ACCEPT).

> Regards
> --=20
> Emmanuel


--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--3ecMC0kzqsE2ddMN
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/hxVIXaXGVTD0i/8RAtTBAJ0WgjJwJcWhsCWszC3iE94jU3lr5QCfTZFZ
Kmg9JxATuBxmMrBC0e8Ebpk=
=j80B
-----END PGP SIGNATURE-----

--3ecMC0kzqsE2ddMN--
