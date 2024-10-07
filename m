Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C77D41E519
	for <netfilter-devel@vger.kernel.org>; Mon,  7 Oct 2024 10:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728296620; cv=none; b=ocUl903SwrFE7cbHVoGtMuK0hWOZlbCCj4n3XWwchtxyTFpyRymIsq975jUiRv9w01XIaBMUVvvlbispnTIe9ey3dQ3ODq1+IpysRHIrhn0F5Wa0NCubEkurkoAbPQgSxnmK4J9KnY1T7WOW+lKBsKxuX9fEe2YSHLtZ+4uJ2/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728296620; c=relaxed/simple;
	bh=LWV2YILJOyi1hQ4FPbd7XEYe3/KJzT9NBjL3FMKef6c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=axNRd82NeF98YVO+QRdEFDCB61UNaFfCDMjimv2aLTg5N6EiIO+e+PUX0RuNYdRL9PiZO+y2TM03sTERgnAjGrVZt1RzjC7QH2kg48v5AD81VSnZHl//K4IGiTgoWZtJFJvMSx+oQAOeSgcLm+9Wb12Xj3X+h34CTCBmEsX45uE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1sxkts-0006f4-UN; Mon, 07 Oct 2024 12:23:36 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [RFC libnftnl/nft 0/5] nftables: indicate presence of unsupported netlink attributes
Date: Mon,  7 Oct 2024 11:49:33 +0200
Message-ID: <20241007094943.7544-1-fw@strlen.de>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This extends linftnl/nftables to indicate incomplete expressions/sets.

When using old nft binary that cannot list a new expression, nft already
prints an error with the name of the unknown expression.

Extend libnftnl to also make an annotation when a known expression has
an unknown attribute included in the dump, then extend nftables to also
display this to the user.

Debug out out will include the [incomplete] tag for each affected
expression.

Nftables will append '"# Unknown features used (old nft version?)"'
comment to the rule resp. the set defintion.

I added new APIs because existing nftnl_expr_get() can't be re-used,
inserting a new common attribute like NFTNL_EXPR_COMPLETE will break ABI.

It would make sense to also add
nftnl_XXX_complete functions for table, chains, objects and flowtables so we
have coverage for all supported types in one go, but I think its better
to first check for feedback before doing this.

libnftnl:
Florian Westphal (3):
  expr: add and use incomplete tag
  sets: add and use incomplete tag
  libnftnl: add api to query dissection state

 include/data_reg.h      |  1 +
 include/expr.h          |  1 +
 include/libnftnl/expr.h |  2 ++
 include/libnftnl/set.h  |  1 +
 include/set.h           |  1 +
 src/expr.c              |  6 ++++++
 src/expr/bitwise.c      |  8 +++++---
 src/expr/byteorder.c    |  9 ++++++---
 src/expr/cmp.c          |  9 ++++++---
 src/expr/connlimit.c    |  9 ++++++---
 src/expr/counter.c      |  9 ++++++---
 src/expr/ct.c           |  9 ++++++---
 src/expr/data_reg.c     | 19 +++++++++++++------
 src/expr/dup.c          |  9 ++++++---
 src/expr/dynset.c       |  9 ++++++---
 src/expr/exthdr.c       |  8 +++++---
 src/expr/fib.c          |  9 ++++++---
 src/expr/flow_offload.c |  9 ++++++---
 src/expr/fwd.c          |  8 +++++---
 src/expr/hash.c         |  8 +++++---
 src/expr/immediate.c    |  8 +++++---
 src/expr/inner.c        |  8 +++++---
 src/expr/last.c         |  8 +++++---
 src/expr/limit.c        |  8 +++++---
 src/expr/log.c          |  8 +++++---
 src/expr/lookup.c       |  8 +++++---
 src/expr/masq.c         |  8 +++++---
 src/expr/match.c        |  8 +++++---
 src/expr/meta.c         |  6 ++++++
 src/expr/nat.c          |  8 +++++---
 src/expr/numgen.c       |  8 +++++---
 src/expr/objref.c       |  8 +++++---
 src/expr/osf.c          |  9 +++++----
 src/expr/payload.c      |  8 +++++---
 src/expr/queue.c        |  9 ++++++---
 src/expr/quota.c        |  8 +++++---
 src/expr/range.c        |  8 +++++---
 src/expr/redir.c        |  8 +++++---
 src/expr/reject.c       |  9 ++++++---
 src/expr/rt.c           |  9 ++++++---
 src/expr/socket.c       |  9 ++++++---
 src/expr/synproxy.c     | 16 ++++++++--------
 src/expr/target.c       |  9 ++++++---
 src/expr/tproxy.c       |  8 +++++---
 src/expr/tunnel.c       |  8 +++++---
 src/expr/xfrm.c         |  8 +++++---
 src/libnftnl.map        |  5 +++++
 src/rule.c              |  5 +++++
 src/set.c               |  6 ++++++
 src/set_elem.c          |  5 +++++
 50 files changed, 259 insertions(+), 126 deletions(-)

nft:
Florian Westphal (2):
      netlink: tell user if libnftnl detected unknown attributes/features
      sets: inform user when set definition contains unknown attributes

 include/netlink.h         |    1 +
 include/rule.h            |    2 ++
 src/netlink.c             |    3 +++
 src/netlink_delinearize.c |   24 ++++++++++++++++++++++++
 src/rule.c                |    5 +++++
 5 files changed, 35 insertions(+)
-- 
2.45.2

