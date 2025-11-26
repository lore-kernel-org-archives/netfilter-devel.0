Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06E8B30E85B
	for <netfilter-devel@vger.kernel.org>; Wed, 26 Nov 2025 15:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764170048; cv=none; b=fCBhiy1MSz6IgtEyL6Ie398qB/q32gCzSmElZo4iCOv11CoSfdv2EHTDAXn05ezSGPCvTHLHaA2Ki4Z8J5Gv+EGp9zF2TbP0cNRNqmCmpFki9HYzKXHhaIiNemOT9+4RrTsCjZanvCWk2Fz+jXXXluAYCTiazcopxS4Ri3VZNNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764170048; c=relaxed/simple;
	bh=ZBKX+AMPUw5AQd5v3tufkkcZMxrdHG0EflH610FRDvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kpm9Cccwd10/cX0DmP3gvUXVAyJOz/NepQWFZkJy+EEbb0ob3AxmnDLkMXJb6nhEWfT7QGzhayXlkUrd3lgscxra8xH4rD/P8o6Mn5muMLofL8J2Tu7Wo4PKrVTKGNJnzgzitvcZzShwX50DtFe1vhDLLqz9cQO9jYRERh2hBWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=pRUxiDgb; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="pRUxiDgb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=5EyvZifZd93mb/keQraJ7xW3isLrsqScJWCdNXCb/NA=; b=pRUxiDgbimRMlhJm/hPDtY3kOu
	3t10WTtwT+NUM1b/Y4mN+M3SJz3apBsoJIq8CJYynClnwd8aFVbsAeBnh9PFLHHgkkNyt1XSI33R+
	S59fm1bXKehaqsjj2GrDYzifq4Mr9FKAFZU7I08qy1PtdRzmyFBeLZs8bPUye+giZPkJg5CygcyRl
	a4Gt9c/2SQ6t909AMxIM6aQpoFGwn0gjuyVVJCewCsbivtA4Jq5zGZ+mn7E67j4o4GmOuGScZGZe3
	HnpqY2gUpg9Z0stXTDDYnyxLA+/54U8dmfdiSpU+7nfl+p433BRcugrst3j9MfGKMTD/GkxCYu8Es
	CTrEuznA==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1vOHDQ-000000001Ax-1JBW;
	Wed, 26 Nov 2025 16:13:56 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org
Subject: [nft PATCH RFC 0/6] parser_bison: Less STRING more tokens
Date: Wed, 26 Nov 2025 16:13:40 +0100
Message-ID: <20251126151346.1132-1-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introducing new tokens should be harmless as long as they are scoped
since it won't harm existing rulesets using them for user-defined names.

Leverage this to offload more input parsing to flex/bison, thereby
reducing custom code size.

This series is marked RFC mostly for the last patch which introduces an
exclusive start condition to defeat the scanner's tendency to fall back
to STRING token when one really wishes it to split up the input string
as all parts are well-defined.

The other patches are less debatable but given upstream's hesitation to
add new tokens in the past, I'd like to propose this as a formal policy
change.

Phil Sutter (6):
  parser_bison: Introduce tokens for monitor events
  parser_bison: Introduce tokens for chain types
  parser_bison: Introduce tokens for osf ttl values
  parser_bison: Introduce tokens for log levels
  parser_bison: Introduce bytes_unit
  scanner: Introduce SCANSTATE_RATE

 include/datatype.h           |   7 --
 include/parser.h             |   1 +
 include/rule.h               |  12 ++-
 src/datatype.c               |  61 -----------
 src/evaluate.c               |  22 +---
 src/parser_bison.y           | 204 +++++++++++------------------------
 src/rule.c                   |  22 +---
 src/scanner.l                |  76 ++++++++-----
 tests/py/any/limit.t         |   6 ++
 tests/py/any/limit.t.json    |  70 ++++++++++++
 tests/py/any/limit.t.payload |  20 ++++
 11 files changed, 226 insertions(+), 275 deletions(-)

-- 
2.51.0

