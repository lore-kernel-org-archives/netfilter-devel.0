Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3D202D46C3
	for <netfilter-devel@vger.kernel.org>; Wed,  3 Sep 2025 17:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756920189; cv=none; b=dmZPe7SJCkO+bulCUQJwZ5rJDFfyP75+aNFiRAh0Ze6r4bfpo92iazvSL/1ZI6V/6kCvSxXpf1YIldnq8AFKaFDEAixmQeztOXt9YXEWDiHNhqNUpe4xgEGtI83MWGtszsv8V/a6R+sr0NX9u+rxgGPvhI7QUj/f414fvns/Guo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756920189; c=relaxed/simple;
	bh=G7s7HleeoLFpJYkBxee9PIu3+hvHkdr72pizOKlLljA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EgVp+rnqe7b6TSAUe3S7u6/ruffSs0am6Q2ssuzEwGLX8SsbbPhgMJLuxxG+g5JSOs54hQQOQFwlHvPmmyEKfd1j6STV9egCD8Lt9nXjpFVXGz2O5DJR7Hhr2kLtBm33iHYOewFMLrGF7NR3qFiCHk7S9y7eD0kqGW9CO8XqTUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=loFp7g/R; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="loFp7g/R"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=pQ8MOvnOCIvc1Y6L0Rhn3F3v384UoEPqG1klNUP/KQM=; b=loFp7g/RWE0jGBxNRNTBEFVIrx
	nNINO3AdOh84bfedyippuVNNxzwWv1oii4rTeYwgUvNruLpv1xNYyHxsxvM8DfL9f5QgES9+vfOdd
	RUyyaPgWgNp/BCUOLpjm+KvbvrNjMLune4z6V0egtbFBYj4CZwwNTNFwcZ1NIAdjohP7WISXPAZhz
	tUxKJM8c0FS4RCL15kj23fkXdb1rliaHLsct2zmP5pOpIuYNXrSbfkLv3Y0rvOJjsndX+DAQUGh9y
	Mh84lO7Pv+5/3eL+cEu9NCam7bytsmI3jxroVbr38y/qHEmFIhqNyvHqHlVsgHZtdTPqQjnHoAOyA
	m305nfiQ==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1utrCL-00000000806-0EZl;
	Wed, 03 Sep 2025 19:23:05 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH v3 04/11] tests: monitor: Extend debug output a bit
Date: Wed,  3 Sep 2025 19:22:52 +0200
Message-ID: <20250903172259.26266-5-phil@nwl.cc>
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

Dump echo output and output file, surrounded by markers to highlight
empty files and extra newlines.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/monitor/run-tests.sh | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/tests/monitor/run-tests.sh b/tests/monitor/run-tests.sh
index 38c20adb1dc61..b09b72ae034cb 100755
--- a/tests/monitor/run-tests.sh
+++ b/tests/monitor/run-tests.sh
@@ -101,8 +101,9 @@ echo_run_test() {
 	local rc=0
 
 	$debug && {
-		echo "command file:"
+		echo ">>> command file"
 		cat $command_file
+		echo "<<< command file"
 	}
 	$nft $echo_args -f - <$command_file >$echo_output || {
 		err "nft command failed!"
@@ -122,6 +123,15 @@ echo_run_test() {
 		done >$output_file
 		[ $i -gt 0 ] && echo "" >>$output_file
 	fi
+	$debug && {
+		echo ">>> output file"
+		cat $output_file
+		echo "<<< output file"
+		echo ">>> echo output"
+		cat $echo_output
+		echo "<<< echo output"
+	}
+
 	mydiff -q $echo_output $output_file >/dev/null 2>&1
 	if [[ $rc == 0 && $? != 0 ]]; then
 		err "echo output differs!"
-- 
2.51.0

