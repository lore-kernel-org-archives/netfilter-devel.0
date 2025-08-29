Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92D9013777E
	for <netfilter-devel@vger.kernel.org>; Fri, 29 Aug 2025 15:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756482734; cv=none; b=Fxdg4ZYtInGIM+yuBBETokFHmNQf3YQFSzL4lw8/KrU215Dy0iXlb7SuPB9leq5LNeTzty6vCA5YsN5e611BB8u3UoL6N/TxXlCTkmM9zg5pRZG17lhUGK/cMk4TQId3TeWJpdEhnLxOz3bqrix2jxhBYV5G8rXNcJjau0o4GrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756482734; c=relaxed/simple;
	bh=1JNaAF9+FLGBaZlSZxiuQIVU7YI7Xb60Hddhe3PXAkQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SkNpqxuFKYmtF6NLgpVy12Q2z00G66g0/Qn7lXx2YbpaVCJvL9R7O4onLRBIlATz3ZJq/53ewv5WbEIoL6lcsTC5xsUtP7dxNwHiNTKduOPMEHPflMVGvxJoU2fmmrFPwVhnA67/iO8gpWLyf/F6eq/4fWixzNg5B6MVaI+rImU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=ad0V/96v; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="ad0V/96v"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=5tgdxqIfr7nftyprONHLuFAfCNOxRkusH0SFrvb49uM=; b=ad0V/96vE+fTDgwNKkU3aHfgBr
	K1QzZLgHtEbAk2B52ASTJkm/tNYqZ1qVK0tDsstdFSbM8DVIE2pLZfr6mtI9ojg06kmRoJSMwnNfa
	wtd7MX3SYPUpVP17Qy7jjm6jB2231bqLCEqtK7pvM7vVKglPR6kUONUsKHT+j1s6JhW4idaj7OUAN
	kEinuK1zD+CaYvjbsFT4kgUvlvqc7B3WvL7f6U8a5rcf4cLFbFKYPg8jf48IhUzHxp7dwf4HNMMX1
	O7gJwsBBxN9iVi3qUyWWQzjQG26yvFGKiP59rml+XVUXEX94HmeOc5zG+jqZvDbz93MH23u/0J9Mv
	jRIlmOlQ==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1us1Oc-000000001Ro-1oth;
	Fri, 29 Aug 2025 17:52:10 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH v2 2/7] tests: monitor: Support running all tests in one go
Date: Fri, 29 Aug 2025 17:51:58 +0200
Message-ID: <20250829155203.29000-3-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250829155203.29000-1-phil@nwl.cc>
References: <20250829155203.29000-1-phil@nwl.cc>
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
2.51.0

