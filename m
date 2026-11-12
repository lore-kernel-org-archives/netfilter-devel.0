Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.175
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794516064;
	b=gA4HHvzAl4AqjGgiegswv8N3TpEbjVsuEwcbXbS9vpto93NmM+nlY1KH2R+xbRx9tE1X
	 fURAPWSte+6JkCqyiGiXF8HgHqBuNdKBKN/mDCp71C8MvXq1xZ2BncSr/Va3h5ZQpA5e6
	 CmWY15fKK0TKnBYaahuy7V1fJ96TnGVPRAXNPIO0oljzWvzgJUOGGHr7DrmR9jq3XN2o7
	 i6zM7s8ux9DywMd1vBWd4VLtXxv/6UWxXxIIhKVj9bkiCjz0B0RD/t9mxPBdWuGJ7c1aI
	 ifNnP8MdlkudPrnR0kkZ1gWlmzg4PQYcLZ12RWHK3H/Iyqjm8sJ2W/UTFyxWnXr39UQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794516064;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3Yb4kVEFgMEgPKm+KoyaP1A4M2GZljeQjc5uyGS7RaM=;
	b=rBbdab0Y0xJQACvXIuBXXJ0yWgswcI0+nNHMfaOcVnDONnrKQBRKk1JaROE9K7AVUIpA
	 9vPoQ69qysQ9ldA5Tr8Rokx3DRX6tqFS/TeX/NFAIc8fit7Cyd9NBkWyrTzgUQ49sESXr
	 /KRNnoNfF/Pzb8IV95nW1xGOlwtx0gE8so8bW4x0/j+xnwhFUVR1lmzSX35BYYiYVt8N0
	 VCrc2D50v8JEJMHB22Rn0rQp57mxFdLab/lBtSv4BE9uHEPv0bEfeY/GTRJuyiyLvFcV1
	 GPFgRsc9Fmo/opCm4Y+drYPZ0iltRwn63qRGj8KU6sVSkmJz7uIOeUHqly5CAksDjCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=mojatatu.com;
	spf=none smtp.mailfrom=mojatatu.com;
	dkim=pass header.d=mojatatu.com header.i=@mojatatu.com header.a=rsa-sha256 header.s=google header.b=LnqU7fZZ;
	arc=none smtp.remote-ip=209.85.160.175
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ACE3606A335
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Nov 2026 20:41:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3ACE3606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mojatatu.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=mojatatu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mojatatu.com header.i=@mojatatu.com header.a=rsa-sha256 header.s=google header.b=LnqU7fZZ
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-5365f9a04c5so1747331cf.1
        for <netfilter-devel@vger.kernel.org>; Thu, 12 Nov 2026 12:41:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu.com; s=google; t=1794516063; x=1795120863; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3Yb4kVEFgMEgPKm+KoyaP1A4M2GZljeQjc5uyGS7RaM=;
        b=LnqU7fZZmWIwa5cGC7/3ZZfwKcvi/O6kUXU+kXsJpqk3FgtXw2cS1ZI3L6stI+6N1t
         JSwtn2NXkHxrTcnkOQ8745vdji2oUdnv67cQLQQYFdWKqMrRjHWeasbX8hfn5cSQNw2i
         3gVgn+/BuE9ZhWUAPhVFfDoqL7wf5A6LH7MCE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794516063; x=1795120863;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=3Yb4kVEFgMEgPKm+KoyaP1A4M2GZljeQjc5uyGS7RaM=;
        b=cAhXcvgCMB4rEag30z195WSPs9UrTiWMDWBQFVEFbSFOpeq7GLRiPYLngDPgccgMzk
         XjyfbVeHfcAvZ7WOzlskfJyMoYlrIFjoCfNwe0707PhoPfVu9lCytpGf/HJGm4PorTWr
         IXQ58zhK+CO98TrsPwQYRF6k0gqwmVd1bgCtJ//F6sWL1XqJiKYNXq+udX91rcISmXqL
         iCfIx+6sQ04MrRtk7NCY1afdIezdkfeLP2S87w7lXCpINIxjGN8E0TqVVqDb29BovzsM
         qUNlHgRmyj4DRO5wcrmUBui58nIub4wIsyMhwwAjxtS/sO8aPGnwk6/fZL4OIk8wxdHY
         cKlQ==
X-Forwarded-Encrypted: i=1; AL+hErEmE6TLrOBgmngJCWJMK0ESzz+hZpPgrYPFVvEg1ZDZnznkPw74SJZw0Hvcs/Z3enNzYzKzyzHlCb//MuKMfe8=@vger.kernel.org
X-Gm-Message-State: APuU4Z/p51MlJIlP5DeiMmc74WP3yZ5UfOWuhtnoG6IFHTa+WlVSluKh
	BGoMaHa+vjpVsPMsUVunNad1aYfylpkARh+er0FuDUxRXlh7AV0JXSkmblEQJZvC9g==
X-Gm-Gg: AYBFou3ggLcoSCLo78DF3otp3sWOODjD7qlTJknsgifeDn9jf0LhL8YStVbQ5DWdD9v
	jXwLmFCtAPO6BiWS1czYz/k1fjGeaJYLReIB4yJQPhAjvdKXx/A2xe4IIT6D+K+kSYdWnPqoKuX
	tP3VQF+hYGd1Ef3PS37pV+XFp5flJKu+//2tjvLFLANkLE3y3H3KTp73I74p/ufRPDnlv5ccOyA
	cGpHWHPWT139H1gZG/o6EPNVkrA64lH5N/ef4e78hZ2C4QZusFw0uVbJD4LtyXuCySXvCDybiX8
	Oiuo9EuGGUroYWJvKnoHqBF3YMxHjK7mJmE26xTYYsGTXbw1+4mjMugSeyceH20LaZ1XL/CwG2w
	hvDnRUnZHjBxNPRwchDWoVnfQDmFRoPuY5bUiO7dCTYeJ06AsexGdGjrbZ44YNkWVgvvxNL1x9i
	/0GFKgUqExOJ/PboJKvnFxGWk/AbJKKMlk85t1el4UXEhomQzl/VIAnm4wFSj/r1yoGkYgkUUc7
	oEvWQ/G4tB+JTDO+/JVMIK89sSmSb58AhQucryjSw3fzWiN0rWnm2+VD2ZNnnVwrsXPSZaAUDYo
	LgyQWr30hcG5thpxcGQFleDY83YSo93Qclh47eiNRv0FZCUwU7B8tL40kKRKh9CY3+iG3y4gfEc
	=
X-Received: by 2002:a05:622a:229e:b0:536:33bf:7bf5 with SMTP id d75a77b69052e-55ac8895596mr9023091cf.29.1794516062959;
        Thu, 12 Nov 2026 12:41:02 -0800 (PST)
Received: from mbili.waya ([64.203.83.2])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91f23d61888sm4452116d6.20.2026.11.12.12.41.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 12:41:02 -0800 (PST)
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
Subject: [PATCH net-next v2 3/4] netfilter: nft_fwd_netdev: drop the stale dst when steering to a device
Date: Thu, 12 Nov 2026 15:40:48 -0500
Message-Id: <CORE-9NOG.v2.r0.20261112151659-3@mojatatu.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <CORE-9NOG.v2.r0.20261112151659@mojatatu.com>
References: <CORE-9NOG.v2.r0.20261112151659@mojatatu.com>
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
Reviewed-by: Victor Nogueira <victor@mojatatu.com>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
---
v1 -> v2:
- Do not drop a dst that is not a route: a DST_METADATA dst is the tunnel
  template a tunnel helper attached to the packet, and dropping it discards
  the encapsulation parameters.  Considered comment from Pablo Neira Ayuso.
- Keep a route's encapsulation parameters as well: a route installed with an
  ip, ip6 or xfrm encapsulation carries them in dst->lwtstate, which a drop
  would discard before a downstream tunnel or xfrm device could use them.
  The dst release now goes through a helper that moves them onto a metadata
  dst first (new 2/4).

 net/netfilter/nft_fwd_netdev.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/netfilter/nft_fwd_netdev.c b/net/netfilter/nft_fwd_netdev.c
index a48c2f765bba..3f2ffda1998c 100644
--- a/net/netfilter/nft_fwd_netdev.c
+++ b/net/netfilter/nft_fwd_netdev.c
@@ -14,6 +14,7 @@
 #include <net/netfilter/nf_tables.h>
 #include <net/netfilter/nf_tables_offload.h>
 #include <net/netfilter/nf_dup_netdev.h>
+#include <net/dst_metadata.h>
 #include <net/neighbour.h>
 #include <net/ip.h>
 
@@ -159,6 +160,11 @@ static void nft_fwd_neigh_eval(const struct nft_expr *expr,
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

