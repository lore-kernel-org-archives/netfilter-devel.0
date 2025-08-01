Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA68228BAAD
	for <netfilter-devel@vger.kernel.org>; Fri,  1 Aug 2025 16:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754064675; cv=none; b=uqXyA3QeQggO15LDrZO67ueWxGB+DtC/kYFCTon1nTB36LfrlYp58x8ZtHPjjg8aodwT+mihkUuHI6Iv8SPdBFndg5CHjkcPi+YFV6yrOD3htlIdGGi2QnogZ5H8cijFj5nC3b3IlxaTTjpqTwyLOB0PHYfCyLf2KxG8HGzCMOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754064675; c=relaxed/simple;
	bh=Q6zx8A78+6dLIeyzqgYF6Fx+02oAvjpQRtPuPAdcT4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uMU3XJXJ1zdogn/JyRBKTNRujGp7Mn6BER/87hXDUjzApkQUeC3tVNKjOUQD+sQtihWlhHIgfOAyVpw5jypT9jWtgW57+LqOOlXzkl7T5tdZoCgUn/X/TqsVX0iz+NpUAxZVmS8SMyXj6OPtmr+YYVHogrKRql3a2GwI0RL4yz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Azy93ZUL; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Azy93ZUL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=QcTlOiz4Jk3apbTTaVRB4xmRg40W4wAz5tBNG567Uj4=; b=Azy93ZULuw/n2x/CCcWWJcE2qb
	C80L+iWjMmaYrmriI9CJpnzwI45Zs8WknJvrelM4tVX0IcaaLqztfuTrVPZPNjm8ZQMqFgGxV0EH5
	Phdl8c/MEJWX2qqCUYFLeWqR7tXYDXDaO/3MuDZhWHOW/gtsQ/tBP26HAZ4naMARSO52GwuXq/lUU
	0mQVeoDxCbivPmSwtfoBHnM6fXVWwA2yf/va/vO91QHgxBQ7q9sOgjohORwRRAwRsUrQG/K4fLXKa
	CBojnqaXWMM29O6zXGaHHG0qBKe7ZGA1SwiYE9UfpS0p4n0OmU1N3DpvfSdvfS5acsUXrsOwrDV2v
	GJvqBDHw==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uhsLf-000000005IM-3nDW;
	Fri, 01 Aug 2025 18:11:11 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 2/6] tests: monitor: Support running all tests in one go
Date: Fri,  1 Aug 2025 18:11:01 +0200
Message-ID: <20250801161105.24823-3-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250801161105.24823-1-phil@nwl.cc>
References: <20250801161105.24823-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Detect RUN_FULL_TESTSUITE env variable set by automake and do an
"unattended" full testrun.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/monitor/run-tests.sh | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/tests/monitor/run-tests.sh b/tests/monitor/run-tests.sh
index 969afe249201b..b8589344a9732 100755
--- a/tests/monitor/run-tests.sh
+++ b/tests/monitor/run-tests.sh
@@ -58,7 +58,7 @@ json_output_filter() { # (filename)
 monitor_run_test() {
 	monitor_output=$(mktemp -p $testdir)
 	monitor_args=""
-	$test_json && monitor_args="vm json"
+	$json_mode && monitor_args="vm json"
 	local rc=0
 
 	$nft -nn monitor $monitor_args >$monitor_output &
@@ -77,7 +77,7 @@ monitor_run_test() {
 	sleep 0.5
 	kill $monitor_pid
 	wait >/dev/null 2>&1
-	$test_json && json_output_filter $monitor_output
+	$json_mode && json_output_filter $monitor_output
 	mydiff -q $monitor_output $output_file >/dev/null 2>&1
 	if [[ $rc == 0 && $? != 0 ]]; then
 		err "monitor output differs!"
@@ -156,20 +156,29 @@ while [ -n "$1" ]; do
 	esac
 done
 
-if $test_json; then
-	variants="monitor"
+if [[ $RUN_FULL_TESTSUITE == 1 ]]; then
+	variants="monitor_json monitor echo"
+elif $test_json; then
+	variants="monitor_json"
 else
 	variants="monitor echo"
 fi
 
 rc=0
 for variant in $variants; do
+	orig_variant=$variant
+	if [[ $variant =~ .*_json ]]; then
+		variant=${variant%_json}
+		json_mode=true
+	else
+		json_mode=false
+	fi
 	run_test=${variant}_run_test
 	output_append=${variant}_output_append
 
 	for testcase in ${testcases:-testcases/*.t}; do
 		filename=$(basename $testcase)
-		echo "$variant: running tests from file $filename"
+		echo "$orig_variant: running tests from file $filename"
 		rc_start=$rc
 
 		# files are like this:
@@ -194,11 +203,11 @@ for variant in $variants; do
 				;;
 			O)
 				input_complete=true
-				$test_json || $output_append "$line"
+				$json_mode || $output_append "$line"
 				;;
 			J)
 				input_complete=true
-				$test_json && $output_append "$line"
+				$json_mode && $output_append "$line"
 				;;
 			'#'|'')
 				# ignore comments and empty lines
-- 
2.49.0

