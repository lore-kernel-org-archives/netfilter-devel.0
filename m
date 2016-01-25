From: =?UTF-8?q?Asbj=C3=B8rn=20Sloth=20T=C3=B8nnesen?= <ast@fiberby.dk>
Subject: [PATCH conntrack 1/5] conntrack: support delete by label
Date: Mon, 25 Jan 2016 11:15:44 +0000
Message-ID: <1453720548-14413-1-git-send-email-ast@fiberby.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org,
	=?UTF-8?q?Asbj=C3=B8rn=20Sloth=20T=C3=B8nnesen?= <ast@fiberby.dk>,
	Clemence Faure <clemence.faure@sophos.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.asbjorn.biz ([185.38.24.25]:37226 "EHLO mail.asbjorn.biz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756030AbcAYLQH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Jan 2016 06:16:07 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This option was already silently allowed by 991fc4ae,
but didn't have any effect.

This patch adds the check and documents it.

Cc: Clemence Faure <clemence.faure@sophos.com>
Signed-off-by: Asbj=C3=B8rn Sloth T=C3=B8nnesen <ast@fiberby.dk>
---

Notes:
    I tried to create a test case, as well but I didn't
    seam to be able to get --label-add to work with
    create.

 conntrack.8     | 2 +-
 src/conntrack.c | 3 +++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/conntrack.8 b/conntrack.8
index a981a76..970c2d7 100644
--- a/conntrack.8
+++ b/conntrack.8
@@ -146,7 +146,7 @@ In "\-\-create" mode, the mask is ignored.
 .TP
 .BI "-l, --label " "LABEL"
 Specify a conntrack label.
-This option is only available in conjunction with "\-L, \-\-dump", "\-=
E, \-\-event", or "\-U \-\-update".
+This option is only available in conjunction with "\-L, \-\-dump", "\-=
E, \-\-event", "\-U \-\-update" or "\-D \-\-delete".
 Match entries whose labels match at least those specified.
 Use multiple \-l commands to specify multiple labels that need to be s=
et.
 Match entries whose labels matches at least those specified as argumen=
ts.
diff --git a/src/conntrack.c b/src/conntrack.c
index 45b8822..b5a0a13 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -1355,6 +1355,9 @@ static int delete_cb(enum nf_conntrack_msg_type t=
ype,
 	if (filter_mark(ct))
 		return NFCT_CB_CONTINUE;
=20
+	if (filter_label(ct))
+		return NFCT_CB_CONTINUE;
+
 	if (options & CT_COMPARISON &&
 	    !nfct_cmp(obj, ct, NFCT_CMP_ALL | NFCT_CMP_MASK))
 		return NFCT_CB_CONTINUE;
--=20
2.6.4

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
