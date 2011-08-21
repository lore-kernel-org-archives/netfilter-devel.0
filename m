From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 17/21] libxt_owner: restore inversion support
Date: Sun, 21 Aug 2011 13:09:32 +0200
Message-ID: <1313924977-8623-18-git-send-email-jengelh@medozas.de>
References: <1313924977-8623-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:38759 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754418Ab1HULJ6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 21 Aug 2011 07:09:58 -0400
In-Reply-To: <1313924977-8623-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Bug origin is in commit v1.4.11~16^2~7.

References: Dave T=C3=A4ht via netfilter-devel on 2011-08-20 14:40:11 -=
0700
References: <CAA93jw6mpDL6rLXM+9SpAhafkDdKoSfhAxU8UM87vUqjuzjYJw@mail.g=
mail.com>
Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_owner.c |    3 ++-
 tests/options-most.rules |    1 +
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/extensions/libxt_owner.c b/extensions/libxt_owner.c
index d2fdfa9..d9adc12 100644
--- a/extensions/libxt_owner.c
+++ b/extensions/libxt_owner.c
@@ -129,7 +129,8 @@ static const struct xt_option_entry owner_mt_opts[]=
 =3D {
 	 .flags =3D XTOPT_INVERT},
 	{.name =3D "gid-owner", .id =3D O_GROUP, .type =3D XTTYPE_STRING,
 	 .flags =3D XTOPT_INVERT},
-	{.name =3D "socket-exists", .id =3D O_SOCK_EXISTS, .type =3D XTTYPE_N=
ONE},
+	{.name =3D "socket-exists", .id =3D O_SOCK_EXISTS, .type =3D XTTYPE_N=
ONE,
+	 .flags =3D XTOPT_INVERT},
 	XTOPT_TABLEEND,
 };
=20
diff --git a/tests/options-most.rules b/tests/options-most.rules
index cd6aab8..37aeabf 100644
--- a/tests/options-most.rules
+++ b/tests/options-most.rules
@@ -57,6 +57,7 @@
 -A INPUT -p mobility
 -A INPUT -p mobility -m mh --mh-type 3
 -A OUTPUT -m owner --socket-exists --uid-owner 1-2 --gid-owner 2-3
+-A OUTPUT -m owner ! --socket-exists ! --uid-owner 0 ! --gid-owner 0
 -A matches -m connbytes --connbytes 1 --connbytes-mode bytes --connbyt=
es-dir both
 -A matches
 -A matches -m connbytes --connbytes :2 --connbytes-mode bytes --connby=
tes-dir both
--=20
1.7.3.4

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
