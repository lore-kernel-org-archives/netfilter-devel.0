Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FA2F3A7D73
	for <netfilter-devel@vger.kernel.org>; Mon,  8 Jun 2026 10:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780914764; cv=none; b=UWujylBGAaiO42jhk1WX6be7WC+C6GDrDhOgVL5eCfakr2g+3IqD19mgYGEmeWSmlM1KTBl2w8xcScJ+VLWUILYe14ffEaZIzhE/TpD3V+hJUzAfAGazig6uUa6BDyFznDgHkdScWbwTBHtx4v9QZ5jGUpn8KxaVLCRzOXyOjdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780914764; c=relaxed/simple;
	bh=UwEbz+t34EV5iddH7QA8WixWMDCulwNmm3b2Mwp4hLo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sAPjp9cPWBG1E8j5b/Cb3JFrZBB9WUuMkFkuw4un8L3UdGpg/wA7j5bvLZFhoTrhFeIOnrDnXfpQklcAx6jwbRrp0D+J6CQL1gmKuPlWpnlS+AIICADxM5p/eWbvPjnwileVv7oMZfe9/1566yerxmzgN9AXXehzRFPvoygW3f4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=aerlync.com; spf=pass smtp.mailfrom=aerlync.com; dkim=fail (0-bit key) header.d=aerlync.com header.i=@aerlync.com header.b=QNyAtSUL reason="key not found in DNS"; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=aerlync.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aerlync.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=aerlync.com header.i=@aerlync.com header.b="QNyAtSUL"
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-c85893bce34so1569205a12.1
        for <netfilter-devel@vger.kernel.org>; Mon, 08 Jun 2026 03:32:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=aerlync.com; s=google; t=1780914762; x=1781519562; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7z+CvKnAGor+c7U0dVX35N7V89+YB/8qEbvrSee3CY0=;
        b=QNyAtSULm8FwJUssxe5WNhfafXswnyxxWqbrvXC3uz/xSpdEyIBafibzlJrqmpGCI6
         E/tyY/AzIwyErdvzcj6LpmYDOsZ2Ke97EoiZOxVGJf6+1Y7JNfr0JaqIbPrjFdV5712/
         hhE6ZMzP8yN007c6sUX0aBa+5n3qCjr7HHQe91z2MNOoR0QFCMNdQh2fyrkFFy6jD/Ly
         +SSHAUM3eJzMPBoIEPz+wY+oKH8dNI2prVchI5K9D3h5NPoe0otRpz/T17z9Cq9C58hK
         l+n6EW+dW00xngtUHntIOHLt2DXkslUQGfjg+JVEqLf/+4WXDMNS5XuhThyMFhh2p74d
         kYdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780914762; x=1781519562;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7z+CvKnAGor+c7U0dVX35N7V89+YB/8qEbvrSee3CY0=;
        b=GuJ3lUggPTme62F2idJq1spHsZcCW/ga//HHYahm7C4NjHHfXKXsRcyqFyhx58k+So
         b+ywl/qLMe4J7VI0DeMhNj9IbG2TE6hUtP6Y2NrI6gVZGrD3uLQL8RX9FFsOhUwoW6eT
         gQPveqwxRAa88gfMu+lo2h7vP5Jx4F3TqVihEQpo+CkvxPW1CCqJ0XdWhRtl4F/d/Od9
         98pNJgb3OqbA9koP01ZFzbd8yoDLUedDhnZl6yljYOuKCVs3W7ybvCTNDLNckjrohbGZ
         0GGtuF9T5k/kVfeH6GW4QC8EEcx5rgLRUXw/HrwXH0JH9iS9ML+tEB3ad3iot1GsutUu
         Ay0w==
X-Forwarded-Encrypted: i=1; AFNElJ8ekH+tFL8T5Iy+1OMG3uJxiOSal6qj9tDEODlkPkCxdmY3rv3lMpN02mjZKFx5PL+B8hr6JjIVVda1mcprb58=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxg5Bu/Cz0r7C7+VAt/pRkkfNsIyNHOX7YYaNnttQ7ZNsi9cWng
	fIkjGa2O9N/m8+lcOMDHaoHIG1AGi2S8MmEKePsZ2uwL+G1bH+/Jlwin6Tmo9+tBTGw=
X-Gm-Gg: Acq92OH7VuSerFVQpl1pzFF1cFFUcA+T81hk2JOPsK59Ab6LJkr5S7gQ6oiTfTef+dC
	5OBHlq1FqbIAFW2Eo7MbwJMWLHJ2uidibgpGEttb2/iRsE2n88hOKrS+n8ZhAYeYgOPjY7cGnXJ
	BaMhKcW8QcTk/fOUdGsLaVEVZ8e3UEhodCK25RdCxHZfacMlaZbcNC2yMOySxxRkIy6A6CxYceH
	fgE21d8g6AXxwMm9dbQub+2QUzlu8Cmfv7dhRx3QWu+NwKq7yoNQE/vdmMNXqnqNQVFAVlOTqXY
	9sXjYmcqkKF1/r/O5PfueGJttmRiT2Tj0DaHhjheJrghRgVbXynhNLzy89fwZl2LU501zPSWvPW
	mATs1xRLvQiM4yUqDPzLX3owmJgkEcs4+Oo0yzWIj71PzYHJgfEhmIeeTuuG8cdeRwQtPQVUDpO
	eAU5eezFbqpBy6bo0ExG+5BAK+YdULyFV6VL3m5YfDgMu+7MDSeNbyhnL7FKk=
X-Received: by 2002:a05:6a21:4d92:b0:3b4:85db:1bd0 with SMTP id adf61e73a8af0-3b4ccd659aamr16493944637.12.1780914762547;
        Mon, 08 Jun 2026 03:32:42 -0700 (PDT)
Received: from manjaro ([103.186.230.13])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c85df03387asm16326028a12.4.2026.06.08.03.32.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 03:32:42 -0700 (PDT)
From: Sayooj K Karun <sayooj@aerlync.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Cc: Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	netdev@vger.kernel.org,
	edumazet@google.com,
	Sayooj K Karun <sayooj@aerlync.com>
Subject: [PATCH nf-next] netfilter: nf_reject_ipv6: do not reject ICMPv6 Redirect with an ICMPv6 error
Date: Mon,  8 Jun 2026 16:01:55 +0530
Message-ID: <20260608103155.8339-1-sayooj@aerlync.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

While fixing is_ineligible() for the L3 reject path, the bridge/netdev
reject path was found to have the same defect. RFC 4443 section 2.4(e.2)
mandates that an ICMPv6 error MUST NOT be originated in response to an
ICMPv6 Redirect message (type 137).

There are two IPv6 reject paths, and they suppress this in different
places. The L3 path (ip6t_REJECT / nft_reject -> nf_send_unreach6())
goes through icmpv6_send(), where is_ineligible() decides whether the
triggering packet may generate an error; a companion fix makes that gate
drop errors in response to a Redirect. The bridge/netdev path
(nft_reject_bridge / nft_reject_netdev -> nf_reject_skb_v6_unreach())
builds the ICMPv6 packet itself and never reaches is_ineligible().
Its local guard, nf_skb_is_icmp6_unreach(), only matched
ICMPV6_DEST_UNREACH and let every other type through,
including Redirect.

A triggerable scenario: a bridge or netdev firewall with a REJECT rule
applied to incoming ICMPv6 traffic (e.g., dropping Redirects from an
untrusted segment). When the Redirect hits the REJECT rule,
nf_reject_skb_v6_unreach() builds and transmits a Destination Unreachable
in response. Without this fix the guard lets the Redirect through and the
error is erroneously sent, violating the RFC.

Extend the guard, renamed nf_skb_is_icmp6_unreach_or_redirect(), to also
match NDISC_REDIRECT so that Redirect packets are skipped and both reject
paths behave consistently.

Link: https://lore.kernel.org/ah_hYJa3byoUyose@chamomile
Signed-off-by: Sayooj K Karun <sayooj@aerlync.com>
---
 net/ipv6/netfilter/nf_reject_ipv6.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/net/ipv6/netfilter/nf_reject_ipv6.c b/net/ipv6/netfilter/nf_reject_ipv6.c
index ef5b7e85c..d4eec8d9a 100644
--- a/net/ipv6/netfilter/nf_reject_ipv6.c
+++ b/net/ipv6/netfilter/nf_reject_ipv6.c
@@ -8,6 +8,7 @@
 #include <net/ip6_route.h>
 #include <net/ip6_fib.h>
 #include <net/ip6_checksum.h>
+#include <net/ndisc.h>
 #include <net/netfilter/ipv6/nf_reject.h>
 #include <linux/netfilter_ipv6.h>
 #include <linux/netfilter_bridge.h>
@@ -104,7 +105,7 @@ struct sk_buff *nf_reject_skb_v6_tcp_reset(struct net *net,
 }
 EXPORT_SYMBOL_GPL(nf_reject_skb_v6_tcp_reset);
 
-static bool nf_skb_is_icmp6_unreach(const struct sk_buff *skb)
+static bool nf_skb_is_icmp6_unreach_or_redirect(const struct sk_buff *skb)
 {
 	const struct ipv6hdr *ip6h = ipv6_hdr(skb);
 	u8 proto = ip6h->nexthdr;
@@ -127,7 +128,7 @@ static bool nf_skb_is_icmp6_unreach(const struct sk_buff *skb)
 	if (!tp)
 		return false;
 
-	return *tp == ICMPV6_DEST_UNREACH;
+	return *tp == ICMPV6_DEST_UNREACH || *tp == NDISC_REDIRECT;
 }
 
 struct sk_buff *nf_reject_skb_v6_unreach(struct net *net,
@@ -143,8 +144,13 @@ struct sk_buff *nf_reject_skb_v6_unreach(struct net *net,
 	if (!nf_reject_ip6hdr_validate(oldskb))
 		return NULL;
 
-	/* Don't reply to ICMPV6_DEST_UNREACH with ICMPV6_DEST_UNREACH */
-	if (nf_skb_is_icmp6_unreach(oldskb))
+	/* Don't reply to ICMPV6_DEST_UNREACH with ICMPV6_DEST_UNREACH, and
+	 * per RFC 4443 section 2.4(e.2) never originate an ICMPv6 error in
+	 * response to an ICMPv6 Redirect. The L3 reject path enforces this
+	 * via icmpv6_send()/is_ineligible(); this bridge/netdev path builds
+	 * the packet itself, so it must check explicitly.
+	 */
+	if (nf_skb_is_icmp6_unreach_or_redirect(oldskb))
 		return NULL;
 
 	/* Include "As much of invoking packet as possible without the ICMPv6
-- 
2.54.0

