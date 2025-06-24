Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83631307481
	for <netfilter-devel@vger.kernel.org>; Tue, 24 Jun 2025 16:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750783099; cv=none; b=g1TuPM9ddVp0dA3Z521ahB1hNd9dbkaIDo+7MWhA3PUV1HPadJYhmSzb1xWNV2LcJHDzEEOpyjxbZD1QK8XTdShT2NJ4dIstB7LvNwvBNqpJMuUus/zDg7d6gGlfe83ApTNhV76je4+dF52TSlAmHqLlO9wlZnp4/nAovf6GNQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750783099; c=relaxed/simple;
	bh=OYtkc6C9ksRVJTtxPnB4PpojPb3Juhwy9Cd4NuyLtpU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=nFMhJYfLcFZM3nutxIYLmeyEhK2m//xgqECsuxHCeEdmV0K0yNoXyfA/Vn4bQY1EBztJeU0ZcBBkS8wNZjkEEbIEomxjBIaxlzgDNRPZJV8W5d6JB3eCRU22DwMo/0xvtp6QhgtNfJDAj+SqLljaY8/rCpGNzIeqw2VwQVZrmy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=cjJgKSwe; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=JJrZLL1p; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="cjJgKSwe";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="JJrZLL1p"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 6CDAA6026C; Tue, 24 Jun 2025 18:38:06 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1750783086;
	bh=0sXoSFwy8XgmvIQz84oa081LShekRS11FSuJeMyANhI=;
	h=From:To:Cc:Subject:Date:From;
	b=cjJgKSweUUjAYzaeds/Ukz1moQHAp3lyiPkgaxdL37Int6TeE8SUoejOiqGIq5BmM
	 CJ6iPOnoDXX+3FFYcnVs0qIUcaR5DWMHWyiNulbT+6JI1SmlgkC9IgV19wn2njBjFP
	 3XNn5pbNSACmBJrAxB5sI8vWbeK9LOoH47e3vew1WiPDcM6WYy2UUfK9aOUJbwhQjK
	 fbaqM7AwBr6ivAmLM3J28N2yVD1sQntYqsXAvNj1O2oz0Xk1I5lWZopY0XmUTpRLBz
	 tr+cYhMP8V+hnFajsTuiCzypiQFTXS4tKJjDwXD61kY6T069FEdpswVoS3Ip2OxGwr
	 FgQj4WTW8oksw==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 8E4E460264;
	Tue, 24 Jun 2025 18:38:05 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1750783085;
	bh=0sXoSFwy8XgmvIQz84oa081LShekRS11FSuJeMyANhI=;
	h=From:To:Cc:Subject:Date:From;
	b=JJrZLL1pFF4s5SrZ+PO0CgbSNarvDUj4wpP2Iy8jp0LgXySBz2pNtRRXXZ6jlf1Sy
	 9To/obVh9swWH1jkLwl72Ys9yknClc0oyQ1KOL6cXVT5HSjVyeVXxA9u0JUzpj6r3D
	 JC/FB+7YVFB+GlF7U0M0zop+YjpgFtQMP2i0TB+A+9g6iUDKsPSUVKRnxjVyp+i5uJ
	 0BCePIpL2eu6Np6w2ySXCXSKnS3ccAqzP8k/L/kR7fSyRqzQu95J+sWStP/U9N/kJ3
	 Y9OBAGWNI1u5T7V4Zh9enobg2GBIofM60Mjnvbw8GSpPPXf0MjepBeSiWMtB38SCE8
	 WwJpKGUfLdyYQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de,
	phil@nwl.cc
Subject: [PATCH nft 0/2] fib expression fixes
Date: Tue, 24 Jun 2025 18:37:59 +0200
Message-Id: <20250624163801.215307-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This small series contains two fib expression fixes:

1) Allow to use fib expression in maps when check for presence, eg.

      fib daddr check vmap { missing : drop, exists : accept }

   NOTE: it should be possible to use this trick instead:

      fib daddr oif vmap { 0 : drop, * : accept }

   but the catch-all element did not exist at the time the fib
   expression was added, so this does not work in older kernels.

2) Allow to use fib expression in set statement.

   NOTE: There are two more expressions that are missing there too:
         exthdr_expr and xfrm_expr.

Pablo Neira Ayuso (2):
  fib: allow to check if route exists in maps
  fib: allow to use it in set statements

 doc/data-types.txt          |  2 +-
 doc/primary-expression.txt  |  5 ++++-
 include/fib.h               |  2 +-
 src/fib.c                   | 12 ++++++++++--
 src/json.c                  |  2 +-
 src/parser_bison.y          | 22 ++++++++++++++++------
 src/scanner.l               |  4 ++++
 tests/py/inet/fib.t         |  8 ++++++--
 tests/py/inet/fib.t.payload | 16 +++++++++++++++-
 9 files changed, 58 insertions(+), 15 deletions(-)

-- 
2.30.2

