From: Arturo Borrero Gonzalez <arturo@debian.org>
Subject: [PATCH] conntrack-tools: update Arturo Borrero Gonzalez email
 address
Date: Tue, 18 Oct 2016 14:08:45 +0200
Message-ID: <147679252544.18787.11953465086620650560.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:56004 "EHLO smtp.cica.es"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753955AbcJRMIm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Oct 2016 08:08:42 -0400
Received: from localhost (unknown [127.0.0.1])
        by smtp.cica.es (Postfix) with ESMTP id AF33E51F2E3
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Oct 2016 12:08:39 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
        by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Wy2zmVntXqlX for <netfilter-devel@vger.kernel.org>;
        Tue, 18 Oct 2016 14:08:33 +0200 (CEST)
Received: from nfdev2.cica.es (nfdev2.cica.es [IPv6:2a00:9ac0:c1ca:31::221])
        (Authenticated sender: servers@cica.es)
        by smtp.cica.es (Postfix) with ESMTP id 9840351F2CA
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Oct 2016 14:08:33 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

My email address has changed, let's update it.

Signed-off-by: Arturo Borrero Gonzalez <arturo@debian.org>
---
 conntrackd.conf.5 |    9 ++++-----
 src/systemd.c     |    2 +-
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/conntrackd.conf.5 b/conntrackd.conf.5
index ed387b9..4a4f2e2 100644
--- a/conntrackd.conf.5
+++ b/conntrackd.conf.5
@@ -1,5 +1,5 @@
 .\"
-.\" (C) Copyright 2015, Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
+.\" (C) Copyright 2015, Arturo Borrero Gonzalez <arturo@debian.org>
 .\"
 .\" %%%LICENSE_START(GPLv2+_DOC_FULL)
 .\" This is free documentation; you can redistribute it and/or
@@ -22,7 +22,7 @@
 .\" <http://www.gnu.org/licenses/>.
 .\" %%%LICENSE_END
 .\"
-.TH CONNTRACKD.CONF 5 "Nov 19, 2015"
+.TH CONNTRACKD.CONF 5 "Oct 18, 2016"
 
 .SH NAME
 conntrackd.conf \- configuration file for conntrackd daemon
@@ -1066,9 +1066,8 @@ General {
 .SH AUTHOR
 Pablo Neira Ayuso wrote and maintains the conntrackd tool.
 
-This manual page was written by Arturo Borrero González
-<arturo.borrero.glez@gmail.com> based on the conntrackd tarball config
-examples.
+This manual page was written by Arturo Borrero Gonzalez <arturo@debian.org>
+based on the conntrackd tarball config examples.
 
 Please send bug reports to <netfilter-devel@lists.netfilter.org>. Subscription is required.
 
diff --git a/src/systemd.c b/src/systemd.c
index 4eb880c..2044da8 100644
--- a/src/systemd.c
+++ b/src/systemd.c
@@ -1,5 +1,5 @@
 /*
- * (C) 2015 by Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
+ * (C) 2015 by Arturo Borrero Gonzalez <arturo@debian.org>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by

