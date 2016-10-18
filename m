From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [iptables PATCH] extensions: update Arturo Borrero email address
Date: Tue, 18 Oct 2016 14:12:57 +0200
Message-ID: <147679277738.21015.8819051856802077633.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:38856 "EHLO smtp.cica.es"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752020AbcJRMMy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Oct 2016 08:12:54 -0400
Received: from localhost (unknown [127.0.0.1])
        by smtp.cica.es (Postfix) with ESMTP id DDA8651F21E
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Oct 2016 12:12:51 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
        by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id S6bVTJKVL20M for <netfilter-devel@vger.kernel.org>;
        Tue, 18 Oct 2016 14:12:46 +0200 (CEST)
Received: from nfdev2.cica.es (nfdev2.cica.es [IPv6:2a00:9ac0:c1ca:31::221])
        (Authenticated sender: servers@cica.es)
        by smtp.cica.es (Postfix) with ESMTP id 8573051F277
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Oct 2016 14:12:45 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Arturo Borrero Gonzalez <arturo@debian.org>

The email address has changed, let's update it.

Signed-off-by: Arturo Borrero Gonzalez <arturo@debian.org>
---
 extensions/libarpt_mangle.c |    2 +-
 extensions/libebt_802_3.c   |    2 +-
 extensions/libebt_ip.c      |    2 +-
 extensions/libebt_limit.c   |    2 +-
 extensions/libebt_mark.c    |    2 +-
 extensions/libebt_mark_m.c  |    2 +-
 extensions/libebt_nflog.c   |    2 +-
 7 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/extensions/libarpt_mangle.c b/extensions/libarpt_mangle.c
index 03c31a9..ec9b543 100644
--- a/extensions/libarpt_mangle.c
+++ b/extensions/libarpt_mangle.c
@@ -1,5 +1,5 @@
 /*
- * Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com> adapted
+ * Arturo Borrero Gonzalez <arturo@debian.org> adapted
  * this code to libxtables for arptables-compat in 2015
  */
 
diff --git a/extensions/libebt_802_3.c b/extensions/libebt_802_3.c
index 3c4a1c3..f05d02e 100644
--- a/extensions/libebt_802_3.c
+++ b/extensions/libebt_802_3.c
@@ -5,7 +5,7 @@
  *
  * May 2003
  *
- * Adapted by Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
+ * Adapted by Arturo Borrero Gonzalez <arturo@debian.org>
  * to use libxtables for ebtables-compat
  */
 
diff --git a/extensions/libebt_ip.c b/extensions/libebt_ip.c
index 8b62876..4ca63e9 100644
--- a/extensions/libebt_ip.c
+++ b/extensions/libebt_ip.c
@@ -9,7 +9,7 @@
  *    Innominate Security Technologies AG <mhopf@innominate.com>
  *    September, 2002
  *
- * Adapted by Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
+ * Adapted by Arturo Borrero Gonzalez <arturo@debian.org>
  * to use libxtables for ebtables-compat in 2015.
  */
 
diff --git a/extensions/libebt_limit.c b/extensions/libebt_limit.c
index c71561c..6b9bb16 100644
--- a/extensions/libebt_limit.c
+++ b/extensions/libebt_limit.c
@@ -8,7 +8,7 @@
  * September, 2003
  *
  * Translated to use libxtables for ebtables-compat in 2015 by
- * Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
+ * Arturo Borrero Gonzalez <arturo@debian.org>
  */
 
 #include <stdio.h>
diff --git a/extensions/libebt_mark.c b/extensions/libebt_mark.c
index 587b4a6..a1a208c 100644
--- a/extensions/libebt_mark.c
+++ b/extensions/libebt_mark.c
@@ -5,7 +5,7 @@
  *
  * July, 2002, September 2006
  *
- * Adapted by Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
+ * Adapted by Arturo Borrero Gonzalez <arturo@debian.org>
  * to use libxtables for ebtables-compat in 2015.
  */
 
diff --git a/extensions/libebt_mark_m.c b/extensions/libebt_mark_m.c
index ef9eb6a..ab9d234 100644
--- a/extensions/libebt_mark_m.c
+++ b/extensions/libebt_mark_m.c
@@ -5,7 +5,7 @@
  *
  * July, 2002
  *
- * Adapted by Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
+ * Adapted by Arturo Borrero Gonzalez <arturo@debian.org>
  * to use libxtables for ebtables-compat in 2015.
  */
 
diff --git a/extensions/libebt_nflog.c b/extensions/libebt_nflog.c
index 72bf372..fef7196 100644
--- a/extensions/libebt_nflog.c
+++ b/extensions/libebt_nflog.c
@@ -10,7 +10,7 @@
  *  libxt_NFLOG.c
  *
  * Adapted to libxtables for ebtables-compat in 2015 by
- * Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
+ * Arturo Borrero Gonzalez <arturo@debian.org>
  */
 
 #include <stdio.h>

