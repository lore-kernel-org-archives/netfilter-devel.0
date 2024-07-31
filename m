Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9078216D4E2
	for <netfilter-devel@vger.kernel.org>; Wed, 31 Jul 2024 22:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722464833; cv=none; b=OXcgWJKNB+D1B/jo3jKvnOIlSijTa96BZRRSpf6x5WB47HhGRaKKa8vYT7XNpfSkk/IPcdWou7fvhD77iK4pPpfxsV+11hRBqNGHH8us1aHPPC+Hj4qoYDTANhirNeaXVVS5FcaizqvzY1pLLmUnmk1pdulweUOvmA6XvMgcxd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722464833; c=relaxed/simple;
	bh=km61ltp/ISqnazd9jUhqR9CREcpy4B0nyt9L7ZjF0Nc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=by0wQGHzhOrPy2Bp7DhPQx7wK9vs+DglySqUjt5QYbGYzuDUQGfI/2m/Opt4Dz/vNICD0ocDf4YmMjmQYelgdR1uPSoBF5S27XU04aqtNGzZwtvIeIx0y2ZywtHFCtvh9D5Wvix5DHCpEOFUqfScDtjkXbduGv3wUS2HGp24ruY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=cVpso6Me; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="cVpso6Me"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=+n3yFMeTS1/4hrB8H35+aSrrO8kf5mfQIoZ0lOH7DzM=; b=cVpso6MeRMUvMyNdSLwptWWQ7S
	qncU+RS1zfEnWlah0WKnA1Br1U6vGykb+ie1ZGZYR207AhoZi9Nf1qQ/uPblp60AoJTEAotqIG4vI
	8zXF0ArV65bUh0XBDB9JGdDdSNNHfggGY+M7wnKUX6iNiMX+aHW+OVg/QDW7EGX2JGe8knwt22t/l
	ksq8qOqfoEIXBfCa24PfnAGDNmu5TGT8zCGf3pC+jIGgVaudDv5qs4jb2O8uSqkwt0HmW5xXiMFIv
	tzcA4lMczAhWwvd7aANDDQf2PFjrYBjmqpeTN+Jxog7tLtmBDbi5Eaf2eLMHeQ57q0P0JALUUbKko
	CoiPw66g==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sZHmn-000000003ic-2Vua;
	Thu, 01 Aug 2024 00:27:09 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Cc: Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jan Engelhardt <jengelh@inai.de>
Subject: [iptables PATCH 0/8] nft: Implement forward compat for future binaries
Date: Thu,  1 Aug 2024 00:26:55 +0200
Message-ID: <20240731222703.22741-1-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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

For now, appending compat extensions is always active. Keeping it
disabled by default and enabling via commandline flag or (simpler) env
variable might make sense (I haven't tested performance yet). The
parsing component will take action only if standard rule parsing fails,
so no need to manually enable this IMO.

The actual implementation sits in patch 8, the preceeding ones are
(mostly) preparation.

To forcibly exercise the fallback rule parsing code, compile with
CFLAGS='-DDEBUG_COMPAT_EXT=1'.

Phil Sutter (8):
  ebtables: Zero freed pointers in ebt_cs_clean()
  ebtables: Introduce nft_bridge_init_cs()
  nft: Reduce overhead in nft_rule_find()
  nft: ruleparse: Drop 'iter' variable in
    nft_rule_to_iptables_command_state
  nft: ruleparse: Introduce nft_parse_rule_expr()
  nft: __add_{match,target}() can't fail
  nft: Introduce UDATA_TYPE_COMPAT_EXT
  nft: Support compat extensions in rule userdata

 configure.ac             |   9 ++
 iptables/Makefile.am     |   1 +
 iptables/nft-bridge.c    |  12 +--
 iptables/nft-compat.c    | 217 +++++++++++++++++++++++++++++++++++++++
 iptables/nft-compat.h    |  54 ++++++++++
 iptables/nft-ruleparse.c | 106 +++++++++++--------
 iptables/nft-ruleparse.h |   4 +
 iptables/nft.c           | 112 +++++++++++---------
 iptables/nft.h           |  14 +++
 iptables/xtables-eb.c    |   4 +-
 10 files changed, 438 insertions(+), 95 deletions(-)
 create mode 100644 iptables/nft-compat.c
 create mode 100644 iptables/nft-compat.h

-- 
2.43.0

