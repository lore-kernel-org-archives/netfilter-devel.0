Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DCD646B5
	for <netfilter-devel@vger.kernel.org>; Sat, 23 Mar 2024 02:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711161462; cv=none; b=aCtWqv84HC/obpmh0Wli2UsP1ST1xkxw16ILnnp3CxJJ9lIrSQu+NOwsn/Ux9NCa/67eNhHuDclFdN2Vmt2+3eM1aDFJMngH9zSFaJVX6wWNHOiD3q7WDGq/vdBQMn9DRkD0t/irzo93tfYYKhidfpd2SyvF7MHIoa4+h8JhyRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711161462; c=relaxed/simple;
	bh=vxm91y6dfuxKiAYU38XwYeKsFs7nZ++c5WLa6VkU5s0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HUz/sZ4PCSCMPRVG/5Tq5zq5eZdfkc21osc+tWrEMU5DcoWAkZIhMHF7QnBdGiDb+JPRBcJ5h+Z4wORZhMRzeiNo9HWsZxva22gTDivqJpNU8gPgF9wmMWVyuh3psTrNYfO1Z0ER1tUJHz2pqF4xuO3w8w4lMp0t97zVH8CEX38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=nFspAzbW; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="nFspAzbW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ZfFl4i4P0HRA4vhae9NFrPn74b8wjhQ4BqDTMf1KZzM=; b=nFspAzbWwNZ8yfJCZHav0bwbRZ
	tYs1W1LZWv7BkyTcNGUqGSDZjAWqAfgW8ML4XREUl9k3sYciEXqAUH7+OT1VXJt+tUU6+yZTMUatb
	UmO+A5Ki1AlC+tXHOQGEtRu1Zv0PZzeF1nfqEdpUCco43lowcnEZuWSHlH/QP5ataJCoTsLC+oqeR
	LA/e6qYVwMtO0t6dWQ1EApyZDSd8fOYOKdoCvQDwXBEpEfhV6JwtvxiJOMSGteL/8wNW/wORcdh0G
	YYZXuBUyf+gpj/ME8kg/gDbsl5G9vcf/lTM10aIE2HamdH5fCNMEL2mJgLHS0qFVIbm00Bx/1a4Pv
	ZZVc2JTg==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1rnrGK-0000000089q-41FY;
	Sat, 23 Mar 2024 03:37:36 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Thomas Haller <thaller@redhat.com>
Subject: [nft PATCH] tests: shell: Avoid escape chars when printing to non-terminals
Date: Sat, 23 Mar 2024 03:37:33 +0100
Message-ID: <20240323023733.20253-1-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Print the 'EXECUTING' status line only if stdout is a terminal, the
mandatory following escape sequence to delete it messes up log file
contents.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/shell/run-tests.sh | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tests/shell/run-tests.sh b/tests/shell/run-tests.sh
index 86c8312683ccb..6a9b518c3aed5 100755
--- a/tests/shell/run-tests.sh
+++ b/tests/shell/run-tests.sh
@@ -860,7 +860,7 @@ job_start() {
 	local testfile="$1"
 	local testidx="$2"
 
-	if [ "$NFT_TEST_JOBS" -le 1 ] ; then
+	if [ "$NFT_TEST_JOBS" -le 1 ] && [[ -t 1 ]]; then
 		print_test_header I "$testfile" "$testidx" "EXECUTING"
 	fi
 
@@ -873,7 +873,7 @@ job_start() {
 	$NFT_TEST_UNSHARE_CMD "$NFT_TEST_BASEDIR/helpers/test-wrapper.sh" "$testfile"
 	local rc_got=$?
 
-	if [ "$NFT_TEST_JOBS" -le 1 ] ; then
+	if [ "$NFT_TEST_JOBS" -le 1 ] && [[ -t 1 ]]; then
 		echo -en "\033[1A\033[K" # clean the [EXECUTING] foobar line
 	fi
 
-- 
2.43.0

