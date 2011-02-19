From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 4/8] Remove unused CVS expanded keywords
Date: Sat, 19 Feb 2011 20:04:14 +0100
Message-ID: <1298142259-11213-5-git-send-email-jengelh@medozas.de>
References: <1298142259-11213-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:42359 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755448Ab1BSTEh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 19 Feb 2011 14:04:37 -0500
In-Reply-To: <1298142259-11213-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libipt_ECN.c    |    2 --
 extensions/libipt_TTL.c    |    2 --
 extensions/libipt_ttl.c    |    2 --
 ip6tables-restore.c        |    2 --
 iptables-restore.c         |    2 --
 iptables-xml.c             |    2 --
 libipq/ipq_create_handle.3 |    2 --
 libipq/ipq_errstr.3        |    2 --
 libipq/ipq_message_type.3  |    2 --
 libipq/ipq_read.3          |    2 --
 libipq/ipq_set_mode.3      |    2 --
 libipq/ipq_set_verdict.3   |    2 --
 libipq/libipq.3            |    2 --
 13 files changed, 0 insertions(+), 26 deletions(-)

diff --git a/extensions/libipt_ECN.c b/extensions/libipt_ECN.c
index 216a996..6bfc1b3 100644
--- a/extensions/libipt_ECN.c
+++ b/extensions/libipt_ECN.c
@@ -5,8 +5,6 @@
  * This program is distributed under the terms of GNU GPL v2, 1991
  *
  * libipt_ECN.c borrowed heavily from libipt_DSCP.c
- *
- * $Id$
  */
 #include <stdbool.h>
 #include <stdio.h>
diff --git a/extensions/libipt_TTL.c b/extensions/libipt_TTL.c
index f13d9c3..c2518f8 100644
--- a/extensions/libipt_TTL.c
+++ b/extensions/libipt_TTL.c
@@ -1,8 +1,6 @@
 /* Shared library add-on to iptables for the TTL target
  * (C) 2000 by Harald Welte <laforge@gnumonks.org>
  *
- * $Id$
- *
  * This program is distributed under the terms of GNU GPL
  */
 #include <stdbool.h>
diff --git a/extensions/libipt_ttl.c b/extensions/libipt_ttl.c
index 07fa3c4..d10eb80 100644
--- a/extensions/libipt_ttl.c
+++ b/extensions/libipt_ttl.c
@@ -1,8 +1,6 @@
 /* Shared library add-on to iptables to add TTL matching support 
  * (C) 2000 by Harald Welte <laforge@gnumonks.org>
  *
- * $Id$
- *
  * This program is released under the terms of GNU GPL */
 #include <stdbool.h>
 #include <stdio.h>
diff --git a/ip6tables-restore.c b/ip6tables-restore.c
index 44a051f..e9a130f 100644
--- a/ip6tables-restore.c
+++ b/ip6tables-restore.c
@@ -6,8 +6,6 @@
  *      Harald Welte <laforge@gnumonks.org>
  *      Rusty Russell <rusty@linuxcare.com.au>
  * This code is distributed under the terms of GNU GPL v2
- *
- * $Id$
  */
 
 #include <getopt.h>
diff --git a/iptables-restore.c b/iptables-restore.c
index e2d1859..31ce52b 100644
--- a/iptables-restore.c
+++ b/iptables-restore.c
@@ -3,8 +3,6 @@
  * based on previous code from Rusty Russell <rusty@linuxcare.com.au>
  *
  * This code is distributed under the terms of GNU GPL v2
- *
- * $Id$
  */
 
 #include <getopt.h>
diff --git a/iptables-xml.c b/iptables-xml.c
index 32d996a..8d67056 100644
--- a/iptables-xml.c
+++ b/iptables-xml.c
@@ -4,8 +4,6 @@
  * based on previous code from Rusty Russell <rusty@linuxcare.com.au>
  *
  * This code is distributed under the terms of GNU GPL v2
- *
- * $Id: iptables-xml.c,v 1.4 2006/11/09 12:02:17 azez Exp $
  */
 
 #include <getopt.h>
diff --git a/libipq/ipq_create_handle.3 b/libipq/ipq_create_handle.3
index 6c0c796..11ef95c 100644
--- a/libipq/ipq_create_handle.3
+++ b/libipq/ipq_create_handle.3
@@ -1,7 +1,5 @@
 .TH IPQ_CREATE_HANDLE 3 "16 October 2001" "Linux iptables 1.2" "Linux Programmer's Manual" 
 .\"
-\" $Id: ipq_create_handle.3,v 1.2 2001/10/16 14:41:02 jamesm Exp $
-.\"
 .\"     Copyright (c) 2000-2001 Netfilter Core Team
 .\"
 .\"     This program is free software; you can redistribute it and/or modify
diff --git a/libipq/ipq_errstr.3 b/libipq/ipq_errstr.3
index bcb3ac4..c8d67ce 100644
--- a/libipq/ipq_errstr.3
+++ b/libipq/ipq_errstr.3
@@ -1,7 +1,5 @@
 .TH IPQ_ERRSTR 3 "16 October 2001" "Linux iptables 1.2" "Linux Programmer's Manual" 
 .\"
-.\" $Id: ipq_errstr.3,v 1.1 2000/11/20 14:13:32 jamesm Exp $
-.\"
 .\"     Copyright (c) 2000 Netfilter Core Team
 .\"
 .\"     This program is free software; you can redistribute it and/or modify
diff --git a/libipq/ipq_message_type.3 b/libipq/ipq_message_type.3
index 64b5220..89d8817 100644
--- a/libipq/ipq_message_type.3
+++ b/libipq/ipq_message_type.3
@@ -1,7 +1,5 @@
 .TH IPQ_MESSAGE_TYPE 3 "16 October 2001" "Linux iptables 1.2" "Linux Programmer's Manual" 
 .\"
-.\" $Id: ipq_message_type.3,v 1.1 2000/11/20 14:13:32 jamesm Exp $
-.\"
 .\"     Copyright (c) 2000-2001 Netfilter Core Team
 .\"
 .\"     This program is free software; you can redistribute it and/or modify
diff --git a/libipq/ipq_read.3 b/libipq/ipq_read.3
index 171c916..26ab9f9 100644
--- a/libipq/ipq_read.3
+++ b/libipq/ipq_read.3
@@ -1,7 +1,5 @@
 .TH IPQ_READ 3 "16 October 2001" "Linux iptables 1.2" "Linux Programmer's Manual" 
 .\"
-.\" $Id: ipq_read.3,v 1.2 2001/10/16 14:41:02 jamesm Exp $
-.\"
 .\"     Copyright (c) 2000-2001 Netfilter Core Team
 .\"
 .\"     This program is free software; you can redistribute it and/or modify
diff --git a/libipq/ipq_set_mode.3 b/libipq/ipq_set_mode.3
index 672ee4e..0edd3c0 100644
--- a/libipq/ipq_set_mode.3
+++ b/libipq/ipq_set_mode.3
@@ -1,7 +1,5 @@
 .TH IPQ_SET_MODE 3 "16 October 2001" "Linux iptables 1.2" "Linux Programmer's Manual" 
 .\"
-.\" $Id: ipq_set_mode.3,v 1.1 2000/11/20 14:13:32 jamesm Exp $
-.\"
 .\"     Copyright (c) 2000-2001 Netfilter Core Team
 .\"
 .\"     This program is free software; you can redistribute it and/or modify
diff --git a/libipq/ipq_set_verdict.3 b/libipq/ipq_set_verdict.3
index e9d3d3f..7771ed6 100644
--- a/libipq/ipq_set_verdict.3
+++ b/libipq/ipq_set_verdict.3
@@ -1,7 +1,5 @@
 .TH IPQ_SET_VERDICT 3 "16 October 2001" "Linux iptables 1.2" "Linux Programmer's Manual" 
 .\"
-.\" $Id: ipq_set_verdict.3,v 1.1 2000/11/20 14:13:32 jamesm Exp $
-.\"
 .\"     Copyright (c) 2000-2001 Netfilter Core Team
 .\"
 .\"     This program is free software; you can redistribute it and/or modify
diff --git a/libipq/libipq.3 b/libipq/libipq.3
index 0196248..611fcdf 100644
--- a/libipq/libipq.3
+++ b/libipq/libipq.3
@@ -1,7 +1,5 @@
 .TH LIBIPQ 3 "16 October 2001" "Linux iptables 1.2" "Linux Programmer's Manual" 
 .\"
-.\" $Id: libipq.3,v 1.4 2001/10/16 16:58:25 jamesm Exp $
-.\"
 .\"     Copyright (c) 2000-2001 Netfilter Core Team
 .\"
 .\"     This program is free software; you can redistribute it and/or modify
-- 
1.7.1

