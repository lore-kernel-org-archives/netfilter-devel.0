Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 369C2188CC9
	for <netfilter-devel@vger.kernel.org>; Fri, 29 Aug 2025 15:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756482734; cv=none; b=YecpI9u3iDnnIPwwCTpzqnC1ZwR5MTsH0cf7EFH8ioqAKWhvcymrCv3y2mNVrXTwra3Zk3CC/5xDwWv5ArJfGcXpt5oKBUaAwU3FdhW4ueNvXKDCk+50GkAAJGexkvV4lFZr2lu408+hU+kaAWpdh/L8RC9e8Gstvj4QyXNXxoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756482734; c=relaxed/simple;
	bh=p+P2YL62ZDTTv2EYTiCk9Dt9mabg6RcAwTrseteDWKY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=h2mTCawKvJ0IYBxwAYnxt4WWC333zo2qJ+1wU4iEDo4iGfvEi21oTkU23QL00+PVzAq5zG8Nr0DPW84idi+sZh64vtVsxKaAgkALOJ799Pkq47Z03DNJOFubOxdhUTvpwFDNmbuBP80FtWZLN8Qibswk8EN5prRU9Z+pYATT93M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=CpvcwBb8; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="CpvcwBb8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=iSn9m2qHJYaQKyyxduGlW3pOBjm+D8TNO2RYT3vhWlo=; b=CpvcwBb8kZ9YFK2S3blOWNgQpa
	aornDnkWuRE5JO8os8/S0uJujygbVe1cnO10O5rRoRnvZ0xNt3wnhHpxMrY1DEHUMafpRcJ7UA2Xk
	2ESBJrLuLoRWKF4wbtt3HH08CvVO0WSlCcvemXMYyrm5bTsXjhZ3eGU0KAQs1cTa+WgxJ6c2ZqMxI
	6VkmvQrh7JVq6RDmsUuI4HAzO5S7bP89HSdrgVI3IctHaEMT3VOLdZquUteQI8ID1mCpEAQ5M2tVn
	tkefYlT01agKFfJTbpGQvnowbG8qftdo/uSsFfMYL0ujNEhzfAC4vZ6KK6GikaSZgGrt6uebVlRqk
	3oQQkZqw==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1us1Ob-000000001RX-0pka;
	Fri, 29 Aug 2025 17:52:09 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH v2 0/7] Run all test suites via 'make check'
Date: Fri, 29 Aug 2025 17:51:56 +0200
Message-ID: <20250829155203.29000-1-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Help me (and maybe others) to not occasionally forget to run this or
that test suite in this or that mode: Implement "run all variants"
mode in test runners (patches 2 and 3), make sure their exit codes
match Automake expectations (patch 1) and register them with Automake
(patch 7). Also fix for running 'make check' as non-root (patches 4 and
5) and calling build test suite from outside its directory (patch 6).

Changes since v1:
- Also integrate build test suite
- Populate TESTS variable only for non-distcheck builds, so 'make
  distcheck' does not run any test suite

Phil Sutter (7):
  tests: Prepare exit codes for automake
  tests: monitor: Support running all tests in one go
  tests: py: Set default options based on RUN_FULL_TESTSUITE
  tests: json_echo: Skip if run as non-root
  tests: shell: Skip packetpath/nat_ftp in fake root env
  tests: build: Do not assume caller's CWD
  Makefile: Enable support for 'make check'

 Makefile.am                              | 10 +++++++
 configure.ac                             |  5 ++++
 tests/build/run-tests.sh                 |  2 ++
 tests/json_echo/run-test.py              |  4 +++
 tests/monitor/run-tests.sh               | 34 ++++++++++++++----------
 tests/py/nft-test.py                     | 19 +++++++++----
 tests/shell/run-tests.sh                 |  2 +-
 tests/shell/testcases/packetpath/nat_ftp |  3 +++
 8 files changed, 59 insertions(+), 20 deletions(-)

-- 
2.51.0

