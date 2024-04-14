Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EA5A1DFF4;
	Sun, 14 Apr 2024 23:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713135882; cv=none; b=NeSDLXL8vlikQCtEswg4VtG8BcsAvbPQeTtdSuK8IJSyI5t8RGlNFLWeRqtPfEkaVyUSQrNheNf0/ghydGYyJ4DvMYikb25VErj/p+5ItzklcdLc5nxJOJHBBUEOXhprZVVrhqsUzXgtNJsIb9ixWp0V2ddqLYyLypJoJRaBdTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713135882; c=relaxed/simple;
	bh=1F1CNbqCcjZGKSOs1VT/JdjiQmh/5cknyAOB2kLkCbI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CGgOGmsNgdSiscQCD4SWIIakq0MaqJd44dgoJNGpy79+ITRlPo3RntqkMmFc2kfxHEpJXyNT5jHXP11b1wXKNfFkYDZ+1le8/qsK+azhulTRSdrJdZAxyAvkfQRtXfbyBQglvdtzlgQW4r+7lB3M0xjgyV9ZS2nulcPdXMvL10U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rw8tg-0002V9-8E; Mon, 15 Apr 2024 01:04:28 +0200
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net-next 00/12] selftests: netfilter: move to lib.sh infra
Date: Mon, 15 Apr 2024 00:57:12 +0200
Message-ID: <20240414225729.18451-1-fw@strlen.de>
X-Mailer: git-send-email 2.43.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is the second batch of the netfilter selftest move.

scripts are moved to lib.sh infra. This allows to use busywait helper
and ditch various 'sleep 2' all over the place.

Last patch updates the makefile with the missing bits to make
'kselftest-install' target work as intended again and adds more required
config settings.

Missing/work in progress:
1. nft_concat_range.sh: it runs for a very long time and also has
a few remaining issues.
2. some scripts still generate lots of warnings when fed to shellcheck.

Both issues work-in-progress, no point in waiting because its not
essential and series should not grow too large.

Florian Westphal (12):
  selftests: netfilter: conntrack_icmp_related.sh: move to lib.sh infra
  selftests: netfilter: conntrack_tcp_unreplied.sh: move to lib.sh infra
  selftests: netfilter: nft_queue.sh: move to lib.sh infra
  selftests: netfilter: nft_synproxy.sh: move to lib.sh infra
  selftests: netfilter: nft_zones_many.sh: move to lib.sh infra
  selftests: netfilter: xt_string.sh: move to lib.sh infra
  selftests: netfilter: nft_nat_zones.sh: shellcheck cleanups
  selftests: netfilter: nft_queue.sh: shellcheck cleanups
  selftests: netfilter: conntrack_ipip_mtu.sh: shellcheck cleanups
  selftests: netfilter: nft_fib.sh: shellcheck cleanups
  selftests: netfilter: nft_audit.sh: skip if auditd is running
  selftests: netfilter: update makefiles and kernel config

 tools/testing/selftests/Makefile              |   2 +-
 .../testing/selftests/net/netfilter/Makefile  |   5 +
 tools/testing/selftests/net/netfilter/config  |  42 ++-
 .../net/netfilter/conntrack_ipip_mtu.sh       |  74 ++---
 .../selftests/net/netfilter/nft_audit.sh      |  18 +-
 .../selftests/net/netfilter/nft_fib.sh        | 128 ++++----
 .../selftests/net/netfilter/nft_nat_zones.sh  | 193 +++++--------
 .../selftests/net/netfilter/nft_queue.sh      | 273 ++++++++----------
 .../selftests/net/netfilter/nft_synproxy.sh   |  77 ++---
 .../selftests/net/netfilter/nft_zones_many.sh |  93 +++---
 .../selftests/net/netfilter/xt_string.sh      |  55 ++--
 11 files changed, 458 insertions(+), 502 deletions(-)

-- 
2.43.2

