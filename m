Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="GrTdrlAw"
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D281BA8
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Nov 2023 05:15:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=kFczb7jnJYvFqgli2NUKHDzJFW5P7BASw4aqZR+CBZc=; b=GrTdrlAw9A9aAFTpjo6zWNgjaf
	uU+cdHDjfZHteM4AXgdj/v3ph7PRz3do5j3183FAUUgrGtFUpzaVNEWNExfdOkhzBks2PKLG9c8Nb
	2gbIuJaYdcswHunhOltysb6yE7L+qQZ6ZXaPRhA9JXtV/9ZJI8kgnsyvUYkhRdbLp1Ifwn6duUoQH
	tunkQC6L6zK6sh+GUsvewBYSWRC1y/4sW1FHd3IXtPtufaC98uDQkz3EJ8gdS16U5Y27OiUAwQ04c
	hTP4zG9/tXnycvoRdnDgUimzWAz387D3Hw2SGu+OQ+oO9PtBuHXsfc2zFM3I7icErlS91XEbI0HVD
	mn4XxSUQ==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.94.2)
	(envelope-from <phil@nwl.cc>)
	id 1r8KPh-0001im-3A
	for netfilter-devel@vger.kernel.org; Wed, 29 Nov 2023 14:15:37 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 00/13] ebtables: Use the shared commandline parser
Date: Wed, 29 Nov 2023 14:28:14 +0100
Message-ID: <20231129132827.18166-1-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series converts do_commandeb() and do_commandeb_xlate() to call
do_parse() from xshared.c instead of iterating over argv themselves.

Patches 1-6 prepare the shared (parser) code for use by ebtables.
Patches 7-11 prepare ebtables code for the following integration in
patch 13. Patch 12 is a minor refactoring in xshared but fits fine right
before the merge as the introduced helper function is called two more
times by it.

Phil Sutter (13):
  xshared: do_parse: Skip option checking for CMD_DELETE_NUM
  xshared: Perform protocol value parsing in callback
  xshared: Turn command_default() into a callback
  xshared: Introduce print_help callback (again)
  xshared: Support rule range deletion in do_parse()
  xshared: Support for ebtables' --change-counters command
  ebtables{,-translate}: Convert if-clause to switch()
  ebtables: Change option values to avoid clashes
  ebtables: Pass struct iptables_command_state to print_help()
  ebtables: Make 'h' case just a call to print_help()
  ebtables: Use struct xt_cmd_parse
  xshared: Introduce option_test_and_reject()
  ebtables: Use do_parse() from xshared

 iptables/ip6tables.c            |   2 +
 iptables/iptables.c             |   2 +
 iptables/nft-arp.c              |   2 +
 iptables/nft-bridge.c           | 121 +++++
 iptables/nft-bridge.h           |  13 +-
 iptables/nft-cmd.h              |   7 -
 iptables/nft-ipv4.c             |   2 +
 iptables/nft-ipv6.c             |   2 +
 iptables/nft.h                  |   1 -
 iptables/xshared.c              | 218 +++++++--
 iptables/xshared.h              |  36 +-
 iptables/xtables-eb-translate.c | 491 +++----------------
 iptables/xtables-eb.c           | 839 ++++++--------------------------
 13 files changed, 567 insertions(+), 1169 deletions(-)

-- 
2.41.0

