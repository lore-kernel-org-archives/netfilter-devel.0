From: =?UTF-8?q?Asbj=C3=B8rn=20Sloth=20T=C3=B8nnesen?= <ast@fiberby.dk>
Subject: [PATCH conntrack 2/5] conntrack: consolidate filtering
Date: Mon, 25 Jan 2016 11:15:45 +0000
Message-ID: <1453720548-14413-2-git-send-email-ast@fiberby.dk>
References: <1453720548-14413-1-git-send-email-ast@fiberby.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org,
	=?UTF-8?q?Asbj=C3=B8rn=20Sloth=20T=C3=B8nnesen?= <ast@fiberby.dk>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.asbjorn.biz ([185.38.24.25]:38283 "EHLO mail.asbjorn.biz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756058AbcAYLQH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Jan 2016 06:16:07 -0500
In-Reply-To: <1453720548-14413-1-git-send-email-ast@fiberby.dk>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Asbj=C3=B8rn Sloth T=C3=B8nnesen <ast@fiberby.dk>
---
 src/conntrack.c | 57 ++++++++++++++++++++-----------------------------=
--------
 1 file changed, 20 insertions(+), 37 deletions(-)

diff --git a/src/conntrack.c b/src/conntrack.c
index b5a0a13..cb9545b 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -1208,6 +1208,21 @@ filter_nat(const struct nf_conntrack *obj, const=
 struct nf_conntrack *ct)
 	return 0;
 }
=20
+static int
+nfct_filter(struct nf_conntrack *obj, struct nf_conntrack *ct)
+{
+	if (filter_nat(obj, ct) ||
+	    filter_mark(ct) ||
+	    filter_label(ct))
+		return 1;
+
+	if (options & CT_COMPARISON &&
+	    !nfct_cmp(obj, ct, NFCT_CMP_ALL | NFCT_CMP_MASK))
+		return 1;
+
+	return 0;
+}
+
 static int counter;
 static int dump_xml_header_done =3D 1;
=20
@@ -1248,17 +1263,7 @@ static int event_cb(enum nf_conntrack_msg_type t=
ype,
 	unsigned int op_type =3D NFCT_O_DEFAULT;
 	unsigned int op_flags =3D 0;
=20
-	if (filter_nat(obj, ct))
-		return NFCT_CB_CONTINUE;
-
-	if (filter_mark(ct))
-		return NFCT_CB_CONTINUE;
-
-	if (filter_label(ct))
-		return NFCT_CB_CONTINUE;
-
-	if (options & CT_COMPARISON &&
-	    !nfct_cmp(obj, ct, NFCT_CMP_ALL | NFCT_CMP_MASK))
+	if (nfct_filter(obj, ct))
 		return NFCT_CB_CONTINUE;
=20
 	if (output_mask & _O_XML) {
@@ -1303,17 +1308,7 @@ static int dump_cb(enum nf_conntrack_msg_type ty=
pe,
 	unsigned int op_type =3D NFCT_O_DEFAULT;
 	unsigned int op_flags =3D 0;
=20
-	if (filter_nat(obj, ct))
-		return NFCT_CB_CONTINUE;
-
-	if (filter_mark(ct))
-		return NFCT_CB_CONTINUE;
-
-	if (filter_label(ct))
-		return NFCT_CB_CONTINUE;
-
-	if (options & CT_COMPARISON &&
-	    !nfct_cmp(obj, ct, NFCT_CMP_ALL | NFCT_CMP_MASK))
+	if (nfct_filter(obj, ct))
 		return NFCT_CB_CONTINUE;
=20
 	if (output_mask & _O_XML) {
@@ -1349,17 +1344,7 @@ static int delete_cb(enum nf_conntrack_msg_type =
type,
 	unsigned int op_type =3D NFCT_O_DEFAULT;
 	unsigned int op_flags =3D 0;
=20
-	if (filter_nat(obj, ct))
-		return NFCT_CB_CONTINUE;
-
-	if (filter_mark(ct))
-		return NFCT_CB_CONTINUE;
-
-	if (filter_label(ct))
-		return NFCT_CB_CONTINUE;
-
-	if (options & CT_COMPARISON &&
-	    !nfct_cmp(obj, ct, NFCT_CMP_ALL | NFCT_CMP_MASK))
+	if (nfct_filter(obj, ct))
 		return NFCT_CB_CONTINUE;
=20
 	res =3D nfct_query(ith, NFCT_Q_DESTROY, ct);
@@ -1498,7 +1483,8 @@ static int update_cb(enum nf_conntrack_msg_type t=
ype,
 	int res;
 	struct nf_conntrack *obj =3D data, *tmp;
=20
-	if (filter_nat(obj, ct))
+	if (filter_nat(obj, ct) ||
+	    filter_label(ct))
 		return NFCT_CB_CONTINUE;
=20
 	if (nfct_attr_is_set(obj, ATTR_ID) && nfct_attr_is_set(ct, ATTR_ID) &=
&
@@ -1510,9 +1496,6 @@ static int update_cb(enum nf_conntrack_msg_type t=
ype,
 	if (options & CT_OPT_TUPLE_REPL && !nfct_cmp(obj, ct, NFCT_CMP_REPL))
 		return NFCT_CB_CONTINUE;
=20
-	if (filter_label(ct))
-		return NFCT_CB_CONTINUE;
-
 	tmp =3D nfct_new();
 	if (tmp =3D=3D NULL)
 		exit_error(OTHER_PROBLEM, "out of memory");
--=20
2.6.4

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
