From: =?UTF-8?q?Carlos=20Falgueras=20Garc=C3=ADa?= <carlosfg@riseup.net>
Subject: [PATCH libmnl] nlmsg: Improve payload printing
Date: Wed,  8 Jun 2016 11:17:57 +0200
Message-ID: <1465377477-6436-1-git-send-email-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:36686 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423107AbcFHJSG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Jun 2016 05:18:06 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It make more sense to use "isprint" than "isalnum" because we use non
alphanumeric characters like '%', '_', etc. And, in case of non printab=
le
character, print a space is preferable to print a NULL (0) in order to =
keep
alignment.

Before:
=2E..
|00012|--|00002|	|len |flags| type|
| 5f 5f 73 65  |	|      data      |	   s e
| 74 25 64 00  |	|      data      |	 t  d
=2E..

After:
=2E..
|00012|--|00002|	|len |flags| type|
| 5f 5f 73 65  |	|      data      |	 _ _ s e
| 74 25 64 00  |	|      data      |	 t % d
=2E..

Signed-off-by: Carlos Falgueras Garc=C3=ADa <carlosfg@riseup.net>
---
 src/nlmsg.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/src/nlmsg.c b/src/nlmsg.c
index fd2f698..5dfbd88 100644
--- a/src/nlmsg.c
+++ b/src/nlmsg.c
@@ -317,10 +317,10 @@ mnl_nlmsg_fprintf_payload(FILE *fd, const struct =
nlmsghdr *nlh,
 				0xff & b[i+2],	0xff & b[i+3]);
 			fprintf(fd, "|      data      |");
 			fprintf(fd, "\t %c %c %c %c\n",
-				isalnum(b[i]) ? b[i] : 0,
-				isalnum(b[i+1]) ? b[i+1] : 0,
-				isalnum(b[i+2]) ? b[i+2] : 0,
-				isalnum(b[i+3]) ? b[i+3] : 0);
+				isprint(b[i]) ? b[i] : ' ',
+				isprint(b[i+1]) ? b[i+1] : ' ',
+				isprint(b[i+2]) ? b[i+2] : ' ',
+				isprint(b[i+3]) ? b[i+3] : ' ');
 		}
 	}
 	fprintf(fd, "----------------\t------------------\n");
--=20
2.8.2

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
