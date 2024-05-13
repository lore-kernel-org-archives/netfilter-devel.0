Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 751F484A30
	for <netfilter-devel@vger.kernel.org>; Mon, 13 May 2024 22:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715637643; cv=none; b=IsJw7SZzLE6bof/nBPeH7M6TD+PMfGYT+aWtiaRyQh75lb4TYMxplNgn8xIuHO8UXxDArLiS1ld1K16qZgldLfuUizA19aZ2pdgkhZ4BXmKX1LYFlpUDj13MPm2Wa1UdrIgVKdqFDgpVFCIXFsG0dmsJ0jbi6eB7Ck8nYC79wD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715637643; c=relaxed/simple;
	bh=LIrWmCdeD1ztOWNBI7+NUXxYs/0uH1ZHZGCeC3zvnAU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=l1e3Oq1iqlw36X2ZP/KHJUtvUF2jy4ijK6FVYszRXm+xli0vnuuw34a2gMapNZFj3lPbK7GXmDZV7svJLFnxbwDf1Q9Xga2c9mUKj11JPIMYmCkcVrE5ZiPF4t1K9xdCsq4bjDCuKfTcKBqqO9nTHr7DdhJ/Q2p3C58CbRP1FiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--aojea.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4kZk8bk5; arc=none smtp.client-ip=209.85.208.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aojea.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4kZk8bk5"
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-56c1ac93679so207084a12.2
        for <netfilter-devel@vger.kernel.org>; Mon, 13 May 2024 15:00:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715637640; x=1716242440; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yDcp++hVHXLnnv/a//XLn51NEsO9sflqY1HSW045cEs=;
        b=4kZk8bk5cS1kAagfqJidmDddnNdvkwQzmEcFgRNGRZ7aZ5X8oiu9lPHmYrIlX1FIKr
         /kPIQfONzPp/bDOFv53Ub4yHs03ml2Eu7QQSt46Btt8OwPiUkwjpYsaV18rwgaa8RAeO
         3mexKwBI/uaPQ2fnjo6CMMqGMLYBbUc8AVUtLT4STE7FWm7TkHfqrxBbmvBXlkNDpPd/
         GmQFgnKnUe1gJMXNJvp2gmahXDGpjBM6ympI4/laWI+PawRTdwPNtlMQc7Hzh1CF+wQi
         RHJgfk3BpoBlUpAnSLqbkXVRKRjrXGSLZusW2Y31H2IS4Y465uK1yChkUsyL1cIQ8Vh9
         2hiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715637640; x=1716242440;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yDcp++hVHXLnnv/a//XLn51NEsO9sflqY1HSW045cEs=;
        b=YD8CU5vz6VGsmkHUf8ixPucQEM9qJmJJhGCyltPCOO662VAPt85xDnBnk3V6QklWF6
         fJMwKAeP80x5CIelyxKNR0Hb11hhRmttKQ3pJjwBpTHf9uLw7y/IO8pO0NpTVgzs2bDu
         LYof2a5vRVHbaKd+xc6k48zEkGNwZ+2Dm9pqX6VGFPH60Cawq4A75+c5pHkNkVZeednM
         RN7TaY2ueykLw8E0Gs6KAjzUKXng37nhaarngaTol/gtc0lbdbWMRomdsPC2BvJ7pMtt
         rnjVwWNxlVKUfayek9PdBd8g1LdBidzcxHxh0wBvZZ+VqLEJEuKX7w+yFjrZSImccscN
         itow==
X-Gm-Message-State: AOJu0YzHC2jM0q/Fj4Lt6QD95Zt2POySm3TnJbwwRBes4zmGywdGdFvO
	YyaUCMUc1u0XjFuG3kPy4sXtp5OfHchQ7W1xzWU+NLFeEX92UUtyJ9T+E3t+4neWwqoPkNxyj8F
	pspVbvjHd6IlcG8TmouH1Y6Nw840QtWEGQQPw5hljm+FmPKcArXkF7MRZi/wq+zS4Lzflz/CMLM
	us2/Gi13cS50C5e1syDJANmFh+Apz/a9UZB4Sq7bA=
X-Google-Smtp-Source: AGHT+IFVq3d9ex5Q/KjzQTk2mNRwdXYwhzlOe1jRUXzkPsXtq/mn1Zy+sqQANFSYC2zavM0GNdAclQOnXg==
X-Received: from aojea.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:b3d])
 (user=aojea job=sendgmr) by 2002:a05:6402:3485:b0:572:469b:6a86 with SMTP id
 4fb4d7f45d1cf-5734d701e58mr14953a12.8.1715637639527; Mon, 13 May 2024
 15:00:39 -0700 (PDT)
Date: Mon, 13 May 2024 22:00:32 +0000
In-Reply-To: <20240513220033.2874981-1-aojea@google.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240513220033.2874981-1-aojea@google.com>
X-Mailer: git-send-email 2.45.0.118.g7fe29c98d7-goog
Message-ID: <20240513220033.2874981-2-aojea@google.com>
Subject: [PATCH v3 1/2] netfilter: nft_queue: compute SCTP checksum
From: Antonio Ojea <aojea@google.com>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org, fw@strlen.de, Antonio Ojea <aojea@google.com>
Content-Type: text/plain; charset="UTF-8"

when packet is enqueued with nfqueue and GSO is enabled, checksum
calculation has to take into account the protocol, as SCTP uses a
32 bits CRC checksum.

Signed-off-by: Antonio Ojea <aojea@google.com>
---
V1 -> V2: add a helper function to process the checksum
V2 -> V3: use tabs instead of whitespaces

 net/netfilter/nfnetlink_queue.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 00f4bd21c59b..13802907ddb8 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -538,6 +538,14 @@ static int nfqnl_put_bridge(struct nf_queue_entry *entry, struct sk_buff *skb)
 	return -1;
 }
 
+static int nf_queue_checksum_help(struct sk_buff *entskb)
+{
+	if (skb_csum_is_sctp(entskb))
+		return skb_crc32c_csum_help(entskb);
+
+	return skb_checksum_help(entskb);
+}
+
 static struct sk_buff *
 nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 			   struct nf_queue_entry *entry,
@@ -600,7 +608,7 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 	case NFQNL_COPY_PACKET:
 		if (!(queue->flags & NFQA_CFG_F_GSO) &&
 		    entskb->ip_summed == CHECKSUM_PARTIAL &&
-		    skb_checksum_help(entskb))
+		    nf_queue_checksum_help(entskb))
 			return NULL;
 
 		data_len = READ_ONCE(queue->copy_range);
-- 
2.45.0.118.g7fe29c98d7-goog

