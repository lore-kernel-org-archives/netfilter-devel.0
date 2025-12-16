Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48D23346FD2
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Dec 2025 14:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765896390; cv=none; b=mBa0Ld2tbYMbBT+0IHdPKmtEAVcB/kw9h4ZaHabbW6TQY5nhd3nDbl7i6W9SWaglzgl1jnzN87GZGVaWz41pxTTnKmOxbCNuO+2SFWyGHsBCHhXqwcdFldQJczesu2B0dfeY7WcRodr2ZY3uaC08P+0k1oVUheiZLIEKy/Zi/D8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765896390; c=relaxed/simple;
	bh=KmYxx9USgOyBa03EAExW+6/YONqu+/gUtOwV6CGccAM=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=rSNYjeiQe9OQAuPHElYRsqNWdf9uistKqwh/leXmro9J0COJ6KHMtERxpBg1eeSAHnYSN5pUgAS1mTwpl1Gg06bzl1tMjWw532bQkpg1oJyU1JKkK9TBGj2BI8H+z2UracMPmouyA6SPrEqVsG0gL29oHh1eQLS6aslgHqXNwOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=oaHEkeDA; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="oaHEkeDA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Rx0RWw5epOP+8o7pE5kEbSi3AgNOLQkZ1S7BYHnuYo8=; b=oaHEkeDAUsLbHwabGoapoEXTsR
	A5eJ4bo2Xf2rwU2sMeV3JBCKD1IzIFvxBUWlQyWsbz9XWVzdsY8JobNRuCAb1E8c3rg3S3F8yYMSF
	Dfgvqyb+q7OmZP0If98eGgQSRxJD/4kJ7iGmgxdXmoUI6QimHP9BDGW6/69tZJhHp2lQPMi7+qGH4
	PUtX/umGu7Ww3KZrCehLx1TsDM/BzDMQhOyf/BsxUWGctGrzO+vwl7pigUOBMkp+cnshBA1sakSTo
	3BBGKiU/GSYbFu0adoirsnGdYKZ4Ro6VfLGkH2gTREL86mCcyBcN5QU/nAzN6vCLoumk0mZ5dHb2h
	7ob/UHEw==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1vVWJe-000000007Ar-3LH9
	for netfilter-devel@vger.kernel.org;
	Tue, 16 Dec 2025 15:46:18 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [nft PATCH] tests: monitor: Fix for out-of-path call
Date: Tue, 16 Dec 2025 15:46:13 +0100
Message-ID: <20251216144613.10873-1-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When called from another directory without specifying test cases, an
incorrect regexp was used to glob all tests and no test was run at all:

| # ./tests/monitor/run-tests.sh
| echo: running tests from file *.t
| ./tests/monitor/run-tests.sh: line 201: testcases/*.t: No such file or directory
| monitor: running tests from file *.t
| ./tests/monitor/run-tests.sh: line 201: testcases/*.t: No such file or directory
| json-echo: running tests from file *.t
| ./tests/monitor/run-tests.sh: line 201: testcases/*.t: No such file or directory
| json-monitor: running tests from file *.t
| ./tests/monitor/run-tests.sh: line 201: testcases/*.t: No such file or directory

Fixes: 83eaf50c36fe8 ("tests: monitor: Become $PWD agnostic")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/monitor/run-tests.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/monitor/run-tests.sh b/tests/monitor/run-tests.sh
index 44f21a285b17c..26293e12b9a01 100755
--- a/tests/monitor/run-tests.sh
+++ b/tests/monitor/run-tests.sh
@@ -253,7 +253,7 @@ total_rc=0
 for syntax in ${syntaxes:-standard json}; do
 	[ $syntax == json ] && test_json=true || test_json=false
 	for variant in ${variants:-echo monitor}; do
-		for testcase in ${testcases:-testcases/*.t}; do
+		for testcase in ${testcases:-$(dirname $0)/testcases/*.t}; do
 			run_testcase "$testcase"
 			let "total_rc += $?"
 		done
-- 
2.51.0

