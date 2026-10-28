Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793221182;
	b=D2eeHNcELkqEBkKaZ8br/0xu2whGdXw850cXsNhR3apZlq8FwXufDTS7/GyOts5+6Zmz
	 Kfnxr2XoXyjqyWGcqj9gkuXkYR/DfdzAj/TmGOHlWS5SAOkt8j090TO94PRy8qu8IyhOx
	 pwhRpdN/o+qyeFuvNFAyOM1ZffLZGYX2aNLRDxqX0mNvUb6B4a264BNMX2B6y25hdgzcA
	 MYjtaPYCgSDCnyhv/ihhTbW12bNIubcuCMrErXAoDTU9esbH4QYBimTWEtgcKg1mrgRzD
	 8lw6OT6Uu56lRxwUA7nXeI2BVsQfSqM/qEIOdpfIZwk3GB2aMIU5SNvEFaUjwkGQFHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793221182;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=qaQSYGMYJjRHdqv1JNYADQndewpgit/Om11IjQW+ZUk=;
	b=IRZXNoQXJsofC6J/yHT2WTyG9mZB4FG/7T9RJ+upaXuCT+CV65WJ5AXzVQ3ozKUF5kLs
	 p7I9YFFeLxcne3HEkckXGWEIZbQ0NrtI7I3ytXO3imt0ktjZ1A+wqpTjomEAQl3GBvnJf
	 +/he60WCuiwRDhBmnhzTOQh+RS/tLh2dMlKhf4UT34xmOMjhuLGHbTr2PJIDFnKidK8Dm
	 ZSLMulL6Dk/5zU0vbhu2kQVSPxMua7BlzJooDGPzAX+p6AIL75+gxKlZdvlU4N1qaxOBa
	 sBltQfFUpnKDuYR1jkA/nbj3QMITosOaJ91FnEqQO/IeUvP9HuroUp0g3TpgSuPeueQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=u5QKoSGG;
	arc=none smtp.remote-ip=74.125.82.48
Received: from mail-dl1-f48.google.com (mail-dl1-f48.google.com [74.125.82.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51B21606A31D
	for <netfilter-devel@vger.kernel.org>; Wed, 28 Oct 2026 20:59:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 51B21606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=u5QKoSGG
Received: by mail-dl1-f48.google.com with SMTP id a92af1059eb24-1846bc43c28so1731203c88.0
        for <netfilter-devel@vger.kernel.org>; Wed, 28 Oct 2026 13:59:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793221181; x=1793825981; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=qaQSYGMYJjRHdqv1JNYADQndewpgit/Om11IjQW+ZUk=;
        b=u5QKoSGGKa5FcFqgzz2UgIWYWG2ytJgfO8emLPx2PdBSUJgRSZ5N50PG1CpEZfhRQx
         6nui0Ola6WQcunlDZLYRaLZ/2f/KoyJCo04OokKdxpFPaDvjBbC14iTopLpDIygIS4uL
         QSoGW/1kajxzKQrjTwe/04JOgas7wR/ROxlYVOt+upOmoaLrALsDZxElpL/v2pmsjfNX
         jAcEH9dZEairz3P9fCbq36OxGAt+bWhWv7OSP2V+/rIyV0TahtJsQMBleeuHQJKnmAf4
         OHSKPWcs9nfzUp7REDuP53RbFPkfDFZw3ywxQydWfMM8NElPvdtcaPC43iMqbq3GbiJY
         zD+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793221181; x=1793825981;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qaQSYGMYJjRHdqv1JNYADQndewpgit/Om11IjQW+ZUk=;
        b=p5fQdi+TozCoSX8j19aBQ85ywFWaYoAJr2Svknrq/WC5b4xeAQdkHzM0NKtxrKvyBd
         7Id8qtPVWKCzI1uoxhgBq08hbD3vY4u60eVcY4BrdL9mQ/5e8tMQgG9lGowI8IJUhRyX
         aER5Yy4Sl6Qs60+2bBaAKZ0v1FGPbdMoTNu9gqdp1yxMaKWM5B1R06/eq/NtM4YyxNeC
         lIGsVX+cR8oA/0MfrwdPszLWXCw20HKcUyUVWCKtphBBd+DZAVTUwG2FNOKcp/VHtsIb
         Yn7RGtwFULMaIxlL1yQFBUYpB2pXkntVHTY6fFnh09LKz/NU61jHWEj13g5OyZWgPR2X
         IYrg==
X-Gm-Message-State: AFq9FYJr9MZMXM/s554TRcdcN5x58I8plpflHlrsS7gyNmzZVVgg4fMd
	JfgJQiK0BchJr7xJa1NMRgx25Fh4N7vQ1HElpqwYWcx53hgbd6xXRwfSaM0xVpsq
X-Gm-Gg: AYBFou189Iv8HxRIxFKYzLCWeMIkzhEzrnh08le8NqjZVBr6VZHJKl4n4v1f8q2KtwM
	gL29g4wOjq95IF3JYbie5sNw2xIUteT6XCpp+D8+/IykZfuRPL34q6Kmn5oScF0ozxceiM0LVav
	H32jvEZSPRGPsLiYXcibRLI2/douEp5YZght7ErU4L4xvh616S18BnLeagESfMO8ucC3fM7782V
	3qxRdVyhAOssE3YRnn+IILP6miEUOLc5igr6/TSWlaIXKgQt8Im54hSaa5CbvlubyP9IlP0OVK1
	0CAX+Ajg/wkzTp8VgTk1iA0m1Va330yBsJjgD30zEe4r7Hpn9SVVXipJ4Hx8yZMjv8vkjwnZ7wv
	RQ8p4GWZaQukgQL1ccfyeal8B7WLi6Uf85cQJ93WrL3a+BhXlbfkoO3F7mtUHQKYr3myqBLfUGY
	fVL8vi2OLcI4Jw1mKofY4lgLkNAkGA0zRsqE2XojITD5FkofJtpxPGmGahQD+L9SPGgv18r34sk
	b/qlIg59Ke681PeJLQ6LJnDDgWunMHaUFByZnSnVRkf4IHjstquX/DNYm7PajlFQVhXjS7yaBqP
	IzV7oS6YIyZKwr73y496LjUNinTacaFzIextz+4KDkLcyFAURJttU8SzoJVtm5sCG2E23YsfolB
	2
X-Received: by 2002:a05:701b:4583:20b0:185:b157:f271 with SMTP id a92af1059eb24-1a6ce113ee5mr4231317c88.23.1793221181020;
        Wed, 28 Oct 2026 13:59:41 -0700 (PDT)
Received: from samniyama.tailbcd61.ts.net ([76.20.4.3])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1a75d76814bsm7954568c88.10.2026.10.28.13.59.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 13:59:40 -0700 (PDT)
From: Koral Ilgun <koralilgun@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Koral Ilgun <koral.ilgun@adtran.com>
Subject: [PATCH nf] netfilter: nft_flow_offload: do not offload multicast
Date: Wed, 28 Oct 2026 13:59:38 -0700
Message-ID: <20261028205938.662312-1-koralilgun@gmail.com>
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

IPv4 multicast stays out of the flowtable only because the reverse
route lookup in nft_flow_route() refuses a multicast source address.
The IPv6 route lookup has no such check, so IPv6 multicast that
ip6mr forwards goes into the flowtable.

Skip a multicast destination for both families, so that the result
no longer depends on the route lookup.

Fixes: a3c90f7a2323 ("netfilter: nf_tables: flow offload expression")
Signed-off-by: Koral Ilgun <koral.ilgun@adtran.com>
---
Tested on an arm64 router with Linux 6.18.54, with an inet flowtable
that offloads forwarded flows, and IPv4 and IPv6 multicast routed from
the WAN to one VLAN. Without this change, the IPv6 flow went into the
flowtable after its first packets: the ip6mr vif counters showed 25 of
1,500 packets, and the receiver still got all 400 packets after its
leave. With it, the vif counters showed 1,500 of 1,500, the flow stayed
out of the flowtable, and the stream stopped about 2.5 s after the
leave. IPv4 multicast stayed out of the flowtable before and after.
Unicast IPv4 and IPv6 flows still went into the flowtable.

 net/netfilter/nft_flow_offload.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index d3c5651dd699..1fc755e594b0 100644
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
@@ -35,6 +36,16 @@ static bool nft_flow_offload_skip(struct sk_buff *skb, int family)
 			return true;
 	}
 
+	/* A flow keeps the output it resolved at offload time, but the
+	 * outputs of a multicast route change when listeners join or leave.
+	 */
+	switch (family) {
+	case NFPROTO_IPV4:
+		return ipv4_is_multicast(ip_hdr(skb)->daddr);
+	case NFPROTO_IPV6:
+		return ipv6_addr_is_multicast(&ipv6_hdr(skb)->daddr);
+	}
+
 	return false;
 }
 

base-commit: 734bef548a96e8774d6eef5dfa2026c6edc4e80b
-- 
2.43.0

