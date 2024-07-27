Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A75532D60C
	for <netfilter-devel@vger.kernel.org>; Sat, 27 Jul 2024 21:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722116217; cv=none; b=iVu89+3z0Vr5YU82r4J3z5lsOdKQRjMSnWf7RdO3uOvQHMf3zz31XoMIF1grPthYBWzph7meF2x8rFDHTE8pY7GmYyAqZWhDdv5K6BxMmo4QOtAHTPd0j9Af/YAbO++SaLc9E8ZdSplFJo23sJMjimezLkY9HLxoN8/rUgGjzlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722116217; c=relaxed/simple;
	bh=vmeRgOJE2k/IGvz8nD9K6tXLgcud+DXG3XZX03Ams7A=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=sTi0Dyx2BOdZxEYD9UnBP7N8JaaGhyX5N4wl1LEOyR8mD1aePsTBRgqhlzl9icbuKDtAaA19iFOTJmRWFlBancH8C71Tt3dgplqI3Zzdnp7mCb9PuzBx3XqJPGo+RKuc4Pr8g2S3g7OfD5BujdZHczvXnbsWJdPeZBM9q0hxPz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=HWcQXlk5; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="HWcQXlk5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=OTMUnP0f0VtMzdzkcEoqosy82FWpGr6uM3WP9bMdYSE=; b=HWcQXlk5k6O+BO9/H1xjDO/2W1
	RknyVY1fdDmPF0L3YQcyRndw7YCnF8rtp3crZBLDub0Opw7mK+CMyjg6+sbn6ze+QZ7KbL0DxLTXu
	j0E1yDgmaTp6N6FwCZLV5nNw3B788dRoOHDfpbjvPAPMF/KYI9IPSA3LwDRLcZFTD6sw7uHx/QN7v
	4MXBCibvXjlIS2sGB/0GRS3mUo8LUZBVWQWUFcUT08u2fnIZG9U/0aCPOwP1ViJb/C6zmNPohD7GS
	N9OjoGJRvYAxbhsdshwpdjrDUPLtslR+Ir7eiJd8WtsmC9SCvGxEhj/sOuajp4GUhadbK96PNFjya
	Sli/cmVw==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sXp5w-000000002UK-46PA
	for netfilter-devel@vger.kernel.org;
	Sat, 27 Jul 2024 23:36:53 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 00/14] Some fixes and trivial improvements
Date: Sat, 27 Jul 2024 23:36:34 +0200
Message-ID: <20240727213648.28761-1-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With my fix for flushing non-existent chains I inadvertently turned
chain flushes into nops and broke iptables-restore with input containing
a flush early before other commands. The shell testsuite clearly
identified all these issues, but I had tested only the problem case.
This is fixed by patch 2 with patch 1 as basic work.

Patches 3-7 fix other issues I stumbled upon when working on some
approach for forward-compatibility.

The remaining patches are not strictly fixes but trivial enough to just
go along with the rest.

Phil Sutter (14):
  nft: cache: Annotate faked base chains as such
  nft: Fix for zeroing existent builtin chains
  extensions: recent: Fix format string for unsigned values
  extensions: conntrack: Use the right callbacks
  nft: cmd: Init struct nft_cmd::head early
  nft: Add potentially missing init_cs calls
  arptables: Fix conditional opcode/proto-type printing
  xshared: Do not omit all-wildcard interface spec when inverted
  extensions: conntrack: Reuse print_state() for old state match
  xshared: Make save_iface() static
  xshared: Move NULL pointer check into save_iface()
  libxtables: Debug: Slightly improve extension ordering debugging
  arptables: Introduce print_iface()
  ebtables: Omit all-wildcard interface specs from output

 extensions/iptables.t         |  2 ++
 extensions/libarpt_standard.t |  2 ++
 extensions/libebt_standard.t  |  2 ++
 extensions/libxt_conntrack.c  | 46 ++++++--------------------
 extensions/libxt_recent.c     | 12 ++++---
 iptables/nft-arp.c            | 61 +++++++++++++----------------------
 iptables/nft-bridge.c         |  2 +-
 iptables/nft-cache.c          |  6 ++--
 iptables/nft-cache.h          |  2 +-
 iptables/nft-chain.c          |  3 +-
 iptables/nft-chain.h          |  3 +-
 iptables/nft-cmd.c            |  1 +
 iptables/nft.c                | 44 ++++++++++++++++++-------
 iptables/xshared.c            | 16 +++------
 iptables/xshared.h            |  1 -
 libxtables/xtables.c          | 20 +++++++++---
 16 files changed, 109 insertions(+), 114 deletions(-)

-- 
2.43.0

