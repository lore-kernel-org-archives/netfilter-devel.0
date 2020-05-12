Return-Path: <SRS0=em6Q=62=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32890C47255
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 May 2020 00:28:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C96A20714
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 May 2020 00:28:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbgELA2C (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 11 May 2020 20:28:02 -0400
Received: from mail.redfish-solutions.com ([45.33.216.244]:60972 "EHLO
        mail.redfish-solutions.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725881AbgELA2C (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 11 May 2020 20:28:02 -0400
Received: from son-of-builder.redfish-solutions.com (son-of-builder.redfish-solutions.com [192.168.1.56])
        (authenticated bits=0)
        by mail.redfish-solutions.com (8.15.2/8.15.2) with ESMTPSA id 04C0RwJ5025958
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 May 2020 18:27:58 -0600
From:   "Philip Prindeville" <philipp@redfish-solutions.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Jan Engelhardt <jengelh@inai.de>,
        Philip Prindeville <philipp@redfish-solutions.com>
Subject: [PATCH v1 1/1] xtables-addons: geoip: update scripts for DBIP names, etc.
Date:   Mon, 11 May 2020 18:27:47 -0600
Message-Id: <20200512002747.2108-1-philipp@redfish-solutions.com>
X-Mailer: git-send-email 2.17.2
X-Scanned-By: MIMEDefang 2.84 on 192.168.1.3
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Philip Prindeville <philipp@redfish-solutions.com>

Also change the default destination directory to /usr/share/xt_geoip
as most distros use this now.  Update the documentation.

Signed-off-by: Philip Prindeville <philipp@redfish-solutions.com>
---
 geoip/xt_geoip_build   |  4 +++-
 geoip/xt_geoip_build.1 | 10 +++++-----
 geoip/xt_geoip_fetch   |  3 ++-
 geoip/xt_geoip_fetch.1 |  3 ++-
 4 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/geoip/xt_geoip_build b/geoip/xt_geoip_build
index e7ad9bfdcc1e3b617ada77872f9be87e126b885f..edb05426554f799524610ce55cbfe738b838ba0e 100644
--- a/geoip/xt_geoip_build
+++ b/geoip/xt_geoip_build
@@ -5,6 +5,7 @@
 #	Copyright Philip Prindeville, 2018
 #	Copyright Arjen de Korte, 2020
 #
+
 use Getopt::Long;
 use Net::CIDR::Lite;
 use Socket qw(AF_INET AF_INET6 inet_pton);
@@ -17,8 +18,9 @@ my $csv = Text::CSV_XS->new({
 	binary => 1,
 	eol => $/,
 }); # or Text::CSV
+
 my $source_dir = ".";
-my $target_dir = ".";
+my $target_dir = "/usr/share/xt_geoip";
 
 &Getopt::Long::Configure(qw(bundling));
 &GetOptions(
diff --git a/geoip/xt_geoip_build.1 b/geoip/xt_geoip_build.1
index 3b6ead31edd405688e692d1244fd6726dd529875..2513f34effffee82a206afca057328f5b86385d5 100644
--- a/geoip/xt_geoip_build.1
+++ b/geoip/xt_geoip_build.1
@@ -22,13 +22,13 @@ script requires it to be called with a path.
 .PP Options
 .TP
 \fB\-D\fP \fItarget_dir\fP
-Specifies the target directory into which the files are to be put. Defaults to ".".
+Specifies the target directory into which the files are to be put.
+Defaults to "/usr/share/xt_geoip".
 .TP
 \fB\-S\fP \fIsource_dir\fP
-Specifies the source directory from which to read the three files by the name
-of \fBGeoLite2\-Country\-Blocks\-IPv4.csv\fP,
-\fBGeoLite2\-Country\-Blocks\-IPv6.csv\fP and
-\fBGeoLite2\-Country\-Locations\-en.csv\fP. Defaults to ".".
+Specifies the source directory from which to read the file
+\fBdbip-country-lite.csv\fP.
+Defaults to ".".
 .SH Application
 .PP
 Shell commands to build the databases and put them to where they are expected:
diff --git a/geoip/xt_geoip_fetch b/geoip/xt_geoip_fetch
index 06245195fb5166ac005b5021fa0f811e5e511c78..790ae36c68b45a63811eed69782e21ee180c8632 100755
--- a/geoip/xt_geoip_fetch
+++ b/geoip/xt_geoip_fetch
@@ -3,6 +3,7 @@
 #	Utility to query GeoIP database
 #	Copyright Philip Prindeville, 2018
 #
+
 use Getopt::Long;
 use Socket qw(AF_INET AF_INET6 inet_ntop);
 use warnings;
@@ -11,7 +12,7 @@ use strict;
 sub AF_INET_SIZE() { 4 }
 sub AF_INET6_SIZE() { 16 }
 
-my $target_dir = ".";
+my $target_dir = "/usr/share/xt_geoip";
 my $ipv4 = 0;
 my $ipv6 = 0;
 
diff --git a/geoip/xt_geoip_fetch.1 b/geoip/xt_geoip_fetch.1
index 7280c74b9ab520e61293a304207dfafee07cbe47..d51feea9328d654e98a24cc52ce7a168c15319d0 100644
--- a/geoip/xt_geoip_fetch.1
+++ b/geoip/xt_geoip_fetch.1
@@ -15,7 +15,8 @@ further processing.
 .PP Options
 .TP
 \fB\-D\fP \fIdatabase_dir\fP
-Specifies the directory into which the files have been put. Defaults to ".".
+Specifies the directory into which the files have been put.
+Defaults to "/usr/share/xt_geoip".
 .TP
 \fB-4\fP
 Specifies IPv4 data only.
-- 
2.17.2

