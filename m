From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: linux-next: build failure after merge of the netfilter-next tree
Date: Mon, 21 Jan 2019 10:36:45 +1100
Message-ID: <20190121103645.0b35e3e4@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/39TvkDYx5Z=SJAGKDz/nWJl"; protocol="application/pgp-signature"
Cc: Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        NetFilter <netfilter-devel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

--Sig_/39TvkDYx5Z=SJAGKDz/nWJl
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the netfilter-next tree, today's linux-next build
(powerpc ppc64_defconfig) failed like this:

ERROR: ".nf_conntrack_invert_icmpv6_tuple" [net/netfilter/nf_conntrack.ko] =
undefined!
ERROR: ".nf_conntrack_icmpv6_packet" [net/netfilter/nf_conntrack.ko] undefi=
ned!
ERROR: ".nf_conntrack_icmpv6_init_net" [net/netfilter/nf_conntrack.ko] unde=
fined!
ERROR: ".icmpv6_pkt_to_tuple" [net/netfilter/nf_conntrack.ko] undefined!
ERROR: ".nf_ct_gre_keymap_destroy" [net/netfilter/nf_conntrack.ko] undefine=
d!

Caused by commit

  a47c54048162 ("netfilter: conntrack: handle builtin l4proto packet functi=
ons via direct calls")
  e2e48b471634 ("netfilter: conntrack: handle icmp pkt_to_tuple helper via =
direct calls")
  197c4300aec0 ("netfilter: conntrack: remove invert_tuple callback")
  2a389de86e4a ("netfilter: conntrack: remove l4proto init and get_net call=
backs")
  e56894356f60 ("netfilter: conntrack: remove l4proto destroy hook")

I have used the netfilter-next tree from next-20190118 for today.

--=20
Cheers,
Stephen Rothwell

--Sig_/39TvkDYx5Z=SJAGKDz/nWJl
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAlxFBg0ACgkQAVBC80lX
0GzwxggAlD/QHSO46gzZjvAbjO5ybAOhCBZ3zslZVI0wx2mmfRC/OkusnwmEjRZz
yF6uLhAvoP3gg+ivv5t1jaHdIGztgZFLIMrTnAs9yaleriUI6l4Hv04MtlywOD8Y
pBqzKymgVsy9TFV/ceAJ0HgbQjxOcquHt1FwWnDZnsN/MbHgwk+fo6QOtN07BnPx
eekr82oPoPI1z7KeZs+nFT/GjeL3zJOgTUuHLUnl8ulQDmjs4U17y1NiTeNtTsI8
xXhfkKz8sUVm+VYzlCnlgIzcCFte1vWrnPxPq0DkJuBjKvr8Yeg09V+TxrFBEPSP
ig043THL9MP7rj4tymRgQIsDdgTCFw==
=glZA
-----END PGP SIGNATURE-----

--Sig_/39TvkDYx5Z=SJAGKDz/nWJl--
