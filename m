From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] iptables: Fix connlabel.conf install location
Date: Mon, 10 Jun 2013 05:35:44 -0400
Message-ID: <20130610093544.GA31559@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="2oS5YaxWCcQjTEyO"
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pd0-f179.google.com ([209.85.192.179]:43090 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755228Ab3FKRFc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 11 Jun 2013 13:05:32 -0400
Received: by mail-pd0-f179.google.com with SMTP id q10so2955485pdj.38
        for <netfilter-devel@vger.kernel.org>; Tue, 11 Jun 2013 10:05:31 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--2oS5YaxWCcQjTEyO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

As reported by Danny Rawlins in bug #828, connlabel.conf is unconditionally
installed in /etc/xtables instead of using prefix set at configure time.  Fix
to use sysconfdir variable.

This closes bugzilla #828.

Phil

Signed-off-by: Phil Oester <kernel@linuxace.com>



--2oS5YaxWCcQjTEyO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-828

diff --git a/Makefile.am b/Makefile.am
index cd008a1..73f1352 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -25,8 +25,8 @@ tarball:
 	rm -Rf /tmp/${PACKAGE_TARNAME}-${PACKAGE_VERSION};
 
 install-data-hook:
-	@mkdir -p -m 755 $(DESTDIR)/etc/xtables/ || :
-	@test -f /etc/xtables/connlabel.conf || $(INSTALL) -m 644 etc/xtables/connlabel.conf $(DESTDIR)/etc/xtables/connlabel.conf || :
+	@mkdir -p -m 755 @sysconfdir@/xtables/ || :
+	@test -f @sysconfdir@/xtables/connlabel.conf || $(INSTALL) -m 644 etc/xtables/connlabel.conf @sysconfdir@/xtables/connlabel.conf || :
 
 config.status: extensions/GNUmakefile.in \
 	include/xtables-version.h.in include/iptables/internal.h.in

--2oS5YaxWCcQjTEyO--
