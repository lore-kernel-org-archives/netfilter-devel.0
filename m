Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023571;
	b=YxLVSiSdY6Bn31lPzHiGnrHJO41f3wj/xwrVYiaEwkb2Gno3buBQoI2DFV7/PX+Sgg9Q
	 InTwRSYch6vh7gSNvYqPoIIxvIWSHdA1eZ+lyBrGDHrK2utYbgYyTUI7ktgetwugUb7Zm
	 YOsKYLgml68gpukDJmeEYKkbOYO8mpAwJFSqAjMuM43EC72oLEPd2Fikz7TjediUphagt
	 FHETxEyxcabToZPbdgoEGUg/iVl9E3HOig60Jt0nmQovJe+o5Bz3NW2NzhyDO44rfuVF1
	 Vd1jUJx+rxZg2fGlyoK+RRO/zlSHeHxq7VbRA8CI1L6xDS9w2h4fD0EXdEJqncfrATw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023571;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=PACIaUk0WrDc9Qq4MXwG6yp11IQWdlRv53EhY2GpdMI=;
	b=hVceB43GHsP7dOAZWl9qBq8T4QC5PuWH7DAhVK+35btBKZ++JRJrb8YXuMFTJfkinHSn
	 tVklfijWdm0/z8WOxzvUKb58DgIyAREQgG5cXokRmSSRipt3SVv/dDzd9XWh/STrHwNH4
	 plowXK8Yzc5fpP9cstcRkh0MIqDi9tQN5jQgqxWN8jb4OF+e5Py5YS+5z/AeaARbnDBMH
	 iuH62Is5AUaa2gLGeH7rJcadmWwhCARoamaAx5OZecYcFMtm5n22H2TK2+s1H21LVnChd
	 9y/jW6IM3XXNHuU+UvcUQ2vdklEKZzsXl2hjwTZduaPn0d6nqsGThta+8upUxW6vkqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7148760A261C
	for <netfilter-devel@vger.kernel.org>; Wed, 18 Nov 2026 17:39:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7148760A261C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id B9F6E60225; Wed, 18 Nov 2026 18:39:27 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH nf-next v3 2/6] netfilter: nf_log_syslog: fix MAC header dump to use real header length
Date: Wed, 18 Nov 2026 18:39:09 +0100
Message-ID: <20261118173913.22592-3-fw@strlen.de>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261118173913.22592-1-fw@strlen.de>
References: <20261118173913.22592-1-fw@strlen.de>
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

