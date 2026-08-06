Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E195C3DD537
	for <netfilter-devel@vger.kernel.org>; Thu,  6 Aug 2026 10:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786011609; cv=none; b=qH0a8dGIKQ/dXZmb3rc0deGcmNKPocepXGX378vxeeB0by3dvYTRnbhxcUT7a0F/5GDGh0Mfyo2jzDmvHaZGpF4pa9FuBodK64Y7YO4uedWOqXta9iz69VT13SqF0uoWIrpL/60A0Qo1ZivOSByOfzfQ/z8WqO/s3SMSpMu0AsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786011609; c=relaxed/simple;
	bh=HpKGCpDfWD/AaUJP669Mxz+JsKAV7bmJjAxVaU50BEs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HrZbi9drxsIiP8tQ6eavT2bx9WtUq71yzKB3nigRuP1/+s0U5sbAXTs0gLIR2ASExkKDhb/uV8DgIunE6Vbqy6Y1+azUJCVBiQAziz7NKZ2NvoJpVmJzLjKFo1RkcgTm8825JBhb1mJ3iuaJcNGhck0fIyKiPqox68nsMFcsTl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 976D560240; Thu, 06 Aug 2026 12:20:03 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nf 0/7] netfilter: switch ipset to rhashtable
Date: Thu,  6 Aug 2026 12:19:40 +0200
Message-ID: <20260806101947.2802-1-fw@strlen.de>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

1) Replace memory allocation in ipset delete operations with in-place
substitution. Move empty CIDR ranges to the end of the array.
This addresses LLM findings of a patch from the rhashtable preparation
series.

2) Fix list_type ext_size memory accounting on set flush. As-is,
flush sets the value to 0, but call_rcu() destructor can subtract again.
Addresses drive-by LLM report.

3) Add rhashtable boilerplate stubs to netfilter ipset. Implement rhashtable
initialization and destruction routines.

4) Add rhltable boilerplate stubs to netfilter ipset. Prepare transitioning
certain hash sets from rhashtable to rhltable.  Was not part of RFC,
needed for the 'net,iface.t' set type.

5) Replace ipset hash tables with rhashtable.
This change will splat on debug kernels, fix is queued as
'rhashtable: fix false-positive lockdep splat on rhltable destruction'
in herbert/crypto-2.6.git.

6) Restore forceadd support to ipset rhashtable via random element
eviction.

7) Include dynamic CIDR storage memory size in userspace reports.
Another LLM finding during review of initial preparation patches.

Florian Westphal (7):
  netfilter: ipset: remove need to allocate memory on delete operations
  netfilter: ipset: let destroy callbacks adjust ext mem size
  netfilter: ipset: add rhashtable boilerplate stubs
  netfilter: ipset: add rhltable boilerplate stubs
  netfilter: ipset: replace internal hash table with rhashtable
  netfilter: ipset: re-add forceadd support for rhashtable
  netfilter: ipset: also report mem size for cidr storage to userspace

 net/netfilter/ipset/ip_set_bitmap_gen.h      |    2 +-
 net/netfilter/ipset/ip_set_hash_gen.h        | 1716 ++++++++----------
 net/netfilter/ipset/ip_set_hash_netiface.c   |   25 +-
 net/netfilter/ipset/ip_set_hash_netportnet.c |    1 -
 net/netfilter/ipset/ip_set_list_set.c        |    3 +-
 5 files changed, 734 insertions(+), 1013 deletions(-)

-- 
2.54.0

