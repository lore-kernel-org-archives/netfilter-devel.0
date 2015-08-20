From: Arturo Borrero Gonzalez <aborrero@cica.es>
Subject: [conntrack-tools PATCH] list: fix prefetch dummy
Date: Thu, 20 Aug 2015 12:45:20 +0200
Message-ID: <20150820104520.23066.45825.stgit@r2d2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: kaber@trash.net, pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:57212 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751016AbbHTL2S (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Aug 2015 07:28:18 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>

[...]
  CC       conntrack.o
In file included from ../include/conntrack.h:4:0,
                 from conntrack.c:41:
conntrack.c: In function =E2=80=98findproto=E2=80=99:
=2E./include/linux_list.h:385:59: warning: right-hand operand of comma =
expression has no effect [-Wunused-value]
  for (pos =3D list_entry((head)->next, typeof(*pos), member), \
                                                          ^
[...]

The original patch is from Patrick McHardy <kaber@trash.net>.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 include/linux_list.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux_list.h b/include/linux_list.h
index de182a4..efffb91 100644
--- a/include/linux_list.h
+++ b/include/linux_list.h
@@ -29,7 +29,7 @@
 	1; \
 })
=20
-#define prefetch(x)		1
+#define prefetch(x)		((void)0)
=20
 /* empty define to make this work in userspace -HW */
 #ifndef smp_wmb

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
