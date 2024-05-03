Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B9EF152521
	for <netfilter-devel@vger.kernel.org>; Fri,  3 May 2024 11:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714736144; cv=none; b=LXL7yhFaFR2ssE2wyMPTJAuNPK3NNUMId3eypXg+d5a8OCG6F+K14K3smtoh0SKildrZBoezjijMwjqenB9Qze/EilExXOO/6teFX2NNcwaclggOcKHnN3ic/u9cXwgI0pS0JxlEP3o7jQyMyBVLjJ3UwJpHDC746sZ5Zk9tpA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714736144; c=relaxed/simple;
	bh=wGnGYMYG4AAYrXJouZo0VQ/bnUs4zifbx+n3lsGCTYc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=r4+OR0T3IF8QyuZP+WxfFZA1u2slp5w/RC6hAsFsmy5wTsWzqsugBPWqrnCDBl9vINt4F+1FSqzQGuJzLM49nKWMhBiKD5SNOEZsz3hDeykWFbsMD+GkJDm8VYt92+x+6Tu7v05gVWcBnppfO6L+m9lUBg+sspft81N5K4XwnvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--aojea.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=C/IpGnH6; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aojea.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="C/IpGnH6"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6202fd268c1so543057b3.2
        for <netfilter-devel@vger.kernel.org>; Fri, 03 May 2024 04:35:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714736142; x=1715340942; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ADateZFJL94d9s+YLyq8KiE9M7tpLEvPfhk48z3hB84=;
        b=C/IpGnH6sNf/bAONbCG5yWkTV9e0Zjr0/9I2+nHJndrNOxYSXMroyia6a3xR5qBLhv
         jPyVeumWe2RNfnHpUJVoqqhr9sYfzJxnJYbv2jBs8/sg6PoaBWS6FQMX8kLNQv5sqPkD
         D/Tdhr+R1eez9Nm88K4T1MVCNkEfkr4VLDFqkLt92pHzaQmWvmMQv2hCdyMwH42W5xnA
         lC/ITMcuUA39Ti2dmWvdWI50vIXOE8dj3mQH8MccUJITzJ6WEuAfNfuUf2fmqPOz2Qzs
         B4Ej/G5uooPsyu678a9OvYZAxj79D9EmbkQofnz+M9G3CC18/AYmD1DwqhUrouAJ+41E
         HUBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714736142; x=1715340942;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ADateZFJL94d9s+YLyq8KiE9M7tpLEvPfhk48z3hB84=;
        b=HA12Ib8Nz198sYI1LrAtkLmPf2X/lJAPQKc8Hdpbooq/lAKByUtrOMXqcSoYUkqePu
         cVK8GxmeG+uMXXXHhgF5wsKLJ40AT+LKkeGGy3JgUow+ASLtCXAHZvmgpPYYpt3a80v1
         EA5ZNFtVk43qKVLiy5CKvx0F8i6m6hClOrKw79kclsWZA/wpWmkAsWbjCb7+IG43zl34
         x595zs0oW0hiB72AXeKFy9hIh0Arop8O5x3dOEZDxYdiPXEreg32AlQzhyYw0UtIhkIQ
         5xJVhxCnTA9Dl+vtTJP/FLvJXYLi2putDQHmCDe3CwVgDbVo33sWNPH4KaWQ6yGoKviM
         gwAA==
X-Gm-Message-State: AOJu0YzbwMP/F5byYHZbQKUROUro0lEuQ5fTwbZlq8lLzihHexjOv0+g
	oi2uveTQgT9yB+w68sXj9O6o5ThDjzwKgD9y/HFXhOa2eomMW7NlH/ueKxHVuX71iZLJwNf2I0a
	vAB1PI67vIqvPPGB1FllZIXWK5B3V6xtwVjqeL28QFakpID2bouPLPKr2D3ImMLnWmugJ1/UcX/
	KFFK8zypX+mzKq9c5Xhvf29b/Q7NGD8ymQhVEeusk=
X-Google-Smtp-Source: AGHT+IG5UXZB0iiQfQO2u5QXbOVgRHNfAGEpktXjJb22PDo4EAXxEzDtTQ6CXmUmORvURi6QrOsnOt7idQ==
X-Received: from aojea.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:b3d])
 (user=aojea job=sendgmr) by 2002:a05:6902:1004:b0:de4:7be7:1c2d with SMTP id
 w4-20020a056902100400b00de47be71c2dmr809160ybt.11.1714736142068; Fri, 03 May
 2024 04:35:42 -0700 (PDT)
Date: Fri,  3 May 2024 11:34:54 +0000
In-Reply-To: <20240503113456.864063-1-aojea@google.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240503113456.864063-1-aojea@google.com>
X-Mailer: git-send-email 2.45.0.rc1.225.g2a3ae87e7f-goog
Message-ID: <20240503113456.864063-2-aojea@google.com>
Subject: [PATCH net-next 1/2] netfilter: nft_queue: compute SCTP checksum
From: Antonio Ojea <aojea@google.com>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de, pablo@netfilter.org, willemb@google.com, edumazet@google.com, 
	Antonio Ojea <aojea@google.com>
Content-Type: text/plain; charset="UTF-8"

when the packet is processed with GSO and is SCTP it has to take into
account the SCTP checksum.

Signed-off-by: Antonio Ojea <aojea@google.com>
---
 net/netfilter/nfnetlink_queue.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 00f4bd21c59b..428014aea396 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -600,6 +600,7 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 	case NFQNL_COPY_PACKET:
 		if (!(queue->flags & NFQA_CFG_F_GSO) &&
 		    entskb->ip_summed == CHECKSUM_PARTIAL &&
+		    (skb_csum_is_sctp(entskb) && skb_crc32c_csum_help(entskb)) &&
 		    skb_checksum_help(entskb))
 			return NULL;
 
-- 
2.45.0.rc1.225.g2a3ae87e7f-goog

