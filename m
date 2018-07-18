From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: linux-next: manual merge of the ipvs-next tree with the
 netfilter-next tree
Date: Wed, 18 Jul 2018 12:04:31 +1000
Message-ID: <20180718120431.68189264@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/s5py6xYsqSWVfpA8CYdG42t"; protocol="application/pgp-signature"
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Simon Horman <horms@verge.net.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

--Sig_/s5py6xYsqSWVfpA8CYdG42t
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Simon,

Today's linux-next merge of the ipvs-next tree got conflicts in:

  net/ipv6/netfilter/Kconfig
  net/netfilter/Kconfig
  net/netfilter/Makefile

caused by commits

66c524acfb51 netfilter: conntrack: remove l3proto abstraction
5a733aa21d2f netfilter: conntrack: remove get_l4proto indirection from l3 p=
rotocol trackers
e33ae98088b4 netfilter: Kconfig: Make NETFILTER_XT_MATCH_SOCKET select NF_S=
OCKET_IPV4/6
35bf1ccecaaa netfilter: Kconfig: Change IPv6 select dependencies

which appear as different commits in the the netfilter-next tree (along
with further changes to these files there).

I fixed it up (I used the netfilter-net tree versions of these files) and
can carry the fix as necessary. Please clean up your tree wrt the
netfilter-next tree.

--=20
Cheers,
Stephen Rothwell

--Sig_/s5py6xYsqSWVfpA8CYdG42t
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAltOoC8ACgkQAVBC80lX
0GzRGgf/Ta8owGnIo1sVmxDMkWaCn24X0i20Jn/gCu3H1VkYL8W/q5eibxFgqU7W
CLXbpDpreMsjy3Jf5lO5+thtrhHPmvIvvkBiuuWfjcM17pPcdtHT+yfySU/iQHzG
tSSyjD5gtve1vbiM7RG6DdeQruz+Pu0ZNlXx17q8aLPPQScoOz26FFaiaRGTOAJs
VaM85Lzs2PiDmytNqVPcxzBpA9YRXoHmjZF2Vk93xRj+hGmIdLoEOS7/Ll4KVD+U
0zRyIFONOwYBBpiN8LMoGX5JR97ghkNrY4r9arGB2GqSDqZBFEjtHa3fhBZ7UDgS
zeSQLAlkzaWFVBWwwqrckBz8zH2aAg==
=n4ju
-----END PGP SIGNATURE-----

--Sig_/s5py6xYsqSWVfpA8CYdG42t--
