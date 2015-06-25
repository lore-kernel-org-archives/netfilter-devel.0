From: pfeiffer.szilard@balabit.hu
Subject: [PATCH 2/2] conntrack: fix expectation entry creation
Date: Thu, 25 Jun 2015 12:22:11 +0200
Message-ID: <1435227731-15872-3-git-send-email-pfeiffer.szilard@balabit.hu>
References: <1435227731-15872-1-git-send-email-pfeiffer.szilard@balabit.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: pfeiffer.szilard@balabit.hu
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from hq.balabit.com ([195.56.155.161]:38979 "EHLO mail.balabit.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932421AbbFYKWP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Jun 2015 06:22:15 -0400
In-Reply-To: <1435227731-15872-1-git-send-email-pfeiffer.szilard@balabit.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: Szil=C3=A1rd Pfeiffer <pfeiffer.szilard@balabit.hu>

Signed-off-by: Szil=C3=A1rd Pfeiffer <pfeiffer.szilard@balabit.hu>
---
 src/conntrack.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/src/conntrack.c b/src/conntrack.c
index 4b22e75..45276f4 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -2063,6 +2063,8 @@ int main(int argc, char *argv[])
 			break;
 		case '{':
 		case '}':
+			nfct_set_addr_from_opt(c, tmpl.exptuple, &ad, &family);
+			break;
 		case '[':
 		case ']':
 			nfct_set_addr_from_opt(c, tmpl.mask, &ad, &family);
--=20
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
