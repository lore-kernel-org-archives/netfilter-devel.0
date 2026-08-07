Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2CED1C862D
	for <netfilter-devel@vger.kernel.org>; Fri,  7 Aug 2026 08:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786092437; cv=none; b=WiW3CD7BkKUpFq+TY/HNJuZtxRa0DafaHXEZZCKJWlfu/syXhM6P8AsilqHbDbylkcs+yxhICbS0t7kI41rM06jCTRP9gzlL+B6QR7Vuq5wVh/tL+Gfx28T15eB3JPAdO+rsenX7F0Ard6dJbkzJllLI4dmTOVztUCIZf8+2qqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786092437; c=relaxed/simple;
	bh=AtkGfS68R4CE+VBW07mFcJ47CJmhBo//NHpPoJNl0io=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=YOvSGGURqy8neI6PZ1v6cY+aIl4R2ftyalNJ7GIPvGvWraZr/mUc/LcO+c14QYAlvxnmpvuvZVXE8fccmM9CvdyKidsVoGg04ISp+7x4mLEcfeDsZVOzEXQoHxY1tcBlbVxnG2+24O3DIY+wJ3dm10JHLBVbsQSZ4AIlpnooIlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cpSnWwzW; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cpSnWwzW"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2cad8076b01so38049145ad.2
        for <netfilter-devel@vger.kernel.org>; Fri, 07 Aug 2026 01:47:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786092435; x=1786697235; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=9v71NFQZGl5OHxg0sIqHwqfW/RdBnFAtsZoi1rTg4N8=;
        b=cpSnWwzWlRKlu6ym2PX4MV9fw5g6yfvGpoNWcul7NIwyAd/o7AdXo1hec14HEXAsMN
         8mTf8owJiKntODUXaGpU5ncfX76xF+xgrZa6pDvWwivCxyUwDgG50tKlKM3HDF4Mmnef
         yjyyAQCZVXUjlw+erF7zSlZwPyF87upCytspT7kxXrv6OhCm+laPk9K1tquW4cGyjHUN
         tJvlfWmawBXl5+PQJcmkqJoplwcp7JEfQkppkVwmRESeyPMPwjicCAaGP/QPh7GocYPt
         ITt2ThuDGSXG93yPWpiWmZX/jGfsC0y7woEARCuB0sWEvswZNKwH8j9HnfzkwwDjJ/5Z
         aV2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786092435; x=1786697235;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9v71NFQZGl5OHxg0sIqHwqfW/RdBnFAtsZoi1rTg4N8=;
        b=RfQZmfYlBBNLyiP/ONBBbmD7hsezc5ozJDG0qDaHqG91Nw2XcxaoEEaA0BhdU2kFAd
         Ql5r4onC/F/rbMb6/QjHgP3ZIzMXLKuBZQYfJT95AIzO2ySPxXbk5Q2I3c0xxlIsVKDZ
         vrkKByGHjETHfEyEvyqJLx2Wtj/hH0FWMVd947xuhe6x8L4EWzrfy/lKe6VY9I1uim1k
         nCnVH1rpYrBf6bl45VP5vgjp+WkK4N0w/Gaa4SUPkNb4qgkO8iwbJXdtEDq2e40hB1l5
         yhfUALDcqCjfFGplnH+PRQuELTjj2u6zHwRHjyF7pxWOCY9qXGU2dUCGz+LMD8fsT25T
         pweQ==
X-Forwarded-Encrypted: i=1; AHgh+Ro8LuTblQCrwJ8AkOIzcQ+Z9HyX6efbEuV4C3CciWLTTUCkB3IHdLES5qIb1yG5gUptnxKPhgpZfE1WroB9KPY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwybyH/0itgjYmcuwkEbhAzmDsVVGEe/DLSTgeJpv/200tLI4D6
	wL+Lre1ubkzKFm6Z7z4w02lO8RW/BLk5hFUW2WIebSTh+6QxW8roFvOe
X-Gm-Gg: AR+sD13joCISkxQQgtqkltHvhLu8kfUOb6XPN9AVwhYdzWENREPMrafXU7poUbE69zT
	rss8mpPDlysMNVVzvf2JsFGHaQPIlYAORINJvouyhB7m+a2SXgYRhXQacFu0xr7TrYKW9a4Odfa
	mBjEWTHJM8mZt5kziZbPlMW6Wx/StKlr/Ipu08sK5+eSXzMSuPmFNhaIR/U2IfTE7MYDp/Y7fkD
	dejtR3k+X/Hb4LYOsYJPm2YrxpoLSUmfrwXz2bp338zflpjbwbdVoMxZJ5rEX1r42iwVSlpuLfU
	U1KUExbxk8gPIogExP3gS3iVOTM9qKDQinYhSkVpK5bkqiq7qmFlUP/AyTp4QyaKoGj04OBgRkE
	l7H9keRgoRm/cCFfxxgfYBrh0Xqx6lvin1gZHH8N/BJv7jkqdEhf2x0mDafq3ye2IF8HAB/xBqa
	rzFA8ixyVwKsOUA4t4hi26DzTmgL4h2/Aoxe3U5N/OadKsMXVQvzsbi/u8Q1AHaEdlKS9N4/hf
X-Received: by 2002:a17:90b:4f91:b0:37c:6910:5758 with SMTP id 98e67ed59e1d1-3903c542f55mr17402088a91.1.1786092434801;
        Fri, 07 Aug 2026 01:47:14 -0700 (PDT)
Received: from c79ofce.localdomain ([103.165.85.242])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39085dea04bsm4051431a91.8.2026.08.07.01.47.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2026 01:47:13 -0700 (PDT)
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
Subject: [PATCH nf-next v4] netfilter: ip6tables: hotdrop malformed hbh/dst and srh headers
Date: Fri,  7 Aug 2026 16:45:59 +0800
Message-Id: <20260807084559.63276-1-running910@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The hbh/dst and srh matches have paths that return false for malformed
IPv6 extension headers without setting hotdrop.

For hbh/dst, strict option parsing can stop when option data cannot be
read or when the current option length exceeds the available header data.
Treat these packets as malformed and set hotdrop. Apply the boundary check
to the current option regardless of whether the rule asks for more
options, so a malformed last requested option cannot be treated as a
normal match result.

For srh, keep a missing SRH as a normal mismatch, but set hotdrop when
header lookup fails for other reasons, when the SRH fixed header is not
present, when the advertised SRH length exceeds the available skb data,
when segments_left exceeds first_segment, when the SID list implied by
first_segment exceeds the advertised SRH length, or when SID selector
reads fail.

Remove the redundant ipv6header length tracker.

Signed-off-by: Zhixing Chen <running910@gmail.com>
---

Changes in v4:
- Retarget to nf-next.
- Do not turn ipv6header ptr overruns into hotdrop because ipv6header_mt6()
  does not stop at non-first fragments.
- Fix hbh/dst strict option parsing so a malformed last requested option
  also sets hotdrop.

Changes in v3:
- Remove the unused len variable from ipv6header_mt6().
- Validate that the SID list implied by first_segment fits within the
  advertised SRH length in srh1_mt6().

Changes in v2:
- Use hotdrop labels for hbh and srh paths.
- Mark SRH packets with segments_left greater than first_segment for
  hotdrop.
- Drop the redundant ipv6header length check before skb_header_pointer().

v3: https://lore.kernel.org/netdev/20260724110111.18783-1-running910@gmail.com/T 
v2: https://lore.kernel.org/netdev/20260714032124.7042-1-running910@gmail.com/T/ 
v1: https://lore.kernel.org/netdev/20260709063012.33160-1-running910@gmail.com/T/ 

---
 net/ipv6/netfilter/ip6t_hbh.c        | 33 +++++++++++----------
 net/ipv6/netfilter/ip6t_ipv6header.c |  7 -----
 net/ipv6/netfilter/ip6t_srh.c        | 44 +++++++++++++++++++++-------
 3 files changed, 50 insertions(+), 34 deletions(-)

diff --git a/net/ipv6/netfilter/ip6t_hbh.c b/net/ipv6/netfilter/ip6t_hbh.c
index 6d1a5d2026a6..9f04b4d8f16f 100644
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
-		/* Packet smaller than it's length field */
-		par->hotdrop = true;
-		return false;
+		/* Packet smaller than its length field */
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
@@ -144,10 +141,10 @@ hbh_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 			/* Step to the next */
 			pr_debug("len%04X\n", optlen);
 
-			if ((ptr > skb->len - optlen || hdrlen < optlen) &&
-			    temp < optinfo->optsnr - 1) {
+			if (ptr > skb->len || optlen > skb->len - ptr ||
+			    hdrlen < optlen) {
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
index c52ff929c93b..aef8f69da7fb 100644
--- a/net/ipv6/netfilter/ip6t_ipv6header.c
+++ b/net/ipv6/netfilter/ip6t_ipv6header.c
@@ -28,7 +28,6 @@ ipv6header_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct ip6t_ipv6header_info *info = par->matchinfo;
 	unsigned int temp;
-	int len;
 	u8 nexthdr;
 	unsigned int ptr;
 
@@ -38,8 +37,6 @@ ipv6header_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 	nexthdr = ipv6_hdr(skb)->nexthdr;
 	/* pointer to the 1st exthdr */
 	ptr = sizeof(struct ipv6hdr);
-	/* available length */
-	len = skb->len - ptr;
 	temp = 0;
 
 	while (nf_ip6_ext_hdr(nexthdr)) {
@@ -52,9 +49,6 @@ ipv6header_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 			temp |= MASK_NONE;
 			break;
 		}
-		/* Is there enough space for the next ext header? */
-		if (len < (int)sizeof(struct ipv6_opt_hdr))
-			return false;
 		/* ESP -> evaluate */
 		if (nexthdr == NEXTHDR_ESP) {
 			temp |= MASK_ESP;
@@ -97,7 +91,6 @@ ipv6header_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 		}
 
 		nexthdr = hp->nexthdr;
-		len -= hdrlen;
 		ptr += hdrlen;
 		if (ptr > skb->len)
 			break;
diff --git a/net/ipv6/netfilter/ip6t_srh.c b/net/ipv6/netfilter/ip6t_srh.c
index db0fd64d8986..6fcc40102fe3 100644
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
@@ -121,22 +130,31 @@ static bool srh1_mt6(const struct sk_buff *skb, struct xt_action_param *par)
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
 
+	if (sizeof(*srh) +
+	    ((srh->first_segment + 1) * sizeof(struct in6_addr)) > hdrlen)
+		goto hotdrop;
+
 	if (srh->segments_left > srh->first_segment)
-		return false;
+		goto hotdrop;
 
 	/* Next Header matching */
 	if (srhinfo->mt_flags & IP6T_SRH_NEXTHDR)
@@ -207,7 +225,7 @@ static bool srh1_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 			  ((srh->segments_left + 1) * sizeof(struct in6_addr));
 		psid = skb_header_pointer(skb, psidoff, sizeof(_psid), &_psid);
 		if (!psid)
-			return false;
+			goto hotdrop;
 		if (NF_SRH_INVF(srhinfo, IP6T_SRH_INV_PSID,
 				ipv6_masked_addr_cmp(psid, &srhinfo->psid_msk,
 						     &srhinfo->psid_addr)))
@@ -222,7 +240,7 @@ static bool srh1_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 			  ((srh->segments_left - 1) * sizeof(struct in6_addr));
 		nsid = skb_header_pointer(skb, nsidoff, sizeof(_nsid), &_nsid);
 		if (!nsid)
-			return false;
+			goto hotdrop;
 		if (NF_SRH_INVF(srhinfo, IP6T_SRH_INV_NSID,
 				ipv6_masked_addr_cmp(nsid, &srhinfo->nsid_msk,
 						     &srhinfo->nsid_addr)))
@@ -234,13 +252,17 @@ static bool srh1_mt6(const struct sk_buff *skb, struct xt_action_param *par)
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

base-commit: a50eba1e778ad4da5b6f9ddbbf57dabbea59bc05
-- 
2.34.1

