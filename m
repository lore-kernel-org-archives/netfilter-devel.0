Received: from mail.redfish-solutions.com (mail.redfish-solutions.com [24.116.100.90])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE2AC1A3A8D
	for <netfilter-devel@vger.kernel.org>; Mon,  2 Sep 2024 19:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=24.116.100.90
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725306216; cv=none; b=Tm2aqI7VNq0Nl3lTY7IQFhXioyYCo4UFwWJV5OxTaQtK4m1urlWcC3Ln0cMDVKanz71fce8tM1Jlo5PSdmqZifrG63pA9EShTe9mP6sjsaYxlE6g/ETsIeG+7/6LOjO0ZMjtc7Dk5G/H9r+gVHfrfHkY5HAXFg/vRZyluld+97w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725306216; c=relaxed/simple;
	bh=n+psHeKJqPOWt1JvYq8WFjJrXzOm1cBzWTys5F0irTY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=gtkL2TJgNmXovBLGXicqsIbHPm2KQbAPcPd667bdpurE6ipRXhoW3PTvmcajIufAjk542ZRau/aJZUFUtGhNh9M7V1QyzCOIWguAGoW92R2tBsKFNuK3/onPVjwlX0Jqn72q+8QhEMVTgigiPgHRQcU1rC2U5zwPiCGfVdjzZXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=redfish-solutions.com; spf=pass smtp.mailfrom=redfish-solutions.com; arc=none smtp.client-ip=24.116.100.90
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=redfish-solutions.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redfish-solutions.com
Received: from ubuntu22.redfish-solutions.com (ubuntu22.redfish-solutions.com [192.168.8.33])
	(authenticated bits=0)
	by mail.redfish-solutions.com (8.17.2/8.16.1) with ESMTPSA id 482JhOPH747003
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 2 Sep 2024 13:43:24 -0600
From: "Philip Prindeville" <philipp@redfish-solutions.com>
To: netfilter-devel@vger.kernel.org
Cc: Jan Engelhardt <jengelh@inai.de>,
        Philip Prindeville <philipp@redfish-solutions.com>
Subject: [PATCH 1/1] asn: fix missing quiet checks in xt_asn_build
Date: Mon,  2 Sep 2024 13:43:24 -0600
Message-Id: <20240902194324.2948111-1-philipp@redfish-solutions.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 192.168.8.3

From: Philip Prindeville <philipp@redfish-solutions.com>

Conceivably someone might want to run a refresh of the ASN database
from within a script, particularly an unattended script such as a cron
job. Do not generate output in that case.

Also, do not send normal (progress) output to STDERR.

Signed-off-by: Philip Prindeville <philipp@redfish-solutions.com>
---
 asn/xt_asn_build | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/asn/xt_asn_build b/asn/xt_asn_build
index 4c406799480538c03efb8a5ccb9479aef3ef3060..e5edfbf169eaeb2e0049c38db4934070ea3d5b38 100755
--- a/asn/xt_asn_build
+++ b/asn/xt_asn_build
@@ -12,12 +12,14 @@ use Socket qw(AF_INET AF_INET6 inet_pton);
 use warnings;
 use Text::CSV_XS; # or trade for Text::CSV
 use strict;
+$| = 1;
 
 my $csv = Text::CSV_XS->new({
 	allow_whitespace => 1,
 	binary => 1,
 	eol => $/,
 }); # or Text::CSV
+my $quiet = 0;
 my $source_dir = ".";
 my $target_dir = ".";
 my $output_txt;
@@ -27,6 +29,7 @@ my $output_txt;
 	"D=s" => \$target_dir,
 	"S=s" => \$source_dir,
 	"O=s" => \$output_txt,
+	"q" => \$quiet,
 );
 
 if (!-d $source_dir) {
@@ -85,8 +88,8 @@ sub collect
 
 		$asns{$asn}->{pool_v4}->add($cidr);
 
-		if ($. % 4096 == 0) {
-			print STDERR "\r\e[2K$. entries";
+		if (!$quiet && $. % 4096 == 0) {
+			print STDOUT "\r\e[2K$. entries";
 		}
 
 		if ($outfile) {
@@ -95,7 +98,7 @@ sub collect
 		}
 	}
 
-	print STDERR "\r\e[2K$. entries total\n";
+	print STDOUT "\r\e[2K$. entries total\n" unless ($quiet);
 
 	close($fh);
 
@@ -132,8 +135,8 @@ sub collect
 
 		$asns{$asn}->{pool_v6}->add($cidr);
 
-		if ($. % 4096 == 0) {
-			print STDERR "\r\e[2K$. entries";
+		if (!$quiet && $. % 4096 == 0) {
+			print STDOUT "\r\e[2K$. entries";
 		}
 
 		if ($outfile) {
@@ -142,7 +145,7 @@ sub collect
 		}
 	}
 
-	print STDERR "\r\e[2K$. entries total\n";
+	print STDOUT "\r\e[2K$. entries total\n" unless ($quiet);
 
 	close($fh);
 
@@ -187,7 +190,7 @@ sub writeASN
 	printf "%5u IPv%s ranges for %s\n",
 		scalar(@ranges),
 		($family == AF_INET ? '4' : '6'),
-		$asn_number;
+		$asn_number unless ($quiet);
 
 	my $file = "$target_dir/".$asn_number.".iv".($family == AF_INET ? '4' : '6');
 	if (!open($fh, '>', $file)) {
-- 
2.34.1

