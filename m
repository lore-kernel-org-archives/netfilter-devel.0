Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C85A3914E0
	for <netfilter-devel@vger.kernel.org>; Tue,  4 Aug 2026 09:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785836013; cv=none; b=lrjXQ5CVeVdas9rsU6nTzl8m7z/Q5Uv6MJx7RHIUodzjY9tyWNPdnPv6d1UA2kxOa/RHfWKZ4iorucl+UxIjVprEd9GBI8RY2g2n0fVt+qtfuncyB9diIC1ZvsBw3dF2usD/gPoUWqv1ZRo1tieJjGsu3oL+F08SifN4875p6qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785836013; c=relaxed/simple;
	bh=S5d77MO7jT+Hxg/r1TJiTp0m7KHLUEVxmp4cjvqHef8=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=WDKHQqFhVJnEE05o9SxLFa7Bjz29tdS+aKMLy+kBqRn5KIH0CzjH6u/8EPlZ/xLzqcQVS/nrZqSGgut2yq2NOSDL+3xOPSOv0GEb1E2H1t2wzvTXua5oCkiMx6pi90+Zfn0m1ADexh3GQgpaaaZXnUqi1pMbRRqG+xHXrdnKJNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--edumazet.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OshbyIpJ; arc=none smtp.client-ip=209.85.222.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--edumazet.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OshbyIpJ"
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-934956beec8so764012185a.0
        for <netfilter-devel@vger.kernel.org>; Tue, 04 Aug 2026 02:33:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785836010; x=1786440810; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=n/o2KUQEG4PbIJNYMsLCUH5mINGumQTL57V04We/jqE=;
        b=OshbyIpJ/qOd58KLeDLCpeTZUAYPDNuqFmPUVG2Er//a/3AZQm0UW8DFtkUaTqD0jr
         0HBg1FEW6YNreWEdoffSjknHK7VDuUZAjYO5X+llSv6f3/ePXgohJoc/pRmjk1VVkf4L
         CbuvpZ07/fscy4Ao1VG4X05tGTDC+JJtrqlV8z950Y1kZMwccCWcUxMMi4CGjhfp1Xy/
         zb17/CsKPFu4E9ivOdLhxWfFZvRjSDe7HOj07irI//v6z0IbMTZqr5rq0rDsaiUjA72O
         iPRKlUT1fhz6OFKU68O+L6Bn3etZNqJVuwOtFpE2h4sqL6Uzcj+e1xlJEGoS3GAafIUR
         8fqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785836010; x=1786440810;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=n/o2KUQEG4PbIJNYMsLCUH5mINGumQTL57V04We/jqE=;
        b=M4qMwu2vEaOMGSFAqGksZrC76t1ksjSMKFF2TVefK27cGAJhKrwpk7PhQtkBYkBbyI
         qz2RQWzF+/dQEMkSjyBrcc4ddUjR/gnuUs3laYtgxa5XDANzu42ThOdMm32i128QSxHH
         64yGyg99OvakUsJ3/Hqp2nhQh15Wr47L4urKIwvFom38Utpdm1EZQlOgaE+GSKZ4oXPd
         xjIlwqchWzZ2ZWypLG/TF3tWU7kz/jr13N/IsZuiaK18I3Y2sR1D9irQZdLGJbU2P7Fa
         /sydg5Wp1UhrAUC1MQ417u0TBrTWd6mu6/zWt9ogso30KmORfkFqkwJO0/0GCgRd7thn
         4ZnA==
X-Forwarded-Encrypted: i=1; AHgh+Rq3u4PPDvwCmId6m9ZXxWevvw87WZjwIaYYkR7B17l+eSWqgDLeZP4sWYnMTWXgjmxqTbEg8deoxgzxkkpHvng=@vger.kernel.org
X-Gm-Message-State: AOJu0YzS0NCURHDFtDMI+jcQuKDd9iYcwI2N4hBpstE/sYBTzR61CqRI
	G+6xBwZDWHFos+EBDkJ1pyLHEKpM6m+GQ9IOr8+Uzm4RFD8251YWukaLaMF8a3aggQU04MjFUi5
	3BplBp0PSgyXhMg==
X-Received: from qkll29.prod.google.com ([2002:a05:620a:211d:b0:92e:6d70:ad3])
 (user=edumazet job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:620a:1588:b0:925:e485:fca7 with SMTP id af79cd13be357-934a078282cmr2094859685a.15.1785836010270;
 Tue, 04 Aug 2026 02:33:30 -0700 (PDT)
Date: Tue,  4 Aug 2026 09:33:28 +0000
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.571.g244d577d93-goog
Message-ID: <20260804093328.1831847-1-edumazet@google.com>
Subject: [PATCH net] netfilter: nf_flow_table: drop existing skb dst before skb_dst_set_noref()
From: Eric Dumazet <edumazet@google.com>
To: "David S . Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, 
	coreteam@netfilter.org, eric.dumazet@gmail.com, 
	Eric Dumazet <edumazet@google.com>, syzbot+76d4e3a055aec3b007ec@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"

Incoming skbs passing through netfilter flowtable offload hooks (or XFRM
offload path) might already carry a ref-counted dst_entry assigned during
earlier RX or routing steps.

Calling skb_dst_set_noref() when skb already holds a ref-counted dst
overwrites skb->_skb_refdst, leaking the previous dst_entry reference
count and triggering a DEBUG_NET_WARN_ON_ONCE assertion in
skb_dst_check_unset():

  WARNING: at skb_dst_check_unset include/linux/skbuff.h:1170
  WARNING: at skb_dst_set_noref include/linux/skbuff.h:1234
  WARNING: at nf_flow_offload_ip_hook+0xf6c/0x2b60 net/netfilter/nf_flow_table_ip.c:864

Drop any existing dst_entry reference with skb_dst_drop(skb) before
setting the non-referenced flowtable destination.

Fixes: 2a79fd3908ac ("netfilter: nf_flow_table: attach dst to skbs")
Reported-by: syzbot+76d4e3a055aec3b007ec@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/6a71b141.9511d2ce.1fc5b9.033b.GAE@google.com/T/#u
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/netfilter/nf_flow_table_ip.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 0b78decce8a9bdc3ed404f9913384335408b00d3..c9e332fafcb5c22559f68858b36f3207822c4423 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -310,6 +310,7 @@ static unsigned int nf_flow_xmit_xfrm(struct sk_buff *skb,
 				      struct dst_entry *dst)
 {
 	skb_orphan(skb);
+	skb_dst_drop(skb);
 	skb_dst_set_noref(skb, dst);
 	dst_output(state->net, state->sk, skb);
 	return NF_STOLEN;
@@ -861,6 +862,7 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 			return NF_DROP;
 		}
 		xmit.dest = neigh->ha;
+		skb_dst_drop(skb);
 		skb_dst_set_noref(skb, &rt->dst);
 		break;
 	case FLOW_OFFLOAD_XMIT_DIRECT:
@@ -1178,6 +1180,7 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 			return NF_DROP;
 		}
 		xmit.dest = neigh->ha;
+		skb_dst_drop(skb);
 		skb_dst_set_noref(skb, &rt->dst);
 		break;
 	case FLOW_OFFLOAD_XMIT_DIRECT:
-- 
2.55.0.571.g244d577d93-goog

