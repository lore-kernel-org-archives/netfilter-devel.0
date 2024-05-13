Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5294386
	for <netfilter-devel@vger.kernel.org>; Mon, 13 May 2024 00:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715559005; cv=none; b=twPaXEIQ9oPmO/1xudud+oy5Jo6AoaUYa1paQ2Mt0+YX8phLr9aNiiu64XxAav1FC87oOHrE2ta3bFq01phgRpL9b8KgPAtWpoISkML24Rti1EfiJDe3nfkm3GCtZr5c0/AFjTK724lSohcamWuzXf+BkY73oMM4OPKktuDoilM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715559005; c=relaxed/simple;
	bh=uVs+OLxkoJMQ+yo531IkNy69Zjuqp8/qQAS7yXZAUeA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=C6sWKePHfTxF/0PIJWQ7TVfap5ZymnfMSEjI0mc2JVLoboam4iU1z4g8+X5MlfQUmnmMuSZXIrpiJBGUBJ/nsf7yskEg8lytehDMvlGYGPKrlN3oSsyiL3Xv2UhO9X55kauUNNmaklXlZlKR8Aok9tE++7jw0GpVGwAzNEigIMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--aojea.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nohDNN/c; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aojea.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nohDNN/c"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-ddaf2f115f2so6102780276.3
        for <netfilter-devel@vger.kernel.org>; Sun, 12 May 2024 17:10:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715559003; x=1716163803; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=sRR8A6vw3MNL4cRtn6UHahv8PFJoyA7NkSXhvo/ge0s=;
        b=nohDNN/ckLXxE/2dZ0RYn3bY1ryZeYQGoHPX32PeQVmBqf/R6G/+oTPVPup08rDZJU
         xhvzKIeyT5wTB/RKtDWMBllG0SvuN/9IH+NpmK4M2B7tgiq0PBpxxJZMMCgPAS9p1RvC
         Mo/8vY2iVOeaWzAFUAtZBAbt9MX0Grizpy7eqnyUJ8rO3ier+AS6Qq1XIb1wN+NVQhUF
         vjKmFXSYR7RzQZox23IngKUwMicfZ9mzL75rxL0pDdKKmqDvdfatvjTbEeZghOnaef6M
         93CATPko7hk/ir80EtfPUVuvXkALCcOquYNjM/bZMp5iLF4LmQM0VxVPcJD9kBHkfS1h
         eVoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715559003; x=1716163803;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sRR8A6vw3MNL4cRtn6UHahv8PFJoyA7NkSXhvo/ge0s=;
        b=DXqr7LjLf2BGuP3a7RdP5EEGgdVYb7jdWn2MZJwEjQISKjntKlv0nRa8m8WfqI+mHG
         aR7wJDM0YRu76mt1k2X0Q5xQhXgVXbkROOPVs+GdhUvIQtdlk/Q8r9fazVJRrx+0X/ZR
         9P7oiJwHFyTzfHDrJ+ehGbGtBu8NHrIb5P1cK1wyJU0hvkOYS5qSWxnazChBy1HWTe/D
         5Ksa3TfgLEvkuHgrKExJWBX+8ObusjDpmxWYQqb0ok+J2c65Gc/v+y7npBk3VZSC7o/3
         Pd6o3cua1yVJJFMDGFgPb1UcNW1PdHHDwTYvkVmrohiY50a+ypTI+xVv2fz9lVb+zuSZ
         Lf3A==
X-Gm-Message-State: AOJu0YyVeWmZDsb8ENk07ER1innlM+3m4pf/te7gO2AEAmUQeYN2DFvR
	vL3CF6HMb0KXTmrmMIsmP7grv7qgL7Zqd6td4JlYCvVT3iBx8OQVTI5/k1Q2i/ZsRqFKXWSVdmq
	64hs0WMiegNHh6RkGCuzhj4bvNOUGT5WFEWgycHQZ1iOcdnL4XOJhmDU6TP9OpCW1UekNZbPGik
	t5s6H92raStI4JdHhMScVSsMc64jGWHDHyvDaVOJ4=
X-Google-Smtp-Source: AGHT+IGueTUZZ1TA651SQgB//wittngvAC6GdvMuxa4GxlkkgOP0gdbOc+D3AZN8SdqMylU4BKiGoqau9w==
X-Received: from aojea.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:b3d])
 (user=aojea job=sendgmr) by 2002:a05:6902:1025:b0:de5:3003:4b83 with SMTP id
 3f1490d57ef6-dee4f4fbce6mr770389276.8.1715559002906; Sun, 12 May 2024
 17:10:02 -0700 (PDT)
Date: Mon, 13 May 2024 00:09:52 +0000
In-Reply-To: <20240513000953.1458015-1-aojea@google.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240513000953.1458015-1-aojea@google.com>
X-Mailer: git-send-email 2.45.0.118.g7fe29c98d7-goog
Message-ID: <20240513000953.1458015-2-aojea@google.com>
Subject: [PATCH v2 1/2] netfilter: nft_queue: compute SCTP checksum
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

 net/netfilter/nfnetlink_queue.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 00f4bd21c59b..accf4942d9ff 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -538,6 +538,14 @@ static int nfqnl_put_bridge(struct nf_queue_entry *entry, struct sk_buff *skb)
 	return -1;
 }
 
+static int nf_queue_checksum_help(struct sk_buff *entskb)
+{
+  if (skb_csum_is_sctp(entskb))
+    return skb_crc32c_csum_help(entskb);
+
+  return skb_checksum_help(entskb);
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

