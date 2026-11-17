Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794938338;
	b=hIeB5yJwca25EN7WtZdcN9yPrCiYIDRQSfCIPq3fJeZQAQJrJ3N8yFABnYHFXsQAiPNh
	 sSxZ+lKSUvxYxNiPzQMhV2fdzABuysI5pxcp36BIpekmbRVE797b1H/vaL0m66BHflMfG
	 Y/cNNuk8vYZzyEFIkqdKim+S8mAVYmtlpkez5MxNzzTgfiI91CLfsOURWsyfKAlGO6SuS
	 zsdtvNxGJrWIOlgnwfOZHwVI81KnXnh1wqfi1vNaiCd+ft4SC7S4HShmmug9fLcfSvPJJ
	 GLu+pEjmtvUzVcvJ/RWALhDj2AmmKD9IUPAcb9DnQbwsqecUMy2xflenKFvfJbIrVaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794938338;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=l1QoGpfYuoWprgioM1kY9kP75Z7uroDjcsK6QHLPstA=;
	b=Qifcdrf5wQTB2QXOshcb01lb3Fsa3b/hpfLN2Kc8KcP0KARxLvLn1PDTG8x34svN+ifP
	 dYNcZ+8/ylyl6hOP0oMfN6te+bP0gxZxeNtSYDPgdxJhcS0bCaMGOibp7I1pxV+08OajA
	 4J/b/gS7oDnvsrwowLaIevwhCVfdYdg486vl2XQL8lUS+IeA3Dw7xAaRhW5nK1scKwqMW
	 cCQ8HdkkGboAKn5ufvk2nFQQA8pJJdzYFiycTk+kdZHlvbHZ1eKziZFwJuewxbQgLk0FR
	 NjmjzSHBGIfXtl+e1tFHfOm0tpBbeBb2LTm2hIdv+SRBKmHy/b44ywvtdN1NGzwZ9kQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=PWEQYxW1;
	arc=none smtp.remote-ip=209.85.208.51
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 284D9606A32C
	for <netfilter-devel@vger.kernel.org>; Tue, 17 Nov 2026 17:58:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 284D9606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=PWEQYxW1
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6b785ca42ebso174422a12.2
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Nov 2026 09:58:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794938336; x=1795543136; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=l1QoGpfYuoWprgioM1kY9kP75Z7uroDjcsK6QHLPstA=;
        b=PWEQYxW16O38mkSaJMaahtPF/+Eky80WqiTdblJMO07adbco6MQoJlu0MMi7/qZ55D
         V31HeZVEuUq3Kz0Avmdi3/n7wink2ix3uZMdkZFxSw9dj/W7vYKmdEZwda86Jlbv8CZ5
         s6/UCI082JnHRubqyS29HPiMACOz8MJVFVOfK/V52Yky8oB34z/t3PqtIWuwrVofTMyF
         LzFnK3RNDSWZIjvC/yBcO4YUcXxBmdbU8A0nO83uEUtyD9GeLw5XcdWqrbu+VDQp/4Nk
         fyUSG1nCU2Yq2kAxudn1FTzTjKIdoQ/vahB2Yjyuw/es3yIgYbtRLgdwBm2jTrRX9JWs
         /iPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794938336; x=1795543136;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=l1QoGpfYuoWprgioM1kY9kP75Z7uroDjcsK6QHLPstA=;
        b=zcMwmpt7FGF4KKSyJDM64UU3W4DC1B9SgZnu+urXHmP1bptnAtC24mDhnWtsDQemov
         R6JaMMuYHAm8dYa+Q6r1M5e3hJ1RX1yE+et6OB8uY8kunGL1XdUxiJBulFnCkK/WIpuK
         1nxToDI6Of5ultHbRuA0Zd60wGAN1JJT4TOmk3qg2byayAmOBurtfO7wuWl7aEwyAdQG
         xcNntL14jeqpEjPSwQcPAfBIDHYqJ9t0a6rRbtgJ7c1vrP95dLocDPpg5RXDiLJvjDqL
         LY47aUvTvG+3jgc8SKeXfommaN1gYvWcyopn3DQbBzyfAE9EtgBSVSzAtfWfvA2Kq5Tw
         +uBw==
X-Forwarded-Encrypted: i=1; AL+hErETM3jyruTfm8UwdBZaHuRGn/VsqRQ9GbwLa0X9CsFpQNpmUBzazOeck1AV1ZmpI5u8yUghZl+epv4FaxlfFeU=@vger.kernel.org
X-Gm-Message-State: APuU4Z9/Gh0veiqLzczyuzTWfYxGh3u391Etl9SU00nSMZ8zEihSfVx+
	d8DLqLBYJNYUl1MIXJ/t1mRfCSq2haTqAZzU5XIF9FHo+oEm1Qcqi8oN
X-Gm-Gg: AYBFou080I6nexmv1yKtf/K8WS2+zSpsKSn2YyjLLUWZ8OqjsdTJQY/pW/ZHxmuqzF8
	timWuCexubqtE5o+PENA9irD8gNtWyx5ANTAD/8fNX9U9FBEaNA2D3EZpP6uSBNjX6/1pm+MLAw
	vicy/j8GSKw6BmuLfZsRn6+IT7UHOv1cY2AaqHYh8vjKBTBLDHOhhNe2pc1gc2T3ylz1mkG0HTd
	8gbXDXe0RfnoH7Jtn1UqIBymulEZAQ5eVqUVjiUh8XvuRIdHHC5J+0erO5wlWDtJlb9TJQz5kFN
	xtxB+KPFJ1FIQ5t0nKuccM7lNFcOkitTpo8v/Ynmwd+ZqdQ+zoFaWL+b2u8rwHcq9Z2TakdWbK3
	2gt6VOADF4tvbTt0oXZZbjNlDQ8QT3IlW9pJEsW+POoccsk3ofi8NyL566AsmIGCAfDIEwP0qqX
	xsN0rOa/0k1oObZO1Ld3iSl46DL+1oLo4+pK8dzO+lDEAMr4P1+9SYgz9pmBuWZ069gt7bq/VZA
	4fXFgS/1PHdcomPBULD4/+oJf07ppNDhRiRX85kEZyq71h3fOmQUcD0DSAKZ8Ho78+nuE7mIfSN
	y3Tqlk2hWc+LBseFamNnydMk6W9LH+AVSpQxdPHY
X-Received: by 2002:a05:6402:450e:b0:6b4:73e6:dc9d with SMTP id 4fb4d7f45d1cf-6b887f1fff8mr18164a12.41.1794938336387;
        Tue, 17 Nov 2026 09:58:56 -0800 (PST)
Received: from theodors-laptop.. ([5.255.118.7])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b886a82951sm78666a12.9.2026.11.17.09.58.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 09:58:56 -0800 (PST)
From: Theodor Arsenij Larionov Trichkine <theodorlarionov@gmail.com>
To: "David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: Simon Horman <horms@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	Theodor Arsenij Larionov Trichkine <theodorlarionov@gmail.com>
Subject: [PATCH net v2 1/2] netfilter: nfnetlink_queue: only adjust bridged skbs that have a mac header
Date: Tue, 17 Nov 2026 20:58:34 +0300
Message-Id: <20261117175835.745796-2-theodorlarionov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261117175835.745796-1-theodorlarionov@gmail.com>
References: <20261117175835.745796-1-theodorlarionov@gmail.com>
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

nf_bridge_adjust_skb_data() and nf_bridge_adjust_segmented_data() push
and pull skb_mac_header_len() bytes for any skb with bridge netfilter
info. A pskb copy of a bridged packet, such as one made by nft dup,
keeps that info, and the next patch unsets its mac header. With the mac
header unset, skb_mac_header_len() underflows and the push moves
skb->data out of the buffer before skb_gso_segment():

  BUG: KASAN: slab-out-of-bounds in inet_gso_segment+0xd5f/0x1370

Only adjust skbs that have a mac header.

Fixes: a5fedd43d5f6 ("netfilter: move skb_gso_segment into nfnetlink_queue module")
Cc: stable@vger.kernel.org
Signed-off-by: Theodor Arsenij Larionov Trichkine <theodorlarionov@gmail.com>
---
 net/netfilter/nfnetlink_queue.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index a8aa7ad832c3..fafadd9057cf 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -1084,13 +1084,13 @@ nf_queue_entry_dup(struct nf_queue_entry *e)
  */
 static void nf_bridge_adjust_skb_data(struct sk_buff *skb)
 {
-	if (nf_bridge_info_get(skb))
+	if (nf_bridge_info_get(skb) && skb_mac_header_was_set(skb))
 		__skb_push(skb, skb_mac_header_len(skb));
 }
 
 static void nf_bridge_adjust_segmented_data(struct sk_buff *skb)
 {
-	if (nf_bridge_info_get(skb))
+	if (nf_bridge_info_get(skb) && skb_mac_header_was_set(skb))
 		__skb_pull(skb, skb_mac_header_len(skb));
 }
 #else
-- 
2.34.1

