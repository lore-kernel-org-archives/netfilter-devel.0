Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.229.2
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793552798;
	b=ZfLWXq6Sfc1Qga/dzEzWkO3GIL5yepOE5GNogcxDJMnc8rBWSfdNxbMUBHKMXxU0WFMJ
	 TUc1lG4k9IqXZdhdg78ktV/fXOlozzLqnWcScl5FdwTY2Jp/zzRP14zhoVHH36uIVgpWO
	 mB4kfNUSqt+Rvkbx4akj1brBpgJqfGB2jhYeYpJqCF+XueRSyGQeShP87kaRyllvQsvpq
	 TxQhfBGnfzGf3LjR3UtMrB+w1FckPFon6Eqw+YoWX6l7WhnJIfld4uAr/R6JrEYZk7ju6
	 IvK68R5r/W3gTB2+Unvii1JnuS0KxZD2wqv4jKaG6m4aA9aOn/tXX0Otrhhm0YuUU5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793552798;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aw39Qev1JSGYdGzVPWR/rCHqkJas2jqRHE7hOubbX28=;
	b=kRFvEK2d5w4GBwOz/gAYgiWdvlfYE9v8EOyM7MemMBNMq3tUgfSxEFqXGgQkNWF3J/y6
	 A7lzJXRKrbGf0zGmQZE/mA31HZHZiWLkOeTWlg5YORsGTiuM/WhmtiJlojeIknG2j0m6D
	 e4ulf2xVF6ZrNdpfGirXRs9+ARXOtp5QvQq6LuODloRZdfyVfJ4rf2AF0sggp5HF8ABCb
	 te1ujmAEwW/W71wOO3TvbbLl2fyGokxHLMwA/Qpez+u5+jauJFEOa3fDYg7mHSmA2Tk98
	 e5OV1yj6gZi5zS3sCFkSS2oO79tUTV8RRKYJIPvwCrA8K3Cs4nKq+CWEDgbWtHGEuMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ikotaslabs.com;
	spf=pass smtp.mailfrom=ikotaslabs.com;
	dkim=pass header.d=ikotaslabs.com header.i=@ikotaslabs.com header.a=rsa-sha256 header.s=google header.b="fNI/QkZN";
	arc=none smtp.remote-ip=74.125.229.2
Received: from mail-dy2-f2.google.com (mail-dy2-f2.google.com [74.125.229.2])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D91B8606A325
	for <netfilter-devel@vger.kernel.org>; Sun,  1 Nov 2026 17:06:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D91B8606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ikotaslabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ikotaslabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ikotaslabs.com header.i=@ikotaslabs.com header.a=rsa-sha256 header.s=google header.b=fNI/QkZN
Received: by mail-dy2-f2.google.com with SMTP id 5a478bee46e88-327b1d5824fso2276195eec.1
        for <netfilter-devel@vger.kernel.org>; Sun, 01 Nov 2026 09:06:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ikotaslabs.com; s=google; t=1793552797; x=1794157597; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aw39Qev1JSGYdGzVPWR/rCHqkJas2jqRHE7hOubbX28=;
        b=fNI/QkZN74Xkc5wdAuCJsKzax9U6M5pX64S35hE8/de2Ts2gsv4GQv18s9qszbQX+1
         NUTpG8veJFNxhEMyWRt/RQ11dGCkBRMkQDllDK5KsjLFOJ26ye/21KeDfGZgP69yZAKC
         D9jWiu/aL+owAZAkMG5w95ZDtBWp0tihZb1xaE/uaWZc8TwlxPbrDH5jx/UuEApO83d9
         eiuy4ER+b/AzZWb/RwhPNf1ggP6bXJ+2wnlyF9a/WuoFkRL8Je9vhpDdu/9w5ukvYOgN
         qAvv7St3AFf7jfqovHFM9fHrUtYQtL/eOwiiYbo7Mpl3zanoROy4TMNd5sA+JSYxKfpl
         ACEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793552797; x=1794157597;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=aw39Qev1JSGYdGzVPWR/rCHqkJas2jqRHE7hOubbX28=;
        b=D6uFTXcMhiROiWmWh0W9G/LqyMWdqoOxWrEvCMx3AJcbA4ip32O3ucQ54Ej6g+02JQ
         9rhoG1vUK97vjfGVKNwg4iV60bJ6zSPH3aTXZznrpfpTOCLTAag74fNVN0b1U0yZ4+DK
         54XWK6EpIQF6RYlCMpa+ZzYVXQ5FRaaB86c6N2jWf9IO108OswPrXKs4SaQ9kooRYqg3
         bxTiUCHOmWNDAex9wQV3QmEQp+IRFVPAcy337ZyIgTYa29FJPun6PtA0bdOa1j7LKP9D
         smIDgMoG0LLhmQOT5/m4ooWkndh9nAFxuiUPXeIQ6Xbkqgv6dylXocdUzvQeO6TIf/zm
         5dyg==
X-Forwarded-Encrypted: i=1; AKwUvBwfLsp2XNIq6Wc+Crz71vl+UxWACWuCmNrs2D0acpVPyICDPWcCqco51+I1aHTVKmgyNd6W25+PwRJqhTbxyb4=@vger.kernel.org
X-Gm-Message-State: APuU4Z95S8Z/VOfULl0457u2Yk67UiJVDE/U1gVfSrU9q9ea7tux87lr
	bT52pJbyD0iavLR61f15qj8uLLoH5v55KZhKM/hbdtR5FkfO72SZ2trvb1T37BSEB98F
X-Gm-Gg: AYBFou2llhj08dSr2ZZ8F6HIDDv4HOlnedCMGCrCJlHcRXn4m4IFzDnc4qSLpvAP65r
	KyBPMyQz5QArnOWbBnVCLPsiHYtrIRl597VYCvOb5/e+BMuwWhEAM+XShs+wCrlbvxrnZYZhKTF
	78C7OWRbZiLwv60f7baoHVlKqYQ6U3YGfSvIshWpEnMx+M19X9mPXenkkpTIyrwhVbRY90W0VDy
	hEZSyd8tQX4Ab7kRHxfqDE5f1dw+8UJsL5EGKxBSHnbzgCwohTiQvSap0qb34klHT6QN3ToLcID
	RJ0S5ynNu3M9qLM/WCWXzyiOylHtS9ZVGwXIF7PshQ/0vsg3Ize1OV73Eady7glN+UyL/H62I5g
	RfPul31gKT+U23CA86unqJOs/Z5MX2SW3Pba0Uk1YfRG98Z2AmtmcPuiE3RryPJZCt8MO4eoW35
	oegIO8yirx7aU6roLQ12eTvQn19OzXAj//Ti0SO1tKoXgyJVGFzDv6Ln8VKnpc+btYbXjGrX+QK
	nnczeRXwZaKR+WVfP9g6cdfaupvPHuf7yX1ZarGYZAB5w2PCeWEoYIss900iyN6UolgxM/Fm1Ja
	rscSmnyBb8sHsotLPBP9sCqnuAgeuHXzbjfLoefkxBhM3KnGUGgXun3FaMMRvkhIUOHS5fhuARG
	C9/5wa4N2h+JJFEGoseG82Cb6GW1baT3A/DZ60CH6zw87j2b3ut87F6iI9b2jRQ==
X-Received: by 2002:a05:7300:a9f:b0:369:fb01:2eb7 with SMTP id 5a478bee46e88-36a4235f45emr11482457eec.13.1793552796603;
        Sun, 01 Nov 2026 09:06:36 -0800 (PST)
Received: from gx81.tail3ecf1.ts.net ([240b:11:99c0:1c00:9e6b:ff:fe84:e26e])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a42902649sm33105165eec.11.2026.11.01.09.06.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 09:06:36 -0800 (PST)
From: Ryosuke Iwahashi <ryosuke@ikotaslabs.com>
To: pablo@netfilter.org,
	fw@strlen.de
Cc: phil@nwl.cc,
	security@kernel.org,
	gregkh@linuxfoundation.org,
	yudai@ikotaslabs.com,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	stable@vger.kernel.org
Subject: [PATCH v2 nf] netfilter: nf_conntrack_reasm: restore IPv6 nhoff after reassembly
Date: Mon,  2 Nov 2026 02:06:33 +0900
Message-ID: <20261101170633.625161-1-ryosuke@ikotaslabs.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <2026110155-twisting-autism-009a@gregkh>
References: <2026110155-twisting-autism-009a@gregkh>
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

nf_ct_frag6_reasm() removes the fragment header and resets the
transport header, but unlike ip6_frag_reasm() it leaves
IP6CB(skb)->nhoff set to its pre-reassembly value.

Subsequent IPv6 local delivery consumes this stale next-header offset
alongside the updated transport header. As a result, the two cursors
can point to different protocol boundaries after conntrack
defragmentation, causing later processing stages to interpret a
different transport protocol than the one evaluated by conntrack and
nftables.

Restore IP6CB(skb)->nhoff from the saved pre-fragment next-header
offset after reassembly, matching ip6_frag_reasm().

Fixes: 9fb9cbb1082d ("[NETFILTER]: Add nf_conntrack subsystem.")
Cc: stable@vger.kernel.org
Signed-off-by: Ryosuke Iwahashi <ryosuke@ikotaslabs.com>
---
v2:
- resend with git send-email formatting
- use full real name in the author and sign-off
- no code change
---
 net/ipv6/netfilter/nf_conntrack_reasm.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index be72c4346..634122055 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -321,6 +321,7 @@ static int nf_ct_frag6_reasm(struct frag_queue *fq, struct sk_buff *skb,
 			     int *refs)
 {
 	void *reasm_data;
+	unsigned int nhoff;
 	int payload_len;
 	u8 ecn;
 
@@ -345,7 +346,8 @@ static int nf_ct_frag6_reasm(struct frag_queue *fq, struct sk_buff *skb,
 
 	/* We have to remove fragment header from datagram and to relocate
 	 * header in order to calculate ICV correctly. */
-	skb_network_header(skb)[fq->nhoffset] = skb_transport_header(skb)[0];
+	nhoff = fq->nhoffset;
+	skb_network_header(skb)[nhoff] = skb_transport_header(skb)[0];
 	memmove(skb->head + sizeof(struct frag_hdr), skb->head,
 		(skb->data - skb->head) - sizeof(struct frag_hdr));
 	if (skb_mac_header_was_set(skb))
@@ -360,6 +362,7 @@ static int nf_ct_frag6_reasm(struct frag_queue *fq, struct sk_buff *skb,
 	skb->dev = dev;
 	ipv6_hdr(skb)->payload_len = htons(payload_len);
 	ipv6_change_dsfield(ipv6_hdr(skb), 0xff, ecn);
+	IP6CB(skb)->nhoff = nhoff;
 	IP6CB(skb)->frag_max_size = sizeof(struct ipv6hdr) + fq->q.max_size;
 	IP6CB(skb)->flags |= IP6SKB_FRAGMENTED;
 
-- 
2.56.0

