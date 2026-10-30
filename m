Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793375093;
	b=tipsLfKD2Z9fPPBZPvmHvcGhz3mB3p1nBwzXW1qvRoS6lerHMDbGlVfz28qFd8OJlFqk
	 dLm2HxMe3X+2IPbQu5KJcAtKtPfdNTyBfdRdO1rP/xrgIbZzh1TBqy4Kx5GV+vmjJx4TH
	 jpPD9D3AIBlk5lqhwwis4oDQmKFlH+Mz3caRrXg/mw0RFRXY33PsKM2mlOja327we+CGZ
	 ryTd3LCOiiO2gRjYbssn8NvOvWcEBZrcv55AckDcFK0Fj+U/slbjL3dV7xiSlf4GxFe+K
	 gTV4xoh4sQy2ZHIVA/9KiGEC15HtWSBkw4BXRyVh6f/WaRpayhkFf4ojzhmyf93x3Eg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793375093;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=dQYC71cvWb3UWDl8a9R2SAt5Yajvglu2+GpGaWEcIfs=;
	b=ZdqlQWCPdbEAXApc7vhwxQMjvO/qwTdZQ9tMrd5wUu1Wv6JWb3AVY58kqwjkcHjJSb6U
	 xJPPMQZlhxuHe45LZ0Hy/FKRVisMM6m/0vlU4kiI6oRi2jy6fBEn4ZpdosoZ28pdwv2nE
	 GAqrqJ4p7P+Pa9Aa1cHhAuiB3WmbvK8ZIgtesR8yFier4SH7UyWO33oBuAOkPyEDZgecQ
	 iazYM1UwgLC5qui3jHrnibV0HBHDR3tz9cisgNc4zU4CSpqyrFs1dvFF0U0/Orki9p8h/
	 OmikLHnZGKBH/UgKDq+QdpsFi7IroWQQGuf3aR/Uj2hHYF/0SaHoXa2ly738dy3F9Gw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89B33606A321
	for <netfilter-devel@vger.kernel.org>; Fri, 30 Oct 2026 15:44:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 89B33606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id D7373609D0; Fri, 30 Oct 2026 16:44:50 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf 2/4] netfilter: nf_log_syslog: fix MAC header dump to use real header length
Date: Fri, 30 Oct 2026 16:44:31 +0100
Message-ID: <20261030154433.13601-3-fw@strlen.de>
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
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_log_syslog.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nf_log_syslog.c b/net/netfilter/nf_log_syslog.c
index 3ff5a49a1c8d..332fe47fd109 100644
--- a/net/netfilter/nf_log_syslog.c
+++ b/net/netfilter/nf_log_syslog.c
@@ -815,14 +815,19 @@ static void dump_mac_header(struct nf_log_buf *m,
 
 fallback:
 	nf_log_buf_add(m, "MAC=");
-	if (dev->hard_header_len && skb_mac_header_was_set(skb) &&
-	    skb_mac_header_len(skb) != 0) {
+	if (dev->hard_header_len && skb_mac_header_was_set(skb)) {
+		unsigned int mac_len = skb_mac_header_len(skb);
 		const unsigned char *p = skb_mac_header(skb);
 		unsigned int i;
 
-		nf_log_buf_add(m, "%02x", *p++);
-		for (i = 1; i < dev->hard_header_len; i++)
-			nf_log_buf_add(m, ":%02x", *p++);
+		if (mac_len > dev->hard_header_len)
+			mac_len = dev->hard_header_len;
+
+		if (mac_len) {
+			nf_log_buf_add(m, "%02x", *p++);
+			for (i = 1; i < mac_len; i++)
+				nf_log_buf_add(m, ":%02x", *p++);
+		}
 	}
 	nf_log_buf_add(m, " ");
 }
-- 
2.56.0

