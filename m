From: pfeiffer.szilard@balabit.hu
Subject: [PATCH] conntrack: made the manual page and help consistent in case of proto option
Date: Thu, 25 Jun 2015 12:11:52 +0200
Message-ID: <1435227112-15500-1-git-send-email-pfeiffer.szilard@balabit.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: pfeiffer.szilard@balabit.hu
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from hq.balabit.com ([195.56.155.161]:35250 "EHLO mail.balabit.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753245AbbFYKMA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Jun 2015 06:12:00 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: Szil=C3=A1rd Pfeiffer <pfeiffer.szilard@balabit.hu>

Signed-off-by: Szil=C3=A1rd Pfeiffer <pfeiffer.szilard@balabit.hu>
---
 conntrack.8     | 2 +-
 src/conntrack.c | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/conntrack.8 b/conntrack.8
index abc26c5..ac82f33 100644
--- a/conntrack.8
+++ b/conntrack.8
@@ -127,7 +127,7 @@ Match only entries whose source address in the repl=
y direction equals the one sp
 .BI "-q, --reply-dst " IP_ADDRESS
 Match only entries whose destination address in the reply direction eq=
uals the one specified as argument.
 .TP
-.BI "-p, --proto " "PROTO "
+.BI "-p, --protocol " "PROTO "
 Specify layer four (TCP, UDP, ...) protocol.
 .TP
 .BI "-f, --family " "PROTO"
diff --git a/src/conntrack.c b/src/conntrack.c
index f6d7d9a..f7d37fb 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -279,7 +279,7 @@ static const char *optflags[NUMBER_OF_OPT] =3D {
 	[CT_OPT_ORIG_DST_BIT]	=3D "dst",
 	[CT_OPT_REPL_SRC_BIT]	=3D "reply-src",
 	[CT_OPT_REPL_DST_BIT]	=3D "reply-dst",
-	[CT_OPT_PROTO_BIT]	=3D "protonum",
+	[CT_OPT_PROTO_BIT]	=3D "protocol",
 	[CT_OPT_TIMEOUT_BIT]	=3D "timeout",
 	[CT_OPT_STATUS_BIT]	=3D "status",
 	[CT_OPT_ZERO_BIT]	=3D "zero",
@@ -322,7 +322,7 @@ static struct option original_opts[] =3D {
 	{"dst", 1, 0, 'd'},
 	{"reply-src", 1, 0, 'r'},
 	{"reply-dst", 1, 0, 'q'},
-	{"protonum", 1, 0, 'p'},
+	{"protocol", 1, 0, 'p'},
 	{"timeout", 1, 0, 't'},
 	{"status", 1, 0, 'u'},
 	{"zero", 0, 0, 'z'},
@@ -502,7 +502,7 @@ static const char usage_parameters[] =3D
 	"  -d, --orig-dst ip\t\tDestination address from original direction\n=
"
 	"  -r, --reply-src ip\t\tSource addres from reply direction\n"
 	"  -q, --reply-dst ip\t\tDestination address from reply direction\n"
-	"  -p, --protonum proto\t\tLayer 4 Protocol, eg. 'tcp'\n"
+	"  -p, --protocol proto\t\tLayer 4 Protocol, eg. 'tcp'\n"
 	"  -f, --family proto\t\tLayer 3 Protocol, eg. 'ipv6'\n"
 	"  -t, --timeout timeout\t\tSet timeout\n"
 	"  -u, --status status\t\tSet status, eg. ASSURED\n"
--=20
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
