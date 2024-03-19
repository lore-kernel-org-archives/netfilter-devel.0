Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD2AC2B9B4
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Mar 2024 17:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710868352; cv=none; b=Dh0GPO2UNwc35r7gGccAnMMRhdzulNP6H0LV1vKq97l6zhsfd20aeFme9/1N4CyajisxHiyp16/wsaUmMEDlkQgJUzzUjIuFRE2OFcIdpclFGxwF0Gfuq6rNpqY99BTeWHSU4mLLOsXh/wAAryyoa5JmRUbjOVcG0qHFl5Mgw+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710868352; c=relaxed/simple;
	bh=lcCnZlKE2/k7ZzfBKyfakdRbKt6+uAR2vbEP6IIoeMc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QPc6WxVhusfj4r19gDOxBs3+gxFnkY4QgpHtrj9uRCUMWOampI+bjyxOKmUMD8wBSB2X9DI+u+0NsVGkpGHVJh9a4vJAZzbf+uC7BebHIfCrgL+oDO1EdovPyDgu5UPxtyPzON+GxVjMFp/uLC2LMFnFKVP9nXC5MCBq8VaQImU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=ODInuRGj; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="ODInuRGj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=MpTzez9h5ndqToYImxVmHuZw7y+TLlkgP5/NJnQLszI=; b=ODInuRGjiTfrrjU2fmWS6t69JK
	fG5ol7UfqE0ck0PJnfjQJ7L3DCqNsZ/3AroGd4Gh4ukKQlqhsmmQ9MBTfCQr0LRLh176jEwtk4B/v
	eLOGRTgWtaI4CIfpSIt5nxTE7iuPO+woF1RWMfd3NAfYX27e8c1VCGssUm7vwRSgDOR/hDgHdIKhb
	uLU4/lbBlyjr4QLkNxw1iIZPcrVtZnl3elCfBCDr4RO3zJMgRxfIJIJWOY8VxuIVNGYyjG8rTeKgC
	uDc7AARsmUHJ647GYP99bC4k78V37Oy/5eeGAGc2TNnWo0bpf+HvLsKYi1/l/bd6+puVP9JsCmZqc
	2j7G9zUw==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1rmd0m-000000007fQ-0smV;
	Tue, 19 Mar 2024 18:12:28 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [libnftnl PATCH 00/17] obj: Introduce attribute policies
Date: Tue, 19 Mar 2024 18:12:07 +0100
Message-ID: <20240319171224.18064-1-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Just like with the recent change in expr_ops, this series reuses
obj_ops::max_attr field (patch 11) for validating the maximum attribute
value and implements an 'attr_policy' field (patch 13) into struct
obj_ops to verify maximum attribute lengths when dispatching to specific
object type setters in nftnl_obj_set_data().

Patches 1-6 add missing attributes to existing validation arrays.
Patches 7-9 fix for various more or less related bugs.
Patch 10 enables error condition propagation to callers, missing already
for ENOMEM situations and used by following patches.
Patches 11-14 contain the actual implementation announced above.
The remaining patches fix for the other possible cause of invalid data
access, namely callers passing too small buffers.

To verify this won't break users, I ran nftables' shell testsuite in
nftables versions 0.9.9, 1.0.6 and current HEAD and compared the results
with and without this series applied to libnftnl.

Phil Sutter (17):
  chain: Validate NFTNL_CHAIN_USE, too
  table: Validate NFTNL_TABLE_USE, too
  flowtable: Validate NFTNL_FLOWTABLE_SIZE, too
  obj: Validate NFTNL_OBJ_TYPE, too
  set: Validate NFTNL_SET_ID, too
  table: Validate NFTNL_TABLE_OWNER, too
  obj: Do not call nftnl_obj_set_data() with zero data_len
  obj: synproxy: Use memcpy() to handle potentially unaligned data
  utils: Fix for wrong variable use in nftnl_assert_validate()
  obj: Return value on setters
  obj: Repurpose struct obj_ops::max_attr field
  obj: Call obj_ops::set with legal attributes only
  obj: Introduce struct obj_ops::attr_policy
  obj: Enforce attr_policy compliance in nftnl_obj_set_data()
  utils: Introduce and use nftnl_set_str_attr()
  obj: Respect data_len when setting attributes
  expr: Respect data_len when setting attributes

 include/libnftnl/object.h | 23 +++++++++++-----
 include/obj.h             |  3 ++-
 include/utils.h           |  7 +++--
 src/chain.c               | 37 +++++++-------------------
 src/expr/bitwise.c        |  8 +++---
 src/expr/byteorder.c      | 10 +++----
 src/expr/cmp.c            |  4 +--
 src/expr/connlimit.c      |  4 +--
 src/expr/counter.c        |  4 +--
 src/expr/ct.c             |  8 +++---
 src/expr/dup.c            |  4 +--
 src/expr/dynset.c         | 12 ++++-----
 src/expr/exthdr.c         | 14 +++++-----
 src/expr/fib.c            |  6 ++---
 src/expr/fwd.c            |  6 ++---
 src/expr/hash.c           | 14 +++++-----
 src/expr/immediate.c      |  6 ++---
 src/expr/inner.c          |  6 ++---
 src/expr/last.c           |  4 +--
 src/expr/limit.c          | 10 +++----
 src/expr/log.c            | 10 +++----
 src/expr/lookup.c         |  8 +++---
 src/expr/masq.c           |  6 ++---
 src/expr/match.c          |  2 +-
 src/expr/meta.c           |  6 ++---
 src/expr/nat.c            | 14 +++++-----
 src/expr/numgen.c         |  8 +++---
 src/expr/objref.c         |  6 ++---
 src/expr/osf.c            |  6 ++---
 src/expr/payload.c        | 16 +++++------
 src/expr/queue.c          |  8 +++---
 src/expr/quota.c          |  6 ++---
 src/expr/range.c          |  4 +--
 src/expr/redir.c          |  6 ++---
 src/expr/reject.c         |  4 +--
 src/expr/rt.c             |  4 +--
 src/expr/socket.c         |  6 ++---
 src/expr/synproxy.c       |  6 ++---
 src/expr/target.c         |  2 +-
 src/expr/tproxy.c         |  6 ++---
 src/expr/tunnel.c         |  4 +--
 src/expr/xfrm.c           |  8 +++---
 src/flowtable.c           | 18 ++++---------
 src/obj/counter.c         | 14 ++++++----
 src/obj/ct_expect.c       | 24 +++++++++++------
 src/obj/ct_helper.c       | 19 +++++++++----
 src/obj/ct_timeout.c      | 15 +++++++----
 src/obj/limit.c           | 23 ++++++++++------
 src/obj/quota.c           | 17 +++++++-----
 src/obj/secmark.c         |  9 ++++---
 src/obj/synproxy.c        | 17 +++++++-----
 src/obj/tunnel.c          | 56 ++++++++++++++++++++++++++-------------
 src/object.c              | 54 ++++++++++++++++++++++---------------
 src/rule.c                | 18 +++----------
 src/set.c                 | 19 ++++---------
 src/table.c               | 11 +++-----
 src/utils.c               | 14 ++++++++++
 57 files changed, 358 insertions(+), 306 deletions(-)

-- 
2.43.0

