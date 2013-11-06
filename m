From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables-nftables PATCH] nft: arp: Fix a compilation warning
Date: Wed,  6 Nov 2013 13:51:18 +0200
Message-ID: <1383738678-25647-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:24938 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932242Ab3KFLvo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 6 Nov 2013 06:51:44 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This fixes such warning:
xtables-arp.c: In function =E2=80=98check_inverse=E2=80=99:
xtables-arp.c:561:54: attention : declaration of =E2=80=98optind=E2=80=99=
 shadows a
global declaration [-Wshadow]

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 iptables/xtables-arp.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/iptables/xtables-arp.c b/iptables/xtables-arp.c
index 97dbca9..4436bc2 100644
--- a/iptables/xtables-arp.c
+++ b/iptables/xtables-arp.c
@@ -558,16 +558,16 @@ add_command(unsigned int *cmd, const int newcmd, =
const unsigned int othercmds, i
 }
=20
 static int
-check_inverse(const char option[], int *invert, int *optind, int argc)
+check_inverse(const char option[], int *invert, int *optidx, int argc)
 {
 	if (option && strcmp(option, "!") =3D=3D 0) {
 		if (*invert)
 			xtables_error(PARAMETER_PROBLEM,
 				      "Multiple `!' flags not allowed");
 		*invert =3D TRUE;
-		if (optind) {
-			*optind =3D *optind+1;
-			if (argc && *optind > argc)
+		if (optidx) {
+			*optidx =3D *optidx+1;
+			if (argc && *optidx > argc)
 				xtables_error(PARAMETER_PROBLEM,
 					      "no argument following `!'");
 		}
--=20
1.8.4.2

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
