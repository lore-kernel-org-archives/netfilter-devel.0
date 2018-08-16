From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: linux-next: manual merge of the ipvs tree with the netfilter tree
Date: Fri, 17 Aug 2018 07:57:17 +1000
Message-ID: <20180817075717.0bc15438@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/5TmRJ.KLaABcun.uJPlj6uX"; protocol="application/pgp-signature"
Cc: Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matteo Croce <mcroce@redhat.com>
To: Simon Horman <horms@verge.net.au>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        NetFilter <netfilter-devel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

--Sig_/5TmRJ.KLaABcun.uJPlj6uX
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the ipvs tree got a conflict in:

  net/netfilter/ipvs/ip_vs_conn.c

between commit:

  b71ed54dc2a1 ("ipvs: don't show negative times in ip_vs_conn")

from the netfilter tree and commit:

  16e98cec49a4 ("ipvs: don't show negative times in ip_vs_conn")

from the ipvs tree.

I fixed it up (I just used the (updated) version from the netfilter tree)
and can carry the fix as necessary. This is now fixed as far as linux-next
is concerned, but any non trivial conflicts should be mentioned to your
upstream maintainer when your tree is submitted for merging.  You may
also want to consider cooperating with the maintainer of the conflicting
tree to minimise any particularly complex conflicts.

--=20
Cheers,
Stephen Rothwell

--Sig_/5TmRJ.KLaABcun.uJPlj6uX
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAlt18z0ACgkQAVBC80lX
0Gz1Pwf/QCcKsgUXw0F6JPwSF3FkvnAHm925RuiF93sCAePZBfZKy4WkEyfr9KBm
HJOGgeZUnFeH0M9IUPpcYMtQyRaeDErtj7v97zNLSqraYiVPhhzTmIVRIt0dSXvy
l5wkTNv9cnbs6mj1CRBn0gq07lLkEg5mz82k84OAay8gL9NtJZLeX/w2Nh5cwBwa
UfimYk9v3xxqCiLmBvCpZTE6JeeS+7bdFhL+7R2qEc/dORAUb3KrU6LOK7ZR4I3r
FKIKlt5Zrj9zE2ehxmeO5pt2h515AoVrjxso35+FJFMz9KUcgkzvBkTwAHYhAN6x
EhR0zRi+EN8tSiZn0P9uIo4pH76Z6g==
=cijq
-----END PGP SIGNATURE-----

--Sig_/5TmRJ.KLaABcun.uJPlj6uX--
