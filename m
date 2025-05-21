Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C757826B958
	for <netfilter-devel@vger.kernel.org>; Wed, 21 May 2025 13:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747833178; cv=none; b=sFYIBaUtj49IdqYkqHUjWu0qe5lcdWogAvktOaM43dXHbs9bsn8AAmuABgLqSAOYa0uXA5+1aAewsLtBUdwTICG3AU0+akOPsQAPxlHnAMpkax6KorSbR6SPvaHXasQflglD5iJqBXfVSqH5F2SBGnsgtzoIpJdbhf7pVxrs2vQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747833178; c=relaxed/simple;
	bh=6V5p+K8+CxxUled/ZgGpNtDtyQvKT1fC7yDmNzM8ncc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=suBVhyXnuvbY7Hgqqhk1VVPmT4JKZ032A1Hskakki6eKXdciMDrbyaChShvEX1Y7n5Su8Nevl+y7+3EfhLD6yo69SY2hEg2mvOlObIdHR2N7vMcKB42ba2E17l6Of1MZp5lcGTAu82FUsmCg+8KHTYqwupEZrGHCzUo2i4UIS3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=bKXLYftv; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="bKXLYftv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=/pyd5QvvlsjibSiqMX839o/pJcN9GoxT5DaA72Dk1A0=; b=bKXLYftvm3xtUQUBj1twut5D4X
	uTmHpOrRna6mN8U9Kyvy46+AnZ7ixE6/bgQOJIUanEN/W2YFQKizR6K6ALD+GERgyzYp44ZIHI9cJ
	DTxe4i8PgztREJOusNslGF3+ISfYyT+4RXdo7I3hDCGKoJ9w8VTQ06+UC516AyJx2gFJKy0taoFPP
	m2gNvW+5FJdEaY48qY+dGTgwoyAUfBfo3Kk9HvOgtAwE/RPyOaKSrrohbSJLknEkbww7yyIOeCllx
	RdNNHorBbb/1DfhkyZrPf5Q/s6oQGwIsELTtthksb0dtVmwfZck8nOIK41vJn82sIrWRWNGUwGhsG
	yznk7/nA==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uHjFX-0000000083V-3wsu;
	Wed, 21 May 2025 15:12:48 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org
Subject: [nft PATCH 0/4] Continue upon netlink deserialization failures
Date: Wed, 21 May 2025 15:12:38 +0200
Message-ID: <20250521131242.2330-1-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Faced with unexpected values or missing attributes, most of the netlink
deserialization code would complain, drop the nftables object being
constructed and carry on. Some error paths though instead call BUG() or
assert(0) instead. This series eliminates at least the most prominent
ones among those (patches 1 and 3).

Patch 4 prevents object deserialization from aborting upon the first one
with unexpected data. If netlink_delinearize_obj() returns NULL, an
error message has been emitted already so just return 0 to the foreach
loop so it continues with the next object.

Patch 2 is just preparation work for patch 3.

Phil Sutter (4):
  netlink_delinearize: Replace some BUG()s by error messages
  netlink: Pass netlink_ctx to netlink_delinearize_setelem()
  netlink: Keep going after set element parsing failures
  cache: Tolerate object deserialization failures

 include/netlink.h         |  6 +++---
 src/cache.c               | 11 +++++------
 src/monitor.c             |  7 +++----
 src/netlink.c             | 15 +++++++++------
 src/netlink_delinearize.c | 17 +++++++++++------
 5 files changed, 31 insertions(+), 25 deletions(-)

-- 
2.49.0

