Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.217.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794855714;
	b=5GjtLBwWsCt7CC/LrpkKdbpGffLFlAzM+25aLzbFbnKng9Nqsg0smAFd1cz9lviso+m9
	 wvY5p1I/666LBwYBIm18RnxR/mlMpNs/nouGX5xB691l0c8RnLkXQ43SMhRnRfA/KNNHC
	 8mv/WMIdx7tFXMzsBWPkjylfDF3XHIjkbXPieu4aNQ7rwBqX7o6/rPjyJi5c51kuc+qU3
	 a/nHJ47oh+Hn7QXisIAX4yFI/NTIpAnWlhZCEMI06b7Cps96wHmkRn+nlM1ENBLe39BiE
	 QMSxeCNbosT4e80KJOG008UHYv9xdU0VV+1JHlXBdA4m8e3q3ySNj6FX4dTbK4uiLlw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794855714;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3MI+brHB9Vx0cwhAA41vaukzU7zAu9Xp5tBLjVwHA00=;
	b=hrmu4W168V0uYIcSNu1dYhltpySOfWVj6B/Qkud96HkKQezNlFyJ0HmQ8/wBbtvSDvIC
	 UujT2KwIS1S9fxVy/9Xmzk3lSitk18Pl6JCnilRL5coYqWU1s8wHl/T0EHphBT3JdTHzw
	 59HoreQJtqv0r4Y1zMPU3X1sk/ev6TYEfQPY1JIw12plMhLatImN/yAxIl8jLmo8erUpj
	 AFlRZUZw9sJZbAvcNY2e1f9b3CjWgEPgsR1f6ZVQn5WNoJgeLELA73CHq3zQDqbyR/N3e
	 aKIOp85WwkJKeJcuc6gO6Btk4oZ/RfbZW8EBfK4Omy3J4UTLlE2AOa8YpOsxpi1LX7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=mojatatu.com;
	spf=none smtp.mailfrom=mojatatu.com;
	dkim=pass header.d=mojatatu.com header.i=@mojatatu.com header.a=rsa-sha256 header.s=google header.b="g2JSPq/F";
	arc=none smtp.remote-ip=209.85.217.42
Received: from mail-vs1-f42.google.com (mail-vs1-f42.google.com [209.85.217.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0141D606A338
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2026 19:01:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0141D606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mojatatu.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=mojatatu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mojatatu.com header.i=@mojatatu.com header.a=rsa-sha256 header.s=google header.b=g2JSPq/F
Received: by mail-vs1-f42.google.com with SMTP id ada2fe7eead31-7a6e560f580so3930844137.1
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2026 11:01:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu.com; s=google; t=1794855713; x=1795460513; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3MI+brHB9Vx0cwhAA41vaukzU7zAu9Xp5tBLjVwHA00=;
        b=g2JSPq/FFT/Q8VQUqJi/efQ0iSls8qOT4f4gGffNRQT6Js3ARcF2vMBqiShX6hItYH
         ly3NmrMxEXjRK1bJTsbaYG0VH6p1VNzGhe8r8iq0NiXReeDLR3eqxOXERr/NtOeHMG83
         DcsDUzpm8vMb00KKFJhn3sYEg+VVVavhtwMqI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794855713; x=1795460513;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=3MI+brHB9Vx0cwhAA41vaukzU7zAu9Xp5tBLjVwHA00=;
        b=xoHQcvLSB5PSiAtdjjnReVww5d1RbAiBcs2zVM10OJmdd6IBKSxGC0uc1xG6uY5hP3
         EygWD5gwGA+lTpPuctgcG9FqLdf19FCMHiT2NoxgD3P3LdOBRuzenRQUKiQNzM9ldqGT
         UE333ugUBx4mbCpGyaeUBKDNTMvLKK068RyE0/s8GO8UGb4vEnG8642k5edyndbWRwRJ
         vhMPdC0mXAkkm2202njZKx/ZSNVpH3ZhjWSsNKuO08jHhqKtfGYb5FpB6G8acyHL10YL
         4G9hx8D1bEl2sF0N0vq/9sDWtW2VyD21CRyi0cC65PEL47UPsUWeXc0E0xn57vNhU0IW
         fjOQ==
X-Forwarded-Encrypted: i=1; AL+hErEhaDNgTYnP+HlY3UbiLkmzLF3nZtc7/H6pGzbSRhdmDndWhfflkWtJ9HGD8SaWSVtlj/ohL9QbZnhMM4EPO7M=@vger.kernel.org
X-Gm-Message-State: APuU4Z8DrwEDPuD95fw81XHWh24W2rk32MMj9HfmD6RHI1Vq3tvG786I
	pMU3X7GqDKRY/mk+c058bhOZ996sClqetTG0kKtUM4ohLSSaleXbO3VK2Mk9qi7ckw==
X-Gm-Gg: AYBFou1GZL8bKv3wyjFUTZ0+bAMn5/bWuNEjiKKyWn1xkIqfppmia3t6N8lpWKD58X7
	3JBdmWdgjQ6eLVIkqZZZug5RQchY4vxPQCh5TbLpIH5t33yRHqB2NQAf5aMW4tekuLawb3yAeP9
	G8cmHjEOoXyy5gE9+yYRggiqXT4TTVJMR4SnTOkMV/vmG0+kUdt2OrjjXuaawkpW0DddXj7fdEf
	Y4WWmWlFfFCwYhPZza7OvA/ViotPF8o3PkeTS7AnT4kMeYrKWAIJ6J9ez0jh0IndgkgFN3pPQhv
	TF43P4T5tVxi9HdrW+GphFtrT+3r1izvNFxRem+wUcnKOuOxGsBrO/YDrCKntEg/p72KkV4V7jK
	06Fu645mk6wYswZEjgqpxCYZWg9Nfh4th1EiS3YApzXUpFB6hLJD1uF65aUZFo4D+SDDDFnMzF/
	X/LA16juJKxPYtyIlQvQ3uSQwwRQD+30ebMjG2D7Qj4CE9zMUhuNOJLzMSemsBaxOsn8k9LMVAd
	6PPzd3BJX+AZkuDUShtUUea9wCdvBB0JfJyXctNGdoYX7pv1FDEzDXENU/b7txgpGodqR7l7vMx
	a9T94uIzKc8wZ8ohsLWyHZqGqifYby4nca1RKr0LT2yDqf7SngHTsgSMaDypbNbdso9fx79oZdI
	=
X-Received: by 2002:a05:6102:83d9:b0:7c1:9286:296f with SMTP id ada2fe7eead31-7d64d77b824mr3478495137.25.1794855712829;
        Mon, 16 Nov 2026 11:01:52 -0800 (PST)
Received: from mbili.waya ([64.203.83.2])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91f23d453casm91997386d6.10.2026.11.16.11.01.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 11:01:52 -0800 (PST)
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
	bpf@vger.kernel.org,
	Jiri Pirko <jiri@resnulli.us>,
	Victor Nogueira <victor@mojatatu.com>,
	Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH net-next v4 3/4] netfilter: nft_fwd_netdev: drop the stale dst when steering to a device
Date: Mon, 16 Nov 2026 14:01:40 -0500
Message-Id: <CORE-9NOG.v4.r0.20261116135311-3@mojatatu.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <CORE-9NOG.v4.r0.20261116135311@mojatatu.com>
References: <CORE-9NOG.v4.r0.20261116135311@mojatatu.com>
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

The issue:
The neighbour variant of fwd rewrites skb->dev to the configured output
device and calls neigh_xmit(), but leaves the skb's dst untouched. If that
device's neighbour for the configured nexthop is incomplete, the packet is
parked on the neighbour's arp_queue while the stale dst still describes the
device the packet was routed through. Draining the queue re-looks the
neighbour up from that dst, so the frame is built with the routed device's
link-layer header and then transmitted on the configured device. The packet
leaves with another device's addresses.

The Fix:
Release the dst before the device switch. Both inputs the neighbour
transmission needs, the device and the nexthop, are supplied by the rule,
so the queue drain keeps the parking neighbour and the frame carries the
configured device's addresses.

The release goes through skb_dst_drop_keep_metadata(), so encapsulation
parameters a route carries are handed over to a metadata dst instead of
being lost, and a metadata dst already on the packet is left in place. If
that copy cannot be allocated the packet is dropped, never sent with the
stale route.

What the configured device's transmit path still sees:
The released dst is the route of the device the packet arrived on, and the
packet leaves through another one, so consumers of that route on the way
out lose it:

  - a tunnel with no configured remote takes its outer endpoint from the
    route: ip_tunnel_xmit() reads the route's next hop, and ip6_tnl_xmit()
    and sit derive it from the route as well. A steered packet whose route
    carried no encapsulation parameters is left with no dst, so it is
    dropped and counted as a transmit error instead of being encapsulated
    towards an endpoint that belongs to another device's path.
  - the route realm goes with it: a realm is a property of the route the
    packet took, so nft meta rtclassid and nft rt classid stop matching on
    that packet, and bpf_get_route_realm() returns 0.
  - encapsulation parameters are not lost: they moved onto the metadata
    dst, so a tunnel or an xfrm interface downstream still finds them.

Taking the outer endpoint or the realm from another device's route is the
same cross-device reuse this patch removes at the neighbour lookup: those
values were never the configured device's to use.

One consumer is older than this series. When a tunnel cannot take an
endpoint from the skb, ip_tunnel_xmit() and ip6_tnl_xmit() fall back to
skb_rtable(), a container_of() over whatever dst the skb carries, and a
metadata dst is not an rtable. That fallback is reachable without this
series: a tc-bpf program that calls bpf_skb_set_tunnel_key() with no
remote already hands an NBMA tunnel such a dst. The release here can leave
one behind as well, when the parameters a route carries are not usable for
the payload. The cast is repaired separately.

Conditions to recreate the bug:
Two network namespaces, A (10.10.0.1/24) and B (10.1.0.1/24) in one, their
veth peers in the other with only A's peer addressed (10.10.0.2/24) so B's
nexthop cannot be resolved by ARP. Resolve A's neighbour for 10.10.0.2 as
permanent, then load this ruleset on A:

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
Link: https://lore.kernel.org/netdev/avTfQjFQYR2NNdRg@chamomile/
Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>
Reviewed-by: Victor Nogueira <victor@mojatatu.com>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
---
v3 -> v4 (commit-log change only; the diff is unchanged from v3):
- Add the section on what the configured device's transmit path still
  sees once the route is released: the NBMA tunnel drop with its
  transmit-error count, the realm readers that stop matching, and the
  encapsulation parameters that are preserved.
- Note that the skb_rtable() cast in ip_tunnel_xmit() and ip6_tnl_xmit()
  is older than this series and is repaired separately. Considered
  comments from Sashiko (nipa).

 net/netfilter/nft_fwd_netdev.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/netfilter/nft_fwd_netdev.c b/net/netfilter/nft_fwd_netdev.c
index 7447da931a95..f486c7be385c 100644
--- a/net/netfilter/nft_fwd_netdev.c
+++ b/net/netfilter/nft_fwd_netdev.c
@@ -14,6 +14,7 @@
 #include <net/netfilter/nf_tables.h>
 #include <net/netfilter/nf_tables_offload.h>
 #include <net/netfilter/nf_dup_netdev.h>
+#include <net/dst_metadata.h>
 #include <net/netfilter/nf_recursion.h>
 #include <net/neighbour.h>
 #include <net/ip.h>
@@ -160,6 +161,11 @@ static void nft_fwd_neigh_eval(const struct nft_expr *expr,
 		goto out;
 	}
 
+	if (!skb_dst_drop_keep_metadata(skb)) {
+		verdict = NF_DROP;
+		goto out;
+	}
+
 	local_bh_disable();
 	if (nf_dev_xmit_recursion()) {
 		local_bh_enable();
-- 
2.43.0

