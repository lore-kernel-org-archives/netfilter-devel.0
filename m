Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACE58165FB0;
	Thu, 18 Apr 2024 15:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713454207; cv=none; b=U4bTZi5QARr6PxZOF5+TdFn4ShB96cyYgrSRr7M4wNCZDV70pxpUgXod5MCIcZ6fMOBI/4kwPw0k49jhXsMW/+Bd6c102yrQ7xnaD9bu17dr/XCwWTJwUG8sI+rLl/dawC9PUP6AKi26FbESRvEdsFBqODIxJvQxndCQOj5T8VQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713454207; c=relaxed/simple;
	bh=Tvq8iHuxMK18L5p4xcfBC59Fqf+sfTQK3JXxxx7Pvdw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mi3YePMcLen0pq+aPXFsYaCX0DDSjQgMbWj7IdB3plYxH0auwK9fQ0ICBTCE9+S4v6IBisMcxSuuvWW0BkRhLmtC8ywZnsSekl5gAIKEL5VbQSX+xp/hQU3+YAme7WdZRB5iDSQ0nFfPR8ifXT5l9OXCMA47GgSbi5S/O11wplk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rxThx-00006v-2Z; Thu, 18 Apr 2024 17:29:53 +0200
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net-next v2 00/12] testing: make netfilter selftests functional in vng environment
Date: Thu, 18 Apr 2024 17:27:28 +0200
Message-ID: <20240418152744.15105-1-fw@strlen.de>
X-Mailer: git-send-email 2.43.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is the second batch of the netfilter selftest move.

Changes since v1:
- makefile and kernel config are updated to have all required features
- fix makefile with missing bits to make kselftest-install work
- test it via vng as per
   https://github.com/linux-netdev/nipa/wiki/How-to-run-netdev-selftests-CI-style
   (Thanks Jakub!)
- squash a few fixes, e.g. nft_queue.sh v1 had a race w. NFNETLINK_QUEUE=m
- add a settings file with 8m timeout, for nft_concat_range.sh sake.
  That script can be sped up a bit, I think, but its not contained in
  this batch yet.
- toss the first two bogus rebase artifacts (Matthieu Baerts)

scripts are moved to lib.sh infra. This allows to use busywait helper
and ditch various 'sleep 2' all over the place.

Tested on Fedora 39:

vng --build  --config tools/testing/selftests/net/netfilter/config
make -C tools/testing/selftests/ TARGETS=net/netfilter
vng -v --run . --user root --cpus 2 -- \
        make -C tools/testing/selftests TARGETS=net/netfilter run_tests

... all tests pass except nft_audit.sh which SKIPs due to nft version mismatch
(Fedora is on nft 1.0.7 which lacks reset keyword support).

Missing/WIP bits:
- speed up nf_concat_range.sh test
- extend flowtable selftest
- shellcheck fixups for remaining scripts

Florian Westphal (12):
  selftests: netfilter: nft_queue.sh: move to lib.sh infra
  selftests: netfilter: nft_queue.sh: shellcheck cleanups
  selftests: netfilter: nft_synproxy.sh: move to lib.sh infra
  selftests: netfilter: nft_zones_many.sh: move to lib.sh infra
  selftests: netfilter: xt_string.sh: move to lib.sh infra
  selftests: netfilter: xt_string.sh: shellcheck cleanups
  selftests: netfilter: nft_nat_zones.sh: shellcheck cleanups
  selftests: netfilter: conntrack_ipip_mtu.sh: shellcheck cleanups
  selftests: netfilter: nft_fib.sh: shellcheck cleanups
  selftests: netfilter: nft_meta.sh: small shellcheck cleanup
  selftests: netfilter: nft_audit.sh: add more skip checks
  selftests: netfilter: update makefiles and kernel config

 .../testing/selftests/net/netfilter/Makefile  |   5 +
 tools/testing/selftests/net/netfilter/config  |  52 +++-
 .../net/netfilter/conntrack_ipip_mtu.sh       |  74 ++---
 .../selftests/net/netfilter/nft_audit.sh      |  30 +-
 .../selftests/net/netfilter/nft_fib.sh        | 128 ++++-----
 .../selftests/net/netfilter/nft_meta.sh       |   4 +-
 .../selftests/net/netfilter/nft_nat_zones.sh  | 193 +++++--------
 .../selftests/net/netfilter/nft_queue.sh      | 272 ++++++++----------
 .../selftests/net/netfilter/nft_synproxy.sh   |  77 ++---
 .../selftests/net/netfilter/nft_zones_many.sh |  93 +++---
 .../testing/selftests/net/netfilter/settings  |   1 +
 .../selftests/net/netfilter/xt_string.sh      |  89 +++---
 12 files changed, 498 insertions(+), 520 deletions(-)
 create mode 100644 tools/testing/selftests/net/netfilter/settings

-- 
2.43.2

