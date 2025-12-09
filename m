Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 132662FFFB1
	for <netfilter-devel@vger.kernel.org>; Tue,  9 Dec 2025 16:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765298753; cv=none; b=OyideRPQu9EQjaII3x1/nT2WKi/I4/NuqxaR0MM1TCieCmEX13+huWlfEbrRHCwkux63O/jQGfijgnXGXw9XJfhYFyvdsvyLBw1T3z7Z6/mkR05rHx8uSITJvxE7vKdXDzWyZoDClOL5GV5C8CgjrtZK+IReewj+kLPxdV0v37U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765298753; c=relaxed/simple;
	bh=jlaOkLIiS32AxTDiHzFEm5Sdp2j/l9fAA7qVWQd/314=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=c/N3APiKropRBoS0+l+FOQNoK9MIDtYgCinZ3a+7Til6dj6ujwx/R2USCQ1U7NDEUoguWmRQliAdo3KiolxIjDFrLylNZOVAkVq80rmuWKNAc3Lf6JsbUvNfPj7/6w16A1pnoXVaXFckGXlUgwZto4P+ucisO6QIzfL9m6NVbsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=OYYR9lGF; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="OYYR9lGF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=T+x+YnbalXcdEfeGXK1SgL59LE0VeNj/25PnyF98Kyo=; b=OYYR9lGFosBc1/F7GVp4Oh9+A6
	W6usCD0JS3ahXgP+QMVxJNcXjzRprL7uDereliZTxmbb5P56BPcS0wos8SKz/DYbHPcLssPMxpxXY
	vQQ25XG84Q8a7GR+O+/Hv5y0kCP0yD96MzgTXypgzsEcxYOJcXD2Hr6PcxAlE0VnuSoLljntbYfdx
	T6kWVhIflOcgdLKfbdyyiB0KrfzHXLRU9unoZR8vimCEsg4dsF26J2f8z7LVSw/InEL6/uckJlJqV
	K5sKZd1Jt0ooLG0ECGLS7imdlSQv/xKSkpZVFT5rOMA+e91IeRD6AQCF9/8D4/OX03QpuvpeqjcsX
	9W/kAYJQ==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1vT0qQ-000000007tO-3K69;
	Tue, 09 Dec 2025 17:45:46 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 0/6] parser_bison: Less STRING more tokens
Date: Tue,  9 Dec 2025 17:45:35 +0100
Message-ID: <20251209164541.13425-1-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introducing new tokens should be harmless as long as they are scoped
since it won't break existing rulesets using them for user-defined names.

Leverage this to offload more input parsing to flex/bison, thereby
reducing custom code size.

Changes since RFC:
- Fix up patches 1 and 2 as per review
- Add Reviewed-by: tags to patches 3 to 5

Phil Sutter (6):
  parser_bison: Introduce tokens for monitor events
  parser_bison: Introduce tokens for chain types
  parser_bison: Introduce tokens for osf ttl values
  parser_bison: Introduce tokens for log levels
  parser_bison: Introduce bytes_unit
  scanner: Introduce SCANSTATE_RATE

 include/datatype.h           |   7 --
 include/parser.h             |   1 +
 include/rule.h               |  21 ++--
 src/datatype.c               |  61 -----------
 src/evaluate.c               |  22 +---
 src/parser_bison.y           | 204 +++++++++++------------------------
 src/rule.c                   |  23 +---
 src/scanner.l                |  76 ++++++++-----
 tests/py/any/limit.t         |   6 ++
 tests/py/any/limit.t.json    |  70 ++++++++++++
 tests/py/any/limit.t.payload |  20 ++++
 11 files changed, 231 insertions(+), 280 deletions(-)

-- 
2.51.0

