Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795003076;
	b=OgpoUBIdMeqo4kNWTsFeRj993YXt/71ZFgfKz+4qfxtesgJr/Puf615vA+M2out80bF7
	 MYMUfDmZ6AtOceblgE5lYrWyb0y/BL+C/VwU2Db2fB2nnnDYKfwoVp8DpmykY654r/wD/
	 XpI4bU/M7Y8kR3kLiSNZTrtiRKYXuYyLVNKTat08nsXO98lFthG0eMo+K/itsXJ89cG9x
	 +Ih9MQHLmOzFM5ZrEtEY6Sx8JWEmTlDM0Tv5Y3p+LamoHdlKYbU7g2bk/d2XnXA2X6/At
	 +JGnS+qYgoKU0hVBN2QKMQHTrFfAEhg+zLOX3jFTYcZIHNtKL3iTgrYJXxtekQRtpPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795003076;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=VHKQ3bQrrrEvEPNL3VtQJO/izgx37XMfGj2lAfV+LmU=;
	b=qgrS0mlci/wBUFlJ04Gw+Ip681HvDVALs54htf4uA1B4jbiCxadExwcHzjwPETlIVifl
	 vMm4Gq3QKwwsZJLiafjY3G5Ml2QXbYQNc7GoDIhOczUtLOr5g0+LJgl4Vu4GSG1RoyGfK
	 k5vy7foAZL3Q0WJvbSVJUafE4kWLN2TLm6dnljR2tyF5Zpoin7ZrwysFAXtzEq50X5dAL
	 SlW3kD3uEg/KrMBX/zFflJy96xW0ZGtaXA0+tE+MUcfxnrWbUrEGNBZGZAawKgRls3mCD
	 Rgz+ESfvmz+8pDDUBIY8QmdHn15nsfGeDaB8EH63ktuNuEaZMANzZsY7gGxMmS65VOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46EE3606A320
	for <netfilter-devel@vger.kernel.org>; Wed, 18 Nov 2026 11:57:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 46EE3606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 6E85760D56; Wed, 18 Nov 2026 12:57:48 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v2 1/6] netfilter: nf_log: remove dead ARPHRD_SIT handling from MAC/HW header logging
Date: Wed, 18 Nov 2026 12:57:27 +0100
Message-ID: <20261118115732.9529-2-fw@strlen.de>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261118115732.9529-1-fw@strlen.de>
References: <20261118115732.9529-1-fw@strlen.de>
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

dump_mac_header() in nf_log_syslog.c and the HWHEADER dump in
nfnetlink_log.c special-case ARPHRD_SIT devices by backing the header
pointer up by ETH_HLEN before dumping dev->hard_header_len bytes, on the
assumption that a SIT tunnel's "hard header" covers the underlying
device's real Ethernet header plus the tunnel's IPv4 header.

That assumption stopped holding after commit 8ef9ba4d6666 ("IPv6: Set
SIT tunnel hard_header_len to zero"), which zeroed dev->hard_header_len
for SIT tunnels.

The syslog call site was gated on dev->hard_header_len being nonzero,
so the ARPHRD_SIT branch there has been unreachable dead code for every
SIT device ever since.

For nfnetlink_log the branch was still reachable, but the adjusted
pointer is never read: nla_put() for the NFULA_HWHEADER attribute uses
dev->hard_header_len as the length, which is 0 for SIT tunnels.

Remove the ARPHRD_SIT special-handling; it's been 6 years and no one
reported this ever since.

Also use the ingress device for the netlink message size estimate of
the hardware header attributes: skb->dev can have been repointed to a
device with a different hard_header_len before the hook runs (multicast
routing does so before the FORWARD hook), and it is dereferenced
without a NULL check.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 v2: use  nla_total_size(in->hard_header_len), not
 skb->dev.

 net/netfilter/nf_log_syslog.c | 17 +----------------
 net/netfilter/nfnetlink_log.c |  8 ++------
 2 files changed, 3 insertions(+), 22 deletions(-)

diff --git a/net/netfilter/nf_log_syslog.c b/net/netfilter/nf_log_syslog.c
index c3fd398ffcd7..910f6975cdf7 100644
--- a/net/netfilter/nf_log_syslog.c
+++ b/net/netfilter/nf_log_syslog.c
@@ -820,26 +820,11 @@ static void dump_mac_header(struct nf_log_buf *m,
 		const unsigned char *p = skb_mac_header(skb);
 		unsigned int i;
 
-		if (dev->type == ARPHRD_SIT) {
-			p -= ETH_HLEN;
-
-			if (p < skb->head)
-				p = NULL;
-		}
-
-		if (p) {
+		if (1) {
 			nf_log_buf_add(m, "%02x", *p++);
 			for (i = 1; i < dev->hard_header_len; i++)
 				nf_log_buf_add(m, ":%02x", *p++);
 		}
-
-		if (dev->type == ARPHRD_SIT) {
-			const struct iphdr *iph =
-				(struct iphdr *)skb_mac_header(skb);
-
-			nf_log_buf_add(m, " TUNNEL=%pI4->%pI4", &iph->saddr,
-				       &iph->daddr);
-		}
 	}
 	nf_log_buf_add(m, " ");
 }
diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index d923f2cb1398..90e87c34df85 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -610,11 +610,7 @@ __build_packet_message(struct nfnl_log_net *log,
 
 		hwhdrp = skb_mac_header(skb);
 
-		if (skb->dev->type == ARPHRD_SIT)
-			hwhdrp -= ETH_HLEN;
-
-		if (hwhdrp >= skb->head &&
-		    nla_put(inst->skb, NFULA_HWHEADER,
+		if (nla_put(inst->skb, NFULA_HWHEADER,
 			    skb->dev->hard_header_len, hwhdrp))
 			goto nla_put_failure;
 	}
@@ -772,7 +768,7 @@ nfulnl_log_packet(struct net *net,
 		+ nlmsg_total_size(sizeof(struct nfgenmsg));	/* NLMSG_DONE */
 
 	if (in && skb_mac_header_was_set(skb)) {
-		size += nla_total_size(skb->dev->hard_header_len)
+		size += nla_total_size(in->hard_header_len)
 			+ nla_total_size(sizeof(u_int16_t))	/* hwtype */
 			+ nla_total_size(sizeof(u_int16_t));	/* hwlen */
 	}
-- 
2.56.1

