From: Peter Warasin <peter@endian.com>
Subject: [PATCH 5/5] stores the converted syslog parameters set within config file
Date: Fri, 11 Jan 2008 16:09:15 +0100
Message-ID: <20080111152825.108644000@andrew.endian.com>
References: <20080111150910.582899000@andrew.endian.com>
Cc: Peter Warasin <peter@endian.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from solaria.endian.it ([80.190.199.145]:34011 "EHLO
	solaria.endian.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760701AbYAKQAS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 11 Jan 2008 11:00:18 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
	by solaria.endian.it (Postfix) with ESMTP id 1D7B059833B
	for <netfilter-devel@vger.kernel.org>; Fri, 11 Jan 2008 16:28:37 +0100 (CET)
Content-Disposition: inline; filename=ulogd_output_SYSLOG_configure_fix.patch
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch stores the converted values from the configuration file
into the syslog instance structure.
Otherwise configuration parameters are senseless and only the
default values will be used.

Signed-off-by: Peter Warasin <peter@endian.com>

---
 output/ulogd_output_SYSLOG.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: ulogd-2.0.0beta1/output/ulogd_output_SYSLOG.c
===================================================================
--- ulogd-2.0.0beta1.orig/output/ulogd_output_SYSLOG.c	2008-01-11 13:12:27.000000000 +0100
+++ ulogd-2.0.0beta1/output/ulogd_output_SYSLOG.c	2008-01-11 13:24:18.000000000 +0100
@@ -87,6 +87,7 @@
 {
 	int syslog_facility, syslog_level;
 	char *facility, *level;
+	struct syslog_instance *li = (struct syslog_instance *) &pi->private;
 
 	/* FIXME: error handling */
 	config_parse_file(pi->id, pi->config_kset);
@@ -144,6 +145,9 @@
 		return -EINVAL;
 	}
 
+	li->syslog_level = syslog_level;
+	li->syslog_facility = syslog_facility;
+
 	return 0;
 }
 

--
