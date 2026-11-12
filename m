Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794494308;
	b=llQegkYwaAGjT95ez4hKWOkSOJdohaT0McMPMbleGdaDPyY5+N9cD9JqK131R07k/iXv
	 eV4wOVJKhNJvzuFOoVEr/ZaHJ8IG/JAPqZMXgjRYerj1PUI+t5eLSuuyx6CBmqFC3k6w6
	 nJpHefi1IehSPkajAW9DcsO48gopGKwlZl/ud/psniJ3erlg38KyPci6Kzq7vVknBe2/z
	 gyZSYCGmZrqrQU4PnBtSdjJtgKqRylAJNj3rhAdp7sbFpBVvf3a3zLLhOsgohzLxDYIxO
	 +jW+fMEXMr5tPQlXd14GGwMPrg+1aATUhsCQyHEt4WLEdSZHDW5RJNWu8MAq06mREBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794494308;
	h=DMARC-Filter:Received:From:To:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WtJk3qD1VxBraIKNHiT3TGL6Mg5+HUfslmM5ox2UI4c=;
	b=yV1fi162CZDmjWSqHQkyzYleARACfEyPGwwrKd7EofaR+r8otKlIDZ9bBAUNBBA024qN
	 uXMUpxvE4UKfSe2jtjXHB0JN4ID0oVKxhcSfuvu39aIUfF5ZODaZJ29OpCGkTFUy3s/xM
	 4TEDftomRhHoJi0sSka54NBJ4VCS32xL65f8UV/u8FwlBVE9PcL1KoFqsCMaB53Oe1SzX
	 HUJORH3sip7RbCuv2DfC3l6yKclFNrTEo5GHtA3VIojXYdb70PC33SHhxRTa40qEceceC
	 ZLrjunga5D8aTX2v9NYa8OIywZLp9fr59mK5bvEy81VkwbPLqj1hj6v+HEHdaHgFIlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7178C60A2608
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Nov 2026 14:38:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7178C60A2608
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 33EB96028B; Thu, 12 Nov 2026 15:38:25 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next v10 0/6] ipset: replace internal hash table with rhashtable
Date: Thu, 12 Nov 2026 15:38:12 +0100
Message-ID: <20261112143818.30638-1-fw@strlen.de>
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

v10: No changes except dropped mention of rhltable in patch 3 commit
message.

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
