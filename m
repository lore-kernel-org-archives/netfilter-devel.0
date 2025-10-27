Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 356172F12BE
	for <netfilter-devel@vger.kernel.org>; Mon, 27 Oct 2025 22:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761603460; cv=none; b=dR7kSsSS2mRkcRYmMYrecRGBs4GtvNut9t+A1GKaYN2RLHecfS5lK6xMZolmXuAqbyZw0391I5qB2/0xiPzi02jdICyBA/w9yiJFR1RooN/W8eHZ6fncL/Wn0twrhLzlIZBvNs9SsYisTfctImHkPUwXQXFTdFI1XRsDGVc1me4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761603460; c=relaxed/simple;
	bh=vwbvEatYMaIi6dIwwEzYzp8rSGORESjX9HfUB1LQNEI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=S2LQI/K/5WrirH0e+Yd5uVSkGrEzgiaD21me95yij3o2f1/PsggEdmBVRmnwlggo+fbHygX9fcUjk5zbc8cjdcKncs3j7Cn/+ruQIngaPHuFSMYne5sownGfUdfLwwLqHTQklAWNtelXwbF9u413Y0d+pjvwI65NEswfc3Pg6wY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=LYhFjoG3; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="LYhFjoG3"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 8F24B6059D;
	Mon, 27 Oct 2025 23:17:27 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1761603447;
	bh=hW13aKe+5Tl2a9KvsXSyDg3LdvdJPmxJZnkQxd+9iAE=;
	h=From:To:Cc:Subject:Date:From;
	b=LYhFjoG3abjwZJ9ZQFJm6a0REJAcZigsv1mZRfHo/daXUOZjFpcpABOt6upStSdAk
	 sKwk0c64ytBVUcAKilFw9egpf0Ws43BNg1aGWfKwaA66Kgp59N4HKVCQovSRSo8kVk
	 lYRLc3RdimLpD1MWfjiJgfi81GOcl7wv0PYMDvGaU3goakgJyLwvH1DPvRABV4MFIt
	 HIsCD0HubWy7i7h/5ACm732j9CKjZwhYuf8UcNKDMJq0q8r5iHXDN5XCWNS0fgbSD9
	 LGIyp+//pAJfqeAUXhg5SSPma0BZWYaHpEjDP1s2W7txFAyfUUoEkETv09TDSU79IZ
	 wcwS4jE4nu35w==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de,
	ffmancera@suse.de,
	brady.1345@gmail.com
Subject: [PATCH nf,v2 0/2] nf_tables: limit maximum number of jumps/gotos per netns
Date: Mon, 27 Oct 2025 23:17:20 +0100
Message-Id: <20251027221722.183398-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This new series contains v2 to add limit per
-

Pablo Neira Ayuso (2):
  netfilter: nf_tables: limit maximum number of jumps/gotos per netns
  selftests: netfilter: add test for nf_tables_jumps_max_netns sysctl

 Documentation/networking/netfilter-sysctl.rst |  15 ++
 include/net/netfilter/nf_tables.h             |   7 +
 include/net/netns/netfilter.h                 |   6 +
 net/netfilter/Makefile                        |   2 +-
 net/netfilter/core.c                          |   9 ++
 net/netfilter/nf_tables_api.c                 |  95 +++++++++++-
 net/netfilter/nf_tables_sysctl.c              |  91 +++++++++++
 net/netfilter/nft_immediate.c                 |   4 +
 net/netfilter/nft_lookup.c                    |   9 ++
 .../testing/selftests/net/netfilter/Makefile  |   2 +
 .../net/netfilter/gen_ruleset_many_jumps.c    | 145 ++++++++++++++++++
 .../net/netfilter/nft_ruleset_many_jumps.sh   | 118 ++++++++++++++
 12 files changed, 498 insertions(+), 5 deletions(-)
 create mode 100644 net/netfilter/nf_tables_sysctl.c
 create mode 100644 tools/testing/selftests/net/netfilter/gen_ruleset_many_jumps.c
 create mode 100755 tools/testing/selftests/net/netfilter/nft_ruleset_many_jumps.sh

-- 
2.30.2

