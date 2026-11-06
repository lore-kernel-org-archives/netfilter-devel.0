Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793979502;
	b=aPtJz/vSUVUc72jburTIyoC/IXKFRHrvi1bMxqtLem59EHnQU4bW5yAM8wEzY9nTHq90
	 RpK32tsH2mIWBKjDM+DcOmX514jrFzChv6unuxg6fRqBVSbk5Hf0XO4ZAgAhjflZO4dYZ
	 MyJQrI2yZZJiIZVVnmDCzeTNJo5O9XIYJZTuwrpn/3b/ccmhsaubFWrq6ZJB9yoZnp8mO
	 6OGoGDqHCzLIcbxcb8wYS8VQY66GV+Zb6dHkVteGkEme/Y7LPXxAQQGTsG96j08YlUhwd
	 afKmNk8OeB+eg1tjHvemRbdf3eJ4vjS4sFgArr/kaoxM+6IcOHNAQHI55EtOkbJnjvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793979502;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3zthRh5eb5tH9Hm4BmszFKqhI9imEV6YDUQt/8OTH38=;
	b=139U9VDb2ysMVUIJpKL227eh+B5E07FCX9L3RRBKMXUCWqRWeQYfGT5npRXQZt4HygjN
	 Fw8j1PUWDlrOaLhpwgAOU10uR2S+gWOXU7Alplb8A8tX5wAfGlehOtIWu3yVRz3vAEQHj
	 3k1zwIf+/NN0FN9p/+3KrXXmuP8ARPafdVZCJDDcEbhm0dFxERbz9LKP1TkE+WqXphR+G
	 8q55oX/8bM9IZIOD2hF/VdFStDYrbVXTvEz78Xfd4Y4Cf/ULt/becB9CpIUQ2ScF+up4v
	 y/lm74+zyIXeU8tLpXrgCD38DEBTIlvqcdRq0V2lAQx0hXbMqp3iS2zEFPniZcifzoQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE205606A326
	for <netfilter-devel@vger.kernel.org>; Fri,  6 Nov 2026 15:38:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AE205606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 811846060B; Fri, 06 Nov 2026 16:38:19 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: herbert@gondor.apana.org.au,
	kadlec@netfilter.org,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v7 0/6] ipset: replace internal hash table with rhashtable
Date: Fri,  6 Nov 2026 16:38:02 +0100
Message-ID: <20261106153808.25148-1-fw@strlen.de>
X-Mailer: git-send-email 2.56.0
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

v7:
- drop rhltable entirely, we need to insert at right location, not just
  the head of the list
- the initial rhashtable conversion now removes MULTI support,
  re-added in extra patch that is new in this series.
- re-target nf-next

See patches for details for changes since v6.

I did extensive LLM reviews of this thing, but by now noise outweights the
signal by far, with successive rounds often giving contradicting hints.
This passes ipset tests, like previous versions of this patchset.

1) Add rhashtable_flush_and_free, From Herbert Xu.
The initial user of this function is added in patch 3.

2) Add rhashtable boilerplate stubs to ipset. Implement its initialization
and destruction logic.

3) Replace ipset internal hash tables with rhashtables.
This drops functionality, in particular, MULTI sets will not work
correctly.  This is restored in patch 5.

4) Report dynamic CIDR storage memory size to userspace.

5) Reimplement hash:net,iface (IP_SET_HASH_WITH_MULTI) using a
group-of-elements structure with explicit exact-over-wildcard match
priority. Update gc, list, flush, and destroy paths for the extra group
level.

6) Restore SET_WITH_FORCEADD eviction support to netfilter ipset. Add
mtype_remove_random() helper to facilitate element eviction during
additions.

Florian Westphal (5):
  netfilter: ipset: add rhashtable boilerplate stubs
  netfilter: ipset: replace internal hash table with rhashtable
  netfilter: ipset: also report mem size for cidr storage to userspace
  netfilter: ipset: re-add IP_SET_HASH_WITH_MULTI support
  netfilter: ipset: re-add forceadd support

Herbert Xu (1):
  rhashtable: Add rhashtable_flush_and_free helper

 include/linux/rhashtable.h                   |   40 +-
 lib/rhashtable.c                             |  186 +-
 net/netfilter/ipset/ip_set_hash_gen.h        | 2138 ++++++++++--------
 net/netfilter/ipset/ip_set_hash_ip.c         |    6 +-
 net/netfilter/ipset/ip_set_hash_ipmac.c      |    6 +-
 net/netfilter/ipset/ip_set_hash_ipmark.c     |    6 +-
 net/netfilter/ipset/ip_set_hash_ipport.c     |    6 +-
 net/netfilter/ipset/ip_set_hash_ipportip.c   |    6 +-
 net/netfilter/ipset/ip_set_hash_ipportnet.c  |    6 +-
 net/netfilter/ipset/ip_set_hash_mac.c        |    3 +-
 net/netfilter/ipset/ip_set_hash_net.c        |    6 +-
 net/netfilter/ipset/ip_set_hash_netiface.c   |   74 +-
 net/netfilter/ipset/ip_set_hash_netnet.c     |    6 +-
 net/netfilter/ipset/ip_set_hash_netport.c    |    6 +-
 net/netfilter/ipset/ip_set_hash_netportnet.c |    6 +-
 15 files changed, 1440 insertions(+), 1061 deletions(-)

-- 
2.56.0

