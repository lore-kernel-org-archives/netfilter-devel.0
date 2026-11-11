Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794391927;
	b=vElg6Ko/3ApobRAop6HHDpNavNZd7g1vTg9TLjcAnE35iMyqJ0rXk1/lyxXYR51zz6NR
	 l8+KQcTPXJ1ukltRRx5aAUTcXj49UI05A/vQK1YnuQRFV6u3hhdmSSWBaK/hFDcQkBLWM
	 XNrubhhaJUMQyVT/UHBFtFO/zSO2tZeUPwQ6mEmhQ0wZnqN4z/dQCvyQ9NgHXdofwsVYX
	 p5WQr7qI2XWe0Wr9ww9hXYCrj5s+RPfhoTEkJc+KT9YSCR9nNeh57I6W5kbH5HrIklu0x
	 3FiRgVzbHB/Nn1sGfWkaPfXhJhJvuDeYIuAGoDo5KnVt91GNFselbt4p0sh4RgwerLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794391927;
	h=DMARC-Filter:Received:From:To:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1tL0BBZzhLUKHXNeC0kg3LdwNns86x9TbtHlExaWrpE=;
	b=e5PF5kc5qRKhXN98LLGL8Xom7E90C2MmfuAK2/uxfDlcQIo+4/WGROCz4l4Uy7aBpKIm
	 vSxUewRs+qGR1UYyUmZDhs4ak1OBoswagAjxPNRq81fCidvtI5W4KVNK5BWTV9Pl2baac
	 G/NkmcIu8U2Rlw6QuCHX66UM2eqcDSzEyZ7OYrPxRB/L8PndOqKO5JCTIVDpxC5y9VBY9
	 lSaGZXoO7hOGF0GPceQyNH0Kq74m8y3At2CwJ4MurXXzNR/QKwIM+uRYZjFFpbltfWUOp
	 xyzYsg+AYTUyZEMUNbNp+1ge4q0EFDtNgg1ZJ9XWf8yRkrAwM6bCzEbUegcpcPtHC3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E65E9606A32D
	for <netfilter-devel@vger.kernel.org>; Wed, 11 Nov 2026 10:12:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E65E9606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 9B6A56060B; Wed, 11 Nov 2026 11:12:04 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next v8 0/6] ipset: replace internal hash table with rhashtable
Date: Wed, 11 Nov 2026 11:11:51 +0100
Message-ID: <20261111101157.22270-1-fw@strlen.de>
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

v8:
- Mostly changes in patches 3 and 5.  Patch 5 now checks if
  unlink from rhashtable worked before freeing the group struct
  to avoud gc/flush entanglements.
- the initial rhashtable conversion now removes MULTI support,
  re-added in extra patch that is new in this series.

See patches for details for changes since v7.

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
 net/netfilter/ipset/ip_set_hash_gen.h        | 2172 ++++++++++--------
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
 15 files changed, 1462 insertions(+), 1073 deletions(-)

-- 
2.56.0

