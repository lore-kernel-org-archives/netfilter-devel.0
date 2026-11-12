Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794443619;
	b=bOrtNCZR7BjYpVdQgf+HOIoJc27j4zCQ5Uievvm6wB3Vt3f5DZZuVJ9x5LLSCe7/2Pkw
	 wzm3etlv7mca6GI8GwmpFRsxThodLM6wbmqqdD7YcpQ47TcPe+cBryFhapnKCBNcHCkpp
	 wK7VDhG4g9yM53sS/lZP2s+KFjgjMUCiS5N172faUwghyK+MNg5L+IJzYlU/cevYxd/Lq
	 DHaIyLqXVTNLhTYZLSo1IV6hhefMaV80jN0o8la9XDzgjMO9+FSYZVcL5S10IikN7+a9q
	 rMNNxnTvCc0RXKywZmWA9hOQNhbGaoEmzaX0rkNkL/1tiQhS0fFwuE7M6GNNUUCEhkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794443619;
	h=DMARC-Filter:Received:From:To:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vvxU9yWxPOoDocJ4HUnY6Hhyv2EXgLqVX/zBFhXAm54=;
	b=a6BXYaKVUAPR7z/RiU6GiV5xDCkSgeS1FBSpByP5Zi/fj4P97ftK1O/UDq219LNvpmJx
	 Ca6YXxIaxdoXzN4z4baB+zcUrRWnZm7OtRDQfBMW93BqZybxFHnuo2iDVPDv0WNdhxPLo
	 IMkG/hgfeBX9U0r57ISqWD2vf4tj0pAl0HUHyjMm26YL4dTc6n8cmvMXXzSMx0/4wQrXo
	 t4ye9rdHCDSmYlNVE/t/s5E5nzCHKXgTvHvVjAs4NspMGB9evh1Cl5OJUPBxBWsgKQm1V
	 HT43u4hzwPesCdNHg/Eev0vwrxTGteCkA2iqUUOMAv3NF5J5KD81FyQboS/pZIbTzCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 360D1606A324
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Nov 2026 00:33:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 360D1606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 8A3BC6032F; Thu, 12 Nov 2026 01:33:35 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next v9 0/6] ipset: replace internal hash table with rhashtable
Date: Thu, 12 Nov 2026 01:33:25 +0100
Message-ID: <20261112003331.16894-1-fw@strlen.de>
X-Mailer: git-send-email 2.56.1
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

v9: No changes except variable names/comments in patch 5.

See patches for details for changes since v8.

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
 net/netfilter/ipset/ip_set_hash_gen.h        | 2176 ++++++++++--------
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
 15 files changed, 1464 insertions(+), 1075 deletions(-)

-- 
2.56.1
