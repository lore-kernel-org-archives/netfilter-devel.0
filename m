From: Eric Leblond <eric@regit.org>
Subject: [PATCH 1/4] Get rid of SVN tag in comment.
Date: Sat, 19 Jan 2013 10:53:48 +0100
Message-ID: <1358589231-1358-2-git-send-email-eric@regit.org>
References: <1358589231-1358-1-git-send-email-eric@regit.org>
Cc: eric@regit.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:37679 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707Ab3ASJyg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 19 Jan 2013 04:54:36 -0500
In-Reply-To: <1358589231-1358-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch also update some copyright and licence declaration.

Signed-off-by: Eric Leblond <eric@regit.org>
---
 README                                    |    2 --
 doc/ulogd.sgml                            |    2 --
 filter/raw2packet/ulogd_raw2packet_BASE.c |    4 +---
 filter/ulogd_filter_HWHDR.c               |    3 +--
 filter/ulogd_filter_IFINDEX.c             |    4 +---
 filter/ulogd_filter_IP2BIN.c              |    1 -
 filter/ulogd_filter_IP2STR.c              |    3 +--
 filter/ulogd_filter_MARK.c                |    3 +--
 filter/ulogd_filter_PWSNIFF.c             |    2 --
 include/libipulog/libipulog.h             |    2 --
 include/ulogd/addr.h                      |    7 +++++++
 include/ulogd/conffile.h                  |    2 --
 include/ulogd/db.h                        |    7 +++++++
 include/ulogd/ulogd.h                     |    3 +--
 libipulog/libipulog.c                     |    5 ++---
 libipulog/ulog_test.c                     |    3 +--
 output/mysql/ulogd_output_MYSQL.c         |    2 --
 output/pcap/ulogd_output_PCAP.c           |    2 --
 output/ulogd_output_IPFIX.c               |    4 +---
 output/ulogd_output_LOGEMU.c              |    4 +---
 output/ulogd_output_OPRINT.c              |    4 +---
 output/ulogd_output_SYSLOG.c              |    2 --
 src/addr.c                                |    5 +----
 src/conffile.c                            |    3 +--
 src/select.c                              |    7 +------
 src/timer.c                               |    4 +---
 src/ulogd.c                               |    5 ++---
 ulogd.conf.in                             |    1 -
 util/db.c                                 |    3 +--
 util/printflow.c                          |    2 --
 util/printpkt.c                           |    2 --
 31 files changed, 33 insertions(+), 70 deletions(-)

diff --git a/README b/README
index 31549a4..369c264 100644
--- a/README
+++ b/README
@@ -1,7 +1,5 @@
 Userspace logging daemon for netfilter/iptables
 
-$Id$
-
 Project Homepage: http://www.gnumonks.org/projects/ulogd
 Mailinglist: http://lists.gnumonks.org/mailman/listinfo/ulogd/
 
diff --git a/doc/ulogd.sgml b/doc/ulogd.sgml
index 9781e9f..30bfecb 100644
--- a/doc/ulogd.sgml
+++ b/doc/ulogd.sgml
@@ -1,7 +1,5 @@
 <!doctype linuxdoc system>
 
-<!-- $Id$ -->
-
 <article>
 
 <title>ULOGD 2.x - the Netfilter Userspace Logging Daemon</title>
diff --git a/filter/raw2packet/ulogd_raw2packet_BASE.c b/filter/raw2packet/ulogd_raw2packet_BASE.c
index 9ae838d..8a6b4da 100644
--- a/filter/raw2packet/ulogd_raw2packet_BASE.c
+++ b/filter/raw2packet/ulogd_raw2packet_BASE.c
@@ -1,4 +1,4 @@
-/* ulogd_MAC.c, Version $Revision$
+/* ulogd_MAC.c
  *
  * ulogd interpreter plugin for 
  * 	o MAC addresses
@@ -26,8 +26,6 @@
  *  You should have received a copy of the GNU General Public License
  *  along with this program; if not, write to the Free Software
  *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
- 
- * $Id$
  *
  */
 
diff --git a/filter/ulogd_filter_HWHDR.c b/filter/ulogd_filter_HWHDR.c
index 2f266fa..3b095c9 100644
--- a/filter/ulogd_filter_HWHDR.c
+++ b/filter/ulogd_filter_HWHDR.c
@@ -1,4 +1,4 @@
-/* ulogd_filter_HWHDR.c, Version $Revision: 1500 $
+/* ulogd_filter_HWHDR.c
  *
  * ulogd interpreter plugin for HWMAC
  *
@@ -20,7 +20,6 @@
  *  along with this program; if not, write to the Free Software
  *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  *
- * $Id: ulogd_filter_IFINDEX.c 1500 2005-10-03 16:54:02Z laforge $
  */
 
 #include <stdio.h>
diff --git a/filter/ulogd_filter_IFINDEX.c b/filter/ulogd_filter_IFINDEX.c
index 41e556d..3ca5795 100644
--- a/filter/ulogd_filter_IFINDEX.c
+++ b/filter/ulogd_filter_IFINDEX.c
@@ -1,4 +1,4 @@
-/* ulogd_filter_IFINDEX.c, Version $Revision: 1500 $
+/* ulogd_filter_IFINDEX.c
  *
  * ulogd interpreter plugin for ifindex to ifname conversion
  *
@@ -18,8 +18,6 @@
  *  along with this program; if not, write to the Free Software
  *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  *
- * $Id: ulogd_filter_IFINDEX.c 1500 2005-10-03 16:54:02Z laforge $
- *
  */
 
 #include <stdio.h>
diff --git a/filter/ulogd_filter_IP2BIN.c b/filter/ulogd_filter_IP2BIN.c
index 84fe21b..e47eeaf 100644
--- a/filter/ulogd_filter_IP2BIN.c
+++ b/filter/ulogd_filter_IP2BIN.c
@@ -19,7 +19,6 @@
  *  along with this program; if not, write to the Free Software
  *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  *
- * $Id: ulogd_filter_IFINDEX.c 1500 2005-10-03 16:54:02Z laforge $
  */
 
 #include <stdio.h>
diff --git a/filter/ulogd_filter_IP2STR.c b/filter/ulogd_filter_IP2STR.c
index 146c054..44157fe 100644
--- a/filter/ulogd_filter_IP2STR.c
+++ b/filter/ulogd_filter_IP2STR.c
@@ -1,4 +1,4 @@
-/* ulogd_filter_IP2STR.c, Version $Revision: 1500 $
+/* ulogd_filter_IP2STR.c
  *
  * ulogd interpreter plugin for internal IP storage format to string conversion
  *
@@ -19,7 +19,6 @@
  *  along with this program; if not, write to the Free Software
  *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  *
- * $Id: ulogd_filter_IFINDEX.c 1500 2005-10-03 16:54:02Z laforge $
  */
 
 #include <stdio.h>
diff --git a/filter/ulogd_filter_MARK.c b/filter/ulogd_filter_MARK.c
index b113f7d..7807f63 100644
--- a/filter/ulogd_filter_MARK.c
+++ b/filter/ulogd_filter_MARK.c
@@ -1,4 +1,4 @@
-/* ulogd_filter_MARK.c, Version $Revision: 1500 $
+/* ulogd_filter_MARK.c
  *
  * ulogd interpreter plugin for internal IP storage format to string conversion
  *
@@ -19,7 +19,6 @@
  *  along with this program; if not, write to the Free Software
  *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  *
- * $Id: ulogd_filter_IFINDEX.c 1500 2005-10-03 16:54:02Z laforge $
  */
 
 #include <stdio.h>
diff --git a/filter/ulogd_filter_PWSNIFF.c b/filter/ulogd_filter_PWSNIFF.c
index 439a8b3..5169eee 100644
--- a/filter/ulogd_filter_PWSNIFF.c
+++ b/filter/ulogd_filter_PWSNIFF.c
@@ -17,8 +17,6 @@
  *  along with this program; if not, write to the Free Software
  *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  *
- * $Id$
- *
  */
 
 #include <stdio.h>
diff --git a/include/libipulog/libipulog.h b/include/libipulog/libipulog.h
index 1f6aee9..b3c9616 100644
--- a/include/libipulog/libipulog.h
+++ b/include/libipulog/libipulog.h
@@ -1,8 +1,6 @@
 #ifndef _LIBIPULOG_H
 #define _LIBIPULOG_H
 
-/* $Id$ */
-
 #include <errno.h>
 #include <unistd.h>
 #include <fcntl.h>
diff --git a/include/ulogd/addr.h b/include/ulogd/addr.h
index 9c91270..b4432e3 100644
--- a/include/ulogd/addr.h
+++ b/include/ulogd/addr.h
@@ -1,3 +1,10 @@
+/* IP address handling functions
+ *
+ * (C) 2012 by Pablo Neira Ayuso <pablo@netfilter.org>
+ * (C) 2012 by Eric Leblond <eric@regit.org>
+ *
+ * This code is distributed under the terms of GNU GPL version 2 */
+
 #ifndef _ADDR_H
 #define _ADDR_H
 
diff --git a/include/ulogd/conffile.h b/include/ulogd/conffile.h
index aa35809..09eb8cf 100644
--- a/include/ulogd/conffile.h
+++ b/include/ulogd/conffile.h
@@ -2,8 +2,6 @@
  *
  * (C) 2000 by Harald Welte <laforge@gnumonks.org>
  *
- * $Id$
- * 
  * This code is distributed under the terms of GNU GPL */
 
 #ifndef _CONFFILE_H
diff --git a/include/ulogd/db.h b/include/ulogd/db.h
index b0b7295..1c910ff 100644
--- a/include/ulogd/db.h
+++ b/include/ulogd/db.h
@@ -1,3 +1,10 @@
+/* DB handling functions
+ *
+ * (C) 2000-2005 by Harald Welte <laforge@gnumonks.org>
+ *
+ * This code is distributed under the terms of GNU GPL version 2 */
+
+
 #ifndef _ULOGD_DB_H
 #define _ULOGD_DB_H
 
diff --git a/include/ulogd/ulogd.h b/include/ulogd/ulogd.h
index 41c2e9b..90272eb 100644
--- a/include/ulogd/ulogd.h
+++ b/include/ulogd/ulogd.h
@@ -1,6 +1,6 @@
 #ifndef _ULOGD_H
 #define _ULOGD_H
-/* ulogd, Version $Revision$
+/* ulogd
  *
  * userspace logging daemon for netfilter ULOG target
  * of the linux 2.4/2.6 netfilter subsystem.
@@ -9,7 +9,6 @@
  *
  * this code is released under the terms of GNU GPL
  *
- * $Id$
  */
 
 #include <ulogd/linuxlist.h>
diff --git a/libipulog/libipulog.c b/libipulog/libipulog.c
index 2f58ea6..ab28bb4 100644
--- a/libipulog/libipulog.c
+++ b/libipulog/libipulog.c
@@ -1,5 +1,5 @@
-/* 
- * libipulog.c, $Revision$
+/*
+ * libipulog.c
  *
  * netfilter ULOG userspace library.
  *
@@ -21,7 +21,6 @@
  * This library is still under development, so be aware of sudden interface
  * changes
  *
- * $Id$
  */
 
 #include <stdlib.h>
diff --git a/libipulog/ulog_test.c b/libipulog/ulog_test.c
index fd9c925..0665717 100644
--- a/libipulog/ulog_test.c
+++ b/libipulog/ulog_test.c
@@ -1,4 +1,4 @@
-/* ulog_test, $Revision: 1.4 $
+/* ulog_test
  *
  * small testing program for libipulog, part of the netfilter ULOG target
  * for the linux 2.4 netfilter subsystem.
@@ -7,7 +7,6 @@
  *
  * this code is released under the terms of GNU GPL
  *
- * $Id: ulog_test.c,v 1.4 2001/01/30 09:28:04 laforge Exp $
  */
 
 #include <stdio.h>
diff --git a/output/mysql/ulogd_output_MYSQL.c b/output/mysql/ulogd_output_MYSQL.c
index e442e5a..72c080e 100644
--- a/output/mysql/ulogd_output_MYSQL.c
+++ b/output/mysql/ulogd_output_MYSQL.c
@@ -16,8 +16,6 @@
  *  You should have received a copy of the GNU General Public License
  *  along with this program; if not, write to the Free Software
  *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
- * 
- * $Id$
  *
  * 15 May 2001, Alex Janssen <alex@ynfonatic.de>:
  *      Added a compability option for older MySQL-servers, which
diff --git a/output/pcap/ulogd_output_PCAP.c b/output/pcap/ulogd_output_PCAP.c
index 2d3f001..e7798f2 100644
--- a/output/pcap/ulogd_output_PCAP.c
+++ b/output/pcap/ulogd_output_PCAP.c
@@ -17,8 +17,6 @@
  *  along with this program; if not, write to the Free Software
  *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  *
- * $Id$
- *
  */
 
 #include <stdio.h>
diff --git a/output/ulogd_output_IPFIX.c b/output/ulogd_output_IPFIX.c
index 432d37e..761d272 100644
--- a/output/ulogd_output_IPFIX.c
+++ b/output/ulogd_output_IPFIX.c
@@ -1,4 +1,4 @@
-/* ulogd_output_IPFIX.c, Version $Revision: 1628 $
+/* ulogd_output_IPFIX.c
  *
  * ulogd output plugin for IPFIX
  *
@@ -20,8 +20,6 @@
  *  along with this program; if not, write to the Free Software
  *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  *
- * $Id: ulogd_output_LOGEMU.c 1628 2005-11-04 15:23:12Z laforge $
- *
  * TODO:
  * - where to get a useable <sctp.h> for linux ?
  * - implement PR-SCTP (no api definition in draft sockets api)
diff --git a/output/ulogd_output_LOGEMU.c b/output/ulogd_output_LOGEMU.c
index 1d0a7e6..26f139b 100644
--- a/output/ulogd_output_LOGEMU.c
+++ b/output/ulogd_output_LOGEMU.c
@@ -1,4 +1,4 @@
-/* ulogd_LOGEMU.c, Version $Revision$
+/* ulogd_LOGEMU.c
  *
  * ulogd output target for syslog logging emulation
  *
@@ -20,8 +20,6 @@
  *  along with this program; if not, write to the Free Software
  *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  *
- * $Id$
- *
  */
 #include <limits.h>
 #include <stdio.h>
diff --git a/output/ulogd_output_OPRINT.c b/output/ulogd_output_OPRINT.c
index 863859a..e390c84 100644
--- a/output/ulogd_output_OPRINT.c
+++ b/output/ulogd_output_OPRINT.c
@@ -1,4 +1,4 @@
-/* ulogd_MAC.c, Version $Revision$
+/* ulogd_OPRINT.C
  *
  * ulogd output target for logging to a file 
  *
@@ -17,8 +17,6 @@
  *  along with this program; if not, write to the Free Software
  *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  *
- * $Id$
- *
  */
 
 #include <stdio.h>
diff --git a/output/ulogd_output_SYSLOG.c b/output/ulogd_output_SYSLOG.c
index 3bcc637..9777f0f 100644
--- a/output/ulogd_output_SYSLOG.c
+++ b/output/ulogd_output_SYSLOG.c
@@ -19,8 +19,6 @@
  *  along with this program; if not, write to the Free Software
  *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  *
- * $Id$
- *
  */
 
 #include <stdio.h>
diff --git a/src/addr.c b/src/addr.c
index 9a68ed8..2672fab 100644
--- a/src/addr.c
+++ b/src/addr.c
@@ -1,7 +1,4 @@
-/* ulogd
- *
- * userspace logging daemon for the iptables ULOG target
- * of the linux 2.4 netfilter subsystem.
+/* IP address handling functions
  *
  * (C) 2012 by Pablo Neira Ayuso <pablo@netfilter.org>
  * (C) 2012 by Eric Leblond <eric@regit.org>
diff --git a/src/conffile.c b/src/conffile.c
index 8dbd726..dd0ed8f 100644
--- a/src/conffile.c
+++ b/src/conffile.c
@@ -1,9 +1,8 @@
 /* config file parser functions
  *
  * (C) 2000-2005 by Harald Welte <laforge@gnumonks.org>
+ * (C) 2013 by Eric Leblond <eric@regit.org>
  *
- * $Id$
- * 
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License version 2 
  *  as published by the Free Software Foundation
diff --git a/src/select.c b/src/select.c
index aaca517..edb75d5 100644
--- a/src/select.c
+++ b/src/select.c
@@ -1,9 +1,4 @@
-/* ulogd, Version $LastChangedRevision: 476 $
- *
- * $Id: ulogd.c 476 2004-07-23 03:19:35Z laforge $
- *
- * userspace logging daemon for the iptables ULOG target
- * of the linux 2.4 netfilter subsystem.
+/* select related functions
  *
  * (C) 2000-2005 by Harald Welte <laforge@gnumonks.org>
  *
diff --git a/src/timer.c b/src/timer.c
index c4da0a5..5969fb8 100644
--- a/src/timer.c
+++ b/src/timer.c
@@ -1,6 +1,4 @@
-/* ulogd, Version $LastChangedRevision: 476 $
- *
- * $Id: ulogd.c 476 2004-07-23 03:19:35Z laforge $
+/* timer implementation
  *
  * userspace logging daemon for the netfilter subsystem
  *
diff --git a/src/ulogd.c b/src/ulogd.c
index 5693572..d0fdcc5 100644
--- a/src/ulogd.c
+++ b/src/ulogd.c
@@ -1,10 +1,9 @@
-/* ulogd, Version $LastChangedRevision$
- *
- * $Id$
+/* ulogd
  *
  * unified network logging daemon for Linux.
  *
  * (C) 2000-2005 by Harald Welte <laforge@gnumonks.org>
+ * (C) 2013 by Eric Leblond <eric@regit.org>
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License version 2 
diff --git a/ulogd.conf.in b/ulogd.conf.in
index d5db77b..f4f63d9 100644
--- a/ulogd.conf.in
+++ b/ulogd.conf.in
@@ -1,5 +1,4 @@
 # Example configuration for ulogd
-# $Id$
 # Adapted to Debian by Achilleas Kotsis <achille@debian.gr>
 
 [global]
diff --git a/util/db.c b/util/db.c
index 54f8882..0d8b9c1 100644
--- a/util/db.c
+++ b/util/db.c
@@ -1,4 +1,4 @@
-/* db.c, Version $Revision: 6304 $
+/* db.c
  *
  * ulogd helper functions for Database / SQL output plugins
  *
@@ -22,7 +22,6 @@
  *  along with this program; if not, write to the Free Software
  *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  * 
- * $Id: ulogd_output_MYSQL.c 6304 2005-12-08 09:43:19Z /C=DE/ST=Berlin/L=Berlin/O=Netfilter Project/OU=Development/CN=laforge/emailAddress=laforge@netfilter.org $
  */
 
 #include <unistd.h>
diff --git a/util/printflow.c b/util/printflow.c
index 7743a6a..30e622c 100644
--- a/util/printflow.c
+++ b/util/printflow.c
@@ -17,8 +17,6 @@
  *  along with this program; if not, write to the Free Software
  *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  *
- * $Id: printflow.c,v 1.1 2006/05/16 01:57:31 philipc Exp $
- *
  */
 
 #include <string.h>
diff --git a/util/printpkt.c b/util/printpkt.c
index 9eb339b..3983a68 100644
--- a/util/printpkt.c
+++ b/util/printpkt.c
@@ -17,8 +17,6 @@
  *  along with this program; if not, write to the Free Software
  *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  *
- * $Id$
- *
  */
 
 #include <stdio.h>
-- 
1.7.10.4

