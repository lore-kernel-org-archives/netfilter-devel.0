From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 04/21] libxt_dccp: fix deprecated intrapositional ordering of !
Date: Sun, 21 Aug 2011 13:09:19 +0200
Message-ID: <1313924977-8623-5-git-send-email-jengelh@medozas.de>
References: <1313924977-8623-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:38726 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754136Ab1HULJn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 21 Aug 2011 07:09:43 -0400
In-Reply-To: <1313924977-8623-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This bug goes back to v1.4.3~63.

References: Dave T=C3=A4ht via netfilter-devel on 2011-08-20 14:40:11 -=
0700
References: <CAA93jw6mpDL6rLXM+9SpAhafkDdKoSfhAxU8UM87vUqjuzjYJw@mail.g=
mail.com>
Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_dccp.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/extensions/libxt_dccp.c b/extensions/libxt_dccp.c
index 0fc5f7d..4de07cc 100644
--- a/extensions/libxt_dccp.c
+++ b/extensions/libxt_dccp.c
@@ -262,13 +262,14 @@ static void dccp_save(const void *ip, const struc=
t xt_entry_match *match)
 	}
=20
 	if (einfo->flags & XT_DCCP_TYPE) {
-		printf(" --dccp-type");
-		print_types(einfo->typemask, einfo->invflags & XT_DCCP_TYPE,0);
+		printf("%s --dccp-type",
+		       einfo->invflags & XT_DCCP_TYPE ? " !" : "");
+		print_types(einfo->typemask, false, 0);
 	}
=20
 	if (einfo->flags & XT_DCCP_OPTION) {
-		printf(" --dccp-option %s%u",
-			einfo->typemask & XT_DCCP_OPTION ? "! " : "",
+		printf("%s --dccp-option %u",
+			einfo->typemask & XT_DCCP_OPTION ? " !" : "",
 			einfo->option);
 	}
 }
--=20
1.7.3.4

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
