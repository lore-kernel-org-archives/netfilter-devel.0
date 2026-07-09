Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B5EF3CDBB7
	for <netfilter-devel@vger.kernel.org>; Thu,  9 Jul 2026 06:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783578644; cv=none; b=MIKslxs44EiwEGwQyiCVah79lAGa/sFKkJLIk3l8mRKSs3cwTLxNunjc6oDFSssuwyW5NoMePsPb0vpeWr3D49C8At5/5wyfuHSiQrV+FVwADnlGaFy75CR/Qix4DgzrBrAQLpC0GW+laGnPti6P5teNr0QqBjrR5HwIodGwldM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783578644; c=relaxed/simple;
	bh=7iyGFkX/KVZ2dRRCt8MLBEDmWyxHFZZgQiTUzgZCRpg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=UMFYRy4PUhAJQ0kZgxwKhyXYoVSuDuRHowswRiG3gwgOYUdM5zg41f+LPg+XwR1KGr6B50Tt+ID07wXWUZl80zTlKYe3mkC+cXKIh5oM/d711LmJLADJJ+e0wpFeEkgbQtISfFrYxrsF7yrWNp/XMsUfPQXiXRDdl2doJmJGRuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lZZsMNO/; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lZZsMNO/"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-8484a0b998fso1448577b3a.2
        for <netfilter-devel@vger.kernel.org>; Wed, 08 Jul 2026 23:30:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783578642; x=1784183442; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=3gd7QqaANUrhoi2BRtAEvQ24FdV1dl/9cG/AY/sVUI8=;
        b=lZZsMNO/C6c8nDY3sq5qNnSjYrxMChPpyH5HkVNaFwa1HUrh26K6qlPzNf5Dvp8PTw
         jx3jQw+ARDbqsGxxOQmq60yzdatadXHyy2sUVgpxXT0zQ70H5R++0CxHvgix+MncdjFW
         Kg1ktLhamaTqrv3XZezZUb5R9TiHm3rumqrhKnSj8vj1QkalX4TeNVyQzrBOYwoyBlMv
         iS00G9BlexdMad2wbzW47AAShbCFsl2n2Vg2rYSZN4FxB30y9JTY92q+4AE5bFy/bV5e
         2Ixke3ngtnBGR8sedmL6zIHx64NhsCHkFAq159XCJ44IUq8eqrwhIxOAPG0rB9n/K0Eu
         NWoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783578642; x=1784183442;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3gd7QqaANUrhoi2BRtAEvQ24FdV1dl/9cG/AY/sVUI8=;
        b=NeL+47mdd5KuKdrZr7jHBPaVNCJ5LBGiSNov5BvdJ8ZvbnIGxdRiWcKzJYJCHd4Xlz
         IQajkdmjt//uGHcZBPjBp+TKv9bRk2vGIfyRpJ2R9vSQhSFRKHrX5cG3nXihBHYu6lGv
         IJmREqRixsdjcbXavWo42kTw07X8CIhiheaDHorcvRxxnnRBMESc0B6vp0B5ujMvFdYD
         BXwNQpjFOS7ZA4/s1nMG8SRmQ748PoPm6KvHrFDgIs6Fq/ePfj/DI4R1Z0zFF1xTjQwa
         oRkEKXEpqfB6xT4tGoXj9pSi9s5MpI/jWN8h19cMoDSjzAx3NawzYEqSTF3/JjsvUSme
         i3hA==
X-Forwarded-Encrypted: i=1; AHgh+RpdPgpUWHm+mSOlUe35U5RgBhecY9s+cWJMTYu64IiggrP5lwxpHCmzl80rD+Fu0bsc0MPY7jANDz8Y2g/XDrk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwpJuzaPmzMOwZYd6eXdU2k3O6O4ay5pNnh1EPJ1yjRftCcAM0k
	56TEG6h43p5ENWYtKS/VImk/PKCWw+2Utj+BMFqcJYbXXEfT6BOsnNYkSbt3An2LldwxTw==
X-Gm-Gg: AfdE7ck8LLvZmBYckHrc1Iml6lUeCzsOv/s2iByNVsxL9HE2jwzt5jZFjYLbPvEz3ma
	J6s2u0CwAisL9gv3zyPKNDqyTg+mpjEhicQ5kOAxAKVRU5CiYj4VKghoC5RT9oLOsVMOBD5hNCt
	L6EsOifxUJ3TonfF5zTEbiMB6neacgCwEUFqWJ9T0OtPwqMAQ2oT4kY+Ojj2yoOGtiCf6/cmYLZ
	o3HX+UjHzbmrdZgbHGI3na3X4Yc24eSTh/l3uctpPWukoVCxEJZ4B53UN38qOJOiMQejg994Zhk
	yNuOBi2C0G4aQktKjcBfiOaeGBRSe5DfKjkJlE+Hfmw9So7OXoOxYItA7Lyc/ZYLPTNPz2u1DcV
	roghZ1j/eKWzqVqe5MC610gdTn7PL/GeLH9aYuLXTVTXayEfmzoUICOrSi4NQ3siI2wjM4fChw1
	kCSu/5pvhupJEOd0Rfo+yPSQ==
X-Received: by 2002:a05:6a00:3486:b0:848:2f77:e2dd with SMTP id d2e1a72fcca58-8484392ec4emr5740542b3a.70.1783578641852;
        Wed, 08 Jul 2026 23:30:41 -0700 (PDT)
Received: from c79home.localdomain ([14.127.26.222])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847f6b9e12csm8087708b3a.21.2026.07.08.23.30.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2026 23:30:40 -0700 (PDT)
From: Zhixing Chen <running910@gmail.com>
To: Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Phil Sutter <phil@nwl.cc>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	Zhixing Chen <running910@gmail.com>
Subject: [PATCH nf] netfilter: ip6tables: set hotdrop for malformed extension header matches
Date: Thu,  9 Jul 2026 14:30:12 +0800
Message-Id: <20260709063012.33160-1-running910@gmail.com>
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
present, when the advertised SRH length exceeds the available skb data, or
when SID selector reads fail.

For ipv6header, set hotdrop when the next extension header is not fully
present or when the advertised extension header length exceeds the
available skb data.

Returning false treats the packet as a rule mismatch. Set hotdrop for
these malformed packets so they cannot bypass rules intended to drop
packets with these IPv6 extension headers.

Signed-off-by: Zhixing Chen <running910@gmail.com>
---

This is a follow-up to the previous IPv6 extension header hotdrop fix:
https://lore.kernel.org/netfilter-devel/20260703125709.16493-6-fw@strlen.de/

---
 net/ipv6/netfilter/ip6t_hbh.c        | 21 +++++++++-----
 net/ipv6/netfilter/ip6t_ipv6header.c | 10 +++++--
 net/ipv6/netfilter/ip6t_srh.c        | 42 ++++++++++++++++++++++------
 3 files changed, 54 insertions(+), 19 deletions(-)

diff --git a/net/ipv6/netfilter/ip6t_hbh.c b/net/ipv6/netfilter/ip6t_hbh.c
index 6d1a5d2026a6..a67f7d0fe93f 100644
--- a/net/ipv6/netfilter/ip6t_hbh.c
+++ b/net/ipv6/netfilter/ip6t_hbh.c
@@ -104,8 +104,10 @@ hbh_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 				break;
 			tp = skb_header_pointer(skb, ptr, sizeof(_opttype),
 						&_opttype);
-			if (tp == NULL)
-				break;
+			if (!tp) {
+				par->hotdrop = true;
+				return false;
+			}
 
 			/* Type check */
 			if (*tp != (optinfo->opts[temp] & 0xFF00) >> 8) {
@@ -120,13 +122,17 @@ hbh_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 				u16 spec_len;
 
 				/* length field exists ? */
-				if (hdrlen < 2)
-					break;
+				if (hdrlen < 2) {
+					par->hotdrop = true;
+					return false;
+				}
 				lp = skb_header_pointer(skb, ptr + 1,
 							sizeof(_optlen),
 							&_optlen);
-				if (lp == NULL)
-					break;
+				if (!lp) {
+					par->hotdrop = true;
+					return false;
+				}
 				spec_len = optinfo->opts[temp] & 0x00FF;
 
 				if (spec_len != 0x00FF && spec_len != *lp) {
@@ -147,7 +153,8 @@ hbh_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 			if ((ptr > skb->len - optlen || hdrlen < optlen) &&
 			    temp < optinfo->optsnr - 1) {
 				pr_debug("new pointer is too large!\n");
-				break;
+				par->hotdrop = true;
+				return false;
 			}
 			ptr += optlen;
 			hdrlen -= optlen;
diff --git a/net/ipv6/netfilter/ip6t_ipv6header.c b/net/ipv6/netfilter/ip6t_ipv6header.c
index c52ff929c93b..0568eb99eb1c 100644
--- a/net/ipv6/netfilter/ip6t_ipv6header.c
+++ b/net/ipv6/netfilter/ip6t_ipv6header.c
@@ -53,8 +53,10 @@ ipv6header_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 			break;
 		}
 		/* Is there enough space for the next ext header? */
-		if (len < (int)sizeof(struct ipv6_opt_hdr))
+		if (len < (int)sizeof(struct ipv6_opt_hdr)) {
+			par->hotdrop = true;
 			return false;
+		}
 		/* ESP -> evaluate */
 		if (nexthdr == NEXTHDR_ESP) {
 			temp |= MASK_ESP;
@@ -99,8 +101,10 @@ ipv6header_mt6(const struct sk_buff *skb, struct xt_action_param *par)
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
index db0fd64d8986..33a659b9b0e3 100644
--- a/net/ipv6/netfilter/ip6t_srh.c
+++ b/net/ipv6/netfilter/ip6t_srh.c
@@ -27,16 +27,25 @@ static bool srh_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 	struct ipv6_sr_hdr *srh;
 	struct ipv6_sr_hdr _srh;
 	int hdrlen, srhoff = 0;
+	int err;
 
-	if (ipv6_find_hdr(skb, &srhoff, IPPROTO_ROUTING, NULL, NULL) < 0)
+	err = ipv6_find_hdr(skb, &srhoff, IPPROTO_ROUTING, NULL, NULL);
+	if (err < 0) {
+		if (err != -ENOENT)
+			par->hotdrop = true;
 		return false;
+	}
 	srh = skb_header_pointer(skb, srhoff, sizeof(_srh), &_srh);
-	if (!srh)
+	if (!srh) {
+		par->hotdrop = true;
 		return false;
+	}
 
 	hdrlen = ipv6_optlen(srh);
-	if (skb->len - srhoff < hdrlen)
+	if (skb->len - srhoff < hdrlen) {
+		par->hotdrop = true;
 		return false;
+	}
 
 	if (srh->type != IPV6_SRCRT_TYPE_4)
 		return false;
@@ -121,16 +130,25 @@ static bool srh1_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 	struct in6_addr _psid, _nsid, _lsid;
 	struct ipv6_sr_hdr *srh;
 	struct ipv6_sr_hdr _srh;
+	int err;
 
-	if (ipv6_find_hdr(skb, &srhoff, IPPROTO_ROUTING, NULL, NULL) < 0)
+	err = ipv6_find_hdr(skb, &srhoff, IPPROTO_ROUTING, NULL, NULL);
+	if (err < 0) {
+		if (err != -ENOENT)
+			par->hotdrop = true;
 		return false;
+	}
 	srh = skb_header_pointer(skb, srhoff, sizeof(_srh), &_srh);
-	if (!srh)
+	if (!srh) {
+		par->hotdrop = true;
 		return false;
+	}
 
 	hdrlen = ipv6_optlen(srh);
-	if (skb->len - srhoff < hdrlen)
+	if (skb->len - srhoff < hdrlen) {
+		par->hotdrop = true;
 		return false;
+	}
 
 	if (srh->type != IPV6_SRCRT_TYPE_4)
 		return false;
@@ -206,8 +224,10 @@ static bool srh1_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 		psidoff = srhoff + sizeof(struct ipv6_sr_hdr) +
 			  ((srh->segments_left + 1) * sizeof(struct in6_addr));
 		psid = skb_header_pointer(skb, psidoff, sizeof(_psid), &_psid);
-		if (!psid)
+		if (!psid) {
+			par->hotdrop = true;
 			return false;
+		}
 		if (NF_SRH_INVF(srhinfo, IP6T_SRH_INV_PSID,
 				ipv6_masked_addr_cmp(psid, &srhinfo->psid_msk,
 						     &srhinfo->psid_addr)))
@@ -221,8 +241,10 @@ static bool srh1_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 		nsidoff = srhoff + sizeof(struct ipv6_sr_hdr) +
 			  ((srh->segments_left - 1) * sizeof(struct in6_addr));
 		nsid = skb_header_pointer(skb, nsidoff, sizeof(_nsid), &_nsid);
-		if (!nsid)
+		if (!nsid) {
+			par->hotdrop = true;
 			return false;
+		}
 		if (NF_SRH_INVF(srhinfo, IP6T_SRH_INV_NSID,
 				ipv6_masked_addr_cmp(nsid, &srhinfo->nsid_msk,
 						     &srhinfo->nsid_addr)))
@@ -233,8 +255,10 @@ static bool srh1_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 	if (srhinfo->mt_flags & IP6T_SRH_LSID) {
 		lsidoff = srhoff + sizeof(struct ipv6_sr_hdr);
 		lsid = skb_header_pointer(skb, lsidoff, sizeof(_lsid), &_lsid);
-		if (!lsid)
+		if (!lsid) {
+			par->hotdrop = true;
 			return false;
+		}
 		if (NF_SRH_INVF(srhinfo, IP6T_SRH_INV_LSID,
 				ipv6_masked_addr_cmp(lsid, &srhinfo->lsid_msk,
 						     &srhinfo->lsid_addr)))
-- 
2.34.1

