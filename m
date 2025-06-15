Received: from mail.redfish-solutions.com (mail.redfish-solutions.com [24.116.100.90])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 126D158210
	for <netfilter-devel@vger.kernel.org>; Sun, 15 Jun 2025 17:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=24.116.100.90
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750008595; cv=none; b=dAVkxbFiROQXtP78im58XwXkjheFpRUOuEdgre0OTl5uo8r2y9ei75szZgD0NMGfBsswF9tMH5oo8rfnKMHgp14ATMGEz6vb28BwzL1x6ibTgEtA/XE+HnP6bOof/EYIW46n0qI9x6JFoRzUewV/yIdPImydVVWcPw7XJhuUPjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750008595; c=relaxed/simple;
	bh=XK27KbPAJ5otUQX/xpOPR3afBdxnInQg4u+Qi18hJXg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=j7fVnthKD7tImrVHtRJY4kRBiXydsa1+pjlX3LJ1ZewPPYpNPZmS+i0+y/0zIqav5rnEzSaCaiSyIxWotauxinrW/JLFsxJ+fK17l6ZB4B4gIxEetiqh7LlrskiylEO7y5vPdVl3LUZLOn7lK2Gh15c6pVSP8oHjDlltE0c/ghc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=redfish-solutions.com; spf=pass smtp.mailfrom=redfish-solutions.com; arc=none smtp.client-ip=24.116.100.90
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=redfish-solutions.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redfish-solutions.com
Received: from ubuntu24.redfish-solutions.com (ubuntu24.redfish-solutions.com [192.168.8.33])
	(authenticated bits=0)
	by mail.redfish-solutions.com (8.18.1/8.18.1) with ESMTPSA id 55FHTpYr091498
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sun, 15 Jun 2025 11:29:51 -0600
From: "Philip Prindeville" <philipp@redfish-solutions.com>
To: netfilter-devel@vger.kernel.org
Cc: Jan Engelhardt <jengelh@inai.de>,
        Philip Prindeville <philipp@redfish-solutions.com>
Subject: [PATCH v2 1/1] asn: fix missing quiet checks in xt_asn_build
Date: Sun, 15 Jun 2025 11:29:50 -0600
Message-ID: <20250615172950.2576738-1-philipp@redfish-solutions.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.6 on 192.168.8.3

From: Philip Prindeville <philipp@redfish-solutions.com>

Conceivably someone might want to run a refresh of the ASN database
from within a script, particularly an unattended script such as a cron
job. Do not generate summary output in that case.

Signed-off-by: Philip Prindeville <philipp@redfish-solutions.com>
---
 asn/xt_asn_build | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/asn/xt_asn_build b/asn/xt_asn_build
index 63019ca689c56d5c9c686838fc4cc758047887e5..81c4965e572bbc7857a4832e0b80669104fe209f 100755
--- a/asn/xt_asn_build
+++ b/asn/xt_asn_build
@@ -12,6 +12,7 @@ use Socket qw(AF_INET AF_INET6 inet_pton);
 use warnings;
 use Text::CSV_XS; # or trade for Text::CSV
 use strict;
+$| = 1;
 
 my $csv = Text::CSV_XS->new({
 	allow_whitespace => 1,
@@ -189,7 +190,7 @@ sub writeASN
 	printf "%5u IPv%s ranges for %s\n",
 		scalar(@ranges),
 		($family == AF_INET ? '4' : '6'),
-		$asn_number;
+		$asn_number unless ($quiet);
 
 	my $file = "$target_dir/".$asn_number.".iv".($family == AF_INET ? '4' : '6');
 	if (!open($fh, '>', $file)) {
-- 
2.43.0

