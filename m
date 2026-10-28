Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793199414;
	b=pKjeePJaayJ+UgylJYygL5gLFD9mvrMnv+JIKzVkMRjJqA7QSBI8B3D3gWsmQx7/EYvA
	 VJ/AUKvavimBdfS9/WDG9Y32l2JIBnPHAU0eVkcdPNh8l8LwCQwu+Fbklla7hU0I4Lkfg
	 mrdX8o7j8c9L2xoWHlQWPvHxJAW4sn0Hrkv39Fz7m119OUappcroWFRQdCg5S/eo7WU2d
	 XASwDP3dep3V8oXTB/saSy8lrnvuHRy1d9Z7i3XxsDSUmbXU2N4wudCzdD/r/as7x5y65
	 1U8e/uThYtoKqbeeoev7OTBEcPKisEWQGUToSvUUnIn6Ki2wULcLEs7smUCxVZP/YoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793199414;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fS1pWk+hY5ffXXbwYxBswe+Q2thSUWXZKtk+ry1pWd0=;
	b=dLYMLJ69NiCwC3FQqdjuEpDfw1PMwur+jFRKVP48ubaxkg1s964oWiSRQmVEh3XBt1Ek
	 UeC5DuzytiZljhQXucLbxRvJkM6suKGzuUNgqRN/HPJSpYyTHsJY4pPbhJibQGenzsDl5
	 /e6iEjwCVvSZjB4QgSeNQiqkqvFAcyiUQfNJlf1DLQ1bwCJkht/flT40EySbHWKq5dQmv
	 0Tp1CLH977kOXV90qSdoPjH+8sdZc8XjabYMnpeQ3VDffmQ6LR+tBb2C3rZYOvqHNJm3x
	 0VqRAnvBAOoH+ptrKWFOV46UBVfPUdkDoH81MYmJzLAEqAJG48tfJ/XnF9+QCz02WOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4796606A32C
	for <netfilter-devel@vger.kernel.org>; Wed, 28 Oct 2026 14:56:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A4796606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id B0765609D0; Wed, 28 Oct 2026 15:56:45 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH libftnl 00/12] more misc LLM fixes
Date: Wed, 28 Oct 2026 15:56:20 +0100
Message-ID: <20261028145632.7089-1-fw@strlen.de>
X-Mailer: git-send-email 2.55.0
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Another round of LLM findings.  These commits are all unrelated,
except that they are LLM findigs with no observed bug reports.

1) Check mnl_nlmsg_batch_start() for a NULL return. Avoid potential NULL
pointer dereference in src/common.

2) Fix uninitialised attr arrays by zero-initialising tb[] arrays.

3) Move several MNL_STRING attribute types to MNL_NUL_STRING so
mnl_attr_validate enforces NUL termination. Harden future
netlink-attribute parsing against non-kernel sources that may omit the
terminator.

4) Validate NFTA_EXPR_NAME parse success. Upgrade string validation to
NUL_STRING, since the kernel always appends a trailing NUL.

5) Forbid re-setting or clearing the object type field to prevent
inconsistent state and segfaults. Check the correct subtype before freeing
to guard against a latent union overlap crash.

6) Drop trailing semicolon from the xfree macro. Callers already append their
own ;, so the macro's is redundant.

7) Remove the obsolete set_elem member from the ruleset union. Its last
consumer (the removed json interface) no longer exists, and the shared
nftnl_set_free path masked a latent type-confusion bug.

8) Clear field_len array before copying to avoid reading stale values from a
prior call. Fix a bug where shrinking the array on a second invocation
leaks leftover field counts.

9) Guard the s->expr_list traversal against the empty-list case to avoid
returning a pointer into the middle of nftnl_set. Initialize data_len to 0.

10) Fix use-after-free by calling list_del() before freeing expressions in
set_elem. Prevents dangling next/prev pointers from corrupting a
subsequent list_add on the same list.

11) Clamp buf->end to the actually copied size in udata_buf_put. Prevent
nftnl_udata_buf_space() from observing an end pointer past the buffer.

12) Remove all remaining MNL_STRING users, switch to MNL_NUL_STRING and
mnl_attr_put_strz. Enforce NUL-termination checking on all string
attributes to prevent illegal strlen/strdup on unchecked data.

Florian Westphal (12):
  src: common: mnl_nlmsg_batch_start may return NULL
  src: fix uninitialised attr arrays
  src: move several MNL_STRING types to MNL_NUL_STRING
  src: expr: make sure NFTA_EXPR_NAME was parsed successfuly
  src: object: don't permit to re-set or clear object type field
  include: drop semicolon at end of xfree macro
  src: ruleset: remove set_elem member from union
  src: set: clear field_len array before copying
  src: set: check for empty list explicitly
  src: set_elem: list_del before freeing
  src: udata: clamp buf->end to actally copied size
  src: remove all remaining MNL_STRING users

 examples/nft-compat-get.c |  2 +-
 include/utils.h           |  2 +-
 src/chain.c               |  4 ++--
 src/common.c              |  4 ++++
 src/expr.c                |  5 ++++-
 src/expr/data_reg.c       |  4 ++--
 src/expr/dynset.c         |  2 +-
 src/expr/flow_offload.c   |  2 +-
 src/expr/log.c            |  2 +-
 src/expr/lookup.c         |  2 +-
 src/expr/objref.c         |  6 +++---
 src/flowtable.c           |  2 +-
 src/obj/ct_helper.c       |  4 ++--
 src/obj/secmark.c         |  4 ++--
 src/object.c              | 19 +++++++++++++++----
 src/rule.c                |  2 +-
 src/ruleset.c             |  3 +--
 src/set.c                 | 13 +++++++------
 src/set_elem.c            | 10 +++++++---
 src/table.c               |  2 +-
 src/trace.c               |  6 +++---
 src/udata.c               |  5 ++++-
 src/utils.c               |  5 +++--
 23 files changed, 68 insertions(+), 42 deletions(-)

-- 
2.55.0

