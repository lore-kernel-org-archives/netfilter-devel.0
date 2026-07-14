Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0F303B895E
	for <netfilter-devel@vger.kernel.org>; Tue, 14 Jul 2026 03:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783999336; cv=none; b=SELwzRBL5p1Y9YBR3JhD4zCMHcndCVJHsFW8cesPJ9Ng+QHMSkydbtTm0aNQtCj58/brVS3QfaTDBuCO7lj/kdFHHe5VdBCaQL3Kh6L38TtMCwWD8PpkUUQ1+igwQQExXOMit/TnBTEzvA6dflJeZiPCmKurOyc0eo/ThL2b5uI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783999336; c=relaxed/simple;
	bh=eBS2/UCPUQ6+8V6OTgVzup444Pe4czSkA2Syz7+RS1M=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=VJ1xvfUO6jXGAfBVw+DccrzFkHfL9IHJwyhjrzTpDuelXlP5NMhw3f8LVHKdjX0bScnS7JM07njc/7ATueb9hcp3M7qFzy6yhQR2WrFb78mo1V8E9OLUqUKMHcArK6b5B7uK/9tpyKq8Kcn46Hg8qbrNPO1sJ6ZKsvPlKv2sKF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FzyyjIV4; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FzyyjIV4"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-383b4a3755fso463551a91.3
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Jul 2026 20:22:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783999334; x=1784604134; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=5RlpC6pS3D2JC8KnQchimNr9oFVPt7c8UwtX27SHkOo=;
        b=FzyyjIV4aXvuAhjX5VmqSaAffcwjCIS4S3SCEjGKWmAwNgVu366WSSzbjQe8J86F6z
         Y4/4osgN1n5S+8yNnUe8/pr/22HANzboAoVsQttBExon+bU4iOe64BG/0S/I0nANQau8
         CyDlKcHfYSCxowakeB5sYyo0/TIKUEdUhVUAWCM/e1bx8JNRaFfraXz3hN3XELMB0/u1
         qs+OjBTms2Rn+PsAcLrYAHfuZp/ySN5xFoAg6193Ha7yc27rVW3uMkythV+hSWk7gX16
         DNxfUltQrLAlE/tvsGmZN6KWyn04qz7Or+VnX4zRQQ8+8nZW8BWLIQCUPdqJejXq4NWC
         C05A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783999334; x=1784604134;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5RlpC6pS3D2JC8KnQchimNr9oFVPt7c8UwtX27SHkOo=;
        b=csvvRTGPjVgg/QwQZq8XUFpN9IWcmXStdxJXhbCPq26CcRRXuUDtHCBX/ujv919yPv
         SbsugSG5bO2LQirHtL1t7r69j8yIdNNdx0ONF74kL376uX8Ge+m0Wig7EbJBkhHnHRa0
         Cu+yOQHDBT+znjdgitfbCPbwu0bVUmaeWc+YhAZDDixV0vEl88o7+64cSH4y16Kg0hSp
         Vb0zO8bxjYPv7YY6X4q8M5l6P+xHsEzGpGy8L5h4E9rWojHo/qqryQ5cYvuEN9KzQHoP
         8/JAePNCMIklUvrfgAWJ0a8AE0HOHjShNlwxAAADLqcYncSDUWaPPsZFgKlBhX4rDqs6
         L13g==
X-Forwarded-Encrypted: i=1; AHgh+Ro86diYqtv2nkEZIB7A2cXX1PF7uzKCNmwkaP10zjiN5dnJH73T1UUqdF+oCoMMI2OamvxhTZrk+RBjAi3zTCg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzlrEinfNF9YbDi/jvU5hQvqmC1H4KgMyySMEX+f9DjGfiB7/GH
	m2NqJKufVoo6KM6SnmqKUZj1l0pbsL5tAQ+JHQZP1qtfOJmqw2Pj32og
X-Gm-Gg: AfdE7cnWnVgZDn17TtIPHVtigsv63BaYWfcWg2GfJzxse80HCrzOwDhgs5NzFbRxq3x
	394vTgLgEotnuI/pmfiOvp0MIpw/YPqZZkP525/8duVVdzHW6XwoY9YzZGz0v4spnHUUeckf5C7
	rdNUArBA9acM+jsccqOKZhTras2ml5UZS75pEyU0b7A80uy5V9FkONgbvNHmzQ3ktyGXh23QfdL
	GK0t/9FkowA6SWpS7ss0s5NX+nnp2npbsn+//PoAcN42QbLhMRd2zwJKrFIXeffrr+hwhq5TEaa
	gsCuHj3oFU0GSO/1rp+eQwqA4DR4yQ8TesxjsJTQZ4mpygvaI97fzmfWzwisdxHAxXZK/ilX9Pp
	gmXg3BbaU8K5H6E9bAXAVqWr3aoFUq784jyedwXbbMDCtRGmYWwnsVoL92yo8ynhKRVjHYa1YaZ
	0Wm9TnB98n55S1OOsr1oDe
X-Received: by 2002:a17:90b:540d:b0:37f:9ce1:cda8 with SMTP id 98e67ed59e1d1-38dc7752969mr10742606a91.30.1783999333895;
        Mon, 13 Jul 2026 20:22:13 -0700 (PDT)
Received: from c79ofce.localdomain ([204.3.140.65])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38e174442f6sm728635a91.10.2026.07.13.20.22.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2026 20:22:13 -0700 (PDT)
From: Zhixing Chen <running910@gmail.com>
To: Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Phil Sutter <phil@nwl.cc>
Cc: "David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	Zhixing Chen <running910@gmail.com>
Subject: [PATCH nf v2] netfilter: ip6tables: set hotdrop for malformed extension header matches
Date: Tue, 14 Jul 2026 11:21:24 +0800
Message-Id: <20260714032124.7042-1-running910@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The hbh, srh and ipv6header matches have paths that return false for
malformed IPv6 extension header packets without setting hotdrop.

For hbh, strict option parsing stops when the option type or length field
cannot be read, or when advancing to the next requested option would
exceed the available header data. Mark these packets for hotdrop instead
of treating them as a rule mismatch.

For srh, keep a missing SRH as a normal mismatch, but set hotdrop when
header lookup fails for other reasons, when the SRH fixed header is not
present, when the advertised SRH length exceeds the available skb data,
when segments_left exceeds first_segment, or when SID selector reads fail.

For ipv6header, set hotdrop when the advertised extension header length
exceeds the available skb data.

Returning false treats the packet as a rule mismatch. Set hotdrop for
these malformed packets so they cannot bypass rules intended to drop
packets with these IPv6 extension headers.

Signed-off-by: Zhixing Chen <running910@gmail.com>
---

Changes in v2:
- Use hotdrop labels for hbh and srh paths.
- Mark SRH packets with segments_left greater than first_segment for
  hotdrop.
- Drop the redundant ipv6header length check before skb_header_pointer().

v1: https://lore.kernel.org/netdev/20260709063012.33160-1-running910@gmail.com/T/

---
 net/ipv6/netfilter/ip6t_hbh.c        | 27 ++++++++++---------
 net/ipv6/netfilter/ip6t_ipv6header.c |  9 +++----
 net/ipv6/netfilter/ip6t_srh.c        | 40 ++++++++++++++++++++--------
 3 files changed, 47 insertions(+), 29 deletions(-)

diff --git a/net/ipv6/netfilter/ip6t_hbh.c b/net/ipv6/netfilter/ip6t_hbh.c
index 6d1a5d2026a6..1b5dcc92b7da 100644
--- a/net/ipv6/netfilter/ip6t_hbh.c
+++ b/net/ipv6/netfilter/ip6t_hbh.c
@@ -62,21 +62,18 @@ hbh_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 			    NEXTHDR_HOP : NEXTHDR_DEST, NULL, NULL);
 	if (err < 0) {
 		if (err != -ENOENT)
-			par->hotdrop = true;
+			goto hotdrop;
 		return false;
 	}
 
 	oh = skb_header_pointer(skb, ptr, sizeof(_optsh), &_optsh);
-	if (oh == NULL) {
-		par->hotdrop = true;
-		return false;
-	}
+	if (!oh)
+		goto hotdrop;
 
 	hdrlen = ipv6_optlen(oh);
 	if (skb->len - ptr < hdrlen) {
 		/* Packet smaller than it's length field */
-		par->hotdrop = true;
-		return false;
+		goto hotdrop;
 	}
 
 	pr_debug("IPv6 OPTS LEN %u %u ", hdrlen, oh->hdrlen);
@@ -104,8 +101,8 @@ hbh_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 				break;
 			tp = skb_header_pointer(skb, ptr, sizeof(_opttype),
 						&_opttype);
-			if (tp == NULL)
-				break;
+			if (!tp)
+				goto hotdrop;
 
 			/* Type check */
 			if (*tp != (optinfo->opts[temp] & 0xFF00) >> 8) {
@@ -121,12 +118,12 @@ hbh_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 
 				/* length field exists ? */
 				if (hdrlen < 2)
-					break;
+					goto hotdrop;
 				lp = skb_header_pointer(skb, ptr + 1,
 							sizeof(_optlen),
 							&_optlen);
-				if (lp == NULL)
-					break;
+				if (!lp)
+					goto hotdrop;
 				spec_len = optinfo->opts[temp] & 0x00FF;
 
 				if (spec_len != 0x00FF && spec_len != *lp) {
@@ -147,7 +144,7 @@ hbh_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 			if ((ptr > skb->len - optlen || hdrlen < optlen) &&
 			    temp < optinfo->optsnr - 1) {
 				pr_debug("new pointer is too large!\n");
-				break;
+				goto hotdrop;
 			}
 			ptr += optlen;
 			hdrlen -= optlen;
@@ -159,6 +156,10 @@ hbh_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 	}
 
 	return false;
+
+hotdrop:
+	par->hotdrop = true;
+	return false;
 }
 
 static int hbh_mt6_check(const struct xt_mtchk_param *par)
diff --git a/net/ipv6/netfilter/ip6t_ipv6header.c b/net/ipv6/netfilter/ip6t_ipv6header.c
index c52ff929c93b..e339cefc7fff 100644
--- a/net/ipv6/netfilter/ip6t_ipv6header.c
+++ b/net/ipv6/netfilter/ip6t_ipv6header.c
@@ -52,9 +52,6 @@ ipv6header_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 			temp |= MASK_NONE;
 			break;
 		}
-		/* Is there enough space for the next ext header? */
-		if (len < (int)sizeof(struct ipv6_opt_hdr))
-			return false;
 		/* ESP -> evaluate */
 		if (nexthdr == NEXTHDR_ESP) {
 			temp |= MASK_ESP;
@@ -99,8 +96,10 @@ ipv6header_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 		nexthdr = hp->nexthdr;
 		len -= hdrlen;
 		ptr += hdrlen;
-		if (ptr > skb->len)
-			break;
+		if (ptr > skb->len) {
+			par->hotdrop = true;
+			return false;
+		}
 	}
 
 	if (nexthdr != NEXTHDR_NONE && nexthdr != NEXTHDR_ESP)
diff --git a/net/ipv6/netfilter/ip6t_srh.c b/net/ipv6/netfilter/ip6t_srh.c
index db0fd64d8986..321c7f40a24f 100644
--- a/net/ipv6/netfilter/ip6t_srh.c
+++ b/net/ipv6/netfilter/ip6t_srh.c
@@ -27,22 +27,27 @@ static bool srh_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 	struct ipv6_sr_hdr *srh;
 	struct ipv6_sr_hdr _srh;
 	int hdrlen, srhoff = 0;
+	int err;
 
-	if (ipv6_find_hdr(skb, &srhoff, IPPROTO_ROUTING, NULL, NULL) < 0)
+	err = ipv6_find_hdr(skb, &srhoff, IPPROTO_ROUTING, NULL, NULL);
+	if (err < 0) {
+		if (err != -ENOENT)
+			goto hotdrop;
 		return false;
+	}
 	srh = skb_header_pointer(skb, srhoff, sizeof(_srh), &_srh);
 	if (!srh)
-		return false;
+		goto hotdrop;
 
 	hdrlen = ipv6_optlen(srh);
 	if (skb->len - srhoff < hdrlen)
-		return false;
+		goto hotdrop;
 
 	if (srh->type != IPV6_SRCRT_TYPE_4)
 		return false;
 
 	if (srh->segments_left > srh->first_segment)
-		return false;
+		goto hotdrop;
 
 	/* Next Header matching */
 	if (srhinfo->mt_flags & IP6T_SRH_NEXTHDR)
@@ -111,6 +116,10 @@ static bool srh_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 				!(srh->tag == srhinfo->tag)))
 			return false;
 	return true;
+
+hotdrop:
+	par->hotdrop = true;
+	return false;
 }
 
 static bool srh1_mt6(const struct sk_buff *skb, struct xt_action_param *par)
@@ -121,22 +130,27 @@ static bool srh1_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 	struct in6_addr _psid, _nsid, _lsid;
 	struct ipv6_sr_hdr *srh;
 	struct ipv6_sr_hdr _srh;
+	int err;
 
-	if (ipv6_find_hdr(skb, &srhoff, IPPROTO_ROUTING, NULL, NULL) < 0)
+	err = ipv6_find_hdr(skb, &srhoff, IPPROTO_ROUTING, NULL, NULL);
+	if (err < 0) {
+		if (err != -ENOENT)
+			goto hotdrop;
 		return false;
+	}
 	srh = skb_header_pointer(skb, srhoff, sizeof(_srh), &_srh);
 	if (!srh)
-		return false;
+		goto hotdrop;
 
 	hdrlen = ipv6_optlen(srh);
 	if (skb->len - srhoff < hdrlen)
-		return false;
+		goto hotdrop;
 
 	if (srh->type != IPV6_SRCRT_TYPE_4)
 		return false;
 
 	if (srh->segments_left > srh->first_segment)
-		return false;
+		goto hotdrop;
 
 	/* Next Header matching */
 	if (srhinfo->mt_flags & IP6T_SRH_NEXTHDR)
@@ -207,7 +221,7 @@ static bool srh1_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 			  ((srh->segments_left + 1) * sizeof(struct in6_addr));
 		psid = skb_header_pointer(skb, psidoff, sizeof(_psid), &_psid);
 		if (!psid)
-			return false;
+			goto hotdrop;
 		if (NF_SRH_INVF(srhinfo, IP6T_SRH_INV_PSID,
 				ipv6_masked_addr_cmp(psid, &srhinfo->psid_msk,
 						     &srhinfo->psid_addr)))
@@ -222,7 +236,7 @@ static bool srh1_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 			  ((srh->segments_left - 1) * sizeof(struct in6_addr));
 		nsid = skb_header_pointer(skb, nsidoff, sizeof(_nsid), &_nsid);
 		if (!nsid)
-			return false;
+			goto hotdrop;
 		if (NF_SRH_INVF(srhinfo, IP6T_SRH_INV_NSID,
 				ipv6_masked_addr_cmp(nsid, &srhinfo->nsid_msk,
 						     &srhinfo->nsid_addr)))
@@ -234,13 +248,17 @@ static bool srh1_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 		lsidoff = srhoff + sizeof(struct ipv6_sr_hdr);
 		lsid = skb_header_pointer(skb, lsidoff, sizeof(_lsid), &_lsid);
 		if (!lsid)
-			return false;
+			goto hotdrop;
 		if (NF_SRH_INVF(srhinfo, IP6T_SRH_INV_LSID,
 				ipv6_masked_addr_cmp(lsid, &srhinfo->lsid_msk,
 						     &srhinfo->lsid_addr)))
 			return false;
 	}
 	return true;
+
+hotdrop:
+	par->hotdrop = true;
+	return false;
 }
 
 static int srh_mt6_check(const struct xt_mtchk_param *par)
-- 
2.34.1

