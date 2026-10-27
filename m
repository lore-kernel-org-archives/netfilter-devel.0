Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793108041;
	b=l+oCSlSJ693d/tXHlW74f3EPCfjVV/gVnWr6FniGAUntDm+427aRPmvIoF+s2XNb1dCU
	 ca5FvWQz7zNOd33gayZ2zA8hiIObwFFbq+3V3hrnyGmcLOvQqvVHiH6RlohM/97WO9fhd
	 NxSR9AprLBk3Nv75LrPrset18cc66RJGuzknZ05OSFdNqJBhZDfLEDXKh7h329/e1mZt4
	 dkrJZKqRzdN/hCwYFpzblHLH23SdVKFn5cEodqMmRdNwmCMC0rrAps5Y7Pru5kl/ZOhkq
	 TrchEc8bJleSnE/YqGg1w8xLvWP++F1Wxwt7XnaDlcIuSfXWDMrtF23v9s1RuFxeH4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793108041;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Uu9/U2UmigqcedckZmbMOso8ZSaSdl4WfKNKvB1dpzQ=;
	b=INC41cjjNiZdkNlz5dTc8NlQ4fZLUL9R0aLjdaudtUIJxoitLP/H0C1GHJYfVzDZV57M
	 xr/l8OPHWaXD1PWuIIrn/reqkePswdLO06MSYrJCcaZD+48hw5A45pLOKzFxK1jPaGOIn
	 8LAawxdSwfV4q9WdC5mC9wUQqqd+0YtKsoIOSHrvnH9W9pZr2+B6f4/btVXNHjuP5niQO
	 V6tEycaA1+/zlVFgbyPvepL3t5Z//MIcTxlU2HBL+PCcFL5W48Wq0EiZdobwMCZkIGxy7
	 3E67ONAUfDj+4EA9ZTK2mSnpMwJIEx0iq4Y7mDGFM5fxBy0r8vd7etPXL9uJCuP0TWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0EE9606A31A
	for <netfilter-devel@vger.kernel.org>; Tue, 27 Oct 2026 13:34:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D0EE9606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id A71E360788; Tue, 27 Oct 2026 14:33:52 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nf v6 0/6] ipset: replace internal hash table with rhashtable
Date: Tue, 27 Oct 2026 14:33:25 +0100
Message-ID: <20261027133331.25979-1-fw@strlen.de>
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

v6: address more AI complaints on v5, affects patches 3, 4 and 5.
Rest unchanged.

v5: add Herbert Xu's new rhashtable_flush_and_free() to rhashtable, this
replaces my own version from v4.  I also dropped a few follwup patches
with further changes/cleanups, not strictly required for initial
conversion.

1) Add rhashtable_flush_and_free, From Herbert Xu.
The initial user of this function is added in patch 4.

2) Add rhashtable boilerplate stubs to ipset. Implement its initialization
and destruction logic.

3) Add rhltable boilerplate stubs to netfilter ipset. Prepare for handling
distinct elements sharing the same hash key.

4) Replace ipset internal hash tables with rhashtables.
Retain legacy configuration options.

5) Restore SET_WITH_FORCEADD eviction support to netfilter ipset. Add
mtype_remove_random() helper to facilitate element eviction during
additions.

6) Report dynamic CIDR storage memory size to userspace.

Florian Westphal (5):
  netfilter: ipset: add rhashtable boilerplate stubs
  netfilter: ipset: add rhltable boilerplate stubs
  netfilter: ipset: replace internal hash table with rhashtable
  netfilter: ipset: re-add forceadd support
  netfilter: ipset: also report mem size for cidr storage to userspace

Herbert Xu (1):
  rhashtable: Add rhashtable_flush_and_free helper

 include/linux/rhashtable.h                 |   40 +-
 lib/rhashtable.c                           |  187 ++-
 net/netfilter/ipset/ip_set_hash_gen.h      | 1638 ++++++++------------
 net/netfilter/ipset/ip_set_hash_netiface.c |   24 +-
 4 files changed, 860 insertions(+), 1029 deletions(-)

-- 
2.55.0

