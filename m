Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792422187;
	b=2+Q9R0OxpwdqW1Vpo2kAdPkFNqlMm3uvD7jp0AvOizJpoduIh2mT3HdDQYT8azzh+uUG
	 3q9CavzXRr1jAbS2wbfqaTBBl+rbSqygGGsAPZBIg+qNorf2zr7/LWNTyhxFFzpHCSFph
	 GihTPrdgZAjfvNINu5rcCbsX2H1ZO5OEl1HdwPJa1N5YgeMSp4ow8tjTriGXMHxs5FZbp
	 h7hIOzMZu+hIihECXZ6wvZb5D0HOeVYp6j1QHV+cEF93YpbOeTA9zFkvg0oKGecifBdXG
	 hrl28jklEDlu188FF5IMU7hm8vrv7mRw8gY33zeHc59e5CT/kLswHNOuTpKm7Uq70/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792422187;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=J1BVIzuDSDYIBVS4IndBEImTqA8QgAVQAqAQoQ8bmeg=;
	b=YdTdzHiVpQu69VwP2HBR+qxq2S31Mktg+k3UXPyM83DtGQxZcFKr1u1rIjoacPpYBnCr
	 STcFIqtsDJfNQnINLjJFyEBcwsciNrhw+KONyFC+/W3WNqoWUPw1nOUtC76KmMg/EYChg
	 0akAkttwMtgYzG73N2fzXqUItCK7EllOydtLTVFk9w3QbAa+pjinn8Pt8V91oTlg95zgL
	 F9iHybPgqprz5vyPP8x/cfln5q2B7CuS1JCG98hIPaJd2DPthQOFh0NE/AteK4AX3mUj8
	 lENwDBzlOqmeFVa7lsUxs2uMHQ+LK4hw1xMNCkX2mZJ921AywOe0iW7gNUX7L9XO4AQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=ZXwArqBy;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE672607D34D;
	Mon, 19 Oct 2026 15:03:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DE672607D34D
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=ZXwArqBy
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1792422178;
	bh=J1BVIzuDSDYIBVS4IndBEImTqA8QgAVQAqAQoQ8bmeg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZXwArqBy5CWOUfmKJpY2cIoeXlK+2KVSV8sDtdieZLtpAPos5cYIJbjSygI28dYnC
	 u4VE/icpMgyPYOyS6vx8XfcFkfnY1HG5RtVq3nBJHAMjdgQmV1RtwQh1lwBDAYvQrI
	 XnkbLc/sMEzgLgXgxvEuNQgLF4FfrcICJ5Dxf2bj9jVacz4ehf92JNbwQy5ep+4f+o
	 qWbkwYWo5E58c/06lMeq6u92vXWKCsGI72hABMcVLPpmcRrdvdYVC9YY/1q18BrK9T
	 T3Rp2Ad9SOF00bGdyrio5Mbk/cLabcNnwU2UWB9KkIwY0hxr3typtWUA8L2fiw64JE
	 H5qvrppoa68xA==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id D2FE16005D;
	Mon, 19 Oct 2026 17:02:57 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@kernel.org,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net 01/10] netfilter: nf_conntrack: avoid truncating IPv6 nexthdr offset
Date: Mon, 19 Oct 2026 17:02:40 +0200
Message-ID: <20261019150249.1879516-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261019150249.1879516-1-pablo@netfilter.org>
References: <20261019150249.1879516-1-pablo@netfilter.org>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>

find_prev_fhdr() returns the offset of the Next Header field before an
IPv6 Fragment header through an int pointer, but stores the offset in a
u8 local.  An extension header chain can put this field beyond byte 255,
causing the offset to wrap before it is saved in the fragment queue.

Reassembly later uses the wrapped value to update the preceding Next
Header field.  This overwrites another byte in the IPv6 header chain and
can make conntrack parse a different transport tuple from the one used
by IPv6 local delivery.  A two-fragment packet can, for example, be
recorded as UDP destination port 53 while its payload is delivered to
UDP port 9999.

Use int for the working offset, matching the output argument and the
other offset variables in this path.

Fixes: 9fb9cbb1082d ("[NETFILTER]: Add nf_conntrack subsystem.")
Assisted-by: Codex:gpt-5
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv6/netfilter/nf_conntrack_reasm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index 599c49bf0a0a..be72c4346f8b 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -398,7 +398,7 @@ find_prev_fhdr(struct sk_buff *skb, u8 *prevhdrp, int *prevhoff, int *fhoff)
 {
 	u8 nexthdr = ipv6_hdr(skb)->nexthdr;
 	const int netoff = skb_network_offset(skb);
-	u8 prev_nhoff = netoff + offsetof(struct ipv6hdr, nexthdr);
+	int prev_nhoff = netoff + offsetof(struct ipv6hdr, nexthdr);
 	int start = netoff + sizeof(struct ipv6hdr);
 	int len = skb->len - start;
 	u8 prevhdr = NEXTHDR_IPV6;
-- 
2.47.3

