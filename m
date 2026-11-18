Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795003074;
	b=Ep9sYV99EftTd92hF63yZJEplSBK+mAzqWxkAj8/tO5T+JwtF/u6qUAIrMdk0qcTJCBV
	 8k1UTM7K66RU1MKchyhurcRdhBeSECnXbmb6m1SuXHlT47aO5clZBychtCjhaJYs9NM/F
	 bYKOP0cwmYBu5s30P2EamQC+2MI1XwGydjtKBxKZmrDCJqKhd/JQZI69J64NrXm0zLQGZ
	 g2iewQSq0J1zf9nZ4MWMMmvHZhFn4Mg7jKaxwGTBX5mUnmULBRcJAlTbLnDSLXHiVYCEz
	 0Umc+kogwnzAI2JtGgIwE1fGDAklRmS9Wlh7iaN8SFehPRObhMvOmBgt/2p96enb2eA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795003074;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=smUEhlQVQjE6pwM3i1Eyxrz6fRGQmgC1yNv+jUSc3gQ=;
	b=zCg3l1joX20s/35XWuxFYR0mLohHPigCL0b0yQbnwfEQ5kNSI6FLyXZfmw3b80ej7L1s
	 UraoUgHsaq14av/jETmIyHthavXpMT5En7seEdfUlx+v/MVtHsiM8cN2lJ6oXniMZUFLH
	 MJxzj+P+sURsbmM26Xk+ih4tlJSzSpW5SeqPI/qkSgdKhflNQVrsgbuYxHtm1iBWzG30h
	 yVuQmPp6Hy4f7anyF/DyqZmZjVE/kIqpTEJJboa8VRCtilTyJfhBb60RICZI1BlcJ8whN
	 C3D2t17wxr6YDDoDuuecArx01JCo6LK5kohoebOmByDPk23XP+4fzwb5TswmRASOkpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67B48606A320
	for <netfilter-devel@vger.kernel.org>; Wed, 18 Nov 2026 11:57:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 67B48606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id AF08360633; Wed, 18 Nov 2026 12:57:52 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH nf-next v2 2/6] netfilter: nf_log_syslog: fix MAC header dump to use real header length
Date: Wed, 18 Nov 2026 12:57:28 +0100
Message-ID: <20261118115732.9529-3-fw@strlen.de>
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

old code unconditionally iterated dev->hard_header_len bytes, assuming
the SKB's MAC header is always exactly that long.

If the actual mac header in the packet is smaller, the loop reads past
the MAC and logs ip/ipv6 header as if it was part of the address.

Use skb_mac_header_len() as the base length, then clamp the result to
dev->hard_header_len so we never read beyond what the
device actually uses for its hard header, even if mac header was
mangled.

LLM finding, no bug was ever reported about this.

Fixes: 7eb9282cd0ef ("netfilter: ipt_LOG/ip6t_LOG: add option to print decoded MAC header")
Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 no changes.

 net/netfilter/nf_log_syslog.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_log_syslog.c b/net/netfilter/nf_log_syslog.c
index 910f6975cdf7..5f7435caff22 100644
--- a/net/netfilter/nf_log_syslog.c
+++ b/net/netfilter/nf_log_syslog.c
@@ -815,14 +815,17 @@ static void dump_mac_header(struct nf_log_buf *m,
 
 fallback:
 	nf_log_buf_add(m, "MAC=");
-	if (dev->hard_header_len && skb_mac_header_was_set(skb) &&
-	    skb_mac_header_len(skb) != 0) {
-		const unsigned char *p = skb_mac_header(skb);
-		unsigned int i;
+	if (dev->hard_header_len && skb_mac_header_was_set(skb)) {
+		unsigned int mac_len;
+
+		mac_len = min_t(unsigned int, skb_mac_header_len(skb),
+				dev->hard_header_len);
+		if (mac_len) {
+			const unsigned char *p = skb_mac_header(skb);
+			unsigned int i;
 
-		if (1) {
 			nf_log_buf_add(m, "%02x", *p++);
-			for (i = 1; i < dev->hard_header_len; i++)
+			for (i = 1; i < mac_len; i++)
 				nf_log_buf_add(m, ":%02x", *p++);
 		}
 	}
-- 
2.56.1

