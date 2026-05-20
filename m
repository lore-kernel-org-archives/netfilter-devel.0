Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A12B1175A6A
	for <netfilter-devel@vger.kernel.org>; Wed, 20 May 2026 02:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779244467; cv=none; b=YqFEiT+J8WONebREYbHiMX0fH7M81dD7JABscs+JrCvT8UsRsbqVh1amlBr9O+gBiRb8UCxewh6dck1Din8Swf7zUXLY7AwUdQnketSk080UfywC/IX948fQeehUArHKbsVc6UCADA3YaiYtf9ReZS6zWOJVKLZfbfWBbQJ7KjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779244467; c=relaxed/simple;
	bh=FmzVp4r4lEfQyJXQ2JQckZGiTUFm7NiwWpDYsS6Km58=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uf254qe6+wZeu7zW5HileX9mOu50u7FyYKPciVAPA+oZsfqIlUICPB5s3tShRV7bcVKxNCYU19apgEgTXJ2vL0hSoriCa4DRifDrlYgqqXr/hSM2xaaEkLa9kwOCxorqkyCz5vyg0ttZQIvhjWuBtJosdHwaXQfPkmTzJa6AF+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=bW68U/eP; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="bW68U/eP"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779244462;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=b1oYtr07/stAVenaMRYvf1EjHOcGs8LpSJix+c+MGIw=;
	b=bW68U/ePX8+RLCl9zd6LZfamGX/rg9OQICpidP/jIVdXCI7TnGHFKXuI6249untq+XLmJT
	9iqg1mNeo4d+xI70zpWdvZQC7ZTISSGc3TWE1xY55FaysSrBRgeZhp352KBhQnaO/Hv9ly
	dgY5jF9euxHMuj4aGKCQ7WzSgisHWfU=
From: Jiayuan Chen <jiayuan.chen@linux.dev>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	coreteam@netfilter.org
Subject: [PATCH nf v2 0/3] netfilter: nft_fib_ipv6: handle routes via external nexthop
Date: Wed, 20 May 2026 10:34:08 +0800
Message-ID: <20260520023411.391233-1-jiayuan.chen@linux.dev>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Patch 1 switches the fib6_siblings walk in nft_fib6_info_nh_uses_dev()
to list_for_each_entry_rcu().

Patch 2 fixes the slab-out-of-bounds when the matched route uses an
external nexthop object.

Patch 3 adds a selftest covering single nh, nh group and old-style
multipath.

v1: https://lore.kernel.org/netfilter-devel/20260519041431.396218-1-jiayuan.chen@linux.dev/

Changes since v1:
  - new patch 1: list_for_each_entry_rcu() conversion split out
    (Suggested-by: Phil Sutter)
  - patch 2:
    * drop redundant ternary in nft_fib6_nh_match_dev_cb (Phil)
    * drop redundant "!= 0" on nexthop_for_each_fib6_nh return (Phil)
    * use READ_ONCE() for rt->fib6_nsiblings (Phil)

Jiayuan Chen (3):
  netfilter: nft_fib_ipv6: walk fib6_siblings under RCU
  netfilter: nft_fib_ipv6: handle routes via external nexthop
  selftests: netfilter: add nft_fib_nexthop test

 net/ipv6/netfilter/nft_fib_ipv6.c             |  18 ++-
 .../testing/selftests/net/netfilter/Makefile  |   1 +
 .../net/netfilter/nft_fib_nexthop.sh          | 152 ++++++++++++++++++
 3 files changed, 170 insertions(+), 1 deletion(-)
 create mode 100755 tools/testing/selftests/net/netfilter/nft_fib_nexthop.sh

-- 
2.43.0

