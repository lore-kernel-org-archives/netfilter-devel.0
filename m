Received: from mail-dy1-f178.google.com (mail-dy1-f178.google.com [74.125.82.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFDFE3E3C44
	for <netfilter-devel@vger.kernel.org>; Sat, 16 May 2026 15:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778945011; cv=none; b=lR2EJUclhv/1Q/ERpjtDQ7662UwvbPw/t/jiEOVOZD68EqZY50c+61Du32ef+ve2tCpMdedKyOVkWPSEjgnCNSdtL/ocgifyKD2yyEC545w/ZEz9ALb0NcDqc9stlHj4WKC+EXjEDZ83fZF6aIrlxO2IxMuFyyLzZYxMHRqZBe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778945011; c=relaxed/simple;
	bh=tl+wcq6ObIaSLoheOE6JBGo3uGujGoAPvnIeqn/mRm8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Z4hnAVeQVAjDJ51Ee2SeovPR6pbcAiqexFbNgsFK+E3eyPDXLXjIdw3BEEykxWZkiSyGBZ8bb3kT6zCi0WhXvlWPZnaC9zagXJWWphkQ0vfPiPktd5H9Je0fhXaVirwyTGoBs8IPAVYXmlfVYEOVlESsPggmTg+qTfwpq1ofc0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=l1B9jf9z; arc=none smtp.client-ip=74.125.82.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l1B9jf9z"
Received: by mail-dy1-f178.google.com with SMTP id 5a478bee46e88-2f7ca62a3c4so721443eec.0
        for <netfilter-devel@vger.kernel.org>; Sat, 16 May 2026 08:23:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778945009; x=1779549809; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gPSGOLDEj02HfkVCX3UX3Jxtg2REZTH7Fxg7/PpQ1zY=;
        b=l1B9jf9z+htu3jbtWvt2rXGtayeN/v8/awjBeMGZCsnZncWq0DivjjzwsaDycVRUUJ
         ILabYhkbC4Wb8bB04ZIIuA/5yjGEHMwp2dJlHvF5++DELL+k+Tl4CJK7ArVZvP3TSp4U
         M02tcJ5oNEQusKeVfQjpZ2WH57X/SdfYTe+cyAm03I7R+HCknEeBR7PJ3/OUjbPk+gdV
         1mQR2eBYBF+9NM84rq02M2w0BogTBUEM80Szp0h/rE75CNs09r+HMgRMs5BPiMni0XLv
         PGEEcabLMECDw7LZLOLNbvCTEIpbTs9rPl9GHW9WE0swqoQFJ4n1LbhiCG4DK12LAggq
         xdbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778945009; x=1779549809;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gPSGOLDEj02HfkVCX3UX3Jxtg2REZTH7Fxg7/PpQ1zY=;
        b=ZglP5uFhAxHRm3pdmAnKzWlpdjNihk37Kg9MxK4O0YM7EzE/kUCvzb3s+eemUAWFqe
         vBj/OFsjMLNU43pwx9gftZ+GVNAfOygpv07WNmr20rmXSsydyTFq/EoJt2mWOsSMgI4j
         hI0AHgj1xZvuh/x0JouOh4rPDUSH2Rnys+T+Wk5QjFcBEqDqw39L79RRwU/3S20rsvwD
         vXflzuJPw8QoUAiGAwuFK44VelrrjIsZj/70isKcyN9+3d0Lklj49QyI7671oZLpXiQS
         T6FB3fYS6A9jwUt8GftwDZDaV85ITqO2y5M8wdX9/s2HDqDB2iUHxTN/rE1XtH+lNrZg
         CeyQ==
X-Gm-Message-State: AOJu0YwC0aXzHrLOg077qL7Evj/MZlFMj3VlNmdGMRO9z+0gjqMkJ3a9
	pLHB3g92dWTDH6gEEczK9aheW+2RSfppyg0UlFF+4e73iK73lQ5VWODMoWpAFD4h
X-Gm-Gg: Acq92OFOq2R6zt365M920TaVAgRVs/ih8+UdLD9MqFh4NgnPQwZsHz/KduTU9dWwA/i
	ewM+bqF+1/eJW8tXx7+640iZbOtsxnFWuoSBGp38PMcXVCfVDlJedE+L8SyL15J/xUbU8CsDCvQ
	5uFEg7KxCS14sijMTCMzN4cGiqA0UT0Ag4RQXIWJjZaDNvZYUIToMTNgiKC03JFWDHELyB91F4Y
	HJBeI9KZDWUdlMUz2ZwhA0KMJ7pCKzRbp+V+3bzehUbgFmbSiRbMX0SVIxLYb9KZ/FkuF+Zvqc3
	98mDLOxARWzivV/6gEpH0nQ2S8opULQ6ndCFRfQwKv/mkMYhLfqz4d19XGjNQfRuikxQCn0Awvi
	XoxWU2isUl3JDFZp3riy0MFcpYefaBn95M1E+U0HTJYfxrC9ck+7kfVVeIpy3k65tRCFZov9za3
	eRgkEdEtbnBzSMUrlbdyh7HpEiCdk2hG6blYkJXySN6wtG
X-Received: by 2002:a05:7300:7241:b0:2d9:a799:3c4f with SMTP id 5a478bee46e88-303986a68d3mr4281033eec.24.1778945008798;
        Sat, 16 May 2026 08:23:28 -0700 (PDT)
Received: from localhost.localdomain ([148.135.103.3])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-134cc33a618sm14473250c88.12.2026.05.16.08.23.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 May 2026 08:23:28 -0700 (PDT)
From: Qi Tang <tpluszz77@gmail.com>
To: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc
Cc: netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org,
	coreteam@netfilter.org,
	davem@davemloft.net,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	horms@kernel.org,
	herbert@gondor.apana.org.au,
	michael.bommarito@gmail.com,
	lyutoon@gmail.com,
	Qi Tang <tpluszz77@gmail.com>
Subject: [PATCH nf] netfilter: disable payload mangling in userns
Date: Sat, 16 May 2026 23:23:21 +0800
Message-ID: <20260516152321.2676564-1-tpluszz77@gmail.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

Several parts of network stack rely on iph->ihl validation
done by network stack before PRE_ROUTING.

Disable this feature for user namespaces for now.

This could be relaxed later.  Example:
 - allow userns only for ingress hook.
 - allow userns write if base is transport header
 - allow userns write if base is linklayer and offset
   below network header offset
 - allow userns write for ipv4 if offset+len match saddr/daddr
 - allow userns write for ipv6 if offset+len match saddr/daddr
 ... etc.

tcp option handling might be safe even for LOCAL_IN, as LOCAL_IN gets
invoked before tcp stack, but this turns it off too.
optstrip remains enabled, see no problem with that one.

I don't think these are the only means to alter packets, but these
appear to be relatively prominent.

Another option would be to restrict this generally, however, this
is harder to do for nfqueue.  For nftables we know where the
modification happens and can even reject a subset from netlink path
directly.  But for nfqueue, we'd need to 'revalidate' at least
ip/ipv6 header for ipv4/ipv6 families.  Bridge path might be okay with
arbitray header modifications.

Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Michael Bommarito <michael.bommarito@gmail.com>
Reported-by: Qi Tang <tpluszz77@gmail.com>
Reported-by: Tong Liu <lyutoon@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Tested-by: Qi Tang <tpluszz77@gmail.com>
Link: https://lore.kernel.org/netfilter-devel/20260515100411.3141-1-fw@strlen.de/
Signed-off-by: Qi Tang <tpluszz77@gmail.com>
---
Tested on net.git tip: unprivileged userns nft @nh,*,* set
rules hit -EPERM at rule install.

 net/netfilter/nfnetlink_queue.c | 3 +++
 net/netfilter/nft_exthdr.c      | 3 +++
 net/netfilter/nft_payload.c     | 3 +++
 3 files changed, 9 insertions(+)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 58304fd1f70ff..e1e1d11fdf04f 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -1141,6 +1141,9 @@ nfqnl_mangle(void *data, unsigned int data_len, struct nf_queue_entry *e, int di
 {
 	struct sk_buff *nskb;
 
+	if (e->state.net->user_ns != &init_user_ns)
+		return -EPERM;
+
 	if (diff < 0) {
 		unsigned int min_len = skb_transport_offset(e->skb);
 
diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
index e6a07c0df2079..577a15383e986 100644
--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -551,6 +551,9 @@ static int nft_exthdr_tcp_set_init(const struct nft_ctx *ctx,
 	u32 offset, len, flags = 0, op = NFT_EXTHDR_OP_IPV6;
 	int err;
 
+	if (ctx->net->user_ns != &init_user_ns)
+		return -EPERM;
+
 	if (!tb[NFTA_EXTHDR_SREG] ||
 	    !tb[NFTA_EXTHDR_TYPE] ||
 	    !tb[NFTA_EXTHDR_OFFSET] ||
diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index 01e13e5255a94..484a5490832e4 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -917,6 +917,9 @@ static int nft_payload_set_init(const struct nft_ctx *ctx,
 	struct nft_payload_set *priv = nft_expr_priv(expr);
 	int err;
 
+	if (ctx->net->user_ns != &init_user_ns)
+		return -EPERM;
+
 	priv->base        = ntohl(nla_get_be32(tb[NFTA_PAYLOAD_BASE]));
 	priv->len         = ntohl(nla_get_be32(tb[NFTA_PAYLOAD_LEN]));
 
-- 
2.47.3

