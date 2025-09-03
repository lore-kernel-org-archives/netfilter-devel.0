Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77DCA320CB4
	for <netfilter-devel@vger.kernel.org>; Wed,  3 Sep 2025 17:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756920192; cv=none; b=UowRX7EYnZ7pVQAWFMElAFK9YZ9jSH0+fa3/7zFeDco+olN5GX4aBAh5HVGfTwnhVxL8/kT1+G1xjnQNkUzvTbr4VHOD2Z1PutxIp+gn/2TXIqnKSobkErwhYw/V/TI90dc7hW8FDsQ3nWjm2nD0ruDgkovk57nd9oUJi31NcIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756920192; c=relaxed/simple;
	bh=G1s8YKjpVJDexxg4cwVe0LWrVo0wMH6wEeHxO3/sgO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YS9tjHDt8VOBX5Hl0aQDAXGivTbQ1XP1gDLEtZwYy69YGjWt91zI5L3fqqrWn7FUad5ctXtydiQbHQ5RJJZDrdEkC0CkCAadywEV19DCpI8aKETUUXs2dMvoB17Iam+KxzaF0AAINywAkMXZfBjYSWhy39Eswjv7D4eX+j2Mv7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=nFdgESvk; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="nFdgESvk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=dohgV1GYfcv9QvcHIw0mDO8AjDRtXjpBIzUPSX4Mp6U=; b=nFdgESvk1JWDWF9HglDYCUck0f
	mlBovSQo7KaIIB7bXj+TfohQjfWphfzBgJ+GIZ4BojXUS0jxeINfUCbaJOsKFigE6TkwRLixk2TO+
	25nU7bVKQoGWlrz0DPnRvP3s/CmhJF19Vn0L00HdMJkPwHm56GexMDMjO9vnsuwuV0SSfD2usA6nF
	0tBE42Y/pR8DOqzeR3h/gFgjfaZItL6kiRgu+H5aKWxR3JTaFiFsjLF+Z5Qgls5lUQlYFN9uoKqle
	TUnrR+k8J2OfMcbkax31l7mDWjmxaTW00N9fT1g7Z2/nQZkE/JbHEF0YCjPawp4K4cL4nCFyS54IL
	Ozebm09A==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1utrCP-0000000080m-3qeR;
	Wed, 03 Sep 2025 19:23:09 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH v3 03/11] tests: monitor: Test JSON echo mode as well
Date: Wed,  3 Sep 2025 19:22:51 +0200
Message-ID: <20250903172259.26266-4-phil@nwl.cc>
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

Reuse the expected JSON monitor output for --echo testing as it is
supposed to be "identical" - apart from formatting differences. To match
lines of commands (monitor output) against a single line of JSON object
(echo output), join the former's lines and drop the surrounding object
in the latter since this seems to be the simplest way.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/monitor/run-tests.sh | 27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/tests/monitor/run-tests.sh b/tests/monitor/run-tests.sh
index 4cbdee587f47c..38c20adb1dc61 100755
--- a/tests/monitor/run-tests.sh
+++ b/tests/monitor/run-tests.sh
@@ -52,7 +52,7 @@ echo_output_append() {
 		grep '^\(add\|replace\|insert\)' $command_file >>$output_file
 		return
 	}
-	[[ "$*" =~ ^(add|replace|insert) ]] && echo "$*" >>$output_file
+	[[ "$*" =~ ^(\{\")?(add|replace|insert) ]] && echo "$*" >>$output_file
 }
 json_output_filter() { # (filename)
 	# unify handle values
@@ -96,16 +96,32 @@ monitor_run_test() {
 
 echo_run_test() {
 	echo_output=$(mktemp -p $testdir)
+	echo_args="-nn -e"
+	$test_json && echo_args+=" -j"
 	local rc=0
 
 	$debug && {
 		echo "command file:"
 		cat $command_file
 	}
-	$nft -nn -e -f - <$command_file >$echo_output || {
+	$nft $echo_args -f - <$command_file >$echo_output || {
 		err "nft command failed!"
 		rc=1
 	}
+	if $test_json; then
+		# Extract commands from the surrounding JSON object
+		sed -i -e 's/^{"nftables": \[//' -e 's/\]}$//' $echo_output
+		json_output_filter $echo_output
+
+		# Replace newlines by ", " in output file
+		readarray -t output_file_lines <$output_file
+		sep=""
+		for ((i = 0; i < ${#output_file_lines[*]}; i++)); do
+			printf "${sep}${output_file_lines[$i]}"
+			sep=", "
+		done >$output_file
+		[ $i -gt 0 ] && echo "" >>$output_file
+	fi
 	mydiff -q $echo_output $output_file >/dev/null 2>&1
 	if [[ $rc == 0 && $? != 0 ]]; then
 		err "echo output differs!"
@@ -159,12 +175,7 @@ while [ -n "$1" ]; do
 	esac
 done
 
-if $test_json; then
-	variants="monitor"
-else
-	variants="monitor echo"
-fi
-
+variants="monitor echo"
 rc=0
 for variant in $variants; do
 	run_test=${variant}_run_test
-- 
2.51.0

