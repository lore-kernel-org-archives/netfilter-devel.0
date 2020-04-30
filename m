Return-Path: <SRS0=RE83=6O=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1192C47247
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 Apr 2020 22:15:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1115206D9
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 Apr 2020 22:15:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726784AbgD3WPy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 30 Apr 2020 18:15:54 -0400
Received: from mail.redfish-solutions.com ([45.33.216.244]:55050 "EHLO
        mail.redfish-solutions.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726447AbgD3WPy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 30 Apr 2020 18:15:54 -0400
Received: from son-of-builder.redfish-solutions.com (son-of-builder.redfish-solutions.com [192.168.1.56])
        (authenticated bits=0)
        by mail.redfish-solutions.com (8.15.2/8.15.2) with ESMTPSA id 03UMFmnt016234
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Apr 2020 16:15:48 -0600
From:   "Philip Prindeville" <philipp@redfish-solutions.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Jan Engelhardt <jengelh@inai.de>,
        Philip Prindeville <philipp@redfish-solutions.com>
Subject: [PATCH v1 1/1] xtables-addons: geoip: install and document xt_geoip_fetch
Date:   Thu, 30 Apr 2020 16:15:46 -0600
Message-Id: <20200430221546.12964-1-philipp@redfish-solutions.com>
X-Mailer: git-send-email 2.17.2
X-Scanned-By: MIMEDefang 2.84 on 192.168.1.3
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Philip Prindeville <philipp@redfish-solutions.com>

Add a man page for xt_geoip_fetch.1 and include it as part of
the installed scripts.

Signed-off-by: Philip Prindeville <philipp@redfish-solutions.com>
---
 geoip/Makefile.am      |  2 ++
 geoip/xt_geoip_fetch.1 | 35 +++++++++++++++++++++++++++++++++++
 2 files changed, 37 insertions(+)

diff --git a/geoip/Makefile.am b/geoip/Makefile.am
index aa28c3d21c6e489bb20c8165ecfec2259e0ee438..32048a21e8069a2b865ef6600aed63f6b7d53446 100644
--- a/geoip/Makefile.am
+++ b/geoip/Makefile.am
@@ -1,5 +1,7 @@
 # -*- Makefile -*-
 
+bin_SCRIPTS = xt_geoip_fetch
+
 pkglibexec_SCRIPTS = xt_geoip_build xt_geoip_dl
 
 man1_MANS = xt_geoip_build.1 xt_geoip_dl.1
diff --git a/geoip/xt_geoip_fetch.1 b/geoip/xt_geoip_fetch.1
new file mode 100644
index 0000000000000000000000000000000000000000..7280c74b9ab520e61293a304207dfafee07cbe47
--- /dev/null
+++ b/geoip/xt_geoip_fetch.1
@@ -0,0 +1,35 @@
+.TH xt_geoip_fetch 1 "2020-04-30" "xtables-addons" "xtables-addons"
+.SH Name
+.PP
+xt_geoip_fetch \(em dump a country database to stdout
+.SH Syntax
+.PP
+\fBxt_geoip_fetch\fP [\fB\-D\fP
+\fIdatabase_dir\fP] [\fB-4\fP] [\fB-6\fP] \fIcc\fP [ \fIcc\fP ... ]
+.SH Description
+.PP
+xt_geoip_fetch unpacks a country's IPv4 or IPv6 databases and dumps
+them to standard output as a sorted, non-overlaping list of ranges (which
+is how they're represented in the database) suitable for browsing or
+further processing.
+.PP Options
+.TP
+\fB\-D\fP \fIdatabase_dir\fP
+Specifies the directory into which the files have been put. Defaults to ".".
+.TP
+\fB-4\fP
+Specifies IPv4 data only.
+.TP
+\fB-6\fP
+Specifies IPv6 data only.
+.TP
+\fIcc\fP [ \fIcc\fP ... ]
+The ISO-3166 country code names of the desired countries' databases.
+.SH Application
+.PP
+Shell command to dump the list of Swiss IPv6 address ranges:
+.PP
+xt_geoip_fetch \-D /usr/share/xt_geoip \-6 ch
+.SH See also
+.PP
+xt_geoip_build(1)
-- 
2.17.2

