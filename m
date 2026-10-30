Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793375089;
	b=uZAzUOOEkVCGst7IIeImCk77wiQxaOPfPeS0oPEYXXN9zuw0eBT4eqA8g3cuSCZL13Tt
	 qLjffmmFSU3wCBYl1tjOwBNmpCy4X6iRMwXBhVzhyiIv/8p9yntLPJbr0tdIiHewehoLL
	 WAEn0TlF0XnGmRDztyOPf0rUUZxgJdsSssFND84xyyIz5uJdkTvXK+6llfjSMhDGlJRkD
	 iAm1kKirl2dQdlff1xupwjr46egMVECYMRjTpJamEP1eEPuSD1scd5KzeSyz2IiBR3hkb
	 BEnAGldf1F31e92oBpVDfzsMToCbeC7czNRF5Uesf3MgfZ75K4MzpczsBgYxRMbTVVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793375089;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=FjUthu6l+mR74HyZN6hzvChtqbXg94VKIpPied5/4G0=;
	b=W+qfliB6qO2RiAqU3QMXJUHJR7vL2kIJKTP66bXpF/gS2EmrX2G4wjQ4nxdiXad6G2M0
	 9oKbRwJDmsJmVn/f1mRJLGdtgJ5baWEmIgFeUdU63I74cr1xZ2yd8YnuYMPVZsYQRMPuF
	 u/DaDHDrlWdqYGp4215itfqCooSqclgUxBLv72ZRk6L7ol8u8ZOBMvS3JkNepozteiXwm
	 OZSF2AiErOeasZiBa8/qK/6/eqfJ1RyX6Wf9BL9ucBaqWOf2M8xB0N+2ZS2AeCC94O1gj
	 xJRJznvvO4lSpSSolDMl2QRi5ewhvsQHbQpyhupTVYUGo2OwKAWiXe6bKqOHAIW1EFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FE3A606A326
	for <netfilter-devel@vger.kernel.org>; Fri, 30 Oct 2026 15:44:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7FE3A606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 96426609D0; Fri, 30 Oct 2026 16:44:46 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf 1/4] netfilter: nf_log: remove dead ARPHRD_SIT handling from MAC/HW header logging
Date: Fri, 30 Oct 2026 16:44:30 +0100
Message-ID: <20261030154433.13601-2-fw@strlen.de>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261030154433.13601-1-fw@strlen.de>
References: <20261030154433.13601-1-fw@strlen.de>
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
pointer up by ETH_HLEN before dumping dev->hard_header_len bytes, on
the assumption that a SIT tunnel's "hard header" covers the
underlying device's real Ethernet header plus the tunnel's IPv4
header.

That is no longer the case: ever sice commit 8ef9ba4d6666 ("IPv6: Set
SIT tunnel hard_header_len to zero"), dev->hard_header_len is 0 and
these branches are dead code.

No bug report in 6 years, so lets remove those branches.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_log_syslog.c | 23 +++--------------------
 net/netfilter/nfnetlink_log.c |  6 +-----
 2 files changed, 4 insertions(+), 25 deletions(-)

diff --git a/net/netfilter/nf_log_syslog.c b/net/netfilter/nf_log_syslog.c
index c3fd398ffcd7..3ff5a49a1c8d 100644
--- a/net/netfilter/nf_log_syslog.c
+++ b/net/netfilter/nf_log_syslog.c
@@ -820,26 +820,9 @@ static void dump_mac_header(struct nf_log_buf *m,
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
-			nf_log_buf_add(m, "%02x", *p++);
-			for (i = 1; i < dev->hard_header_len; i++)
-				nf_log_buf_add(m, ":%02x", *p++);
-		}
-
-		if (dev->type == ARPHRD_SIT) {
-			const struct iphdr *iph =
-				(struct iphdr *)skb_mac_header(skb);
-
-			nf_log_buf_add(m, " TUNNEL=%pI4->%pI4", &iph->saddr,
-				       &iph->daddr);
-		}
+		nf_log_buf_add(m, "%02x", *p++);
+		for (i = 1; i < dev->hard_header_len; i++)
+			nf_log_buf_add(m, ":%02x", *p++);
 	}
 	nf_log_buf_add(m, " ");
 }
diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index d923f2cb1398..0b590c117f4c 100644
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
-- 
2.56.0

