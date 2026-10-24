Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.10.208.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792833989;
	b=oObxi0o5JrV6u6sfWN7UGRrBKvPlpKH8kiq+QqSMOuyl0/OEuc1PrzwXtwqkxVgBVz6Q
	 x/o3yueHMCwaug1RiWPdm6+rTQ1tSffH7TS1mqHoEb9vWUn++wFxr15t+iu6jvKIZQNhO
	 Bp3+NtNUZaPWoty7Er6k3jJi/9V4+sIhXCNnu6bwX5yo2qT6t0ZH1s8BV7x3FZgbntbJ5
	 HP08VnC3ixIoqclAf0ST5B4PIOJlrCzG5xLkMQY2TTrWEIsmW5jyJy7/AyNk2u9nGGXpi
	 I9lGjMpjh4tsmwTRRQ1WNvIL0NyrtSHv/Q1pvJ+aRXGsHVd2PyjpnYOuW7CjEPj5hpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792833989;
	h=DMARC-Filter:Received:DKIM-Signature:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Rspamd-Queue-Id;
	bh=281QRRbW1VmkF9elzsYyupLiOx9eoHUTjURhr4e3vkU=;
	b=2GLnN5hsI5Ee16in079/vsPbq8GcfGb4eDEttAAJ+UPzcKV5QpjR0C8a52TXqRezH+dW
	 YR+LP4T6WAA5DSqHdmYb7UJWuPyP89BAFoUiW7Ac8GobYXdfZKhDYkvtAGA4JELKidJ4p
	 lTwZ5VKGcedE5+/f95CXJLoLTE36nu/Q+iJOUqffG9SyG3ax9aUEruJyvmzEK/OcjfMLr
	 /qLcTEjcpDJ+CY6B4lzgry+spySg6H3mgmwVXISWhHH9k+me+Udwwz0QUSCRUOgUSPjxs
	 zpGNEmJ7gmXLGaYypxzdWwsxnKSitfrObkKm6EY25l19S6R7uVGtCx/2ak+vuQAzoIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=mandelbit.com;
	spf=pass smtp.mailfrom=mandelbit.com;
	dkim=pass header.d=mandelbit.com header.i=@mandelbit.com header.a=rsa-sha256 header.s=MBO0001 header.b=SD7Zdqcs;
	arc=none smtp.remote-ip=195.10.208.47
Received: from mout-b-107.mailbox.org (mout-b-107.mailbox.org [195.10.208.47])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42765606A337;
	Sat, 24 Oct 2026 09:26:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 42765606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mandelbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mandelbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mandelbit.com header.i=@mandelbit.com header.a=rsa-sha256 header.s=MBO0001 header.b=SD7Zdqcs
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:b231:465::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-b-107.mailbox.org (Postfix) with ESMTPS id 4jBZJG377Yz3y0f;
	Sat, 24 Oct 2026 11:26:06 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mandelbit.com;
	s=MBO0001; t=1792833966;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=281QRRbW1VmkF9elzsYyupLiOx9eoHUTjURhr4e3vkU=;
	b=SD7ZdqcsDfzf6EgfgQ5AtmN/VUNwU76YhUFhfErGIGO+/stACXBTcchulOnVN+Hc7iW6ae
	zYh7+Qor3ikQLzjj72CMMsrWIQJ35SyJuhumKIwsX83GJXxe8nXFHqp/ItT9mVBW9WpS+7
	LMHj6ANusIR5afg5VzfeQ7uJEbp8JGCLSeGC3wVUtlssOos5VLGL0CzeXqBGnSDfDaOerj
	Oiq2HfkZffHAXEZJtKkwObwwQw0dsykN3fVc+Q8OB8kt7nZO/Qo1rMbP4dvn2pYMuzKZ15
	bBBrmcRpt01RvkPdCgSoF1nRpR61m3+2ylm0J8h4o23relXxjVmshBFLYE2BNw==
Authentication-Results: outgoing_mbo_mout;
	dkim=none;
	spf=pass (outgoing_mbo_mout: domain of ralf@mandelbit.com designates 2001:67c:2050:b231:465::1 as permitted sender) smtp.mailfrom=ralf@mandelbit.com
From: Ralf Lici <ralf@mandelbit.com>
To: netdev@vger.kernel.org
Cc: David Ahern <dsahern@kernel.org>,
	Ido Schimmel <idosch@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	=?UTF-8?q?Daniel=20Gr=C3=B6ber?= <dxld@darkboxed.org>,
	Antonio Quartulli <antonio@mandelbit.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	linux-kernel@vger.kernel.org
Subject: [RFC net-next v2 04/18] netfilter: preserve IPv6 refragmentation state across reassembly
Date: Sat, 24 Oct 2026 11:25:14 +0200
Message-ID: <20261024092532.172005-5-ralf@mandelbit.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261024092532.172005-1-ralf@mandelbit.com>
References: <20261024092532.172005-1-ralf@mandelbit.com>
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
X-Rspamd-Queue-Id: 4jBZJG377Yz3y0f

Remember when all fragments describe a locally constructed IPv6
representation. Restore that state after conntrack reassembly so
IPv6 output can fragment the datagram for its actual route without
treating the old fragment size as a PMTU constraint.

Signed-off-by: Ralf Lici <ralf@mandelbit.com>
---
New patch in RFC v2.

 include/net/ipv6_frag.h                 |  2 ++
 net/ipv6/netfilter/nf_conntrack_reasm.c | 11 ++++++++++-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/include/net/ipv6_frag.h b/include/net/ipv6_frag.h
index 41d9fc6965f9..df0a6309b342 100644
--- a/include/net/ipv6_frag.h
+++ b/include/net/ipv6_frag.h
@@ -26,6 +26,7 @@ struct frag_queue {
 	int			iif;
 	__u16			nhoffset;
 	u8			ecn;
+	bool			frag_source;
 };
 
 #if IS_ENABLED(CONFIG_IPV6)
@@ -36,6 +37,7 @@ static inline void ip6frag_init(struct inet_frag_queue *q, const void *a)
 
 	q->key.v6 = *key;
 	fq->ecn = 0;
+	fq->frag_source = true;
 }
 
 static inline u32 ip6frag_key_hashfn(const void *data, u32 len, u32 seed)
diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index be72c4346f8b..dee89aaf56ee 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -272,6 +272,7 @@ static int nf_ct_frag6_queue(struct frag_queue *fq, struct sk_buff *skb,
 	fq->q.tstamp_type = skb->tstamp_type;
 	fq->q.meat += skb->len;
 	fq->ecn |= ecn;
+	fq->frag_source &= !!(IP6CB(skb)->flags & IP6SKB_FRAG_SOURCE);
 	if (payload_len > fq->q.max_size)
 		fq->q.max_size = payload_len;
 	add_frag_mem_limit(fq->q.fqdir, skb->truesize);
@@ -360,8 +361,16 @@ static int nf_ct_frag6_reasm(struct frag_queue *fq, struct sk_buff *skb,
 	skb->dev = dev;
 	ipv6_hdr(skb)->payload_len = htons(payload_len);
 	ipv6_change_dsfield(ipv6_hdr(skb), 0xff, ecn);
-	IP6CB(skb)->frag_max_size = sizeof(struct ipv6hdr) + fq->q.max_size;
 	IP6CB(skb)->flags |= IP6SKB_FRAGMENTED;
+	if (fq->frag_source) {
+		/* use the output route MTU instead of the old fragment size */
+		IP6CB(skb)->frag_max_size = 0;
+		IP6CB(skb)->flags |= IP6SKB_FRAG_SOURCE;
+	} else {
+		IP6CB(skb)->frag_max_size = sizeof(struct ipv6hdr) +
+					      fq->q.max_size;
+		IP6CB(skb)->flags &= ~IP6SKB_FRAG_SOURCE;
+	}
 
 	/* Yes, and fold redundant checksum back. 8) */
 	if (skb->ip_summed == CHECKSUM_COMPLETE)
-- 
2.55.0

