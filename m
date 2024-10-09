Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3C7318FDAF
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Oct 2024 10:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728471052; cv=none; b=rfHcTuVYZED3J2bjgHkhacMZzt9PBiIzKUW+q2JtVd7ja078VKZX9C4ajSsv9iK8ZRGJqJA0s+wo6gB7JD5lesO3oIvfb8Tn+KVox5lAJ0JqgBsN1Jn7V21+9unlOaOyqZZ3zoxgVu9QDC9x2T6yYdUP2hyOeVLSxSH/T197ex4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728471052; c=relaxed/simple;
	bh=tnaooQaY5QB/8BnnsjBwdORRWyyC4j1t2hoCfr4BJTU=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=eIpdQJDi+WpgU42sLdUyDA31pkKvJWMwQMFfR/hgz30PC7z3Q7lYrsq726G0Tw5JiYI/ZTvSicJdAZOCzduzsEllW9k6mASg4fYeoBm912NHGvPSa4BvAQPB1psEsyEP/+8kF0PImUdp4DJ++rA/iHi3JMF9Ua2SZV5Hvmeq+5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=fUNAILA2; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="fUNAILA2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=yxWVzGd9sQTBMLuTQHSEkkyhJs/O2J+2NcYeE0+QwLQ=; b=fUNAILA2ZJAplOSUhfwq/w2/bX
	HuGDyGELAKeJIlh7dzkOjSGfu1evJpy1kdcKXab1n2mdG/iCKlHsmQZBKtgM8PA2A6Zd2EsjjwKC5
	mC+njQ089zxDJPurw29xe9yG1Girho3DiSVp6IP5cU1UBRdoCzL5xuoJIaP4Z2e1R/j3ahpHrVPan
	P5IJ5HvveTpJRMWGUJ8x7ihyYR+IHwQZN2FzgWTKfkZEoUEY8c5UUbMznuoLGrjS32vunzpWGeaQd
	FxR4DR7WW4Z74FLx3CiJlzmk12ufWuCwEUArIXV/v49hyYTrLiqZjzWriCXem2eU7F3kpzzvLgEm7
	qXnwXl+w==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1syUHC-000000007QE-01CL
	for netfilter-devel@vger.kernel.org;
	Wed, 09 Oct 2024 12:50:42 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 0/5] Some minor fixes
Date: Wed,  9 Oct 2024 12:50:32 +0200
Message-ID: <20241009105037.30114-1-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Correct some things I noticed while working on something else. Nothing
depends on those, so push them separately.

Phil Sutter (5):
  tests: iptables-test: Append stderr output to log file
  man: xtables-legacy.8: Join two paragraphs
  man: ebtables-nft.8: Note that --concurrent is a NOP
  gitignore: Ignore generated arptables-translate.8
  xshared: iptables does not support '-b'

 iptables-test.py          | 6 ++++++
 iptables/.gitignore       | 1 +
 iptables/ebtables-nft.8   | 3 ++-
 iptables/xshared.h        | 2 +-
 iptables/xtables-legacy.8 | 1 -
 5 files changed, 10 insertions(+), 3 deletions(-)

-- 
2.43.0

