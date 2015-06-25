From: pfeiffer.szilard@balabit.hu
Subject: [PATCH] conntrack: made the protocol option value case insensitive
Date: Thu, 25 Jun 2015 12:12:25 +0200
Message-ID: <1435227145-15554-1-git-send-email-pfeiffer.szilard@balabit.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: pfeiffer.szilard@balabit.hu
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from hq.balabit.com ([195.56.155.161]:35685 "EHLO mail.balabit.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751863AbbFYKMa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Jun 2015 06:12:30 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: Szil=C3=A1rd Pfeiffer <pfeiffer.szilard@balabit.hu>

Extensions register protocols by lowercase protocol name, but value of
proto command line option may be uppercase. Extension related options
cannot be used when protocol name comparision fails.

Signed-off-by: Szil=C3=A1rd Pfeiffer <pfeiffer.szilard@balabit.hu>
---
 src/conntrack.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/src/conntrack.c b/src/conntrack.c
index f7d37fb..b1a2589 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -555,6 +555,12 @@ static struct ctproto_handler *findproto(char *nam=
e, int *pnum)
 	/* using the protocol name for an unsupported protocol? */
 	if ((pent =3D getprotobyname(name))) {
 		*pnum =3D pent->p_proto;
+		list_for_each_entry(cur, &proto_list, head) {
+			if (cur->protonum =3D=3D pent->p_proto) {
+				*pnum =3D cur->protonum;
+				return cur;
+			}
+		}
 		return &ct_proto_unknown;
 	}
 	/* using a protocol number? */
--=20
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
