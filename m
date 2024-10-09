Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99BC217332B
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Oct 2024 11:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728474507; cv=none; b=nEzm0durx0yiShWQF20n+E0gVOAmXYMMJ1mIWA5JdMmRY6VmjDlL9QVQG1cC8px0KoaYzRdsASAM21S3OJGe5rvxCwW46uLHsUiokN01gZqulqGnmV9UPcNxFsV95CIt/ChMOxS99X3obvW3aNKbZyCJV9b7pZutTfDZCK++xFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728474507; c=relaxed/simple;
	bh=+3CX+8+peMcDmAt6LxFUlE87SBuKQ0AXgEURGxbMM/E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TkZK/EaaY/c8R1Ldun/7hMFL+urUBYbCZtIED8NkX8xGTyLbphbK/sikOttMRj4iZxPKdKzVCm2vt0VgtL/siCK0jAsDHLexEbFJ052WljZz4syPSHXOlMrINj5djAPCPVWjAcEbV+PvDxy3AO9TcVwG7A5HPt6Mq/uWNuDf7Go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=divRFUB1; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="divRFUB1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=kmqIffUiwwznUtRoCXGw8FKG8tWHQEsf2EjLiesCDyw=; b=divRFUB1fiTlphtqx1oksPy+o9
	L5mn7E8f9uIo/ReHa+kKso9PuuqDu83zHPbw5BwYpw9P1qoOLuxRQUN7cMjlvY60msR1QHdkLnCnM
	kWCDR8fkxhu0mOhtPF4Cozs8sXEW/GHLbQcyW2DkvDBm8HzvETXLAXs0FtyvGrTnZS3xvs4C8OVNa
	NIwEeYWjY5HdsCDfV6I3Mc4wI0qGiMZuRe6gpl1ta31gfa6FjV/72KVULevhDAy55400oJsuAx05I
	sHGg6EcDTUX6NmXLXzD1NQaQQ4v8rNRI7f66mOlN91p3Wfqkjbg/nv12RdegcLBaXvpOtCiGZQdsd
	doIbEbNw==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1syVB1-000000008H7-290g;
	Wed, 09 Oct 2024 13:48:23 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Cc: Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jan Engelhardt <jengelh@inai.de>
Subject: [iptables PATCH v2 0/8] nft: Implement forward compat for future binaries
Date: Wed,  9 Oct 2024 13:48:11 +0200
Message-ID: <20241009114819.15379-1-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Changes since v1:
- Split the parser into a separate patch for easier backporting by
  distributions.
- Make the writer opt-in, allow users to force the parser fallback at
  run-time.
- Document the feature in man pages.

Time to abandon earlier attempts at providing compatibility for old
binaries, choose the next best option which is not relying upon any
kernel changes.

Basically, all extensions replaced by native bytecode are appended to
rule userdata so when nftnl rule parsing code fails, it may retry
omitting all these expressions and restoring an extension from userdata
instead.

The idea behind this is that extensions are stable which relieves native
bytecode from being the same. With this series in place, one may
(re-)start converting extensions into native nftables bytecode again.

Appending rule userdata upon creation is inactive by default and enabled
via --compat option or XTABLES_COMPAT env variable. The parser will fall
back to userdata automatically if present and parsing fails.

Patches 1-3 are preparation. Patches 4 and 5 implement the parser side,
patches 6 and 7 implement the writer and patch 8 finally extends
iptables-test.py to cover the new code.

Phil Sutter (8):
  nft: Make add_log() static
  nft: ruleparse: Introduce nft_parse_rule_expr()
  nft: __add_{match,target}() can't fail
  nft: Introduce UDATA_TYPE_COMPAT_EXT
  nft-ruleparse: Fallback to compat expressions in userdata
  nft: Pass nft_handle into add_{action,match}()
  nft: Embed compat extensions in rule userdata
  tests: iptables-test: Add nft-compat variant

 configure.ac                   |   9 ++
 iptables-test.py               |  14 ++-
 iptables/Makefile.am           |   1 +
 iptables/arptables-nft.8       |  12 ++
 iptables/ebtables-nft.8        |  12 ++
 iptables/iptables-restore.8.in |  12 ++
 iptables/iptables.8.in         |  12 ++
 iptables/nft-arp.c             |   2 +-
 iptables/nft-bridge.c          |   9 +-
 iptables/nft-compat.c          | 222 +++++++++++++++++++++++++++++++++
 iptables/nft-compat.h          |  54 ++++++++
 iptables/nft-ipv4.c            |   2 +-
 iptables/nft-ipv6.c            |   2 +-
 iptables/nft-ruleparse.c       |  90 ++++++++-----
 iptables/nft-ruleparse.h       |   4 +
 iptables/nft.c                 | 111 ++++++++++-------
 iptables/nft.h                 |  24 +++-
 iptables/xshared.c             |   7 ++
 iptables/xshared.h             |   1 +
 iptables/xtables-arp.c         |   1 +
 iptables/xtables-eb.c          |   4 +
 iptables/xtables-nft.8         |  11 ++
 iptables/xtables-restore.c     |  15 ++-
 iptables/xtables.c             |   3 +
 24 files changed, 544 insertions(+), 90 deletions(-)
 create mode 100644 iptables/nft-compat.c
 create mode 100644 iptables/nft-compat.h

-- 
2.43.0

