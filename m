Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6A88288C37
	for <netfilter-devel@vger.kernel.org>; Fri,  1 Aug 2025 16:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754064675; cv=none; b=lmg3SmkHzJ87XdcGQbCQUjm4t6OL/ZHwU97vyc75IleiKep5sohqGkIAmFirQSU8iXdxmJ0D5zpsTp7IbwyULIUc8H3lyOyEThpwf5Q/riHk+a8WiGcDOhC37FiUPgYJi6apD/2FULJZJnVw1Zjh7Zob6SnEeEtSbLanyWr45SE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754064675; c=relaxed/simple;
	bh=3SAobN/CN8gLOhifl3zlFHya3QNAQm7osi8NXTu3/dE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=a3V0hD1Hfwc6SNf9F6agTbMXY6gRisr7n3eJb7pdWQvdJUVvqDaD4Qi9AMvlp404Wmbyg/XjSxb8OWNcPzaOyDgOKx27Ycto86+f/W4YNAvOy6BJMp0+19djE3MDanlnpHvGmW4p9npGMJuxFChWb57GikfIdzpupL4OwAudCBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=n5QkGl1D; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="n5QkGl1D"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=6W6ninryCvoYb/DH6NIXPcEYqWywj9ZeEApMe+w4GlA=; b=n5QkGl1DToKnOa444WzvtnLBk3
	X4d9MFcHqSuFsxDVPQZ1PwQ3E0l/xypv3IQF8NstEiYpvGjDEwLkdixwFb9P7N2EqyX+YjUvBCOAP
	9VsjoTGBYHDtWKS1n3FCeo/ArykMLkN9b6UdV8F5mmtR3Fw6BUjCp51GC8p/OXblWfEl5Ir5TsjVm
	G2OxfYduIZjsgvFFSOvdP6vy0SyQ22PueWY07iDLFijrPVu5nBwc1aIwMhEJSjUgQo6K5NrWa7gfg
	QMk65DM+VgiXFWrhZYCnBpFMV6wOW3aw6+7vRP4RoS6hXi/+/vumNa4T1Hblgjx9ADpN65Yi+tSyO
	xqHttsUw==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uhsLf-000000005IH-1hj5;
	Fri, 01 Aug 2025 18:11:11 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 0/6] Run all test suites via 'make check'
Date: Fri,  1 Aug 2025 18:10:59 +0200
Message-ID: <20250801161105.24823-1-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Help me (and maybe others) to not occasionally forget to run this or
that test suite in this or that mode: Implement "run all variants"
mode in test runners (patches 2 and 3), make sure they're exit codes
match Automake expectations (patch 1) and register them with Automake
(patch 6). Also fix for running 'make check' as non-root (patches 4 and
5).

Phil Sutter (6):
  tests: Prepare exit codes for automake
  tests: monitor: Support running all tests in one go
  tests: py: Set default options based on RUN_FULL_TESTSUITE
  tests: json_echo: Skip if run as non-root
  tests: shell: Skip packetpath/nat_ftp in fake root env
  Makefile: Enable support for 'make check'

 Makefile.am                              |  6 +++++
 tests/json_echo/run-test.py              |  4 +++
 tests/monitor/run-tests.sh               | 34 ++++++++++++++----------
 tests/py/nft-test.py                     | 19 +++++++++----
 tests/shell/run-tests.sh                 |  2 +-
 tests/shell/testcases/packetpath/nat_ftp |  3 +++
 6 files changed, 48 insertions(+), 20 deletions(-)

-- 
2.49.0

