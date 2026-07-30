Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E211D3BBFAA
	for <netfilter-devel@vger.kernel.org>; Thu, 30 Jul 2026 07:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785396644; cv=none; b=QWe1aX9erdmS2S/+J7aZJZsVACNaDjErsO5ngxV910YNjF+G5rOU6S/80Mq+jEBvYzT8LTM5iajBwa58lDMxw6i+Xdnlwt7fWtoO73Xq/B3LxDmnqbnHPCr2p2ZY2hjVx6ApRXi6XfNmZUrjfvvjjeR6lMllKjxtDQ74SNCRe5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785396644; c=relaxed/simple;
	bh=GqQpAwlYaIZs3wCFyDpIWB/NE+UztWrFJBL/6ix0W3w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DvMS5rsb8/MAhGf27pnn8FZhkDmAbIqHMzHSYsaSIOhAIKafDx3UtERZzbo2lkrcVRP4Vk9bT4rxV7Q5K1SX4RARxQCvZ2QHrxCk1hrPHeFqjRJ7wncZUuu/AhU4Mlqfat1DD4C7srxUV8Rh4x/2qC+O8L+T9Au80dWXAyp/7zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=lytQPWeU; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="lytQPWeU"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2cab973140bso24863965ad.3
        for <netfilter-devel@vger.kernel.org>; Thu, 30 Jul 2026 00:30:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1785396642; x=1786001442; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=fbg4G6uDy6aVTLr4SsEE/5bJimkgIjt/OIwOsBCmh8Q=;
        b=lytQPWeUn10Zqu3wFmAbdhXLMEoT+qClCTYKFsaIRjTpY9pb12nApWsZC7jXR19TMB
         W8YSpHfqNBnZO+8MzZVxfDcDPs/4TlpjD4+6fWrULdnoHrC/YjUhf6UpoZeTga1OgGyl
         r26rGT8Fyu3CA2Xazhwv8pLMOqR1/S8qVZtIOwYJFheQAn4pSKkmECqLm9dj86sjE0zK
         +ZjKYhaksudgzkYu9dPKVAzQXpVLLHNFNNwn425lnf8uJj+wW9MrC/rRCwscfQpB91M3
         VuNpWHoC7CyjgXX5Ji/G4zQeDcoTdcyz27Ap8rE/BTFZscnBDIl47eaLKL+P1LWENLmu
         TKZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785396642; x=1786001442;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fbg4G6uDy6aVTLr4SsEE/5bJimkgIjt/OIwOsBCmh8Q=;
        b=HjoWkOr12OTRScNQrw/xrBRL1C0yYGdRDW0XxvkyO76ptc8n6Kwt9fMRK/T9YrYCir
         PsDQB2W8klpAS25hWsIMGtTRxy9p8l4oxU3ZlKFlj2IRsgBXGuHHBWv/QRNLUkkmhhKW
         5aF3GBdHtrUBJvhfE5lTTFrffRdPVKfB6Y+iO4Sl6jfenA4J1bTc5ausmhWb1ftDgsdd
         nR5uaFb6anyu+SC5yVzHTXbU5/oHWHBB7NDdqJAAetePwvEV4pc1vC4ecCb4eh2Ly3Qg
         3yBVOx+GEt802y9QyluphjKBkJlniKuSPxYCzkIFwWfnHaiQkkwesPDzIvXkT09HCtF6
         IDZQ==
X-Forwarded-Encrypted: i=1; AHgh+RqEZuObD6gXZyMohaQAuYJDcS6IrvfwoHsUMmedydcFeApO9JmhrY0an4BBv0p0+y8a0Gq9Us8iOAfBB4dQQVo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwvTzLIAJ/aUkFSgfgBZ1fTWFSLf387Nmw3mfS72lH3LAXy8HGc
	PCe8txKXKBVCBBSX/wO6rIls23RQyRrN+BjCcT3Vx8b8PSr5l7vYx3TdRb1x2O8eKyBX
X-Gm-Gg: AR+sD10akI8zK1X+zmz7e/FJoFf83jFDPQV1lekihdlOifDykpVP8EEJmDxD1IfkOSw
	X/YLliMFMfdNLlEfR7ZmQTFRJRzdDi/WC/oMiyo/PG0d7k29j58EMqT/HhZLffnukmaA6ehJOC5
	NTa+Syuq0OSLiwo77awmyspEHs0tdRa891SZ9RVJnGaa8zAyuz7GjkW+A8gwUj3QXWLUoFM7Dtc
	4TLqkiXd08UDDY7fwHWYIQprFUgnMlgeM99ZKRBrv+0zdWMROHcJAuwehgHhwm+79BW8zLmL36B
	zsk+PP8I/4cGoGeG+uBH/OG4Aq/pEP+7Yw/RNloZsBnFTNqt58yl8kPc6LqL3K9BANs+bLwYRQD
	t+wvydqjdOpBpj4IPyQAyoZZE7RO58Vmg1e2Lvck9L3K5cMdoE9cspE3S9TU3dXzLCxJL174NSZ
	tFl7YOudxb40Nf6ZatF1xMBPsvsJBcUHVbf4qSSO2P0G/ezvPHJ9mZm3IjSpUdaIQaTgurPqNDz
	8QT
X-Received: by 2002:a17:903:388c:b0:2ce:d5e4:2fcf with SMTP id d9443c01a7336-2d035cfb3a9mr15269515ad.42.1785396642130;
        Thu, 30 Jul 2026 00:30:42 -0700 (PDT)
Received: from Roxy.localdomain ([203.175.14.54])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d022a7e333sm22236325ad.36.2026.07.30.00.30.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 00:30:41 -0700 (PDT)
From: Zhiling Zou <zhilinz@nebusec.ai>
To: fw@strlen.de,
	netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org
Cc: pablo@netfilter.org,
	phil@nwl.cc,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	kaber@trash.net,
	zhaojignmin@hotmail.com,
	vega@nebusec.ai,
	zhilinz@nebusec.ai
Subject: [PATCH nf v2 1/1] netfilter: validate L4 headers after userspace packet writes
Date: Thu, 30 Jul 2026 15:30:26 +0800
Message-ID: <f0efaa7d67a580488fc5e32a09683c992db35742.1785392716.git.zhilinz@nebusec.ai>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

NFQUEUE and nft_payload can hand packet data modified by userspace back
to the stack. Recent restrictions keep link and network headers stable,
but the transport header can still be changed.

A packet can therefore keep the same network header and conntrack entry
while changing the transport header layout. For TCP, increasing doff can
make later helper or NAT code use a different transport-header base than
the parser used, and can make offsets point past skb->tail.

Extend NFQUEUE payload validation to check the final L4 protocol and base
header after IPv4 options or IPv6 extension headers. Reject packets whose
L4 protocol no longer matches an attached non-template conntrack entry,
reject unknown L4 protocols for writable payload replacement, and
validate TCP data offset before reinjection.

For nft payload writes, reject transport-header stores that overlap TCP
doff. nft_nh_write_ok() already rejects network-header protocol changes,
so keeping doff stable prevents nft payload writes from changing the TCP
header length underneath conntrack and helper users.

Fixes: 5e35941d9901 ("[NETFILTER]: Add H.323 conntrack/NAT helper")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Signed-off-by: Zhiling Zou <zhilinz@nebusec.ai>
---
changes in v2:
- Replace the H.323-specific NAT/helper-only fix with generic validation
  for userspace packet writes.
- Validate NFQUEUE payload replacements after IPv4 option and IPv6
  extension-header validation, including TCP data offset and attached
  non-template conntrack L4 protocol consistency.
- Reject nft_payload transport-header writes that overlap TCP doff.
- v1 Link: https://lore.kernel.org/all/68faab5bf406aad612233e76994c649fbc547b8d.1785133455.git.zhilinz@nebusec.ai

 net/netfilter/nfnetlink_queue.c | 58 +++++++++++++++++++++++++++++++--
 net/netfilter/nft_payload.c     | 13 ++++++++
 2 files changed, 68 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index b8aaf39cb4d8e..562b7bf6c8777 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -28,10 +28,16 @@
 #include <linux/netfilter/nfnetlink.h>
 #include <linux/netfilter/nfnetlink_queue.h>
 #include <linux/netfilter/nf_conntrack_common.h>
+#include <linux/icmp.h>
+#include <linux/icmpv6.h>
 #include <linux/list.h>
+#include <linux/sctp.h>
 #include <linux/cgroup-defs.h>
 #include <linux/rhashtable.h>
 #include <linux/jhash.h>
+#include <linux/tcp.h>
+#include <linux/udp.h>
+#include <net/gre.h>
 #include <net/gso.h>
 #include <net/sock.h>
 #include <net/tcp_states.h>
@@ -1192,6 +1198,49 @@ nfqnl_enqueue_packet(struct nf_queue_entry *entry, unsigned int queuenum)
 	return err;
 }
 
+static bool nfqnl_validate_l4(const u8 *data, unsigned int data_len,
+			      const struct nf_queue_entry *e, u8 proto)
+{
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
+	enum ip_conntrack_info ctinfo;
+	const struct nf_conn *ct;
+
+	ct = nf_ct_get(e->skb, &ctinfo);
+	if (ct && !nf_ct_is_template(ct) && nf_ct_protonum(ct) != proto)
+		return false;
+#endif
+
+	switch (proto) {
+	case IPPROTO_TCP: {
+		const struct tcphdr *th = (const struct tcphdr *)data;
+		unsigned int thlen;
+
+		if (data_len < sizeof(*th))
+			return false;
+
+		thlen = __tcp_hdrlen(th);
+		if (thlen < sizeof(*th) || data_len < thlen)
+			return false;
+
+		return true;
+	}
+	case IPPROTO_UDP:
+		return data_len >= sizeof(struct udphdr);
+	case IPPROTO_ICMP:
+		return data_len >= sizeof(struct icmphdr);
+	case IPPROTO_ICMPV6:
+		return data_len >= sizeof(struct icmp6hdr);
+	case IPPROTO_SCTP:
+		return data_len >= sizeof(struct sctphdr);
+	case IPPROTO_GRE:
+		return data_len >= sizeof(struct gre_base_hdr);
+	case IPPROTO_NONE:
+		return true;
+	}
+
+	return false;
+}
+
 static bool nfqnl_validate_ipopts(const struct iphdr *iph_new,
 				  const struct nf_queue_entry *e)
 {
@@ -1229,7 +1278,9 @@ static bool nfqnl_validate_ip4(const struct iphdr *iph, unsigned int data_len,
 	/* support for ipopts mangling would require
 	 * recompile + skb transport header update.
 	 */
-	return nfqnl_validate_ipopts(iph, e);
+	return nfqnl_validate_ipopts(iph, e) &&
+	       nfqnl_validate_l4((const u8 *)iph + ihl, data_len - ihl, e,
+				 iph->protocol);
 }
 
 static bool nfqnl_validate_one_exthdr(const u8 *data,
@@ -1286,7 +1337,8 @@ static bool nfqnl_validate_exthdr(const struct ipv6hdr *ip6_new,
 		int hdrlen;
 
 		if (orig_nexthdr == NEXTHDR_NONE)
-			return true;
+			return nfqnl_validate_l4(data, data_len, e,
+						 new_nexthdr);
 
 		if (unlikely(exthdr_cnt++ >= IP6_MAX_EXT_HDRS_CNT))
 			return false;
@@ -1323,7 +1375,7 @@ static bool nfqnl_validate_exthdr(const struct ipv6hdr *ip6_new,
 		data += hdrlen;
 	}
 
-	return true;
+	return nfqnl_validate_l4(data, data_len, e, new_nexthdr);
 }
 
 static bool nfqnl_validate_ip6(const struct ipv6hdr *ip6, unsigned int data_len,
diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index 391539a1ceaa7..63cf3b4f7420d 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -1077,6 +1077,17 @@ static bool nft_payload_csum_write_ok(const struct nft_pktinfo *pkt,
 	return false;
 }
 
+static bool nft_th_write_ok(const struct nft_pktinfo *pkt,
+			    const struct nft_payload_set *priv)
+{
+	unsigned int doff = offsetof(struct tcphdr, ack_seq) + sizeof(__be32);
+
+	if (pkt->tprot != IPPROTO_TCP)
+		return true;
+
+	return priv->offset > doff || priv->offset + priv->len <= doff;
+}
+
 static void nft_payload_set_eval(const struct nft_expr *expr,
 				 struct nft_regs *regs,
 				 const struct nft_pktinfo *pkt)
@@ -1115,6 +1126,8 @@ static void nft_payload_set_eval(const struct nft_expr *expr,
 	case NFT_PAYLOAD_TRANSPORT_HEADER:
 		if (!(pkt->flags & NFT_PKTINFO_L4PROTO) || pkt->fragoff)
 			goto err;
+		if (!nft_th_write_ok(pkt, priv))
+			goto err;
 		offset = nft_thoff(pkt);
 		break;
 	case NFT_PAYLOAD_INNER_HEADER:
-- 
2.43.0
