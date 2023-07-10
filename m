Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A9C6EB64DA
	for <netfilter-devel@archiver.kernel.org>; Mon, 10 Jul 2023 04:47:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbjGJErX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 10 Jul 2023 00:47:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230266AbjGJErW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 10 Jul 2023 00:47:22 -0400
X-Greylist: delayed 568 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 09 Jul 2023 21:47:21 PDT
Received: from mail.redfish-solutions.com (mail.redfish-solutions.com [24.116.100.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F06C129
        for <netfilter-devel@vger.kernel.org>; Sun,  9 Jul 2023 21:47:21 -0700 (PDT)
Received: from ubuntu22.redfish-solutions.com (ubuntu22.redfish-solutions.com [192.168.8.33])
        (authenticated bits=0)
        by mail.redfish-solutions.com (8.17.1/8.16.1) with ESMTPSA id 36A4lI8o060360
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
        Sun, 9 Jul 2023 22:47:18 -0600
From:   "Philip Prindeville" <philipp@redfish-solutions.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Jan Engelhardt <jengelh@inai.de>,
        Philip Prindeville <philipp@redfish-solutions.com>
Subject: [PATCH 1/1] xt_asn: support quiet mode
Date:   Sun,  9 Jul 2023 22:47:18 -0600
Message-Id: <20230710044718.2682302-1-philipp@redfish-solutions.com>
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
 asn/xt_asn_build | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/asn/xt_asn_build b/asn/xt_asn_build
index 4c406799480538c03efb8a5ccb9479aef3ef3060..63019ca689c56d5c9c686838fc4cc758047887e5 100755
--- a/asn/xt_asn_build
+++ b/asn/xt_asn_build
@@ -18,6 +18,7 @@ my $csv = Text::CSV_XS->new({
 	binary => 1,
 	eol => $/,
 }); # or Text::CSV
+my $quiet = 0;
 my $source_dir = ".";
 my $target_dir = ".";
 my $output_txt;
@@ -27,6 +28,7 @@ my $output_txt;
 	"D=s" => \$target_dir,
 	"S=s" => \$source_dir,
 	"O=s" => \$output_txt,
+	"q" => \$quiet,
 );
 
 if (!-d $source_dir) {
@@ -85,7 +87,7 @@ sub collect
 
 		$asns{$asn}->{pool_v4}->add($cidr);
 
-		if ($. % 4096 == 0) {
+		if (!$quiet && $. % 4096 == 0) {
 			print STDERR "\r\e[2K$. entries";
 		}
 
@@ -95,7 +97,7 @@ sub collect
 		}
 	}
 
-	print STDERR "\r\e[2K$. entries total\n";
+	print STDERR "\r\e[2K$. entries total\n" unless ($quiet);
 
 	close($fh);
 
@@ -132,7 +134,7 @@ sub collect
 
 		$asns{$asn}->{pool_v6}->add($cidr);
 
-		if ($. % 4096 == 0) {
+		if (!$quiet && $. % 4096 == 0) {
 			print STDERR "\r\e[2K$. entries";
 		}
 
@@ -142,7 +144,7 @@ sub collect
 		}
 	}
 
-	print STDERR "\r\e[2K$. entries total\n";
+	print STDERR "\r\e[2K$. entries total\n" unless ($quiet);
 
 	close($fh);
 
-- 
2.34.1

