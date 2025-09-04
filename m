Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A94F8277CAF
	for <netfilter-devel@vger.kernel.org>; Thu,  4 Sep 2025 15:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756999509; cv=none; b=DK+fznWpgNTz+8swh9ilnre11Y+hPVQFKVUMW8QP3pbPLxkhd90Ejy45rqFuzDSszw5fiTaqa6dFytYeZP1QT/zW6npxpNXVO6F9eFwS/7pe2/GFWmHIcqDJ6HjEyKDrfUtcE6f7I8MWl6A53q/WCTDQLrCxcPkOf2qrjRSfZ4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756999509; c=relaxed/simple;
	bh=r3p6lfMMvBSpEJSNG1idWgISjVeVxHjZ7fb9vhC4JMA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iUFsNKyT4t1cGCIQI9fdclDx3D9RZdzgko1/ExDdmWSdk6iLJwklrQuP2qog5rmh1pMEX2AoSMFhBFgFg2dTtDga7UvWMS1NM69VR4A6dyhSRnTv+wGjuPLTafXdgUEFtwfe+8Wjv95JJhZ7dohOTGOt4X6G15s9RTkvAmH6WHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=mcuiVyxI; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="mcuiVyxI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=44y1t7vI8GK2G+mDZygXwHB0WXjtKJSYqX0tM3ncQSk=; b=mcuiVyxIrrU+xXdkfSvGEM6IOx
	fawOqgVo/nP+FrJQxv471jUF4qpEQ/maY1VeIi3OvoMW2REB6dtJaZbr5snXUCopHS9MdupoB5zMa
	swC8WFA0Da15RfogK+ovERAZc4++cdZUSLyVLFGxbK1um0qCQKykUuk52DBXTQr/KyTBnHxBQB5A/
	4hQFDi4Iox1ktjmnq1APkHNVJoqy5Ku37YZjno9kgTzTjLVjaeWKe9AcP+GlzpBqWdcZ2smqqrfzw
	czbzgaeIE+Fq+NJuoUAkw9gCsxf9e22sgm00SVynOW5vgCYIE/XhFxjyWPp1SbFw2H/cbTs2kxaLW
	w0ZG4cRg==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uuBph-000000001pj-0Un7;
	Thu, 04 Sep 2025 17:25:06 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH v4 0/8] Run all test suites via 'make check'
Date: Thu,  4 Sep 2025 17:24:46 +0200
Message-ID: <20250904152454.13054-1-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Help me (and maybe others) to not occasionally forget to run this or
that test suite in this or that mode:

Have test suites execute all variants by default (patches 1 and 2), make
sure their exit codes match Automake expectations (patch 3) and register
them with Automake (patch 8). Also fix for running 'make check' as
non-root (patches 4 and 5) and calling build test suite from outside its
directory (patch 6).

There is a "funny" problem with build test suite calling 'make
distcheck' which behaves differently under the environment polluted by
the calling 'make check' invocation, details in patch 7.

Changes since v3:
- Applied the initial monitor test suite enhancements already
- gitignore generated logs and reports
- New patch 7

Changes since v2:
- Drop the need for RUN_FULL_TESTSUITE env var by making the "all
  variants" mode the default in all test suites
- Implement JSON echo testing into monitor test suite, stored JSON
  output matches echo output after minor adjustment

Changes since v1:
- Also integrate build test suite
- Populate TESTS variable only for non-distcheck builds, so 'make
  distcheck' does not run any test suite

Phil Sutter (8):
  tests: monitor: Excercise all syntaxes and variants by default
  tests: py: Enable JSON and JSON schema by default
  tests: Prepare exit codes for automake
  tests: json_echo: Skip if run as non-root
  tests: shell: Skip packetpath/nat_ftp in fake root env
  tests: build: Do not assume caller's CWD
  tests: build: Avoid a recursive 'make check' run
  Makefile: Enable support for 'make check'

 .gitignore                               |  13 ++
 Makefile.am                              |   9 ++
 configure.ac                             |   5 +
 tests/build/run-tests.sh                 |   6 +
 tests/json_echo/run-test.py              |   4 +
 tests/monitor/run-tests.sh               | 145 +++++++++++++----------
 tests/py/nft-test.py                     |  28 +++--
 tests/shell/run-tests.sh                 |   2 +-
 tests/shell/testcases/packetpath/nat_ftp |   3 +
 9 files changed, 143 insertions(+), 72 deletions(-)

-- 
2.51.0

