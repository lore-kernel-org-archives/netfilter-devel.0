Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58F414B15F
	for <netfilter-devel@vger.kernel.org>; Fri, 15 Dec 2023 21:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="XkODz24O"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=aFH1e1pMued26XfJ4ybHdCvrqdqIuNnT2610Yecttoo=; b=XkODz24OP1rkiKTPb8dl+Hcpnn
	MXgC6XyKBNnKOBBzCFujbvAkOIFcl5FGotept7Ouz9bjTg65BA+V789ce4wV4Xhp6dK67qWEPeVMb
	ZKpKfb0dcQGY/mEkweNvjcyzv20vLQcZUo78baYf6lcxz1WSNpGHvELsTVsvDrYtzc2iECyTwojRc
	OYReIDA1Vprc9HGfZRkF5Sc1wu4QZ+aB/NrWCIH9zYojDCIjSv4i4+rYk4rBUTTiS+aBvJI0kESos
	JWhXkzyNWrr/XnPv5suavGV7ExnWN+Z8szVUfcM1Qp73aerTDeTNfqxrRb7B3A9xH84R0Tp3Z2ufB
	zEAEDA/Q==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.94.2)
	(envelope-from <phil@nwl.cc>)
	id 1rEG83-0001Zk-KK; Fri, 15 Dec 2023 22:53:55 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>
Subject: [libnftnl PATCH 0/6] Attribute policies for expressions
Date: Fri, 15 Dec 2023 22:53:44 +0100
Message-ID: <20231215215350.17691-1-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is the former RFC turned into a complete implementation including
Florian's suggested improvements.

Patch 1 is fallout, took me a while debugging the segfaulting test case
until I noticed it wasn't my fault! :)

Patch 2 is the same as in the RFC.

Patch 3 separates the type value checking from patch 2 and drops
expressions' default switch cases where all possible values are handled.

Patch 4 is prep work for patch 5.

Patch 5 adds the new struct expr_ops field and defines policies for all
expressions.

Patch 6 then enables policy checking.

Some remarks for consideration:

* This adds kernel-internal knowledge to libnftnl, namely in max name
  lengths. Maybe not ideal, but I found it more sensible than Florian's
  suggested alternative of using 65528 to just not exceed netlink
  limits.

* nftnl_expr_set_u*() setters start failing when they would happily
  overstep boundaries before. This is intentional, but getting the
  policy values right (at first I thought 'sizeof(enum nft_registers)'
  was a good idea) showed how hard to diagnose bugs in that area are. I
  think we should make the setters return success/fail like
  nftnl_expr_set_str does already, even if that breaks ABI (does it?).
  nftables probably benefits from setter wrappers which call
  netlink_abi_error() if the setter fails.

Phil Sutter (6):
  tests: Fix objref test case
  expr: Repurpose struct expr_ops::max_attr field
  expr: Call expr_ops::set with legal types only
  include: Sync nf_log.h with kernel headers
  expr: Introduce struct expr_ops::attr_policy
  expr: Enforce attr_policy compliance in nftnl_expr_set()

 include/expr_ops.h               |  7 +++++-
 include/libnftnl/expr.h          | 39 ++++++++++++++++++++++++++++++++
 include/linux/netfilter/nf_log.h |  3 +++
 src/expr.c                       | 10 ++++++++
 src/expr/bitwise.c               | 15 +++++++++---
 src/expr/byteorder.c             | 13 ++++++++---
 src/expr/cmp.c                   | 11 ++++++---
 src/expr/connlimit.c             | 10 +++++---
 src/expr/counter.c               | 10 +++++---
 src/expr/ct.c                    | 12 +++++++---
 src/expr/dup.c                   | 10 +++++---
 src/expr/dynset.c                | 15 +++++++++++-
 src/expr/exthdr.c                | 15 +++++++++---
 src/expr/fib.c                   | 11 ++++++---
 src/expr/flow_offload.c          |  9 +++++---
 src/expr/fwd.c                   | 11 ++++++---
 src/expr/hash.c                  | 13 ++++++++++-
 src/expr/immediate.c             | 13 ++++++++---
 src/expr/inner.c                 | 12 +++++++---
 src/expr/last.c                  | 10 +++++---
 src/expr/limit.c                 | 13 ++++++++---
 src/expr/log.c                   | 14 +++++++++---
 src/expr/lookup.c                | 13 ++++++++---
 src/expr/masq.c                  | 11 ++++++---
 src/expr/match.c                 | 11 ++++++---
 src/expr/meta.c                  | 11 ++++++---
 src/expr/nat.c                   | 15 +++++++++---
 src/expr/numgen.c                | 10 +++++++-
 src/expr/objref.c                | 13 ++++++++---
 src/expr/osf.c                   |  9 +++++++-
 src/expr/payload.c               | 16 ++++++++++---
 src/expr/queue.c                 | 12 +++++++---
 src/expr/quota.c                 | 11 ++++++---
 src/expr/range.c                 | 12 +++++++---
 src/expr/redir.c                 | 11 ++++++---
 src/expr/reject.c                | 10 +++++---
 src/expr/rt.c                    | 10 +++++---
 src/expr/socket.c                | 11 ++++++---
 src/expr/synproxy.c              |  9 +++++++-
 src/expr/target.c                | 11 ++++++---
 src/expr/tproxy.c                | 11 ++++++---
 src/expr/tunnel.c                | 10 +++++---
 src/expr/xfrm.c                  | 11 ++++++++-
 tests/nft-expr_objref-test.c     |  2 +-
 44 files changed, 409 insertions(+), 107 deletions(-)

-- 
2.43.0

