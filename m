Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.175
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794737963;
	b=uLmbJJjCuI00HQ49WyUYfgrNJvDrbBRDUOPYLGmwZ3NsnKgeiGkW7m7bpEw7oUN6y6Jo
	 xnSByfG1LYyfjzcj+HEZE+53bULic1mD79BX81TIEdV+H2OvVUNYGrxbtV7UYcg+jDcw/
	 dXSpdUFeoIW+wKBZIUb0ZsTrZCbBsSLiOSY9rQSfXDtRdWQb8u4r1HrnnV16TgFaa0a1B
	 yVt9fw+kPwYzaEoKwmwhlX9AtjzCPT5aCDyO8zzBSPCrJIts8LLjh+rKOTkZzMoDNqUyk
	 OKIhPn70DJcWbqI4Qtyc/XhObia8J4zVbnGS2MhwAfKlWbKEhu2AMm7owyh+Qdne1MQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794737963;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8FdZmPYxVJRZwepv2ASwo7Gw6muFW4JO5etLfzKYWPY=;
	b=aTYYw1huzcsBgOEaPCvnS7kc+dRumCEA/iOoFMOn83LUqQidzHEgZQ7whe53jnA7fDiE
	 GDfCDKTDkKwa7DKIXotMU8sjZYcl7ECZ6A/Hq3i2ABdsFdQpquY9OSFZskFq2hDONGCxC
	 ZGnrTRf3oi65mUoLosRtFW21xxybT3WkHLa0viafg2Ck6i2qgbGI6GarMCUz9DmT42xC8
	 TElUZfigA6zZ4cIo/hJaPeynM7dyZEjeelH3zd98DsIXP+77YKTOzZnQawSMVJNofRss/
	 hY43Bf6q864jQH0OJDbFcflqaFIW0gp7W19HzubAuVvYPKD3Nd/2iOEAier4YabZ2bA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=mojatatu.com;
	spf=none smtp.mailfrom=mojatatu.com;
	dkim=pass header.d=mojatatu.com header.i=@mojatatu.com header.a=rsa-sha256 header.s=google header.b=MWGVQG1E;
	arc=none smtp.remote-ip=209.85.222.175
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67C51606A332
	for <netfilter-devel@vger.kernel.org>; Sun, 15 Nov 2026 10:19:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 67C51606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mojatatu.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=mojatatu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mojatatu.com header.i=@mojatatu.com header.a=rsa-sha256 header.s=google header.b=MWGVQG1E
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-945e6d9ceeaso286920785a.0
        for <netfilter-devel@vger.kernel.org>; Sun, 15 Nov 2026 02:19:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu.com; s=google; t=1794737962; x=1795342762; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8FdZmPYxVJRZwepv2ASwo7Gw6muFW4JO5etLfzKYWPY=;
        b=MWGVQG1EmcCvaAbT9BiccGy3hK999wI2mBLTw6m0Jbj4d6yki8WXtF7CKwieJGeiKr
         a4Z9bNV2qZuskUaYPhoXKkQzopPtL2AGzmsoJtv72MFl8HnwHgpxz63X+EQ+zRH6R7aR
         IoLhQ6Hip33egtOCGe5g8lpSnTcFGX20yluAI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794737962; x=1795342762;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=8FdZmPYxVJRZwepv2ASwo7Gw6muFW4JO5etLfzKYWPY=;
        b=eXp0q0FNZ0UMMpcGTe+R6h5EjVvQE9t+NS66+RJEsQoeqh8h92SVCQF1uEmLwuOo6V
         u8vUZVNgQ/pA/0ULwqI35BR1gYEe1KyHFytYVP7VtC6cMHSZixAgfcNdFVfjS5GlLO4i
         kdDrYJLXIZO08Sw7eMuWZm7xauifAdDyjbWDe4Om/Ex0YEsXvBlEqjXJYJUNbXidIx0b
         6FGjaCbulZzPHNwjHyc0z76W1i79ywK4nlsXcPPTqsTfs20B7BH85EQxJoBwXo7kZdpH
         GIiMTzdJdf7Q7d7Ig2Dbb+xcUoA/jeQzV1tAjC8wUSalph1fKYljqciAOJyuWynv9EL4
         yHFA==
X-Forwarded-Encrypted: i=1; AL+hErHxTrsBJav/FqjB8ELnJQIJ7zR+yEsarDiBol/RI9OmbKl3br50IxTgz6JAvY62UqoCkeS8Revu8JIlr3NyC70=@vger.kernel.org
X-Gm-Message-State: APuU4Z8BxX08QucX1NPnisN1us2ioM4s9LvpXWVQ5jJQmM7d5WS9yj3V
	pdYtIjbCKIu5ybJVxi4mOoLASp5hRFxf91gLKC5UuqBR8Xf8SRUxSZ70w3erwh7b8Q==
X-Gm-Gg: AYBFou2r7ma8bibmTJH686psqvsD6+7pDf4pe3gWb9/3ntTZiHPMTG00F3IUkljeY5U
	t+9woI+4XRrjfEKPXWNty5nXvskwoiw1Fd6nFHHC4VxmkIOj7FvIOYTkp3RHrC859RSYea7GDAV
	0iADxLyxnWgyiRGB8j55/c15/eV8Sz8Qk1DBJJ6oViyv3/nPW1sR9b0v8yd5dguQ7hPqeoOXFst
	HQi+ljrdE2NMu6aaJOS9U6Q0bCJ4JEicWUJccIFMZV0bJD2g9CDpEu/P6wKjZDREDqvYR0i7nYq
	XDZO7BMuudEEPffgQ49UraxFaXjOtSAsf3NrRTemEJVDVpq3bAE/2N7qPJxu9LydBdgkyMHLSU1
	mc1h3AiafuZ9Fn95HCV1VhzPPVg2ae9dxqNd5uo6vJzaCZDIXA58NnGRtHag2aSS4a2gbGlu1Ot
	jR/WGQ/dHKA0y52svTSqLzT81AzFMIAzQJZi7pbl94PFIi8VYa5EGzlYArSsS0SK4bU2nHYuMbJ
	TFDXP1ve7Ck9XXbbT7/QQ1MfRyZD8viCDGopMEQA2C21QxTUjXB+JS8QRUhXUoMzR6ooToWTPYi
	t6QFC3myJc9PSZ1xmqy+Pb9bhjlYaDC9ynpN8q+9jAcw/qXJcLhfIgNQFMvxMh7OuoCWqnO8QU9
	u
X-Received: by 2002:a05:620a:4449:b0:93e:c12c:9dc4 with SMTP id af79cd13be357-9494bc9296cmr1274673485a.68.1794737962445;
        Sun, 15 Nov 2026 02:19:22 -0800 (PST)
Received: from mbili.waya ([64.203.83.2])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9494c6025f5sm592337085a.5.2026.11.15.02.19.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2026 02:19:21 -0800 (PST)
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
	Jiri Pirko <jiri@resnulli.us>,
	Victor Nogueira <victor@mojatatu.com>,
	Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH net-next v3 3/4] netfilter: nft_fwd_netdev: drop the stale dst when steering to a device
Date: Sun, 15 Nov 2026 05:19:10 -0500
Message-Id: <CORE-9NOG.v3.r0.20261115050625-3@mojatatu.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <CORE-9NOG.v3.r0.20261115050625@mojatatu.com>
References: <CORE-9NOG.v3.r0.20261115050625@mojatatu.com>
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
Release the dst before the device switch. Both lookup inputs the neighbour
transmission needs, the device and the nexthop, are supplied by the rule,
so the route dst is never consulted. Without it the queue drain keeps the
parking neighbour and the frame carries the configured device's addresses.

The release goes through skb_dst_drop_keep_metadata(), so encapsulation
parameters a route carries are handed over to a metadata dst instead of
being lost, and a metadata dst already on the packet is left in place. If
that copy cannot be allocated the packet is dropped, never sent with the
stale route.

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
v2 -> v3:
- Add the Reviewed-by tag from Pablo Neira Ayuso, given on the v2
  posting of this patch.

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

