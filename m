Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CB6D3E51F8
	for <netfilter-devel@vger.kernel.org>; Thu,  2 Apr 2026 18:43:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775155412; cv=none; b=OcZ+dR1VS47Kf/QEgmLn5HqTYSI4+XPBjrd88YSdVAAs/5hWW+mjD3/YHzxA0eoNf/8RVilz3jGiARE7jIWYNiOLlPSt00nQXjI/9ASpDaIq7y41DcbEcUTjoqLKp44NHsAVuTSt2UxGEpNA7U1lTd9IsCE1KCQc/zkQQ0OphPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775155412; c=relaxed/simple;
	bh=lBu0NuucJgA3rJeOjlA39DKhlMdmM15HMbce4yL1gH4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lNBCypY9myKTmdlEa1wDR73rkF895FAXaMJVFsiktcM9meuDmynJ5yz11V2K9Gn6gm7mLFC90+bs39TEtx1DhU0Wu7ukJI22y9J0zhca5a4/NjDUilejuXiuxK5fENFHEKlvq5LCca2w7UUHwsPtPmfJhu+nLH01NUVYmt6KDjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Y4dBwfHu; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Y4dBwfHu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=5S/EDGRqNBpqY0K8xxDNyiaQgBNzr7VdyptEAqJDIbg=; b=Y4dBwfHuK5gk1l5Gxi5DUHlLsl
	EUt3/gQ5HkShCEYo8SqHBehU3/8Ir8jpTyn5IkCsiorhb06nY05aruGDdc2lyrzlENS/5aOunX4NI
	8RAgp1vF9AyStRsCW/M1mAAKEUILcoOz+gcEMTfpfhZLvB9T6dg16rfkJ6VbeAPcFGvFFuDZkkLhh
	TlyW2HYd17zFKGsjGN5W8a7c5w5qD8eQLDXTAFQA3Lf/EdGNsXdWmnvwgbpyQBvo8zPgYGw0iRNVV
	b0Y889Ng+HTTmywZ92nJ2PTxRPzhro/4aFMnwZdcHlHw7mKA8iFyBNQM3k9x7K39Bx8cigPewJhEr
	TPJiCKOQ==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1w8N0o-000000005oh-0yik;
	Thu, 02 Apr 2026 20:43:26 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Dion Bosschieter <dionbosschieter@gmail.com>
Subject: [nft PATCH 0/2] A bit of non-constant binop follow-up
Date: Thu,  2 Apr 2026 20:43:18 +0200
Message-ID: <20260402184320.14862-1-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When asked about how to translate ebtables' --arp-gratuitous match, I
noticed that basically everything is there already but the parser
rejects it.

While we can't do a simple 'arp saddr ip == arp daddr ip' because cmp
expression requires for one side of the equation to be constant, using
XOR on LHS we can work around this limitation:

arp saddr ip ^ arp daddr ip == 0.0.0.0

Thanks to Jeremy's work on bitwise expression (which one might want to
repeat for cmp), the above is possible in VM code:

[ payload load 4b @ network header + 14 => reg 1 ]
[ payload load 4b @ network header + 24 => reg 2 ]
[ bitwise reg 1 = ( reg 1 ^ reg 2 ) ]
[ cmp eq reg 1 0x00000000 ]

Patch 2 of this series relaxes the parser so it accepts the input.
Basically it undoes an old workaround needed before we introduced start
conditions.

Patch 1 removes a similar restriction in JSON parser. It is needed at
least to accept the JSON equivalent of above match (conversion to JSON
on output was already correct).

Phil Sutter (2):
  parser_json: Accept non-RHS expressions in binop RHS
  parser_bison: Accept non-constant binop on LHS of relationals

 doc/payload-expression.txt        |  6 ++++
 src/parser_bison.y                | 16 +++++-----
 src/parser_json.c                 |  2 +-
 src/scanner.l                     |  2 +-
 tests/py/arp/arp.t                |  4 +++
 tests/py/arp/arp.t.json           | 51 +++++++++++++++++++++++++++++++
 tests/py/arp/arp.t.payload        | 14 +++++++++
 tests/py/arp/arp.t.payload.netdev | 18 +++++++++++
 8 files changed, 104 insertions(+), 9 deletions(-)

-- 
2.51.0

