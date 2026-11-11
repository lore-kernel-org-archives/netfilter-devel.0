Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794406608;
	b=P7r+5ToPZOEyLocE/1EnZgd2AmvkHqiPZ4k/lYo40XSAmpvsGO3bNsB9gdRCoRq1yE2y
	 a6Lj8Fim91jT8hDZ1MHxKHVfez3CkC4AfTURea2uxVClN/wiwbd0oDkeu92JSGdQyEb2s
	 kic0jovEJ7oyCIn3Lt/iTAsU4GLnkUtHIV725v+GOzgscA4eC+hqUdiVkMeRS+AGI9z6l
	 ggQdifAzDo0z012aKYz84QyvX2UlklGymDt8mj+73gty64FVCWcmJc5DXjub15YMyPu8D
	 6xYGFU5MquocgOGaGHqDz98wCagiLfBEJOB5xB1lz2bDlzwes1miXBxYhHnAJw4O8iQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794406608;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Kkp0sf7AYW6VmAUeGJTN0IINgbfaB9P070/+YW6JJGM=;
	b=dxwXGO9XOapfdEbeJO5VyidE9ZbTORA/fsuedcJanKYGm9e2tkb69gmxNUjTGp85pcfh
	 H/tSQFGVG1T2Axl5GOW3H4JY2QVMAGTFY2WE+/sVi44ZUuWTqcIFTWoubax4UGBsLiX3y
	 WIcHJb9Wpwapi1cDkl83csycGQDoQmfukzaeKwMpSTW4qE1m5lGhO9RT7GBB0cZXcvdBw
	 Vic8RkWK9xzs84Z48efZGXGAj3LC8NcLAV7GbIat0b2q3oHt41FRI2Rdf8pF1Caw2yNwn
	 tTqwA8mQ2mRVcNHUXvkMXvCkamBfSvvdva11Iq1iIFbtgX/B/6T7Shko1Saeb/Mzw8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=mojatatu.com;
	spf=none smtp.mailfrom=mojatatu.com;
	dkim=pass header.d=mojatatu.com header.i=@mojatatu.com header.a=rsa-sha256 header.s=google header.b=SQ4E1TMp;
	arc=none smtp.remote-ip=209.85.160.169
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 770AE606A33A
	for <netfilter-devel@vger.kernel.org>; Wed, 11 Nov 2026 14:16:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 770AE606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mojatatu.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=mojatatu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mojatatu.com header.i=@mojatatu.com header.a=rsa-sha256 header.s=google header.b=SQ4E1TMp
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-53639b8903bso40660051cf.0
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Nov 2026 06:16:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu.com; s=google; t=1794406607; x=1795011407; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Kkp0sf7AYW6VmAUeGJTN0IINgbfaB9P070/+YW6JJGM=;
        b=SQ4E1TMp/e2ruLG4sjeW4a9FyCecaLf7rPv9DZjCXoQQokviHfyx48hZqqIliIAyzg
         U0qynPV/Rcmw3BZy5NZ115W30eORxd1WIQpNwsNbtHLkZmQGhIImXhOEOBnpyc5JsFyU
         sMeljLDzBCoa+U/Jzm/wSHqHh+G3MhvLtwxbE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794406607; x=1795011407;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Kkp0sf7AYW6VmAUeGJTN0IINgbfaB9P070/+YW6JJGM=;
        b=2RL3WReqfr+3NKFyOis4E8JfTiyUYgMdPp2pCrirJOvfy6a4M6CqNcMPbjwDyWGNzt
         rT9gcpw6or9gU/4vrMPVEbQ4wB8NWzOyHD6y0hpRv+p9jBcSU1cvWMots01VcfQJ3G/b
         PvufUJ4zXztS0NQQpUSgG3BWpGNpaaMjiz21RnKv4DyDDJgjR5FKlYrF+G3sn3bQG9dz
         5hyHYfiBRKU4WS66YgsL0iaFOs9sK0FHOa4ghRvzB65d3RcjD5ojuC93P/692zBlDJdw
         VnA0XjXZyAO4ElWCCXRCWWsm1/JGRpnseuugh4N2JwSCdonUa9IpStiUvYnLrIajcFKJ
         K0fQ==
X-Forwarded-Encrypted: i=1; AL+hErHFwLZ5Gciy2ytrjx2SKZsDPADCT6tsMoRixLQZgWaqJoNVVKyuPJYIrlcjyXKVuMdXw+DUuRttP2Y7MsUBKzo=@vger.kernel.org
X-Gm-Message-State: APuU4Z9mmI3OP+bz15fsuHczxtERy3TwAd7lxUz1VvprazELbEw2cKG3
	WPop0WxH1e/K6yEigrbG9z84E3ztY3JOJzkWx6S2R3So3pqf2qnUdgIH99Ba09AozQ==
X-Gm-Gg: AYBFou2iznjWyKtmjN+h9L4PAxM0Wl+UEN2SMFTNgMhCHIhs5Dgz8NST7C/QEznmAft
	yi1Ivwbr2mW0xvIcIlD2FvsgATEwJIvxJ1aMqhOdRwdEormmvLnJH0DdXCGgFRnRcYZI1yVUMuZ
	KxoWZDbkDM61+KuzmJ1cR/eY7Z6edAn4nOuOJJ9FbZFE9VCbZAqaFDg6CF3HaYfE8LW2F1WsGJq
	Qe/qQ+At22ZfLnji8JKPm5qlNZEJrOMKNfViyaEDcvaVcrZImw6rvgOv0Z3wg3ChdNdpV6UX86F
	TZ3rR59Z7JxXzlh9ZhQsXQYpOI9Y+BKhPTgLQHLAByW7uNnaqYxgreolVAuJ9wHjo/ZJZCExqVU
	1L8p+m+zzjRF+KoBXxUwQxS2DbOyyxuWKOkSEsFzQig7FZEgcMdUGPFQ3F7F1yg89Tntpng+Vae
	uLnuj+WrwhjQK58zApvbqDm3kKfhYPZwW1psF9uGLEkERSRf7FDtlp7edBPUWco/gfdHIVbJ9Oo
	gLPnP91MPzThMrkM0Jcyjo05o1UdG2GswIq3Mc1fVGbHgf9FRngzX/yJGGFYIgI5gcYzSs0G3id
	CdInMWqyztRB836ZoHyW6RCgvo6KvHG8VT6lBFQhnR5Nc3AM4Qf7sfsOJz89lozHgsrhaEjUOT1
	e9iJTTQP4W8iJ4g==
X-Received: by 2002:ac8:5fc5:0:b0:535:96cd:559a with SMTP id d75a77b69052e-556c0cbd262mr31027821cf.16.1794406607214;
        Wed, 11 Nov 2026 06:16:47 -0800 (PST)
Received: from localhost.localdomain ([64.203.83.2])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5550be2e592sm51505041cf.24.2026.11.11.06.16.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2026 06:16:46 -0800 (PST)
From: Jamal Hadi Salim <jhs@mojatatu.com>
To: netdev@vger.kernel.org
Cc: Jamal Hadi Salim <jhs@mojatatu.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	Victor Nogueira <victor@mojatatu.com>,
	Jiri Pirko <jiri@resnulli.us>,
	sashiko-bot@kernel.org
Subject: [PATCH net-next 1/2] netfilter: nft_fwd_netdev: drop the stale dst when steering to a device
Date: Wed, 11 Nov 2026 09:16:37 -0500
Message-Id: <CORE-9NOG.v1.r0.20261111073528-1@mojatatu.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <CORE-9NOG.v1.r0.20261111073528@mojatatu.com>
References: <CORE-9NOG.v1.r0.20261111073528@mojatatu.com>
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

This is a followup of the review of the teql arp-queue fix as reported
by Sashiko.

The issue: the neighbour variant of fwd rewrites skb->dev to the
configured output device and calls neigh_xmit(), but leaves the skb's
dst untouched. If that device's neighbour for the configured nexthop is
incomplete, the packet is parked on the neighbour's arp_queue while the
stale dst still describes the device the packet was routed through.
Draining the queue re-looks the neighbour up from that dst, so the frame
is built with the routed device's link-layer header and then transmitted
on the configured device. The packet leaves with another device's
addresses.

The Fix: drop the dst before the device switch. Both lookup inputs the
neighbour transmission needs, the device and the nexthop, are supplied
by the rule, so the route dst is never consulted. Without it the queue
drain keeps the parking neighbour and the frame carries the configured
device's addresses.

Conditions to recreate the bug: two network namespaces, A (10.10.0.1/24)
and B (10.1.0.1/24) in one, their veth peers in the other with only A's
peer addressed (10.10.0.2/24) so B's nexthop cannot be resolved by ARP.
Resolve A's neighbour for 10.10.0.2 as permanent, then load this ruleset
on A:

    table netdev t {
            chain c {
                    type filter hook egress device va priority 0
                    policy accept
                    fwd ip to 10.1.0.2 device vb
            }
    }

Send one packet to 10.10.0.2. It is parked on B's incomplete neighbour
for 10.1.0.2; once that neighbour becomes valid the frame leaves B
carrying A's source address and A's neighbour as the destination.

Reported-by: Sashiko (nipa) <sashiko-bot@kernel.org>
Closes: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/QDISC-6HS9.v3.r0.20261103062649-2@mojatatu.com
Link: https://lore.kernel.org/netdev/QDISC-6HS9.v3.r0.20261103062649-2@mojatatu.com/
Reviewed-by: Victor Nogueira <victor@mojatatu.com>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
---
 net/netfilter/nft_fwd_netdev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nft_fwd_netdev.c b/net/netfilter/nft_fwd_netdev.c
index a48c2f765bba..ad4d61d64cdd 100644
--- a/net/netfilter/nft_fwd_netdev.c
+++ b/net/netfilter/nft_fwd_netdev.c
@@ -175,6 +175,7 @@ static void nft_fwd_neigh_eval(const struct nft_expr *expr,
 		}
 	}
 
+	skb_dst_drop(skb);
 	skb->dev = dev;
 	skb_clear_tstamp(skb);
 
-- 
2.43.0

