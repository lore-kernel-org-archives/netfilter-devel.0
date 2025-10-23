Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C3972749E0
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Oct 2025 16:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761235572; cv=none; b=LiIDz4etg2syFZY1oxnCt2/1k8bkIPpWc92zHmhLoPLe+d5Do/0qhNH7rZNPuRvDDbejD/rIfa/1Ahgczn12kwP4voU82puU37jrHY6cNFwsOotQD85Oh2IPtCU7YnbX7xQ1HuvhnUdsZ6IF5upFvVWzkpDQkKPvzeFQY/JGjCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761235572; c=relaxed/simple;
	bh=CprIgU7Hv71CHlUCanl66PR8Zs0+SJDBQtTQTiPIGdI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=py1W/v/ZtJKT+EPihED3BNm1x8s5vLmm9Cwdu5/kZQzIUKoa/x6NRm1veEuvTYmzsn3k6Z8xV3A43nRMMo+zBiV2OIvEpZYi7n8w+l5dmwckhmFbqT77PgGcrqDM4o56ZrPamS/sLS8gIqinKM7KKxHgCtSwBXqwIop6AVXNulA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=nccGDqu/; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="nccGDqu/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=qtX3LImxrFtdrQhc9rea1XhlQ38C4r3nMLYM9AScMQs=; b=nccGDqu/lvKo4LXTlfTMdVIHTY
	GGNFYCAQJIVr6Si864eXVEpGdeexfbmhfE6hadrsTlnFnWJuXDyGcp4XvKOYKyhZQ3xNuM0U/HFPv
	tQnzG7bTih3f4auGL7LTT3+695SyVCZg61mFndc8Glq9yzuIWaqJxKYIEeO7vX7lmB6jKoYwLqYpR
	SyYku18DCPAelWhSfTylxxy3ztSVASODo4b9pHdcNv6qkosYExa9DgXrflBaccm+gRkwupz1zv+Yy
	Pb8QxHGc5DTbHVj8JgooyDutj06Si8MHmEhwVoZnmc1gROsMkEtxgeenqnTf7SkXZ4Mk6hcycCLTi
	83vty3Gw==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1vBxpC-000000007fK-2ggj;
	Thu, 23 Oct 2025 18:06:02 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [libnftnl PATCH 0/9] Fix for debug output on Big Endian
Date: Thu, 23 Oct 2025 18:05:38 +0200
Message-ID: <20251023160547.10928-1-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series aims at providing identical netlink debug output in nftables
on Big and Little Endian systems. Particularly problematic are all data
regs in host byte order, worsened by the potential for byte order swaps
within a single data reg (concatenated set elements).

A bonus task is cropping data reg values to their actual size.
Previously, every four-byte register containing data was printed which
further reduces data expressiveness.

This series introduces data attribute setters for expressions and set
elements which accept a byteorder value (plus an array of component
sizes in the latter case) and changes the data reg printer to:

- Print only nftnl_data_reg::len bytes at max
- Print data byte-by-byte, not four byte chunks as u32 values
  interpreted in host byte order
- Print data in reverse if in host byte order on Little Endian

If nftnl_data_reg::sizes array has non-zero fields, data is assumed to
be concatenated and bits in nftnl_data_reg::byteorder signal host byte
order in components. Each component is then printed as per the above
rules and separated by a dot (".").

Patches 3-8 implement the above. Since debug output changes
significantly, use the occasion to:
- Print a colon (":") and flags value only if relevant (patch 1)
- Fix for missing object name in objmap elements (patch 1)
- Avoid ambiguity between data and flags value by prefixing with 'flags'
  (patch 1)
- Avoid trailing whitespace or space before tab (patch 2)

Finally, patch 8 tries to avoid userdata values in host byte order by
storing u32 values in Big Endian. Since nftnl_udata_put_u32() is the
only typed attribute setter (apart from the unproblematic strz one),
this may be good enough for the purpose.

Phil Sutter (9):
  set_elem: Review debug output
  expr: data_reg: Avoid extra whitespace
  expr: Pass byteorder to struct expr_ops::set callback
  data_reg: Introduce struct nftnl_data_reg::byteorder field
  data_reg: Introduce struct nftnl_data_reg::sizes array
  Introduce nftnl_{expr,set_elem}_set_imm()
  data_reg: Respect data byteorder when printing
  data_reg: Support concatenated data
  udata: Store u32 udata values in Big Endian

 include/data_reg.h      |  5 +++-
 include/expr_ops.h      |  2 +-
 include/libnftnl/expr.h |  1 +
 include/libnftnl/set.h  |  1 +
 src/expr.c              | 22 +++++++++++---
 src/expr/bitwise.c      | 18 ++++++++----
 src/expr/byteorder.c    |  2 +-
 src/expr/cmp.c          |  8 ++++--
 src/expr/connlimit.c    |  2 +-
 src/expr/counter.c      |  2 +-
 src/expr/ct.c           |  2 +-
 src/expr/data_reg.c     | 64 ++++++++++++++++++++++++++++++++++++-----
 src/expr/dup.c          |  5 ++--
 src/expr/dynset.c       |  2 +-
 src/expr/exthdr.c       |  2 +-
 src/expr/fib.c          |  2 +-
 src/expr/flow_offload.c |  5 ++--
 src/expr/fwd.c          |  5 ++--
 src/expr/hash.c         |  2 +-
 src/expr/immediate.c    |  8 ++++--
 src/expr/inner.c        |  2 +-
 src/expr/last.c         |  5 ++--
 src/expr/limit.c        |  2 +-
 src/expr/log.c          |  5 ++--
 src/expr/lookup.c       |  2 +-
 src/expr/masq.c         |  2 +-
 src/expr/match.c        |  2 +-
 src/expr/meta.c         |  2 +-
 src/expr/nat.c          |  2 +-
 src/expr/numgen.c       |  2 +-
 src/expr/objref.c       |  5 ++--
 src/expr/osf.c          |  5 ++--
 src/expr/payload.c      |  2 +-
 src/expr/queue.c        |  5 ++--
 src/expr/quota.c        |  5 ++--
 src/expr/range.c        | 17 ++++++++---
 src/expr/redir.c        |  2 +-
 src/expr/reject.c       |  5 ++--
 src/expr/rt.c           |  2 +-
 src/expr/socket.c       |  2 +-
 src/expr/synproxy.c     |  5 ++--
 src/expr/target.c       |  2 +-
 src/expr/tproxy.c       |  2 +-
 src/expr/tunnel.c       |  5 ++--
 src/expr/xfrm.c         |  2 +-
 src/libnftnl.map        |  5 ++++
 src/set_elem.c          | 61 ++++++++++++++++++++++++++++-----------
 src/udata.c             |  7 +++--
 48 files changed, 233 insertions(+), 92 deletions(-)

-- 
2.51.0

