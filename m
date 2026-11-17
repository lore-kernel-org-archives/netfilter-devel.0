Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794916261;
	b=ni2o5+/A7DnLaL13yP1VeyHYUQU3oPy2sy34pEMVOMMyRHqLd8xNsBUf0mVfLWLUFt+S
	 ZxPfiC+EMuNThKPkkF5BViNp+q+vCogwmhpbD1QjmsSFi3FMnvMA5t5txWm5D6DXrwETn
	 sN6JWTctMI3pZJ/F3XM6jc3txVUsxIzph8DIP0vAQvuo5i3UzrhwEhvseHDdDxUjyKGzs
	 VuXOiviYuXlnc0vPA1swNG+4JYYRSDgfR/pkZw6wruOF7y5lpSrDkMTplC33KmSbgeDm1
	 C/xu5itvaxhTDt3EWyhZ5Qw7BJUtU1ldm1U8W/DyXDD/c8xQFaJJTAVj8/ampn6LdmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794916261;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=lKLpUdVYVQhtP9ATiUcikP9z7A+B8R2Wpfu2OLHa2SI=;
	b=HHE4rZ+5T9yi6voVmsvCB7SoVr53KLCTwA9rbT7h3KdTJ7g1/0G80lCiQdCo3MVySI0w
	 bHqEO4BtGQYUCHtWkRggeOaQsi1Mijk6axypNlKDi99Laf6XK5Qb4BWHxKqvXFWdL03r2
	 Q6QXchZ2NtpUAzf65pFsM5EAPGq0kn9tGAeHURELqZAj2AjCAArywFTGxKGY1YhvKV3ZK
	 LepN7p7gcgNxg5EtRCZE0o3eF0JEk0/zFlFM8TILkRDGS9KpSB0RqLZ6RIWBfvPVPMwbz
	 +9SmdhlUcoZJOwKH8uh/rldtU+frSr/9WmEtu8NBJ11RCF4F7vxJKZSPcn+zvtMfbwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7B69606A323
	for <netfilter-devel@vger.kernel.org>; Tue, 17 Nov 2026 11:51:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D7B69606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id E723F6055A; Tue, 17 Nov 2026 12:50:58 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 1/6] netfilter: nf_log: remove dead ARPHRD_SIT handling from MAC/HW header logging
Date: Tue, 17 Nov 2026 12:50:41 +0100
Message-ID: <20261117115046.15435-2-fw@strlen.de>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261117115046.15435-1-fw@strlen.de>
References: <20261117115046.15435-1-fw@strlen.de>
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

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_log_syslog.c | 17 +----------------
 net/netfilter/nfnetlink_log.c |  6 +-----
 2 files changed, 2 insertions(+), 21 deletions(-)

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
2.56.1

