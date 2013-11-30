From: Eric Leblond <eric@regit.org>
Subject: [nft PATCH] add support for queue target
Date: Sat, 30 Nov 2013 11:52:02 +0100
Message-ID: <1385808722.4321.19.camel@ice-age2.regit.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-uEhd+WLSU/yRei2hH0U8"
Cc: Netfilter Devel <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:38729 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158Ab3K3KwP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 30 Nov 2013 05:52:15 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-uEhd+WLSU/yRei2hH0U8
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable

Hello,

To follow is a series of patches for kernel, libnftables and nftables
which bring nfnetlink queue support to nftables.

Kernel patches:
 include/uapi/linux/netfilter/nf_tables.h |  21 ++++
 net/netfilter/Kconfig                    |   9 ++
 net/netfilter/Makefile                   |   1 +
 net/netfilter/nf_tables_core.c           |   5 +-
 net/netfilter/nft_queue.c                | 189 +++++++++++++++++++++++++++=
++++
 5 files changed, 224 insertions(+), 1 deletion(-)

Libnftables patch:
 include/libnftables/expr.h          |   5 +
 include/linux/netfilter/nf_tables.h |  20 +++
 src/Makefile.am                     |   1 +
 src/expr/queue.c                    | 254 ++++++++++++++++++++++++++++++++=
++++
 tests/Makefile.am                   |   4 +
 tests/nft-expr_queue-test.c         |  99 ++++++++++++++
 6 files changed, 383 insertions(+)

nftables patch:
 include/linux/netfilter/nf_tables.h | 20 ++++++++++++
 include/statement.h                 | 11 +++++++
 src/evaluate.c                      |  2 ++
 src/netlink_delinearize.c           | 15 +++++++++
 src/netlink_linearize.c             | 22 +++++++++++++
 src/parser.y                        | 61 +++++++++++++++++++++++++++++++++=
+---
 src/scanner.l                       |  8 ++++-
 src/statement.c                     | 31 +++++++++++++++++++
 8 files changed, 164 insertions(+), 6 deletions(-)

BR,
--=20
Eric Leblond <eric@regit.org>

--=-uEhd+WLSU/yRei2hH0U8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iD8DBQBSmcNSnxA7CdMWjzIRAnTRAJsHwW6fRgaQ050824c7ByMuQQz/YgCgkrUD
b8p5gtRUfO0uKuVOol3biIA=
=D3pA
-----END PGP SIGNATURE-----

--=-uEhd+WLSU/yRei2hH0U8--

