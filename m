From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 12/21] libip6t_frag: restore inversion support
Date: Sun, 21 Aug 2011 13:09:27 +0200
Message-ID: <1313924977-8623-13-git-send-email-jengelh@medozas.de>
References: <1313924977-8623-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:38758 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754344Ab1HULJy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 21 Aug 2011 07:09:54 -0400
In-Reply-To: <1313924977-8623-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

--fraglen also was not printed since v1.4.11~26^2~22.

References: Dave T=C3=A4ht via netfilter-devel on 2011-08-20 14:40:11 -=
0700
References: <CAA93jw6mpDL6rLXM+9SpAhafkDdKoSfhAxU8UM87vUqjuzjYJw@mail.g=
mail.com>
Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libip6t_frag.c |   16 ++++++++++++++++
 tests/options-most.rules  |    2 ++
 2 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/extensions/libip6t_frag.c b/extensions/libip6t_frag.c
index 4779386..d8bcaee 100644
--- a/extensions/libip6t_frag.c
+++ b/extensions/libip6t_frag.c
@@ -50,6 +50,22 @@ static void frag_parse(struct xt_option_call *cb)
 	case O_FRAGID:
 		if (cb->nvals =3D=3D 1)
 			fraginfo->ids[1] =3D fraginfo->ids[0];
+		if (cb->invert)
+			fraginfo->invflags |=3D IP6T_FRAG_INV_IDS;
+		/*
+		 * Note however that IP6T_FRAG_IDS is not tested by anything,
+		 * so it is merely here for completeness.
+		 */
+		fraginfo->flags |=3D IP6T_FRAG_IDS;
+		break;
+	case O_FRAGLEN:
+		/*
+		 * As of Linux 3.0, the kernel does not check for
+		 * fraglen at all.
+		 */
+		if (cb->invert)
+			fraginfo->invflags |=3D IP6T_FRAG_INV_LEN;
+		fraginfo->flags |=3D IP6T_FRAG_LEN;
 		break;
 	case O_FRAGRES:
 		fraginfo->flags |=3D IP6T_FRAG_RES;
diff --git a/tests/options-most.rules b/tests/options-most.rules
index 4becc2a..6839d89 100644
--- a/tests/options-most.rules
+++ b/tests/options-most.rules
@@ -144,6 +144,8 @@
 -A matches
 -A matches -m frag --fragid 5:4294967295
 -A matches
+-A matches -m frag ! --fragid 9:10 ! --fraglen 12
+-A matches
 -A matches -m rt --rt-segsleft 1
 -A matches
 -A matches -m rt --rt-segsleft :2
--=20
1.7.3.4

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
