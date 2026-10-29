Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793311308;
	b=OxCqORTr1oVa2ZDof++hz+RDlRVbNrBnU6MRm+ACeEutZ2oS+YH3KOX6aYdgbXHuxDF1
	 Wt9qebXyDwqgL8B1nT8o+skZYvVrF2xJhuUUPy0VA1uoa5bap2EUgmunkhBHgYB3Mh7v7
	 Zin4EzWm+vtJNEv60avyCX6sYjaCBtNu/RRDpAAw8btWFIgD7bK5DEP7OvhHsBtXU26ks
	 rHDUcdgybyHYNLgvEC8kLaFbxLLNSIWhpANr+SkZxXmElt/pZuSAqzBjHgWCvU6exwJEr
	 m1vQY5fXo8OTqdsLG2W6zobe8NOSLLsaS3ATeDG69Cce0tC3OwzPU/d6l+3Hc+XibEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793311308;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=8Q/lW9fQYT21QznHQjvJzPQJl55ESH89M5aAdKeZYiU=;
	b=GOWAkP7PV3+TeqvJGgx2ZPjxBJFRnmD5F9fvJadyzVlzMr6DAqBqYlH1SEbRjc0PPeNf
	 zLp+4OarHHfj7OYVKf1CDfYbv/cZ5qeLwXdC0qQ8AhxoBkGsrfvRVlnHBYTpPcIQHyhEU
	 UVhIb5GyQGRXzxX8VpEVzM/zXg7xVvYEvKmpp8aus85YczkHn9KGrs7tpx8QHlm9176AB
	 pHBAecURgcAio/y9he9KD849oZ0lCnyR7wVg15NMvaVbancYJsdg3+af5XHLhbhIRJdBB
	 sqwKARWCOhGQbsZond9p+rRQhBDak4aWQ4b8XEFawjybhVvR+WVGVCLNc/1ABm3Cydg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=HCAjDS8P;
	arc=none smtp.remote-ip=74.125.82.49
Received: from mail-dl1-f49.google.com (mail-dl1-f49.google.com [74.125.82.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6859E606A31C
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Oct 2026 22:01:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6859E606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=HCAjDS8P
Received: by mail-dl1-f49.google.com with SMTP id a92af1059eb24-1931ff67a29so123301c88.1
        for <netfilter-devel@vger.kernel.org>; Thu, 29 Oct 2026 15:01:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793311307; x=1793916107; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=8Q/lW9fQYT21QznHQjvJzPQJl55ESH89M5aAdKeZYiU=;
        b=HCAjDS8P9gVEmar346ebcMBuz87gARxPe/xf1qL6qqUQlhBC7UJUe7jLP9vJ6TJlKg
         aM/BfEfx/2F5bUKpkKM1Uyuq9rP33tCJmw4gTpTVBll16BqX39cSCskD5GmBjIjffrZ9
         2Bn8j+XR2vPmB5dQpovdQA87mUbQ+k4bmLF/+VisJ7d3RVvWRs0UqjIm4JwmxwhB2jCx
         PNrLJLqcVuRt2v+jvb0kri90HYfx9o8eSuAy2N3pE+DpBA32DiHNvaixs19DWLB+jI/9
         cs/dAolV6c01s5VO6/HXw78jtPSDFB/C2ZRs4J8Fi6WcWHR4PrBIq2IO77HrnkFg/FnG
         4iXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793311307; x=1793916107;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8Q/lW9fQYT21QznHQjvJzPQJl55ESH89M5aAdKeZYiU=;
        b=li8N8qf7IgIrK47vbdr/Y5/IOKBn0faaozzyVqaliAqTpGepxKhA7PQk8LzcuOWyn7
         7XLUm6QRowfQAWmg+UqA70MY0KtYNQ7fpO3yjlyceVi7NzZ3FJunBHda5Fyp6KFLKObR
         bDVO8M1Zm4UXJpbOxF3Ezwi0IJ1AxmyqJ+6G2XqfrDj9I0lW+UMcPJMsELgsoR1gY6gj
         6axjl0VeIuww2sxEXicdXJ5JEr3NpqA6XHv4Q0ntrAT1deLWaoVP/jMho7XMIUeKTD3o
         tbxljau9GKZw0vMqQu7LU9YQwpno1eXTPo9v5DoYhnW/O32xqzlMUCSOJlQsPXZDaBMj
         ru4Q==
X-Gm-Message-State: AFq9FYJ7p6+h01Z32y0AOcdwBywKp4H8EWhUhATHMAXndFVnqiVZi1W/
	JPE4OErNZjMJYyp4Cl8kZOGdzWujUKG2w8H59eZZASkAaJ0aYyJprdRxJF+MuWHn
X-Gm-Gg: AYBFou2MG91haD6RV6Tkp3R6pIICKctZg1X/o9lvnC/vndYfpUMD4EpFrJi9L35EAfn
	VrnvV4J5igNkmdItSiUWVrfdZbuOWcHbrGI7P8NzRh0NbbzXQ5RVx9okRDIAuz3xWNswuGP8slY
	7Px1DDumHEG9GblaFkPBKWw2gVz2KnorugLEaoUUZRve1/mOowb3CmaKUsrlSoRbyfW3jTXpB6n
	4S86TsH06bcd6+cebc3CemmPemdNWngb15pEG7IHV8D4tJAtDOqMsP/yT1vaJsa7+lUX1d0C3/E
	OONuDKV0DL2ahBaAVYh1+odMfgnREwohC/1DTC5l2dUAcWZ753Dfp9OeLtOlBslBEOwYD0cUYzI
	wk+KC3wdRfxNKJYtINCjuGCqiqbswf9rKHKXyOslOuhWwUc8lWWYdyJu0GQ6FfTu6cXf74Q5X3q
	QnSZ97SPrZrGl1xL4TLib9yMYmA3CPIL5mUPJkJqqAFCal27oExQvdiKpJrcH0cVZ9kJWuYw1dG
	cteS8nMhvKJheulzlzsmA477LQF9es3JX24bj6Uexrht3bWnO7zlIWTZksEv8rEBvLGcMdRVLNT
	VNzjejvrWeQEhWmTWWSFRopSBHiY41jry6tu4eUxjeiPdUOpe9QSshva/55jVBoRx6x/MJN62LB
	k
X-Received: by 2002:a05:701b:4589:b0:187:eb7f:bb4 with SMTP id a92af1059eb24-1ac5d88c4e4mr385234c88.46.1793311306922;
        Thu, 29 Oct 2026 15:01:46 -0700 (PDT)
Received: from samniyama.tailbcd61.ts.net ([76.20.4.3])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1ac1abcd6f1sm1314661c88.20.2026.10.29.15.01.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 15:01:46 -0700 (PDT)
From: Koral Ilgun <koralilgun@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	fmancera@suse.de,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Koral Ilgun <koral.ilgun@adtran.com>
Subject: [PATCH nf-next v2] netfilter: nft_flow_offload: do not offload multicast
Date: Thu, 29 Oct 2026 15:01:44 -0700
Message-ID: <20261029220144.2474139-1-koralilgun@gmail.com>
X-Mailer: git-send-email 2.43.0
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

From: Koral Ilgun <koral.ilgun@adtran.com>

A flow holds one output per direction, which it resolves when it is
added. The outputs of a multicast route change when listeners join
or leave. So a multicast flow in the flowtable continues to send to
the output that it resolved, also after the last listener left, and
the counters of the multicast routing stop.

A ruleset can keep multicast out with a match before the flow
offload statement. Without one, IPv4 multicast stays out of the
flowtable only because the reverse route lookup in nft_flow_route()
refuses a multicast source address. The IPv6 route lookup has no such
check, so IPv6 multicast that ip6mr forwards goes into the flowtable.

Skip a multicast destination for both families in the flow offload
expression itself, so that the result no longer depends on the
ruleset or on the route lookup.

Signed-off-by: Koral Ilgun <koral.ilgun@adtran.com>
---
v2:
- Target nf-next, and drop the Fixes tag (Pablo).
- Use the shorter form that Fernando suggested; the result is the same.
- Say in the commit message that a ruleset can keep multicast out.
v1: https://lore.kernel.org/all/20261028205938.662312-1-koralilgun@gmail.com/

Tested with v1, which skips the same packets: on an arm64 router with
Linux 6.18.54, with an inet flowtable that offloads forwarded flows,
and IPv4 and IPv6 multicast routed from the WAN to one VLAN. Without
this change, the IPv6 flow went into the flowtable after its first
packets: the ip6mr vif counters showed 25 of 1,500 packets, and the
receiver still got all 400 packets after its leave. With it, the vif
counters showed 1,500 of 1,500, the flow stayed out of the flowtable,
and the stream stopped about 2.5 s after the leave. Unicast IPv4 and
IPv6 flows still went into the flowtable.

 net/netfilter/nft_flow_offload.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index d3c5651dd699..530e20c7fd45 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -10,6 +10,7 @@
 #include <linux/netfilter/nf_conntrack_common.h>
 #include <linux/netfilter/nf_tables.h>
 #include <net/ip.h>
+#include <net/ipv6.h>
 #include <net/flow.h>
 #include <net/netfilter/nf_tables.h>
 #include <net/netfilter/nf_tables_core.h>
@@ -33,6 +34,10 @@ static bool nft_flow_offload_skip(struct sk_buff *skb, int family)
 
 		if (unlikely(opt->optlen))
 			return true;
+
+		return ipv4_is_multicast(ip_hdr(skb)->daddr);
+	} else if (family == NFPROTO_IPV6) {
+		return ipv6_addr_is_multicast(&ipv6_hdr(skb)->daddr);
 	}
 
 	return false;

base-commit: 734bef548a96e8774d6eef5dfa2026c6edc4e80b
-- 
2.43.0

