Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD87530DD12
	for <netfilter-devel@vger.kernel.org>; Wed,  3 Sep 2025 17:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756920190; cv=none; b=CJHI3v5mccmKpLBv1vsvZ3y2bFxldYTaAjjuDDfT+svPAPfe+aQFbw2UsKJdyKmLxG72Z4f2x4bkbQqB9HTQj9gC8ts8O+UDYHBIpar0NrAZRktiEfoYpaUjh7Rdon7Vj2rTWgQe4Plpjqsj+7TjwVbDSZCNe4aZqBB36ibEdnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756920190; c=relaxed/simple;
	bh=Tbex/k+mp1Qbgl0vB4E8DriRVXwII5y6b7ycccddM5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RsTC+vUDcMzmn6apijWQ60aKdXfNi+S/chXVM0qrMagM/iDTSc2adwMW+4JLSCyAjZnX+CNnoTc2+yyar0avhoyJf4KQI8qrwv9EuAWsPQH8E35ab5zkqAzmhuEBYv3dBTjZBhml2qluPHvmNz2yaYkMf2Lt6AYwYi6V6/nVKEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=i5JTHiAg; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="i5JTHiAg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=irQQf23mIVV53wmHNxHPvKd6ucUcYhQvWC0uuYwGzQk=; b=i5JTHiAgtfHVDIBxp2EOHPpM6J
	Qk+1p6QKpdOr0cjRSUDUQDbHyNKQA0QW1aDcaQiKGffKOuJ/W7d+6Pfcw1MxRTXKVo0yIlqNovx/v
	cUbr8xqUWiEfibVKvun8v9X23JLGvtKTisvFZ/caAnGOi+s0/2zPGa47nESHd+d7SrnQC4i7HQJQd
	QqRM1kuhBAJjJLU5Am0ELQeQcEYHkRaJSTOH+iqoQt6DIit7kpC4e2dtYeZls4rHHIaU8iMrTp14n
	2UcpHPwaOQpUGjvvXvZniDhPCiuO6hUYsX8gxTxtqufXuI3u9T9usDZA2zlAoTBUtLutlXCiyfjQN
	4tFS06xw==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1utrCM-0000000080L-2Fzd;
	Wed, 03 Sep 2025 19:23:06 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH v3 05/11] tests: monitor: Excercise all syntaxes and variants by default
Date: Wed,  3 Sep 2025 19:22:53 +0200
Message-ID: <20250903172259.26266-6-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250903172259.26266-1-phil@nwl.cc>
References: <20250903172259.26266-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introduce -s/--standard flag to restrict execution to standard syntax
and let users select a specific variant by means of -e/--echo and
-m/--monitor flags. Run all four possible combinations by default.

To keep indenting sane, introduce run_testcase() executing tests in a
single test case for a given syntax and variant.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/monitor/run-tests.sh | 134 ++++++++++++++++++++++---------------
 1 file changed, 79 insertions(+), 55 deletions(-)

diff --git a/tests/monitor/run-tests.sh b/tests/monitor/run-tests.sh
index b09b72ae034cb..32b1b86e0cc6e 100755
--- a/tests/monitor/run-tests.sh
+++ b/tests/monitor/run-tests.sh
@@ -154,14 +154,28 @@ if $netns; then
 fi
 
 testcases=""
+variants=""
+syntaxes=""
 while [ -n "$1" ]; do
 	case "$1" in
 	-d|--debug)
 		debug=true
 		shift
 		;;
+	-s|--standard)
+		syntaxes+=" standard"
+		shift
+		;;
 	-j|--json)
-		test_json=true
+		syntaxes+=" json"
+		shift
+		;;
+	-e|--echo)
+		variants+=" echo"
+		shift
+		;;
+	-m|--monitor)
+		variants+=" monitor"
 		shift
 		;;
 	--no-netns)
@@ -179,64 +193,74 @@ while [ -n "$1" ]; do
 		echo "unknown option '$1'"
 		;&
 	-h|--help)
-		echo "Usage: $(basename $0) [-j|--json] [-d|--debug] [testcase ...]"
+		echo "Usage: $(basename $0) [(-e|--echo)|(-m|--monitor)] [(-j|--json)|(-s|--standard)] [-d|--debug] [testcase ...]"
 		exit 1
 		;;
 	esac
 done
 
-variants="monitor echo"
-rc=0
-for variant in $variants; do
-	run_test=${variant}_run_test
-	output_append=${variant}_output_append
-
-	for testcase in ${testcases:-testcases/*.t}; do
-		filename=$(basename $testcase)
-		echo "$variant: running tests from file $filename"
-		rc_start=$rc
-
-		# files are like this:
-		#
-		# I add table ip t
-		# O add table ip t
-		# I add chain ip t c
-		# O add chain ip t c
-
-		$nft flush ruleset
-
-		input_complete=false
-		while read dir line; do
-			case $dir in
-			I)
-				$input_complete && {
-					$run_test
-					let "rc += $?"
-				}
-				input_complete=false
-				cmd_append "$line"
-				;;
-			O)
-				input_complete=true
-				$test_json || $output_append "$line"
-				;;
-			J)
-				input_complete=true
-				$test_json && $output_append "$line"
-				;;
-			'#'|'')
-				# ignore comments and empty lines
-				;;
-			esac
-		done <$testcase
-		$input_complete && {
-			$run_test
-			let "rc += $?"
-		}
-
-		let "rc_diff = rc - rc_start"
-		[[ $rc_diff -ne 0 ]] && \
-			echo "$variant: $rc_diff tests from file $filename failed"
+# run the single test in $1
+# expect $variant and $test_json to be set appropriately
+run_testcase() {
+	testcase="$1"
+	filename=$(basename $testcase)
+	rc=0
+	$test_json && printf "json-"
+	echo "$variant: running tests from file $filename"
+
+	# files are like this:
+	#
+	# I add table ip t
+	# O add table ip t
+	# I add chain ip t c
+	# O add chain ip t c
+
+	$nft flush ruleset
+
+	input_complete=false
+	while read dir line; do
+		case $dir in
+		I)
+			$input_complete && {
+				${variant}_run_test
+				$run_test
+				let "rc += $?"
+			}
+			input_complete=false
+			cmd_append "$line"
+			;;
+		O)
+			input_complete=true
+			$test_json || ${variant}_output_append "$line"
+			;;
+		J)
+			input_complete=true
+			$test_json && ${variant}_output_append "$line"
+			;;
+		'#'|'')
+			# ignore comments and empty lines
+			;;
+		esac
+	done <$testcase
+	$input_complete && {
+		${variant}_run_test
+		let "rc += $?"
+	}
+
+	[[ $rc -ne 0 ]] && \
+		echo "$variant: $rc tests from file $filename failed"
+	return $rc
+}
+
+total_rc=0
+for syntax in ${syntaxes:-standard json}; do
+	[ $syntax == json ] && test_json=true || test_json=false
+	for variant in ${variants:-echo monitor}; do
+		for testcase in ${testcases:-testcases/*.t}; do
+			run_testcase "$testcase"
+			let "total_rc += $?"
+		done
 	done
 done
-exit $rc
+
+exit $total_rc
-- 
2.51.0

