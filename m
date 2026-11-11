Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.10.208.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794386667;
	b=5Fhg1PDAbwL9YwiHB4eiU5i+rHg3yorNkWVgihpOkWr27u4bxSsdK3hZ0r8F7P6LSXVf
	 Yn68oJ7PWI/MbtgU6k6n+vqqWFNqoTyWEafBEqUn8bOpZ6aQk+jzmGxdnxh1LLmArA496
	 1K5OoJzUQGSckox5WuAY8+Eswa+UtyKIWs9sJ95DN1/07n95P1tfc2a1iySZwXBraUh98
	 nBnxhlURS+GQX4328SkT0Pej1MQpcCKZMNDLqyPzBVLyWyc1PalmFZzKXjW667cH3sipC
	 ijOpfo/gAy76Ex0dlnEvUmBotKMZ3ixcLhf1w8e0ZMbbI8vmEFTJ0rs/4bGCdnBjR/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794386667;
	h=DMARC-Filter:Received:DKIM-Signature:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-Rspamd-Queue-Id;
	bh=0TaZ5JCUftcvgABnCcPfKOwKyYVdTvJYp612kagBhak=;
	b=Sasjr0GjKB57705BBvRdoXW1hRckXJQrMtxAtfJkpsLT4BZ8wjsI4SEn1Nzdtc2al6dd
	 xi9K9ItG9KDGcL9u9I4jdQQgMHmGzaES/102HyiaYPC+EZG0DouHgv3YE2XS1d02Jn964
	 u2o65q41h67z986kz5qkAZWF/ci9kdhNGGPDNk9Z6Fmj+QWTo8/uzSCuAhDypBwy4/PSw
	 gPh4/ZiqHd46mqbHxvY2+5DWNFXrlj2K54VinoyxKbwzabUzQvPuJgilZ0Kc0H0QnGVvl
	 MqtDkPQW4D1aMSJhGZj9JT3vibi/eHY6IP0AK0J1RabyF2cQSRZyr0vSCd5Ebr93AhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=mandelbit.com;
	spf=pass smtp.mailfrom=mandelbit.com;
	dkim=pass header.d=mandelbit.com header.i=@mandelbit.com header.a=rsa-sha256 header.s=MBO0001 header.b=ATF2+Wf+;
	arc=none smtp.remote-ip=195.10.208.52
Received: from mout-b-203.mailbox.org (mout-b-203.mailbox.org [195.10.208.52])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E531E606A320;
	Wed, 11 Nov 2026 08:44:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E531E606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mandelbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mandelbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mandelbit.com header.i=@mandelbit.com header.a=rsa-sha256 header.s=MBO0001 header.b=ATF2+Wf+
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:b231:465::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (4096 bits) server-digest SHA512)
	(No client certificate requested)
	by mout-b-203.mailbox.org (Postfix) with ESMTPS id 4jPcWg4fPpzLmG0;
	Wed, 11 Nov 2026 09:44:15 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mandelbit.com;
	s=MBO0001; t=1794386655;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=0TaZ5JCUftcvgABnCcPfKOwKyYVdTvJYp612kagBhak=;
	b=ATF2+Wf+xgoumpPzKb+IWK0RLW4Fsetsy6H391CtVmhidqOaqAe2SH6R4INqUSWp8WHgYB
	F+kqPWHMA2XMr7rwDOr2MNOIY4pl92TSPS39JykUSPypBuDEdhxjljdOtGJwqo1k74A4k6
	8a38WCXNlXeNb8YpnoLWfYjTvWae4ZtFN4KX+7IKfcLWKglOILtDy7fZLOfuN3X9N2fkpu
	qHkqMPvB459suDuYyvp2XWT0KpKF6qsz6CkwzoENEclNxuVFoCwQ1U+5UehpNB6uokQ6Qo
	v3NWaoMpD0U+OUiJAXQtfRDy2rADFS+86+we3kW9TRjlWjOk8vlWPFR9CTeJAA==
Authentication-Results: outgoing_mbo_mout;
	dkim=none;
	spf=pass (outgoing_mbo_mout: domain of antonio@mandelbit.com designates 2001:67c:2050:b231:465::1 as permitted sender) smtp.mailfrom=antonio@mandelbit.com
From: Antonio Quartulli <antonio@mandelbit.com>
To: pablo@netfilter.org,
	fw@strlen.de
Cc: Antonio Quartulli <antonio@mandelbit.com>,
	phil@nwl.cc,
	steffen.klassert@secunet.com,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	edumazet@kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org
Subject: [PATCH nf-next] netfilter: nf_nat: skip the xfrm re-lookup without outbound policies
Date: Wed, 11 Nov 2026 09:44:10 +0100
Message-ID: <20261111084412.2702283-1-antonio@mandelbit.com>
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
X-Rspamd-Queue-Id: 4jPcWg4fPpzLmG0

nf_xfrm_me_harder() decodes the session and redoes the xfrm lookup for
every packet whose source or ports NAT changed, even when there is no
policy that could match. The session decode alone is a sizeable part of
the NAT path.

Skip it when there is no outbound policy, global or per socket, the
default outbound policy accepts and the dst is not a bundle: the lookup
would return the same route. xfrm_route_forward() takes the same
shortcut for forwarded packets.

This is the common case for masquerading routers built with
CONFIG_XFRM that never use IPsec. Forwarding a 1400-byte packet through
conntrack and masquerade (x86, qemu -icount) drops from 7533 to 7091
instructions for UDP (-5.9%) and from 7835 to 7395 for TCP (-5.6%).
With an outbound policy installed the full path still runs, and a
block policy matching only the masqueraded flow still drops it.

Signed-off-by: Antonio Quartulli <antonio@mandelbit.com>
---
 net/netfilter/nf_nat_proto.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/net/netfilter/nf_nat_proto.c b/net/netfilter/nf_nat_proto.c
index 64b9bac228ea..69849d805984 100644
--- a/net/netfilter/nf_nat_proto.c
+++ b/net/netfilter/nf_nat_proto.c
@@ -600,12 +600,25 @@ nf_nat_ipv4_pre_routing(void *priv, struct sk_buff *skb,
 #ifdef CONFIG_XFRM
 static int nf_xfrm_me_harder(struct net *net, struct sk_buff *skb, unsigned int family)
 {
+	const struct netns_xfrm *xfrm = &net->xfrm;
 	struct sock *sk = skb->sk;
 	struct dst_entry *dst;
 	unsigned int hh_len;
 	struct flowi fl;
 	int err;
 
+	/* Without any outbound policy, global or per socket, and with the
+	 * default outbound policy accepting, the lookup below cannot change
+	 * the route unless the dst is already a bundle: skip it, and the
+	 * session decode it needs.
+	 */
+	if (!READ_ONCE(xfrm->policy_count[XFRM_POLICY_OUT]) &&
+	    !READ_ONCE(xfrm->policy_count[XFRM_POLICY_MAX + XFRM_POLICY_OUT]) &&
+	    READ_ONCE(xfrm->policy_default[XFRM_POLICY_OUT]) ==
+	    XFRM_USERPOLICY_ACCEPT &&
+	    !skb_dst(skb)->xfrm)
+		return 0;
+
 	err = xfrm_decode_session(net, skb, &fl, family);
 	if (err < 0)
 		return err;
-- 
2.56.0

