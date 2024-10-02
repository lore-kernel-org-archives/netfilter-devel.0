Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F2181DB93C
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Oct 2024 19:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727897941; cv=none; b=keHA+M7WFWoBh3/wPAATVZPFc7UCgKW6W/y9pDPOS0fAjvXrDvy/NiU3jMEEKVyAr19cIoU9in7uxbPdWgLM7aWOOAem7bUsMiX+jky3D+MoqvrRnj25W6k0ciE4Kl7ppSVjwHDZj5yiYU5MffpOSy+sy4v/wE7roIuuwOURxMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727897941; c=relaxed/simple;
	bh=zMiExvh9Mg5h60VIoDVHrkIK+Ou8E6+80mqx4GfhnWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TcUs9b0f8txGIaplsKPu1g46DWSjPYCy+m0c7TIpC6lxQ8nByGF17GSEqhcWk3oRTuUAwsDcztbk/F1TeuwyPkWZzbExgG6f3a+GsKWtzeC1868dUKNsbK6MoQ90xoaSMFPOMBNavNVCMe1HWk37uuSy55F/Kgb6d+C/+JQVw2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=P8VjmBTs; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="P8VjmBTs"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Ub0ncQrXcos+Vtndci6TpolefcmtT3BLb8v5TL+7wkQ=; b=P8VjmBTswEn0GySQnBuNkvFEpD
	UYvBS6OCB470nd73ocN47a5OU3P2GfKA+uIsp5lkECxL044JSpY7bz0nMcxBaFf4CRZyVw6QdS/fI
	4NKheyp0puCYmon5uOab9nuVYnl+6VeH0Utd1xaGREmH6oTMq//8Sg7UvkH8UOHZghu5Q4ZJsrv1v
	zVCL5xUHQzGTMcHkyBwPn14wCYH4TYg1GLT2tuqpWfmLvxEleEmyyzTIIsbMfUlH1f1II80+0mBF2
	pTiijEaLSGmAGM++AcztaxR+T05DtVOGoQ8SrNc1tZHULb2G1/iSWmCY3VlXmiEk+G+ABRFNpBetf
	axInmazA==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sw5Ba-0000000030e-1sY6;
	Wed, 02 Oct 2024 21:38:58 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 8/9] tests: monitor: Support running external commands
Date: Wed,  2 Oct 2024 21:38:52 +0200
Message-ID: <20241002193853.13818-9-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241002193853.13818-1-phil@nwl.cc>
References: <20241002193853.13818-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Accept '@'-prefixed lines mixed in between 'I'-prefixed ones and apply
nft input and run commands in specified ordering.

To keep things simple, ignore such test cases when in echo mode for now.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/monitor/run-tests.sh | 61 ++++++++++++++++++++++++++++++++++----
 1 file changed, 56 insertions(+), 5 deletions(-)

diff --git a/tests/monitor/run-tests.sh b/tests/monitor/run-tests.sh
index 214512d269e8d..36fc800c10520 100755
--- a/tests/monitor/run-tests.sh
+++ b/tests/monitor/run-tests.sh
@@ -59,6 +59,44 @@ json_output_filter() { # (filename)
 	# unify handle values
 	sed -i -e 's/\("handle":\) [0-9][0-9]*/\1 0/g' "$1"
 }
+apply_commands_from_file() { # (command_file)
+	grep -q '^# run: ' $1 || {
+		$nft -f - <$1 || {
+			err "nft command failed!"
+			return 1
+		}
+		return 0
+	}
+	local nft_cmd=""
+	local sep=""
+	local line=""
+	while read line; do
+		[[ $line =~ ^#\ run: ]] || {
+			nft_cmd+="$sep$line"
+			sep="; "
+			continue
+		}
+		[[ -n $nft_cmd ]] && {
+			$nft -f - <<<"$nft_cmd" || {
+				err "nft command failed!"
+				return 1
+			}
+		}
+		nft_cmd=""
+		sep=""
+		${line#\# run: } || {
+			err "custom command failed!"
+			return 1
+		}
+	done <$1
+	[[ -n $nft_cmd ]] && {
+		$nft -f - <<<"$nft_cmd" || {
+			err "nft command failed!"
+			return 1
+		}
+	}
+	return 0
+}
 monitor_run_test() {
 	monitor_output=$(mktemp -p $testdir)
 	monitor_args=""
@@ -74,10 +112,7 @@ monitor_run_test() {
 		echo "command file:"
 		cat $command_file
 	}
-	$nft -f - <$command_file || {
-		err "nft command failed!"
-		rc=1
-	}
+	apply_commands_from_file $command_file || rc=1
 	sleep 0.5
 	kill $monitor_pid
 	wait >/dev/null 2>&1
@@ -103,6 +138,17 @@ echo_run_test() {
 		echo "command file:"
 		cat $command_file
 	}
+	grep -q '^# run: ' $command_file && {
+		$debug && {
+			echo "skipping unsuitable test case in command file:"
+			cat $command_file
+		}
+		rm $command_file
+		rm $output_file
+		touch $command_file
+		touch $output_file
+		return 0
+	}
 	$nft -nn -e -f - <$command_file >$echo_output || {
 		err "nft command failed!"
 		rc=1
@@ -182,18 +228,23 @@ for variant in $variants; do
 		# O add table ip t
 		# I add chain ip t c
 		# O add chain ip t c
+		# I <nft input1>
+		# @ <command to run after nft input1>
+		# I <nft input2>
+		# O ...
 
 		$nft flush ruleset
 
 		input_complete=false
 		while read dir line; do
 			case $dir in
-			I)
+			I|@)
 				$input_complete && {
 					$run_test
 					let "rc += $?"
 				}
 				input_complete=false
+				[[ $dir == '@' ]] && line="# run: $line"
 				cmd_append "$line"
 				;;
 			O)
-- 
2.43.0

