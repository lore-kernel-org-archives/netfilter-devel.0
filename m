From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [iptables PATCH] list: fix prefetch dummy
Date: Mon, 06 Apr 2015 20:05:41 +0200
Message-ID: <20150406180541.7031.97131.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:39951 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752673AbbDFSFt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Apr 2015 14:05:49 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

linux_list.h:381:59: warning: right-hand operand of comma expression has no effect [-Wunused-value]
  for (pos = list_entry((head)->next, typeof(*pos), member), \
                                                           ^
libiptc.c:552:2: note: in expansion of macro 'list_for_each_entry'
  list_for_each_entry(c, &h->chains, list) {
  ^

[ Patch copied from one similar of Patrick McHardy on libnftnl ]

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 libiptc/linux_list.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libiptc/linux_list.h b/libiptc/linux_list.h
index abdcf88..559e33c 100644
--- a/libiptc/linux_list.h
+++ b/libiptc/linux_list.h
@@ -27,7 +27,7 @@
 	1; \
 })
 
-#define prefetch(x)		1
+#define prefetch(x)		((void)0)
 
 /* empty define to make this work in userspace -HW */
 #define smp_wmb()

