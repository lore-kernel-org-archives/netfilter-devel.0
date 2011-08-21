From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 18/21] libxt_physdev: restore inversion support
Date: Sun, 21 Aug 2011 13:09:33 +0200
Message-ID: <1313924977-8623-19-git-send-email-jengelh@medozas.de>
References: <1313924977-8623-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:38775 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754471Ab1HULJ7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 21 Aug 2011 07:09:59 -0400
In-Reply-To: <1313924977-8623-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Bug origin is in commit v1.4.11~26^2~4.

References: Dave T=C3=A4ht via netfilter-devel on 2011-08-20 14:40:11 -=
0700
References: <CAA93jw6mpDL6rLXM+9SpAhafkDdKoSfhAxU8UM87vUqjuzjYJw@mail.g=
mail.com>
Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_physdev.c |    7 ++++---
 tests/options-most.rules   |    2 ++
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/extensions/libxt_physdev.c b/extensions/libxt_physdev.c
index 8f57fe9..a11faf4 100644
--- a/extensions/libxt_physdev.c
+++ b/extensions/libxt_physdev.c
@@ -27,11 +27,12 @@ static const struct xt_option_entry physdev_opts[] =
=3D {
 	 .flags =3D XTOPT_INVERT | XTOPT_PUT, XTOPT_POINTER(s, physindev)},
 	{.name =3D "physdev-out", .id =3D O_PHYSDEV_OUT, .type =3D XTTYPE_STR=
ING,
 	 .flags =3D XTOPT_INVERT | XTOPT_PUT, XTOPT_POINTER(s, physoutdev)},
-	{.name =3D "physdev-is-in", .id =3D O_PHYSDEV_IS_IN, .type =3D XTTYPE=
_NONE},
+	{.name =3D "physdev-is-in", .id =3D O_PHYSDEV_IS_IN, .type =3D XTTYPE=
_NONE,
+	 .flags =3D XTOPT_INVERT},
 	{.name =3D "physdev-is-out", .id =3D O_PHYSDEV_IS_OUT,
-	 .type =3D XTTYPE_NONE},
+	 .type =3D XTTYPE_NONE, .flags =3D XTOPT_INVERT},
 	{.name =3D "physdev-is-bridged", .id =3D O_PHYSDEV_IS_BRIDGED,
-	 .type =3D XTTYPE_NONE},
+	 .type =3D XTTYPE_NONE, .flags =3D XTOPT_INVERT},
 	XTOPT_TABLEEND,
 };
 #undef s
diff --git a/tests/options-most.rules b/tests/options-most.rules
index 37aeabf..c243649 100644
--- a/tests/options-most.rules
+++ b/tests/options-most.rules
@@ -111,6 +111,8 @@
 -A matches
 -A matches -m length --length 5:65535
 -A matches
+-A matches -m physdev ! --physdev-is-in ! --physdev-is-out ! --physdev=
-is-bridged
+-A matches
 -A matches -p tcp -m tcpmss --mss 1
 -A matches
 -A matches -p tcp -m tcpmss --mss :2
--=20
1.7.3.4

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
