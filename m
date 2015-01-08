From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] build: use -Wno-sign-compare to avoid compilation warning in mini-gmp.c
Date: Thu,  8 Jan 2015 13:30:12 +0100
Message-ID: <1420720212-29867-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: kaber@trash.net, cyrus@openwrt.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49484 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754544AbbAHM13 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 8 Jan 2015 07:27:29 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  CC     mini-gmp.o
mini-gmp.c: In function =E2=80=98mpn_get_str_bits=E2=80=99:
mini-gmp.c:1176:17: warning: comparison between signed and unsigned int=
eger expressions [-Wsign-compare]
mini-gmp.c: In function =E2=80=98mpz_and=E2=80=99:
mini-gmp.c:3650:8: warning: comparison between signed and unsigned inte=
ger expressions [-Wsign-compare]
mini-gmp.c: In function =E2=80=98mpz_ior=E2=80=99:
mini-gmp.c:3723:8: warning: comparison between signed and unsigned inte=
ger expressions [-Wsign-compare]
mini-gmp.c: In function =E2=80=98mpz_xor=E2=80=99:
mini-gmp.c:3792:8: warning: comparison between signed and unsigned inte=
ger expressions [-Wsign-compare]
mini-gmp.c: In function =E2=80=98mpz_set_str=E2=80=99:
mini-gmp.c:4167:17: warning: comparison between signed and unsigned int=
eger expressions [-Wsign-compare]

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/Makefile.am |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/src/Makefile.am b/src/Makefile.am
index 099052a..2410fd3 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -52,6 +52,8 @@ nft_SOURCES +=3D	cli.c
 endif
=20
 if BUILD_MINIGMP
+mini-gmp.o: AM_CFLAGS +=3D -Wno-sign-compare
+
 nft_SOURCES +=3D	mini-gmp.c
 endif
=20
--=20
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
