Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794916265;
	b=E2hpWZsYg+ZsG4K9zI8qPX1L0q3tUIOVzUFT9IB3JCn/GN381vW2ZGq+rmyWb55R6p3u
	 kW2zU323wbIQ5/gEBfdNyBTyXyFubxo6TfZ+3awYMv3VniDiXbN5k9YO9SYjiXOsBsACi
	 cvfSyPh8Vmv3uOTrjb1qcpMghx00bKoBIBSJOrgl36k4xKm9D2DRKmmt4/F81ryd5bwqc
	 U2NkTjxX8MU3/wbc+oHGWUHEAh4SnhLlzmg9V6TtoRM0ZjTz61nmAr58wDVMJ59xfZPqO
	 jbphDnGaqejuPTWoXXZ48FSwYfjzMg130NEgahWw0AM1KMJ5UtHc4XkZtOAdDnLVjqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794916265;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=PACIaUk0WrDc9Qq4MXwG6yp11IQWdlRv53EhY2GpdMI=;
	b=RxP82Q2hs7mJNYY1U0PxnUkavr5X0T4317K0Z6du7pmsjyJsQtO/MsV4zMJAmV1yMhZB
	 /3LQY5ryY1ZI3cGIWohETtn2M8dPWbw1emAzFazRkG6qmCiLVA6SSx0wWkRi0YP+owZy+
	 F0GatJrX3iPYpbF2MpctkLn9W9ElioStffrnlNc5/YJLq+LAvzGRFaCxo35VMqSOhqosm
	 FYqlqelTmLQy1IeVd0YINUztVne9t8B/l+18F/Ebb0uwYoERpXvR+dKYA68kmedkB2CPg
	 w7wWFlotL5C9mLvYTAfeA5W82RLZhnZkId+LdtPTI5fTWmu6FzXwc/cAn2F3DeLaqyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB976606A31C
	for <netfilter-devel@vger.kernel.org>; Tue, 17 Nov 2026 11:51:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DB976606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 32D0F6055A; Tue, 17 Nov 2026 12:51:03 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH nf-next 2/6] netfilter: nf_log_syslog: fix MAC header dump to use real header length
Date: Tue, 17 Nov 2026 12:50:42 +0100
Message-ID: <20261117115046.15435-3-fw@strlen.de>
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

