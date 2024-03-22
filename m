Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F0D65916B
	for <netfilter-devel@vger.kernel.org>; Fri, 22 Mar 2024 16:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711123613; cv=none; b=EAcXRF4MkXVnkuZ3diqe+E1TG5GAmE/FSUwdyVqFDKY1anPnB7hAKgEmVi8C3iFPzuY2peJMmFd5oNeyMUTJt6MlAbxkK/g4TVW4p6A4l4MPIM99gakDekSvMeu6AUWaWqQUdbCWglONP+yYBdcAZTH3L2XQos0o2tcMMKld2dY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711123613; c=relaxed/simple;
	bh=9NCoA053+wJ+gZbySC1RoPSaZNreFIz9xyN3eT1z5xY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TGtGm4mX497dQoDR82s5Vif3rZvMXDFiZ4vN3TGKQJXllMozRscWT3UyczFULitpeA57JqU43oFgC2Zg0A7bMqOfdN6P99FgIo7Hf0qrHplu4R+iJttFSDKmrZjyy7mSEdUzh2uN1x+y52sbZ7bLuBARg9d4KbTfxPXVgQUdEQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=On5WDjBF; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="On5WDjBF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=NSboospYHG6Ns4GI9qeoZ3aGPG7Tn9IH+8VpLuiTuRY=; b=On5WDjBF4ma+8t4bpqyED9EUYe
	z/nMOlzWfN5jAwPEKuqrVGrMtykUI0qPNmf4XH8JU3nWP3jyzfcIEP7izLp2j4W6jDfj9Orq3ksPs
	eVkGEh/IV6hnZnr++KCHyARF4kNJa0UNHvGphE9LCcBX+uKhnaTo+ud1N8zbC2Yco8VtscWurXnEr
	PfHoTa3MDOXReOp3G2vhRog1pHHrbwo7bs0sL9wz29RqAToKIMHNN4203DSBRMRxnCCyw/CGeCM+H
	wekkeaTdLS9BeKv8UhO/RQ4I5VT0qws0jAftbq5JUTDyQqD3iVmNtmPBvYFsSGyRtRzV15FBiddk4
	pqabrwpw==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1rnhPu-000000000yU-1nGx;
	Fri, 22 Mar 2024 17:06:50 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH v2 0/5] json: Accept more than two operands in binary expressions
Date: Fri, 22 Mar 2024 17:06:40 +0100
Message-ID: <20240322160645.18331-1-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This needed rebase of patch 1 to cover for intermediate changes got a
bit out of hand and resulted in this series:

Patch 2 fixes a bug in set element sorting triggered by binop expression
elements being treated equal in value if the LHS parts match.

Patch 3 collates general bugs in recorded JSON equivalents for py
testsuite.

Patch 4 adds detection of needless recorded JSON outputs to
nft-tests.py, patch 5 then performs the cleanup to eliminate the
warnings it generates.

Phil Sutter (5):
  json: Accept more than two operands in binary expressions
  mergesort: Avoid accidental set element reordering
  tests: py: Fix some JSON equivalents
  tests: py: Warn if recorded JSON output matches the input
  tests: py: Drop needless recorded JSON outputs

 doc/libnftables-json.adoc                     |  18 +-
 src/intervals.c                               |   2 +-
 src/json.c                                    |  19 +-
 src/mergesort.c                               |   2 +-
 src/parser_json.c                             |  12 +
 tests/py/any/last.t.json.output               |   7 -
 tests/py/any/meta.t.json                      |   2 +-
 tests/py/any/meta.t.json.output               | 180 ----------
 tests/py/any/tcpopt.t.json                    |   4 +-
 tests/py/inet/tcp.t.json                      | 189 ++++------
 tests/py/inet/tcp.t.json.output               | 339 +-----------------
 tests/py/ip/numgen.t.json.output              |  30 --
 tests/py/ip6/exthdr.t.json.output             |  30 --
 tests/py/nft-test.py                          |   2 +
 .../dumps/0012different_defines_0.json-nft    |   8 +-
 .../sets/dumps/0055tcpflags_0.json-nft        | 114 ++----
 .../testcases/sets/dumps/0055tcpflags_0.nft   |   8 +-
 17 files changed, 166 insertions(+), 800 deletions(-)

-- 
2.43.0

