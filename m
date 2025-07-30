Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83E6B20297C
	for <netfilter-devel@vger.kernel.org>; Wed, 30 Jul 2025 22:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753914352; cv=none; b=ihCsAY8wAiXpgF7/COrd2vYNwFE/OkuR9Ty2Lp3XMp2E+UMquqz2SdvyvQX7SW80Diy9T6Yo2GnxlL15wuMNB7Uz2OwTHYuTlosyx0OJy/8beJp3I/AKzUfK3TTYtf+K7pDj16TdlJJ4kul8du0vq2p+rs7vXqHgxnznlkDYZzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753914352; c=relaxed/simple;
	bh=te/c7Ys2FTwrXOTUBbtUzY8q/Del491H6gkhPg+NtWs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HYYUvsIPDP1JGQh55eCm/z08QPA3CCvaSLox6RAo20ZvWD2Q8vXu+fw+O9Xwv5VTeK2tWwL2hmNvs7jekW7UFkbVDly9PI9e4bqOtHB6QWoG4KweMriLo6VvsRM3dQC3cW2Lqkx4VgmKO3lOrGsOCXe46jRatt/k1I9VKUlMnws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=GXOn9J6F; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="GXOn9J6F"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=c13+2T1hene0OWE4BWEWs5uqxapP3ho0nx9JTgepB48=; b=GXOn9J6FrCC3jkTGI4g1liveoA
	21VepHTSQLaEi/ZmNuNCXu1274qLdXEmSNCW2alGMkQMKYvLYkwK06vj7hsQ/oVZrdGFmxH9qvNmO
	Ic6lErZcfLouTatJf0pKClV0FTh8h4BFGmIHAGEUTW3KY4JsUhiXBrmeX0Q7ekLa5BNwYtGBkM/3i
	kSZl57fTLCKXb3N4uDqVRLmKr68gGx5y/hcxe28dyHWoGQFJ56T926hMMU/xf3JnUZg9/ZTh9Re6m
	+h5H10+N+NaFYkKtNVgomZQ/Rr0c/jrx+Ty6shwXlW3wFz/JNs02rwWQC/s7Ae8G38/jrMNW9U5YH
	hnOueYWQ==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uhFEz-000000004RV-1beT;
	Thu, 31 Jul 2025 00:25:41 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH v3 0/3] evaluate: Fix for 'meta hour' ranges spanning date boundaries
Date: Thu, 31 Jul 2025 00:25:33 +0200
Message-ID: <20250730222536.786-1-phil@nwl.cc>
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

Changes since v2:
- Must continue handling for EXPR_RANGE type, it is still in use

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
 tests/shell/testcases/listing/meta_time |  30 ++++
 10 files changed, 327 insertions(+), 11 deletions(-)

-- 
2.49.0

