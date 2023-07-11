Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09752EB64DC
	for <netfilter-devel@archiver.kernel.org>; Tue, 11 Jul 2023 19:49:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230254AbjGKTtD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 11 Jul 2023 15:49:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbjGKTtC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 11 Jul 2023 15:49:02 -0400
Received: from mail.redfish-solutions.com (mail.redfish-solutions.com [24.116.100.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD4C819B
        for <netfilter-devel@vger.kernel.org>; Tue, 11 Jul 2023 12:49:01 -0700 (PDT)
Received: from ubuntu22.redfish-solutions.com (ubuntu22.redfish-solutions.com [192.168.8.33])
        (authenticated bits=0)
        by mail.redfish-solutions.com (8.17.1/8.16.1) with ESMTPSA id 36BJmvpb080880
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
        Tue, 11 Jul 2023 13:48:57 -0600
From:   "Philip Prindeville" <philipp@redfish-solutions.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Jan Engelhardt <jengelh@inai.de>,
        Philip Prindeville <philipp@redfish-solutions.com>
Subject: [PATCH 1/1] xt_asn: add matching dump [query] utility
Date:   Tue, 11 Jul 2023 13:48:57 -0600
Message-Id: <20230711194857.12581-1-philipp@redfish-solutions.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 192.168.8.3
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Philip Prindeville <philipp@redfish-solutions.com>

Signed-off-by: Philip Prindeville <philipp@redfish-solutions.com>
---
 asn/xt_asn_query     | 95 ++++++++++++++++++++++++++++++++++++++++++++
 asn/xt_asn_query.1   | 35 ++++++++++++++++
 geoip/xt_geoip_query |  4 +-
 3 files changed, 132 insertions(+), 2 deletions(-)

diff --git a/asn/xt_asn_query b/asn/xt_asn_query
new file mode 100755
index 0000000000000000000000000000000000000000..195b54f4d29de2b346cabbd1c8c1f6dcecdeceaf
--- /dev/null
+++ b/asn/xt_asn_query
@@ -0,0 +1,95 @@
+#!/usr/bin/perl
+#
+#	Utility to query GeoLite2 database (.iv4/.iv6 files)
+#	Copyright Philip Prindeville, 2023
+#
+use Getopt::Long;
+use Socket qw(AF_INET AF_INET6 inet_ntop);
+use warnings;
+use strict;
+
+sub AF_INET_SIZE() { 4 }
+sub AF_INET6_SIZE() { 16 }
+
+my $target_dir = ".";
+my $ipv4 = 0;
+my $ipv6 = 0;
+
+&Getopt::Long::Configure(qw(bundling));
+&GetOptions(
+	"D=s" => \$target_dir,
+	"4"   => \$ipv4,
+	"6"   => \$ipv6,
+);
+
+if (!-d $target_dir) {
+	print STDERR "Target directory $target_dir does not exit.\n";
+	exit 1;
+}
+
+# if neither specified, assume both
+if (! $ipv4 && ! $ipv6) {
+	$ipv4 = $ipv6 = 1;
+}
+
+foreach my $asn (@ARGV) {
+	if ($asn !~ m/^\d+$/i) {
+		print STDERR "Invalid ASN '$asn'\n";
+		exit 1;
+	}
+
+	my $file = $target_dir . '/' . uc($asn) . '.iv4';
+
+	if (! -f $file) {
+		printf STDERR "Can't find data for ASN '$asn'\n";
+		exit 1;
+	}
+
+	my ($contents, $buffer, $bytes, $fh);
+
+	if ($ipv4) {
+		open($fh, '<', $file) || die "Couldn't open file for '$asn'\n";
+
+		binmode($fh);
+
+		while (($bytes = read($fh, $buffer, AF_INET_SIZE * 2)) == AF_INET_SIZE * 2) {
+			my ($start, $end) = unpack('a4a4', $buffer);
+			$start = inet_ntop(AF_INET, $start);
+			$end = inet_ntop(AF_INET, $end);
+			print $start, '-', $end, "\n";
+		}
+		close($fh);
+		if (! defined $bytes) {
+			printf STDERR "Error reading file for '$asn'\n";
+			exit 1;
+		} elsif ($bytes != 0) {
+			printf STDERR "Short read on file for '$asn'\n";
+			exit 1;
+		}
+	}
+
+	substr($file, -1) = '6';
+
+	if ($ipv6) {
+		open($fh, '<', $file) || die "Couldn't open file for '$asn'\n";
+
+		binmode($fh);
+
+		while (($bytes = read($fh, $buffer, AF_INET6_SIZE * 2)) == AF_INET6_SIZE * 2) {
+			my ($start, $end) = unpack('a16a16', $buffer);
+			$start = inet_ntop(AF_INET6, $start);
+			$end = inet_ntop(AF_INET6, $end);
+			print $start, '-', $end, "\n";
+		}
+		close($fh);
+		if (! defined $bytes) {
+			printf STDERR "Error reading file for '$asn'\n";
+			exit 1;
+		} elsif ($bytes != 0) {
+			printf STDERR "Short read on file for '$asn'\n";
+			exit 1;
+		}
+	}
+}
+
+exit 0;
diff --git a/asn/xt_asn_query.1 b/asn/xt_asn_query.1
new file mode 100644
index 0000000000000000000000000000000000000000..da67c60cd975d358f7924a6029e566075a982e2d
--- /dev/null
+++ b/asn/xt_asn_query.1
@@ -0,0 +1,35 @@
+.TH xt_asn_query 1 "2020-04-30" "xtables-addons" "xtables-addons"
+.SH Name
+.PP
+xt_asn_query \(em dump an ASN database to stdout
+.SH Syntax
+.PP
+\fBxt_asn_query\fP [\fB\-D\fP
+\fIdatabase_dir\fP] [\fB-4\fP] [\fB-6\fP] \fIasn\fP [ \fIasn\fP ... ]
+.SH Description
+.PP
+xt_asn_query reads an ASN's IPv4 or IPv6 databases and dumps
+them to standard output as a sorted, non-overlapping list of ranges (which
+is how they are represented in the database), suitable for browsing or
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
+\fIasn\fP [ \fIasn\fP ... ]
+The ASN (Autonomous System Numbers) from global BGP peering in decimal notation.
+.SH Application
+.PP
+Shell command to dump the list of OVH's IPv4 address ranges from ASN 16276:
+.PP
+xt_asn_query \-D /usr/share/xt_asn \-6 16276
+.SH See also
+.PP
+xt_asn_build(1)
diff --git a/geoip/xt_geoip_query b/geoip/xt_geoip_query
index 2d80baf4487a24f64cd1d190d7acc6dc66de74cb..23d8513ee22f90253ecc299f6adb8484c2e5141c 100755
--- a/geoip/xt_geoip_query
+++ b/geoip/xt_geoip_query
@@ -1,7 +1,7 @@
 #!/usr/bin/perl
 #
-#	Utility to query GeoIP database (.iv4/.iv6 files)
-#	Copyright Philip Prindeville, 2018
+#	Utility to query GeoLite2 database (.iv4/.iv6 files)
+#	Copyright Philip Prindeville, 2018, 2023
 #
 use Getopt::Long;
 use Socket qw(AF_INET AF_INET6 inet_ntop);
-- 
2.34.1

