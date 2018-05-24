From: Mark Brown <broonie@kernel.org>
Subject: linux-next: manual merge of the netfilter-next tree with the
 netfilter tree
Date: Thu, 24 May 2018 17:19:02 +0100
Message-ID: <20180524161902.GZ4828@sirena.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="RGnAp+RkZMffi58C"
Cc: Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        NetFilter <netfilter-devel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


--RGnAp+RkZMffi58C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the netfilter-next tree got a conflict in:

  net/netfilter/core.c

between commit:

  25fd386e0bc065849 ("netfilter: core: add missing __rcu annotation")

=66rom the netfilter tree and commit:

  2c205dd3981f79cef ("netfilter: add struct nf_nat_hook and use it")

=66rom the netfilter-next tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

diff --cc net/netfilter/core.c
index 206fb2c4c319,e0ae4aae96f5..000000000000
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@@ -580,13 -611,7 +611,8 @@@ const struct nf_conntrack_zone nf_ct_zo
  EXPORT_SYMBOL_GPL(nf_ct_zone_dflt);
  #endif /* CONFIG_NF_CONNTRACK */
 =20
- #ifdef CONFIG_NF_NAT_NEEDED
- void (*nf_nat_decode_session_hook)(struct sk_buff *, struct flowi *);
- EXPORT_SYMBOL(nf_nat_decode_session_hook);
- #endif
-=20
 -static void __net_init __netfilter_net_init(struct nf_hook_entries **e, i=
nt max)
 +static void __net_init
 +__netfilter_net_init(struct nf_hook_entries __rcu **e, int max)
  {
  	int h;
 =20

--RGnAp+RkZMffi58C
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAlsG5fUACgkQJNaLcl1U
h9BN8wf+IVcMrcMA4ND9qi4tLCsDQTmXVIPSQuIpuM+UlT2LhYmrpiWdRn2Tw5Kj
h4gD8YTMxERppNLkJbSl2yg/qcJ0Zo3vlnd1TM174g7ny4VD4w6PxYEqw49ovqLu
y5w0i1YkHpbHhy4QvWWgsJwGIzeVHe4Ikv4DLxwHALMm1Nr/UnK0v3CM1UzQN8z4
Rv3vYxWjWOdyv75tTZrqqMxk/QF2qU2Hlg5P5dFLXnNPQUUT30zcOguvUC4jTR1n
Jg3Jsl+qzPcbf38kcQ+iMdR5x6p4NSW46iPRlFCUYq6Tx2U7W/iSm11UxDCCz8ab
YMTCRdplwxsoqFspnFSuap9SFBD4MQ==
=+lEi
-----END PGP SIGNATURE-----

--RGnAp+RkZMffi58C--
