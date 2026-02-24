Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C88CB30ACF1
	for <netfilter-devel@vger.kernel.org>; Tue, 24 Feb 2026 06:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771916004; cv=none; b=h8cU6zCLT3PiaVEknkJYiz1Ri3ZbVuGR2s8bRwIqmaf6GnE4Gj4CRVdnUZLztC5cQfuueLGUgzzUPvaoVYrhzqf6VfBRdQ0qUfvfOKrCfGgjf55X2cKstLiT5QnwAj5MxKv+2qkEnVR3gzuNpH9rIJ3cPsWwg3zfK+Fjal+TTrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771916004; c=relaxed/simple;
	bh=otw/sidfsrVAXpxIAPSAHcc1JnUEwkQzo3iMewEEbLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KNM58rmzrJvPqqLFQdrkNhVfOHVF8MVkkDkr2rdDI7SAXwW+vxAmvtmhhcyzIdaTeZ+ozeVM1HbErntj9iaQDS6/5xvR5Y06NtPBz+S/Q13gTjbXLKMSbfX4Ej3xcPYz0r2OPyaqvHMYkFQdQiDLBfg3bGTCf9vjB7+YqdgJcxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MDi+Eww/; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MDi+Eww/"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-65c5a778923so7854248a12.2
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Feb 2026 22:53:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771916001; x=1772520801; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=coP60IDvUwENZ4G8REzPur6qzEmmqfojoUutShryN4c=;
        b=MDi+Eww/pw94u6xHqF0tz18BMsf7tuVhogQtdfWVLjch7+IYeLGrJ8xFbhvq4JGXcy
         8ERihOa5D+h/LePO9YzjvtR23MqXs6L7aPBmEaFkonhkHJxvFoP+7iPjNUiaK8lqqC+v
         eKiKIkxX5tqzyp3d8AN9ig1YQTnrKrrO8hXUcsYZ6ctjOoh1W7RBogCFAbdwqQETeGWf
         yfUHh0btuUYCxMKKyxwT7bPeufU1nP8rqs06A0fZf46TXNFZ7Cu5fbIqA9uGQPgq8TM2
         RhMB6Zxhztzf0LB9qb25JViHrQuB9wDI4HErh04oRbKYz8iCkEiuSRjYtXrv4qIw4QH/
         cLaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771916001; x=1772520801;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=coP60IDvUwENZ4G8REzPur6qzEmmqfojoUutShryN4c=;
        b=hwoJXoPbNsXbffD/c+rOn5dbsrVlu1HpHW6Ho60VtExrp1Q6ADHH88NDYSLyfPBEKR
         /IXA2JR1A6pI+pdBz1wyjVH+RZGCxP5eusanARVpbLIHDWAAgLDMCorAmCTir/ebdNSB
         R0PgdtU6HYROJ1lF00EAsuI9oxK0nM23xYTd8/hIYzbF7jvgzD8eIHvY9LbmepXafiWD
         2ToQGQ7O74XkHCxnS2I7P0freP7ABbJjBSJ3Cm9wN3ceHb2+Vdj03ubLz+Ool/J8Hykj
         R1L1W06gJ4grXwWEJxi8fBSjLkaWz3zmG+6g8goqIJ4IyzWNXzoIibBLMPOXKYqNmZir
         PO3w==
X-Forwarded-Encrypted: i=1; AJvYcCUu+WckJG499JLRxTuFN0m/glDFDIsyKVoVtmAVOJvYV6D6sJe7sxNhwF6KZ/GUqweSYD9gdPd06HLe9j9qTvY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyvIX2ulL68RnWm6kBX1s4LyibudthVgifPoJ5JcMZJIIcF5xf0
	g/qdDZ2AOspLsJYKNPy4mm0HPvbGHbs0ii/wQeVZVvFUEUKorIlNa1eu
X-Gm-Gg: ATEYQzyBcy0P0MWDSR5BeVQvp4zqYZJ8mKAtNQC5pN7Z/cYaCAFni0UpWcua0t7VuIc
	ltQDp6YZ5Fa6+6oHWRRP9gZaLcfvbaCSMEk8JCcRxn+lsWxTD91a8VcrkoxBI0rIi+Xy6PBnUUL
	IPCYg9gAuuTl9qKzCyLc05r77+f4Y8pFgKjSku276EXa6iDkMBdS/LdhTODl0wA5pKMUh6uYiJe
	UUVjMrAHnyFKgE04t0tfT+sQjO7RnJUJR6YinsT1QEE4YusOvnYUmxey7MtGTT2lSJByhlNeYbx
	TTmLl7SIyZBeFneyDsStxTq4sxODgW50l884475h0uBhN1HeECG2UQko2CkVZshzrd31jgID0KK
	lN3gkoA8I3R5UObWsUuL3RpP9BLqMsYS7HobVhLbC2kJAqNaazUYXy2y31ShDLAKAPoQHxY2fFY
	NYFrLcnuniNd0om+xNoEHasCJvLRvJPrM1I7UdIobuHAK90lnqS41dSISrAD3K/oq11n0HPx4xo
	IvUQ+4BICbn8rPkTTJMcCWtD40EkHs9pMrYvkGJNLQOBE+KxhTwKV0=
X-Received: by 2002:a05:6402:50d2:b0:64b:58c0:a393 with SMTP id 4fb4d7f45d1cf-65ea4f07f63mr7024950a12.30.1771916001174;
        Mon, 23 Feb 2026 22:53:21 -0800 (PST)
Received: from eric (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-65eaba13866sm3096698a12.18.2026.02.23.22.53.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Feb 2026 22:53:20 -0800 (PST)
From: Eric Woudstra <ericwouds@gmail.com>
To: Michal Ostrowski <mostrows@earthlink.net>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	Simon Horman <horms@kernel.org>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>
Cc: netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	bridge@lists.linux.dev,
	Eric Woudstra <ericwouds@gmail.com>
Subject: [PATCH v19 nf-next 5/5] netfilter: nft_chain_filter: Add bridge double vlan and pppoe
Date: Tue, 24 Feb 2026 07:53:06 +0100
Message-ID: <20260224065307.120768-6-ericwouds@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260224065307.120768-1-ericwouds@gmail.com>
References: <20260224065307.120768-1-ericwouds@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In nft_do_chain_bridge() pktinfo is only fully populated for plain packets
and packets encapsulated in single 802.1q or 802.1ad.

When implementing the software bridge-fastpath and testing all possible
encapulations, there can be more encapsulations:

The packet could (also) be encapsulated in PPPoE, or the packet could be
encapsulated in an inner 802.1q, combined with an outer 802.1ad or 802.1q
encapsulation.

nft_flow_offload_eval() also examines the L4 header, with the L4 protocol
known from the conntrack-tuplehash. To access the header it uses
nft_thoff(), but for these packets it returns zero.

Introduce nft_set_bridge_pktinfo() to help populate pktinfo with the
offsets.

Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
---
 net/netfilter/nft_chain_filter.c | 55 +++++++++++++++++++++++++++++---
 1 file changed, 51 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nft_chain_filter.c b/net/netfilter/nft_chain_filter.c
index d4d5eadaba9c..66ef30c60e56 100644
--- a/net/netfilter/nft_chain_filter.c
+++ b/net/netfilter/nft_chain_filter.c
@@ -227,21 +227,68 @@ static inline void nft_chain_filter_inet_fini(void) {}
 #endif /* CONFIG_NF_TABLES_IPV6 */
 
 #if IS_ENABLED(CONFIG_NF_TABLES_BRIDGE)
+static int nft_set_bridge_pktinfo(struct nft_pktinfo *pkt, struct sk_buff *skb,
+				  const struct nf_hook_state *state,
+				  __be16 *proto)
+{
+	nft_set_pktinfo(pkt, skb, state);
+
+	switch (*proto) {
+	case htons(ETH_P_PPP_SES): {
+		struct ppp_hdr {
+			struct pppoe_hdr hdr;
+			__be16 proto;
+		} *ph, _ph;
+
+		ph = skb_header_pointer(skb, 0, sizeof(_ph), &_ph);
+		if (!ph) {
+			*proto = 0;
+			return -1;
+		}
+		switch (ph->proto) {
+		case htons(PPP_IP):
+			*proto = htons(ETH_P_IP);
+			return PPPOE_SES_HLEN;
+		case htons(PPP_IPV6):
+			*proto = htons(ETH_P_IPV6);
+			return PPPOE_SES_HLEN;
+		}
+		break;
+	}
+	case htons(ETH_P_8021Q): {
+		struct vlan_hdr *vhdr, _vhdr;
+
+		vhdr = skb_header_pointer(skb, 0, sizeof(_vhdr), &_vhdr);
+		if (!vhdr) {
+			*proto = 0;
+			return -1;
+		}
+		*proto = vhdr->h_vlan_encapsulated_proto;
+		return VLAN_HLEN;
+	}
+	}
+	return 0;
+}
+
 static unsigned int
 nft_do_chain_bridge(void *priv,
 		    struct sk_buff *skb,
 		    const struct nf_hook_state *state)
 {
 	struct nft_pktinfo pkt;
+	__be16 proto;
+	int offset;
 
-	nft_set_pktinfo(&pkt, skb, state);
+	proto = eth_hdr(skb)->h_proto;
+
+	offset = nft_set_bridge_pktinfo(&pkt, skb, state, &proto);
 
-	switch (eth_hdr(skb)->h_proto) {
+	switch (proto) {
 	case htons(ETH_P_IP):
-		nft_set_pktinfo_ipv4_validate(&pkt, 0);
+		nft_set_pktinfo_ipv4_validate(&pkt, offset);
 		break;
 	case htons(ETH_P_IPV6):
-		nft_set_pktinfo_ipv6_validate(&pkt, 0);
+		nft_set_pktinfo_ipv6_validate(&pkt, offset);
 		break;
 	default:
 		nft_set_pktinfo_unspec(&pkt);
-- 
2.53.0

