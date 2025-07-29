Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D87541D5154
	for <netfilter-devel@vger.kernel.org>; Tue, 29 Jul 2025 16:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753805922; cv=none; b=osPSp4dWWYYa8E+UobF8qnIWSQmUVwucwhY2qFBVAbssn5M/ONdmamcuA0VA84Jhtk9kK9sRT6sEsKzNhHZn+noSqXQFnI6sfiqA/M8R7vUoWYnq+cdQI3RW8qFipGqkFj7EwBQgZQ7XzN5tvpCSjUIyNW/xfvQkDCIcocU0ZTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753805922; c=relaxed/simple;
	bh=y/CN9gz7vOnLnP91Xv+9vs9vWcKfMpsm3UguRdZo7R0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YrZt4l5iZ/itoUGvPWXvbwAKJjAsju87ml1xn+0m6LBvC1gufAkmDJOgoPcBzlZtndfizk8WH5DnCzb1/kbQvPDOgczmAczX/9fmUoz4pLKcELAXUqKhiT0bFMdKBFJrEKBr8MDsP/9HsZI4PTQ1snby3k1oOV9DUGAg5hYCsMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=eqKUUD2z; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="eqKUUD2z"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=N8HEkUWUlzyg12CCVQecRzf7Xfm7ydVOBt6xB6iHZYc=; b=eqKUUD2z5Guaifs4MnfSin6GdN
	Vu0DlvXqle9vMqkH4XmS++R7nblt7aLMXwY/BE03vICfftjXYK8slF+wJ2YxirD9v5yguHlDy/uZP
	cROZkTcdaIM6Uhp/fQ+EdfxcKotVvGgQgfqc4Kjj9skRH3EeIGfVVIlq1cyu3ZhHpiQ42PZCtefUC
	3Cb0/n5zo/53ioWsHFSvMMiCe58CRKl2rb7xB3dKcS5ISh/Cg/1YZOjS+uPcXgPkhiWoWvYnUxznD
	9CqNCVPX/MuuabZmSH1HIs1Yhg8gAwaOuc9mvyU2AXc833Zw/KJentcDRcOgS2c/Jh6OZbANbCHDE
	tbtF5UUg==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1ugn2E-000000005Bi-3ouL;
	Tue, 29 Jul 2025 18:18:38 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH v2 0/3] evaluate: Fix for 'meta hour' ranges spanning date boundaries
Date: Tue, 29 Jul 2025 18:18:29 +0200
Message-ID: <20250729161832.6450-1-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Kernel's timezone is UTC, so 'meta hour' returns seconds since UTC start
of day. To mach against this, user space has to convert the RHS value
given in local timezone into UTC. With ranges (e.g. 9:00-17:00),
depending on the local timezone, these may span midnight in UTC (e.g.
23:00-7:00) and thus need to be converted into a proper range again
(e.g. 7:00-23:00, inverted). Since nftables commit 347039f64509e ("src:
add symbol range expression to further compact intervals"), this
conversion was broken.

Changes since v1:
- Apply the parser changes of commit 347039f64509e to JSON parser as
  well (new patches 1 and 2)
- Misc fixes in patch 3

Phil Sutter (3):
  expression: Introduce is_symbol_value_expr() macro
  parser_json: Parse into symbol range expression if possible
  evaluate: Fix for 'meta hour' ranges spanning date boundaries

 doc/primary-expression.txt              |   3 +-
 include/expression.h                    |   2 +
 src/evaluate.c                          |  25 +++-
 src/parser_bison.y                      |   6 +-
 src/parser_json.c                       |  12 +-
 tests/py/any/meta.t                     |   9 ++
 tests/py/any/meta.t.json                | 182 ++++++++++++++++++++++++
 tests/py/any/meta.t.json.output         |  18 +++
 tests/py/any/meta.t.payload             |  51 +++++++
 tests/shell/testcases/listing/meta_time |  11 ++
 10 files changed, 306 insertions(+), 13 deletions(-)

-- 
2.49.0

