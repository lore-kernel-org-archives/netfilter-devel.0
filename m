From: Jan Engelhardt <jengelh@medozas.de>
Subject: libxt_conntrack: dump ctdir
Date: Tue, 11 Nov 2008 15:18:44 +0100 (CET)
Message-ID: <alpine.LNX.1.10.0811111518090.19024@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:55197 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755581AbYKKOSq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 11 Nov 2008 09:18:46 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 9de6f0517f5fef7f18f2e4bba392ed68182e3d47
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Mon Nov 10 18:01:04 2008 +0100

libxt_conntrack: dump ctdir

Sent in as part of a larger private mail by G=C3=A1sp=C3=A1r Lajos
<swifty@freemail.hu>; I cherry-picked the ctdir part.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_conntrack.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/extensions/libxt_conntrack.c b/extensions/libxt_conntrack.=
c
index 987e1af..1e5f141 100644
--- a/extensions/libxt_conntrack.c
+++ b/extensions/libxt_conntrack.c
@@ -879,6 +879,14 @@ matchinfo_print(const void *ip, const struct xt_en=
try_match *match, int numeric,
         	else
                 	printf("%lu:%lu ", sinfo->expires_min, sinfo->expires=
_max);
 	}
+
+	if (sinfo->flags & XT_CONNTRACK_DIRECTION) {
+		if (sinfo->invflags & XT_CONNTRACK_DIRECTION)
+			printf("%sctdir REPLY", optpfx);
+		else
+			printf("%sctdir ORIGINAL", optpfx);
+	}
+
 }
=20
 static void
@@ -976,6 +984,13 @@ conntrack_dump(const struct xt_conntrack_mtinfo1 *=
info, const char *prefix,
 			printf("%u:%u ", (unsigned int)info->expires_min,
 			       (unsigned int)info->expires_max);
 	}
+
+	if (info->match_flags & XT_CONNTRACK_DIRECTION) {
+		if (info->invert_flags & XT_CONNTRACK_DIRECTION)
+			printf("%sctdir REPLY", prefix);
+		else
+			printf("%sctdir ORIGINAL", prefix);
+	}
 }
=20
 static void conntrack_print(const void *ip, const struct xt_entry_matc=
h *match,

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
