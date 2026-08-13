Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C00C847126D
	for <netfilter-devel@vger.kernel.org>; Thu, 13 Aug 2026 11:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786621567; cv=none; b=Y2yUltthEbBTyNASP0AdNwcryUvaAT0orPwW9VvubpMYqUJt2BzpPOUhIZiHf/yfPblHHRj6IYQDF5/Qe4nL0a5CDKNsq4QbfH0aBQrZ5TYJ34EoDpPhrT0r5aI/ckluNlcryDdHBTQDdzHJhKhQki0sNArGdofHTvgDzQP8SB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786621567; c=relaxed/simple;
	bh=DD2LI5tpAbCScpCdhg/sFLjZoL/t97a9aB/3Hzjb7B4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aF3y/AMROwVp/1VzYvQXMWqweUCE6tsG7pPaYMpeJ2u902yI/ZRyqycgmAwfDIWvtzWbW2/EH2LjhUuPb9jZ+vIbHsJLO4IhaQtLuY52l5OvHLtkP2gEYwStQBDqrrox/rrxkszAVrwb4oY/7y7qAyNiMzO+BekFvZ6ZGtlNXYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=ANaW4sqQ; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="ANaW4sqQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=1cppiDnZ8oTns1Bsu+jf/JvwKaqJnQWJVNv5Zl6bP3E=; b=ANaW4sqQ7U5lsSy+CHXHkqBDYt
	GFbOmYHDVc7HalFn/m8fJ1xCqQX3TsxCTXoOUq9RKYgwA5In7mXoEaq9R/5BSJcD3KJvijA1cLckK
	yikjgKIRJO+wHvMeIHS+7M98+f7whspRU3p7ZDxf4Bw1eDJbO0mYcqD4Hmp4A1bD6YncrDXaGPPDN
	Zi/hy1BXKq14DyVhyNwSL2Aj8Uha2aeN/5hYRZLrdcETI5gAs1nmKftOcr8Hh943dv7cPDxgKjqSQ
	W3ALlQ1d5nqsIBYotmtygVmT5+c/8Aph1DKCQtFBY7Fj/z+UA+GPXIDEFB8VDHF5Rp+0ydIp6zxtp
	CYco+5ww==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1wuTsn-000000002Gs-2Yxd;
	Thu, 13 Aug 2026 13:46:01 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Avinash Duduskar <avinash.duduskar@gmail.com>
Subject: [nft PATCH 1/2] tests: shell: Use --numeric-protocol for dumps
Date: Thu, 13 Aug 2026 13:45:55 +0200
Message-ID: <20260813114556.2685869-2-phil@nwl.cc>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260813114556.2685869-1-phil@nwl.cc>
References: <20260813114556.2685869-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The py test suite does this as well. Protocol names depend on contents
of /etc/protocols which is not in control of nftables. Using numeric
protocol values for dumps therefore prevents the host system from
compromising test results.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/shell/helpers/test-wrapper.sh | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/tests/shell/helpers/test-wrapper.sh b/tests/shell/helpers/test-wrapper.sh
index 7a73e531f7e42..78a01d5666ec2 100755
--- a/tests/shell/helpers/test-wrapper.sh
+++ b/tests/shell/helpers/test-wrapper.sh
@@ -152,21 +152,22 @@ fi
 
 rc_chkdump=0
 rc=0
-$NFT list ruleset > "$NFT_TEST_TESTTMPDIR/ruleset-after" 2> "$NFT_TEST_TESTTMPDIR/chkdump" || rc=$?
+chkdump_nft="$NFT --numeric-protocol"
+$chkdump_nft list ruleset > "$NFT_TEST_TESTTMPDIR/ruleset-after" 2> "$NFT_TEST_TESTTMPDIR/chkdump" || rc=$?
 if [ "$rc" -ne 0 -o -s "$NFT_TEST_TESTTMPDIR/chkdump" ] ; then
-	show_file "$NFT_TEST_TESTTMPDIR/chkdump" "Command \`$NFT list ruleset\` failed" >> "$NFT_TEST_TESTTMPDIR/rc-failed-chkdump"
+	show_file "$NFT_TEST_TESTTMPDIR/chkdump" "Command \`$chkdump_nft list ruleset\` failed" >> "$NFT_TEST_TESTTMPDIR/rc-failed-chkdump"
 	rc_chkdump=1
 fi
 if [ "$NFT_TEST_HAVE_json" != n ] ; then
 	rc=0
-	$NFT -j list ruleset > "$NFT_TEST_TESTTMPDIR/ruleset-after.json" 2> "$NFT_TEST_TESTTMPDIR/chkdump" || rc=$?
+	$chkdump_nft -j list ruleset > "$NFT_TEST_TESTTMPDIR/ruleset-after.json" 2> "$NFT_TEST_TESTTMPDIR/chkdump" || rc=$?
 
 	# Workaround known bug in stmt_print_json(), due to
 	# "chain_stmt_ops.json" being NULL. This spams stderr.
 	sed -i '/^warning: stmt ops chain have no json callback$/d' "$NFT_TEST_TESTTMPDIR/chkdump"
 
 	if [ "$rc" -ne 0 -o -s "$NFT_TEST_TESTTMPDIR/chkdump" ] ; then
-		show_file "$NFT_TEST_TESTTMPDIR/chkdump" "Command \`$NFT -j list ruleset\` failed" >> "$NFT_TEST_TESTTMPDIR/rc-failed-chkdump"
+		show_file "$NFT_TEST_TESTTMPDIR/chkdump" "Command \`$chkdump_nft -j list ruleset\` failed" >> "$NFT_TEST_TESTTMPDIR/rc-failed-chkdump"
 		rc_chkdump=1
 	fi
 	# JSON output needs normalization/sanitization, otherwise it's not stable.
-- 
2.54.0

