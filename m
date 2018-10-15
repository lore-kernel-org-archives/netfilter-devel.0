From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: linux-next: build failure after merge of the netfilter-next tree
Date: Tue, 16 Oct 2018 10:41:25 +1100
Message-ID: <20181016104125.2a299bc5@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/Pz9NZM4HjnQuGcakoiEtXrk"; protocol="application/pgp-signature"
Cc: Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        NetFilter <netfilter-devel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

--Sig_/Pz9NZM4HjnQuGcakoiEtXrk
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the netfilter-next tree, today's linux-next build (x86_64
allmodconfig) failed like this:

net/ipv4/netfilter/ipt_ECN.c: In function 'set_ect_tcp':
net/ipv4/netfilter/ipt_ECN.c:58:28: error: 'IPT_ECN_OP_SET_ECE' undeclared =
(first use in this function); did you mean 'IPT_ECN_OP_MATCH_ECE'?
  if ((!(einfo->operation & IPT_ECN_OP_SET_ECE) ||
                            ^~~~~~~~~~~~~~~~~~
                            IPT_ECN_OP_MATCH_ECE
net/ipv4/netfilter/ipt_ECN.c:58:28: note: each undeclared identifier is rep=
orted only once for each function it appears in
net/ipv4/netfilter/ipt_ECN.c:60:28: error: 'IPT_ECN_OP_SET_CWR' undeclared =
(first use in this function); did you mean 'IPT_ECN_OP_MATCH_CWR'?
      (!(einfo->operation & IPT_ECN_OP_SET_CWR) ||
                            ^~~~~~~~~~~~~~~~~~
                            IPT_ECN_OP_MATCH_CWR
net/ipv4/netfilter/ipt_ECN.c: In function 'ecn_tg':
net/ipv4/netfilter/ipt_ECN.c:84:25: error: 'IPT_ECN_OP_SET_IP' undeclared (=
first use in this function); did you mean 'IPT_ECN_OP_MATCH_IP'?
  if (einfo->operation & IPT_ECN_OP_SET_IP)
                         ^~~~~~~~~~~~~~~~~
                         IPT_ECN_OP_MATCH_IP
net/ipv4/netfilter/ipt_ECN.c:88:26: error: 'IPT_ECN_OP_SET_ECE' undeclared =
(first use in this function); did you mean 'IPT_ECN_OP_MATCH_ECE'?
  if (einfo->operation & (IPT_ECN_OP_SET_ECE | IPT_ECN_OP_SET_CWR) &&
                          ^~~~~~~~~~~~~~~~~~
                          IPT_ECN_OP_MATCH_ECE
net/ipv4/netfilter/ipt_ECN.c:88:47: error: 'IPT_ECN_OP_SET_CWR' undeclared =
(first use in this function); did you mean 'IPT_ECN_OP_MATCH_CWR'?
  if (einfo->operation & (IPT_ECN_OP_SET_ECE | IPT_ECN_OP_SET_CWR) &&
                                               ^~~~~~~~~~~~~~~~~~
                                               IPT_ECN_OP_MATCH_CWR
net/ipv4/netfilter/ipt_ECN.c: In function 'ecn_tg_check':
net/ipv4/netfilter/ipt_ECN.c:101:25: error: 'IPT_ECN_OP_MASK' undeclared (f=
irst use in this function); did you mean 'IPT_ECN_IP_MASK'?
  if (einfo->operation & IPT_ECN_OP_MASK)
                         ^~~~~~~~~~~~~~~
                         IPT_ECN_IP_MASK
net/ipv4/netfilter/ipt_ECN.c:107:27: error: 'IPT_ECN_OP_SET_ECE' undeclared=
 (first use in this function); did you mean 'IPT_ECN_OP_MATCH_ECE'?
  if ((einfo->operation & (IPT_ECN_OP_SET_ECE|IPT_ECN_OP_SET_CWR)) &&
                           ^~~~~~~~~~~~~~~~~~
                           IPT_ECN_OP_MATCH_ECE
net/ipv4/netfilter/ipt_ECN.c:107:46: error: 'IPT_ECN_OP_SET_CWR' undeclared=
 (first use in this function); did you mean 'IPT_ECN_OP_MATCH_CWR'?
  if ((einfo->operation & (IPT_ECN_OP_SET_ECE|IPT_ECN_OP_SET_CWR)) &&
                                              ^~~~~~~~~~~~~~~~~~
                                              IPT_ECN_OP_MATCH_CWR

Caused by commit

  25038aaf0cbf ("UAPI: netfilter: Fix symbol collision issues [ver #2]")

I used the netfilter-next tree from next-20181015 for today.

--=20
Cheers,
Stephen Rothwell

--Sig_/Pz9NZM4HjnQuGcakoiEtXrk
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAlvFJaUACgkQAVBC80lX
0GwDEggAn6sCOZxM6kIdtWt1DY1v8e8/G0KXE+ar4SjwcYytEGHzy/H+D2r2lqfB
JdJen4sKIaEjTdnWomqkNdxTA05dhrkbOH73TV6Vy9TEjGQ/N6il5036cyxhLJ1E
y/SfunckvN5paFyzqC7wyRGcKAAepXWaZLf3ZdYU97PwogTU42aUGPER9Vowd0PX
xYWCgBuMs1qOJ9ogvyxXs2DplMXbmTrYZhCTNnWB1EuSfmIeURmroHHM01otId7V
wz5jCy5OHupkdWaa9pLvkWb4N5dqV6wplgWuDmDbtrSkrw87DHCsotFFV+9ocRbi
OBbD3vw7cSmeO4PYvGdaIv3efTkTAg==
=Xf9r
-----END PGP SIGNATURE-----

--Sig_/Pz9NZM4HjnQuGcakoiEtXrk--
