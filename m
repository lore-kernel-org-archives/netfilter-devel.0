Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D59233126B3
	for <netfilter-devel@vger.kernel.org>; Wed,  3 Sep 2025 17:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756920193; cv=none; b=NadwdxBgMadTkDsbpEy2aAv3bHW3iKS3KhMG2C7ZarAKx9N8vjK6xd6qehqY2WsM+yrroLKBEna/uv1NCWXWgdyN9DNgapryDIuyUywkosQizaTbkVka9YBl1Ql0Erk6LHJ4c7CjBzokILeBxlEB1D7j6+Hvmrn9ScPEDJsvQ7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756920193; c=relaxed/simple;
	bh=9xF/Ei6V1dXLEzuqf2BFQ/XgLcWyhHmidFDr9JjqmV8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hjgEnfeak5NOjZfiKVU8ChZZaU7SPDZfaTgktCUhrxeF6+miBb3QmTQb5QHAw+M8NJtmfpOD02FTflRzH9IYVei/3gXW9dr3yZ6xWGdcAPoxjnZvhFs0B41qefC6hf/ZdzA7hm4JG7q5DcYcSktVJ9E0jEWRVCpQL2bt5sakTk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=BlLPHAba; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="BlLPHAba"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=8IPg8mLBoucpKxczK35FJaOmla0Uo7drdVHt5k4FgO8=; b=BlLPHAbadeviN5PXFId+J5FEvr
	aHnBAK8nw/0h6K4jRIydDyzha4lm4i3ajgxAwPgXONEGpf2InVhsepXB5iLfT1cYqShEJ4AAwWfd0
	r2SYG3/MZigu7ec9WmE6sd/yxSqnWefswtBbni5zYPclm1Z1YCxh8tjlwdwEJDLlFIqTcdHzQlKNT
	MWhk7NoDBC3riOY73pxrxK+aFsmRkayDZgqlyFUo+AIH3UGhvowitCdSus31WbaxInzf4e5QUWw7B
	eBYVjX65o569UQW3aUjXnOrE6lMbYortEDU1AllEieHbHcgGGb2MZD50NKWfWNyE8QFagA7RF86oS
	D8Ej2EAg==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1utrCQ-0000000080t-1fiS;
	Wed, 03 Sep 2025 19:23:10 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH v3 00/11] Run all test suites via 'make check'
Date: Wed,  3 Sep 2025 19:22:48 +0200
Message-ID: <20250903172259.26266-1-phil@nwl.cc>
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

Have test suites execute all variants by default (patches 5 and 6),
make sure their exit codes
match Automake expectations (patch 7) and register them with Automake
(patch 11). Also fix for running 'make check' as non-root (patches 8 and
9) and calling build test suite from outside its directory (patch 10).

The first four patches are fallout from enabling all variants by default
in monitor test suite, which includes implementing previously missing
JSON echo testing.

Changes since v2:
- Drop the need for RUN_FULL_TESTSUITE env var by making the "all
  variants" mode the default in all test suites
- Implement JSON echo testing into monitor test suite, stored JSON
  output matches echo output after minor adjustment

Changes since v1:
- Also integrate build test suite
- Populate TESTS variable only for non-distcheck builds, so 'make
  distcheck' does not run any test suite

Phil Sutter (11):
  tests: monitor: Label diffs to help users
  tests: monitor: Fix regex collecting expected echo output
  tests: monitor: Test JSON echo mode as well
  tests: monitor: Extend debug output a bit
  tests: monitor: Excercise all syntaxes and variants by default
  tests: py: Enable JSON and JSON schema by default
  tests: Prepare exit codes for automake
  tests: json_echo: Skip if run as non-root
  tests: shell: Skip packetpath/nat_ftp in fake root env
  tests: build: Do not assume caller's CWD
  Makefile: Enable support for 'make check'

 Makefile.am                              |   9 ++
 configure.ac                             |   5 +
 tests/build/run-tests.sh                 |   2 +
 tests/json_echo/run-test.py              |   4 +
 tests/monitor/run-tests.sh               | 182 ++++++++++++++---------
 tests/py/nft-test.py                     |  28 ++--
 tests/shell/run-tests.sh                 |   2 +-
 tests/shell/testcases/packetpath/nat_ftp |   3 +
 8 files changed, 155 insertions(+), 80 deletions(-)

-- 
2.51.0

