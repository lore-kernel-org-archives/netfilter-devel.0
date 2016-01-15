From: =?UTF-8?q?Asbj=C3=B8rn=20Sloth=20T=C3=B8nnesen?= <ast@fiberby.dk>
Subject: [PATCH conntrack 2/2] conntrack: fix expectation entry creation
Date: Fri, 15 Jan 2016 19:47:44 +0000
Message-ID: <1452887264-26064-2-git-send-email-ast@fiberby.dk>
References: <1452887264-26064-1-git-send-email-ast@fiberby.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	pfeiffer.szilard@balabit.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.asbjorn.biz ([185.38.24.25]:55978 "EHLO mail.asbjorn.biz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751236AbcAOTs3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 15 Jan 2016 14:48:29 -0500
In-Reply-To: <1452887264-26064-1-git-send-email-ast@fiberby.dk>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Store tuple-src and tuple-dst in exptuple,
as used by the EXP_CREATE case.

Verified with doc/cli/test.sh

Also reorder the cases, so the netmask case is last.

Reported-by: Szil=C3=A1rd Pfeiffer <pfeiffer.szilard@balabit.hu>
Signed-off-by: Asbj=C3=B8rn Sloth T=C3=B8nnesen <ast@fiberby.dk>
---
 src/conntrack.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/src/conntrack.c b/src/conntrack.c
index 324daf4..45b8822 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -2072,10 +2072,12 @@ int main(int argc, char *argv[])
 		case 'q':
 			nfct_set_addr_from_opt(c, tmpl.ct, &ad, &family);
 			break;
-		case '{':
-		case '}':
 		case '[':
 		case ']':
+			nfct_set_addr_from_opt(c, tmpl.exptuple, &ad, &family);
+			break;
+		case '{':
+		case '}':
 			nfct_set_addr_from_opt(c, tmpl.mask, &ad, &family);
 			break;
 		case 'p':
--=20
2.6.4

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
