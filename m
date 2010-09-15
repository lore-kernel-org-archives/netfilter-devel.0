From: Peter Volkov <pva@gentoo.org>
Subject: [patch] arptables respect LDFLAGS
Date: Wed, 15 Sep 2010 17:48:53 +0400
Message-ID: <1284558534.22085.164.camel@tablet>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-KUgtslux2A7K0d0Q/9t6"
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: ebtables-devel@lists.sourceforge.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:56618 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752964Ab0IONut (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Sep 2010 09:50:49 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-KUgtslux2A7K0d0Q/9t6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Hi. The patch in attachment makes arptables respect LDFLAGS. Please,
apply. Thank you.

-- 
Peter.

--=-KUgtslux2A7K0d0Q/9t6
Content-Disposition: attachment; filename="arptables-0.0.3.4-ldflags.patch"
Content-Type: text/x-patch; name="arptables-0.0.3.4-ldflags.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

=== modified file 'Makefile'
--- Makefile	2010-09-15 11:51:49 +0000
+++ Makefile	2010-09-15 11:52:56 +0000
@@ -31,7 +31,7 @@
 	$(CC) $(CFLAGS) -c -o $@ $<
 
 arptables: arptables-standalone.o arptables.o libarptc/libarptc.o $(EXT_OBJS)
-	$(CC) $(CFLAGS) -o $@ $^
+	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^
 
 $(DESTDIR)$(MANDIR)/man8/arptables.8: arptables.8
 	mkdir -p $(@D)


--=-KUgtslux2A7K0d0Q/9t6--

