From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: linux-next: build failure after merge of the netfilter-next tree
Date: Wed, 13 Feb 2019 16:54:15 +1100
Message-ID: <20190213165415.5a992838@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/H8=D_/BOxF_SwYAG=cgyHrp"; protocol="application/pgp-signature"
Cc: Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alin Nastac <alin.nastac@gmail.com>,
        Florian Westphal <fw@strlen.de>,
        David Miller <davem@davemloft.net>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        NetFilter <netfilter-devel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

--Sig_/H8=D_/BOxF_SwYAG=cgyHrp
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the netfilter-next tree, today's linux-next build (powerpc
allyesconfig) failed like this:

ld: net/ipv4/netfilter/nf_reject_ipv4.o:(.opd+0x78): multiple definition of=
 `nf_reject_verify_csum'; net/netfilter/nft_reject_inet.o:(.opd+0x78): firs=
t defined here
ld: net/ipv4/netfilter/nf_reject_ipv4.o: in function `.nf_reject_verify_csu=
m':
(.text.nf_reject_verify_csum+0x0): multiple definition of `.nf_reject_verif=
y_csum'; net/netfilter/nft_reject_inet.o:(.text.nf_reject_verify_csum+0x0):=
 first defined here
ld: net/ipv4/netfilter/nft_reject_ipv4.o:(.opd+0x48): multiple definition o=
f `nf_reject_verify_csum'; net/netfilter/nft_reject_inet.o:(.opd+0x78): fir=
st defined here
ld: net/ipv4/netfilter/nft_reject_ipv4.o: in function `.nf_reject_verify_cs=
um':
(.text.nf_reject_verify_csum+0x0): multiple definition of `.nf_reject_verif=
y_csum'; net/netfilter/nft_reject_inet.o:(.text.nf_reject_verify_csum+0x0):=
 first defined here
ld: net/ipv4/netfilter/ipt_REJECT.o:(.opd+0x60): multiple definition of `nf=
_reject_verify_csum'; net/netfilter/nft_reject_inet.o:(.opd+0x78): first de=
fined here
ld: net/ipv4/netfilter/ipt_REJECT.o: in function `.nf_reject_verify_csum':
(.text.nf_reject_verify_csum+0x0): multiple definition of `.nf_reject_verif=
y_csum'; net/netfilter/nft_reject_inet.o:(.text.nf_reject_verify_csum+0x0):=
 first defined here
ld: net/ipv6/netfilter/nf_reject_ipv6.o:(.opd+0x78): multiple definition of=
 `nf_reject_verify_csum'; net/netfilter/nft_reject_inet.o:(.opd+0x78): firs=
t defined here
ld: net/ipv6/netfilter/nf_reject_ipv6.o: in function `.nf_reject_verify_csu=
m':
(.text.nf_reject_verify_csum+0x0): multiple definition of `.nf_reject_verif=
y_csum'; net/netfilter/nft_reject_inet.o:(.text.nf_reject_verify_csum+0x0):=
 first defined here
ld: net/ipv6/netfilter/nft_reject_ipv6.o:(.opd+0x48): multiple definition o=
f `nf_reject_verify_csum'; net/netfilter/nft_reject_inet.o:(.opd+0x78): fir=
st defined here
ld: net/ipv6/netfilter/nft_reject_ipv6.o: in function `.nf_reject_verify_cs=
um':
(.text.nf_reject_verify_csum+0x0): multiple definition of `.nf_reject_verif=
y_csum'; net/netfilter/nft_reject_inet.o:(.text.nf_reject_verify_csum+0x0):=
 first defined here
ld: net/ipv6/netfilter/ip6t_REJECT.o:(.opd+0x60): multiple definition of `n=
f_reject_verify_csum'; net/netfilter/nft_reject_inet.o:(.opd+0x78): first d=
efined here
ld: net/ipv6/netfilter/ip6t_REJECT.o: in function `.nf_reject_verify_csum':
(.text.nf_reject_verify_csum+0x0): multiple definition of `.nf_reject_verif=
y_csum'; net/netfilter/nft_reject_inet.o:(.text.nf_reject_verify_csum+0x0):=
 first defined here
ld: net/bridge/netfilter/nft_reject_bridge.o:(.opd+0x108): multiple definit=
ion of `nf_reject_verify_csum'; net/netfilter/nft_reject_inet.o:(.opd+0x78)=
: first defined here
ld: net/bridge/netfilter/nft_reject_bridge.o: in function `.nf_reject_verif=
y_csum':
(.text.nf_reject_verify_csum+0x0): multiple definition of `.nf_reject_verif=
y_csum'; net/netfilter/nft_reject_inet.o:(.text.nf_reject_verify_csum+0x0):=
 first defined here

Caused by commit

  bfcf40da7559 ("netfilter: reject: skip csum verification for protocols th=
at don't support it")

I have reverted that commit for today.



--=20
Cheers,
Stephen Rothwell

--Sig_/H8=D_/BOxF_SwYAG=cgyHrp
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAlxjsQcACgkQAVBC80lX
0GxC8wf+MmMGIH9mmr0wQOs8NTy3WJcrktXmDoZjBkv8gAwNOen7TkzmfjddeDT9
Z6jYcPQ6pnBSZyCif0UORURYJMGPQMCtvIwKGnHMno5d4rAR5fkbwDsNdbFwBs+S
ldZ/8nm7/UrS6N7E4l1jLgyhnukTn3DKYqBlDK2tLHP+hRFHW9E8P4bEVjW55R65
e2E7Nt2791qeRQu46aO+BCiKsP8D5L10qkcvSDu3q5p4gsGAj0+P8dsT3UHlLPjO
yiIVgLc9sMHWu0Q//EL/XEd/z7I62tYNOZ1n9Rx1UGSEH75tCFn95/XeuT+GfEP0
t/8w9w5iWM6kfXBSBRepaBns4C91bg==
=FgFO
-----END PGP SIGNATURE-----

--Sig_/H8=D_/BOxF_SwYAG=cgyHrp--
