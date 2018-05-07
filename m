From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: linux-next: build warning after merge of the netfilter-next tree
Date: Mon, 7 May 2018 10:55:19 +1000
Message-ID: <20180507105519.1d34f19e@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/8uVLuQXPtL_r+dAryLA7MBJ"; protocol="application/pgp-signature"
Cc: Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Fernando Fernandez Mancera <ffmancera@riseup.net>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        NetFilter <netfilter-devel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

--Sig_/8uVLuQXPtL_r+dAryLA7MBJ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the netfilter-next tree, today's linux-next build (x86_64
allmodconfig) produced this warning:

./usr/include/linux/netfilter/nf_osf.h:25: found __[us]{8,16,32,64} type wi=
thout #include <linux/types.h>

Introduced by commit

  bfb15f2a95cb ("netfilter: extract Passive OS fingerprint infrastructure f=
rom xt_osf")

--=20
Cheers,
Stephen Rothwell

--Sig_/8uVLuQXPtL_r+dAryLA7MBJ
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAlrvo/cACgkQAVBC80lX
0GxieQgAi4CHHiG95PCz6z2PsjnoW1KIITozD6mai2UBEaOVK+2IkRkMmm4h6dkb
zdq9VIcVxw7lZ4y5IeXtAdUd+cO/JxtL9ljm5JESznDUYNQK3cBPAALUvD9YGvVr
64UO5kvFfOL7cAt1bRqDWiHWH5orpT+mlqaqAGAXQmOQmC76CLOUd8avYph3M9Eg
Ccbw4rQtpkLgGSKLJruSfPUvAGSXx8hDSTh5Wc27JnFuPCjoQypJNh4mF/fXkjwx
UDSHcCdiqyybODuu+SXItRZTOWguUgGYUTUOHux5DsOZUmetcgayCHwZEhYW6zvm
ZgDkKcr8FcGB14R801P9g4rCb6pnTw==
=GVse
-----END PGP SIGNATURE-----

--Sig_/8uVLuQXPtL_r+dAryLA7MBJ--
