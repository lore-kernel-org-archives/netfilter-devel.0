From: pfeiffer.szilard@balabit.hu
Subject: [PATCH v2] conntrack: made the protocol option value case insensitive
Date: Fri,  3 Jul 2015 01:04:58 +0200
Message-ID: <1435878298-7000-1-git-send-email-pfeiffer.szilard@balabit.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?UTF-8?q?Szil=C3=A1rd=20Pfeiffer?= <pfeiffer.szilard@balabit.hu>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from hq.balabit.com ([195.56.155.161]:48305 "EHLO mail.balabit.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754092AbbGBXFD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Jul 2015 19:05:03 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: Szil=C3=A1rd Pfeiffer <pfeiffer.szilard@balabit.hu>

Extensions register protocols by lowercase protocol name, but value of
proto command line option may be uppercase. Extension related options
cannot be used when protocol name comparision fails.

Signed-off-by: Szil=C3=A1rd Pfeiffer <pfeiffer.szilard@balabit.hu>
---
 src/conntrack.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/conntrack.c b/src/conntrack.c
index 368920f..03b294a 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -551,7 +551,7 @@ static struct ctproto_handler *findproto(char *name=
, int *pnum)
=20
 	/* is it in the list of supported protocol? */
 	list_for_each_entry(cur, &proto_list, head) {
-		if (strcmp(cur->name, name) =3D=3D 0) {
+		if (strcasecmp(cur->name, name) =3D=3D 0) {
 			*pnum =3D cur->protonum;
 			return cur;
 		}
--=20
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
